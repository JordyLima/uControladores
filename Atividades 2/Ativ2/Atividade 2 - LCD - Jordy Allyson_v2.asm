;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA�?�?ES PARA USO COM 12F675                 *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�?O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI�?�?O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI�?�?ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�?O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA�?�?O DE MEM�?RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI�?�?O DE COMANDOS DE USUÁRIO PARA ALTERA�?�?O DA PÁGINA DE MEM�?RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�?RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�?RIA


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI�?�?O DOS NOMES E ENDERE�?OS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�?O INICIAL DA MEM�?RIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO �?S INTERRUP�?�?ES
		
		DADOS_LCD	;OS BITS QUE QUERO MANDAR PARA O LCD
		LETRA

		;NOVAS VARIÁVEIS

	ENDC			;FIM DO BLOCO DE MEM�?RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI�?�?O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI�?�?O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI�?�?O DE TODOS OS PINOS QUE SER�?O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI�?�?O DE TODOS OS PINOS QUE SER�?O UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMB�?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)
#DEFINE	  LCD_EN   GPIO,GP5
#DEFINE	  SR_DAT   GPIO,GP4
#DEFINE	  SR_CLOCK GPIO,GP0 	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�?O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUP�?�?O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�?O DE DESVIO DAS INTERRUP�?�?ES. A PRIMEIRA TAREFA �? SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA�?�?O FUTURA

	ORG	0x04			;ENDERE�?O INICIAL DA INTERRUP�?�?O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP�?�?O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP�?�?ES
	
		
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUP�?�?O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP�?�?O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI�?�?O DE FUNCIONAMENTO
; E UM NOME COERENTE �?S SUAS FUN�?�?ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;DEFINE OP�?�?ES DE OPERA�?�?O
	MOVLW	B'11000000'
	MOVWF	INTCON		;DEFINE OP�?�?ES DE INTERRUP�?�?ES
	CALL	0X3FF
	MOVWF	OSCCAL
	
	BCF	 PIE1,TMR1IE	;DESABILITA A INTERRUP��O PELO TIMER1
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA�?�?O DO COMPARADOR ANAL�?GICO	
	BSF	T1CON,TMR1ON	;HABILITA O TIMER1
	BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERA��O INTERNO
	BCF	T1CON,T1CKPS1	
	BCF	T1CON,T1CKPS0	;PRESCALER 1:1	
	CLRF	DADOS_LCD
	CLRF	GPIO
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA�?�?O DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	CALL INIT_LCD	    ;CHAMA A ROTINHA DE INICIALIZA��O DO LCD
	call  delay_0.5s
		
	
	
	MOVLW A'J'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'o'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'r'
	CALL  ESCREVE
	call  delay_0.5s	
	MOVLW A'd'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'y'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW 0x20
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'L'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'i'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'm'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'a'
	CALL  ESCREVE
	
	call  delay_0.5s
       	
    GOTO MAIN	;REPETE A ESCRITA DO NOME
    
    
ESCREVE
    BSF  LCD_EN
	MOVWF	LETRA		   ;RECEBE 8 BITS DE DADOS
	RLF	LETRA		   ;FAZ RRF E ANALISA O CARRY
	BCF	SR_DAT		   ;DEPENDENDO DO VALOR EM CARRY, ENVIA 0 OU 1
	BTFSC	STATUS,C	   ;PARA O SHIFT REGISTER 
	BSF	SR_DAT		
	BSF	SR_CLOCK	   ;NESTE PONTO, ENVIA D7
	BCF	SR_CLOCK	   ;D� PULSO DE CLOCK PARA MOVIMENTA��O DOS BITS 
	
	RLF	LETRA		;ENVIA D6
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	    
	RLF 	LETRA		;ENVIA D5
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	RLF	LETRA		;ENVIA D4
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
				;RS - 0 COMANDO
				;RS - 1 CARACTER	
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BSF	SR_DAT		;ATIVA BACKLIGHT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
    BCF  LCD_EN
    	
    BSF  LCD_EN
	
	RLF	LETRA		   ;FAZ RRF E ANALISA O CARRY
	BCF	SR_DAT		   ;DEPENDENDO DO VALOR EM CARRY, ENVIA 0 OU 1
	BTFSC	STATUS,C	   ;PARA O SHIFT REGISTER 
	BSF	SR_DAT		
	BSF	SR_CLOCK	   ;NESTE PONTO, ENVIA D7
	BCF	SR_CLOCK	   ;D� PULSO DE CLOCK PARA MOVIMENTA��O DOS BITS 
	
	RLF	LETRA		;ENVIA D6
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	    
	RLF 	LETRA		;ENVIA D5
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	RLF	LETRA		;ENVIA D4
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
				;RS - 0 COMANDO
				;RS - 1 CARACTER	
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BSF	SR_DAT		;ATIVA BACKLIGHT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
    BCF  LCD_EN
RETURN
    
	
    
