/* Ejemplo para ver si ya tiene ese punto :D */

	.global main
	.func main

main:
	mov r5, #0		@contador de ciclo
	mov r6, #0		@Contador de byte


loop:
	ldr r0, =Ganado		@array
	ldrb r0, [r0], r6	@Siguiente bit de array
	ldr r1, =Siguiente	@Otro coso ganado
	ldrb r1, [r1]		@Byte del nuevo personaje
	cmp r0, r1		@Comparan
	beq true		@Si ya tiene, sale
	add r5, r5, #1		@Sino, sigue el ciclo
	add r6, r6, #1		@Corrimiento para el arreglo
	cmp r5, #3		@Realiza el ciclo 3 veces
	bne loop

falso:
	ldr r0, =noTiene
	bl puts
	b fin

true:
	ldr r0, =tieneYa
	bl puts


fin:
	MOV R7, #1
	SWI 0


	.data

Ganado:		.byte 'P', 'C', ' '
Siguiente:	.byte 'C'
Repetido:	.byte 'P'
noTiene:	.asciz "No existe este valor"
tieneYa:	.asciz "Ya tiene este valor"


@ P de poporopo
@ F de futbol
@ H de historia
@ A de arte
@ G de globo
@ C de ciencia

