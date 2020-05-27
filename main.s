/*Programa hecho por>> Andrea Amaya  Martin Amado        */
/*            Carnet>> 19357         19020               */
/*Programa en ARM para simular trivia crack
	>PROYECTO FINAL ASSEMBLER							*/


.data
.align 2

opcion_ingresada:	.word 0
formato:.asciz  "\n %d"
nom_jugador1:	.asciz " "
nom_jugador2:	.asciz " "


.text
.align 2

.global main
.type main,%function




main:
	ldr r4, =nom_jugador1	/*R4 -> Nombre del jugador 1*/
	ldr r5, =nom_jugador2	/*R5 -> Nombre del jugador 2*/
	mov r11, #0				/*R11 -> Contador*/
	

	opcion_menu:		/*Se muestra que ingrese una opcion del menu*/
		ldr r0,=menu
		bl puts

		ldr r0,=formato /*Formato de impresion*/	
		ldr r1,=opcion_ingresada	/*Se guarda lo ingresado en una variable temporal*/
		bl scanf		/*Se lee lo ingresado por el usuario*/
		
		cmp r0, #0		/*Si es 0, no es un entero, por lo tanto, es error*/
		beq impresion_error	


	opcion_elegida:
		mov r0, #0
		ldr r1,=opcion_ingresada			/*Se apunta a lo ingresado*/
		ldr r1,[r1] 	

		cmp r1, #1
		beq jugar							/*Es pedir los nombres, jugar*/

		cmp r1, #2
		beq impresion_salir					/*Se sale del programa*/

		b impresion_error					/*No es opcion definida*/
	
	jugar:
		b nombre_jugador1				/*Se manda a la subrutina*/
		mov r4, r0						/*Se guarda en r4*/
		b nombre_jugador2				/*Se manda a la subrutina*/
		mov r5, r0						/*Se guarda en r5*/

	/*Imprime el menu*/
	impresion_menu:
		ldr r0, = menu              /* cargar dirección de la cadena a imprimir*/ 
		bl puts						 /* se muestra */
		b opcion_menu

	/*Imprime error en opcion elegida*/
	impresion_error:
		ldr r0, = error           /* cargar dirección de la cadena a imprimir*/ 
		bl puts                   /* se muestra */	
		bl getchar				  /*Limpia el buffer*/
		b opcion_menu			  /* regresando al menu */

	/*Imprime la salida*/
	impresion_salir:
		ldr r0, = salir              /* cargar dirección de la cadena a imprimir*/ 
		bl puts						 /* se muestra */
	
	/*Se sale correctamente*/
	mov r0,#0
	mov r1,#0
	mov r3, #0
	ldmfd sp!,{lr}
	bx lr

/*Interfaz amigable*/
menu:
    .asciz "\nBIENVENIDO A LA TRIVIA-ARM\n    Que deseas hacer? \n1. Ingresar los nombres de los jugadores\n2. Salir del programa \nPor favor, ingrese un numero:"

salir:
	.asciz "\nTe esperamos pronto para otra partida!\n"
