Kolision:
    PUSH AF
    PUSH DE;Se guardan los registros
    PUSH BC
    PUSH IX
    PUSH HL
    LD (Tetro),IX
    LD A,(IX);Se carga la dirección de la figura de ix a A
    LD A,(IX+2);ix+2 =Tamaño
    LD (tamanox2),A;Ya tiene valor el tamaño de X 
    LD A,C;Se carga la columna
    LD (posX2),A 
    LD D,(IX+1);Movemos ix a la posición 1 y se guarda en memoria
BUCLEY2:
    LD A,(tamanox2);El tamaño de x
    LD E,A
    LD A,(posX2);La columna en la que se encuentra
    LD C,A 
BUCLEX2:
    LD A,(IX+7);Aquí empiezan los 1 en la etiqueta
    CP 0;Compara si es 1 el contenido
    JR Z,NOCOLISION;Si es 0 no puede colisionar
    CALL COLISION;Va si puede colisionar
    CP 15
    JR Z,SiguientePiezaa
NOCOLISION:
    INC C;Igual se incrementa la columna
    INC IX;Hace que se mueva de columna
    DEC E;Decrementa porque es el tamaño x
    JR NZ,BUCLEX2;Verifica que la instrucción no sea 0
    INC B;Se incrementa la fila 
    DEC D ;Decrementa el valor en Y
    JR NZ,BUCLEY2;Bucle de Y hasta que sea cero
    POP HL
    POP IX;Se restauran los registros
    POP BC
    POP DE
    POP AF
    JP RegresarColision;Regresa para ver a que final se va, sin o con colisión
COLISION: ;Y=B X=C
    PUSH AF
    PUSH DE
    PUSH HL;Apunta a la siguiente fila
    PUSH BC
    INC B;Se incrementa 1 para ver la fila de abajo
    LD L,B 
    LD H,0
    ADD HL,HL  
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL   ;Se multiplica por 32 la posición
    ADD HL,HL   
    ADD HL,HL   
    LD E,C ;Se le suma la columna
    LD D,0
    ADD HL,DE
    LD DE,$5800;Aquí aparece la pantalla
    ADD HL,DE  
    ADD A;Obtiene el bit 8 para el color
    ADD A
    ADD A
    LD A,(HL)
    CP 0;La siguiente es 0, puede seguir y no entra al final
    JR NZ, FINALCOLISION;Si no es 0, hay colisión
    POP BC
    POP HL
    POP DE;Se restauran los registros
    POP AF
    RET;Para volver a la anterior función
FINALCOLISION:
    POP BC
    POP HL;Se restauran los registros
    POP DE
    POP AF
    LD A,15;Para entrar a la salida de colisión
    RET
SiguientePiezaa:
    POP HL
    POP IX
    POP BC;Se restauran los registros
    POP DE
    POP AF
    JP SiguientePieza;Se va a siguiente pieza ya que existe una colisión y no puede seguir bajando

posX2: DB 0
tamanox2: DB 0
