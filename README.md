amutake's master thesis
=======================

This is the repository of amutake's master thesis.


Prerequisites
-------------

- MacTeX
  - platex
  - dvipdfmx
  - latexmk
  - and some style files included in MacTeX
- make (optional)


Compilation
-----------

```
make
```

or if you don't have `make`,

```
TEXINPUTS=".:./sty//:" latexmk -pdfdvi main.tex
```
