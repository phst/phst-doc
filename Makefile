PKG := phst-doc

DTX := $(PKG).dtx
INS := $(PKG).ins
CLS := $(PKG).cls
PDF := $(PKG).pdf
IDXSRC := $(PKG).idx
IDXDST := $(PKG).ind
IDXSTY := gind.ist
GLOSRC := $(PKG).glo
GLODST := $(PKG).gls
GLOSTY := gglo.ist

SOURCES := $(DTX) $(INS)
OBJECTS := $(STY) $(PDF)

TEXMF := $(shell kpsewhich --var-value=TEXMFHOME)
CLSDIR := $(TEXMF)/tex/latex/phst
PDFDIR := $(TEXMF)/doc/latex/phst

INSTALL := install
MKTEXLSR := mktexlsr
TEX := tex
LATEX := pdflatex
LATEXFLAGS := --file-line-error --interaction=nonstopmode
DRAFTFLAGS := --draftmode
FINALFLAGS := --synctex=1
MAKEINDEX := makeindex


# all: package doc
all: package

package: $(CLS)

doc: $(PDF)

# install: install-package install-doc
install: install-package

install-package: package
	$(INSTALL) -d $(CLSDIR)
	$(INSTALL) -c -m 644 $(CLS) $(CLSDIR)
	$(MKTEXLSR)

install-doc: doc
	$(INSTALL) -d $(PDFDIR)
	$(INSTALL) -c -m 644 $(PDF) $(PDFDIR)
	$(MKTEXLSR)

install-doc:

#$(CLS): $(SOURCES)
#	$(TEX) $(INS)

$(PDF): $(CLS) $(DTX)
	$(LATEX) $(LATEXFLAGS) $(DRAFTFLAGS) $(DTX)
	$(MAKEINDEX) -s $(IDXSTY) -o $(IDXDST) $(IDXSRC)
	$(MAKEINDEX) -s $(GLOSTY) -o $(GLODST) $(GLOSRC)
	$(LATEX) $(LATEXFLAGS) $(DRAFTFLAGS) $(DTX)
	$(LATEX) $(LATEXFLAGS) $(FINALFLAGS) $(DTX)
