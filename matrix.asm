.data

    matrix:
        .float 1.0, 2.0, 3.0
        .float 4.0, 5.0, 6.0
        .float 7.0, 8.0, 9.0

    title: .asciiz "\n--- Current Matrix State ---\n"
    tb: .asciiz "\t"
    nl: .asciiz "\n"


.text
.globl main

main: 
    # Print the title
    li $v0, 4
    la $a0, title
    syscall

    # Load the base address of the matrix into $s0
    la $s0, matrix

    li $s1, 9

    li $s2, 0
    li $s3, 3

print_loop: 
    beq $s2, $s1, EOM # end of matrix

    lwc1 $f12, 0($s0)
    li $v0, 2
    syscall

    li $v0, 4
    la $a0, tb
    syscall
    
    addi $s0, $s0, 4
    addi $s2, $s2, 1

    div $s2, $s3
    mfhi $t0
   bnez $t0, print_loop # if not end of row, continue printing

    # Print a newline after each row
    li $v0, 4
    la $a0, nl
    syscall

    j print_loop 

EOM:
    # Exit the program
    li $v0, 10
    syscall