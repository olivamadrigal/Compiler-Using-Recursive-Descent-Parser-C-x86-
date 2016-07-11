ASSEMBLY_FILE.asm
### Sample assembly file generated for test expression ( 5 * 7 \ 3 + 1 ) 

SECTION .data
Number: db   "Num: %d",10,0
operand1: dd 0
operand2: dd 0
result: dd 0
SECTION .bss
SECTION .text
extern  printf 
global main 
main:
nop
push ebp
mov  ebp,esp
push ebx 
push esi
push edi
	push dword 5		; Push constant 5
	push dword 7		; Push constant 7
	pop eax
	pop ebx
	imul ebx
	push eax
	push dword 3		; Push constant 3
	pop ecx
	pop eax
	idiv ecx
	push eax
	push dword 1		; Push constant 1
	pop eax
	pop ebx
	add eax, ebx
	push eax
	push Number
	call printf
	add esp,8
pop edi
pop esi
pop ebx
mov esp,ebp
pop ebp
ret

