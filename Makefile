DESTDIR ?= $(shell pwd)/sysroot
DESTISO ?= $(shell pwd)/mk2018.iso

export DESTDIR

.PHONY: all clean iso run-qemu

all:
	$(MAKE) -C boot all
	$(MAKE) -C boot install

clean:
	$(MAKE) -C boot clean

iso:
	xorriso -as mkisofs \
	-b boot/cd/boot.bin -no-emul-boot -boot-load-size 4 -boot-info-table \
	-o $(DESTISO) $(DESTDIR)

run-qemu:
	qemu-system-i386 -m 64 -cdrom $(DESTISO)
