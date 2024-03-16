@ as -march=armv7-a -mthumb LAB_4.s -o LAB_4.o
@ gcc -march=armv7-a -mthumb LAB_4.o -o LAB_4

.syntax unified
.thumb

.section .data
.Balign 4
total_money: .word 0 
input_money: .word 0
selected_drink: .word 0
drink_inventory: .word 2, 2, 2, 2
welcome_txt: .asciz "SELECT DRINK '6' TO SEE INVENTORY\n\nWelcome to The Vending Machine\n"
insert_money_txt: .asciz "\nInsert change (5, 10, 25, 100):\n"
total_money_txt: .asciz "\nTotal is %d cents.\n"
select_drink_txt: .asciz "\nSelect a drink (55c):\n1. Coke\n2. Sprite\n3. Dr. Pepper\n4. Coke Zero\n5. Exit\nEnter choice: "
confirmation_drink_txt: .asciz "\nYou chose %d. Is this correct? (y/n)\n"
invalid_selection_txt: .asciz "\nInvalid selection. Please try again.\n\n"
dispense_txt: .asciz "\nSelection %d has Been dispensed with %d change."
out_txt: .asciz "\nSorry! Your selection is out of stock.\n\n"
out_stock_txt: .asciz "\n\n\nSorry! We are all out of stock.\n"
inventory_head_txt: .asciz "\nDRINK  SUPPLY\n"
inventory_txt: .asciz "  %d\t %d\n"
bye_txt: .asciz "Goodbye! Returned %d change.\n"
format_int: .asciz "%d"
format_char: .asciz " %c"
confirm_input: .byte 0

.section .text
.global main
.thumb_func

main:
    LDR R0, =welcome_txt
    BL printf

    MOVS R4, #0
    B get_money

.thumb_func
get_money:
    LDR R0, =insert_money_txt
    BL printf

    LDR R0, =format_int
    LDR R1, =input_money
    BL scanf

    LDR R2, =input_money
    LDR R2, [R2]

    CMP R2, #5
    BEQ update_total
    CMP R2, #10
    BEQ update_total
    CMP R2, #25
    BEQ update_total
    CMP R2, #100
    BEQ update_total

    B get_money

.thumb_func
update_total:
    ADD R4, R4, R2
    LDR R0, =total_money_txt
    MOV R1, R4
    BL printf

    CMP R4, #55
    BLT get_money

    B get_drink

.thumb_func
get_drink:
    LDR R0, =select_drink_txt
    BL printf

    LDR R0, =format_int
    LDR R1, =selected_drink
    BL scanf

    LDR R5, =selected_drink
    LDR R5, [R5]

    LDR R0, =confirmation_drink_txt
    MOV R1, R5
    BL printf

    LDR R0, =format_char
    LDR R1, =confirm_input
    BL scanf

    LDR R6, =confirm_input
    LDR R6, [R6]
    CMP R6, #'y'
    BEQ validate_confirmed_choice
    B get_drink

.thumb_func
validate_confirmed_choice:
    CMP R5, #1
    BLt invalid_selection
    CMP R5, #5
    BEQ exit_program
    CMP R5, #6
    BEQ display_inventory
    CMP R5, #6
    BGT invalid_selection

    B confirmed_choice

.thumb_func
confirmed_choice:
    SUB R5, R5, #1
    LDR R0, =drink_inventory
    ADD R0, R0, R5, lsl #2
    LDR R1, [R0]
    SUB R1, R1, #1

    CMP R1, #0
    BLT out_of_stock

    STR R1, [R0]

    SUB R4, R4, #55

    LDR R0, =dispense_txt
    MOV R1, R5
    ADD R1, R1, #1
    MOV R2, R4
    BL printf

    MOVS R4, #0

    B get_money

.thumb_func
out_of_stock:
    LDR R0, =out_txt
    BL printf
    B get_drink

.thumb_func
invalid_selection:
    LDR R0, =invalid_selection_txt
    BL printf
    B get_drink

.thumb_func
display_inventory:
    MOVS R7, #0
    LDR R0, =inventory_head_txt
    BL printf
    B display_loop

.thumb_func
display_loop:
    CMP R7, #4
    BEQ get_drink
    LDR R0, =drink_inventory
    ADD R0, R0, R7, lsl #2
    LDR R2, [R0]
    LDR R0, =inventory_txt
    ADD R1, R7, #1
    BL printf
    ADDS R7, R7, #1
    B display_loop

.thumb_func
exit_program:
    LDR R0, =bye_txt
    MOV R1, R4
    BL printf
    MOVS R0, #0
    BX lr

