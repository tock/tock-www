---
title: Rust's Mutex, Atomics and UnsafeCell – Spooky Action at a Distance?
subtitle:
authors: lschuermann
excerpt: >
  In this post we explore how Rust's Atomic, Mutex, and UnsafeCell types
  interact with its type system and concepts of references and aliasing ⊕
  mutability. We do so by looking at how the AtomicUsize and Mutex types are
  implemented, how violating Rust's assumptions can lead to incorrect
  optimizations by the compiler, and the surprising global impact of
  synchronization primitives.
canonical_url: https://leon.schuermann.io/blog/2024-08-07_rust-mutex-atomics-unsafecell_spooky-action-at-a-distance.html
---

_This article is cross-posted from [Leon's blog](https://leon.schuermann.io/blog/2024-08-07_rust-mutex-atomics-unsafecell_spooky-action-at-a-distance.html)_

A defining feature of Rust is its concept of *aliasing ⊕ mutability*. This rule
governs that at any time a value may either have multiple *immutable* shared
references, or a single *mutable* unique reference, and never both. While this
greatly helps in producing fast, efficient and correct code, it can be
limiting. To this end, Rust also features types that bend these rules, like
`Mutex`, `RwLock`, `Cell`, `RefCell`, and the ominous `UnsafeCell` types. In
this post we explore how these types interact with Rust's type system and
concepts of *references* and *aliasing ⊕ mutability*. We do so by looking at how
the `AtomicUsize` and `Mutex` types are implemented, how violating Rust's
assumptions can lead to incorrect optimizations by the compiler, and the
surprising *global* impact of synchronization primitives.

# Atomics From Scratch

William Henderson's blog features a great article on how to [implement Rust's
atomic types](https://whenderson.dev/blog/implementing-atomics-in-rust/) (and
[ultimately even Mutexes](https://whenderson.dev/blog/rust-mutexes/)) from
scratch. I encourage reading the full article, but will repeat the essential
parts of the code here (for an AMD64 CPU) as well:

```rust
 1  pub struct AtomicUsize {
 2      inner: UnsafeCell<usize>,
 3  }
 4
 5  unsafe impl Send for AtomicUsize {}
 6  unsafe impl Sync for AtomicUsize {}
 7
 8  impl AtomicUsize {
 9      pub const fn new(v: usize) -> Self {
10          Self {
11              inner: UnsafeCell::new(v),
12          }
13      }
14      pub fn load(&self) -> usize {
15          unsafe { *self.inner.get() }
16      }
17      pub fn store(&self, v: usize) {
18          unsafe {
19              asm!(
20                  "lock; xchg [{address}], {v}",
21                  address = in(reg) self.inner.get(),
22                  v = in(reg) v
23              );
24          }
25      }
26  }
```

We start by defining our `AtomicUsize` type to be a wrapper around an
`UnsafeCell<usize>`. This container type allows us to modify its contents even
if we hold just a shared reference to it (a concept known as *interior
mutability*). As put in William Henderson's post:

> The `usize` needs to be within an `UnsafeCell` to effectively opt out of
> Rust’s borrow checker [&#x2026;]

Whereas `UnsafeCell` is the underlying primitive type that causes the Rust
compiler to provide these semantics for the objects contained therein, it is
more commonly used in safe wrappers such as `Cell` or `RefCell`.

It is important to note that despite allowing interior mutability, `UnsafeCell`
does not perform any synchronization on its own—one of the key distinguishing
features of other types like `Mutex`. This restriction is visible by the fact
that `UnsafeCell` does not implement the `Sync` trait. Without this trait, Rust
will not allow us to share a reference to this type between threads, and thus
guarantees that `UnsafeCell` will never have unsynchronized accesses.

However, this property is problematic for our `AtomicUsize` type whose entire
purpose is to enable reading and writing of a shared value among multiple
threads! For this, the documentation of `UnsafeCell` provides us with an escape
hatch:

> At all times, you must avoid data races. If multiple threads have access to
> the same UnsafeCell, then any writes must have a proper happens-before
> relation to all other accesses (or use atomics).

OK, so to safely use an `UnsafeCell` between threads we will need to perform
synchronization ourselves (establish a *happens-before relation*) or use
atomics. As the above is building an atomic usize primitive, we should thus be
safe to tell the Rust compiler that our own `AtomicUsize` type is indeed both
`Send` (can be moved between threads) and `Sync` (can be concurrently used from
multiple threads). Because the Rust compiler cannot check whether this is
actually the case, implementing these traits are `unsafe` operations.

The above example makes use of the fact that, in AMD64, a read-lock is not
required when all operations that modify a shared value use locking
instructions. As such, we can simply dereference the value stored in the
`UnsafeCell`:

> Since our implementations of all the methods which change the value will be
> atomic, the CPU won’t let us observe the value in the middle of an
> operation. Therefore, to load the value, we can simply return the current
> value of the UnsafeCell.

For writing, William Henderson's version uses an AMD64 inline assembly
instruction that performs a locking store operation.

# Optimized to the Breaking Point

With our `AtomicUsize` implemented, let's write a basic reader / writer test
case: we spawn a thread that spin-waits until the shared atomic assumes a
non-zero value, and another that writes a `1` to it after a short delay ([Rust
playground](https://play.rust-lang.org/?version=stable&mode=release&edition=2021&gist=062364916552c3debff119c59e982dc0)).

```rust
 1  fn reader(a: &AtomicUsize) {
 2      while a.load() == 0 {
 3          // Wait until `a` contains a non-zero value.
 4      }
 5  }
 6
 7  fn writer(a: &AtomicUsize) {
 8      a.store(1);
 9  }
10
11  fn main() {
12      let shared_atomic = Arc::new(AtomicUsize::new(0));
13
14      // Start up the reader thread:
15      let shared_atomic_clone = shared_atomic.clone();
16      let join_handle = std::thread::spawn(
17          move || reader(&shared_atomic_clone));
18
19      // Wait for 50ms:
20      std::thread::sleep(Duration::from_millis(50));
21
22      // Write a non-zero value to the shared atomic:
23      writer(&shared_atomic);
24
25      // Wait for the reader thread to exit:
26      join_handle.join().unwrap()
27  }
```

When we run this example with the above `AtomicUsize` implementation in a
*debug* build, it runs for about 50ms—as expected. However, once we turn on more
aggressive compiler optimizations by building in *release* mode, the program
does not quit and fully consumes one CPU core &#x2026; hm, what's going on here?

If we look at the assembly of our `fn reader` (by selecting "Show Assembly" in
[this Rust
playground](https://play.rust-lang.org/?version=stable&mode=release&edition=2021&gist=08e7afa7c1a259cc3170c953c5736720))
we see that Rust generates the following machine code:

```asm
1  fn_reader:
2          cmpq  $0, (%rdi)
3          je    .LBB24_1
4          retq
5
6  .LBB24_1:
7          jmp   .LBB24_1
```

Even though our source code calls `a.load()` for each loop iteration, it seems
like the generated function only reads the `usize` value (at an adress in
`%rdi`) once and, if it happens to be equal to `0`, jumps into an infinite loop
at symbol `.LBB24_1`. That's not at all what we want!

It seems that the Rust compiler determines that it should be enough to read the
value returned by `a.load()` once, and then assumes that it may never change. If
it was `0` when entering this function, because the function never modifies it,
the compiler thus assumes that it will always stay at this value and never
return from the `while` loop. This seems quite counter-intuitive given that the
entire purpose behind `UnsafeCell` is to *allow* interior mutability. Thus, Rust
should need to expect that its underlying value changes even though we only hold
an immutable (`&`) reference to it.

We can observe similar behavior with the following minimal example
([Playground](https://play.rust-lang.org/?version=stable&mode=release&edition=2021&gist=c19065067ab8ce6631858069beb0a963)). Here
we use Rust's `Cell` type instead of `UnsafeCell` for convenience; `Cell` is
nothing more than a safe wrapper around `UnsafeCell`.

```rust
1  pub fn cell_test(a: &Cell<usize>) -> bool {
2      let first = a.get();
3      let second = a.get();
4      first == second
5  }
```

Looking at the generated assembly, Rust turns this function into a simple
"return true":

```asm
1  fn_cell_test:
2          movb     1, %al
3          retq
```

# `UnsafeCell` Revisited

With the above behavior, one might wonder what an `UnsafeCell` is actually
useful for? We cannot—by default—share it between threads and clearly its
concepts of *interior mutability* do not extend to give any guarantees in the
face of *concurrent* accesses to its memory. So what's the point? To illustrate
this, we can extend the above example like so:

```rust
 1  use std::cell::Cell;
 2
 3  pub fn cell_test(a: &Cell<usize>, writer: &dyn Fn()) -> bool {
 4      let first = a.get();
 5      writer();
 6      let second = a.get();
 7      first == second
 8  }
 9
10  pub fn main() {
11      let a = Cell::new(0);
12      println!(
13          "Cell contents identical? {:?}",
14          cell_test(&a, &|| { a.set(1) })
15      );
16  }
```

We extend our `fn cell_test` to take an additional `writer` function reference
argument. This `writer` function is then called in between our first and second
read of the `Cell<usize>`.

After this change, we can observe that Rust instead generates the following
assembly<sup><a id="fnr.1" class="footref" href="#fn.1"
role="doc-backlink">1</a></sup>
([Playground](https://play.rust-lang.org/?version=stable&mode=release&edition=2021&gist=71cd229c9306fc2e8ec56ff0cbac9cbc)):

```asm
 1  fn_cell_test:
 2          pushq %r14
 3          pushq %rbx
 4          pushq %rax
 5          movq  %rdi, %rbx
 6          movq  (%rdi), %r14
 7          movq  %rsi, %rdi
 8          callq *40(%rdx)
 9          cmpq  (%rbx), %r14
10          sete  %al
11          addq  $8, %rsp
12          popq  %rbx
13          popq  %r14
14          retq
```

There's a lot more happening here. The important bits are:

- on line 5, we copy the pointer to our `Cell<usize>`, initially passed in
  register `%rdi`, into `%rbx`,
- on line 6, we read the contents of the `Cell<usize>` into register `%r14`,
- on line 8, we invoke the `writer` function,
- and finally, on lines 9 and 10 we compare the current contents of the
  `Cell<usize>` to the value we read on line 6, and set the return value
  (`%al`) to `true` (`$1`) or `false` (`$0`) using the `sete` instruction.

This makes sense: we're handing out two shared references to the `Cell<usize>`,
one passed to `fn cell_test` directly, and one embedded in the closure
constructed on line 14 of `fn main`. When we invoke `writer` on line 5, because
it also holds to a reference to this `Cell`, we must assume that its contents
have been changed and thus re-read it.

We can force the compiler to generate quite similar assembly when we replace the
invocation of `writer` with a call to `std::hint::black_box`:

```rust
1  pub fn cell_test(a: &Cell<usize>) -> bool {
2      let first = a.get();
3      std::hint::black_box(a);
4      let second = a.get();
5      first == second
6  }
```

From [its
documentation](https://doc.rust-lang.org/stable/std/hint/fn.black_box.html),
`std::hint::black_box` is

> [an] identity function that hints to the compiler to be maximally pessimistic
> about what `black_box` could do.

In this case, one of the possible effects that the compiler assumes `black_box`
to have is performing an `a.set(1)` operation. Hence it makes sense that
`black_box` would force the compiler to re-read the `Cell`'s contents on the
second call to `a.get()`.

However, things get even more interesting when we replace this with a call to
`std::hint::black_box(())`. In this case, the Rust compiler will be *maximally
pessimistic* about what `black_box` could do to its function argument, an
instance of the unit type. Its documentation doesn't say anything about what
could happen to other variables such as `a`. Yet, when we compile the following
code&#x2026;

```rust
    1  pub fn cell_test(a: &Cell<usize>) -> bool {
    2      let first = a.get();
    3      std::hint::black_box(());
    4      let second = a.get();
    5      first == second
    6  }
```

&#x2026;we see that the `Cell` is indeed read *twice*. Curious!

```asm
    1  fn_cell_test:
    2          movq (%rdi), %rax
    3          cmpq (%rdi), %rax
    4          sete %al
    5          retq
```

From these findings we can derive two properties of `UnsafeCell`:

1. For part of the code where the Rust compiler assumes that it has *full
   visibility* over all operations carried out on all references that are
   accessible, it may make assumptions about an `UnsafeCell`'s contents not
   changing.

2. Across any code path where Rust does not have this degree of visibility (e.g.,
   by calling into an opaque function, foreign function, or invoking a
   `black_box`), it instead assumes that an `UnsafeCell`'s contents may have
   changed.

It is important to note that Rust generally assumes that an `UnsafeCell` is not
shared across multiple threads (apart from the *happens-before* condition
mentioned above). Thus, even though multiple references may exist for any
`UnsafeCell` at any time, as long as the compiler determines that the *current
thread* does not modify a particular reference, and no other code is invoked
that could modify any other reference to this `UnsafeCell`, its contents will
not change.

This explains the behavior of our `AtomicUsize` example. As part of the load
function, we're simply accessing and dereferencing the contents of the inner
`UnsafeCell`. Rust does not assume that this value is shared with any other
concurrent thread, and by having full visibility of the operations carried out
within the `reader` thread, it determines that its value may never be modified
within this function; hence reading its value once ought to be sufficient.


# Concurrency and `UnsafeCell`

This raises the question: given that `UnsafeCell` does not deliver our desired
semantics, how are `AtomicUsize`, `Mutex`, and friends actually implemented in
Rust? Well &#x2026; using `UnsafeCell`!

Looking at the `core::atomic` module with macros expanded, the implementation of
`AtomicUsize` looks roughly like this:

```rust
1  pub struct AtomicUsize {
2      v: UnsafeCell<usize>,
3  }
```

This seems virtually identical to how our own `AtomicUsize` is
implemented. However, there is a crucial difference when we look at the
`AtomicUsize::load` function:

```rust
 1  impl AtomicUsize{
 2      pub fn load(&self, order: Ordering) -> usize {
 3          unsafe { atomic_load(self.v.get(), order) }
 4      }
 5      ...
 6  }
 7
 8  #[inline]
 9  unsafe fn atomic_load<T: Copy>(dst: *const T, order: Ordering) -> T {
10      match order {
11          Relaxed => intrinsics::atomic_load_relaxed(dst),
12          Acquire => intrinsics::atomic_load_acquire(dst),
13          ...
14      }
15  }
```

In addition to the ability to specify a desired *ordering* or *consistency
model*, this implementation uses *compiler intrinsics* to generate the
corresponding atomic operations. This means that the compiler will automatically
generate the appropriate instructions for the target architecture to perform
these atomic operations. These intrinsics can also enforce other high-level
constraints, such as on the order of operations. In this case, the `Relaxed`
ordering model corresponds to our custom implementation of the `AtomicUsize`
type.

Here is a [Rust
playground](https://play.rust-lang.org/?version=stable&mode=release&edition=2021&gist=5a9b74d7d58d8e46fcd57f64a44a4c73)
that uses the standard library's `AtomicUsize` type with `Ordering::Relaxed`
instead. Looking at the generated assembly, we can observe that Rust turns both
the `load` and `store` operations into simple reads and writes with the `movq`
instruction:

```asm
1  fn_reader:
2          movq (%rdi), %rax
3          testq    %rax, %rax
4          je   fn_reader
5          retq
6
7  fn_writer:
8          movq $1, (%rdi)
9          retq
```

Superficially, it seems that our implementation and the Rust standard library's
should thus be functionally equivalent! We're generating essentially the same
machine code, and rely on the target-architecture specific guarantee that
naturally aligned load and store operations of `usize` values are always atomic.

However, there is another crucial difference: the generated assembly re-reads
the `UnsafeCell`'s value in each loop iteration. Thus, this `AtomicUsize`
implementation generates *actually correct* code—despite producing effectively
equivalent instructions otherwise!  Now seems like a good time to revisit the
`UnsafeCell`'s documentation concerning concurrency:

> At all times, you must avoid data races. If multiple threads have access to
> the same UnsafeCell, then any writes must have a proper happens-before
> relation to all other accesses (or use atomics).

It seems that the phrasing here is unfortunate in two regards:

- When we don't have a proper *happens-before relation* (we'll get to that
  later), we need to use atomic operations for concurrent accesses on the
  `UnsafeCell`'s memory instead. However, clearly these atomic operations must
  *not only* be used for *writes*, but also for *reads*!
- It is not only important that the generated machine code instructions are
  atomic (as is the case with our custom `AtomicUsize`). We *also* need to
  communicate to the Rust compiler that these instructions are *used as atomic
  operations*. Somehow, something magic about the `atomic_load_` intrinsics
  causes the compiler to not assume that the memory behind this reference cannot
  change.

We can confirm the latter by looking at the LLVM intermediate representation
(IR) that the Rust compiler generates. This format is then used by the LLVM
compiler backend to generate optimized machine code for various
architectures. However, for those optimizations to be correct, the Rust compiler
has to encode a bunch of information on program behavior into this LLVM IR.

Rust generates the following slightly cryptic LLVM IR for `fn reader` using our
custom `AtomicUsize`:

```llvm
 1  ; Function Attrs: nofree noinline norecurse nosync nounwind nonlazybind memory(argmem: read) uwtable
 2  define dso_local void @fn_reader(ptr nocapture noundef nonnull readonly align 8 %a) unnamed_addr #4 {
 3  start:
 4    %_2.pr = load i64, ptr %a, align 8
 5    %0 = icmp eq i64 %_2.pr, 0
 6    br i1 %0, label %bb1, label %bb3
 7
 8  bb1:                                              ; preds = %start, %bb1
 9    br label %bb1
10
11  bb3:                                              ; preds = %start
12    ret void
13  }
```

Let's see what changes if we swap this out for the standard library's
`AtomicUsize`:

```llvm
 1  ; Function Attrs: nofree noinline norecurse nounwind nonlazybind memory(argmem: readwrite) uwtable
 2  define dso_local void @fn_reader(ptr nocapture noundef nonnull readonly align 8 %a) unnamed_addr #4 {
 3  start:
 4    br label %bb1
 5
 6  bb1:                                              ; preds = %bb1, %start
 7    %0 = load atomic i64, ptr %a monotonic, align 8
 8    %1 = icmp eq i64 %0, 0
 9    br i1 %1, label %bb1, label %bb3
10
11  bb3:                                              ; preds = %bb1
12    ret void
13  }
```

The changes on line 4 and 7 respectively make sense: instead of a `load`
instruction, Rust generates a `load atomic` LLVM instruction. The added
`monotonic` here is the desired consistency model, where `monotonic` corresponds
to Rust's `Ordering::Relaxed`.

The branching behavior also changes: whereas in the former version the label
`bb1:` forms a simple infinite loop, the latter performs a read every time it
jumps back to `bb1:`.

However, the addition of the `nosync` function attribute for our custom
`AtomicUsize` version is perhaps most telling. Here's what [LLVM's language
reference](https://llvm.org/docs/LangRef.html) says about this attribute:

> This function attribute indicates that the function does not communicate
> (synchronize) with another thread through memory or other well-defined
> means. Synchronization is considered possible in the presence of atomic
> accesses that enforce an order, thus not “unordered” and “monotonic”, volatile
> accesses, as well as convergent function calls. [&#x2026;]
>
> If a nosync function does ever synchronize with another thread, the behavior
> is undefined.

This means that Rust compiler intrinsics such as
`intrinsics::atomic_load_relaxed` implicitly tell the compiler that code may use
these atomic operations to synchronize with other concurrent code. Without these
operations, Rust simply assumes that variables are not concurrently modified by
other code and is thus allowed to reason about them as if they aren't shared
with other threads at all. Ultimately, this is safe as `UnsafeCell` is not
`Sync`—by default, it cannot be shared between threads. And our custom
`AtomicUsize` is *unsound*, as we promise to the compiler that `AtomicUsize` is
safe to share between threads, but do not adequately instruct the compiler to
synchronize all accesses to underlying memory. This is regardless of whether or
not the generated machine code uses atomic instructions.

# Spooky Action at a Distance?

Finally, let's look at how `Mutex` is implemented on top of `UnsafeCell`. The
`Mutex` type in the standard library is implemented based on an `UnsafeCell` and
a platform-specific mutex locking mechanism (we can ignore `poison` for now):

```rust
1  pub struct Mutex<T: ?Sized> {
2      inner: sys::Mutex,
3      poison: poison::Flag,
4      data: UnsafeCell<T>,
5  }
```

Here, `sys::Mutex` is platform specific, and happens to use the futex
implementation on Linux:

```rust
1  // std::sys::sync::mutex::futex::Mutex
2  pub struct Mutex {
3      futex: AtomicU32,
4  }
```

The atomic integer type within this `futex::Mutex` also varies between systems
and happens to be `AtomicU32` for UNIX. Recall from the `AtomicUsize` example
above that these atomic types in turn are just another wrapper around an
`UnsafeCell`. *It's `UnsafeCell` all the way down!*

To get access to the contents of a mutex we need to lock it. The `Mutex::lock`
function is implemented as follows:

```rust
1  pub fn lock(&self) -> LockResult<MutexGuard<'_, T>> {
2      unsafe {
3          self.inner.lock();
4          MutexGuard::new(self)
5      }
6  }
```

After calling `lock()` on the platform-specific inner `Mutex` struct, the user
is provided a `MutexGuard` object. This `MutexGuard` is simply a wrapper that
retains a reference to the original `Mutex`. Notably, it provides *entirely
unsynchronized access* to the underlying data (which is simply contained in a
`UnsafeCell`):

```rust
1  impl<T: ?Sized> Deref for MutexGuard<'_, T> {
2      type Target = T;
3
4      fn deref(&self) -> &T {
5          unsafe { &*self.lock.data.get() }
6      }
7  }
```

This function looks a lot like our custom `AtomicUsize::load` implementation. In
fact, what happens here is quite similar to this first example: a reference to
an `UnsafeCell` is shared between threads, and accesses to the `UnsafeCell`'s
contents do not use any special intrinsics or atomic operations. So &#x2026;
this surely isn't sound in practice?!

Of course, Rust's `Mutex` implementation is correct. To understand why, we need
to look into the implementation of the `inner.lock()` method. Here's the
implementation of `futex::Mutex::lock`:

```rust
1  pub fn lock(&self) {
2      if self.futex.compare_exchange(UNLOCKED, LOCKED, Acquire, Relaxed).is_err() {
3          self.lock_contended();
4      }
5  }
```

Essentially, the `futex` implementation uses an atomic integer shared between
threads to record the current lock state of the mutex. When attempting to lock
the mutex, it uses a *compare-exchange* operation to atomically write a value of
`1` (*locked*) into this integer, if any only if the current value of the atomic
integer currently contains a value of `0` (*unlocked*). If the mutex is
currently locked, it asks the operating system to inform it when the lock is
free again (`self.lock_contended()`). See [this excellent
post](https://eli.thegreenplace.net/2018/basics-of-futexes/) by Eli Bendersky
for more context on `futex`.

Unfortunately, the implementation of `AtomicU32::compare_exchange` (as invoked
on `self.futex`) is too complex to fully depict here. However, ultimately this
function ends up calling into the following helper function:

```rust
 1  unsafe fn atomic_compare_exchange<T: Copy>(
 2      dst: *mut T,
 3      old: T,
 4      new: T,
 5      success: Ordering,
 6      failure: Ordering,
 7  ) -> Result<T, T> {
 8      let (val, ok) = unsafe {
 9          match (success, failure) {
10              (Relaxed, Relaxed) => {
11                  intrinsics::atomic_cxchg_relaxed_relaxed(dst, old, new)
12              }
13              (Relaxed, Acquire) => {
14                  intrinsics::atomic_cxchg_relaxed_acquire(dst, old, new)
15              }
16              ...
```

The implementation here again uses compiler intrinsics to generate the actual
underlying machine code. By compiling a simplified version of the above
([Playground](https://play.rust-lang.org/?version=stable&mode=release&edition=2021&gist=ec5d5af6ea6a25ebef67e40914af67a6)),
we can confirm that these intrinsics generate corresponding `lock cmpxchgb`
instructions *before* the value stored in the `UnsafeCell` is accessed:

```asm
 1  fn_reader:
 2          movb    $1, %cl
 3  .LBB24_1:
 4          xorl    %eax, %eax
 5          lock cmpxchgb %cl, 8(%rdi)
 6          jne .LBB24_1
 7          cmpq    $0, (%rdi)
 8          movb    $0, 8(%rdi)
 9          je  .LBB24_1
10          retq
```

Thus, if used correctly, a `compare_exchange` operation seems to be sufficient
to synchronize accesses to a Rust `UnsafeCell` across threads.

&#x2026;But wait! Our Mutex holds not one, but **two** `UnsafeCell`s
internally. And we only used a `compare_exchange` on *one* of the `UnsafeCell`s,
namely the one holding information on whether the `Mutex` is locked or not. The
other `UnsafeCell` holding the actual data that the mutex is supposed to be
synchronized never has any atomic or locking instructions used on it. In fact,
we're <span class="underline">still</span> using the exact some problematic code
snippet (`*self.inner.get()`) that led to problems with our `AtomicUsize` in the
first place!

What we're observing here is that **a local operation performed on *one* value
has implicit impact on how the compiler treats assumptions around *another*,
completely independent value**. I think that this can be quite surprising and
unintuitive; you might call it "spooky action at a distance".

Indeed, the `atomic_cxchg` compiler intrinsic again does more than meets the
eye: in addition to generating the appropriate atomic machine instruction(s), it
can also establish an *ordering*, or *happens-before relation* of other program
operations. For example, when performing an atomic load operation with an
`Acquire` ordering, the program is granted the following guarantee, [per Rust's
documentation](https://doc.rust-lang.org/stable/std/sync/atomic/enum.Ordering.html#variant.Acquire):

> When coupled with a load, if the loaded value was written by a store operation
> with `Release` (or stronger) ordering, then all subsequent operations become
> ordered after that store. In particular, all subsequent loads will see data
> written before the store.

It is important to understand that these ordering requirements can not only
influence the types of atomic machine instructions ultimately executed by the
hardware. They can also influence other compiler assumptions and program
optimizations, and in particular, limit the flexibility that a compiler has to
re-order or elide operations that access memory.

Revisiting the example of our `Mutex` implementation
([Playground](https://play.rust-lang.org/?version=stable&mode=release&edition=2021&gist=ec5d5af6ea6a25ebef67e40914af67a6)),
there are two basic guarantees we need to maintain:

1.  We must never give out concurrent access to the `data` field. We do this by
    acquiring a unique lock with a shared atomic value.
2.  By the next time a thread acquires a lock on the `Mutex`, all changes made
    by the previous holder of the lock must be visible in this new thread.

And memory ordering specifications help us achieve this second goal. In
practice, when we load an atomic value with `Ordering::Acquire`, we **prohibit**
the compiler to *move reads* on variables that *could be* shared with other
threads to *before* this operation. As hinted at by the Rust documentation, this
is not enough on its own though: the compiler would still be able to move writes
beyond the point where the mutex is unlocked by the previous holder of the
lock. These writes would thus not necessarily be visible to the new lock holder,
infringing on our guarantees. For this reason, we release the lock by performing
another atomic operation, this time with `Release` ordering—preventing this
exact optimization. So long as these atomic operations are performed in tandem
on the same atomic value, the compiler will provide us these guarantees for
**all**, global variables that may potentially be shared with other threads.


# Conclusion

Concurrency and synchronization are tricky subjects on their own. As we have
seen above, things get even more nuanced when we throw Rust's concepts around
borrowing, references, and its compiler optimizations into the mix. While many
of these basic concepts were familiar to me from both practical experience and
theoretical computer science lectures, seeing how they play in to the actual
implementation of concurrency primitives in a high-level language such as Rust
is still interesting (and at times surprising). I hope that this post can
demystify some of the *"magic"* behavior and optimizations you may observe
around these constructs.

One of those particularly nebulous constructs to me has always been
`UnsafeCell`: *sure, it "opts out" of the Rust borrow checker, but what other
effects does it have?* *We need to "avoid data races", but how to do so
exactly?* Reasoning about this is hard, in part because we need to consider both
Rust's high-level language invariants, low-level compiler optimization effects,
<span class="underline">and</span> their interactions. Some slightly clearer
language in `UnsafeCell`'s documentation could help a great amount here. For
instance, a "happens-before" relation is well-defined by LLVM, but there is no
clear documentation on which Rust compiler intrinsics establish it.

While they make sense when thinking about, something particularly surprising are
the non-local *"spooky"* effects that certain compiler intrinsics have on other
program behavior. Rust usually requires developers to think <span
class="underline">locally</span> (*"is this reference still alive here?"*  or
*"have this variable's contents been moved?"*). Instead, these intrinsics have
*implicit*, *global* effects on program behavior after compiler optimizations,
and these effects do not manifest in Rust's type system at all.


# Aside: What About `VolatileCell`?

Next to these concurrency primitives that Rust ships, some users decide to
develop their own. There is
[`parking_lot`](https://crates.io/crates/parking_lot), a crate with more
efficient implementations of synchronization primitives. If you want to avoid
using locks at all, the [`lockfree`](https://crates.io/crates/lockfree) crate
might be interesting to you. And one of those special types that is popular
among embedded developers is `VolatileCell` (like in
[`vcell`](https://docs.rs/vcell/latest/vcell/), or [its Tock
equivalent](https://docs.tockos.org/kernel/utilities/cells/struct.volatilecell)).
In this section, we will try to apply some of the concepts learned above to this
construct. Note that while much of the content of this section is trying to
reason about the safety of `VolatileCell`, ****I do not claim for any of this to
be authoritative information****. These are mostly just notes I wrote down while
reasoning about this myself.

Embedded systems or bare-metal code commonly operate over memory that is not
backed by RAM in the conventional sense. Instead, these memory address represent
registers that are provided by peripherals, so-called "Memory Mapped I/O"
(MMIO).

In general, these peripherals run in parallel to the CPU—thus, it may be
reasonable to effectively model them to be separate threads in your system. They
"share" certain MMIO memory addresses with your program and may, at times, even
be able to write to arbitrary regular program memory too. Similar to threads,
they should follow a contract for *when* it is safe to read from or write to
certain memory.

However, despite behaving similar to a separate thread, these devices can differ
in one significant regard: memory accesses (that is, both read or write
operations) may also have arbitrary, device-specific side effects. A common
example is that of a serial console (UART) controller. These devices feature
internal queues that hold on to a limited amount of received bytes, which are
later read by the CPU. While a separate thread might expose this as, e.g., a
ring-buffer protected by a Mutex, such MMIO peripherals can implement a more
efficient, lock-free way of exposing this information. Following example of a
read-queue implemented within a serial console controller, it may expose the
current queue's head element for every read to a specific queue register, but on
each read *also* immediately discard (*dequeue*) this head element.

When paired with compiler optimizations as we've seen above, this can be
problematic. The compiler makes many assumptions on how memory will behave,
which can lead it to elide certain accesses, reorder them, or even insert
spurious accesses when it believes this to be safe. These peripherals, though,
don't share the compilers understanding around memory behavior. Thus, an
optimizing compiler can translate a driver that correctly implements a device's
hardware contract into something incorrect, or even dangerous (e.g., when a
peripheral can override program memory).

To avoid these issues, Rust provides *volatile* memory operations (i.e.,
[reads](https://doc.rust-lang.org/stable/std/ptr/fn.read_volatile.html) and
[writes](https://doc.rust-lang.org/stable/std/ptr/fn.write_volatile.html)). Volatile
operations provide some unique guarantees:

> Volatile operations are intended to act on I/O memory, and are guaranteed to
> not be elided or reordered by the compiler across other volatile operations.

> The compiler shouldn’t change the relative order or number of volatile memory
> operations.

However, notably, volatile operations are independent from atomic operations:

> Just like in C, whether an operation is volatile has no bearing whatsoever on
> questions involving concurrent access from multiple threads. Volatile accesses
> behave exactly like non-atomic accesses in that regard. In particular, a race
> between a `read_volatile` and any other operation (reading or writing) on the
> same location is undefined behavior.

These properties make their interactions with synchronization, ordering, and
other compiler optimizations all the more interesting. For this post, we'll
focus only on three things that have recently come up in discussions around
Tock's use of `VolatileCell`. `VolatileCell` is not something that Rust
provides; you can view its implementation
[here](https://docs.tockos.org/src/tock_cells/volatile_cell.rs). In fact, its
soundness is subject to debate (e.g., [in the Rust unsafe code
guidelines](https://github.com/rust-lang/unsafe-code-guidelines/issues/411#issuecomment-1581214968))
and is the motivation for this post.


## Introducing `VolatileCell`

`VolatileCell`'s purpose is to make a developer's life easier: peripherals that
expose an MMIO-based interface typically do so by having their registers laid
out such that it can be modeled like a `#[repr(C)]` struct, like
[this](https://github.com/tock/tock/blob/dee00dc23d32dd8116cb88b705ffaba11e950e72/chips/sifive/src/uart.rs#L21-L37):

```rust
 1  #[repr(C)]
 2  pub struct UartRegisters {
 3      /// Transmit Data Register
 4      txdata: u32,
 5      /// Receive Data Register
 6      rxdata: u32,
 7      /// Transmit Control Register
 8      txctrl: u32,
 9      /// Receive Control Register
10      rxctrl: u32,
11      /// Interrupt Enable Register
12      ie: u32,
13      /// Interrupt Pending Register
14      ip: u32,
15      /// Baud Rate Divisor Register
16      div: u32,
17  }
```

If we then cast a pointer at the address at which the peripheral's MMIO
interface is exposed in memory (its *base address*) to a `&mut UartRegisters`
reference, we have a convenient way to access its registers.

Unfortunately, doing so would not be sound. Given that the peripheral can act
like a different thread and change the values of these registers independent of
the CPU, creating a unique, mutable reference to this struct would infringe on
Rust's "no mutable aliasing" requirement. Despite that, regular memory accesses
are subject to the compiler optimizations described above; for these registers,
we need all accesses to be *volatile*.

This is the niche that `VolatileCell` fills!  It's quite simple, and like all
things we discuss today wraps an `UnsafeCell` internally:

```rust
1  pub struct VolatileCell<T> {
2      value: UnsafeCell<T>,
3  }
```

To implement these volatile accesses, it features custom `get` and `set` methods
respectively:

```rust
 1  impl<T> VolatileCell<T> {
 2      pub fn get(&self) -> T {
 3          // self.value.get() returns a *mut T pointer here:
 4          unsafe { ptr::read_volatile(self.value.get()) }
 5      }
 6
 7      pub fn set(&self, value: T) {
 8          unsafe { ptr::write_volatile(self.value.get(), value) }
 9      }
10  }
```

Thus, in essence, `VolatileCell` combines the properties of interior mutability
with those of volatile memory accesses. With it, we can transform the above
struct into a similar version, while still benefiting from a convenient API:

```rust
1  pub struct UartRegisters {
2      /// Transmit Data Register
3      txdata: VolatileCell<u32>,
4      /// Receive Data Register
5      rxdata: VolatileCell<u32>,
6      ...
```

Neat.


## `VolatileCell` and `dereferencable`

Unfortunately, `VolatileCell` has issues. I encourage you to read [the
discussion on the Rust unsafe
code](https://github.com/rust-lang/unsafe-code-guidelines/issues/411)
guidelines, but in short, this problem comes from the fact that all references
in Rust are marked as `dereferenceable` by default.

This dereference-ability means that the compiler is free to, for instance as
part of certain optimizations, insert a *spurious read* to the reference's
contents. And performing such a spurious read on a memory location where reads
can have side effects can mean that for many uses, using this abstraction can be
dangerous and unsound.

Unfortunately, we do not have a good answer around this problem yet. For now, it
seems that the only way to safely interact with such volatile memory is through
volatile pointer operations, and never creating a Rust reference to the memory
in question.


## `VolatileCell` and Concurrency

Another interesting concern is that of concurrency. As peripherals can be
modeled as to behave effectively like another thread, we should make sure that
`VolatileCell` is safe to use in these contexts—that is, making sure that it is
safe to have a `VolatileCell` defined over memory that is being changed by
hardware, and having all accesses be properly synchronized.

Our analysis of Rust's `Mutex` gives us confidence that the mere existence of
`VolatileCell` over memory that is being modified by hardware should not be of
concern. In particular, this issue was raised [on a PR for the Tock operating
system](https://github.com/tock/tock/pull/4129): given that `UnsafeCell` does
not make any guarantees about thread safety, and Rust is always free to
dereference its contents based on the `dereferenceable` attribute, how can it
possibly be safe to retain a reference to it in the first place? However, we can
observe that `Mutex` does exactly this: it holds a reference to an `UnsafeCell`
even when it may be modified concurrently by a different thread. Importantly,
`Mutex` *does* ensure that any *direct, intentional* accesses of its value are
properly synchronized.

This brings us to our second question on synchronization. Here, the following
statement is particularly worrying:

> In particular, a race between a `read_volatile` and any other operation
> (reading or writing) on the same location is undefined behavior.

Does using `read_volatile` over MMIO memory that may arbitrary change contents
across any two accesses count as a "data race"?

Unfortunately, atomic operations do not help here either:

> Since C++ does not support mixing atomic and non-atomic accesses, or
> non-synchronized different-sized accesses to the same data, Rust does not
> support those operations either.

I do not see a clear answer to this question. In practice, many developers rely
on volatile accesses are for interacting with such hardware-modified registers
without issues. One of the reasons for this might be that on most hardware
platforms, MMIO read operations are always consistent: registers are updated
atomically by peripherals, and a CPU will never be exposed to a partial
write. It would be great if the Rust documentation could provide more guidance
for these questions.


## `VolatileCell` and Happens-Before Relations

Finally, one important aspect to consider is that of volatile operations and
their interactions with regular memory accesses.  Again, Rust provides the
following guarantees for volatile memory operations [emphasis added]:

> Volatile operations are intended to act on I/O memory, and ****are guaranteed
> to not be**** elided or ****reordered by the compiler across other volatile
> operations****.

This is a substantially different guarantee than the ordering-constraints
imposed by atomic operations: while atomics can establish a *happens-before
relation* between two parts of parallel threads in a program that affects a
*global* set of variables, ordering guarantees around volatile operations are
constrained to only these operations. This makes sense for many use-cases of
volatile operations. For instance, it may matter that an "interrupt clear" flag
is written *before* data is removed from a receive queue, but generally a
peripheral should not be affected by other, independent memory accesses outside
of its MMIO address space.

However, certain peripherals break this assumption, most prominently ones that
perform "Direct Memory Access" (DMA). A DMA-capable peripheral not only has
control over its MMIO registers, but can also access (a subset of) the same RAM
that is accessible to the CPU. These devices can read from or write to a
specified memory region after being instructed to do so through a write to a
MMIO register.

This interaction between volatile accesses to an MMIO register and access to
regular memory can create issues in the face of compiler optimizations, or
hardware-reordering of memory accesses, though. For example, given that the
compiler does not make promises of the order of volatile operations relative to
other memory accesses, it could happen that a peripheral could read from a
buffer prepared by the CPU, when those buffer writes have not actually been
comiitted to memory yet.

For this reason, we need to establish an additional, explicit ordering guarantee
between other memory operations and these volatile accesses. Rust provides us
the
[`std::sync::atomic::fence`](https://doc.rust-lang.org/stable/std/sync/atomic/fn.fence.html)
function to do just that. This function works similar to atomic operations and
takes an `Ordering` argument. It will ensure that compiler optimizations respect
the requested ordering guarantees and, if applicable, will also emit a CPU
instruction that prevents hardware-based reordering of accesses beyond this
point.

Thus, when kicking off an operation that *reads* from memory written by the CPU,
we must use a `fence` operation with an `Ordering::Release` argument, to ensure
that all writes become visible to another thread (or the hardware) that is
synchronizing with our current thread. For reading data that the hardware has
written into memory, we must use a `fence` operation with `Ordering::Acquire`
instead. This ensures that we are seeing all changes since the point at which
the hardware has informed us that an operation has finished (e.g., through a
volatile read or interrupt).

It should be noted that this relies on a fairly liberal interpretation of the
following comment in `std::sync::atomic::fence`'s documentation:

> A fence ‘A’ which has (at least) Release ordering semantics, synchronizes with
> a fence ‘B’ with (at least) Acquire semantics, if and only if there exist
> operations X and Y, both operating on some atomic object ‘M’ such that A is
> sequenced before X, Y is sequenced before B and Y observes the change to
> M. This provides a happens-before dependence between A and B.

Here, we assume that the volatile reads and writes to MMIO registers count as
operations that are operating on an *atomic object*. However, this seems to be a
fair assumption to make on many hardware platforms in practice, and clarifying
it likely also ties in to the considerations of the previous subsection.

# Footnotes

<sup><a id="fn.1" href="#fnr.1">1</a></sup> In practice, Rust knows which exact
function we pass into the `writer` argument and generates a
`fn_cell_test.specialized.1:` symbol that it calls instead. Because our `fn
cell_test` is marked `pub` though, Rust also generates the general
`fn_cell_test:` symbol that does not make any assumptions on the function passed
into its second argument.
