###############################################################################
## Makefile for apertium-tzh
###############################################################################

LANG1=tzh
BASENAME=apertium-$(LANG1)

TARGETS_COMMON =			\
	$(LANG1).automorf.hfst		\
	$(LANG1).automorf.bin		\
	$(LANG1).automorf.att.gz	\
	$(LANG1).autogen.hfst		\
	$(LANG1).autogen.bin		\
	$(LANG1).autogen.att.gz		\
	$(LANG1).autoseg.hfst		\
	$(LANG1).autoseg.bin		\
	$(LANG1).rlx.bin

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################

tzh.automorf.hfst: tzh.mor.hfst 
	hfst-fst2fst -w $< -o $@

tzh.autogen.hfst: tzh.gen.hfst
	hfst-fst2fst -w $< -o $@

tzh.autoseg.hfst: tzh.seg.hfst 
	hfst-fst2fst -w $< -o $@

tzh.mor.hfst: tzh.gen.hfst tzh.mor.twol.hfst tzh.spellrelax.hfst
	hfst-compose-intersect -1 tzh.gen.hfst -2 tzh.mor.twol.hfst | hfst-compose -F -1 - -2 tzh.spellrelax.hfst | hfst-invert -o $@

# <impf><o_pl1><s_pl3>tʼis<v><tv>+o<mark>:k>oj>ki>tʼis>o
tzh.gen.hfst: tzh.lexc.hfst tzh.twol.hfst
	hfst-compose-intersect -1 tzh.lexc.hfst -2 tzh.twol.hfst -o $@

tzh.twol.hfst: apertium-tzh.tzh.twol
	hfst-twolc $< -o $@

# <impf><o_pl1><s_pl3>tʼis<v><tv>+o<mark>:k>{o}j>k{i}>tʼis>o
tzh.lexc.hfst: apertium-tzh.tzh.lexc
	hfst-lexc -A --Werror $< -o $@

tzh.mor.twol.hfst: apertium-tzh.tzh.mor.twol
	hfst-twolc apertium-tzh.tzh.mor.twol -o tzh.mor.twol.hfst

# kojkitʼiso:k>oj>ki>tʼis>o
tzh.seg.hfst: tzh.mor.hfst tzh.gen.hfst
	hfst-compose -F -1 tzh.mor.hfst -2 tzh.gen.hfst -o tzh.seg.hfst 

tzh.spellrelax.hfst: apertium-tzh.tzh.spellrelax 
	hfst-regexp2fst -S -o $@ < $<

tzh.rlx.bin: apertium-tzh.tzh.rlx
	cg-comp $< $@

$(LANG1).autogen.att.gz: $(LANG1).gen.hfst
	hfst-fst2txt $< | gzip -9 -c > $@

$(LANG1).automorf.att.gz: $(LANG1).mor.hfst
	hfst-fst2txt $< | gzip -9 -c > $@

$(LANG1).autoseg.att.gz: $(LANG1).seg.hfst
	hfst-fst2txt $< | gzip -9 -c > $@

$(LANG1).autogen.bin: $(LANG1).autogen.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autogen.att
	lt-comp lr .deps/$(LANG1).autogen.att $@

$(LANG1).automorf.bin: $(LANG1).automorf.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).automorf.att
	lt-comp lr .deps/$(LANG1).automorf.att $@

$(LANG1).autoseg.bin: $(LANG1).autoseg.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autoseg.att
	lt-comp lr .deps/$(LANG1).autoseg.att $@

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(LANG1).lexc		\
		$(BASENAME).$(LANG1).twol	\
		$(BASENAME).$(LANG1).spellrelax \
		$(BASENAME).$(LANG1).rlx	\
		modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_tzh_dir: This is where the compiled binaries go
#   apertium_tzh_srcdir: This is where the source files go

apertium_tzhdir=$(prefix)/share/apertium/$(BASENAME)/
apertium_tzh_srcdir=$(prefix)/share/apertium/$(BASENAME)/

EXTRA_TARGETS=

if HAVE_HFSTOSPELL
EXTRA_TARGETS += $(LANG1).zhfst
endif # HAVE_HFSTOSPELL

apertium_tzh_DATA=$(TARGETS_COMMON) $(EXTRA_TARGETS) 

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
	$(INSTALL_DATA) $(BASENAME).$(LANG1).lexc $(DESTDIR)$(apertium_tzh_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).twol $(DESTDIR)$(apertium_tzh_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).rlx $(DESTDIR)$(apertium_tzh_srcdir)


###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################

test: all
	apertium-regtest test
