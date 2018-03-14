; 20H-2DH is used
; oprand1 at 20H, oprand2 at 22H, opcode at 21H
; answer
; digit3 at 26H, digit2 at 27H, digit1 at 28H, digit0 at 29H
; division has its fraction part at 2AH, 2BH, 2CH, 2DH
; sign flag 0000000SH at 25H

ORG             0000H
LJMP            CALC

ORG             1000H
;branch according to the opcode at 21H
CALC:             MOV		A,21H
                        CLR             C
                        SUBB	        A,#0AH
			JZ		ADD_CALL	;0AH
			DEC		A
			JZ		SUB_CALL	;0BH
			DEC		A
			JZ		MUL_CALL	;0CH
			DEC		A
			JZ		DIV_CALL	;0DH

ADD_CALL:	LCALL	ADD_SBRT
			LJMP	DONE
SUB_CALL:	LCALL	SUB_SBRT
			LJMP	DONE
MUL_CALL:	LCALL	MUL_SBRT
			LJMP	DONE
DIV_CALL:	LCALL	DIV_SBRT
			LJMP	DONE

			;oprend1 at 20H signal extension at 23H
ADD_SBRT:	MOV		A,20H
			ANL		A,#80H	;get the MSB
			RL		A		;shift the MSB to LSB
			MOV		23H,A
			CLR		A
			SUBB	A,23H
			MOV		23H,A

			;oprend2 at 22H signal extension at 24H
			MOV		A,22H
			ANL		A,7FH	;get the MSB
			RL		A		;shift the MSB to LSB
			MOV		24H,A
			CLR		A
			SUBB	A,24H
			MOV		24H,A

			;ADD operation, H at 25H, L at 26H
			CLR		C
			MOV		A,20H
			ADDC	A,22H
			MOV		26H,A
			MOV		A,23H
			ADDC	A,24H
			MOV		25H,A	;store high bit

			;get sign,27H=0000000S 28H=SSSSSSSS
			ANL		A,7FH
			RL		A
			MOV		27H,A
			MOV		29H,A
			CLR		A
			SUBB	A,29H
			MOV		28H,A

			;get absolute value of H at 25H and L at 26H, answer H at 23H, L at 24H
			;inverting
			MOV		A,25H
			XRL		A,28H	;invert
			MOV		25H,A
			MOV		A,26H
			XRL		A,28H   ;invert
			;MOV	26H,A
			;increasing
			CLR		C
			;MOV	A,26H
			ADDC	A,27H	;add 1
			MOV		24H,A
			MOV		A,25H
			ADDC	A,#00H
			MOV		23H,A

			; put sign at 25H
			MOV		25H,27H

			;end of subroutine
			RET

			;oprend1 signal extension
SUB_SBRT:	MOV		A,20H
			ANL		A,#80H
			RL		A
			MOV		23H,A
			CLR		A
			SUBB	A,23H
			MOV		23H,A

			;oprend2 signal extension
			MOV		A,22H
			ANL		A,#80H
			RL		A
			MOV		24H,A
			CLR		A
			SUBB	A,24H
			MOV		24H,A

			;SUB operation, H at 25H, L at 26H
			CLR		C
			MOV		A,20H
			SUBB	A,22H
			MOV		26H,A
			MOV		A,23H
			SUBB	A,24H
			MOV		25H,A	;store high bit

			;get sign, 27H=0000000S 28H=SSSSSSSS
			;27H=0000000S
			;MOV		A,25H
			ANL		A,#80H
			RL		A
			MOV		27H,A
			;28H=SSSSSSSS
			MOV		29H,A
			CLR		A
			CLR		C
			SUBB	A,29H
			MOV		28H,A

			;get absolute value of H at 25H and L at 26H
			;answer H at 23H, L at 24H
			;inverting
			MOV		A,25H
			XRL		A,28H	;invert
			MOV		25H,A
			MOV		A,26H
			XRL		A,28H   ;invert
			;MOV	26H,A
			;increasing
			CLR		C
			;MOV	A,26H
			ADDC	A,27H	;add 1
			MOV		24H,A
			MOV		A,25H
			ADDC	A,#00H
			MOV		23H,A

			;put sign at 25H
			MOV		25H,27H

			;end of subroutine
			RET

			;get sign of answer, 27H=0000000S, 28H=SSSSSSSS
MUL_SBRT:	MOV		A,20H
			ANL		A,#80H
			RL		A
			MOV		23H,A
			MOV		A,22H
			ANL		A,#80H
			RL		A
			XRL		A,23H	;get the sign
			MOV		27H,A	;27H=0000000S
			MOV		29H,A
			CLR		A
			SUBB	A,29H
			MOV		28H,A	;28H=SSSSSSSS



			;MUL operation, H at 25H, L at 26H
			MOV 	A,20H;
			MOV 	B,22H;
			MUL		AB;
			MOV		25H,B
			MOV		26H,A

			;get absolute value of H at 25H and L at 26H
			;answer H at 23H, L at 24H
			;inverting
			MOV		A,25H
			XRL		A,28H	;invert
			MOV		25H,A
			MOV		A,26H
			XRL		A,28H   ;invert
			;MOV	26H,A
			;increasing
			CLR		C
			;MOV	A,26H
			ADDC	A,27H	;add 1
			MOV		24H,A
			MOV		A,25H
			ADDC	A,#00H
			MOV		23H,A

			;put sign at 25H
			MOV		25H,27H

			;end of subroutine
			RET

			;get sign of answer, 27H=0000000S, 28H=SSSSSSSS
