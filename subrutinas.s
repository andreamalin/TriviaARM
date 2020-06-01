/*Subrutinas que llevan a cabo las operaciones de la trivia ARM*/

.text
.align 2


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

	mov r1, r4
	ldr r0, = jugador_actual    /* cargar dirección de la cadena a imprimir*/ 
	bl printf                   /* se muestra */

	cmp r6, #0						/*Se compara el turno actual con 0 (j1)*/
	beq turnoJ1

turnoJ1:
	mov r0,sp					/*Se apunta al stack*/
	bl mysrand					/*Se jala la semilla a r0*/

	bl myrand					/*R0 contendra el numero aleatorio generado*/
	push {r0}					/*R0 se mete al stack*/

	mov r1,r0					/*Se guarda r0 en r1*/
	and r1,r1,#6				/*R1 llevara el limite superior de numero a generar -> Cantidad de categorias*/

	
	pop {r0}					/*Se saca r0 del stack*/
	mov r8, r1					/*Se jala a r8 el numero aleatorio*/

	mov r9, #4
	mul r9, r8 					/*Se multiplica por 4 para tener la cantidad de bits*/

	ldr r1, =categorias			/*Se apunta al arreglo*/
	add r1, r1, r9
	ldr r1, [r1]			/*Se carga*/
	ldr r0,=categoria_actual	/*Formato de impresion*/
	bl printf					/*Se imprime*/



	pop {r4-r12, pc}			/*Regresando sin error*/




/* Subrutina para generar categoria/pregunta aleatoria tomada de: 
Villena, A. & Asenjo, R. & Corbera, F. Practicas basadas en Raspberry Pi */
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
	


.data
.align 2
nom_jugador:	.asciz "            "
ingreso_nom:	.asciz "\nHola jugador 1! Ingresa tu nombre:"
ingreso_nom2:	.asciz "\nHola jugador 2! Ingresa tu nombre:"
jugador_actual:	.asciz  "\nEs turno de: %s"
categoria_actual:	.asciz  "\nCategoria actual: %s\n"
formato:		.asciz  "\n%s"
seed: 	.word 	1
/*Const1 y const2 seran valores constantes para generar aleatorios*/
const1:	.word	1103515245
const2:	.word	12345
num: .asciz "%d\n"
categorias:		.asciz "Entretenimiento  y Deportes", "Literatura", "Ciencia y Tecnologia", "Geografia", "Arte", "Historia"








/*PREGUNTAS PARA LA TRIVIA*/
preguntas_ciencia:		.asciz "¿Como se llama el componente minimo que forma a los seres vivos?", "Unidad basica de la materia", "La  columna más a la derecha de la tabla periódica esta compuesta por", " ¿Que elemento tiene el simbolo Cu?", " Ciencia que estudia los seres vivos", "La velocidad a la que viaja la luz es"
respuestas_ciencia:		.asciz  "Celula", "Atomo", "Gases nobles", "Cobre", "Biologia", "300,000 km/s"
aleatorios1_ciencia:	.asciz "Tejido, Celula, Particula"
aleatorios2_ciencia:	.asciz "Atomo, Celula, Mitocondria"
aleatorios3_ciencia:	.asciz "Haluros, Gases nobles, Minerales"
aleatorios4_ciencia:	.asciz "Cobre, Carbon, Calcio"
aleatorios5_ciencia:	.asciz "Biologia, Organismologia, Viviologia"
aleatorios6_ciencia:	.asciz "300,000 m/s", "300,000 km/s", "30,000 km/h"

preguntas_literatura:	.asciz "¿Quien escribio 'La Iliada'?", "¿Quien es el autor de la 'Divina comedia'?"
respuestas_literatura:	.asciz "Homero"
aleatorios1_literatura:	.asciz "Homero, Herodoto, Seneca"


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
