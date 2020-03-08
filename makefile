TEXMFLOCAL := $(shell kpsewhich --var-value=TEXMFlocal)
STRIPTARGET = bellsloadingpkgs.sty
DOCTARGET = bellsloadingpkgs
PDFTARGET = bellsloadingpkgs.pdf
DVITARGET = bellsloadingpkgs.dvi

default: $(STRIPTARGET) $(DVITARGET)
strip: $(STRIPTARGET)
all: $(STRIPTARGET) $(PDFTARGET)

bellsloadingpkgs.sty: bellsloadingpkgs.dtx
	pdflatex bellsloadingpkgs.ins


.SUFFIXES: .dtx .dvi .pdf
.dtx.dvi:
	uplatex $<
	makeindex -s gind.ist $(basename $<)
	makeindex -s gglo.ist -o $(addsuffix .gls,$(basename $<)) $(addsuffix .glo,$(basename $<))
	uplatex -synctex=1 $<
.dvi.pdf:
	dvipdfmx $<

.PHONY: clean cleanstrip cleanall cleandoc movelog install
install: $(STRIPTARGET) $(PDFTARGET)
	mkdir -p $(TEXMFLOCAL)/tex/platex/bellMacros
	install $(STRIPTARGET) $(TEXMFLOCAL)/tex/platex/bellMacros
	mkdir -p $(TEXMFLOCAL)/doc/platex/bellMacros
	install $(PDFTARGET) $(TEXMFLOCAL)/doc/platex/bellMacros

clean:
	rm -f $(DVITARGET) \
	$(addsuffix .idx,$(DOCTARGET)) \
	$(addsuffix .ind,$(DOCTARGET)) \
	$(addsuffix .ilg,$(DOCTARGET)) \
	$(addsuffix .glo,$(DOCTARGET)) \
	$(addsuffix .gls,$(DOCTARGET)) \
	$(addsuffix .aux,$(DOCTARGET)) \
	$(addsuffix .toc,$(DOCTARGET)) \
	$(addsuffix .log,$(DOCTARGET))

cleanall:
	rm -f $(PDFTARGET) \
	$(STRIPTARGET) \
	make clean

movebuild:
	if [ -e $(STRIPTARGET) ]; then mv $(STRIPTARGET) ./build; fi
	if [ -e $(PDFTARGET) ]; then mv $(PDFTARGET) ./build; fi
	if [ -e $(DOCTARGET).synctex.gz ]; then mv $(DOCTARGET).synctex.gz ./build; fi
	if [ -e $(DVITARGET) ]; then mv $(DVITARGET) ./build; fi

movelog:
	if [ -e $(DOCTARGET).aux ]; then mv $(DOCTARGET).aux ./logs; fi
	if [ -e $(DOCTARGET).log ]; then mv $(DOCTARGET).log ./logs; fi
	if [ -e $(DOCTARGET).toc ]; then mv $(DOCTARGET).toc ./logs; fi
	if [ -e $(DOCTARGET).mx1 ]; then mv $(DOCTARGET).mx1 ./logs; fi
	if [ -e $(DOCTARGET).mx2 ]; then mv $(DOCTARGET).mx2 ./logs; fi
	if [ -e $(DOCTARGET).bcf ]; then mv $(DOCTARGET).bcf ./logs; fi
	if [ -e $(DOCTARGET).bbl ]; then mv $(DOCTARGET).bbl ./logs; fi
	if [ -e $(DOCTARGET).blg ]; then mv $(DOCTARGET).blg ./logs; fi
	if [ -e $(DOCTARGET).idx ]; then mv $(DOCTARGET).idx ./logs; fi
	if [ -e $(DOCTARGET).ind ]; then mv $(DOCTARGET).ind ./logs; fi
	if [ -e $(DOCTARGET).glo ]; then mv $(DOCTARGET).glo ./logs; fi
	if [ -e $(DOCTARGET).gls ]; then mv $(DOCTARGET).gls ./logs; fi
	if [ -e $(DOCTARGET).ilg ]; then mv $(DOCTARGET).ilg ./logs; fi
	if [ -e $(DOCTARGET).out ]; then mv $(DOCTARGET).out ./logs; fi
	if [ -e $(DOCTARGET).run.xml ]; then mv $(DOCTARGET).run.xml ./logs; fi
