    DEVICE ZXSPECTRUM48     
    ORG $8000
    LD SP, 0
    LD A,0
    out ($fe),A;Cambiar color del borde de la pantalla
    LD HL,tetris;Se carga la dirección de Memoria de la etiqueta Tetris
    call CargarPantalla;Para imprimir el fondo del juego
    LD A,2+$80      ; Letra roja(2), fondo negro(8), parpadeante(0)
    LD B,0          ; Coordenadas del título
    LD C,6          
    LD IX,Titulo    ; Dirección del título
    CALL PRINTAT    ; Imprimimos el título por pantalla
    LD A,1          ; Letra azul(1)
    LD B,23         ; Coordenadas del mensaje
    LD C,1       
    LD IX,Mensaje   ; Dirección del mensaje
    CALL PRINTAT    ; Imprimimos el mensaje por pantalla con la rutina printat
    LD B,23         ; Buscamos la dirección del atributo de coordenadas 23,30
    LD C,30         ; Para poner el cursor
    CALL Coor_Atrib ; Devuelve en HL la dirección del atributo
    LD A,1+$80      ; Azul(1) fondo negro(8), parpadeante(0)
    LD (HL),A       ; Ponemos el atributo
    CALL Teclado    ; Leemos el teclado hasta que pulsen S o N
    LD A,1          ; Eco de la tecla pulsada
    LD B,23
    LD C,30
    LD IX,Caracter
    CALL PRINTAT
    LD A,(Caracter)
    CP 'S'
    JR Z, Jugar;Si pone S se va jugar
    jp Final;Si no pone S se va a FInal
Jugar:
    CALL CLEARSCR;Se limpia la pantalla
    LD A,0
    out ($fe),A;Se pone en negro el borde
    LD B,32
    LD C,64
    CALL BucleRecuadro;Rutina para poner el recuadro 
    CALL inicio3D;Rutina para poner el color de las piezas estilo 3D    
    LD B,0; Se incializa en 0 para controlar bucles
    LD A,0; Se incializa en 0 para controlar bucles
SeleccionarTetromino: 
    PUSH AF;Se guarda el valor de A
    LD A,R ;Valor Aleatorio
    AND 7;Restringe el rango de valores que pueden salir 
NdeTetromino:  ;Segun el número que salga del 0 al 6, tendrá una pieza equivalente a ese número   
    CP 0
    JR Z,Pieza1
    CP 1
    JR Z,Pieza2
    CP 2
    JR Z,Pieza3
    CP 3
    JR Z,Pieza4
    CP 4
    JR Z,Pieza5
    CP 5
    JR Z,Pieza6
    CP 6
    JR Z,Pieza7
Pieza1:
    LD IY,OB0;Se guarda la pieza seleccionada en IY
    JP PiezaObtenida
Pieza2:
    LD IY, IB0;Se guarda la pieza seleccionada en IY
    JP PiezaObtenida
Pieza3:
    LD IY,ZB0;Se guarda la pieza seleccionada en IY
    JP PiezaObtenida
Pieza4:
    LD IY,SB0;Se guarda la pieza seleccionada en IY
    JP PiezaObtenida
Pieza5:
    LD IY,LB0;Se guarda la pieza seleccionada en IY
    JP PiezaObtenida
Pieza6:
    LD IY,JB0;Se guarda la pieza seleccionada en IY
    JP PiezaObtenida
Pieza7:
    LD IY,TB0;Se guarda la pieza seleccionada en IY
    JP PiezaObtenida
PiezaObtenida:
    POP AF;Se recupera en anterior valor de A que va a controlar el bucle
    LD IX,IY;Se guarda el valor en ix para posteriormente imprimirlo
    INC B;Se incrementa B para que ya nunca vuelva a valer 1 cuando vuelva a entrar en el bucle
    PUSH AF;Se guarda A
    LD A,B;La segunda vez ya no entra aquí
    CP 1;Se hacen 2 Aleatorios y se guarda el valor en el stack
    JR Z, SeleccionarTetromino2;Si es la primera vez va ahí y hace un segundo seleccionar tetromino
    POP AF;Se recupera A
    JP ImprimirPieza;Seleccionar Tetromino 2 se imprime directamente despues de hacer el recorrido del bucle y se imprime a la derecha como pieza siguiente
SeleccionarTetromino2: 
    POP AF;Se recupera A
    PUSH IX ; GUARDAMOS la figura en memoria en la pila
    JP SeleccionarTetromino;se recorre el segundo bucle para la pieza a la derecha
ImprimirPieza:
    LD B,9         ; Coordenadas del tetromino en el lateral
    LD C,26
    CALL DibujarTetromino;Se dibuja
    LD (Figura), IX;Se guarda la figura en la etiqueta
    CP 0;A al principio vale 0 y al entrar aqui ya no vuelve a valer 0
    JR Z,IgualarPieza ;si es 0
    JP IgualarPieza2;Si no es 0
