#-------------------------------------------------------
# $Id: Makefile,v 1.6 2003/09/03 19:38:20 norman Exp $
#
# This Makefile has special support for the PDF generation
# requirements for NSF proposals
# 
# This is a basic Makefile for compiling LaTeX documents
# Included is basic support for BibTeX bibliographies
# as well as support for multiple output formats.
#
# Current supported output types:
# dvi postscript html pdf
#
# Invoke the makefile in the following manners:
# make             -- Run LaTeX and BibTeX
# make dvi         -- Run LaTeX and BibTeX and invoke the DVI viewer
# make postscript  -- Make simple postscript output
# make pdf         -- Make PDF output using pdfTeX
# make finalps     -- Make better postscript output with embedded fonts
# make finalpdf    -- Make PDF output with embedded fonts, etc... 
# make index       -- Runs indexing (if you do indexing that is)
# make html        -- Makes HTML output
# make clean       -- Removes temp files and cleans up output
# make proper      -- More exhaustive clean 
#-------------------------------------------------------
#
# Name of the Main LaTeX document
# (without the .tex extenstion)
MAINDOC	= docs
#
# Program Definitions
#
TEX	 = latex
HTML	 = latex2html
DVIPS	 = dvips
PDFLATEX = pdflatex
PS2PDF   = ps2pdf
XDVI	 = xdvi
MAKEINDEX = makeindex
#
# Program Flags
#
TEX_FLAGS	=
HTML_FLAGS	=
PDF_FLAGS	=
PS2PDF_FLAGS    = -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true
MAKEINDEX_FLAGS = 
#DVIPS_FLAGS	= -Pcmz
DVIPS_FLAGS	= -Ppdf -G0
#
# LaTeX Source Paths
#
SRCDIR	= .
FIGDIR	= ./figures
#
# LaTeX Source Files
#
TEXSRC	= $(SRCDIR)/docs.tex \
	  $(wildcard $(SRCDIR)/chapters/*.tex)
FIGSRC	= $(wildcard $(FIGDIR)/*.ps ) \
	  $(wildcard $(FIGDIR)/*.eps) \
	  $(wildcard $(FIGDIR)/*.fig) \
	  $(wildcard data/*/*.pdf) \
	  $(wildcard data/*/*.ps) \
	  $(wildcard data/*/*.eps) 
STYSRC	= $(wildcard $(SRCDIR)/*.sty) $(wildcard $(SRCDIR)/*.cls)
#
#=====================================================#
# Display Codes (this is so we can track passes)
#=====================================================#
MOVE_TO_COL	= @echo -en "\\033[60G"
SETCOLOR_BLACK	= @tput sgr0
SETCOLOR_RED 	= @echo -en "\\033[0;31m"
SETCOLOR_GREEN 	= @echo -en "\\033[0;32m"
SETCOLOR_BLUE	= @echo -en "\\033[0;34m"
#=====================================================#
# Standard Targets                                    #
#=====================================================#
all : $(MAINDOC).dvi $(TEXSRC) $(FIGSRC) 

clean :	
	@rm -f *.aux *.bbl *.blg *.log *.toc *.loc *.lot *.lof *.pdf *.dvi

proper :
	@rm -f *.aux *.bbl *.blg *.log *.dvi \
	*.idx *.ilg *.ind *.toc *.lot *.lof 

#-----------------------------------------------------
# Portable Document Format (PDF) Output
#-----------------------------------------------------
pdf : $(MAINDOC).pdf $(FIGSRC)
#-----------------------------------------------------
# Postscript Output
#-----------------------------------------------------
ps :  $(MAINDOC).ps $(FIGSRC)
postscript : $(MAINDOC).ps $(FIGSRC)
finalps:
	${DVIPS} ${DVIPS_FLAGS} -o ${MAINDOC}.ps ${MAINDOC}.dvi
finalpdf:
	${PS2PDF} ${PS2PDF_FLAGS} ${MAINDOC}.ps ${MAINDOC}.pdf
#-----------------------------------------------------
# Index Generation
#-----------------------------------------------------
index:	$(MAINDOC).aux $(MAINDOC).idx $(MAINDOC).ilg $(MAINDOC).ind
#-----------------------------------------------------
# HTML Output
#-----------------------------------------------------
html :       $(MAINDOC).html $(FIGSRC)
#-----------------------------------------------------
# DVI Output (with X display)
#-----------------------------------------------------
dvi :	$(MAINDOC).dvi
#	@clear
	@$(XDVI) $(MAINDOC) 1> /dev/null &
#	@clear

#=====================================================
# Compilation Rules for LaTeX and BibTeX
#=====================================================

# Note: LaTeX must be run multiple times 
# to get the proper cross referencing from
# the \ref and \cite commands
# To accomplish this we chain from tex->aux->dvi

# To generate a .aux file from a .tex file
%.aux :	%.tex
#	$(MOVE_TO_COL)
	$(SETCOLOR_GREEN)
	@echo "=========================TEX -> AUX PASS=============================="
	$(SETCOLOR_BLACK)
	@$(TEX) $(TEX_FLAGS) $(*F)
#	@rm -f $(MAINDOC).dvi

# To generate a .dvi file from a .tex file
%.dvi :	%.aux
#	$(MOVE_TO_COL)
	$(SETCOLOR_BLUE)
	@echo "=========================AUX -> DVI PASS=============================="
	$(SETCOLOR_BLACK)
	@$(TEX) $(TEX_FLAGS) $(*F)


# To generate a .idx file from a .tex file
%.ilg :	%.idx
#	$(MOVE_TO_COL)
	$(SETCOLOR_BLUE)
	@echo "=========================Indexing Pass================================"
	$(SETCOLOR_BLACK)
	@$(MAKEINDEX) $(MAKEINDEX_FLAGS) $(*F)
	@$(TEX) $(TEX_FLAGS) $(*F)

# To generate a .ps file from a .dvi file
%.ps : %.dvi
	@$(DVIPS) $(DVIPS_FLAGS) -o $(*F).ps $(*F).dvi

# To generate .html files from a .dvi file
%.html : %.dvi
	@$(HTML) $(HTML_FLAGS) $(*F)	

# To generate a .pdf file from a .tex file
%.pdf : %.tex
	@$(PDFLATEX) $(PDF_FLAGS) $(*F)
	@$(PDFLATEX) $(PDF_FLAGS) $(*F) 
	@$(PDFLATEX) $(PDF_FLAGS) $(*F) 
#
# Dependencies
# DO NOT DELETE
$(MAINDOC).tex : $(TEXSRC) $(FIGSRC) $(STYSRC)
$(MAINDOC).aux : $(TEXSRC) $(FIGSRC) $(STYSRC)
$(MAINDOC).bbl : $(TEXSRC) $(STYSRC)
$(MAINDOC).pdf : $(TEXSRC) $(FIGSRC) $(STYSRC)
$(MAINDOC).dvi : $(TEXSRC) $(FIGSRC) $(STYSRC)
