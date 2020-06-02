

	.global main
	.func main

main:

	ldr r0, =respuestas_ciencia
	add r0, r0, #1
	bl puts
	


	MOV R7, #1
	SWI 0



	.data
ciencia_1:		.asciz "¿Como se llama el componente minimo que forma a los seres vivos?\na. Tejido\nb. Celula\nc. Particula" 
ciencia_2:		.asciz "Unidad basica de la materia\na. Atomo\nb. Celula\nc. Mitocondria"
ciencia_3:		.asciz "La  columna más a la derecha de la tabla periódica esta compuesta por\na. Haluros\nb. Gases nobles\nc. Minerales"
ciencia_4:		.asciz "¿Que elemento tiene el simbolo Cu?\na. Cobre\nb. Carbon\nc. Calcio"
ciencia_5:		.asciz "Ciencia que estudia los seres vivos\na. Viviologia\nb. Organismologia\nc. Biologia"
ciencia_6:		.asciz "La velocidad a la que viaja la luz es\na. 300,000 m/s\nb. 300,000 km/s\nc. 30,000 km/h"
respuestas_ciencia:	.byte  'b', 'a', 'b', 'a', 'c', 'b'

literatura_1:		.asciz "¿Quien escribio 'La Iliada'?\na. Homero\nb. Herodoto\nc. Seneca"     
literatura_2:		.asciz "¿Quien es el autor de la 'Divina comedia'?\na. Petrarca\nb. Virgilio\nc. Dante Alighier"
literatura_3:		.asciz "¿Que autor NO pertenece al boom latinoamericano?\na. Julio Cortazar\nb. Ruben Dario\nc. Gabriel Garcia Marquez"
literatura_4:		.asciz "Obra literaria mas vendida de la historia\na. El Hobbit\nb. El senor de los Anillos\nc. Don Quijote de la Mancha"
literatura_5:		.asciz "Autor que escribe en el genero de terror\na. Stephen King\nb. JK Rowling\nc. William Shakespeare"
literatura_6:		.asciz "¿Cual de los autores SI pertenece al genero del realismo magico y es guatemalteco?\na. Frida Kahlo\nb. Gabriel Garcia Marquez\nc. Miguel Angel Asturias"
respuestas_literatura:	.byte 'a', 'c', 'b', 'c', 'a', 'c'

geografia_1:		.asciz "Continente con la mayor cantidad de paises\na. Africa\nb. Europa\nc. Asia"  
geografia_2:		.asciz "Pais mas grande del mundo\na. China\nb. Rusia\nc. Canada"
geografia_3:		.asciz "¿De qué tiene forma Italia?\na. Camisa\nb. Sombrero\nc. Bota"
geografia_4:		.asciz "Pais con la mayor poblacion del mundo\na. China\nb. India\nc. Brasil"
geografia_5:		.asciz "¿Donde se encuentra el rio mas grande de Africa?\na. Argelia\nb. Egipto\nc. Madagascar"
geografia_6:		.asciz "¿Cual de los siguientes es el lago mas grande del mundo?\na. Mar Rojo\nb. Mar Mediterraneo\nc. Mar Caspio"
respuestas_geografia:	.byte 'a', 'b', 'c', 'a', 'b', 'c'

arte_1:			.asciz "¿A que movimiento pertenecio Pablo Picasso?\na. Cubismo\nb. Surrealismo\nc. Realismo"
arte_2:			.asciz "Artista que se corto su propia oreja\na. Donatello\nb. Leonardo\nc. Vincent Van Gogh"
arte_3:			.asciz "Artista y miembro de las tortugas ninja\na. Claude Monet\nb. Miguel Angel\nc. Leonardo Da Vinci"
arte_4:			.asciz "¿Cual era el 6o nombre de Picasso?\na. Juan\nb. Francisco de Paula\nc. Nepomuceno"
arte_5:			.asciz "¿Quien fue el primer arquitecto encargado de 'La Sagrada Familia'?\na. Francisco del Villar\nb. Antonio Gaudi\nc. Juan Rubio"
arte_6:			.asciz "¿Cual de estos era inventor a parte de ser artista?\na. Dali\nb. Duchamp\nc. Da Vinci"
respuestas_arte:	.byte 'a', 'c', 'b', 'c', 'b', 'c'

historia_1:		.asciz "¿Cuantas veces fue apunalado el emperador Julio Cesar?\na. 23\nb. 21\nc. 24"
historia_2:		.asciz "¿Donde se asento la primera civilizacion?\na. Rio Nilo\nb. Mesopotamia\nc. Amazonas"
historia_3:		.asciz "Lugar donde cruzan los humanos a América\na. Estrecho de Bering\nb. Estrecho de Gibraltar\nc. Estrecho de Malaca"
historia_4:		.asciz "Ciudad destruida por la erupcion del Monte Vesuvio\na. Troya\nb. Atenas\nc. Pompeya"
historia_5:		.asciz "Caracteristica geografica donde se asientan las civilizaciones\na. Rios\nb. Montanas\nc. Playas"
historia_6:		.asciz "¿Quien estaba al mando del mayor imperio en la historia?\na. La corona inglesa\nb. Genghis Khan\nc. Alejandro el Grande"
respuestas_historia:	.byte 'a', 'b', 'a', 'c', 'a', 'a'

deportes_1:		.asciz "¿Que pelicula de la triologia del Senor de los Anillos gano todos los oscares a los cuales fue nominada?\na. La Comunidad del Anillo\nb. Las Dos Torres\nc. El Retorno del Rey"
deportes_2:		.asciz "Artista mas vendido de la historia\na. Elvis Presley\nb. Michael Jackson\nc. Elton John"
deportes_3:		.asciz "¿Cual es el videojuego mas vendido de la historia?\na. Tetris\nb. Minecraft\nc. GTAV"
deportes_4:		.asciz "¿Cual es el deporte mas visto en las olimpiadas?\na. Natacion\nb. Atletismo\nc. Gimnasia"
deportes_5:		.asciz "¿Cual es el pais con mayor cantidad de mundiales de futbol?\na. Brasil\nb. Alemania\nc. Italia"
deportes_6:		.asciz "¿Cuantos kilometros se recorren en el Tour de Francia?\na. 5600\nb. 5500\nc. 5700"
respuestas_deportes:	.byte 'c', 'a', 'b', 'c', 'a', 'b'

