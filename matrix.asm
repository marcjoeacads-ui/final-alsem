.data # variables and constants
    prmrow: .asciiz "Enter n rows: " 
    prmcol: .asciiz "Enter n columns: "
    
.text
.globl main
main: 
    # Rows input
    li $v0, 4  
    la $a0, prmrow
    syscall
    li $v0, 5
    syscall
    move $s6, $v0

    # Columns input
    li $v0, 4
    la $a0, prmcol
    syscall
    li $v0, 5
    syscall
    move $s3, $v0

    # Calculate memory and allocate
    mul $s1, $s6, $s3 
    mul $a0, $s1, 4 

    li $v0, 9 # allocates memory and zeros it out
    syscall
    move $s5, $v0 

    # Call input which displays in real-time
    move $a0, $s5 #base address
    move $a1, $s1 #rowcount
    move $a2, $s3 #colcount

    jal inputmatrix  

    # Final display one last time
    move $a0, $s5
    move $a1, $s1
    move $a2, $s3
    jal displaymatrix

    li $v0, 10
    syscall

.include "visual.asm"