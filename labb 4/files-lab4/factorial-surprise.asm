# Initialize
	addi 	$a0, $zero, 3		
	
		
# Main factorial function
	beq	$a0, $zero, Zero	# Guard for 0!
	add	$v0, $a0, $zero		# Value out is initially the argument
	add	$a1, $a0, $zero
	
Fact:
	addi	$a1, $a1, -1
	beq	$a1, 1,	Stop
	mul	$v0, $v0, $a1
	beq	$zero, $zero, Fact
	
		


# If Zero
Zero:
	addi	$v0, $zero, 1
	

# Stoploop
Stop:
	beq	$0, $0, Stop
	nop