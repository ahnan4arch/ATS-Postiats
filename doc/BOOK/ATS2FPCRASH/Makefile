#
#
# A Simple Makefile
#
#

######

ATSHOMEQ="$(ATSHOME)"
ATSCC=$(ATSHOMEQ)/bin/atscc
ATSDOC=$(ATSHOMEQ)/bin/atsdoc
#LIBATSDOC=$(ATSHOMEQ)/libatsdoc

######

all::
all:: html
all:: synhilit
all:: htmltoc
all:: clean

######

cleanall::

######

MAKE=make
JADE=/usr/bin/openjade

######
#
DSL=default
DSL=./mydocbook.dsl
#
# HX-2016-08-01:
# PDF needs to be changed from 0 to 1
# in ats2fpcrash.hats before atext2db conversion
#
pdf: main.db ; \
jw -b pdf --dsl default --parser $(JADE) --output PDF/ main.db
#
######
#
DSL=default
DSL=./mydocbook.dsl
#
html: main.db ; \
jw -b html --parser $(JADE) --dsl $(DSL) --output HTML/ main.db
#
htmltoc: ; \
$(MAKE) -C HTML -f Makefile htmltoc
#
synhilit: \
mytexting; $(MAKE) -C HTML synhilit
mytexting: ; $(MAKE) -C MYTEXT mytexting
#
######

main.db:: lectures
main.db:: preface.db

######

preface.exe: preface_atxt.dats
	$(ATSCC) -D_ATS_NGC -o $@ preface_atxt.dats -latsdoc
preface_atxt.dats: preface.atxt
	$(ATSDOC) --outcode $@ -i preface.atxt > preface_atxt.txt
preface.db:: preface.exe ; ./$< > $@
preface.db:: ; $(RMF) preface.exe preface_atxt_dats.c preface_atxt.dats preface_atxt.txt

######
#
# Basic Topics
#
######
#
lectures:: lecture01
lectures:: lecture02
lectures:: lecture03
lectures:: lecture04
lectures:: lecture05
#
######
#
lecture01:: ; \
$(MAKE) -C LECTURE/01 -f ../Makefile_lect main.db
clean:: ; $(MAKE) -C LECTURE/01 -f ../Makefile_lect clean
#
lecture02:: ; \
$(MAKE) -C LECTURE/02 -f ../Makefile_lect main.db
clean:: ; $(MAKE) -C LECTURE/02 -f ../Makefile_lect clean
#
lecture03:: ; \
$(MAKE) -C LECTURE/03 -f ../Makefile_lect main.db
clean:: ; $(MAKE) -C LECTURE/03 -f ../Makefile_lect clean
#
lecture04:: ; \
$(MAKE) -C LECTURE/04 -f ../Makefile_lect main.db
clean:: ; $(MAKE) -C LECTURE/04 -f ../Makefile_lect clean
#
lecture05:: ; \
$(MAKE) -C LECTURE/05 -f ../Makefile_lect main.db
clean:: ; $(MAKE) -C LECTURE/05 -f ../Makefile_lect clean
#
######
#
CPRF=cp -rf
SCPR=scp -r
#
RSYNC=rsync
CHMOD=chmod
#
######

regress:: ; \
$(MAKE) -C CODE regress

######

upload:: upload_html

upload_pdf:: ; \
  $(SCPR) PDF ats-hwxi,ats-lang@web.sourceforge.net:htdocs/DOCUMENT/ATS2FPCRASH/
upload_html:: ; \
  $(RSYNC) -av --delete HTML ats-hwxi,ats-lang@web.sourceforge.net:htdocs/DOCUMENT/ATS2FPCRASH

######

uploadloc:: ; $(SCPR) HTML hwxi@csa2.bu.edu:public_html/ATS/DOCUMENT/ATS2FPCRASH

######
#
upload_code:: ; \
  $(MAKE) -C CODE cleanall
upload_code:: ; \
  $(RSYNC) -av --delete CODE ats-hwxi,ats-lang@web.sourceforge.net:htdocs/DOCUMENT/ATS2FPCRASH
#
######

RMF=rm -f

######

clean:: ; $(RMF) *~
clean:: ; $(RMF) *_atxt.txt
clean:: ; $(RMF) *_atxt.dats
clean:: ; $(RMF) *_atxt_dats.c
clean:: ; $(RMF) HTML/htmltoc_dats.c
clean:: ; make -C HTML clean
clean:: ; make -C MYTEXT clean

cleanall:: clean
cleanall:: ; $(RMF) preface
cleanall:: ; $(RMF) preface.db
cleanall:: ; $(RMF) PDF/main.pdf
cleanall:: ; $(RMF) TEMP/chap_*.dats
cleanall:: ; $(RMF) HTML/htmltoc.exe
cleanall:: ; make -C HTML cleanall
cleanall:: ; make -C MYTEXT cleanall

###### end of [Makefile] ######