DIV_SBRT:	MOV		A,20H
			ANL		A,#80H
			RL		A
			MOV		23H,A
			MOV		A,22H
			ANL		A,#80H
			RL		A
			XRL		A,23H	;get the sign
			MOV		27H,A	;27H=0000000S
			MOV		29H,A
			CLR		A
			SUBB	A,29H
			MOV		28H,A	;28H=SSSSSSSS

			;get absolute value of oprend1 at 25H and oprend2 at 26H
			;answer: oprend1 at 25H, oprend2 at 26H
			;25H is 0
			;op1
			MOV		A,20H
			MOV		C,ACC.7
			JNC		OP1_POS
OP1_NEG:	XRL		A,28H	;invert
			ADD		A,27H	;increase
OP1_POS:	MOV		25H,A
			;op2
			MOV		A,22H
			MOV		C,ACC.7
			JNC		OP2_POS
OP2_NEG:	XRL		A,28H	;invert
			ADD		A,27H	;increase
OP2_POS:	MOV		26H,A




			;DIV operation, Q at 25H, R is for fraction
			MOV 	A,25H;
			MOV 	B,26H;
			DIV		AB;
			MOV		24H,A;
			MOV		28H,B;
			MOV		23H,#00H;

			;put sign at 25H
			MOV		25H,27H

			;get fraction
			MOV		2AH,#00H;
			MOV		2BH,#00H;
			MOV		2CH,#00H;
			MOV		2DH,#00H;
			;divider at 26H, reminder at 28H
			MOV		A,B;quotient at A
		;calculate fraction digit1 at 30H
			MOV		R3,#09H; multiplied by 10
FRAC1:		ADD		A,B;
			CLR		C;
			SUBB	A,26H;
			MOV		C,ACC.7;
			JNC		FRAC1_INC
FRAC1_NINC:	ADD		A,26H	;recover
			DEC		2AH;
FRAC1_INC:	INC		2AH		;franction digit increased
			DJNZ	R3,FRAC1;
			MOV		B,A
		;calculate fraction digit2 at 31H
			MOV		R3,#09H; multiplied by 10
FRAC2:		ADD		A,B;
			CLR		C;
			SUBB	A,26H;
			MOV		C,ACC.7;
			JNC		FRAC2_INC
FRAC2_NINC:	ADD		A,26H	;recover
			DEC		2BH;
FRAC2_INC:	INC		2BH		;franction digit increased
			DJNZ	R3,FRAC2;
			MOV		B,A
		;calculate fraction digit3 at 32H
			MOV		R3,#09H; multiplied by 10
FRAC3:		ADD		A,B;
			CLR		C;
			SUBB	A,26H;
			MOV		C,ACC.7;
			JNC		FRAC3_INC
FRAC3_NINC:	ADD		A,26H	;recover
			DEC		2CH;
FRAC3_INC:	INC		2CH		;franction digit increased
			DJNZ	R3,FRAC3;
			MOV		B,A
		;calculate fraction digit3 at 32H
			MOV		R3,#09H; multiplied by 10
FRAC4:		ADD		A,B;
			CLR		C;
			SUBB	A,26H;
			MOV		C,ACC.7;
			JNC		FRAC4_INC
FRAC4_NINC:	ADD		A,26H	;recover
			DEC		2DH;
FRAC4_INC:	INC		2DH		;franction digit increased
			DJNZ	R3,FRAC4;


			RET


;BIN2BCD
; H at 23H, L at 24H, sign at 25H
; digit3 at 26H, digit2 at 27H, digit1 at 28H, digit0 at 29H
			;clear
DONE:		MOV		26H,00H;
			MOV		27H,00H;
			MOV		28H,00H;
			MOV		29H,00H;

			;
				;subtract 1000
DIGIT3_LOOP:	CLR		C
				MOV		A,24H
				SUBB	A,#0E8H	;L of 1000
				MOV		24H,A
				MOV		A,23H
				SUBB	A,#03H	;H of 1000
				MOV		23H,A
				;count digit3
				INC		26H
				;test if less than zero
				MOV		C,ACC.7
				JNC		DIGIT3_LOOP		;jump if subtracting not over

			;recover the last subtraction
				DEC		26H
				CLR		C
				MOV		A,24H
				ADDC	A,#0E8H	;L of 1000
				MOV		24H,A
				MOV		A,23H
				ADDC	A,#03H	;H of 1000
				MOV		23H,A

				;subtract 100
DIGIT2_LOOP:	CLR		C
				MOV		A,24H
				SUBB	A,#64H	;L of 100
				MOV		24H,A
				MOV		A,23H
				SUBB	A,#00H	;H of 100
				MOV		23H,A
				;count digit3
				INC		27H
				;test if less than zero
				MOV		C,ACC.7
				JNC		DIGIT2_LOOP		;jump if subtracting not over

			;recover the last subtraction
				DEC		27H
				CLR		C
				MOV		A,24H
				ADDC	A,#64H	;L of 100
				MOV		24H,A
				MOV		A,23H
				ADDC	A,#00H	;H of 100
				MOV		23H,A

				;subtract 10
DIGIT1_LOOP:	CLR		C
				MOV		A,24H
				SUBB	A,#0AH	;10
				MOV		24H,A
				;count digit3
				INC		28H
				;test if less than zero
				MOV		C,ACC.7
				JNC		DIGIT1_LOOP		;jump if subtracting not over

			;recover the last subtraction
				DEC		28H
				CLR		C
				MOV		A,24H
				ADDC	A,#0AH	;10
				MOV		24H,A

				;directly move as the BCD of digit0
DIGIT0_LOOP:	MOV		29H,24H

sjmp $

END

; digit3 at 26H, digit2 at 27H, digit1 at 28H, digit0 at 29H
; sign 0000000SH at 25H



