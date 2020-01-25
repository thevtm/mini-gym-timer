HTML_FILEPATH = index.html
ASSET_PATH = public/
ENTRY_FILEPATH = src/App.elm
OUTPUT_FILEPATH = public/elm.js

# Run development environment
dev:
	elm-live $(ENTRY_FILEPATH) --dir $(ASSET_PATH) --start-page $(HTML_FILEPATH) -- --output $(OUTPUT_FILEPATH) --debug

test:
	elm-test

test-watch:
	elm-test --watch

# Build production
build:
	elm make $(ENTRY_FILEPATH) --output $(OUTPUT_FILEPATH) --optimize

# Build development
build-dev:
	elm make $(ENTRY_FILEPATH) --output $(OUTPUT_FILEPATH) --debug

# Deploy
deploy: build
	gh-pages --dist public
