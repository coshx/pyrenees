repo = https://github.com/coshx/pyrenees

all: clean build

build:
	git clone $(repo) src
	cd src; jazzy \
	  --author "Coshx Labs" \
	  --author_url http://www.coshx.com/ \
	  --github_url $(repo) \
	  --root-url https://coshx.github.io/pyrenees/ \
	  --module-version 0.3.1 \
	  --x -project,pyrenees.xcodeproj \
	  --module pyrenees \
	  --output ../ \
	  --theme fullwidth
	rm -rf src

clean:
	rm -rf Classes* Enums* Extensions* Protocols* Functions* css js img docsets index.html undocumented.txt src