install:
	dart build cli
	cp build/cli/linux_x64/bundle/bin/submission_prep $(HOME)/.local/bin/submission-prep

draft:
	rm output -rf
	dart run bin/submission_prep.dart -i sample-input/manuscript.tex -o output
