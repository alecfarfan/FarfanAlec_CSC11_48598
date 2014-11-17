/* array.s */

.data
a: .skip 64
format: .asciz "%c "
format2: .asciz "%c "
format3: .asciz "%c"
endl: .asciz "\n"

.text

.global main
main:

	PUSH {LR}

	LDR R4, address_a
	MOV R5, #0
	MOV R8, #'+'
	MOV R9, #'-'
	BL makeBoard
	BL print

	POP {LR}
	BX LR

/* Beggining of makeBoard subroutine */
makeBoard:
	PUSH {LR}
	BAL loop

loop:
	CMP R5, #64
	BEQ fillW
	ADD R6, R4, R5
	STR R8, [R6]

	MOV R0, R5
	MOV R1, #8
	BL mod
	CMP R0, #7
	BLEQ swap

	BL swap
	ADD R5, R5, #1
	BAL loop

swap:
	PUSH {LR}
	
	MOV R10, R8
	MOV R8, R9
	MOV R9, R10

	POP {LR}
	BX LR
fillW:
	MOV R5, #0
	MOV R6, #0
fillLoopW:
	CMP R5, #16
	BEQ fillB

	ADD R6, R4, R5
	LDRB R8, [R6]

	CMP R8, #43
	BEQ changeW

	ADD R5, R5, #1
	BAL fillLoopW
changeW:
	mov r7, #'o'
	ADD R6, R4, R5
	STRB R7, [R6]
	ADD R5, R5, #1
	BAL fillLoopW
fillB:
	MOV R5, #48
	MOV R6, #0
fillLoopB:
	CMP R5, #64
	BEQ end

	ADD R6, R4, R5
	LDRB R8, [R6]

	CMP R8, #43
	BEQ changeB

	ADD R5, R5, #1
	BAL fillLoopB
changeB:
	mov r7, #'*'
	ADD R6, R4, R5
	STRB R7, [R6]
	ADD R5, R5, #1
	BAL fillLoopB

/* End of makeBoard subroutine */

/* Beginning of mod subroutine */
mod:
	PUSH {LR}

	MOV R3, #0
	BAL check

check:
	CMP R0, R1
	BGT subtract

	POP {LR}
	BX LR

subtract:
	ADD R3, R3, #1
	SUB R0, R0, R1
	BAL check

/* End of mod subroutine */

/* Beginning of print subroutine */
print:
	PUSH {LR}
	LDR R4, address_a
	MOV R5, #0
	MOV R6, #0
	BAL printLoop

printLoop:
	CMP R5, #64
	BEQ end

	ADD R6, R4, R5
	ldrb r6, [r6]
	mov r1, r6
	LDR R0, address_format2
	BL printf

	MOV R0, R5
	MOV R1, #8
	BL mod
	CMP R0, #7
	BLEQ endline

	ADD R5, R5, #1
	BAL printLoop

endline:
	PUSH {LR}

	LDR R0, address_format3
	LDR R1, address_endl
	LDR R1, [R1]
	BL printf

	POP {LR}
	BX LR

end:
	POP {LR}
	BX LR


address_a: .word a
address_endl: .word endl
address_format: .word format
address_format2: .word format2
address_format3: .word format3
