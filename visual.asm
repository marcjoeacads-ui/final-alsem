.data
    prmstart: .asciiz "Enter Number for ["
    prmmid: .asciiz "]["
    prmend: .asciiz "]: "

    title: .asciiz "\n--- Current Matrix State ---\n"
    tb: .asciiz "\t"
    nl: .asciiz "\n"

.text

inputmatrix:
    # Save $ra and $s registers to stack (since we are calling another function)
    addi $sp, $sp, -20 
    sw $ra, 16($sp)
    sw $s0, 12($sp) # Base address
    sw $s1, 8($sp)  # Total elements
    sw $s2, 4($sp)  # Column count
    sw $s3, 0($sp)  # Counter (i)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    li $s3, 0 

inputloop:
    beq $s3, $s1, endinputloop

    # Refresh the screen every time
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal displaymatrix 

    # Calculate row/col for the prompt
    div $s3, $s2
    mflo $t4 # row
    mfhi $t5 # col

    # 3. Print the prompt
    li $v0, 4
    la $a0, prmstart #[
    syscall
    li $v0, 1
    move $a0, $t4
    syscall
    li $v0, 4
    la $a0, prmmid #][
    syscall
    li $v0, 1
    move $a0, $t5
    syscall
    li $v0, 4
    la $a0, prmend
    syscall

    # 4. Read float and store
    li $v0, 6
    syscall
    
    # Calculate offset: counter * 4
    sll $t6, $s3, 2   # $t6 = $s3 * 4
    add $t6, $t6, $s0 # add base address
    swc1 $f0, 0($t6)

    addi $s3, $s3, 1 # increment counter
    j inputloop

endinputloop:
    # Restore stack and return
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

displaymatrix:
    # 
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Move arguments to temps for the display logic
    move $t0, $a0 # base
    move $t1, $a1 # total
    move $t2, $a2 # cols
    
    jal clear_screen

    li $v0, 4
    la $a0, title
    syscall

    li $t3, 0 # local counter
displayloop:
    beq $t3, $t1, enddisplayloop

    lwc1 $f12, 0($t0)
    li $v0, 2
    syscall

    li $v0, 4
    la $a0, tb
    syscall 

    addi $t0, $t0, 4
    addi $t3, $t3, 1 

    div  $t3, $t2
    mfhi $t4
    bnez $t4, displayloop 

    li $v0, 4
    la $a0, nl
    syscall
    j displayloop

enddisplayloop:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra 

clear_screen:
    li $t7, 0
    li $t8, 20 # 20 to ensure is at bottom
clear_loop:
    beq $t7, $t8, end_clear
    li $v0, 4
    la $a0, nl
    syscall
    addi $t7, $t7, 1
    j clear_loop
end_clear:
    jr $ra