#Leonardo Braga e Rafael Freitas

.data

input:
		.align 2 			#tipo word para int
		.space 20 			#array 5 ints alterar em funcao do teste
		
output:
		.align 2			#tipo word para int
		.space 20			#array 5 ints alterar em função do teste
		
eratosthenes:
		.align 2			#tipo word para int
		.space 400			#array 100 ints
	
.text
		li $t7, 20
		move $t0, $zero
		move $t1, $zero
		li $t2, 1
		sw $t2, eratosthenes($t1)
		addi $t2, $t2, 1
		addi $t0, $t0, 4
		addi $t1, $t1, 4
		li $t4, 4
		
beginEratosthenes:
		beq $t2, 8, endEratosthenes
		lw $t5, eratosthenes($t0)
		beq $t5, 1, halfEratosthenes
		sw $t2, eratosthenes($t0)
		
		mul $t3, $t2, $t4
		
		move $t1, $t0
		add $t1, $t1, $t3
		j midEratosthenes
		
midEratosthenes:
		bge $t1, 400, halfEratosthenes
		li $t6, 1
		sw $t6, eratosthenes($t1)
		add $t1, $t1, $t3
		j midEratosthenes
		
halfEratosthenes:
		addi $t0, $t0, 4
		addi $t2, $t2, 1
		j beginEratosthenes
		
endEratosthenes:
		beq $t0, 400, exitEratosthenes
		lw $t5, eratosthenes($t0)
		beq $t5, 0, if
		
		addi $t2, $t2, 1
		addi $t0, $t0, 4
		j endEratosthenes
		
if:
		sw $t2, eratosthenes($t0)
		addi $t2, $t2, 1
		addi $t0, $t0, 4
		j endEratosthenes
		
exitEratosthenes:
		move $t0, $zero
		li $t7, 20
		
loopInput:
		beq $t0, $t7, endLoopInput
		li $v0, 5
		syscall
		sw $v0, input($t0)
		addi $t0, $t0, 4
		j loopInput
		
endLoopInput:
		move $t0, $zero
		move $t1, $zero
		move $t2, $zero
		
checkPrime:
		beq $t0, $t7, preLoopOutput
		lw $t3, input($t0)

		subi $t6, $t3, 1
		mul $t6, $t6, 4
		add $t2, $t2, $t6
		lw $t5, eratosthenes($t6)
		bne $t5, 1, insertOutput
		
		addi $t0, $t0, 4
		j checkPrime
		
insertOutput:
		sw $t3, output($t1)
		la $t4, ($t1)
		addi $t1, $t1, 4
		addi $t0, $t0, 4
		j checkPrime
		
preLoopOutput:
		move $t1, $zero
		
loopOutput:
		bgt $t1, $t4, end
		li $v0, 1
		lw $a0, output($t1)
		syscall
		addi $t1, $t1, 4
		j loopOutput
		
end: