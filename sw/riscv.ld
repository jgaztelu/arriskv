ENTRY(_start)

MEMORY
{
    rom (rx ): ORIGIN = 0x00001000, LENGTH = 16M
    ram (rw): ORIGIN = 0x10000000, LENGTH = 32M
}

SECTIONS
{
    .text : {
        /*
            entry point is expected to be the first function here
            --> we are assuming there's only a single function in the .text.boot segment and by convention that is "_start"

            KEEP ensures that "_start" is kept here, even if there are no references to it
        */
        KEEP(*(.text.boot))

        /*
            all other code follows
        */
        *(.text*)
    } > rom

    .rodata : { *(.rodata*) } > rom

    .bss : { *(.bss*) } > ram
}