COLISIONIZQUIERDA:
    PUSH AF
    PUSH DE;Se guardan los registros
    PUSH BC
    PUSH IX
    PUSH HL
    LD A,(IX);Se carga la dirección de la figura de ix a A
    LD A,(IX+2);ix+2 =Tamaño
    LD (tamanoxCOLIZQ),A;Ya tiene valor el tamaño de X 
    LD A,C;Se carga la columna
    LD (posXCOLIZQ),A 
    LD D,(IX+1);Movemos ix a la posición 1 y se guarda en memoria
BUCLEYCOLIZQ:
    LD A,(tamanoxCOLIZQ);El tamaño de x
    LD E,A
    LD A,(posXCOLIZQ);La columna en la que se encuentra
    LD C,A 
BUCLEXCOLIZQ:
    LD A,(IX+7);Aqui empiezan los 1 en la etiqueta
    CP 0;Compara si es 1 el contenido
    JR Z,NOCOLISIONCOLIZQ;Si es 0 no puede colisionar
    CALL COLISIONCOLIZQ;Va si puede colisionar
    CP 15
    JR Z,SalidaCOLIZQ;Salida si hay colisión
NOCOLISIONCOLIZQ:
    INC C;Igual se incrementa la columna
    INC IX;Hace que se mueva de columna
    DEC E;Decrementa porque es el tamaño x
    JR NZ,BUCLEXCOLIZQ;Verifica que la instruccion no sea 0
    INC B;Se incrementa la fila 
    DEC D  ;Decrementa el valor en Y
    JR NZ,BUCLEYCOLIZQ;Bucle de Y hasta que sea cero
    POP HL
    POP IX;Se restauran los registros
    POP BC
    POP DE
    POP AF
    RET;Sale
COLISIONCOLIZQ: ;Y=B X=C
    PUSH AF
    PUSH DE
    PUSH HL;Apunta a la siguiente fila
    PUSH BC
    INC B;Se incrementa 1 para ver la fila de abajo
    DEC C;Se decrementa para ver lo que hay a la izquierda
    LD L,B 
    LD H,0
    ADD HL,HL  
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL  ;Se multiplica por 32 la posicion
    ADD HL,HL   
    ADD HL,HL
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
    JR NZ, FINALCOLISIONCOLIZQ;Si no es 0, hay colisión
    
    POP BC
    POP HL
    POP DE;Se restauran los registros
    POP AF
    RET;Para volver a la anterior función
FINALCOLISIONCOLIZQ:
    POP BC
    POP HL;Se restauran los registros
    POP DE
    POP AF
    LD A,15;Para entrar a la salida de colisión
    RET
SalidaCOLIZQ:
    POP HL
    POP IX;Se restauran los registros
    POP BC
    POP DE
    POP AF
    INC D;Si hay colisión entonces se anula el DEC D que hay en desplazar a la izquierda con este INC D
    RET;Sale
posXCOLIZQ: DB 0
tamanoxCOLIZQ: DB 0