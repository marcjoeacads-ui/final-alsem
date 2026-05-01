.data
    
    prmrow: .asciiz "Enter n rows: "
    prmcol: .asciiz "Enter n columns: "
    
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

    move $a0, $s5
    move $a1, $s1
    move $a2, $s3
    jal inputmatrix 

    move $a0, $s5
    move $a1, $s1
    move $a2, $s3
    jal displaymatrix

EOM:
    li $v0, 10
    syscall

.include "visual.asm"