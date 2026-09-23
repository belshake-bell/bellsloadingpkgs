TEXMFLOCAL := $(shell kpsewhich --var-value=TEXMFlocal)
TARGET      = bellsloadingpkgs
STRIPTARGET = $(addsuffix .sty,$(TARGET))
PDFTARGET   = $(addsuffix .pdf,$(TARGET))
DVITARGET   = $(addsuffix .dvi,$(TARGET))
LOGSUFFIXES = .aux .log .toc .mx1 .mx2 .bcf .bbl .blg .idx .ind .glo .gls .ilg .glg .out .run.xml .hd
LATEXOpt   := -interaction batchmode
UPMENDEXOpt = -q
LATEXENGINE := uplatex
DVIWARE := dvipdfmx
DVIPDFMxOpt =

define move
	$(foreach tempsuffix,$(LOGSUFFIXES),$(call movebase,$1,$(tempsuffix)))

endef
define movebase
	@if [ -e $(addsuffix $2,$1) ]; then mv $(addsuffix $2,$1) ./logs; fi

endef

all: $(STRIPTARGET) $(PDFTARGET) movelog
strip: $(STRIPTARGET)

bellsloadingpkgs.sty: bellsloadingpkgs.dtx
	pdflatex bellsloadingpkgs.ins

.PHONY: clean cleanstrip cleanall cleandoc movelog install
.SUFFIXES: .dtx .dvi .pdf

%.dvi: %.dtx
	uplatex $(LATEXOpt) $(notdir $<)
	if [ -e $(addsuffix .idx,$(basename $(notdir $<))) ]; then $(MAKE) -B $(addsuffix .ind,$(basename $(notdir $<))); fi
	if [ -e $(addsuffix .glo,$(basename $(notdir $<))) ]; then $(MAKE) -B $(addsuffix .gls,$(basename $(notdir $<))); fi
	uplatex $(LATEXOpt) -synctex=1 $<

%.pdf: %.dvi
	dvipdfmx $(DVIPDFMxOpt) $(notdir $<)

%.ind: %.idx
	makeindex $(UPMENDEXOpt) -s gind.ist $(notdir $<)

%.gls: %.glo
	makeindex $(UPMENDEXOpt) -s gglo.ist -o $(notdir $@) -t $(addsuffix .glg,$(basename $(notdir $<))) $(notdir $<)


install: $(STRIPTARGET) $(PDFTARGET)
	mkdir -p $(TEXMFLOCAL)/tex/platex/bellMacros
	install $(STRIPTARGET) $(TEXMFLOCAL)/tex/platex/bellMacros
	mkdir -p $(TEXMFLOCAL)/doc/platex/bellMacros
	install $(PDFTARGET) $(TEXMFLOCAL)/doc/platex/bellMacros

clean:
	rm -f $(DVITARGET) \
	$(addprefix $(TARGET),$(LOGSUFFIXES))

cleanall:
	rm -f $(PDFTARGET) \
	$(STRIPTARGET)
	$(MAKE) clean

movebuild:
	@mkdir -p ./build
	if [ -e $(STRIPTARGET) ]; then mv $(STRIPTARGET) ./build; fi
	if [ -e $(PDFTARGET) ]; then mv $(PDFTARGET) ./build; fi
	if [ -e $(TARGET).synctex.gz ]; then mv $(TARGET).synctex.gz ./build; fi
	if [ -e $(DVITARGET) ]; then mv $(DVITARGET) ./build; fi

movelog:
	@mkdir -p ./logs
	$(foreach temp,$(TARGET),$(call move,$(temp)))

makelog:
	@git log --graph --date=short --all --pretty="format:(%C(yellow)%h) %C(cyan)%ad \"%C(green)%an\"%C(reset)%x09%C(red)%d%C(reset) %s" 1> "log_all.gitlog"
	@git log --graph --date=short       --pretty="format:(%C(yellow)%h) %C(cyan)%ad \"%C(green)%an\"%C(reset)%x09%C(red)%d%C(reset) %s" 1> "log.gitlog"
