/*Subrutinas que llevan a cabo las operaciones de la trivia ARM*/


/* Subrutinas mysrand y myrand tomadas de:
Villena, A. & Asenjo, R. & Corbera, F. Practicas basadas en Raspberry Pi */

.data
seed: 	.word 	1
const1:	.word	1103515245
const2:	.word	12345

.text
.global myrand, mysrand

mysrand:				/*Retorna el aleatorio*/
	ldr r1, =seed		/*Se jala la semilla*/
	str r0, [r1]		/*Se guarda R0 en R1*/
	mov pc, lr			/*Se retorna*/

myrand:					/*Genera el aleatorio*/
	ldr r1, =seed		/*Se jala el valor de la semilla*/
	ldr r0, [r1]		/*Se lee el valor de la semilla*/
	ldr r2, [r1,#4]		/*Se lee la const1*/
	mul r3, r0, r2		/*R3 contendra seed*1103515245*/
	ldr r0, [r1,#8]		/*Se lee la const2*/
	add r0, r0, r3		/*R0 contendra R3+12345*/
	str r0, [r1]		/*Se guarda R0 en R1 (semilla)*/
	lsl r0, #1			/*Logical Shift Left*/
	lsr r0, #17			/*Logical Shift Right*/
	mov pc, lr			/*Retorno*/


/*Subrutinas encargadas de ir alternando turnos, dar personajes,
pedir nombres*/


.data
nom_jugador1:	.asciz "            "
nom_jugador2:	.asciz "            "
.text

/* nombre_jugador son las subrutinas encargadas de recibir los nombres de los jugadores */
/* Diseñadas y programadas por */
/* Martin Amado y Andrea Amaya */
/*	Parametros	> r0 con el nombre del jugador 1
	Retorna		> r1 con el nombre del jugador	 */
.global nombre_jugador1
nombre_jugador1:
	push {r4-r12, lr}

	ldr r0,=ingreso_nom     /* cargar dirección de la cadena a imprimir*/ 
	bl puts					/* se muestra */	

	ldr r0,=formato			/*Formato de entrada*/	
	ldr r1,=nom_jugador1	/*Se guarda lo ingresado dentro de nom_jugador*/
	bl scanf				/*Se lee lo ingresado por el usuario*/
	
	ldr r1,=nom_jugador1	/*Se obtiene la direccion de nom_jugador*/
	
	pop {r4-r12, pc}		/*Regresando sin error*/


/*	Parametros	> r0 con el nombre del jugador
	Retorna		> r1 con el nombre del jugador 2 */
.global nombre_jugador2
nombre_jugador2:
	push {r4-r12, lr}

	ldr r0,=ingreso_nom2    /* cargar dirección de la cadena a imprimir*/ 
	bl puts					/* se muestra */	

	ldr r0,=formato			/*Formato de entrada*/	
	ldr r1,=nom_jugador2	/*Se guarda lo ingresado dentro de nom_jugador*/
	bl scanf				/*Se lee lo ingresado por el usuario*/
	
	ldr r1,=nom_jugador2	/*Se obtiene la direccion de nom_jugador*/
	
	pop {r4-r12, pc}		/*Regresando sin error*/



/*	Parametros	> r6 turno actual, r5 nombre jugador 2, r4 nombre jugador 1  */
/* Las subrutinas desde comenzarJuego hasta ganar_personaje son las encargadas de llevar el juego */
/* Diseñadas y programadas por */
/* Martin Amado y Andrea Amaya */
.global comenzarJuego
comenzarJuego:
	push {r4-r12, lr}

/* Encargada de mostrar de quien es el turno */
mostrar_jugador:
	mov r7, #0					/* Contador de preguntas buenas */
	cmp r6, #1					/* Comparamos cual es el jugador actual*/
	ldreq r1, =nom_jugador1		/*Se jala el nombre del jugador 1*/	
	ldrne r1, =nom_jugador2		/*Se jala el nombre del jugador 2*/	
	ldr r0, = jugador_actual    /* cargar dirección de la cadena a imprimir*/ 
	bl printf                   /* se muestra */

/* Genera un numero del 0 al 5 para generar una de las 6 categoria */
categoria_aleatoria:
	mov r8, #0					/*Reiniciando parametros*/
	mov r9, #0
	mov r10, #0

	bl myrand					/*R0 contendra el numero aleatorio generado*/
	push {r0}					/*R0 se mete al stack*/

	mov r1,r0					/*Se guarda r0 en r1*/
	and r1,r1,#5				/*R1 llevara el limite superior de numero a generar -> Cantidad de categorias*/
	mov r8, r1					/*Se jala a r8 el numero aleatorio*/
	pop {r0}					/*Se saca r0 del stack*/

/*r8 -> categoria aleatoria*/
/* Genera un numero del 0 al 5 para generar una de las 6 preguntas por categoria */
pregunta_aleatoria:
	bl myrand					/*R0 contendra el numero aleatorio generado*/
	push {r0}					/*R0 se mete al stack*/

	mov r1,r0					/*Se guarda r0 en r1*/
	and r1,r1,#5				/*R1 llevara el limite superior de numero a generar -> Cantidad de preguntas*/
	mov r9, r1					/*Se jala a r9 el numero aleatorio*/
	pop {r0}					/*Se saca r0 del stack*/

	mov r10, #1					/*bytes*/
	mul r10, r9					/*Direccion de la respuesta correcta dentro del vector*/

	/*r8 -> categoria aleatoria      r9 -> pregunta aleatoria      r10 -> direccion de la respuesta correcta */

	cmp r8, #0
	beq mostrar_categoria1
	cmp r8, #1
	beq mostrar_categoria2
	cmp r8, #2
	beq mostrar_categoria3
	cmp r8, #3
	beq mostrar_categoria4
	cmp r8, #4
	beq mostrar_categoria5
	cmp r8, #5
	beq mostrar_categoria6

/*r8 -> categoria aleatoria      r9 -> pregunta aleatoria      r10 -> direccion de la respuesta correcta */
/* En mostrar_categoria, se muestra la pregunta de la categoria indicada y generada anteriormente */
/* Se revisa si la respuesta ingresada es la correcta */
/* CATEGORIA -> CIENCIAS */
mostrar_categoria1:
	/* Dependiendo del valor de r9, escoge la pregunta y posibles respuestas correspondientes */
	cmp r9, #0
	ldreq r0, =ciencia_1
	bleq puts

	cmp r9, #1
	ldreq r0, =ciencia_2
	bleq puts

	cmp r9, #2
	ldreq r0, =ciencia_3
	bleq puts

	cmp r9, #3
	ldreq r0, =ciencia_4
	bleq puts

	cmp r9, #4
	ldreq r0, =ciencia_5
	bleq puts

	cmp r9, #5
	ldreq r0, =ciencia_6
	bleq puts


	/*Pedimos la respuesta*/
	ldr r0,=formato					/*Formato de impresion*/	
	ldr r1,=respuesta				/*Se guarda lo ingresado en una variable temporal*/
	bl scanf						/*Se lee lo ingresado por el usuario*/

	ldr r1,=respuesta				/*Se apunta a lo ingresado*/
	ldrb r1,[r1] 
	ldr r0,=respuestas_ciencia		/*Se apunta al vector de respuestas*/
	ldrb r0,[r0,r10] 				/*Apuntamos a la respuesta correcta dependiendo de la pregunta*/
	cmp r1, r0						@Se compara respuesta ingresada y respuesta correcta
	beq seguirTurno
	bne incorrecta


/*r8 -> categoria aleatoria      r9 -> pregunta aleatoria      r10 -> direccion de la respuesta correcta */
/* CATEGORIA -> LITERATURA */
mostrar_categoria2:
	/* Dependiendo del valor de r9, escoge la pregunta y posibles respuestas correspondientes */
	cmp r9, #0
	ldreq r0, =literatura_1
	bleq puts

	cmp r9, #1
	ldreq r0, =literatura_2
	bleq puts

	cmp r9, #2
	ldreq r0, =literatura_3
	bleq puts

	cmp r9, #3
	ldreq r0, =literatura_4
	bleq puts

	cmp r9, #4
	ldreq r0, =literatura_5
	bleq puts

	cmp r9, #5
	ldreq r0, =literatura_6
	bleq puts


	/*Pedimos la respuesta*/
	ldr r0,=formato					/*Formato de impresion*/	
	ldr r1,=respuesta				/*Se guarda lo ingresado en una variable temporal*/
	bl scanf						/*Se lee lo ingresado por el usuario*/

	ldr r1,=respuesta				/*Se apunta a lo ingresado*/
	ldrb r1,[r1] 
	ldr r0,=respuestas_literatura	/*Se apunta al vector de respuestas*/
	ldrb r0,[r0,r10] 				/*Apuntamos a la respuesta correcta dependiendo de la pregunta*/
	cmp r1, r0						@Se compara respuesta ingresada y respuesta correcta
	beq seguirTurno
	bne incorrecta

/*r8 -> categoria aleatoria      r9 -> pregunta aleatoria      r10 -> direccion de la respuesta correcta */
/* CATEGORIA -> GEOGRAFIA */
mostrar_categoria3:
	/* Dependiendo del valor de r9, escoge la pregunta y posibles respuestas correspondientes */
	cmp r9, #0
	ldreq r0, =geografia_1
	bleq puts

	cmp r9, #1
	ldreq r0, =geografia_2
	bleq puts

	cmp r9, #2
	ldreq r0, =geografia_3
	bleq puts

	cmp r9, #3
	ldreq r0, =geografia_4
	bleq puts

	cmp r9, #4
	ldreq r0, =geografia_5
	bleq puts

	cmp r9, #5
	ldreq r0, =geografia_6
	bleq puts

	/*Pedimos la respuesta*/
	ldr r0,=formato					/*Formato de impresion*/	
	ldr r1,=respuesta				/*Se guarda lo ingresado en una variable temporal*/
	bl scanf						/*Se lee lo ingresado por el usuario*/

	ldr r1,=respuesta				/*Se apunta a lo ingresado*/
	ldrb r1,[r1] 
	ldr r0,=respuestas_geografia	/*Se apunta al vector de respuestas*/
	ldrb r0,[r0,r10] 				/*Apuntamos a la respuesta correcta dependiendo de la pregunta*/
	cmp r1, r0						@Se compara respuesta ingresada y respuesta correcta
	beq seguirTurno
	bne incorrecta

/*r8 -> categoria aleatoria      r9 -> pregunta aleatoria      r10 -> direccion de la respuesta correcta */
/* CATEGORIA -> ARTE */
mostrar_categoria4:
	/* Dependiendo del valor de r9, escoge la pregunta y posibles respuestas correspondientes */
	cmp r9, #0
	ldreq r0, =arte_1
	bleq puts

	cmp r9, #1
	ldreq r0, =arte_2
	bleq puts

	cmp r9, #2
	ldreq r0, =arte_3
	bleq puts

	cmp r9, #3
	ldreq r0, =arte_4
	bleq puts

	cmp r9, #4
	ldreq r0, =arte_5
	bleq puts

	cmp r9, #5
	ldreq r0, =arte_6
	bleq puts

	/*Pedimos la respuesta*/
	ldr r0,=formato					/*Formato de impresion*/	
	ldr r1,=respuesta				/*Se guarda lo ingresado en una variable temporal*/
	bl scanf						/*Se lee lo ingresado por el usuario*/

	ldr r1,=respuesta				/*Se apunta a lo ingresado*/
	ldrb r1,[r1] 
	ldr r0,=respuestas_arte			/*Se apunta al vector de respuestas*/
	ldrb r0,[r0,r10] 				/*Apuntamos a la respuesta correcta dependiendo de la pregunta*/
	cmp r1, r0						@Se compara respuesta ingresada y respuesta correcta
	beq seguirTurno
	bne incorrecta

/*r8 -> categoria aleatoria      r9 -> pregunta aleatoria      r10 -> direccion de la respuesta correcta */
/* CATEGORIA -> HISTORIA */
mostrar_categoria5:
	/* Dependiendo del valor de r9, escoge la pregunta y posibles respuestas correspondientes */
	cmp r9, #0
	ldreq r0, =historia_1
	bleq puts

	cmp r9, #1
	ldreq r0, =historia_2
	bleq puts

	cmp r9, #2
	ldreq r0, =historia_3
	bleq puts

	cmp r9, #3
	ldreq r0, =historia_4
	bleq puts

	cmp r9, #4
	ldreq r0, =historia_5
	bleq puts

	cmp r9, #5
	ldreq r0, =historia_6
	bleq puts

	/*Pedimos la respuesta*/
	ldr r0,=formato					/*Formato de impresion*/	
	ldr r1,=respuesta				/*Se guarda lo ingresado en una variable temporal*/
	bl scanf						/*Se lee lo ingresado por el usuario*/

	ldr r1,=respuesta				/*Se apunta a lo ingresado*/
	ldrb r1,[r1] 
	ldr r0,=respuestas_historia		/*Se apunta al vector de respuestas*/
	ldrb r0,[r0,r10] 				/*Apuntamos a la respuesta correcta dependiendo de la pregunta*/
	cmp r1, r0						@Se compara respuesta ingresada y respuesta correcta
	beq seguirTurno
	bne incorrecta

/*r8 -> categoria aleatoria      r9 -> pregunta aleatoria      r10 -> direccion de la respuesta correcta */
/* CATEGORIA -> DEPORTES Y ENTRETENIMIENTO */
mostrar_categoria6:
	/* Dependiendo del valor de r9, escoge la pregunta y posibles respuestas correspondientes */
	cmp r9, #0
	ldreq r0, =deportes_1
	bleq puts

	cmp r9, #1
	ldreq r0, =deportes_2
	bleq puts

	cmp r9, #2
	ldreq r0, =deportes_3
	bleq puts

	cmp r9, #3
	ldreq r0, =deportes_4
	bleq puts

	cmp r9, #4
	ldreq r0, =deportes_5
	bleq puts

	cmp r9, #5
	ldreq r0, =deportes_6
	bleq puts

	/*Pedimos la respuesta*/
	ldr r0,=formato					/*Formato de impresion*/	
	ldr r1,=respuesta				/*Se guarda lo ingresado en una variable temporal*/
	bl scanf						/*Se lee lo ingresado por el usuario*/

	ldr r1,=respuesta				/*Se apunta a lo ingresado*/
	ldrb r1,[r1] 
	ldr r0,=respuestas_deportes		/*Se apunta al vector de respuestas*/
	ldrb r0,[r0,r10] 				/*Apuntamos a la respuesta correcta dependiendo de la pregunta*/
	cmp r1, r0						@Se compara respuesta ingresada y respuesta correcta
	beq seguirTurno
	bne incorrecta

/*r0 -> respuesta ingresada      r6 -> jugador actual      r10 -> direccion del contador correcto	r11 -> contador extra para direccionar los vectores */
/* Si la respuesta fue CORRECTA y ya obtuvo 3 respuestas correctas de dicha categoria, se muestra el personaje */
seguirTurno: 
	ldr r0, =respuestaCorrecta		/*La respuesta es correcta*/
	bl puts
	/*SUMANDO RESPUESTA CORRECTA AL VECTOR*/

	cmp r6, #1						/*Comparamos que jugador es para incrementar el contador*/
	ldreq r11,=contadorJ1			/*Se apunta al vector de respuestas J1*/
	ldrne r11,=contadorJ2			/*Se apunta al vector de respuestas J2*/

	mov r10, #4						/*bytes*/
	mul r10, r8						/*Direccion del contador correcto dentro del vector*/
	add r11, r11, r10				/*Direccion actual*/

	ldr r1, [r11]					/*Jalamos el numero a r1*/
	add r1, r1, #1					/*Sumamos 1 al contador*/
	str r1,[r11],r10				/*Se guarda en la posicion correspondiente de notas el valor guardado en r1*/
	
	cmp r1, #3
	beq mostrarPersonaje			/*Si tiene 3 correctas de la misma categoria (y por primera vez), se gana al personaje*/
	bne sumarCorrecta				/*De lo contrario, solo sumamos una respuesta correcta*/

/*r8 -> categoria aleatoria */
mostrarPersonaje:
	cmp r8, #0
	beq ganar_personaje1			/*Se gana el personaje de ciencias*/

	cmp r8, #1
	beq ganar_personaje2			/*Se gana el personaje de literatura*/		

	cmp r8, #2
	beq ganar_personaje3			/*Se gana el personaje de geografia*/

	cmp r8, #3
	beq ganar_personaje4			/*Se gana el personaje de arte*/

	cmp r8, #4
	beq ganar_personaje5			/*Se gana el personaje de historia*/

	cmp r8, #5
	beq ganar_personaje6			/*Se gana el personaje de deportes y entretenimiento*/

/*r7 -> cantidad de respuestas correctas por ronda */

/* Una vez llegue a 3 respuestas correctas seguidas, se cambia de turno */
sumarCorrecta:
	/*Sumando respuesta correcta al contador si r7 es 3, cambiar turno*/
	add r7, r7, #1					/* r7++ */
	cmp r7, #3						/* Si r7 es 3, cambiar de turno */
	beq tresBuenas					/* Se cambia turno */

	b categoria_aleatoria			/*Si tiene respuesta correcta, el jugador sigue en turno*/

/*r0 -> mensaje tres respuestas correctas */
tresBuenas:
	ldr r0, =tresSeguidas
	bl puts
	b cambiarTurno

/*r0 -> mensaje respuesta incorrecta */
incorrecta:
	ldr r0, =respuestaIncorrecta	/*La respuesta es incorrecta*/
	bl puts


/*r6 -> turno actual  */
cambiarTurno:
	cmp r6, #1
	moveq r6, #2					/*Si el jugador actual es 1, se cambia a jugador 2*/
	movne r6, #1					/*Si el jugador actual es 2, se cambia a jugador 1*/

	b mostrar_jugador				/*Cambiamos al jugador que toque*/

ganarJuego:
	cmp r6, #1
	ldreq r1, =nom_jugador1
	ldrne r1, =nom_jugador2
	ldr r0, =jugador_ganador
	bl printf
	
finalizarJuego:
	pop {r4-r12, pc}				/*Regresando sin error*/


/* Se muestra el ascii Art del personaje ganado */
ganar_personaje1:
	ldr r0, = ciencia            /* cargamos personaje ciencias*/ 
	bl puts						 /* se muestra */
	ldr r0, = ciencia2           /* cargamos personaje ciencias*/ 
	bl puts						 /* se muestra */

	ldr r1, =categoria1			/*Se carga la categoria ganada*/
	ldr r0, =ganaPersonaje
	bl printf

	b revisarGanar				/* Se revisa si ya llego a los tres personajes */


ganar_personaje2:
	ldr r0, = literatura        /* cargamos personaje literatura*/ 
	bl puts						/* se muestra */
	ldr r0, = literatura2	    /* cargamos personaje literatura*/ 
	bl puts						/* se muestra */
	ldr r0, = literatura3       /* cargamos personaje literatura*/ 
	bl puts						/* se muestra */
	ldr r0, = literatura4       /* cargamos personaje literatura*/ 
	bl puts						/* se muestra */
	ldr r0, = literatura5       /* cargamos personaje literatura*/ 
	bl puts						/* se muestra */

	ldr r1, =categoria2			/*Se carga la categoria ganada*/
	ldr r0, =ganaPersonaje
	bl printf

	b revisarGanar				/* Se revisa si ya llego a los tres personajes */

ganar_personaje3:
	ldr r0, = mundo				/* cargamos personaje geografia*/ 
	bl puts						/* se muestra */
	ldr r0, = mundo2            /* cargamos personaje geografia*/ 
	bl puts						/* se muestra */
	ldr r0, = mundo3            /* cargamos personaje geografia*/ 
	bl puts						/* se muestra */

	ldr r1, =categoria3			/*Se carga la categoria ganada*/
	ldr r0, =ganaPersonaje
	bl printf

	b revisarGanar				/* Se revisa si ya llego a los tres personajes */

ganar_personaje4:
	ldr r0, = arte				/* cargamos personaje arte*/ 
	bl puts						/* se muestra */
	ldr r0, = arte2				/* cargamos personaje arte*/ 
	bl puts						/* se muestra */

	ldr r1, =categoria4			/*Se carga la categoria ganada*/
	ldr r0, =ganaPersonaje
	bl printf

	b revisarGanar				/* Se revisa si ya llego a los tres personajes */

ganar_personaje5:
	ldr r0, = historia           /* cargamos personaje historia*/ 
	bl puts						 /* se muestra */
	ldr r0, = historia2          /* cargamos personaje historia*/ 
	bl puts						 /* se muestra */
	ldr r0, = historia3          /* cargamos personaje historia*/ 
	bl puts						 /* se muestra */

	ldr r1, =categoria5			/*Se carga la categoria ganada*/
	ldr r0, =ganaPersonaje
	bl printf

	b revisarGanar				/* Se revisa si ya llego a los tres personajes */

ganar_personaje6:
	ldr r0, = deporte           /* cargamos personaje deportes*/ 
	bl puts						/* se muestra */

	ldr r1, =categoria6			/*Se carga la categoria ganada*/
	ldr r0, =ganaPersonaje
	bl printf

	b revisarGanar				/* Se revisa si ya llego a los tres personajes */

revisarGanar:
	cmp r6, #1
	ldreq r1, =gana1
	ldrne r1, =gana2		/* Se carga el contador de presonajes del jugador indicado */
	ldr r1, [r1]
	add r1, r1, #1			/* Se le suma uno al contador */
	cmp r1, #3			/* Si ha llegado a 3, mostrar mensaje */
	beq ganarJuego
	mov r12, r1
	cmp r6, #1
	ldreq r1, =gana1
	ldrne r1, =gana2
	str r12, [r1]

	mov r12, #0
	mov r1, #0
	b sumarCorrecta


/*INTERFAZ*/
.data
respuesta:	.byte	' '
ingreso_nom:	.asciz "\nHola jugador 1! Ingresa tu nombre:"
ingreso_nom2:	.asciz "\nHola jugador 2! Ingresa tu nombre:"
jugador_actual:	.asciz  "\nEs turno de: %s"
categoria_actual:.asciz  "\nCategoria actual: %s\n"
formato:		.asciz  "\n%s"
num:			.asciz	"\n%d\n"

jugador_ganador: .asciz "\nEl ganador es: %s\n"
gana1:			.word 0
gana2:			.word 0

categoria1:		.asciz "Ciencia y Tecnologia" 
categoria2:		.asciz "Literatura"
categoria3:		.asciz "Geografia"
categoria4:		.asciz "Arte"
categoria5:		.asciz "Historia"
categoria6:		.asciz "Entretenimiento  y Deportes"

respuestaCorrecta:		.asciz "\nLo ingresado es correcto! Sigues jugando"
respuestaIncorrecta:	.asciz "\nLo ingresado es incorrecto! Pierdes turno"
tresSeguidas:			.asciz "\nLograste tres seguidas, cambio de turno!"
ganaPersonaje:			.asciz "\nTe has ganado el pesonaje de: %s !"

/*Los contadores llevan el orden de las categorias, al llegar a 3 se gana al personaje*/
contadorJ1:		.word 0, 0, 0, 0, 0, 0
contadorJ2:		.word 0, 0, 0, 0, 0, 0

/*PREGUNTAS PARA -> CIENCIAS*/
ciencia_1:		.asciz "\nComo se llama el componente minimo que forma a los seres vivos?\na. Tejido\nb. Celula\nc. Particula" 
ciencia_2:		.asciz "\nUnidad basica de la materia\na. Atomo\nb. Celula\nc. Mitocondria"
ciencia_3:		.asciz "\nLa  columna más a la derecha de la tabla periódica esta compuesta por\na. Haluros\nb. Gases nobles\nc. Minerales"
ciencia_4:		.asciz "\nQue elemento tiene el simbolo Cu?\na. Cobre\nb. Carbon\nc. Calcio"
ciencia_5:		.asciz "\nCiencia que estudia los seres vivos\na. Viviologia\nb. Organismologia\nc. Biologia"
ciencia_6:		.asciz "\nLa velocidad a la que viaja la luz es\na. 300,000 m/s\nb. 300,000 km/s\nc. 30,000 km/h"
respuestas_ciencia:	.byte  'b', 'a', 'b', 'a', 'c', 'b'

literatura_1:		.asciz "\nQuien escribio 'La Iliada'?\na. Homero\nb. Herodoto\nc. Seneca"     
literatura_2:		.asciz "\nQuien es el autor de la 'Divina comedia'?\na. Petrarca\nb. Virgilio\nc. Dante Alighier"
literatura_3:		.asciz "\nQue autor NO pertenece al boom latinoamericano?\na. Julio Cortazar\nb. Ruben Dario\nc. Gabriel Garcia Marquez"
literatura_4:		.asciz "\nObra literaria mas vendida de la historia\na. El Hobbit\nb. El senor de los Anillos\nc. Don Quijote de la Mancha"
literatura_5:		.asciz "\nAutor que escribe en el genero de terror\na. Stephen King\nb. JK Rowling\nc. William Shakespeare"
literatura_6:		.asciz "\nCual de los autores SI pertenece al genero del realismo magico y es guatemalteco?\na. Frida Kahlo\nb. Gabriel Garcia Marquez\nc. Miguel Angel Asturias"
respuestas_literatura:	.byte 'a', 'c', 'b', 'c', 'a', 'c'

geografia_1:		.asciz "\nContinente con la mayor cantidad de paises\na. Africa\nb. Europa\nc. Asia"  
geografia_2:		.asciz "\nPais mas grande del mundo\na. China\nb. Rusia\nc. Canada"
geografia_3:		.asciz "\nDe qué tiene forma Italia?\na. Camisa\nb. Sombrero\nc. Bota"
geografia_4:		.asciz "\nPais con la mayor poblacion del mundo\na. China\nb. India\nc. Brasil"
geografia_5:		.asciz "\nDonde se encuentra el rio mas grande de Africa?\na. Argelia\nb. Egipto\nc. Madagascar"
geografia_6:		.asciz "\nCual de los siguientes es el lago mas grande del mundo?\na. Mar Rojo\nb. Mar Mediterraneo\nc. Mar Caspio"
respuestas_geografia:	.byte 'a', 'b', 'c', 'a', 'b', 'c'

arte_1:			.asciz "\nA que movimiento pertenecio Pablo Picasso?\na. Cubismo\nb. Surrealismo\nc. Realismo"
arte_2:			.asciz "\nArtista que se corto su propia oreja\na. Donatello\nb. Leonardo\nc. Vincent Van Gogh"
arte_3:			.asciz "\nArtista y miembro de las tortugas ninja\na. Claude Monet\nb. Miguel Angel\nc. Leonardo Da Vinci"
arte_4:			.asciz "\nCual era el 6o nombre de Picasso?\na. Juan\nb. Francisco de Paula\nc. Nepomuceno"
arte_5:			.asciz "\nQuien fue el primer arquitecto encargado de 'La Sagrada Familia'?\na. Francisco del Villar\nb. Antonio Gaudi\nc. Juan Rubio"
arte_6:			.asciz "\nCual de estos era inventor a parte de ser artista?\na. Dali\nb. Duchamp\nc. Da Vinci"
respuestas_arte:	.byte 'a', 'c', 'b', 'c', 'b', 'c'

historia_1:		.asciz "\nCuantas veces fue apunalado el emperador Julio Cesar?\na. 23\nb. 21\nc. 24"
historia_2:		.asciz "\nDonde se asento la primera civilizacion?\na. Rio Nilo\nb. Mesopotamia\nc. Amazonas"
historia_3:		.asciz "\nLugar donde cruzan los humanos a América\na. Estrecho de Bering\nb. Estrecho de Gibraltar\nc. Estrecho de Malaca"
historia_4:		.asciz "\nCiudad destruida por la erupcion del Monte Vesuvio\na. Troya\nb. Atenas\nc. Pompeya"
historia_5:		.asciz "\nCaracteristica geografica donde se asientan las civilizaciones\na. Rios\nb. Montanas\nc. Playas"
historia_6:		.asciz "\nQuien estaba al mando del mayor imperio en la historia?\na. La corona inglesa\nb. Genghis Khan\nc. Alejandro el Grande"
respuestas_historia:	.byte 'a', 'b', 'a', 'c', 'a', 'a'

deportes_1:		.asciz "\nQue pelicula de la trilogia del Senor de los Anillos gano todos los oscares a los cuales fue nominada?\na. La Comunidad del Anillo\nb. Las Dos Torres\nc. El Retorno del Rey"
deportes_2:		.asciz "\nArtista mas vendido de la historia\na. Elvis Presley\nb. Michael Jackson\nc. Elton John"
deportes_3:		.asciz "\nCual es el videojuego mas vendido de la historia?\na. Tetris\nb. Minecraft\nc. GTAV"
deportes_4:		.asciz "\nCual es el deporte mas visto en las olimpiadas?\na. Natacion\nb. Atletismo\nc. Gimnasia"
deportes_5:		.asciz "\nCual es el pais con mayor cantidad de mundiales de futbol?\na. Brasil\nb. Alemania\nc. Italia"
deportes_6:		.asciz "\nCuantos kilometros se recorren en el Tour de Francia?\na. 5600\nb. 5500\nc. 5700"
respuestas_deportes:	.byte 'c', 'a', 'b', 'c', 'a', 'b'


/*PERSONAJES DENTRO DE LA TRIVIA*/
ciencia: .asciz "\n..II7IIIIIIII$NIIIIIIIIIIIIIII~~I.......\n..IIIIIIIIIINNIIIII78MI7IIIIIII=~+......\n..IIIIIIIIIIIIIIIIII7II7IIIIIII=7.......\n....,,,$$$$$$$$$$$$$$7$$$$77+,.....I.II.\n.......777777$$7$7777$777777=.....,I,I,.\n.......7777777NN777NM7777777=....,III~7:\n.......7777777NN777NM7777777=......III..\n.......7777777NN777NN7777777=......I=...\n.......777$$$7MN$77MM777$777=......I....\n.......7777777$$$777$$777777=......I....\n.......777777887$777OD777777=.....?+....\n.......7777777$$$77$77777777=....,I.....\n.......777777777777777777777=...,I,.....\n.......777777777777777777777=..II.......\n.......7777777777777777777777II.........\n.......777777777777777777777=...........\n.......77777777777777777777$=...........\n.......777777777777777777777=...........\n......I777777777777777777777=...........\n.....II777777777777777777777=...........\n....,I.77777777777777777+~77=...........\n....7~.7777777777777777~~~77=...........\n....I..7777777777777777~~~77=...........\n...:I..7777777777777777~~~77=..........."
ciencia2: .asciz "...I:..7777777777777777~~~77=...........\n...I...7777777777777777~~~77=...........\n...I...777777$7$$777777~~~77=...........\nI??7II.77$OOO888OO$7777~~~77=...........\n:7II.I.77788888O8O888OO~~~77=...........\n,.,I...777O88O8O888888O~~~77=...........\n.......777O888OOO88888O~~~$7=...........\n.......7778888OOOO88888~=+7$,...........\n.......:77O8888OO88888O~877$............\n........77$O888888OO8OO8$7$,............\n.........$$778OOOOOO8O8$77..............\n...........777$7ZOO$7$$77...............\n.............77$7$$7$7,.................\n...............I+..I+...................\n...............I,..?I...................\n...............7...,I...................\n.......,~~I:::~7~::~:...........\n.....::7IIII+:::IIII7I~::,........\n......:::::::~:::~::..........\n.............,:::~~:::,.................\n"
deporte: .asciz "\n........................................\n...............??.......................\n.............IIIIII?....$7..............\n....777.....IIII~~~..7..............\n.....7$....I~~D8~.................\n......,...~~?IIDII~...............\n.......7..~~+IIIIIDI8ZI8DDDZ............\n........$+IIII?IIID?IINN8DDDZ...........\n.........IIIIIIIIIIIIINNNNDD$...........\n.........7IIIIIIIIIIIINNNN8DDZ..........\n.........IIIIIIIIIIIII?NNNDDDZ..........\n.........II$IIIIIIIIIII~~+~DI...........\n.........IIIIIIIIIIIII?II==II...........\n..........IIIIIIIIIIIIIII7?.............\n..........IIIIIIIIIIIIIIIII.............\n...........IIIIIIIIIIIIIIII.............\n............IIIIIIIIIIIII~..............\n.............~~~~...............\n...............~~~+7.77...........\n................IIIIIII?................\n...................II?7.................\n......................+.................\n...............+++++++++++:.............\n........................................\n........................................\n"
historia: .asciz "\n............................................................\n............................................................\n............................................................\n.......................................~~==...............\n.....................................=~~~=..............\n...........................+?+?++++++=~~~=+.............\n......................=..???+++++++++++?~~..............\n.....................77777I??++++++++++?+?~~............\n....................7777777777?+?+?++++++++~~~............\n...................777Z$$7777777++++++++++++~.............\n..................7777$$77$$777777I+++++++?+~=............\n.................77777Z777$$77$$7777++??++++~~~...........\n...................:77777$Z77Z$7777777++++++~~..........\n...................DDDDZ7777$$$77Z$77777++??~~~=..........\n..................DDDDDDDDO77777$$777777++++~~:...........\n.................,DDDDD8DDDDD7777$77777?++?~..............\n.................+8DDD8~=DDD8DD87777777++?+~.............."
historia2: .asciz "................,?++D88=DD=8DDD8877$$$$$7~~,..............\n................++?++ZD8D88DDDDD8DDZ$$$$$$..................\n................?+?+???+DDDD8DDD8DD$$$$$$$..................\n................++I7?++?++??+=ODDD+$$$$$$$..................\n...............I??777?+777+++?????+?$$$$,...................\n..............=.++777777777+++++?++?+?+.....................\n..............=.+7+++??777+?++++++7I?++.....................\n...............:+?+++++?7+++++++++7?+++.....................\n................:++++++?+77+++?++77??++.....................\n.................?+++++++?777777I7?++++.....................\n.................+++++++++?+++?++??++++.....................\n..................+?+++++++++++++++++?+.....................\n....................7++++???+++???++........................\n....................7.............77........................\n....................7...............7.......................\n..................:==7============+I7===~..................."
historia3: .asciz ".............+=====I7777+=========777777======..............\n...............+=====777====================~...............\n............................................................\n............................................................\n............................................................\n"
arte: .asciz "\n.........................OOOOOOOOO8888,.\n....................7.8OOOOOOOO8888,....\n..................OO8OOOOOOOOO8888......\n................OOOOOOOOOOOOOO888$......\n...............OOOOOOOOOOOOOOO888.......\n..............$OOOOOOOOOOOOOOO888.......\n..............OOOOOOOOOOOOOOOO888.......\n..............8OOOOOOOOOOOOOOO888~......\n.......,.......OOOOOOOOOOOOOO8888.......\n......+O7O.....I8DOOOOOOOOOOO8888.......\n......=$$=....+++++++N8OOOO88888,.......\n.......~O...$$$$7?+++++OO888888,........\n........O.$$$7$ZN$$N7++++8888,..........\n........Z7$$$$7N7$NN$$$++......Z.,......\n.......?$$$7$$NN$ON$$$$$$....,~OZ?......\n.......$$$$7$7N$$NZ$$$$$$.....ZOZO......\n......$$$$$$8$$$$8$$$$$$7....O~.........\n.....,$$$$$$$$D$$ZZ$77$$$..$O...........\n.....$$7$$$$$$$$$$$$$$$$$.ZZ............\n.....$$$$$$$$$$$$$$$$$$$$Z,.............\n.....7$$$$$$$$$$$$$$$$$$Z...............\n.....$$$$$$$$$$$$$$$$$$$................\n.....$$$$$$$$$$$$$$$$$$.................\n.....$$$$$$$$$$$$$$$$$+................."
arte2: .asciz ".....$$$$$$$$$$$$$$$$7..................\n.....7$$$$$$$$$$$$$$$...................\n.....$$$$$$$$$$$$$$$+...................\n.....,$$$$$$$$$$$$$$....................\n......$$$$$$$$$$$$$?....................\n......:$$$$$$$$$$$7.....................\n.......$7$$$$$$$$$7.....................\n.......+$$$$$$$$$$,.....................\n........$$$$$$$$$$......................\n.........$$$$$$$$$......................\n..........7$$$$$$.......................\n............II,O........................\n............,O.?........................\n....:::::~O:~7::~:~~..............\n...,:::~::~:::::~::.............\n..........,,::~~:::,....................\n"
mundo: .asciz "\n....................+++++++++++++++++?......................\n................777+++++++++++++++++++++++..................\n..............7777$I+++++7+++++++++++77777I+................\n............$77777777777777$$?+++++777777777$7..............\n..........:$777777777777777777++++?777777777$77~............\n.........$77777777777777777++++$77777777777777777...........\n........777777777777777O8$777778$7777777777777777$..........\n.......7777777777777778$7777777788$777777777777777$,........\n......777777777777777777777777777777777777777777777I........\n.....$777777777777777777777777777777777777777777777+?.......\n....,7777777777777777777O$7777$$77777777777777777777+:......\n....$777777777777777777ZDD7777DD77777777777777777777++......\n....7777777777777777777ZDD7777DD77777777777777777777$+......\n....7777777777777777777ZND7777DD7777$777777777777777I+......\n...~7777777777777777Z777Z777777777$O77777777777777$?+++.....\n...=77777777777777777O77777777777ZZ77777777777777$+++++....."
mundo2: .asciz "...:7777777777777777777OOZ$77ZOO77777777777777777+++++=.....\n....777777777777777777777777777777777777777777777+++++,.....\n....7777777777777777777777777777777777777777777777++++......\n....I77777777777777777777777777777777777777777777777+?......\n.....777777777777777777777777777777777777777777777$I+.......\n.....?7777777777777777777777777777777777777777777777?.......\n......7777777777777777777777777777777777777777777777........\n......+$777777777777777$$7777777777777777777777777$+........\n......+.7777777777I++++++++I$777777777777777777777,?........\n.....+=..I7777777?+++++++++++++++I77777777777777I..:+.......\n.....+....:777777$+++++++++++++++++777777777$77~....+:......\n=++++......?7777++++++++++++++++++?777777777I.......+...~.\n+?++.........~7I++++++++++++++++++77777777..........?+=,..\n=,.~+............I+?++++++++++++++?77777$.............+=+++,\n...................=+?+?++++++++++++?,+,..............+=....\n...................+..................,+...................."
mundo3: .asciz "..................,+...................+,...................\n...................?...................+,...................\n...........,::~::++:~~::~~~+:::~~:,.............\n.........:~:=++++::~~~~~+?++=~~...........\n...........:::~::~:~~~:~~::::~:.............\n....................,,,:::::~~:::::,,,......................\n"
literatura: .asciz "\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM::::::MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM$::::::::+MM$ZMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMM:::::::MZ::7::::::::::I::::O:::~N:::~MMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMI:::::::~:::::::::::,::::::::::::::::::::MMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMM:::::::::::::::::::::::::::::::::,,:::::::MMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMM+::::,::,:,::::::::::::::::::::::::::::::::MMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMDZ::::::::::::::::::::,,,::::::::::::::::::::::7MMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMM+::::::::::::::::::::::,::::::::::::::::::::::::::MMMMMMMMMMMMMMMMM\nMMMMMMM8:::::::::::::::::::::::,::,,:::::::::::::::::::::::::::::::$DMMMMMMMMMMM\nMMMMMMD:::::,::::::::::::::::::::::::::::::::::::::::::,::::::::::::::OMMMMMMMMM\nMMMMMMZ:::::::::::::::::::::::::::::::::::::::,::::::::::,:::::::::::::MMMMMMMMM\nMMMMMMM::::::::::::,:,::::::::::::::::::::::,:::,,:::::::::::::::::::::MMMMMMMMM"
literatura2: .asciz "MMMMMMN$:::,::::::::,:::::::::,,,,:::::::::::::::,:,::::::::$MMMMMMMMM\nMMMMD::::,::::::::::::::::::::::::,,::::::::::::::::::::::::::::::::::::$MMMMMMM\nMMMMN:::::::::::::::::::::::::::::,::::::::::::::::::::::::::::::::::::::MMMMMMM\nMMMMMN~::::::=+??+=::::===+=:::::=????+=::::::=+++==::::+???+~:::::=MMMMMMMM\nMMMMMM:::::+????????+==========????????????+:=========+:?????????:::~MMMMMMMMM\nMMMMMMM?::+??????????+=========+OZ??????????7Z?+=========???????????ODMMMMMMMMMM\nMMMMMMMMMMMI?????????+======+ODD8????????????8DDO========??????????8MMMMMMMMMMMM\nMMMMMMMMMMMZ?????????+=======8Z+??????????????+$8?=======??????????MMMMMMMMMMMMM\nMMMMMMMMMMMM?????????+==========??????????????+==========??????????MMMMMMMMMMMMM\nMMMMMMMMMMMM??????????==========??????????????+==========??????????MMMMMMMMMMMMM\nMMMMMMMMMMMM7?????????==========??????????????+=========+?????????OMMMMMMMMMMMMM\nMMMMMMMMMMMMD?????????+=========??????????????+=========+?????????MMMMMMMMMMMMMM"
literatura3: .asciz "MMMMMMMMMMMMM?????????==========??????????????+=========??????????MMMMMMMMO8MMMM\nMMM7IMMMMMMMM?????????==========DDD????????7DDD=========??????????MMMMMM$M7IMDII\nINNIIM7NMMMMMO????????++=======+DDD????????ZDDD=========?????????OMMMMMMIIOIOIIN\nIIDIIIIMMMMMMM????????++=======+DDD????????ZDDD=========?????????MMMMMMMMIIII7MM\nMIIIIIMMMMMMMM?????????========+DDD????????ZDDD========+?????????MMMMMMMMMDIIMMM\nMM$IDMMMMMMMMMZ????????========+DDD????????ZDDD========+????????IMMMMMMMMMMZIMMM\nMMZIMMMMMMMMMMM????????==++====+DDD????????ZDDD=====++=?????????ZMMMMMMMMMM7IMMM\nMMMI8MMMMMMMMMM????????===7====+DDD????????ZDDD=====I==?????????NMMMMMMMMMMIOMMM\nMMMIIMMMMMMMMMM7???????====Z====8DD????????IDD8+===$===?????????MMMMMMMMMM$IMMMM\nMMMMI$MMMMMMMMMN???????+====ZI+==?????????????===+Z+===?????????MMMMMMMMM77MMMMM\nMMMMM7IOMMMMMMMM???????+=====+7O??????????????+Z$======?????????MMMMMMOIIZMMMMMM\nMMMMMMN7IIZDNDZI????????========+$OOOZZ$$ZOOOZ+=======+?????????IIIIIIIDMMMMMMMM"
literatura4: .asciz "MMMMMMMMMMMNDNMMI???????=========????????????+========+????????8MMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMZ???????========+????????????+========?????????MMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMM???????=========????????????+========?????????MMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMM???????+========????????????+========????????IMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMI??????+========????????????+========????????8MMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMD???????========????????????+=======+????????MMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMM???????=======+????????????+=======+????????MMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMM???????========????????????========+???????7MMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMO??????========????????????========+???????8MMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMM??????+=======????????????========+???????MMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMM??????+=======+???????????+=======????????MMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMD$???+=======+???????????+=======?????$DNMMMMMMMMMMMMMMMMMMM"
literatura5: .asciz "MMMMMMMMMMMMMMMMMMMMMMMMMMM87+=+=+???????????=++=++?7MMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMI$MMMMMMMMMMMMMMMMIMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNINMMMMMMMMMMMMMMMMIOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMI8MMMMMMMMMMMMMMMMI8MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMIIMMMMMMMMMMMMMMMMIMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMD$IIIDMMMMMMMMMMMMMMI$NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMIIIIOMMMMMMMMMMMMMMMMMIIII7ZMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n"









