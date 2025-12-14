install:
	dart build cli
	cp build/cli/linux_x64/bundle/bin/manuprep $(HOME)/.local/bin/manuprep

draft:
	rm output -rf
	dart run manuprep sample-input/manuscript.tex output
