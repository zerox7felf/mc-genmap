.PHONY: build

build:
	docker build mc-mapgen -t mc-mapgen
	docker build mc-mapgen-lighttpd -t mc-mapgen-lighttpd
