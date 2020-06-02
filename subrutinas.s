/*Subrutinas que llevan a cabo las operaciones de la trivia ARM*/

.data
seed: 	.word 	1
const1:	.word	1103515245
const2:	.word	12345

.text
.global myrand, mysrand

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

mysrand:				/*Retorna el aleatorio*/
	ldr r1, =seed		/*Se jala la semilla*/
	str r0, [r1]		/*Se guarda R0 en R1*/
	mov pc, lr			/*Se retorna*/


.text

/*	Parametros	> r1 el nombre del jugador 1
	Retorna		> r0 con el nombre del jugador	 */
.global nombre_jugador1
nombre_jugador1:
	push {r4-r12, lr}

	ldr r0,=ingreso_nom     /* cargar dirección de la cadena a imprimir*/ 
	bl puts					/* se muestra */	

	ldr r0,=formato			/*Formato de impresion*/	
	ldr r1,=nom_jugador		/*Se guarda lo ingresado dentro de nom_jugador*/
	bl scanf				/*Se lee lo ingresado por el usuario*/
	
	ldr r1,=nom_jugador		/*Se obtiene la direccion de nom_jugador*/
	
	pop {r4-r12, pc}		/*Regresando sin error*/




/*	Parametros	> r1 el nombre del jugador
	Retorna		> r0 con el nombre del jugador 2 */
.global nombre_jugador2
nombre_jugador2:
	push {r4-r12, lr}

	ldr r0,=ingreso_nom2     /* cargar dirección de la cadena a imprimir*/ 
	bl puts					/* se muestra */	

	ldr r0,=formato			/*Formato de impresion*/	
	ldr r1,=nom_jugador		/*Se guarda lo ingresado dentro de nom_jugador*/
	bl scanf				/*Se lee lo ingresado por el usuario*/
	
	ldr r1,=nom_jugador		/*Se obtiene la direccion de nom_jugador*/
	
	pop {r4-r12, pc}		/*Regresando sin error*/

/*	Parametros	> r6 turno actual, r5 nombre jugador 2, r4 nombre jugador 1
	Retorna		>  */
.global jugarTurnos
jugarTurnos:
	push {r4-r12, lr}

aleatorios:
	bl myrand					/*R0 contendra el numero aleatorio generado*/
	push {r0}					/*R0 se mete al stack*/

	mov r1,r0					/*Se guarda r0 en r1*/
	and r1,r1,#5				/*R1 llevara el limite superior de numero a generar -> Cantidad de categorias*/
	mov r8, r1					/*Se jala a r8 el numero aleatorio*/
	pop {r0}					/*Se saca r0 del stack*/
	
	cmp r6, #1
	moveq r1, r4				/*Se jala el nombre del jugador actual*/
	movne r1, r5				
	ldr r0, = jugador_actual    /* cargar dirección de la cadena a imprimir*/ 
	bl printf                   /* se muestra */

	bl myrand					/*R0 contendra el numero aleatorio generado*/
	push {r0}					/*R0 se mete al stack*/

	mov r1,r0					/*Se guarda r0 en r1*/
	and r1,r1,#5				/*R1 llevara el limite superior de numero a generar -> Cantidad de preguntas*/
	mov r9, r1					/*Se jala a r9 el numero aleatorio*/
	pop {r0}					/*Se saca r0 del stack*/

	mov r10, #4					/*bytes*/
	mul r10, r9					/*Direccion de la respuesta correcta dentro del vector*/

	/*r8 -> categoria aleatoria      r9 -> pregunta aleatoria      r10 -> direccion de la respuesta correcta */
	cmp r8, #0
	b mostrar_categoria1
	
mostrar_categoria1:					/*CATEGORIA -> CIENCIAS*/
	/*Comparamos que pregunta es*/
	cmp r9, #0
	ldreq r0, =ciencia_1
	bleq puts						/*Se muestra la pregunta correspondiente*/
	ldreq r0, =aleatorios1_ciencia
	cmp r9, #1
	ldreq r0, =ciencia_2
	bleq puts						/*Se muestra la pregunta correspondiente*/
	ldreq r0, =aleatorios2_ciencia
	cmp r9, #2
	ldreq r0, =ciencia_3
	bleq puts						/*Se muestra la pregunta correspondiente*/
	ldreq r0, =aleatorios3_ciencia
	cmp r9, #3
	ldreq r0, =ciencia_4
	bleq puts						/*Se muestra la pregunta correspondiente*/
	ldreq r0, =aleatorios4_ciencia
	cmp r9, #45
	ldreq r0, =ciencia_5
	bleq puts						/*Se muestra la pregunta correspondiente*/
	ldreq r0, =aleatorios5_ciencia
	cmp r9, #5
	ldreq r0, =ciencia_6
	bleq puts						/*Se muestra la pregunta correspondiente*/
	ldreq r0, =aleatorios6_ciencia
	bl puts							/*Se muestran las respuestas correspondientes*/

	/*Pedimos la respuesta*/
	ldr r0,=formato				/*Formato de impresion*/	
	ldr r1,=respuesta			/*Se guarda lo ingresado en una variable temporal*/
	bl scanf					/*Se lee lo ingresado por el usuario*/

	ldr r1,=respuesta				/*Se apunta a lo ingresado*/
	ldrb r1,[r1] 
	ldr r0,=respuestas_ciencia		/*Se apunta al vector de respuestas*/
	ldrb r0,[r0,r10] 				/*Apuntamos a la respuesta correcta dependiendo de la pregunta*/
	cmp r1, r0						@Se compara respuesta ingresada y respuesta correcta
	ldreq r0, =respuestaCorrecta	/*La respuesta es correcta*/
	ldrne r0, =respuestaIncorrecta	/*La respuesta es incorrecta*/
	bl puts
	
finalizarTurno:
	pop {r4-r12, pc}			/*Regresando sin error*/

ganar_personaje1:
	ldr r0, = ciencia            /* cargamos personaje deportes*/ 
	bl puts						 /* se muestra */
	ldr r0, = ciencia2            /* cargamos personaje deportes*/ 
	bl puts						 /* se muestra */
	mov pc, lr 


.data
respuesta:	.byte	' '

nom_jugador:	.asciz "            "
ingreso_nom:	.asciz "\nHola jugador 1! Ingresa tu nombre:"
ingreso_nom2:	.asciz "\nHola jugador 2! Ingresa tu nombre:"
jugador_actual:	.asciz  "\nEs turno de: %s"
categoria_actual:.asciz  "\nCategoria actual: %s\n"
formato:		.asciz  "\n%s"
num:			.asciz	"\n%d\n"

categoria1:		.asciz "Entretenimiento  y Deportes"
categoria2:		.asciz "Literatura"
categoria3:		.asciz "Ciencia y Tecnologia"
categoria4:		.asciz "Geografia"
categoria5:		.asciz "Arte"
categoria6:		.asciz "Historia"

respuestaCorrecta:		.asciz "\nLo ingresado es correcto! Sigues jugando"
respuestaIncorrecta:	.asciz "\nLo ingresado es incorrecto! Pierdes turno"

/*PREGUNTAS PARA -> CIENCIAS*/
ciencia_1:	.asciz "\nComo se llama el componente minimo que forma a los seres vivos?"
ciencia_2:	.asciz "\nUnidad basica de la materia"
ciencia_3:	.asciz "\nLa  columna más a la derecha de la tabla periódica esta compuesta por"
ciencia_4:	.asciz "\nQue elemento tiene el simbolo Cu?"
ciencia_5:	.asciz "\nCiencia que estudia los seres vivos"
ciencia_6:	.asciz "\nLa velocidad a la que viaja la luz es"
aleatorios1_ciencia:	.asciz "a. Tejido\nb. Celula\nc. Particula"
aleatorios2_ciencia:	.asciz "a. Atomo\nb. Celula\nc. Mitocondria"
aleatorios3_ciencia:	.asciz "a. Haluros\nb. Gases nobles\nc. Minerales"
aleatorios4_ciencia:	.asciz "a. Cobre\nb. Carbon\nc. Calcio"
aleatorios5_ciencia:	.asciz "a. Viviologia\nb. Organismologia\nc. Biologia"
aleatorios6_ciencia:	.asciz "a. 300,000 m/s\nb. 300,000 km/s\nc. 30,000 km/h"
respuestas_ciencia:		.byte  'b', 'a', 'b', 'a', 'c', 'b'

