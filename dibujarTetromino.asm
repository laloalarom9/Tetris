DibujarTetromino:
    PUSH AF
    PUSH DE;Se guardan los registros
    PUSH HL
    PUSH BC
    PUSH IX
    LD A,(IX);Se carga la dirección de la figura de ix a A
    LD (color),A ;Se carga color, le das un valor a la etiqueta color
    LD A,(IX+2);ix+2 =Tamaño
    LD (tamanox),A;Ya tiene valor el tamaño de X 
    LD A,C;Se carga la columa
    LD (posX),A 
    LD D,(IX+1);Movemos ix a la posición 1 y se guarda en memoria
BUCLEY:
    LD A,(tamanox);El tamaño de x
    LD E,A
    LD A,(posX);posición actual de esta rutina
    LD C,A 
BUCLEX:
    LD A,(IX+7);Aquí aparecen los 1 de la etiqueta
    CP 0;Si no es 0 se pinta y sino solo se recorre
    LD A,(color)
    JR Z,NOPINTAR
    CALL PINTAR

NOPINTAR:
    INC C 
    INC IX;Hace que se mueva de columna
    DEC E;Decrementa porque es el tamaño x
    JR NZ,BUCLEX
    INC B ;incrementa la fila
    DEC D ;Decrementa el valor en Y
    JR NZ,BUCLEY;Bucle de Y hasta que sea cero  
    POP IX
    POP BC
    POP HL
    POP DE;Sale
    POP AF
    RET

PINTAR: ;Y=B X=C
    PUSH AF
    PUSH DE
    PUSH HL
    LD L,B 
    LD H,0
    ADD HL,HL  
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL  ;Se multiplica por 32 la posición
    ADD HL,HL   
    ADD HL,HL   
    LD E,C 
    LD D,0
    ADD HL,DE
    LD DE,$5800;Aquí aparece la pantalla
    ADD HL,DE  ;Se carga la dirección final
    ADD A
    ADD A;Obtiene el bit 8 para el color
    ADD A
    LD (HL),A;Se termina de pintar
    POP HL
    POP DE
    POP AF
    
    

    RET;Para volver a la anterior función
color: DB 0
posX: DB 0
tamanox: DB 0