IgualarPieza:;Si es la primera vez, se saca el valor de ix de la pila
    POP IX
    INC A;Para que ya no vuelva 0
    JP InicializarBucleBajar;Una vez que hace esto se va a inicializar el bucle bajar si es el primer par de piezas impresas
IgualarPieza2:;Si no es la primera vez
    PUSH AF;Se guarda A
    LD A,E
    CP 0;si E no es 0 quiere decir que ya se imprimieron 2 pares de piezas, E se incrementa en la etiqueta SiguientePieza
    JR NZ,SiguientePieza3;Si E es distinto de 0, quiere decir que ya va por el tercer par de piezas impresas y después de esas se repite el proceso para el resto de piezas
    POP AF;Se recupera el valor de A
    LD IY,(Figura);Se guarda el valor de la etiqueta Figura en IY
    LD IX,IY;Se carga IY en IX para poder imprimirlo y usarlo
    JP InicializarBucleBajar;Se va a incializar para que empiece a bajar
SiguientePieza3:
    POP AF;Si es el tercer par de piezas o más 
    LD IY,(FiguraSig);Se le da un valor a esta etiqueta en Siguiente Pieza
    LD IX,IY;Se carga IY en IX
InicializarBucleBajar:
    LD A,1 ;Siempre empieza en la fila 1 y columna 14, la fila se carga en A y en el bucle de abajo se incrementa al igual que la columna
    LD D,14
BucleBajar: 
    LD C,D  ;
    LD B,A          ;Coordenadas del tetromino, C incrementa o decrementa (los lados) y B incrementa
Parte2Jugar:
    JP Kolision;Aqui se verifica si hay colisión o no, si no hay se va a RegresarColision y si no se va a SiguientePieza
RegresarColision:
    CALL Lee_Tecla;Rutina que lee las teclas para desplazarse derecha,izquierda(A,D), bajar rápido(tecla de espacio),giro derecha(Q) y giro izquierda(E)
    CALL DibujarTetromino;Se dibuja
    CALL PausaCodigo;Rutina para que descienda más lento el trtromino 
    CALL DibujarVacio;Se borra en las mismas coordenadas el tetromino
    INC A;Se incrementa la fila
    JP BucleBajar;Vuelve a iniciar el bucle
SiguientePieza:    ;Aquí se borra la pieza de la derecha
    CALL DibujarTetromino;Se dibuja con o sin decremento en sus columnas y filas segun el momento donde se detecte colisión
    CALL VerificarLinea;Aquí se verifica si hay una línea hecha y se borra, posteriormente baja lo que esta arriba de la línea
    JP VerificarFin;Aquí se verifica si el juego ya acabo o no
RegresoVErificacion:;Es parte de SiguientePieza pero aqui regresa de la verificación del fin.
    LD IY,(Figura);Se guarda la figura de la derecha en IY
    LD (FiguraSig),IY;Esta etiqueta se usará en la etiqueta IgualarPieza3
    LD IX,IY;Se pone la figura anterior
    LD B,9 ; Coordenadas del tetromino en el lateral
    LD C,26 
    CALL DibujarVacio;Se borra para que luego se pinte el siguiente tetromino
    INC E;Se incrementa E para el bucle del siguiente tetromino
    JP SeleccionarTetromino;Bucle Siguiente Tetromino 
VerificarFin:
    PUSH AF;
    PUSH BC
    PUSH DE
    PUSH HL;El hl se va a usar para ver el color en las siguientes coordenadas 
    LD A,1   
    LD D,14
    LD C,D
    LD B,A
    LD L,B 
    LD H,0
    ADD HL,HL  ;Para multiplicarlo por 32
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL  
    ADD HL,HL   
    ADD HL,HL   
    LD E,C ;Se le suma la columna
    LD D,0
    ADD HL,DE
    LD DE,$5800;En 5800 empieza la pantalla
    ADD HL,DE 
    ADD A; se llega al bit 8
    ADD A
    ADD A
    LD A,(HL);Se carga la direccion en A para ver el color
    CP 0;La siguiente es 0, puede seguir y no entra al final
    POP HL
    POP DE
    POP BC
    JR Z, BucleBajarr ;Regresa al juego
    POP AF
    JP Final;Se va al final del juego
BucleBajarr:
    POP AF;hace el pop que faltaba 
    JP RegresoVErificacion;Regresa al juego
