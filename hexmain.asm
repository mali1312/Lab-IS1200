  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,14		# change this to test different values
#om a0 och v0 skulle vara 17 så printas det endast ut en tom fyrkant, karaktärerna 0-31 används främst för i/o devices

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window

	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

hexasc:
	andi	$a0,$a0,0xF
	slti	$t0,$a0,10
	beq	$t0,0,storre
	addi	$a0,$a0,48
	j	slut
storre:
	addi	$a0,$a0,55
	j	slut
slut:
	jr	$ra
	nop 
	
	
	
	
	
