#.SILENT:

.PHONY: clean

all: pandocpdf pandochtml

epsfiles:
	$(foreach d,$(wildcard *.dot),dot -Teps $(d) -o $(d:.dot=.eps);)

pandocpdf: epsfiles
	pandoc -H header.txt cse150_notes.md -o cse150_notes.pdf

pandochtml: epsfiles
	pandoc -s -thtml5 cse150_notes.md -o cse150_notes.html

pandoctex: epsfiles
	pandoc -s -H header.txt -thtml5 cse150_notes.md -o cse150_notes.html

notes: pandocpdf


homework%eps: homework% 
	#homework%/*.dot
	#$(hwdir=test)

	echo eps: $^
	$(foreach d,$(wildcard $</*.dot),dot -Teps $(d) -o $(d:.dot=.eps) & ) \
	wait

#%.eps: %.dot
#	echo $^

homework%pdf: homework% homework%/*.md homework%/header.txt homework%eps
	#$(foreach d,$(homework%/*.dot),$(d:.dot=.eps))
	#homework%eps 
	$(hwdir=test)
	echo $(hwdir)
	cd $<; \
	$(foreach d,$(wildcard $</*.md),pandoc -H header.txt ../$d -o ../$(d:.md=.pdf); )

#homework%/*.pdf

hw%: homework% homework%pdf
	echo done

clean:
	git clean -x -d -n
	@/bin/echo -n "Purge files? [y/n] "
	read continue; \
	if [ "$$continue" = "y" ]; then \
		git clean -x -d -f; \
	fi