INIT_LCD ;DADOS => 0 0 BL RS D4 D5 D6 D7 PARA NIBBLE1
	 ;DADOS => 0 0 BL RS D0 D1 D2 D3 PARA NIBBLE2
	 ;       MSB                  LSB
    
	CALL delay_15ms	    ;ENVIA COMANDO 0X30 PARA O LCD
	BSF  LCD_EN
	MOVLW	B'00101100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN	
		
	CALL delay_4ms	    ;ENVIA COMANDO 0X30 PARA O LCD
	BSF  LCD_EN
	MOVLW	B'00101100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN	
	
	CALL delay_100us    ;ENVIA COMANDO 0X30 PARA O LCD
	BSF  LCD_EN
	MOVLW	B'00101100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
		
	CALL delay_100us    ;ESPERA DE SEGURAN�A
	
	BSF  LCD_EN	    ;ESTABELECE A COMUNICA��O POR 4VIAS
	MOVLW	B'00100100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_100us    ;CONDI��ES DE UTILIZA��O
	BSF  LCD_EN
	MOVLW	B'00100100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00100001' ;NIBBLE2  -   4VIAS e 2 LINHAS, MATRIZ 7X5
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_100us    ;CLEAR DISPLAY E CURSOR NA LINHA 1, NA ESQUERDA
	BSF  LCD_EN
	MOVLW	B'00100000' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00101000' ;NIBBLE2
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_1.8ms
	
	BSF  LCD_EN	    ;LIGA O DISPLAY SEM CURSOR
	MOVLW	B'00100000' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00100011' ;NIBBLE2  
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_100us
	
	BSF  LCD_EN	    ;DESLOCAMENTO AUTOM�TICO PARA DIREITA
	MOVLW	B'00100000' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00100110' ;NIBBLE2  
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_40us
	CALL delay_100us
return
	
	
;FUN��O QUE RECEBE O QUE � ENVIADO PARA O WORK
;ONDE FAZ ROTATE PARA DIREITA, PEGA O QUE EST� NO CARRY
;E ENVIA PARA O SHIFT REGISTER
SHIFT_REGISTER     
    
	MOVWF	DADOS_LCD	   ;RECEBE 8 BITS DE DADOS
	RRF	DADOS_LCD	   ;FAZ RRF E ANALISA O CARRY
	BCF	SR_DAT		   ;DEPENDENDO DO VALOR EM CARRY, ENVIA 0 OU 1
	BTFSC	STATUS,C	   ;PARA O SHIFT REGISTER 
	BSF	SR_DAT		
	BSF	SR_CLOCK	   ;NESTE PONTO, ENVIA D7
	BCF	SR_CLOCK	   ;D� PULSO DE CLOCK PARA MOVIMENTA��O DOS BITS 
	
	RRF	DADOS_LCD	;ENVIA D6
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	    
	RRF 	DADOS_LCD	;ENVIA D5
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	RRF	DADOS_LCD	;ENVIA D4
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	RRF	DADOS_LCD	;RS - 0 COMANDO
	BCF	SR_DAT		;RS - 1 CARACTER
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BSF	SR_DAT		;ATIVA BACKLIGHT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
RETURN
	
	
;##############################delays################################    
    delay_2s
	call  delay_0.5s
	call  delay_0.5s
	call  delay_0.5s
	call  delay_0.5s
    return
	
    delay_0.5s
	    BSF	T1CON,T1CKPS1	;DEFINE PRESCALER PARA 1:8
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .0		;INICIA O TIMER1 COM B'0000 0000'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS�O
	    aux_0.5s
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_0.5s
	   BCF	T1CON,T1CKPS1	
	   BCF	T1CON,T1CKPS0
    return
    
    delay_15ms
	    BCF	  PIR1,TMR1IF
	    MOVLW   .193	;INICIA O TIMER1 COM B'1100 0001'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS�O
	    aux_15ms
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_15ms
    return
    
    delay_8ms
	    BCF	    PIR1,TMR1IF
	    MOVLW   .222	;INICIA O TIMER1 COM B'1101 1110'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .199
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS�O
	    aux_8ms
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_8ms
    return
	   
    delay_4ms
	    BCF	  PIR1,TMR1IF
	    MOVLW   .236	;INICIA O TIMER1 COM B'1110 1100'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .115
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS�O
	    aux_4ms
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_4ms
    return
	   

    delay_1.8ms
	    BCF	  PIR1,TMR1IF
	    MOVLW   .248	;INICIA O TIMER1 COM B'1111 1000'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS�O
	    aux_1.8ms
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_1.8ms
    return
    
    delay_100us
	    BCF	  PIR1,TMR1IF
	    MOVLW   .255	;INICIA O TIMER1 COM B'1111 1111'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .120
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS�O
	    aux_100us
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_100us
    return
	   
    delay_40us
	    BCF	  PIR1,TMR1IF
	    MOVLW   .255	;INICIA O TIMER1 COM B'1111 1111'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .185
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS�O
	    aux_40us
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_40us
    return

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
