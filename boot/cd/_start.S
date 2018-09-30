.section .sector0
.global _start

.code16

_start:
	# Jump past the Boot Info Table.
	# Note: We don't use the "boot" label, since addresses understood
	# by the linker start from 0x0800, while we have been loaded to 0x7C00
	# and will relocate to 0x0800 later.
	ljmp $0x0000, $0x7C40

	.skip 8 - (. - _start), 0x00

bootinfo:
	.long 0        # LBA of PVD.
	.long 0        # LBA of boot file.
	.long 0        # Length of boot file.
	.long 0        # Checksum of boot file.
	.skip 40, 0x00 # Reserved.

boot:
	# Clear interrupts and direction.
	cli
	cld

	# Set stack to 0x1000:0x0000. Pushing a word to it will cause it
	# to wrap up to 0x1000:0xFFFE.
	movw $0x1000, %ax
	movw %ax, %ss
	xorw %sp, %sp

	# Relocate (2048 bytes) from 0x0000:0x7C00 to 0x0000:0x0800.
	xorw %ax, %ax
	movw %ax, %ds
	movw $0x7C00, %si

	movw %ax, %es
	movw $0x0800, %di

	movw $2048, %cx

	rep movsb

	# Jump to relocated.
	ljmp $0x0000, $1f

1:
	# Restore interrupts.
	sti

	# Print the string.
	# Note: DS is already set to 0x0000 from before.
	movw $string, %si
	call print

2:
	# Halt.
	cli
	hlt
	jmp 2b

print:
	pushf
	pushw %ax
	pushw %bx
	pushw %si

	movb $0x0E, %ah
	movw $0x0007, %bx

1:
	lodsb
	testb %al, %al
	jz 2f
	int $0x10
	jmp 1b

2:
	popw %si
	popw %bx
	popw %ax
	popf
	ret

string:
	.asciz "ELTORITO!"

	.skip 2046 - (. - _start), 0x00
	.byte 0x55
	.byte 0xAA
