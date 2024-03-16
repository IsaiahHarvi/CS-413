@ CS 413: Isaiah Harville - LAB 1 (2/2/2024)
@ User inputs 10 integers, which are stored to the second half of an array
@ the program will output three arrays, the third = a1[index] + a2[index]

@ To assemble, link, and run
@ gcc -o LAB_1 LAB_1.s -nostartfiles
@ ./LAB_1
@ INP DATA: 1,2,3,4,5,6,7,8,9,1



.data
.balign 4 @ Array with custom values
array_1: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10

.balign 4 @ Array 2 containing half of array 1
array_2: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.balign 4 @ Initializing space for the third array
array_3: .space 80

.balign 4
size: .word 20

.balign 4
welcome_txt: .asciz "Welcome, input 10 integers:\n"

.balign 4
print_arr1_txt: .asciz "\nArray 1\n"

.balign 4
print_arr2_txt: .asciz "\n\nArray 2\n"

.balign 4
print_arr3_txt: .asciz "\n\nArray 3\n"

.balign 4 @ For printing at EOP
new_line: .asciz "\n\n"

.balign 4
scanf_format: .asciz "%d"

.balign 4 @ Array element, next array element, so on..
printf_format: .asciz "%d, "


@ C
.global main
.extern printf, scanf

.text
main:
	@ Print Start Message
	LDR R0, =welcome_txt
	BL printf

	@ Add user input to the second half of array2
	MOV R3, #10	@ Half of the array size (20/2=10)
	LDR R4, =array_2 @ Memory address of array2
	ADD R4, R4, #40 @ Point to the middle index of the second array
	
	MOV r5, #10 @ Load counter for loop_read with half the size of an array
	B loop_read

loop_read:
	CMP R5, #0
	BEQ sum			@ If all inputs have been read
	LDR R0, =scanf_format
	SUB R5, R5, #1  	@ Decrement loop counter
	ADD R1, R4, R5, LSL #2	@ Next index to store input in array_2
				@ R2 is the middle of the array, LSL #2 multiplies the 
				@ loop counter (R4) by 4, the size of the integer
	BL scanf
	B loop_read

sum:
	MOV r4, #0	@ array index
	LDR r6, =array_1
	LDR r7, =array_2
	LDR r8, =array_3
	LDR r9, =size
	LDR r9, [r9]

sum_loop:
	CMP r4, r9 	@ If we are at the size of the array
	BEQ print_arrays
	LDR r0, [r6, r4, LSL #2] @ Load from array 1
	LDR r1, [r7, r4, LSL #2] @ Load from array 2
	MUL r2, r0, r1           @ Add the elements
	STR r2, [r8, r4, LSL #2] @ Store the sum in array 3
	ADD r4, r4, #1           @ increment loop count
	B sum_loop
	
print_arrays:
	@ Array 1
	LDR r0, =print_arr1_txt
	BL printf
	LDR r6, =array_1
	BL print_array
	
	@ Array 2
	LDR r0, =print_arr2_txt
	BL printf
	LDR r6, =array_2
	BL print_array

	@ Array 3
	LDR r0, =print_arr3_txt
	BL printf
	LDR r6, =array_3
	BL print_array

	B exit

print_array:
	@ Intialize before going into
	@ print_array_loop
	PUSH {LR}
	MOV r4, #0
	LDR r9, =size
	LDR r9, [r9]

print_array_loop:
	CMP r4, r9		@ Are we at the length of the array
	BEQ end_array_loop	@ If we are, pop from stack

	LDR r1, [r6, r4, LSL #2] @ Move to next index
	LDR r0, =printf_format   @ print the int at that index
	BL printf

	ADD r4, r4, #1		@ Increment the counter
	B print_array_loop

end_array_loop:
	POP {PC}

exit:
	LDR r0, =new_line 	@ Print a newline character at the end
	BL printf		@ to show the output of array 3

	MOV r7, #1
	SVC 0
@ EOF
