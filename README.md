[![Build Status](https://travis-ci.org/tock/tock-www.svg?branch=master)](https://travis-ci.org/tock/tock-www)

# ![Tock OS Website](http://www.tockos.org/assets/img/tockwebsite.svg "Tock Website Logo")


[https://www.tockos.org/](https://www.tockos.org/)


## Building

Dependencies:

First install ruby and ruby bundler if you don't already have it from another ruby project:
```bash
    sudo apt install ruby ruby-dev
```

To configure RubyGems to install executables in your user account rather than in a system directory add these lines to ~/.bashrc on Linux or ~/.zshrc on macOS:
```bash
    export GEM_HOME="$HOME/gems"
    export PATH="$GEM_HOME/bin:$PATH"
```
Restart your shell, or load the updated file (for example, source ~/.bashrc). Then install Bundler without sudo:
```
    gem install jekyll bundler
```

or

```bash
    # Note: No sudo on a Mac. You should never use sudo for these kinds of installs on a Mac anymore.
    # sudo may make this work for now, but it will make your life miserable in the long run.

    brew install ruby
    gem install jekyll bundler
```


Then use bundler to install the needed gems
```bash
    bundle install
```

To build the website:
```bash
    bundle exec jekyll serve
```
Now browse to http://localhost:4000 to view

Logo maker: [logomakr.com/5mGstw](https://logomakr.com/5mGstw)
