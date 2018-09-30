ENTRY(_start)
OUTPUT_FORMAT(binary)

SECTIONS {
	. = 0x800;

	.text BLOCK(0x800) : ALIGN(0x800) {
		*(.sector0)
		*(.text)
	}
}
