test: Parser.pm
	@for t in t/*.t; do $$t; done

Parser.pm: Parser.yp
	yapp -v Parser.yp
