# Design of a RISC-V-lite processor
The main purpose of this lab was to design in VHDL a RISC-V-lite processor with 5 pipeline stages where the instructions supported by this processor are a subset of the whole RV32I which has a 32-bit fixed-width instruction set. 
In particular, this subset is defined by the instructions required to execute the "minv" application given as specification.

## The "minv-project" directory
In "minv-project" folder there are files on the compilation and generation of the source code. In practice the application that must run on the developed RISC-V processor is made of 3 files: "main.c", "minv.h" and "minv.c". This code, given an array of numbers makes the absolute value of them and find the maximum among them.
The process to obtain the wanted instructions is now described. The first step is to rely on a RISC-V version of gcc ("riscv32-unknown-elf-gcc") to generate the executable file from the main application; to do this, the compiler requires information about the memory organization and a preamble to initialize registers. The registers initialization is performed by the "crt0.s" file that defines the start symbol which represents the address of the first instruction to execute. The information about the memory organization is performed by the linked script: a file named "riscV32-isa.ld" which sets the first address at 0x00400000 for the instruction ROM memory, and 0x10010000 for the data RAM. It sets also the global pointer to 0x100008000, the stack pointer to 0x7fffeffc and assigns each segment of the program to the correct memory type.
After generating the executable with the RISC-V version of gcc, we relied on the disassembler to convert the executable file into a text file. In particular, from the executable file it was necessary to extract both the sequence of instructions with the corresponding address and the data. The obtained files from this procedure are the main.hex and data.hex.
The final goal with the data and instructions obtained by compiling the application is to generate an assembly file ready to be simulated with the RISC-V simulator named RARS. To do this 2 codes (named "extract code.sh" and "extract data.sh") have been utilized to extract the binary executable in hexadecimal format from the "main.hex" file and the data from the "data.hex" one. The resulting files are the "main.asm" and the "data.txt".
From these last two files, the final "program.asm file", which was used for the simulation in RARS, has been obtained by taking these two files and apply some minor editing.
The program RARS simulates the execution of these instructions, updating the register file and data memory at every iteration, representing a reference for how the structures in the RISC-V architecture have to behave for every instruction.

## "crypt" and "no_crypt"
nella cartella minv-project sono presenti i file relativi alla compilazione e alla generazione del codice sorgente. 
- Il file che contiene il codice assembly da eseguire nel simulatore è "program.asm".
- Nella cartella crypt invece sono presenti i codici di encryption.

nella cartella RTL sono presenti:
		--- la cartella crypt che contiene la versione del RISCV con l'estensione dell'encryption.
		--- la cartella no_crypt contiene la versione del RISCV senza l'encryption

