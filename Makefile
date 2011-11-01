.SUFFIXES: .tex .dvi .dvi2 .ps .ps2 .pdf .bib .bbl

DVIDVI=dvidvi -m '2:0(3mm,-14mm),1(193mm,-14mm)'
DVIPS=dvips -Ppdf
DVI2PS=dvips -t landscape -x 707
PS2PDF=ps2pdf -dEmbedAllFonts#true

MYSRC=cv

#pdflatex prefered here over latex

.tex.pdf:
	rm -f $(MYSRC).pdf
	pdflatex $< $@ || { rm -f $*.aux $*.idx && false ; }
	while grep 'Rerun to get cross-references right.' $*.log ; do \
	  pdflatex $< $@ || { rm -f $*.aux $*.idx && false ; } ; done

.tex.dvi:
	rm -f $*.ps $*.pdf
	latex $< || { rm -f $*.dvi $*.aux $*.idx && false ; }
	while grep 'Rerun to get cross-references right.' $*.log ; do \
	  latex $< || { rm -f $*.dvi $*.aux $*.idx && false ; } ; done

.dvi.ps:
	$(DVIPS) $< -o $@

.dvi.dvi2:
	$(DVIDVI) $< $@

.dvi2.ps2:
	$(DVI2PS) $< -o $@

.ps.pdf:
	$(PS2PDF) $< $@

$(MYSRC).pdf:  	$(MYSRC).tex
$(MYSRC).ps:  	$(MYSRC).dvi
$(MYSRC).ps2:   $(MYSRC).dvi2
$(MYSRC).dvi2:	$(MYSRC).dvi
$(MYSRC).dvi:	$(MYSRC).tex

clean:
	rm -f $(MYSRC){.aux,.nav,.log,.pdf,.toc,.snm,.out,.dvi,.ps}
