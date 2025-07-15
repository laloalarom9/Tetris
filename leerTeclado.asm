Lee_Tecla:
    PUSH AF
    PUSH BC
    
T0:
    LD BC,$FDFE
    IN A,(C)
    BIT 0,A
    JR NZ,T1;Si no se cumple se va a la siguiente
    LD A,'A';Lee si hay o no una A pulsada
    JP DespIzq;Entra al desplazamiento
RegresarIZQUIERDA:
    JP NZ, Salir;Regresa y sale
T1:
    BIT 2,A
    JR NZ,T2;Si no se cumple se va a la siguiente
    LD A,'D';Lee si hay o no una D pulsada
    JP DespDerecha;Entra al desplazamiento
RegresarDESPDERECHA:
    JR NZ, Salir   ;Regresa y sale
T2:
    LD BC,$FBFE
    IN A,(C)
    BIT 0,A
    JR NZ,T3;Si no se cumple se va a la siguiente
    LD A,'Q';Lee si Q se pulsó para girar a la derecha
    JP GiroDerecha;Entra al giro
RegresoGiroDerecha:
    JP NZ, Salir;Regresa y sale
T3:
    BIT 2,A
    JR NZ,T4;Si no se cumple se va a la siguiente
    LD A,'E';Lee si hay una E pulsada
    JP GiroIzquierda;Entra al giro
RegresoGiroIzquierda:
    JP NZ, Salir;Regresa y sale
T4:
    LD BC,$7FFE
    IN A,(C)
    BIT 0,A
    JR NZ,Salir;Si no se cumple sale 
    LD A,' '
    JP BajarRapido;Rutina para bajar Rápido
    
Salir:
    POP BC
    POP AF;Se restauran los valores y sale
    RET
DespDerecha:
    POP BC
    LD E,A;Se guarda el valor aquí
    POP AF
    CALL ColisionDERECHA;Rutina para moverse a la derecha o no segun la colisión
    PUSH AF
    LD A,E;Se restaura el valor de A
    INC D;Se incrementa la columna
    PUSH BC
    JP RegresarDESPDERECHA;Regresa para salir
DespIzq:
    POP BC
    LD E,A;Se guarda el valor aquí
    POP AF
    CALL COLISIONIZQUIERDA;Rutina para moverse a la izquierda o no segun la colisión
    PUSH AF
    LD A,E;Se restaura el valor de A
    DEC D;Se decrementa la columna
    PUSH BC
    JP RegresarIZQUIERDA;Regresa para salir
GiroDerecha:
    PUSH AF
    PUSH DE
    LD A,(IX+5);Se carga la figura de la derecha en E
    LD E,A
    LD A, (IX+6);Se carga el resto de la figura a la izquierda en D
    LD D,A
    LD IX,DE;Se carga en IX
    POP DE
    POP AF
    LD E,A;Se guarda A en E
    POP BC
    POP AF
    CALL ColisionGiroDERECHA;Se verifica la colisión con el giro
    PUSH AF 
    PUSH BC;Se restauran los registros utilizados
    LD A,E;A vuelve a su valor original
    JP RegresoGiroDerecha;Regresa para salir
GiroIzquierda:
    PUSH AF
    PUSH DE
    LD A,(IX+3);Se carga la figura de la izquierda en E
    LD E,A
    LD A, (IX+4);Se carga el resto de la figura a la izquierda en D
    LD D,a
    LD IX,DE;Se carga en IX
    POP DE
    POP AF
    LD E,A;Se guarda A en E
    POP BC
    POP AF
    CALL ColisionGiroIZQUIERDA;Se verifica la colision con el giro
    PUSH AF 
    PUSH BC;Se restauran los registros utilizados
    LD A,E;A vuelve a su valor original
    JP RegresoGiroIzquierda;Regresa para salir
BajarRapido:
    POP BC
    POP AF
    CALL ColisionRAPIDA;Verifica si hay colision y se anula el inc A si hay colision
    INC A
    LD C,D
    LD B,A 
    JP SalirRapido;Sale
SalirRapido:
    RET;Otro salir