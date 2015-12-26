#!/usr/bin/env perl

# This file is from the followings.
# - http://oku.edu.mie-u.ac.jp/~okumura/texwiki/?Latexmk
# - http://konn-san.com/prog/why-not-latexmk.html

$latex = 'platex %O -synctex=1 %S';
$pdflatex = 'lualatex %O -synctex=1 -interaction=errorstopmode %S';
$biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$bibtex = 'pbibtex %O %B';
$makeindex = 'mendex %O -U -o %D %S';
$dvipdf = 'dvipdfmx %O -o %D %S';
$dvips = 'dvips %O -z -f %S | convbkmk -u > %D';
$ps2pdf = 'ps2pdf %O %S %D';
$pdf_mode = 3;

# Prevent latexmk from removing PDF after typeset.
# This enables Skim to chase the update in PDF automatically.
$pvc_view_file_via_temporary = 0;

# Use Skim as a previewer
$pdf_previewer    = "open -ga ~/Applications/Skim.app";
