out=build
source:=$(shell cat source-urls.txt)
filename=ledger-tutorial
metadata=metadata.xml

all: epub mobi

retrieve:
	mkdir -p $(out)
	cd $(out); for i in $(source); do curl -L -O $$i; done

postprocess:
	sed -i \
		-e "s/^Title:/#/" \
		-e "/^Date:/d" \
		-e "/^Tags:/d" \
		-e "/^Id:/d" \
		-e "/^--fold--$$/d" \
		$(out)/*.md

epub:
	mkdir -p $(out)
	pandoc --from markdown+smart --to=epub \
		--epub-metadata=$(metadata) \
		--toc --output=$(out)/$(filename).epub $(out)/*.md

mobi: epub
	kindlegen $(out)/$(filename).epub

.PHONY: all epub mobi retrieve postprocess
