.data
    

    prmstart: .asciiz "Enter Number for ["
    prmmid: .asciiz "]["
    prmend: .asciiz "]: "

  #output formatting
    title: .asciiz "\n--- Current Matrix State ---\n" # header
    tb: .asciiz "\t"  #special characters for printing
    nl: .asciiz "\n"
.text

inputmatrix:
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    li $t3, 0 

inputloop:
    beq $t3, $t1, endinputloop

    div $t3, $t2
    mflo $t4 #row number
    mfhi $t5 #column number

    li $v0, 4
    la $a0, prmstart
    syscall
    li $v0, 1
    move $a0, $t4
    syscall
    li $v0, 4
    la $a0, prmmid
    syscall
    li $v0, 1
    move $a0, $t5
    syscall
    li $v0, 4
    la $a0, prmend
    syscall

    li $v0, 6
    syscall
    swc1 $f0, 0($t0) #store the input value in the matrix

    addi $t0, $t0, 4 #move to the next element in the matrix
    addi $t3, $t3, 1 #increment the counter
    j inputloop

   
endinputloop:
    jr $ra #jr returns to the caller function (main)

displaymatrix:
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    li $t3, 0

    li $v0, 4
    la $a0, title
    syscall
displayloop:
    beq $t3, $t1, enddisplayloop

    lwc1 $f12, 0($t0) #load the current element of the matrix
    li $v0, 2
    syscall

    li $v0, 4
    la $a0, tb
    syscall 

    addi $t0, $t0, 4 #move to the next element in the matrix
    addi $t3, $t3, 1 

    div  $t3, $t2        # Divide counter by columns
    mfhi $t4             # Get remainder
    bnez $t4, displayloop # If remainder is  !0, don't 

    li $v0, 4
    la $a0, nl
    syscall # print a newline
    j displayloop

enddisplayloop:
    jr $ra 
