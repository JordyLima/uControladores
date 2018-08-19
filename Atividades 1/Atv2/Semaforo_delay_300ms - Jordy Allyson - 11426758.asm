;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MEM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		CONT_1
		CONT_2
		;NOVAS VARI�VEIS

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;Aluno: Jordy Allyson de Sousa Lima - 11426758
;Atividade 2 - Simula��o de Sem�foro Simples com Delay de 300ms	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	MOVWF	CONT_1
	MOVWF	CONT_2
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BSF	   GPIO,GP5	;LED1 = HIGH        LED2 = LOW
	CALL	   CONTAGEM	;DELAY CONTAGEM DE 9 a 0 - dura��o 3s
	BCF	   GPIO,GP5	;LED1 = LOW         LED2 = HIGH
	CALL	   CONTAGEM	;DELAY CONTAGEM DE 9 a 0 - dura��o 3s
	GOTO	   MAIN	
	
CONTAGEM	    ;GP0 - MSB e GP4 - LSB
Seg_9
	    BSF	    GPIO,GP0	;1 
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
Seg_8
	    BSF	    GPIO,GP0	;1
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
Seg_7
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
Seg_6
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
Seg_5
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
Seg_4
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
Seg_3
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
Seg_2
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BSF	    GPIO,GP2	;1
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
	    
Seg_1
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
	    
Seg_0
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
return

delay300ms
	    MOVLW   D'200'  ;ATRAV�S DO CALCULO DO TEMPO APROXIMADO (Explicado
			    ;no coment�rio sobre o delay)
	    MOVWF   CONT_1  ;TEM-SE O VALOR DE 200 PARA O CONT_1

aux1
	    MOVLW   D'187'  ;IDEM AO COMENTARIO ANTERIOR
	    MOVWF   CONT_2  ;TEM-SE O VALOR DE 187 PARA O CONT_2

aux2			    ;####DELAY####
	    nop		    ;USA-SE A SEGUINTE EQUA��O COMO L�GICA:
	    nop		    ;CONT_2 * (QT_DE_OP_nop + DECFSZ + GOTO) = QT_DE_CICLOS
	    nop		    ;QT_DE_CICLOS * CONT_1 = TEMPO_DE_DELAY
	    nop		    ;EX.: 8us -> 5us(nop's) + 1us (DECFSZ) + 2us (GOTO)
	    nop		   ;187 * 8 = 1496 ciclos de m�quina (1496us ou 1,496ms)
			    ;1496 * 200 = 299,200 ms ~ 300ms
	    
	    DECFSZ CONT_2
	    goto aux2
	    
	    DECFSZ CONT_1
	    goto aux1
return	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END

