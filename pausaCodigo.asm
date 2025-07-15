PausaCodigo:
    PUSH AF
    PUSH DE
    PUSH HL
    PUSH BC
    LD DE,(Tiempo_espera)   ;Cantidad de tiempo a esperar
Wait:
    DEC DE;Se va decrementando 1 a 1
    LD A,E;primero se decrementa E
    OR A
    JR NZ, Wait

    LD A,D;Se decrementa D
    OR A
    JR NZ, Wait
    POP BC
    POP HL;Se restauran los registros
    POP DE
    POP AF
    RET
Tiempo_espera: DW $1FFF

