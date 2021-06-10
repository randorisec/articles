## Return oriented programming 101
L'article en [pdf](https://github.com/randorisec/articles/blob/master/MISCHS22-ROP-101/MISCHS22-ROP-101.pdf)

### Auteur
Brendan Guevel

### Synopsis
Le Returned Oriented Programming (ou ROP) est une technique permettant d'exploiter des programmes disposant de la protection NX (No eXecute) ou DEP (Data Execution Prevention). L'objectif de cet article est de vous présenter les bases du ROP, ainsi que l’exploitation pas-à-pas d’un programme d’entraînement via l'utilisation de la bibliothèque python pwntools [1]. Dans un souci de simplicité, la démonstration sera réalisée sur un programme s'exécutant sur un système Linux 64 bits. Bien entendu, cette démonstration reste applicable sur d'autres architectures (ARM, MIPS, etc.).

### Les liens
[1] http://docs.pwntools.com/en/stable/index.html

[2] https://en.wikipedia.org/wiki/NX_bit

[3] https://en.wikipedia.org/wiki/Buffer_overflow_protection#Canaries

[4] https://en.wikipedia.org/wiki/Position-independent_code

[5] https://made0x78.com/bseries-how-to-leak-data/

[6] https://github.com/JonathanSalwan/ROPgadget

[7] https://github.com/Gr0minet/rop_example

[8] https://www.redhat.com/en/blog/hardening-elf-binaries-using-relocation-read-only-relro

[9] https://github.com/niklasb/libc-database
