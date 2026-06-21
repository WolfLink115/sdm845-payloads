ARCH              = arm64
TARGET            = aarch64-linux-gnu
CC                = clang
CFLAGS            = --target=$(TARGET)
OBJCOPY           = llvm-objcopy

all: coyote.elf coyote.bin

coyote.bin: coyote.elf
	$(OBJCOPY) -O binary $< $@
	rm coyote.elf

coyote.elf: coyote.S
	$(CC) ${CFLAGS} -c $< -o $@

coyote.S:
