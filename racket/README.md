General Information
====
This directory holds projects from the first, third, and fourth year. In Bilgi University,
**Racket** is used in the first year of the education with the book **How To Design Programs**. Thus, codes in **htdp** are from my first year.

**Plai** subdirectory contains different versions parser and evaluator for a new language built on top of racket. It contains the actual implementation of the topics in **Programming Languages: Application and Interpretation** by Shriram Krishnamurthi.
Different versions are prefixed with numbers.

PLAI
===
Written in **2014**, PLAI is all about parsing and evaluating. Within this course, I was
exposed to λ-calculus as well.


λ-Parser
---
Parser for λ-calculus. It supports λ definition and application. It
implements naive β-transform, which can simply be defined as function application.


Single Valued Interpreter
---
Extended versions of arithmetic expression parser (AE-Parser) supporting ``with`` statements and functions. It is an environment based, single parameter interpreter supporting high-order functions and closures. It accepts S-expressions.


Multi Valued Interpreted
----
Built on top of FWAE, it's the last version of the interpreter. It is environment based,
multi-parameter interpreter supporting high-order functions and closures.


HTDP
===
Written in **2010**, when I first started my computer science education. The book used was an online version of **How to Design Programs** which started with animations and gradually expected students to solve harder problems.


Gauss Elimination
---

Implementation of gauss elimination using racket.

Eight Queens Puzzle Solver
---
Puzzle solver operating on lists representing the chess board. The functions
are tested using the chess board data structure internally. Unfortunately,
it does not have a GUI to represent the chess board.

Animations
---

- **Traffic simulation**: simple animation of traffic lights
- **Random balls**: puts a ball with random colour, size, and speed onto the screen and animates it.
- **Free fall**: animation of a ball falling from a wall.
