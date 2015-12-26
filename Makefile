.PHONY: pdf cont clean update final

MAIN=main
TEXINPUTS=".:./sty//:"

pdf: $(MAIN).tex
	TEXINPUTS=$(TEXINPUTS) latexmk -pdfdvi $(MAIN)

cont: $(MAIN).tex
	TEXINPUTS=$(TEXINPUTS) latexmk -pvc -pdfdvi $(MAIN)

clean:
	latexmk -C $(MAIN)

update:
	mkluatexfontdb -vvv

final:
	TEXINPUTS=$(TEXINPUTS) latexmk $(MAIN)
	dvipdfmx $(MAIN).dvi
