.PHONY: pdf cont clean update final

MAIN=sigplanconf
TEXINPUTS=".:./sty//:"

pdf: $(MAIN).tex
	TEXINPUTS=$(TEXINPUTS) latexmk -pdf $(MAIN)

cont: $(MAIN).tex
	TEXINPUTS=$(TEXINPUTS) latexmk -pvc -pdf $(MAIN)

clean:
	latexmk -C $(MAIN)

update:
	mkluatexfontdb -vvv

final:
	TEXINPUTS=$(TEXINPUTS) latexmk $(MAIN)
	dvipdfmx $(MAIN).dvi
