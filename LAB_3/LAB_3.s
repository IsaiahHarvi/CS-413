@ Isaiah Harville
@ 2/25/2024
@ 
@ as -g -o LAB3.o LAB_3.s
@ gcc -g -o LAB3 LAB3.o

.section .data
.balign 16
total_money: .word 0 

.balign 16
input_money: .word 0

.balign 16
selected_drink: .word 0 

.balign 16
drink_inventory: .word 2, 2, 2, 2 

.balign 16
welcome_txt: .asciz "\SELECT DRINK '6' TO SEE INVENTORY\n\nWelcome to The Vending Machine\n"

.balign 16
insert_money_txt: .asciz "\nInsert change (5, 10, 25, 100):\n"

.balign 16
total_money_txt: .asciz "\nTotal is %d cents.\n"

.balign 16
select_drink_txt: .asciz "\nSelect a drink (55c):\n1. Coke\n2. Sprite\n3. Dr. Pepper\n4. Coke Zero\n5. Exit\nEnter choice: "

.balign 16
confirmation_drink_txt: .asciz "\nYou chose %d. Is this correct? (y/n)\n"

.balign 16
invalid_selection_txt: .asciz "\nInvalid selection. Please try again.\n\n"

.balign 16
dispense_txt: .asciz "\nSelection %d has been dispensed with %d change."

.balign 16
out_txt: .asciz "\nSorry! Your selection is out of stock.\n\n"

.balign 16
out_stock_txt: .asciz "\n\n\nSorry! We are all out of stock.\n"

.balign 16
inventory_head_txt: .asciz "\nDRINK  SUPPLY\n"

.balign 16
inventory_txt: .asciz "  %d\t %d\n"

.balign 16
bye_txt: .asciz "Goodbye! Returned %d change.\n"

.balign 16
format_int: .asciz "%d"

.balign 16
format_char: .asciz " %c"

.balign 16
confirm_input: .byte 0



.section .text
.extern printf, scanf
.global main

main:
	LDR R0, =welcome_txt 
	BL printf
	
	@ Get Money
	MOV R4, #0
	B get_money

get_money:
	LDR R0, =insert_money_txt
	BL printf

	LDR R0, =format_int
	LDR R1, =input_money
	BL scanf
	
	LDR R2, =input_money
	LDR R2, [R2]	@ The input amount

    @ Validate the input and update total
    CMP R2, #5          @ Check if input is a nickel
    BEQ update_total
    CMP R2, #10         @ Check if input is a dime
    BEQ update_total
    CMP R2, #25         @ Check if input is a quarter
    BEQ update_total
    CMP R2, #100        @ Check if input is a dollar
    BEQ update_total
	
	@ Invalid 
	B get_money

update_total:
	ADD R4, R4, R2	@ Add the new amount to the total
	LDR R0, =total_money_txt
	MOV R1, R4	@ Load total into R1
	BL printf	@ Print the total amount of money

	CMP R4, #55
	BLT get_money	@ <$0.55
	
	B get_drink	@ >=$0.55

get_drink:
	@ R4: contains the amount of change
	@ R5: contains the selected drink

	@ Confirm there is drinks available
	BL check_stock

	LDR R0, =select_drink_txt
	BL printf
	
	@ Scan in the drink
	LDR R0, =format_int	@ take in an integer
	LDR R1, =selected_drink
	BL scanf

	LDR R5, =selected_drink
	LDR R5, [R5] @ Store selected drink in R5

	@ Prompt if correct choice
	LDR R0, =confirmation_drink_txt
	MOV R1, R5
	BL printf

	@ Get y/n after prompt
	LDR R0, =format_char
	LDR R1, =confirm_input
	BL scanf

	LDR R6, =confirm_input
	LDR R6, [R6] @ Store y/n in R6
	CMP R6, #'y'
	BEQ validate_confirmed_choice
	B get_drink @ user chose 'n'

validate_confirmed_choice: @ Confirm the user input a valid selection
	CMP R5, #1
	BLT invalid_selection
	CMP R5, #5
	BEQ exit_program
	CMP R5, #6
	BEQ display_inventory
	CMP R5, #6
	BGT invalid_selection

confirmed_choice:
	SUB R5, R5, #1  @ Subtract one to zero-base index
	LDR R0, =drink_inventory
	ADD R0, R0, R5, LSL #2	@ calculate address of drinks inventory slot
	LDR R1, [R0]			@ Loading current inventory for the selected drink
	SUB R1, R1, #1			@ Subtracting one

	CMP R1, #0				@ If the selected drink is out of stock
	BLT out_of_stock

	STR R1, [R0]			@ Store the new amount

	SUB R4, R4, #55	@ Subtract 55 from the input change

	LDR R0, =dispense_txt
	MOV R1, R5	    @ Drink choice
	ADD R1, R1, #1  @ 1 base indexing
	MOV R2, R4 		@ left over change
	BL printf

	MOV R4, #0	

	B get_money		@ the user cant get another drink

out_of_stock:
	LDR R0, =out_txt
	BL printf
	B get_drink

check_stock:
	MOV R7, #0 		@ Iterator
	MOV R6, #0		@ Counter

check_stock_loop:
	CMP R7, #4
	BEQ check_stock_done

	LDR R0, =drink_inventory
	ADD R0, R0, R7, LSL #2
	LDR R1, [R0]
	CMP R1, #0
	ADDNE R6, R6, #1
	ADD R7, R7, #1
	B check_stock_loop

check_stock_done:
	CMP R6, #0
	BEQ out_of_stock_exit

	BX LR

out_of_stock_exit:
	LDR R0, =out_stock_txt
	BL printf
	B exit_program

invalid_selection:
	LDR R0, =invalid_selection_txt
	BL printf
	B get_drink

display_inventory:
	MOV R7, #1
	LDR R0, =inventory_head_txt
	BL printf

display_loop:
	CMP R7, #5
	BEQ get_drink

	SUB R7, R7, #1
	LDR R0, =drink_inventory
	ADD R0, R0, R7, LSL #2
	LDR R2, [R0]	@ The inventory at the selected drink

    LDR R0, =inventory_txt
	ADD R7, R7, #1  @ 1-based indexing
    MOV R1, R7		@ Print the drink number
	@ R2 holds the amount of the selected drink
    BL printf 

	ADD R7, R7, #1 @ Increment counter
	B display_loop

exit_program:
	LDR R0, =bye_txt
	MOV R1, R4
	BL printf

	MOV R0, #0
	BL exit



