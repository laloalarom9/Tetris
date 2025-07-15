BucleRecuadro:
    PUSH HL
    PUSH BC
    PUSH DE
    PUSH AF;Esto se hace para que estos registros puedan ser restaurados a sus valores originales al final de la rutina
    LD A, $38 ;lo que se va a imprimir(color blanco)
    LD B,22;Aquí empieza la columna 
    LD HL,$5806;Dirección de memoria en HL
    LD DE,32;Para sumar columnas
BucleColumna:;Bucle para imprimir la columna
    ADD HL,DE;se suma una fila
    LD (HL),A;Se carga el color en hl
    DJNZ BucleColumna;Hasta que sea 0 se decrementa b
    LD B,18;Se incializa la fila
    LD DE,1
BucleFila:
    ADD HL,DE;Se suma 1 para aumentar la columna
    LD (HL),A
    DJNZ BucleFila;Se decrementa b y regresa al bucle hasta que sea cero
    LD HL,$5806+18;Dirección de memoria en HL
    LD B,22;Se incializa la otra columna
    LD DE,32;Mismo proceso que la columna anterior
BucleColumna2:
    ADD HL,DE;Se le suma una fila
    LD (HL),A;Se pinta
    DJNZ BucleColumna2
    POP AF;Se restauran los registros
    POP DE 
    POP BC
    POP HL
    RET;Regresa
