@ Isaiah Harville
@ 2/16/2024
@  

.data

.balign 4
welcome_msg: .asciz "\n\nPlease enter your operation (AND, ORR, EOR, BIC) followed by two hexadecimal numbers one at a time.\n"

.balign 4 
instruction_prompt: .asciz "(a=AND, o=ORR, e=EOR, b=BIC):\n"

.balign 4
num_instruction_prompt: .asciz "\nHEX:\n"

.balign 4
continue_prompt: .asciz "Perform another calculation?:\n"

.balign 4
hex_format: .asciz "%x"

.balign 4
c_format: .asciz " %c"

.balign 4 
result_msg: .asciz "Result: %x\n"

.balign 1
op_type: .byte 0

.balign 1
continue: .byte 0

.balign 4
op1: .space 33

.balign 4
op2: .space 33

.balign 4
error_msg: .asciz "Error!\n"


.global main
.extern printf, scanf

.text
main:
	@ Print Intro
	ldr r0, =welcome_msg
	bl printf

	@ Get First Number
	ldr r0, =num_instruction_prompt
	bl printf
	ldr r0, =hex_format
	ldr r1, =op1
	bl scanf
	cmp r0, #1
	bne error
	ldr r0, #1
	

	@ Get OP
	ldr r0, =instruction_prompt
   	bl printf
    	ldr r0, =c_format
    	ldr r1, =op_type
    	bl scanf
	cmp r0, #1
	bne error
	ldr r0, #1

	@ Get Second Number
    	ldr r0, =num_instruction_prompt
    	bl printf
    	ldr r0, =hex_format
    	ldr r1, =op2
    	bl scanf
	cmp r0, #1
	bne error
	ldr r0, #1

	@ Load scanned inputs from memory
    	ldr r4, =op1
    	ldr r4, [r4]
    	
	ldr r5, =op2
    	ldr r5, [r5]
    	
	ldr r6, =op_type
    	ldrb r6, [r6]

	push {r4, r5, lr}
	bl operations @ Perform operation 
	pop {r4, r5, lr}

	@ Print Result
   	mov r1, r7 @ Load value from r7
    	ldr r0, =result_msg
    	bl printf

	@ Prompt to continue
	ldr r0, =continue_prompt
	bl printf
	ldr r0, =c_format
	ldr r1, =continue
	bl scanf
	ldr r1, =continue
	ldrb r1, [r1]

	@ Compare Input from prompt
	cmp r1, #'y'
	beq main @ Continue
	cmp r1, #'Y'
	beq main

	@ Exit if not y/Y
	mov r0, #0
	mov r7, #1
	svc 0
	
operations:
	@ Branch to op subroutine
        cmp r6, #'a'    @ BITWISE AND
        beq and_subroutine
        cmp r6, #'o'    @ BITWISE OR
        beq or_subroutine
        cmp r6, #'e'    @ BITWISE XOR
        beq eor_subroutine
        cmp r6, #'b'    @BITWISE BIC
        beq bic_subroutine
	bx lr

and_subroutine:
	and r7, r4, r5	@ AND and store r7
	bx lr		@ Return

or_subroutine:
	orr r7, r4, r5	@ OR, r7
	bx lr		@ Return

eor_subroutine:
	eor r7, r4, r5	@ XOR, r7
	bx lr		@ Return

bic_subroutine:
	bic r7, r4, r5	@ BIC, r7
	bx lr

error:
	ldr r0, =error_msg
	bl printf
	ldr r0, #1
	b main
@ EOF