/*PERSONAJES DENTRO DE LA TRIVIA*/
ciencia: .asciz "\n..II7IIIIIIII$NIIIIIIIIIIIIIII~~I.......\n..IIIIIIIIIINNIIIII78MI7IIIIIII=~+......\n..IIIIIIIIIIIIIIIIII7II7IIIIIII=7.......\n....,,,$$$$$$$$$$$$$$7$$$$77+,.....I.II.\n.......777777$$7$7777$777777=.....,I,I,.\n.......7777777NN777NM7777777=....,III~7:\n.......7777777NN777NM7777777=......III..\n.......7777777NN777NN7777777=......I=...\n.......777$$$7MN$77MM777$777=......I....\n.......7777777$$$777$$777777=......I....\n.......777777887$777OD777777=.....?+....\n.......7777777$$$77$77777777=....,I.....\n.......777777777777777777777=...,I,.....\n.......777777777777777777777=..II.......\n.......7777777777777777777777II.........\n.......777777777777777777777=...........\n.......77777777777777777777$=...........\n.......777777777777777777777=...........\n......I777777777777777777777=...........\n.....II777777777777777777777=...........\n....,I.77777777777777777+~77=...........\n....7~.7777777777777777~~~77=...........\n....I..7777777777777777~~~77=...........\n...:I..7777777777777777~~~77=...........\n"
ciencia2: .asciz "\n...I:..7777777777777777~~~77=...........\n...I...7777777777777777~~~77=...........\n...I...777777$7$$777777~~~77=...........\nI??7II.77$OOO888OO$7777~~~77=...........\n:7II.I.77788888O8O888OO~~~77=...........\n,.,I...777O88O8O888888O~~~77=...........\n.......777O888OOO88888O~~~$7=...........\n.......7778888OOOO88888~=+7$,...........\n.......:77O8888OO88888O~877$............\n........77$O888888OO8OO8$7$,............\n.........$$778OOOOOO8O8$77..............\n...........777$7ZOO$7$$77...............\n.............77$7$$7$7,.................\n...............I+..I+...................\n...............I,..?I...................\n...............7...,I...................\n.......,~~I:::~7~::~:...........\n.....::7IIII+:::IIII7I~::,........\n......:::::::~:::~::..........\n.............,:::~~:::,.................\n"
deporte: .asciz "\n........................................\n...............??.......................\n.............IIIIII?....$7..............\n....777.....IIII~~~..7..............\n.....7$....I~~D8~.................\n......,...~~?IIDII~...............\n.......7..~~+IIIIIDI8ZI8DDDZ............\n........$+IIII?IIID?IINN8DDDZ...........\n.........IIIIIIIIIIIIINNNNDD$...........\n.........7IIIIIIIIIIIINNNN8DDZ..........\n.........IIIIIIIIIIIII?NNNDDDZ..........\n.........II$IIIIIIIIIII~~+~DI...........\n.........IIIIIIIIIIIII?II==II...........\n..........IIIIIIIIIIIIIII7?.............\n..........IIIIIIIIIIIIIIIII.............\n...........IIIIIIIIIIIIIIII.............\n............IIIIIIIIIIIII~..............\n.............~~~~...............\n...............~~~+7.77...........\n................IIIIIII?................\n...................II?7.................\n......................+.................\n...............+++++++++++:.............\n........................................\n........................................\n"
historia: .asciz "\n............................................................\n............................................................\n............................................................\n.......................................~~==...............\n.....................................=~~~=..............\n...........................+?+?++++++=~~~=+.............\n......................=..???+++++++++++?~~..............\n.....................77777I??++++++++++?+?~~............\n....................7777777777?+?+?++++++++~~~............\n...................777Z$$7777777++++++++++++~.............\n..................7777$$77$$777777I+++++++?+~=............\n.................77777Z777$$77$$7777++??++++~~~...........\n...................:77777$Z77Z$7777777++++++~~..........\n...................DDDDZ7777$$$77Z$77777++??~~~=..........\n..................DDDDDDDDO77777$$777777++++~~:...........\n.................,DDDDD8DDDDD7777$77777?++?~..............\n.................+8DDD8~=DDD8DD87777777++?+~..............\n"
historia2: .asciz "\n................,?++D88=DD=8DDD8877$$$$$7~~,..............\n................++?++ZD8D88DDDDD8DDZ$$$$$$..................\n................?+?+???+DDDD8DDD8DD$$$$$$$..................\n................++I7?++?++??+=ODDD+$$$$$$$..................\n...............I??777?+777+++?????+?$$$$,...................\n..............=.++777777777+++++?++?+?+.....................\n..............=.+7+++??777+?++++++7I?++.....................\n...............:+?+++++?7+++++++++7?+++.....................\n................:++++++?+77+++?++77??++.....................\n.................?+++++++?777777I7?++++.....................\n.................+++++++++?+++?++??++++.....................\n..................+?+++++++++++++++++?+.....................\n....................7++++???+++???++........................\n....................7.............77........................\n....................7...............7.......................\n..................:==7============+I7===~...................\n"
historia3: .asciz "\n.............+=====I7777+=========777777======..............\n...............+=====777====================~...............\n............................................................\n............................................................\n............................................................\n"
arte: .asciz "\n.........................OOOOOOOOO8888,.\n....................7.8OOOOOOOO8888,....\n..................OO8OOOOOOOOO8888......\n................OOOOOOOOOOOOOO888$......\n...............OOOOOOOOOOOOOOO888.......\n..............$OOOOOOOOOOOOOOO888.......\n..............OOOOOOOOOOOOOOOO888.......\n..............8OOOOOOOOOOOOOOO888~......\n.......,.......OOOOOOOOOOOOOO8888.......\n......+O7O.....I8DOOOOOOOOOOO8888.......\n......=$$=....+++++++N8OOOO88888,.......\n.......~O...$$$$7?+++++OO888888,........\n........O.$$$7$ZN$$N7++++8888,..........\n........Z7$$$$7N7$NN$$$++......Z.,......\n.......?$$$7$$NN$ON$$$$$$....,~OZ?......\n.......$$$$7$7N$$NZ$$$$$$.....ZOZO......\n......$$$$$$8$$$$8$$$$$$7....O~.........\n.....,$$$$$$$$D$$ZZ$77$$$..$O...........\n.....$$7$$$$$$$$$$$$$$$$$.ZZ............\n.....$$$$$$$$$$$$$$$$$$$$Z,.............\n.....7$$$$$$$$$$$$$$$$$$Z...............\n.....$$$$$$$$$$$$$$$$$$$................\n.....$$$$$$$$$$$$$$$$$$.................\n.....$$$$$$$$$$$$$$$$$+................."
arte2: .asciz "\n.....$$$$$$$$$$$$$$$$7..................\n.....7$$$$$$$$$$$$$$$...................\n.....$$$$$$$$$$$$$$$+...................\n.....,$$$$$$$$$$$$$$....................\n......$$$$$$$$$$$$$?....................\n......:$$$$$$$$$$$7.....................\n.......$7$$$$$$$$$7.....................\n.......+$$$$$$$$$$,.....................\n........$$$$$$$$$$......................\n.........$$$$$$$$$......................\n..........7$$$$$$.......................\n............II,O........................\n............,O.?........................\n....:::::~O:~7::~:~~..............\n...,:::~::~:::::~::.............\n..........,,::~~:::,....................\n"
mundo: .asciz "\n....................+++++++++++++++++?......................\n................777+++++++++++++++++++++++..................\n..............7777$I+++++7+++++++++++77777I+................\n............$77777777777777$$?+++++777777777$7..............\n..........:$777777777777777777++++?777777777$77~............\n.........$77777777777777777++++$77777777777777777...........\n........777777777777777O8$777778$7777777777777777$..........\n.......7777777777777778$7777777788$777777777777777$,........\n......777777777777777777777777777777777777777777777I........\n.....$777777777777777777777777777777777777777777777+?.......\n....,7777777777777777777O$7777$$77777777777777777777+:......\n....$777777777777777777ZDD7777DD77777777777777777777++......\n....7777777777777777777ZDD7777DD77777777777777777777$+......\n....7777777777777777777ZND7777DD7777$777777777777777I+......\n...~7777777777777777Z777Z777777777$O77777777777777$?+++.....\n...=77777777777777777O77777777777ZZ77777777777777$+++++.....\n"
mundo2: .asciz "\n...:7777777777777777777OOZ$77ZOO77777777777777777+++++=.....\n....777777777777777777777777777777777777777777777+++++,.....\n....7777777777777777777777777777777777777777777777++++......\n....I77777777777777777777777777777777777777777777777+?......\n.....777777777777777777777777777777777777777777777$I+.......\n.....?7777777777777777777777777777777777777777777777?.......\n......7777777777777777777777777777777777777777777777........\n......+$777777777777777$$7777777777777777777777777$+........\n......+.7777777777I++++++++I$777777777777777777777,?........\n.....+=..I7777777?+++++++++++++++I77777777777777I..:+.......\n.....+....:777777$+++++++++++++++++777777777$77~....+:......\n=++++......?7777++++++++++++++++++?777777777I.......+...~.\n+?++.........~7I++++++++++++++++++77777777..........?+=,..\n=,.~+............I+?++++++++++++++?77777$.............+=+++,\n...................=+?+?++++++++++++?,+,..............+=....\n...................+..................,+....................\n"
mundo3: .asciz "\n..................,+...................+,...................\n...................?...................+,...................\n...........,::~::++:~~::~~~+:::~~:,.............\n.........:~:=++++::~~~~~+?++=~~...........\n...........:::~::~:~~~:~~::::~:.............\n....................,,,:::::~~:::::,,,......................\n"
literatura: .asciz "\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM::::::MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM$::::::::+MM$ZMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMM:::::::MZ::7::::::::::I::::O:::~N:::~MMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMI:::::::~:::::::::::,::::::::::::::::::::MMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMM:::::::::::::::::::::::::::::::::,,:::::::MMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMM+::::,::,:,::::::::::::::::::::::::::::::::MMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMDZ::::::::::::::::::::,,,::::::::::::::::::::::7MMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMM+::::::::::::::::::::::,::::::::::::::::::::::::::MMMMMMMMMMMMMMMMM\nMMMMMMM8:::::::::::::::::::::::,::,,:::::::::::::::::::::::::::::::$DMMMMMMMMMMM\nMMMMMMD:::::,::::::::::::::::::::::::::::::::::::::::::,::::::::::::::OMMMMMMMMM\nMMMMMMZ:::::::::::::::::::::::::::::::::::::::,::::::::::,:::::::::::::MMMMMMMMM\nMMMMMMM::::::::::::,:,::::::::::::::::::::::,:::,,:::::::::::::::::::::MMMMMMMMM\n"
literatura2: .asciz "\nMMMMMMN$:::,::::::::,:::::::::,,,,:::::::::::::::,:,::::::::$MMMMMMMMM\nMMMMD::::,::::::::::::::::::::::::,,::::::::::::::::::::::::::::::::::::$MMMMMMM\nMMMMN:::::::::::::::::::::::::::::,::::::::::::::::::::::::::::::::::::::MMMMMMM\nMMMMMN~::::::=+??+=::::===+=:::::=????+=::::::=+++==::::+???+~:::::=MMMMMMMM\nMMMMMM:::::+????????+==========????????????+:=========+:?????????:::~MMMMMMMMM\nMMMMMMM?::+??????????+=========+OZ??????????7Z?+=========???????????ODMMMMMMMMMM\nMMMMMMMMMMMI?????????+======+ODD8????????????8DDO========??????????8MMMMMMMMMMMM\nMMMMMMMMMMMZ?????????+=======8Z+??????????????+$8?=======??????????MMMMMMMMMMMMM\nMMMMMMMMMMMM?????????+==========??????????????+==========??????????MMMMMMMMMMMMM\nMMMMMMMMMMMM??????????==========??????????????+==========??????????MMMMMMMMMMMMM\nMMMMMMMMMMMM7?????????==========??????????????+=========+?????????OMMMMMMMMMMMMM\nMMMMMMMMMMMMD?????????+=========??????????????+=========+?????????MMMMMMMMMMMMMM\n"
literatura3: .asciz "\nMMMMMMMMMMMMM?????????==========??????????????+=========??????????MMMMMMMMO8MMMM\nMMM7IMMMMMMMM?????????==========DDD????????7DDD=========??????????MMMMMM$M7IMDII\nINNIIM7NMMMMMO????????++=======+DDD????????ZDDD=========?????????OMMMMMMIIOIOIIN\nIIDIIIIMMMMMMM????????++=======+DDD????????ZDDD=========?????????MMMMMMMMIIII7MM\nMIIIIIMMMMMMMM?????????========+DDD????????ZDDD========+?????????MMMMMMMMMDIIMMM\nMM$IDMMMMMMMMMZ????????========+DDD????????ZDDD========+????????IMMMMMMMMMMZIMMM\nMMZIMMMMMMMMMMM????????==++====+DDD????????ZDDD=====++=?????????ZMMMMMMMMMM7IMMM\nMMMI8MMMMMMMMMM????????===7====+DDD????????ZDDD=====I==?????????NMMMMMMMMMMIOMMM\nMMMIIMMMMMMMMMM7???????====Z====8DD????????IDD8+===$===?????????MMMMMMMMMM$IMMMM\nMMMMI$MMMMMMMMMN???????+====ZI+==?????????????===+Z+===?????????MMMMMMMMM77MMMMM\nMMMMM7IOMMMMMMMM???????+=====+7O??????????????+Z$======?????????MMMMMMOIIZMMMMMM\nMMMMMMN7IIZDNDZI????????========+$OOOZZ$$ZOOOZ+=======+?????????IIIIIIIDMMMMMMMM\n"
literatura4: .asciz "\nMMMMMMMMMMMNDNMMI???????=========????????????+========+????????8MMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMZ???????========+????????????+========?????????MMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMM???????=========????????????+========?????????MMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMM???????+========????????????+========????????IMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMI??????+========????????????+========????????8MMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMD???????========????????????+=======+????????MMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMM???????=======+????????????+=======+????????MMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMM???????========????????????========+???????7MMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMO??????========????????????========+???????8MMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMM??????+=======????????????========+???????MMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMM??????+=======+???????????+=======????????MMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMD$???+=======+???????????+=======?????$DNMMMMMMMMMMMMMMMMMMM\n"
literatura5: .asciz "\nMMMMMMMMMMMMMMMMMMMMMMMMMMM87+=+=+???????????=++=++?7MMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMI$MMMMMMMMMMMMMMMMIMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNINMMMMMMMMMMMMMMMMIOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMI8MMMMMMMMMMMMMMMMI8MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMIIMMMMMMMMMMMMMMMMIMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMD$IIIDMMMMMMMMMMMMMMI$NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMIIIIOMMMMMMMMMMMMMMMMMIIII7ZMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n"









