env = sandbox
.PHONY: help sass icons tools deps assets init test run repl
# HELP sourced from https://gist.github.com/prwhite/8168133

# Add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUNC = \
    %help; \
    while(<>) { \
        if(/^([a-z0-9_-]+):.*\#\#(?:@(\w+))?\s(.*)$$/) { \
            push(@{$$help{$$2}}, [$$1, $$3]); \
        } \
    }; \
    print "usage: make [target]\n\n"; \
    for ( sort keys %help ) { \
        print "$$_:\n"; \
        printf("  %-20s %s\n", $$_->[0], $$_->[1]) for @{$$help{$$_}}; \
        print "\n"; \
    }

help: ##@Miscellaneous Show this help.
	@perl -e '$(HELP_FUNC)' $(MAKEFILE_LIST)

# Hidden@Setup Clarity Icons
icons:
	$(info Installing Clarity Icons...)
	npm install @webcomponents/custom-elements@1.0.0 --save
	cp node_modules/@webcomponents/custom-elements/custom-elements.min.js resources/public/js/custom-elements.min.js
	npm install @clr/icons@4.0.3 --save
	cp node_modules/@clr/icons/clr-icons.min.css resources/public/css/clr-icons.min.css
	cp node_modules/@clr/icons/clr-icons.min.js resources/public/js/clr-icons.min.js
	rm -rf node_modules

txt-clean: ##@Setup Remove all TXT-related directories
	rm -rf txt/pali   && mkdir -p txt/pali   && touch txt/pali/.keep
	rm -rf txt/buddha && mkdir -p txt/buddha && touch txt/buddha/.keep
	rm -rf txt/dohas  && mkdir -p txt/dohas  && touch txt/dohas/.keep
	rm -rf /tmp/daily_emails_rss_auto

txt-clone: ##@Setup Copy TXT files from private repo
	./bin/copy-txt-files.sh
