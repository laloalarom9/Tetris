VerificarLinea:    PUSH AF;se guardan los registros en la pila
    PUSH BC
    PUSH DE
    LD C,6;Suma hasta 23, se hace hasta que revise que acabo de visualizar la columna de la 7 a 23 de cada fila
    LD B,1;Se verifica de arriba hacia abajo hasta la fila 22
SeguirVerific:
    PUSH AF
    LD A,C
    CP 23;verifica si la columna llega o no a 23, siempre cp se hace con A
    JR Z,SALIDAVER;Si llega hasta 23 de columna  y llega a 22 de fila quiere decir que leyó el borde de abajo, no encontro nada
    POP AF
    INC C;incrementa y lo hace con 7,COLUMNA=C
    LD L,B ;B es la fila
    LD H,0
    ADD HL,HL  ;Se multiplica por 32
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL  
    ADD HL,HL   
    ADD HL,HL   
    LD E,C ;Se le suma la columna
    LD D,0
    ADD HL,DE
    LD DE,$5800;Donde se imprime cosas por pantalla
    ADD HL,DE  
    ADD A;Para llegar al bit 8
    ADD A
    ADD A
    LD A,(HL);Para verificar el color en la posicion
    CP 0;La siguiente es 0, puede seguir y no entra al final
    JR NZ,SeguirVerific;Si no es 0 que siga verificando
    INC B;Aumenta la fila y reinicia los valores de las columnas
    LD C,6
    JP SeguirVerific  ;Regresa al bucle
SALIDAVER:
    POP AF;El pop pendiente
    PUSH AF;Se guarda A por si regresa
    LD A,B;Se verifica si B es 22, la fila
    CP 22;verifica si la fila llego a 22 o no, si leyó el borde o no
    JR Z,Salir22;Si lo leyó se sale
    POP AF
    LD C,7
    PUSH IX
    PUSH IY
    LD IY,LINEA;Se creo una etiqueta con 17 numeros 1 y se hace dibujar vacio
    LD IX,IY;Se carga en IX
    CALL DibujarVacio;Se borra la línea
    JP BAJARCOSAS;Se bajan las los cuadros que estan sobre la línea
RegresoBajarrCosas:
    POP IY
    POP IX
    LD C,6
    JP SeguirVerific;Regresa a verificacion pero ya no va encontrar lineas por lo tanto va a salir
Salir22:
    POP AF;Salida si no encuentra nada
    POP DE 
    POP BC
    POP AF
    RET
BAJARCOSAS:
    PUSH AF
    PUSH BC;Se guardan los registros
    PUSH DE
    DEC B ;Se decrementa una fila
    LD C,6
SumarColumna:
    PUSH AF
    LD A,b;Se compara si la fila es 0 o no, quiere decir que ya recorrió todo
    CP 0
    JR Z,SALIRBAJARCOSAS;Sale de bajar cosas
    POP AF    
    PUSH AF
    LD A,c
    CP 23; si llegó a 23 es necesario reiniciar la columna con otra fila
    JR Z,ReinicioLinea
    POP AF
RegresoReinicio:
    INC C;incrementa y lo hace con 6,COLUMNA
    LD L,B ;se carga la fila
    LD H,0
    ADD HL,HL  
    ADD HL,HL   ;Cambia posición Y
    ADD HL,HL  ;Se multiplica por 32
    ADD HL,HL   
    ADD HL,HL   
    LD E,C ;Se le suma la columna
    LD D,0
    ADD HL,DE
    LD DE,$5800;Empieza la pantalla en esta dirección
    ADD HL,DE  ;Esta la direecion final en hl
    ADD A
    ADD A;Se aumenta A para llegar al bit 8
    ADD A
    LD A,(HL);Para ver el color
    CP 0;La siguiente es 0, puede seguir y no entra al final
    JR NZ,CopiarValores;Si no es 0, hay un color y se debe copiar
    JP SumarColumna;Regresa al bucle de sumar columna
SALIRBAJARCOSAS:
    POP AF
    POP DE 
    POP BC
    POP AF
    JP RegresoBajarrCosas;Proceso para salir
CopiarValores:
    PUSH AF
    LD A,B
    LD (Fila),a;Se guarda la fila
    LD A,C
    LD (Columna),A;Se guarda la columna
    POP AF
    LD (COLORRNuevo),A;Se guarda el color
    PUSH BC
    PUSH AF
    LD A,(Fila);Se carga la fila
    LD B,A
    LD A,(Columna);Se carga la columna
    LD C,A
    POP AF
    LD A,0
    LD (HL),A;Se le quita el color a la figura
    PUSH HL;Se guarda la direeción
    PUSH DE
    LD DE,32;Se incrementa la fila
    ADD HL,DE
    POP DE  
    LD A,(COLORRNuevo);Se carga el color 
    LD (HL),A;Se termina de pintar el color
    POP HL;Se restaura la anterior direeción
    POP BC
    JP SumarColumna
ReinicioLinea:
    POP AF;POP que faltaba
    LD C,6;Se reinicia a en 6 la columna
    DEC B;Se decrementra la fila 1
    JP RegresoReinicio


Fila:DB 0
Columna:DB 0
COLORRNuevo:DB 0