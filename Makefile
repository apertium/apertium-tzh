all: tzh.rlx.bin tzh.gen.hfst tzh.mor.hfst tzh.mor.hfstol modes/tzh-morph.mode

tzh.mor.hfstol: tzh.mor.hfst 
	hfst-fst2fst -w $< -o $@

tzh.mor.hfst: tzh.gen.hfst tzh.mor.twol.hfst tzh.spellrelax.hfst
	hfst-compose-intersect -1 tzh.gen.hfst -2 tzh.mor.twol.hfst | hfst-compose -F -1 - -2 tzh.spellrelax.hfst | hfst-invert -o $@
	#hfst-compose-intersect -1 tzh.gen.hfst -2 tzh.mor.twol.hfst | hfst-invert -o $@

tzh.gen.hfst: tzh.lexc.hfst tzh.twol.hfst
	hfst-compose-intersect -1 tzh.lexc.hfst -2 tzh.twol.hfst -o $@

tzh.twol.hfst: apertium-tzh.tzh.twol
	hfst-twolc $< -o $@

tzh.lexc.hfst: apertium-tzh.tzh.lexc
	hfst-lexc --Werror $< -o $@

tzh.mor.twol.hfst: apertium-tzh.tzh.mor.twol
	hfst-twolc apertium-tzh.tzh.mor.twol -o tzh.mor.twol.hfst

tzh.seg.hfst: tzh.mor.hfst tzh.gen.hfst
	hfst-compose -1 tzh.mor.hfst -2 tzh.gen.hfst -o tzh.seg.hfst 

tzh.spellrelax.hfst: apertium-tzh.tzh.spellrelax 
	hfst-regexp2fst -S -o $@ < $<

tzh.rlx.bin: apertium-tzh.tzh.rlx
	cg-comp $< $@

modes/tzh-morph.mode: modes.xml
	apertium-gen-modes modes.xml
