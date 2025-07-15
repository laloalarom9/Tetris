ColisionDERECHA:
    PUSH AF
    PUSH DE;Se guardan los registros
    PUSH BC
    PUSH IX
    PUSH HL
    LD A,(IX);Se carga la dirección de la figura de ix a A
    LD A,(IX+2);ix+2 =Tamaño
    LD (tamanoxCOLDER),A;Ya tiene valor el tamaño de X 
    LD A,C;Se carga la columna
    LD (posXCOLDER),A 
    LD D,(IX+1);Movemos ix a la posición 1 y se guarda en memoria
BUCLEYCOLDER:
    LD A,(tamanoxCOLDER);El tamaño de x
    LD E,A
    LD A,(posXCOLDER);La columna en la que se encuentra
    LD C,A 
BUCLEXCOLDER:
    LD A,(IX+7);Aquí empiezan los 1 en la etiqueta
    CP 0;Compara si es 1 el contenido
    JR Z,NOCOLISIONCOLDER;Si es 0 no puede colisionar
    CALL COLISIONCOLDER;Va si puede colisionar
    CP 15
    JR Z,SalidaCOLDER;Salida si hay colision
NOCOLISIONCOLDER:
    INC C;Igual se incrementa la columna
    INC IX;Hace que se mueva de columna
    DEC E;Decrementa porque es el tamaño x
    JR NZ,BUCLEXCOLDER;Verifica que la instruccion no sea 0
    INC B;Se incrementa la fila 
    DEC D ;Decrementa el valor en Y
    JR NZ,BUCLEYCOLDER;Bucle de Y hasta que sea cero
    POP HL
    POP IX
    POP BC;Se restauran los registros
    POP DE
    POP AF
    RET;Sale
COLISIONCOLDER: ;Y=B X=C
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
    INC C;Se incrementa para ver lo que hay a la derecha
    LD E,C ;Se le suma la columna
    LD D,0
    ADD HL,DE
    LD DE,$5800;Aquí aparece la pantalla
    ADD HL,DE
    ADD A
    ADD A;Obtiene el bit 8 para el color
    ADD A
    LD A,(HL)
    CP 0;La siguiente es 0, puede seguir y no entra al final
    JR NZ, FINALCOLISIONCOLDER;Si no es 0, hay colisión
    POP BC
    POP HL
    POP DE
    POP AF
    RET;Para volver a la anterior función
FINALCOLISIONCOLDER:
    POP BC
    POP HL;Se restauran los registros
    POP DE
    POP AF
    LD A,15;Para entrar a la salida de colisión
    RET
SalidaCOLDER:
    POP HL
    POP IX
    POP BC
    POP DE;Se restauran los registros
    POP AF
    DEC D;Si hay colisión entonces se anula el INC D que hay en desplazar a la derecha con este DEC D
    RET;Sale
posXCOLDER: DB 0
tamanoxCOLDER: DB 0