ColisionGiroIZQUIERDA:
    PUSH AF
    PUSH DE
    PUSH BC;Se guardan los registros
    PUSH IX
    PUSH HL
    LD A,(IX);Se carga la dirección de la figura de ix a A
    LD A,(IX+2);ix+2 =Tamaño
    LD (tamanoxCOLGIRIZQ),A;Ya tiene valor el tamaño de X 
    LD A,C;Se carga la columna
    LD (posXCOLGIRIZQ),A 
    LD D,(IX+1);Movemos ix a la posición 1 y se guarda en memoria
BUCLEYCOLGIRIZQ:
    LD A,(tamanoxCOLGIRIZQ);El tamaño de x
    LD E,A
    LD A,(posXCOLGIRIZQ);La columna en la que se encuentra
    LD C,A 
BUCLEXCOLGIRIZQ:
    LD A,(IX+7);Aqui empiezan los 1 en la etiqueta
    CP 0;Compara si es 1 el contenido
    JR Z,NOCOLISIONCOLGIRIZQ;Si es 0 no puede colisionar
    CALL COLISIONCOLGIRIZQ;Va si puede colisionar
    CP 15
    JR Z,SalidaCOLGIRIZQ;Salida si hay colision
NOCOLISIONCOLGIRIZQ:
    INC C;Igual se incrementa la columna
    INC IX;Hace que se mueva de columna
    DEC E;Decrementa porque es el tamaño x
    JR NZ,BUCLEXCOLGIRIZQ;Verifica que la instruccion no sea 0
    INC B;Se incrementa la fila 
    DEC D ;Decrementa el valor en Y
    JR NZ,BUCLEYCOLGIRIZQ;Bucle de Y hasta que sea cero
    POP HL
    POP IX;Se restauran los registros
    POP BC
    POP DE
    POP AF
    RET;Sale
COLISIONCOLGIRIZQ: ;Y=B X=C
    PUSH AF
    PUSH DE
    PUSH HL;Apunta a la siguiente fila
    PUSH BC
    INC B;Se incrementa 1 para ver la fila de abajo
    LD L,B 
    LD H,0
    ADD HL,HL  
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL  
    ADD HL,HL    ;Se multiplica por 32 la posición
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
    JR NZ, FINALCOLISIONCOLGIRIZQ;Si no es 0, hay colisión
    POP BC
    POP HL;Se restauran los registros
    POP DE
    POP AF
    RET;Para volver a la anterior función
FINALCOLISIONCOLGIRIZQ:
    POP BC
    POP HL
    POP DE;Se restauran los registros
    POP AF
    LD A,15;Para entrar a la salida de colisión
    RET
SalidaCOLGIRIZQ:
    POP HL
    POP IX
    POP BC;Se restauran los registros
    POP DE
    POP AF
    PUSH AF
    PUSH DE;Se guarda DE y AF ya que se van a usar para anular el giro ya que habría colisión al girar
    LD A,(IX+5);IX+5 y IX+6 representan el giro a la derecha, lo contrario
    LD E,A
    LD A, (IX+6)
    LD D,a
    LD IX,DE;Se cargan en IX
    POP DE
    POP AF 
    RET;Sale
posXCOLGIRIZQ: DB 0
tamanoxCOLGIRIZQ: DB 0