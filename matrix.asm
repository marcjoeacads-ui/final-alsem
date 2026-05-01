.data
    
    prmrow: .asciiz "Enter n rows: "
    prmcol: .asciiz "Enter n columns: "



    # prompts for entering matrixs values
    prmstart: .asciiz "Enter Number for ["
    prmmid: .asciiz "]["
    prmend: .asciiz "]: "
    #this is for printing the matrix "Enter Number for [0][0]: " and so on..


    #output formatting
    title: .asciiz "\n--- Current Matrix State ---\n" # header
    tb: .asciiz "\t"  #special characters for printing
    nl: .asciiz "\n"


.text
.globl main

main: 

    #Rows print
    li $v0, 4 
    la $a0, prmrow
    syscall

    #Rows input
    li $v0, 5
    syscall
    move $s6, $v0

    #Columns print
    li $v0, 4
    la $a0, prmcol
    syscall

    #Columns input
    li $v0, 5
    syscall
    move $s3, $v0

    #Calculate memory n allocate
    mul $s1, $s6, $s3 #s1 = ttl numbers of m( r x c )
    mul $a0, $s1, 4 #a0 = total bytes since for floats/int we need 4 bytes each

    li $v0, 9
    syscall

    move $s5, $v0 # base address of the matrix in memory
    move $s0, $s5 

    li $s2, 0

inputrequest:
    beq $s2, $s1, endinputrequest 

    div $s2, $s3
    mflo $t0 #mflo gives us the quotient which is the row number
    mfhi $t1 #gives us the column number
    
    # Print the prompt for the current element
    li $v0, 4
    la $a0, prmstart #[
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4 # first number 
    la $a0, prmmid #[]
    syscall
    li $v0, 1 # second number
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, prmend #]:  
    syscall

    li $v0, 6 #reads float
    syscall

    swc1 $f0, 0($s0)  # store the input value in the matrix

    # Increment the pointer and the counter
    addi $s0, $s0, 4 
    addi $s2, $s2, 1
    j inputrequest

endinputrequest:
    # Print the title for the matrix
    li $v0, 4
    la $a0, title
    syscall
    # Reset $s0 to the base address of the matrix for printing
    move $s0, $s5
    li $s2, 0


loopforprinting: 
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
    bnez $t0, loopforprinting # if not end of row, continue printing

    # Print a newline after each row
    li $v0, 4
    la $a0, nl
    syscall

    j loopforprinting   

EOM:
    li $v0, 10
    syscall