Final:
    CALL PausaCodigo;Rutina para bajar más lento el tetris
    CALL CLEARSCR;Se borra la pantalla
    LD A,4; Letra verde, fondo negro
    LD B,3; Coordenadas para pintar el mensaje
    LD C,4
    LD IX, MensajeFin
    CALL PRINTAT
    LD A,4          ; Letra Verde, Fondo negro
    LD B,10         ;Coordenadas para pintar el mensaje
    LD C,1
    LD IX, Mensaje;Mensaje de final "En proceso de cerrarse"
    CALL PRINTAT; Se pinta el mensaje 
    LD B,10        ; Buscamos la dirección del atributo de coordenadas 10,30
    LD C,30         ; Para poner el cursor
    CALL Coor_Atrib ; Devuelve en HL la dirección del atributo
    LD A,4+$80      ; Azul(1) fondo negro(8), parpadeante(0)
    LD (HL),A       ; Ponemos el atributo
    CALL Teclado    ; Leemos el teclado hasta que pulsen S o N
    LD A,4
    LD B,10
    LD C,30
    LD IX,Caracter
    CALL PRINTAT   ; Mostramos un carácter
    LD A,(Caracter) ; Cargamos lo que contenga Caracter al registro A para comparalo con las letras S y N
    CP 'S'
    JR Z, Jugarr ;Si quiere volver a jugar
    CP 'N'
    JR Z, PreFin;Si quiere salir definitivamente

Jugarr:
    JP Jugar;Regresa a Jugar
PreFin:
    CALL CLEARSCR;Se borra la pantalla y entra a fin
fin:    
    JP fin;Bucle infinito de fin
Coor_Atrib:
    ; Rutina que recibe en B,C las coordenadas de la pantalla (fila, columna)
    ; y devuelve en HL la dirección del atributo correspondiente
    PUSH AF             ; Guardamos A en el stack
    LD H,b              ; Los bits 4,5 de B deben ser los bits 0,1 de H
    SRL H : SRL H : SRL H
    LD A,B              ; Los bits 0,1,2 de B deben ser los bits 5,6,7 de L
    SLA A : SLA A : SLA A : SLA A : SLA a
    OR c                ; Y C son los bits 0-4 de L
    LD L,A
    LD BC, $5800        ; Le sumamos la dirección de comienzo de los atributos
    ADD HL,BC
    POP AF
    RET
Teclado:                ; Rutina para leer del teclado 'S' o 'N'
    LD BC,$7FFE         ; Escanear línea B,N,M,SYMB,Space
    IN A,(C)
    BIT 3,A
    JR Z,T_N            ; Han pulsado N
    LD BC,$FDFE         ; Escanear línea G,F,D,S,A
    IN A,(C)
    BIT 1,A
    JR NZ,Teclado       ; No han pulsado 'S
T_S:    
    LD A,'S'            ; Guardo 'S' en la Variable Caracter
    LD (Caracter),A
    JR Soltar_Tecla     ; Esperar q que suelten la tecla
T_N:
    LD A,'N'            ; Guardo 'N' en la variable Caracter 
    LD (Caracter),A 
    LD D,1
Soltar_Tecla:           ; Rutina de espera hasta que se suelta la tecla
    IN A,(C)            ; Leer del puerto que se ha definido en Lee_Tecla
    CP $FF              ; Comprobar que no hay tecla pulsada
    JR NZ,Soltar_Tecla  ; esperar hasta que no haya tecla pulsada
    RET

Titulo:    db "Bienvenido al Tetris",0    ; Título del juego
Mensaje:   db "Empezamos una partida (S/N)? ",0   ; Pregunta inicial
Caracter:   db "P",0              ; Mensaje del carácter para imprimir
TeclaLeida: db 0,0              ;Tecla leida en el juego para rotar la figura
MensajeFin: db "En proceso de cerrarse",0 ; Mensaje previo al cierre de juego
Figura: DW 0;Para controlar pieza Siguiente
Tetro:  DW 0 ;Para imprimir tetromino
FiguraSig:DW 0;Para controlar pieza Siguiente

    INCLUDE printat.asm         ; Incluimos PRINTAT para imprimir por pantalla
    INCLUDE pintarRecuadro.asm
    INCLUDE tetromino.asm
    INCLUDE dibujarTetromino.asm
    INCLUDE Tetris_3D.asm
    INCLUDE leerTeclado.asm
    INCLUDE dibujarVacio.asm
    INCLUDE pausaCodigo.asm
    INCLUDE Colision.asm
    INCLUDE colisionDer.asm
    INCLUDE ColisionIzq.asm
    INCLUDE VerificarLinea.asm
    INCLUDE ColisionRapida.asm
    INCLUDE ColisionGiroDer.asm
    INCLUDE ColisionGirIZq.asm

CargarPantalla:
	push bc						; Guarda registros utilizados
	push de
	ld de, $4000				; Pantalla a zona de memoria de video
	ld bc, 6912					; Tamaño de la VideoRam
bucle:
	ldi							; (de)=(HL) , de++, hl++, bc--
	ld a,b						; Comprobamos si BC es 0
	or c						; BC=0 <=> B|C=0
	jp nz, bucle				; Siguiente byte de la pantalla
	pop de						; Recupera registros usados
	pop bc
	ret							; Retornamos al programa principal
tetris:   INCBIN "tetriis.SCR"	; Se copia en este punto el contenido de este fichero


