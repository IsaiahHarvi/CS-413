@ s -march=armv7-a -mthumb LAB_4.s -o LAB_4.o
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
Bye_txt: .asciz "Goodbye! Returned %d change.\n"
format_int: .asciz "%d"
format_char: .asciz " %c"
confirm_input: .Byte 0

.section .text
.global main
.thumb_func

main:
    LDR r0, =welcome_txt
    BL printf

    MOVS r4, #0
    B get_money

.thumb_func
get_money:
    LDR R0, =insert_money_txt
    BL printf

    LDR r0, =format_int
    LDR r1, =input_money
    BL scanf

    LDR r2, =input_money
    LDR r2, [r2]

    CMP r2, #5
    BEQ update_total
    CMP r2, #10
    BEQ update_total
    CMP r2, #25
    BEQ update_total
    CMP r2, #100
    BEQ update_total

    B get_money

.thumb_func
update_total:
    ADD r4, r4, r2
    LDR r0, =total_money_txt
    MOV r1, r4
    BL printf

    CMP r4, #55
    BLT get_money

    B get_drink

.thumb_func
get_drink:
    LDR r0, =select_drink_txt
    BL printf

    LDR r0, =format_int
    LDR r1, =selected_drink
    BL scanf

    LDR r5, =selected_drink
    LDR r5, [r5]

    LDR r0, =confirmation_drink_txt
    MOV r1, r5
    BL printf

    LDR r0, =format_char
    LDR r1, =confirm_input
    BL scanf

    LDR r6, =confirm_input
    LDR r6, [r6]
    CMP r6, #'y'
    BEQ validate_confirmed_choice
    B get_drink

.thumb_func
validate_confirmed_choice:
    CMP r5, #1
    BLt invalid_selection
    CMP r5, #5
    BEQ exit_program
    CMP r5, #6
    BEQ display_inventory
    CMP r5, #6
    BGT invalid_selection

    B confirmed_choice

.thumb_func
confirmed_choice:
    SUB r5, r5, #1
    LDR r0, =drink_inventory
    ADD r0, r0, r5, lsl #2
    LDR r1, [r0]
    SUB r1, r1, #1

    CMP r1, #0
    BLT out_of_stock

    STR r1, [r0]

    SUB r4, r4, #55

    LDR r0, =dispense_txt
    MOV r1, r5
    ADD r1, r1, #1
    MOV r2, r4
    BL printf

    MOVS r4, #0

    B get_money

.thumb_func
out_of_stock:
    LDR r0, =out_txt
    BL printf
    B get_drink

.thumb_func
invalid_selection:
    LDR r0, =invalid_selection_txt
    BL printf
    B get_drink

.thumb_func
display_inventory:
    MOVS r7, #0
    LDR r0, =inventory_head_txt
    BL printf
    B display_loop

.thumb_func
display_loop:
    CMP r7, #4
    BEQ get_drink
    LDR r0, =drink_inventory
    ADD r0, r0, r7, lsl #2
    LDR r2, [r0]
    LDR r0, =inventory_txt
    ADD r1, r7, #1
    BL printf
    ADDS r7, r7, #1
    B display_loop

.thumb_func
exit_program:
    LDR r0, =Bye_txt
    MOV r1, r4
    BL printf
    MOVS r0, #0
    BX lr

