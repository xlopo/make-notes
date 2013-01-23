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
HEADER_FILE = $(dir $@)header.txt
%.pdf: %.md $$(EPS_TARGETS)
	if [ -f $(HEADER_FILE) ]; then \
		cd $(dir $@); pandoc -H $(notdir $(HEADER_FILE)) $(notdir $<) -o $(notdir $@); \
	else \
		cd $(dir $@); pandoc $(notdir $<) -o $(notdir $@); \
	fi


%.html: %.md $$(EPS_TARGETS)
	pandoc -s -thtml5 $< -o $@

%.eps: %.dot
	dot -Teps $< -o $@

clean:
	git clean -x -d -n
	@/bin/echo -n "Purge file(s)? [y/n] "
	@read continue; \
	if [ "$$continue" = "y" ]; then \
		git clean -x -d -f; \
	fi
