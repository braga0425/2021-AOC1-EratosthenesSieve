#Leonardo Braga e Rafael Freitas

.data

input:
		.align 2			#align do tipo word para int
		.space 20			#array 5 ints

output:
		.align 2			#align do tipo word para int
		.space 20			#array 5 ints
		
eratosthenes:
		.align 2			#align do tipo word para int
		.space 400			#array 100 ints
		
.text
		li $t7, 20			#tamanho array entrada
		move $t0, $zero			#registrador que carregara o indice do eratosthenes que contera os numeros primos
		move $t1, $zero 		#registrador que carregara o indice dos numeros nao primos que terao valor 1 no eratosthenes
		
		li $t2, 1			#valor inicial do array eratosthenes, slots nao primos conterao 1
		sw $t2, eratosthenes($t1)	#o numero 1 é inserido na lista para entao o codigo seguir para o Crivo de Eratostenes (Sieve of Eratosthenes)
		
		addi $t2, $t2, 1		#registrador t2 contem agr valor do primeiro numero primo (que é o 2)
		addi $t0, $t0, 4		#prosseguimos 4 bytes para acessar o endereco do proximo slot do array na memoria
		addi $t1, $t1, 4
		li $t4, 4			#comando de apoio, sera utilizado na contagem de casas para cortar os multiplos
		
#aqui é o Crivo de Eratostenes, onde ocorre insercao dos primos no array eratosthenes e nos slots dos nao primos insere-se 1, conforme explicado acima
beginEratosthenes:
		beq $t2, 8, endEratosthenes	#apos a remocao de multiplos do primo 7, obetem-se uma lista de primos, porem seus slots estao com o valor 0, mas sera tratado no bloco endEratosthenes
		lw $t5, eratosthenes($t0)	#colocamos em t5, o valor no slot da memoria atual acessado pelo indice no registrador t0
		beq $t5, 1, halfEratosthenes 	#aqui checa se no slot atual tem um numero nao primo marcado por 1
		sw $t2, eratosthenes($t0)	#entao é armazenado na lista o valor do primo atual

#calcular intervalo para remover nao primos
		mul $t3, $t2, $t4		#(o registrador t3 contem a distancia nos slots do array eratosthenes, dos multiplos do primo atual), esse valor é obtido pela multiplicacao do primo atual (t2) por 4, obtendo assim a distancia na memoria dos multiplos do primo atual		
		move $t1, $t0			#movo o registrador t1 para o endereco do primo atual
		add $t1, $t1, $t3		#mover para o primeiro multiplo do primo atual
		j midEratosthenes

#esse loop esta dentro do primeiro loop "beginEratosthenes" e nele é colocado o valor de 1 em todos os slots multiplos do primo atual em t0
midEratosthenes:
		bge $t1, 400, halfEratosthenes	#caso todos os multiplos do primo atual ja tenham sido anulados
		li $t6, 1
		sw $t6, eratosthenes($t1)
		add $t1, $t1, $t3
		j midEratosthenes

#aqui todos os multiplos do primo atual ja foram anulados
halfEratosthenes:
		addi $t0, $t0, 4		#o indice do registrador dos primos, t0, anda 4 bytes a direita, com o intuito de acessar o proximo slot do array eratosthenes
		addi $t2, $t2, 1		#t2 que contem o numero o qual foi colocado no slot t0 é somado 1
		j beginEratosthenes
		
#esse loop é responsavel por inserir os primos apos o numero 7
endEratosthenes:
		beq $t0, 400, exitEratosthenes
		lw $t5, eratosthenes($t0)
		
		beq $t5, 0, if			#slot com primo, pois se o numero nao fosse, estaria com 1
		
#else
		addi $t2, $t2, 1
		addi $t0, $t0, 4
		j endEratosthenes

#aqui é inserido o numero primo daquele slot no array eratosthenes
if:
		sw $t2, eratosthenes($t0)
		addi $t2, $t2, 1
		addi $t0, $t0, 4
		j endEratosthenes

#finalizando o Crivo de Eratostenes				
exitEratosthenes:
		move $t0, $zero 		#indice dos primos
		li $t7, 20			#tamanho do array de entrada

#esse bloco de codigo e responsavel por receber a entrada do input
loopInput:
		beq $t0, $t7, endLoopInput
		li $v0, 5
		syscall
		sw $v0, input($t0)
		addi $t0, $t0, 4
		j loopInput
		
endLoopInput:
		move $t0, $zero 		#indice input recebera valor contido nesse indice
		move $t1, $zero 		#indice output recebera valor contido nesse indice
		move $t2, $zero 		#indice eratosthenes recebera valor contido nesse indice
		
#esse bloco do codigo é responsavel por checar quais dos valores no input sao primos e os inserir no output
checkPrimeNumber:
		beq $t0, $t7, preLoopOutput
		lw $t3, input($t0) 		#valor a ser checado

#aqui é calculado o indice do numero primo do input no array eratosthenes, caculo e feito pelo (valor do numero - 1) * 4, pois na memoria assim estao organizados os bytes e seus respectivos valores numa lista de 1 a 100
#array eratosthenes (0 +4 +8 +12 +16 +20 +24 +28) | 1 2 3 4 5 6 7 8

#o indice do numero 5, por exemplo, é 16, que é obtido por (5 - 1) * 4

		subi $t6, $t3, 1		#(valor do input -1)
		mul $t6, $t6, 4			# * 4
		
		add $t2, $t2, $t6		#aqui o registrador t2, que estava no indice zero, é movido + (valor do input - 1) * 4 bits na memoria
		
		lw $t5, eratosthenes($t6)	#aqui colocamos no registrador t5 o valor que esta dentro do eratosthenes no endereço calculado acima
		
		bne $t5, 1, insertOutput	#aqui descobrimos se esse valor é primo ou nao, caso nao seja igual a 1, ou seja, é primo, é chamado o bloco insertOutput

#por exemplo, se fosse 4 o input, o calculo daria 12 e esse endereço no array eratosthenes esta com o valor 1, logo nao é primo
		addi $t0, $t0, 4
		j checkPrimeNumber
		
#aqui é inserido no array output o valor primo do slot do input, o qual teve sua primalidade checada no bloco checkPrimeNumber
insertOutput:
		sw $t3, output($t1)
		la $t4, ($t1)			#OBS: o valor do indice do registrador t4, contera no fim do laco checkPrimeNumber, a ultima posicao com primo no output, esse registrador sera importantissimo para controlar o limite de leitura para a saida em loopOutput
		addi $t1, $t1, 4
		addi $t0, $t0, 4
		
		j checkPrimeNumber

preLoopOutput:
		move $t1, $zero

#loop responsavel pela saida do programa
loopOutput:
		bgt $t1, $t4, end
		li $v0, 1
		lw $a0, output($t1)
		syscall
		addi $t1, $t1, 4
		j loopOutput
end: