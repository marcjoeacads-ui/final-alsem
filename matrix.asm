.data
    
    r: .asciiz "Enter n rows"
    c: .asciiz "Enter n columns"



    # prompts for entering matrixs values
    startp: .asciiz "Enter Number for ["
    midp: .asciiz "]["
    endp: .asciiz "]: "


    title: .asciiz "\n--- Current Matrix State ---\n"
    tb: .asciiz "\t"
    nl: .asciiz "\n"


.text
.globl main

main: 

    #Rows
    li $v0, 4
    la $a0, r
    syscall

    li $v0, 5
    syscall
    move $s6, $v0

    #Columns
    li $v0, 4
    la $a0, c
    syscall

    li $v0, 5
    syscall
    move $s3, $v0

    #gets rows x columns
    mul $s1, $s6, $s3 
    
    mul $a0, $s1, 4 #a0 = total bytes since for floats/int we need 4 bytes each

    li $v0, 9
    syscall

    move $s5, $v0 
    move $s0, $s5 

    li $s2, 0

inputl:
    beq $s2, $s1, endi

    div $s2, $s3
    mflo $t0
    mfhi $t1

    li $v0, 4
    la $a0, startp
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, midp
    syscall

    li $v0, 1
    move $a0, $t1
    syscall


    li $v0, 4
    la $a0, endp
    syscall

    li $v0, 6 #reads float
    syscall

    swc1 $f0, 0($s0) 

    addi $s0, $s0, 4
    addi $s2, $s2, 1
    j inputl

endi:
    li $v0, 4
    la $a0, title
    syscall

    move $s0, $s5
    li $s2, 0


loopp: 
    beq $s2, $s1, EOM # stands for end of matrix

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
    bnez $t0, loopp # if not end of row, continue printing

    # Print a newline after each row
    li $v0, 4
    la $a0, nl
    syscall

    j loopp

EOM:
    # Exit the program
    li $v0, 10
    syscall