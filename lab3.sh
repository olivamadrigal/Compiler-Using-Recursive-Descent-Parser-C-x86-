
#!/bin/bash
# shell script for testing compiler
# PARSER.l is lex / flex file with expression grammar
lex PARSER.l
gcc -o myCompiler lex.yy.c
echo -n " ( 5 * 7 \ 3 + 1 ) " | ./myCompiler  
nasm -f elf ASSEMBLY_FILE.asm 
gcc -m32 ASSEMBLY_FILE.o -o arithmeticProgram
./arithmeticProgram
