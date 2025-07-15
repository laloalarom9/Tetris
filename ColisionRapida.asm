ColisionRAPIDA:
    PUSH AF
    PUSH DE
    PUSH BC;Se guardan los registros
    PUSH IX
    PUSH HL
    LD A,(IX);Se carga la dirección de la figura de ix a A
    LD A,(IX+2);ix+2 =Tamaño
    LD (tamanoCOLRA),A;Ya tiene valor el tamaño de X 
    LD A,C;Se carga la columna
    LD (posXCOLRA),A 
    LD D,(IX+1);Movemos ix a la posición 1 y se guarda en memoria
BUCLEYCOLRA:
    LD A,(tamanoCOLRA);El tamaño de x
    LD E,A
    LD A,(posXCOLRA);La columna en la que se encuentra
    LD C,A 
BUCLEXCOLRA:
    LD A,(IX+7);Aqui empiezan los 1 en la etiqueta
    CP 0;Compara si es 1 el contenido
    JR Z,NOCOLISIONCOLRA;si es 0 no puede colisionar
    CALL COLISIONCOLRA;entra si puede colisionar
    CP 15
    JR Z,SalidaCOLRA;Salida si hay colisión
NOCOLISIONCOLRA:
    INC C;Igual se incrementa la columna
    INC IX;Hace que se mueva de columna
    DEC E;Decrementa porque es el tamaño x
    JR NZ,BUCLEXCOLRA;Verifica que la instruccion no sea 0
    INC B;Se incrementa la fila 
    DEC D ;Decrementa el valor en Y
    JR NZ,BUCLEYCOLRA;Bucle de Y hasta que sea cero
    POP HL
    POP IX;Se restauran los registros
    POP BC;Sale
    POP DE
    POP AF
    RET
COLISIONCOLRA: ;Y=B X=C
    PUSH AF
    PUSH DE
    PUSH HL;Apunta a la siguiente fila
    PUSH BC
    INC B
    INC B;Se incrementa 2 veces ya que para ir más rápido se le suma uno, más el otro que hace al bajar
    LD L,B 
    LD H,0
    ADD HL,HL  
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL   ;Se multiplica por 32 la posicion
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
    JR NZ, FINALCOLISIONCOLRA;Si no es 0, hay colisión
    POP BC
    POP HL
    POP DE;Se restauran los registros
    POP AF
    RET;Para volver a la anterior función
FINALCOLISIONCOLRA:
    POP BC
    POP HL
    POP DE;Se restauran los registros
    POP AF
    LD A,15;Para entrar a la salida de colisión
    RET
SalidaCOLRA:
    POP HL
    POP IX
    POP BC;Se restauran los registros
    POP DE
    POP AF
    DEC A;Si hay colisión entonces se anula el inc A que hay en Bajar Rapido con este Dec A
    RET;Sale
posXCOLRA: DB 0
tamanoCOLRA: DB 0