/* Ejemplo para comparar un byte de palabra, (letra) */

	.global main
	.func main

main:

	ldr r0, = uno		@Se carga el asciz
	ldrb r1, [r0, #1]	@Se mueve al byte necesario
	cmp r1, #'o'		@Se compara
	bne noF

F:
	ldr r0, =funciona
	bl puts
	b fin

noF:
	ldr r0, =noFunciona
	bl puts

fin:


	MOV R7, #1
	SWI 0




	.data

uno:		.asciz "Ho"
funciona:	.asciz "Funciono"
noFunciona:	.asciz "Nop"

