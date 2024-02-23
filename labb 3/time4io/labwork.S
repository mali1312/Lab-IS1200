  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  #cd
  # Please keep the two macros PUSH and POP unchanged
  #
.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm
  #
  # Please add your own code below this line
    # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

#.macro	PUSH (%reg)
#	addi	$sp,$sp,-4
#	sw	%reg,0($sp)
#.end_macro

#.macro	POP (%reg)
#	lw	%reg,0($sp)
#	addi	$sp,$sp,4
#.end_macro
        
	.data
	    delayconstant: .word 3800 # Easy to change constant
	.align 2
mytime:	.word 0x0000
timstr:	.ascii "text more text lots of text\0"
	.text
	.global time2string
	.global delay
	
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
   hexasc: 
    andi $v0, $a0, 0xF   # Extract the 4 least significant bits

    # Convert the value to ASCII
    blt $v0, 10, hex_digit   # If value is less than 10, it's a digit
    nop
    addi $v0, $v0, 0x37   # Adjust for letters ('A' is 10, so add 55)
    j   done
    nop

hex_digit:
    addi $v0, $v0, 0x30   # Adjust for digits ('0' is 0, so add 48)

done:
    jr $ra               # Return
    nop

delay: 
    # Function Prologue
    PUSH $ra
    PUSH $s0
    
    whileloop:
    slt $t1, $0, $a0
    beq $t1, $0, endwhile
    nop
    addi $a0, $a0, -1
    
    # For loop starts
    li $t0, 0
    lw $t2, delayconstant
    forloop:
    slt $t1, $t0, $t2
    beq $t1, $0, endfor
    nop
    addi $t0, $t0, 1
    j forloop
    nop
    
    endfor:
    j whileloop
    nop
    
    endwhile:
    
    # Function Epilogue
    POP $s0
    POP $ra
    jr $ra               # Return from function
    nop
   
time2string:
   # a0, timstr, should change to mm:ss
    # a1, mytime, get time from this

    PUSH $s0 # we want to make sure s0 and s1 are restored
    PUSH $s1 # after the function has finished
    PUSH $ra # we don't want to lose this after calling hexasc

    add $s0, $a0, $zero # storing arguments in s0 and s1 so they can be used
    add $s1, $a1, $zero # when calling hexasc without relying on the stack


    andi $t0, $s1, 0xf000 # isolating
    srl  $t0, $t0, 12     # shift to far right
    add $a0, $t0, $zero   # setting argument
    jal hexasc            # ascii will returned in v0
    nop
    sb $v0, 0($s0)        # storing ascii character in timstr at index 0


    andi $t0, $s1, 0x0f00 # isolating
    srl  $t0, $t0, 8      # shift to far right
    add $a0, $t0, $zero   # setting argument
    jal hexasc            # ascii will returned in v0
    nop
    sb $v0, 1($s0)        # storing ascii character in timstr at index 1

 
    li $t0, 0x3a          # storing colon ascii into t0
    sb $t0, 2($s0)        # storing ascii character in timstr at index 2

    
    andi $t0, $s1, 0x00f0 # isolating
    srl  $t0, $t0, 4      # shift to far right
    add $a0, $t0, $zero   # setting argument
    jal hexasc            # ascii will returned in v0
    nop
    sb $v0, 3($s0)        # storing ascii character in timstr at index 3


    andi $t0, $s1, 0x000f # isolating
    srl  $t0, $t0, 0      # shift to far right
    add $a0, $t0, $zero   # setting argument
    jal hexasc            # ascii will returned in v0
    nop
    sb $v0, 4($s0)        # storing ascii character in timstr at index 4
    
    # Check if seconds are xx:00
    #andi $t1, $s1, 0x00ff # isolating seconds part
    #beqz $t1, append_x    # if seconds are zero, jump to append_x
    #nop

     # null, end-of-string-marker
    li $t0, 0x00          # storing null ascii into t0
    sb $t0, 5($s0)        # storing ascii character in timstr at index 5
    j end_time2string
    nop

   # append_x:
  #  li $t0, 'X'           # Load ASCII value of 'X'
   # sb $t0, 5($s0)        # Store 'X' after the time
    #li $t0, 0x00          # storing null ascii into t0
    #sb $t0, 6($s0)        # storing ascii character in timstr at index 6

    # popping in reverse to push
    end_time2string:
    POP $ra
    POP $s1
    POP $s0

    jr $ra
    nop
    
  .global enable_interrupt
  .text

  enable_interrupt:
      ei               # Enable interrupts globally
      jr $ra           # Return to the caller
      nop              # Delay slot filler

