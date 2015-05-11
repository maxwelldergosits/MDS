.PHONY: doc clean-doc update-readme html
DOC=doc
DIAGRAM_SOURCE=system-diagram.dot
DIAGRAM_OUT=$(DIAGRAM_SOURCE:.dot=.svg)
README_MD=README.md
README_HTML=README.html

doc: $(DIAGRAM_OUT) $(README)
update-readme: $(README_MD) $(DIAGRAM_OUT)
html: $(README_MD) $(README_HTML)
clean-doc:
	rm -f $(README_HTML)
	@echo moving to $(DOC);
	@cd $(DOC)&&\
	rm -f $(DIAGRAM_OUT)

$(DIAGRAM_OUT):
	@echo moving to $(DOC)
	@cd $(DOC)&&\
	dot -Tsvg -o$(DIAGRAM_OUT) $(DIAGRAM_SOURCE)

.PHONY: $(README_MD)
$(README_MD):
	cp $(DOC)/$(README_MD) $(README_MD)

.PHONY: $(README_HTML)
$(README_HTML):
	pandoc -o $(README_HTML) $(README_MD)
