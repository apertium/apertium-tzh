all: tzh.gen.hfst tzh.mor.hfst tzh.mor.hfstol

tzh.mor.hfstol: tzh.mor.hfst
	hfst-fst2fst -w $< -o $@

tzh.mor.hfst: tzh.gen.hfst
	hfst-invert $< -o $@

tzh.gen.hfst: tzh.lexc.hfst tzh.twol.hfst
	hfst-compose-intersect -1 tzh.lexc.hfst -2 tzh.twol.hfst -o $@

tzh.twol.hfst: apertium-tzh.tzh.twol
	hfst-twolc $< -o $@

tzh.lexc.hfst: apertium-tzh.tzh.lexc
	hfst-lexc --Werror $< -o $@


