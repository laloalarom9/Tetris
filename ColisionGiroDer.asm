ColisionGiroDERECHA:
    PUSH AF
    PUSH DE
    PUSH BC;Se guardan los registros
    PUSH IX
    PUSH HL
    LD A,(IX);Se carga la dirección de la figura de ix a A
    LD A,(IX+2);ix+2 =Tamaño
    LD (tamanoxCOLGIRDER),A;Ya tiene valor el tamaño de X 
    LD A,C;Se carga la columna
    LD (posXCOLGIRDER),A 
    LD D,(IX+1);Movemos ix a la posición 1 y se guarda en memoria
BUCLEYCOLGIRDER:
    LD A,(tamanoxCOLGIRDER);El tamaño de x
    LD E,A
    LD A,(posXCOLGIRDER);La columna en la que se encuentra
    LD C,A 
BUCLEXCOLGIRDER:
    LD A,(IX+7);Aqui empiezan los 1 en la etiqueta
    CP 0;Compara si es 1 el contenido
    JR Z,NOCOLISIONCOLGIRDER;Si es 0 no puede colisionar
    CALL COLISIONCOLGIRDER;Va si puede colisionar
    CP 15
    JR Z,SalidaCOLGIRDER;Salida si hay colisión
NOCOLISIONCOLGIRDER:
    INC C;Igual se incrementa la columna
    INC IX;Hace que se mueva de columna
    DEC E;Decrementa porque es el tamaño x
    JR NZ,BUCLEXCOLGIRDER;Verifica que la instruccion no sea 0
    INC B;Se incrementa la fila 
    DEC D  ;Decrementa el valor en Y
    JR NZ,BUCLEYCOLGIRDER;Bucle de Y hasta que sea cero
    POP HL
    POP IX
    POP BC;Se restauran los registros
    POP DE
    POP AF
    RET;Sale
COLISIONCOLGIRDER: ;Y=B X=C
    PUSH AF
    PUSH DE
    PUSH HL;Apunta a la siguiente fila
    PUSH BC
    INC B;Se incrementa 1 para ver la fila de abajo
    LD L,B 
    LD H,0
    ADD HL,HL  
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL  ;Se multiplica por 32 la posición
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
    JR NZ, FINALCOLISIONCOLGIRDER;Si no es 0, hay colisión
    POP BC
    POP HL
    POP DE;Se restauran los registros
    POP AF
    RET;Para volver a la anterior función
FINALCOLISIONCOLGIRDER:
    POP BC
    POP HL;Se restauran los registros
    POP DE
    POP AF
    LD A,15;Para entrar a la salida de colisión
    RET
SalidaCOLGIRDER:
    POP HL
    POP IX
    POP BC
    POP DE;Se restauran los registros
    POP AF
    PUSH AF
    PUSH DE;Se guarda DE y AF ya que se van a usar para anular el giro ya que habría colisión al girar
    LD A,(IX+3);IX+3 y IX+4 representan el giro a la izquierda, lo contrario
    LD E,A
    LD A, (IX+4)
    LD D,a
    LD IX,DE;Se cargan en IX
    POP DE
    POP AF 
    RET;Sale
posXCOLGIRDER: DB 0
tamanoxCOLGIRDER: DB 0