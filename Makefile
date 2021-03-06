DOC=doc
DIAGRAM_SOURCE=system-diagram.dot
DIAGRAM_OUT=$(DIAGRAM_SOURCE:.dot=.svg)
README_MD=README.md
README_HTML=README.html

.PHONY: doc
doc: $(DIAGRAM_OUT) $(README_MD)

.PHONY: update-readme
update-readme: $(README_MD) $(DIAGRAM_OUT)

.PHONY: html
html: $(README_MD) $(README_HTML)


.PHONY: clean-doc
clean-doc:
	rm -f $(README_HTML)
	@echo moving to $(DOC);
	@cd $(DOC)&&\
	rm -f $(DIAGRAM_OUT)


.PHONY: $(README_MD)
$(DIAGRAM_OUT):
	@echo moving to $(DOC)
	@cd $(DOC)&&\
	dot -Tsvg -o$(DIAGRAM_OUT) $(DIAGRAM_SOURCE)

.PHONY: $(README_MD)
$(README_MD): $(DOC)/$(README_MD)
	cp $(DOC)/$(README_MD) $(README_MD)

.PHONY: $(README_HTML)
$(README_HTML): $(README_MD)
	pandoc -o $(README_HTML) $(README_MD) -c $(DOC)/style.css
