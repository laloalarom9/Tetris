DibujarVacio:
    PUSH AF
    PUSH DE
    PUSH HL;Se guardan los registros
    PUSH BC
    PUSH IX
    
    LD A,(IX);Se carga la dirección de la figura de ix a A ;
    LD A,(IX+2);ix+2 =Tamaño
    LD (Borrartamanox),A;Ya tiene valor el tamaño de X 
    LD A,C;Se carga la columa
    LD (BorrarposX),A 
    LD D,(IX+1);Movemos ix a la posición 1 y se guarda en memoria
BORRARBUCLEY:
    LD A,(Borrartamanox);El tamaño de x
    LD E,A
    LD A,(BorrarposX);posición actual de esta rutina
    LD C,A 
BORRARBUCLEX:
    LD A,(IX+7);Aquí aparecen los 1 de la etiqueta
    CP 0;Si no es 0 se borra y sino solo se recorre
    LD A,0
    JR Z,BORRARNOPINTAR
    CALL BORRARPINTAR

BORRARNOPINTAR:
    INC C 
    INC IX;Hace que se mueva de columna

    DEC E;Decrementa porque es el tamaño x
    JR NZ,BORRARBUCLEX
    INC B ;incrementa la fila
    DEC D ;Decrementa el valor en Y
    JR NZ,BORRARBUCLEY;Bucle de Y hasta que sea cero
    POP IX
    POP BC
    POP HL;Sale
    POP DE
    POP AF
    RET

BORRARPINTAR: ;Y=B X=C
    PUSH AF
    PUSH DE
    PUSH HL
    LD L,B 
    LD H,0
    ADD HL,HL  
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL  ;Se multiplica por 32 la posicion
    ADD HL,HL   
    ADD HL,HL   
    LD E,C 
    LD D,0
    ADD HL,DE
    LD DE,$5800;Primera dirección de memoria de la pantalla
    ADD HL,DE  ;Se carga la dirección final
    ADD A
    ADD A;Obtiene el bit 8 para el color
    ADD A
    LD (HL),A;Se termina de pintar con 0
    POP HL
    POP DE
    POP AF
    
    RET;Para volver a la anterior función
BorrarposX: DB 0
Borrartamanox: DB 0
