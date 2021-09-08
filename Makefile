build:
	docker build . -t dai-clip

run:
	docker run -it -v $(shell pwd):/app dai-clip ruby dai_clip.rb --asset_key=$(ASSET_KEY) --offset=$(OFFSET) --bitrate=$(BITRATE) --domain=$(DOMAIN)

console:
	docker run -it -v $(shell pwd):/app dai-clip bash
