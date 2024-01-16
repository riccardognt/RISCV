# Design of a RISC-V-lite processor
The main purpose of this lab was to design in VHDL a RISC-V-lite processor with 5 pipeline stages where the instructions supported by this processor are a subset of the whole RV32I which has a 32-bit fixed-width instruction set. 
In particular, this subset is defined by the instructions required to execute the "minv" application given as specification.

## Contenuto delle directory
nella cartella minv-project sono presenti i file relativi alla compilazione e alla generazione del codice sorgente. 
		---il file che contiene il codice assembly da eseguire nel simulatore è "program.asm"
		--- nella cartella crypt invece sono presenti i codici di encryption 

nella cartella RTL sono presenti:
		--- la cartella crypt che contiene la versione del RISCV con l'estensione dell'encryption.
		--- la cartella no_crypt contiene la versione del RISCV senza l'encryption

