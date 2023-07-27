---
layout: page
title: TockWorld 6 - Technical Debt / Documentation Discussion
description: Technical Debt Discussion at TockWorld 6
permalink: /tockworld6/techdebt
---

# Technical Debt / Documentation Discussion Group

## Challenges

### Technical Debt / Issue Management

1. 90+ issues in https://github.com/tock/tock/issues
   - Which to work on?
   - Which are important?

2. Which projects are active in Tock?
   - What are people working on?
   - What is the roadmap?

3. Hidden technical debt in the source tree
   - Ex: capsules which violate tock design guides

### Documentation

1. Book diverges from kernel

2. `tock/doc` folder unwieldy

3. Discoverability of resources and https://docs.tockos.org
   - Comments in source not always valid markdown


## Ideas

- Create a pinned tracking issue with priority queue of issues
  - Which issues are important?
  - Which are just nice to have?

- Create a `triage` tag (or some other name) for quickly+easily marking found
  problems
  - Goal: easy to do. Designed to help us identify and track known issues.
  - Only two lines in the issue:
    1. What code is problematic?
    2. What is the issue or which guideline is violated?

- Create links in the readme to specific issue groups
  - Label all issues

- Create `mdbook` plugin to include source code in book
  - Example: `X.rs#L28-40$L30-L35$L38-L39` would include lines 28-40 but omit
    the other sections

- Either:
  - Move docs to tock/book
  - Create script to copy (sync) tock/docs to book

- Update the tockos.org website to explain the ecosystem and point to resources

- Idea: implement that TODOs in code have corresponding tracking issues