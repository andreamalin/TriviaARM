/*Programa hecho por>> Andrea Amaya  Martin Amado        */
/*            Carnet>> 19357         19020               */
/*Programa en ARM para simular trivia crack
	>PROYECTO FINAL ASSEMBLER							*/


.data
.align 2
.text
.align 2

.global main
.type main,%function

opcion_menu:	.word 0


main:
	mov r11, #0				/*R11 -> Contador*/

	opcion_menu:		/*Se muestra que ingrese una opcion del menu*/
		ldr r0,=menu
		bl puts

		ldr r0,=formato /*Formato de impresion*/	
		ldr r1,=ingreso	/*Se guarda lo ingresado en una variable temporal*/
		bl scanf		/*Se lee lo ingresado por el usuario*/
		
		cmp r0, #0		/*Si es 0, no es un entero, por lo tanto, es error*/
		beq impresion_error	

	opcion_elegida:
		mov r0, #0
		ldr r1,=ingreso			/*Se apunta a lo ingresado*/
		ldr r1,[r1] 	

		cmp r1, #1
		b ingresando_nombres				/*Es pedir los nombres, jugar*/
	


		/*Imprime el numero segun el valor de test, luego de mostrar el resultado, se salta de regreso a mostrar el menu*/
	impresion_menu:
		ldr r0, = menu              /* cargar dirección de la cadena a imprimir*/ 
		bl puts						 /* se muestra */
		b opcion_menu


	impresion_error:
		ldr r0, = error           /* cargar dirección de la cadena a imprimir*/ 
		bl puts                   /* se muestra */	
		bl getchar				  /*Limpia el buffer*/
		b opcion_menu			  /* regresando al menu */


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
    .asciz "\nBIENVENIDO A LA TRIVIA-ARM\n Que deseas hacer? \n 1. Ingresar los nombres de los jugadores\n2. Salir del programa \nPor favor, ingrese un numero:"

salir:
	.asciz "\nTe esperamos pronto para otra partida!\n"