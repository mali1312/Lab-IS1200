  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  #
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
  #

time2string:
   # a0, timstr, should change to mm:ss
    # a1, mytime, get time from this

    PUSH $s0 # we want to make sure s0 and s1 are restored
    PUSH $s1 # after the function has finished
    PUSH $ra #  we don't want to lose this after calling hexasc

    add $s0, $a0, $zero # storing arguments in s0 and s1 so they can be used
    add $s1, $a1, $zero # when calling hexasc without relying on the stack

    # m---- / mm:ss
    andi $t0, $s1, 0xf000 # isolating
    srl  $t0, $t0, 12     # shift to far right
    add $a0, $t0, $zero   # setting argument
    jal hexasc            # ascii will returned in v0
    nop
    sb $v0, 0($s0)        # storing ascii character in timstr at index 0

    # -m--- / mm:ss
    andi $t0, $s1, 0x0f00 # isolating
    srl  $t0, $t0, 8      # shift to far right
    add $a0, $t0, $zero   # setting argument
    jal hexasc            # ascii will returned in v0
    nop
    sb $v0, 1($s0)        # storing ascii character in timstr at index 1

    # --:-- / mm:ss
    li $t0, 0x3a          # storing colon ascii into t0
    sb $t0, 2($s0)        # storing ascii character in timstr at index 2

    # ---s- / mm:ss
    andi $t0, $s1, 0x00f0 # isolating
    srl  $t0, $t0, 4      # shift to far right
    add $a0, $t0, $zero   # setting argument
    jal hexasc            # ascii will returned in v0
    nop
    sb $v0, 3($s0)        # storing ascii character in timstr at index 3

    # ----s / mm:ss
    andi $t0, $s1, 0x000f # isolating
    srl  $t0, $t0, 0      # shift to far right
    add $a0, $t0, $zero   # setting argument
    jal hexasc            # ascii will returned in v0
    nop
    sb $v0, 4($s0)        # storing ascii character in timstr at index 4

    # null, end-of-string-marker
    li $t0, 0x00          # storing null ascii into t0
    sb $t0, 5($s0)        # storing ascii character in timstr at index 5

    # popping in reverse to push
    POP $ra
    POP $s1
    POP $s0

    jr $ra
    nop
