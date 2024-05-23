# This is the makefile for the Part II demonstration dissertation
#
# Note that continuation lines require '\' and
# that a TAB character preceeds any shell command line

.DELETE_ON_ERROR:

# Rules for building LaTeX documents (see Unix Tools course)
%.pdf %.aux %.idx: %.tex
	pdflatex -halt-on-error $<
	while grep 'Rerun to get ' $*.log ; do pdflatex $< ; done
%.quiet: %.tex
	pdflatex -halt-on-error $< > /dev/null 
	while grep 'Rerun to get ' $*.log ; do pdflatex $< > /dev/null; done
%.ind: %.idx
	makeindex $*
%.bbl: %.aux
	bibtex $*
# Rules for exporting xfig diagrams into PDF or EPS
%.pdf: %.eps
	epstopdf --outfile=$@ $<
%.eps: %.fig
	fig2dev -L eps $< $@
%.pdftex %.pdftex_t: %.fig
	fig2dev -L pdftex_t -p $*.pdftex $< $*.pdftex_t
	fig2dev -L pdftex $< $*.pdftex

help:
	@echo
	@echo "USAGE:"
	@echo
	@echo "make                display help information"
	@echo "make proposal.pdf   format the proposal as PDF"
	@echo "make main.pdf       format the dissertation as PDF"
	@echo "make all            make proposal.pdf and main.pdf"
	@echo "make view-proposal  format and view the proposal"
	@echo "make view-main      format and view the dissertation"
	@echo "make count          display an estimated word count"
	@echo "make pub            put demodiss.pdf onto your homepage"
	@echo "make create_text    creates a text document with content from main.tex"
	@echo "make clean          delete all intermediate files"
	@echo

view-%: %.pdf
	( okular --unique $< || evince $< ) &

main.pdf: makefile.txt proposal.tex main.bbl

makefile.txt: makefile
	expand makefile >makefile.txt

create_text:
	detex main.tex >> main.txt

count:
# detex main.tex | tr -cd '0-9A-Za-z \n' | wc -w
	texcount -inc main.tex

all: proposal.pdf main.pdf clean

quiet: proposal.quiet main.quiet clean

allclean: proposal.pdf main.pdf clean

pub: main.pdf
	rsync -t $+ $(HOME)/public_html/demodiss.pdf

clean:
	rm -f *.aux *.log *.err *.out
	rm -f *~ *.lof *.toc *.blg *.bbl
	rm -f makefile.txt

distclean: clean
	rm -f figs/*.pdf chapters/*.pdf proposal.pdf main.pdf
