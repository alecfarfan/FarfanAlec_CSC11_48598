/* array.s */

.data
a: .skip 64
format: .asciz "%c "
endl: .asciz "\n"

.text
@.global array
@array:

.global main
main:
	PUSH {LR}
	LDR R4, address_a
	MOV R5, #0
	MOV R8, #'+'
	MOV R9, #'-'

loop:
	CMP R5, #64	
	BEQ end
	ADD R6, R4, R5
	MOV R6, R8

	LDR R0, address_format
	MOV R1, R6
	BL printf

	@ADD R5, R5, #1
	@AND R7, R5, #1
	@CMP R7, #0
	BAL swap

	ADD R5, R5, #1
	BAL loop

swap:
	MOV R10, R8
	MOV R8, R9
	MOV R9, R10
	ADD R5, R5, #1
	BAL loop

end:
	POP {LR}
	BX LR

address_a: .word a
address_format: .word format
