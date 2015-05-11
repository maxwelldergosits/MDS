.PHONY: doc clean-doc update-readme
DOC=doc
DIAGRAM_SOURCE=system-diagram.dot
DIAGRAM_OUT=$(DIAGRAM_SOURCE:.dot=.svg)
README=README.md

doc: $(DIAGRAM_OUT)
update-readme: $(README)
clean-doc:
	@echo moving to $(DOC);
	@cd $(DOC)&&\
	rm -f $(DIAGRAM_OUT)

$(DIAGRAM_OUT):
	@echo moving to $(DOC)
	@cd $(DOC)&&\
	dot -Tsvg -o$(DIAGRAM_OUT) $(DIAGRAM_SOURCE)


$(README):
	cp $(DOC)/$(README) $(README)
