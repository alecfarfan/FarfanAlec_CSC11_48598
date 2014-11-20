/* array.s */

.data
a: .skip 64
h: .asciz "--------\n"
header: .asciz "   | A | B | C | D | E | F | G | H |\n"
border: .asciz "___|___|___|___|___|___|___|___|___|\n"
format: .asciz "%s"
format2: .asciz " %c |"
format3: .asciz "%c"
formatd: .asciz "%d  |"
endl: .asciz "\n"
choicePrompt1: .asciz "Enter the letter/number coordinate to select a gamepiece:"
choicePrompt2: .asciz "Enter the letter/number coordinate to move to that square:"
choice: .word 0
player: .asciz "Player %d\n"
invalid1: .asciz "Error. Must select one's own gamepiece\n"

.text

.global main
main:
	PUSH {LR}

	LDR R4, address_a
	MOV R5, #0
	MOV R8, #'+'
	MOV R9, #'-'
	MOV R11, #6
	MOV R12, #6
	MOV R10, #0

	BL makeBoard
match:
	BL print
	BL prompt
	BL update
	BL print
	ADD R10, R10, #1
	CMP R10, #3
	BNE match

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
	
	MOV R7, R8
	MOV R8, R9
	MOV R9, R7

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
	BGE subtract

	POP {LR}
	BX LR

subtract:
	ADD R3, R3, #1
	SUB R0, R0, R1
	BAL check

/* End of mod subroutine */

/* Beginning of div subroutine */
div:
	PUSH {LR}

	MOV R3, #0
	BAL divCheck

divCheck:
	CMP R0, R1
	BGE divSubtract
	MOV R0, R3

	POP {LR}
	BX LR

divSubtract:
	ADD R3, R3, #1
	SUB R0, R0, R1
	BAL divCheck

/* End of div subroutine */

/* Beginning of print subroutine */
print:
	PUSH {LR}

	LDR R0, address_header
	BL printf
	LDR R0, address_border
	BL printf

	LDR R4, address_a
	MOV R5, #0
	MOV R6, #0
	BAL printLoop

printLoop:
	CMP R5, #64
	BEQ end

	MOV R0, R5
	MOV R1, #8
	BL mod
	CMP R0, #0
	BLEQ rowNum

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

	LDR R0, address_border
	BL printf

	POP {LR}
	BX LR

rowNum:
	PUSH {LR}
	MOV R0, R5
	MOV R1, #8
	BL div
	ADD R0, R0, #1
	MOV R1, R0

	LDR R0, address_formatd
	
	BL printf

	POP {LR}
	BX LR

/* End of print subroutine */

/* Beginning of prompt subroutine */
prompt:
	PUSH {LR}

checks:
	MOV R0, R10
	MOV R1, #2
	BL mod
	MOV R1, R0
	ADD R1, R1, #1
	MOV R3, R1
	LDR R0, address_player
	BL printf

	LDR R0, address_choicePrompt1
	BL printf
	LDR R0, address_format
	LDR R1, address_choice
	BL scanf
	BL getIndex
	
	CMP R3, #1
	BLEQ validSelect1
	CMPEQ R1, #1
	BEQ checks

	CMP R3, #2
	BLEQ validSelect2
	CMP R1, #1
	BEQ checks
	PUSH {R0}

	LDR R0, address_choicePrompt2
	BL printf
	LDR R0, address_format
	LDR R1, address_choice
	BL scanf
	BL getIndex
	MOV R1, R0
	POP {R0}

	POP {LR}
	BX LR

getIndex:
	PUSH {LR}

	LDR R1, address_choice
	LDRB R2, [R1,#0]
	LDRB R3, [R1,#1]
	
	CMP R2, #96
	SUBGT R2, R2, #97
	SUBLT R2, R2, #65
	SUB R3, R3, #49
	MOV R5, #8
	MUL R6, R3, R5
	ADD R6, R6, R2
	MOV R0, R6

	POP {LR}
	BX LR

validSelect1:
	PUSH {R5,LR}

	ADD R5, R4, R0
	LDRB R2, [R5]
	CMP R2, #'*'
	BLNE invalidSelect
	MOVEQ R1, #0
	MOVNE R1, #1

	POP {R5,LR}
	BX LR

validSelect2:
	PUSH {R5,LR}

	LDR R4, address_a
	ADD R5, R4, R0
	LDRB R2, [R5]

	CMP R2, #'o'
	BLNE invalidSelect
	MOVNE R1, #1
	MOVEQ R1, #0

	POP {R5,LR}
	BX LR

invalidSelect:
	PUSH {LR}

	LDR R0, address_invalid1
	BL printf

	POP {LR}
	BX LR

/* End of prompt subroutine */

/* Beginning of update subroutine */
update:
	PUSH {LR}
	
	LDR R4, address_a
	ADD R2, R4, R0
	LDRB R3, [R2]
	MOV R5, R3

	ADD R2, R4, R1
	LDRB R3, [R2]
	STRB R5, [R2]
	ADD R2, R4, R0
	STRB R3, [R2]

	POP {LR}
	BX LR

/* End of update subroutine */

end:
	POP {LR}
	BX LR

/* Data addresses */
address_a: .word a
address_headline: .word h
address_header: .word header
address_border: .word border
address_endl: .word endl
address_format: .word format
address_format2: .word format2
address_format3: .word format3
address_formatd: .word formatd
address_choicePrompt1: .word choicePrompt1
address_choicePrompt2: .word choicePrompt2
address_choice: .word choice
address_player: .word player
address_invalid1: .word invalid1
