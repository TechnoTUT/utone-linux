.PHONY: all config build clean purge submodule help

IMAGE_NAME ?= technotut-utone-live
DISTRIBUTION ?= trixie
ARCHIVE_AREAS ?= main non-free non-free-firmware contrib
BOOTAPPEND_LIVE ?= boot=live components splash persistence

help:
	@echo "Usage:"
	@echo "  make build       - Configure and build the ISO image"
	@echo "  make config      - Run lb config"
	@echo "  make clean       - Clean temporary build files"
	@echo "  make purge       - Completely clean build files and caches"
	@echo "  make submodule   - Initialize and update git submodules"

submodule:
	git submodule update --init --recursive

config: submodule
	cd work && lb config \
		--distribution '$(DISTRIBUTION)' \
		--archive-areas '$(ARCHIVE_AREAS)' \
		--bootappend-live '$(BOOTAPPEND_LIVE)' \
		--image-name '$(IMAGE_NAME)'

build: config
	cd work && sudo lb build

clean:
	cd work && sudo lb clean

purge:
	cd work && sudo lb clean --purge
