# Compiler-Using-Recursive-Descent-Parser-C-x86-

DESCRIPTION:
Extension of Lab 6 (Arithmetic Grammar Top-Down Parser). Lab builds a complete compiler 
implementing a top-down recursive descent parser for a right-recursive version grammar. 
Compiler outputs an x86 assembly file of the program using the stack to compute postfix 
arithmetic expressions. The assembly file produced is then compiled into a full program 
via NASM and gcc which is then executed to output the results.


	
	• PARSER.l  := 	lex /flex file with expression grammar
	• lab3.sh   :=  shell script for testing compiler
	• ASSEMBLY_FILE.asm  := file with sample output

# Compiler: 

1. $lex PARSER.l

3. $gcc -o myCompiler lex.yy.c

5. $echo EXPRESSION | ./myCompiler

# Test assmebly code generated by compiler: 
7. nasm -f elf ASSEMBLY_FILE.asm

9. gcc -m32 ASSEMBLY_FILE.asm arithProg

11. ./arithProg
