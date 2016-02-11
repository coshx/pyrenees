repo = https://github.com/coshx/pyrenees

all: clean build

build:
	git clone $(repo) src
	cd src; jazzy \
	  --author "Coshx Labs" \
	  --author_url http://www.coshx.com/ \
	  --github_url $(repo) \
	  --root-url https://coshx.github.io/pyrenees/ \
	  --module-version 1.1.0 \
	  --x -project,pyrenees.xcodeproj \
	  --output ../ \
	  --theme fullwidth
	rm -rf src

clean:
	rm -rf Classes* Enums* css js img docsets index.html undocumented.txt src