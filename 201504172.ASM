ORG 0000H
                                                                                                                                                                                 MOV P0,#00H
MOV P2,#00H
START:
MOV R2,#00H
MOV R3,#01H
BEGIN:
MOV DPTR,#TAB
MOV A,R2
MOVC A,@A+DPTR
MOV P0,A
INC R2
MOV A,R2
MOVC A,@A+DPTR
MOV P3                                                                                                                       ,A
INC R2
MOV A,R3
;LCALL DELAY
MOV P0,#00H
MOV P3,#00H
MOV P1,A
INC R3
;LCALL DELAY
CJNE R3,#17,BEGIN
SJMP START

TAB:DB  008H,000H,088H,00FH,088H,008H,0BEH,008H,0AAH,008H,0AAH,008H,0AAH,009H,0AAH,00AH
DB  0AAH,00AH,0AAH,008H,0AAH,008H,0BAH,048H,088H,048H,048H,048H,048H,070H,028H,000H

DELAY:
MOV R5,#1
D1:MOV R6,#100
D2:MOV R7,#250
NOP
DJNZ R6,D2
DJNZ R5,D1
RET

SJMP $
END
