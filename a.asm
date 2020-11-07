;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Пн окт 12 2020
; Processor: AT89C51
; Compiler:  ASEM-51 (Proteus)
;====================================================================

$NOMOD51
$INCLUDE (8051.MCU)

;====================================================================
; DEFINITIONS
;====================================================================
TB BIT 20H.0
OUT EQU P2
DA_TA EQU 21H
BUFF EQU 22H
FL_SEND BIT 20H.1
ZVEZD_ BIT 20H.2
OPR EQU 24H
WR_ BIT P3.4
;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

      ; Reset Vector
      org   0000h
	  JMP   Init

	  org 0003h
		SETB TB
		MOV BUFF,P1
		MOV P1,#0FFh
		CLR IE0
	  RETI
	  
	  org 0023h
	  JNB TI, SERVE_RI
      CLR TI
      RETI
      
	  SERVE_RI:
	  ;MOV SCON, #00000000b
      CLR RI
      
      RETI

	  org 000Bh
      
      CALL SERVE_TIMER
      
      RETI

	  org 0013h
		;MOV SCON, #00010000b
		CALL SERVE_GET
	  RETI
		
;====================================================================
; CODE SEGMENT
;====================================================================

      org   0100h

Start:
	  JB TB, SERVE

SEND:
	  JNB FL_SEND, Loop
	  
      
	  CLR WR_
	  SETB WR_
	  NOP
	  NOP
	  NOP
	  NOP
      MOV SBUF, DA_TA
	  JNB TI, $
	  
      CLR FL_SEND

	  MOV OUT,#0FFh
      JMP Loop
Loop:	
      jmp Start

SERVE_TIMER:
	MOV P1, #0FFh
      MOV TL0, #-250				 ; ИНИЦИАЛИЗАЦИЯ ТАЙМЕРА
      MOV TH0, #-40
	 JB OPR.0, CH2
	 CLR OPR.1
	 SETB OPR.0
	 SETB OPR.2
	 CLR P1.4
	 JMP EX_
	 
	CH2:
      JB OPR.1, CH3
	 CLR OPR.2
	 SETB OPR.0
	 SETB OPR.1
	 CLR P1.5
	 JMP EX_

    CH3:
	 JB OPR.2, EX_
	 CLR OPR.0
	 SETB OPR.1
	 SETB OPR.2
	 CLR P1.6
	
      
      EX_:
      RET

SERVE_GET:
	  MOV SCON, #00010000b
	  JNB RI,$
	  MOV SCON, #00000000b
      MOV R0, SBUF
       
      MOV A, R0
      ANL A, #15
      MOV DPTR,#OUTM
      MOVC A,@A+DPTR
	  MOV OUT,A
      RET
SERVE:	
		CLR ZVEZD_
		JB BUFF.4, CH_COL2
			JB BUFF.0, CH_BUT_1B
			MOV DA_TA,#1
			JMP EXIT
		CH_BUT_1B:
			JB BUFF.1, CH_BUT_1C
			MOV DA_TA,#4
			JMP EXIT
		CH_BUT_1C:
			JB BUFF.2, CH_BUT_1D
			MOV DA_TA,#7
			JMP EXIT
		CH_BUT_1D:
			JB BUFF.3, CH_COL2
			SETB ZVEZD_
			MOV DA_TA,#10
			JMP EXIT


	CH_COL2:
		JB BUFF.5, CH_COL3
			JB BUFF.0, CH_BUT_2B
			MOV DA_TA,#2
			JMP EXIT
		CH_BUT_2B:
			JB BUFF.1, CH_BUT_2C
			MOV DA_TA,#5
			JMP EXIT
		CH_BUT_2C:
			JB BUFF.2, CH_BUT_2D
			MOV DA_TA,#8
			JMP EXIT
		CH_BUT_2D:
			JB BUFF.3, CH_COL3
			MOV DA_TA,#0
			JMP EXIT


	CH_COL3:
		JB BUFF.6, EXIT
			JB BUFF.0, CH_BUT_3B
			MOV DA_TA,#3
			JMP EXIT
		CH_BUT_3B:
			JB BUFF.1, CH_BUT_3C
			MOV DA_TA,#6
			JMP EXIT
		CH_BUT_3C:
			JB BUFF.2, CH_BUT_3D
			MOV DA_TA,#9
			JMP EXIT
		CH_BUT_3D:
			JB BUFF.3, EXIT
			SETB FL_SEND
			SETB ZVEZD_
			;MOV DA_TA,#10
	EXIT:
	   MOV A,DA_TA
       MOV DPTR,#OUTM
       MOVC A,@A+DPTR
       MOV OUT, A
	   CLR TB
	   JB ZVEZD_, ZVEZD
	   JMP SEND
	ZVEZD:
		CLR ZVEZD_
	    JMP SEND
Init:
		
		

		MOV OPR,#0
		MOV SCON, #00000000b
		MOV TMOD, #00000001B		 ; ТАЙМЕР(C/T0 = 0) В 1 РЕЖИМ M1.0=0 M0.0=1
		MOV TL0, #-250				 
		MOV TH0, #-40


		SETB ET0 					
		SETB TR0
		;SETB ES
		SETB EX0
		SETB EA
		SETB EX1
		MOV OUT,#0BFh

		JMP Start


 OUTM: DB 0C0h,0F9h,0A4h,0B0H,99h,92h,82h,0F8h,80h,90h,0FFh
;====================================================================
      END
