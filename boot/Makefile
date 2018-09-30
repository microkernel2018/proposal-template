DESTDIR ?=
BOOTDIR ?= /boot

CFLAGS ?= -O2 -g
CFLAGS += -Wall -Wextra -ffreestanding -nostdlib

OBJS_CD := \
cd/_start.o

BIN_CD := cd/boot.bin

.PHONY: all clean install
.SUFFIXES: .c .o .S

all: $(BIN_CD)

clean:
	rm -f $(OBJS_CD)
	rm -f $(OBJS_CD:.o=.d)
	rm -f $(BIN_CD)

install:
	mkdir -p $(DESTDIR)$(BOOTDIR)/cd
	cp $(BIN_CD) $(DESTDIR)$(BOOTDIR)/cd

$(BIN_CD): $(OBJS_CD)
	$(CC) $(CFLAGS) -T cd/linker.ld -o $@ $(OBJS_CD) -lgcc

.S.o:
	$(CC) -MD $(CFLAGS) -c -o $@ $<

-include $(OBJS_CD:.o=.d)
