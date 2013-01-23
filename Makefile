VALID_TARGETS := $(subst /,,$(wildcard */))
VALID_TARGETS += .

.PHONY: $(VALID_TARGETS)

all: .
	@echo done

.SECONDEXPANSION:
MD_FILES=$(wildcard $@/*.md)
PDF_TARGETS=$(MD_FILES:.md=.pdf)
$(VALID_TARGETS): $$(PDF_TARGETS)

.SECONDEXPANSION:
DOT_FILES = $(wildcard $(dir $@)*.dot)
EPS_TARGETS = $(DOT_FILES:.dot=.eps)
%.pdf: %.md $$(EPS_TARGETS)
	pandoc $< -o $@

%.html: %.md $$(EPS_TARGETS)
	pandoc -thtml5 $< -o $@

%.eps: %.dot
	dot -Teps $< -o $@

clean:
	git clean -x -d -n
	@/bin/echo -n "Purge files? [y/n] "
	read continue; \
	if [ "$$continue" = "y" ]; then \
		git clean -x -d -f; \
	fi

# none:
# 	echo $(VALID_TARGETS)



# $(VALID_TARGETS): 
# 	echo $@

# %.md:
# 	echo $@ $^

# all: pandocpdf pandochtml

# epsfiles:
# 	$(foreach d,$(wildcard *.dot),dot -Teps $(d) -o $(d:.dot=.eps);)

# pandocpdf: epsfiles
# 	pandoc -H header.txt cse150_notes.md -o cse150_notes.pdf

# pandochtml: epsfiles
# 	pandoc -s -thtml5 cse150_notes.md -o cse150_notes.html

# pandoctex: epsfiles
# 	pandoc -s -H header.txt -thtml5 cse150_notes.md -o cse150_notes.html

# notes: pandocpdf


# homework%eps: homework% 
# 	#homework%/*.dot
# 	#$(hwdir=test)

# 	echo eps: $^
# 	$(foreach d,$(wildcard $</*.dot),dot -Teps $(d) -o $(d:.dot=.eps) & ) \
# 	wait

# #%.eps: %.dot
# #	echo $^

# homework%pdf: homework% homework%/*.md homework%/header.txt homework%eps
# 	#$(foreach d,$(homework%/*.dot),$(d:.dot=.eps))
# 	#homework%eps 
# 	$(hwdir=test)
# 	echo $(hwdir)
# 	cd $<; \
# 	$(foreach d,$(wildcard $</*.md),pandoc -H header.txt ../$d -o ../$(d:.md=.pdf); )

# #homework%/*.pdf

# hw%: homework% homework%pdf
# 	echo done
