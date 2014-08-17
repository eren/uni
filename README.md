University Projects
===

This is a repository that hosts different projects written throughout my
computer science education (starting from **2010**). The repository is separated by languages instead of course codes. In each directory, a detailed explanation is given regarding to what the code does.

These projects are not the only ones I did in university. These are only
small subset which I decided to make public.

Project List
====

Racket
---
### λ-Parser
Parser for λ-calculus. It supports λ definition and application. It
implements naive β-transform, which can simply be defined as function application.


### Multi Parameter Interpreter
Extended versions of arithmetic expression parser (AE-Parser) supporting ``with`` statements and functions. It is an environment based, multi parameter interpreter supporting high-order functions and closures. It accepts S-expressions.

### Eight Queens Puzzle Solver
Puzzle solver operating on lists representing the chess board. The functions
are tested using the chess board data structure internally. Unfortunately,
it does not have a GUI to represent the chess board.

### Others
- Guess elimination
- Traffic light simulator
- Random ball animator on the screen
- Free fall simulation of a ball.

Java
---
### Sorting Algorithms

Implementation, testing, and performance comparison of **Quick Sort**, **Heap Sort**,
and **Cormen's Merge Sort** algorithms. The comparison also includes **insertion sort** and **regular merge sort**, which my professor provided the implementation.

The data is gathered using my own implementation, written into a file, and plotted
using ``gnuplot``.


### Binary Tree
Extendible, highly documented binary tree implementations with java generics.
The implementations include **Red-Black**, **AVL**, and **Binary Search** trees.


C
---
### Dining Philosophers
An implementation and solution of dining philosophers problem using semaphores.
The directory contains a detailed explanation of the problem, possible solutions,
and the solution I chose. (please check the PDF file)

### Lex & Yacc
Simple, stack based calculator implemented using lex and yacc. The design and
the implementation is in ``main.y`` file. You will find detailed explanation for
design in the comments.


Python
---
### Chat Server


Simple and highly extendible chat server and client architecture using pure python sockets.

### Window Share

Built on top of chat server, window share is a simple scribble-like game. Each
client connects to the server and draws to the screen. The information is, then,
relayed to other clients.

Tk is used to draw the GUI.