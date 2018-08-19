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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		
		CONT_5		;Vari�veis CONT_x s�o usadas na manipula��o
		CONT_6		;e cria��o dos diferentes delays necess�rios
		CONT_7
		CONT_8
		CONT_9
		CONT_10
		CONT_BIT	;Faz a contagem de quanto tempo passa em LOW
		DECODE		;Recebe o sinal enviado pelo controle na forma MSB-LSB
		AUX_SINAL	;Vari�vel que � decrementada sempre que um novo sinal � identificado
		AUX_TRATA   	;Vari�vel que � uma c�pia do que se recebe em DECODE, afim de fazer
				;Verifica��o de qual n�mero ser� mostrado no display de 7seg
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
;uC 2018.1
;Atividade 3 - Decodificador de Protocolo Infravermelho Controle Sony	
;Aluno: Jordy Allyson de Sousa Lima - 11426758

INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	CALL	0X3FF
	MOVWF	OSCCAL
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF	GPIO
	CLRF	CONT_5
	CLRF	CONT_6
	CLRF	CONT_7
	CLRF	CONT_8
	CLRF	CONT_9
	CLRF	CONT_10
	CLRF	DECODE
	CLRF	CONT_BIT
	CLRF	AUX_TRATA
	MOVLW	.9	    ;VALOR QUE SER� DECREMENTADO, AT� CHEGAR NO FINAL
	MOVWF	AUX_SINAL   ;DO SINAL DE CONTROLE
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BTFSS	   GPIO,GP3	    ;A CADA CHEGADA DE SINAL DO SENSOR IR, VERIFICA
	CALL	   VERIFICA	    ;SE O SINAL CONTINUA EM HIGH, SE N�O VAI 
	GOTO MAIN		    ;SER VERIFICADO QUE TIPO DE SINAL EST� RECEBENDO.
	
VERIFICA
	CLRF	CONT_BIT	    ;TODA VEZ QUE FOR FAZER UMA NOVA VERIFICA��O, ZERA A CONTAGEM.
	
	CALL	delay_25us	    ;ATRASO QUE SERVE COMO FORMA DE VERIFICAR QUANTO TEMPO PRECISA
	VER_AUX			    ;PASSAR PARA QUE SEJA ST_BIT, ZERO OU UM.
	
	CALL	   delay_25us	    ;ESTA ROTINA (VER_AUX) POSSUI UM TEMPO DE EXECU��O DE ~37us
	BTFSC	   GPIO,GP3	    ;SENDO ASSIM, TEREMOS OS VALORES APROXIMADOS DE QUANTAS CONTAGENS
	GOTO	   CONTADOR	    ;PRECISAM SER FEITAS EM LOW PARA QUE SE IDENTIFIQUE CADA BIT
	INCF	   CONT_BIT	    ;CORRETAMENTE.
GOTO	   VER_AUX		    

CONTADOR
	DECFSZ	AUX_SINAL	    ;SEMPRE QUE � FEITA UMA VERIFICA��O, DECREMENTA-SE AUX_SINAL
	GOTO	debg		    ;CASO SEJA IGUAL A ZERO (RECEBEU TODOS OS SINAIS DE CONTROLE)
	GOTO	IGNORA_RESTO	    ;O RESTO DOS SINAIS (DEVICE) S�O IGNORADOS.
    debg
    ;IDENTIFICA START_BIT
	MOVLW	.55			;COMO A ROTINA RESPONS�VEL PELA CONTAGEM LEVA 37us PARA SER EXECUTADA
	SUBWF	CONT_BIT,0		;TEMOS QUE PARA IDENTIFICAR QUE O BIT � START_BIT FAZEMOS 2.400/37 = 64
	BTFSS	STATUS,C		;O QUE SERIA O PONTO DE LIMIAR DO SINAL, COMO ESTE N�MERO PODE VARIAR 
	GOTO	CONTADOR_EH1		;BASTANTE, ESCOLHEU-SE 55 POR SER UMA APROXIMA��O BOA, DE ACORDO COM 
	GOTO	DECODE_RECEBE_START_BIT ;TESTES EM BANCADA.
	
    ;IDENTIFICA UM
	CONTADOR_EH1		    ;USANDO O CONCEITO ADOTADO EM START_BIT, TEMOS QUE PARA QUE SEJA UM
	MOVLW	.24		    ;1.200/37 = 32 QUE � O LIMIAR PARA DETERMINAR SE � UM. SENDO ASSIM, 
	SUBWF	CONT_BIT,0	    ;UMA BOA APROXIMA��O FOI DE 24, DE ACORDO COM OS TESTES EM BANCADA.
	BTFSS	STATUS,C
	GOTO	CONTADOR_EH0
	GOTO	DECODE_RECEBE_1
	
    ;IDENTIFICA ZERO
	CONTADOR_EH0		    ;USANDO O CONCEITO ADOTADO EM START_BIT, TEMOS QUE PARA QUE SEJA UM
	MOVLW	.12		    ;600/37 = 16 QUE � O LIMIAR PARA DETERMINAR SE � ZERO. SENDO ASSIM,
	SUBWF	CONT_BIT,0	    ;UMA BOA APROXIMA��O FOI DE 12, DE ACORDO COM OS TESTES EM BANCADA.
	BTFSS	STATUS,C
	GOTO	VERIFICA_AINDA
	GOTO	DECODE_RECEBE_0
	
	VERIFICA_AINDA		    ;CASO N�O SEJA NENHUM DOS 3, VOLTA A ESPERAR
	    BTFSC   GPIO,GP3	    ;NIVEL ALTO, AT� UMA NOVA DESCIDA ONDE REFAZ	
	    GOTO    MAIN	    ;A CONTAGEM E VERIFICA��O DOS N�MEROS
	GOTO	VERIFICA_AINDA
	
	;============================
	
	IGNORA_RESTO		    ;D� UM DELAY DE 2.5ms PARA IGNORAR O SINAL DE DEVICE.
	    MOVLW   .9		    ;REINICIA A NOVA CONTAGEM QUE SER� FEITA.
	    MOVWF   AUX_SINAL	    
	    CALL   delay_2.2ms	    ;CHAMA A ROTINA PARA DELAY.
	GOTO	   TRATA_SINAL	    ;PARTE PARA O TRATAMENTO DO SINAL QUE FOI RECEBIDO EM DECODE
	
	;===============================
	;A CADA IDENTIFICA��O DE BIT, COLOCA-SE NA VARI�VEL DECODE
	;O BIT CORRESPONDENTE � IDENTIFICA��O.
	DECODE_RECEBE_START_BIT	    
	    BCF	   STATUS,C	    
	    RRF	   DECODE,F	    
	GOTO	MAIN	    
	
	DECODE_RECEBE_1
	    BSF	   STATUS,C
	    RRF	   DECODE,F
	GOTO	MAIN
	
	DECODE_RECEBE_0
	    BCF	   STATUS,C
	    RRF	   DECODE,F
	GOTO	MAIN	
	
	;==========INICIO TRATA SINAL============
	TRATA_SINAL	      ;NESTE PONTO DO PROGRAMA, DECODE J� EST� COM TODOS
	    BCF	    STATUS,C  ;SINAIS, INCLUINDO ST_BIT. COM ISSO, � FEITO RRF
	    RRF	    DECODE,F  ;PARA IGNORAR ST_BIT E A PARTIR DISTO, EXIBIR NO DISPLAY.
	    MOVF    DECODE,W	
	    MOVWF   AUX_TRATA
			    
	BOTAO_0			;EM CADA LABEL RESPONSAVEL PELO BOT�O, � FEITA
	    MOVLW   .9		;UMA SUBTRA��O DO VALOR IDENTIFICADO EM DECODE
	    SUBWF   AUX_TRATA,0	;ONDE QUANDO O RESULTADO DA SUBTRA��O FOR ZERO
	    BTFSC   STATUS,Z	;TEM-SE QUE O BOT�O PRESSIONADO CORRESPONDE
	    GOTO    DISPLAY_0	;AO BOT�O QUE A LABEL INDICA, CASO N�O,
				;UM LED PISCA COM UM INTERVALO DE 100ms
	BOTAO_1			;INDICANDO QUE AQUELE BOT�O N�O � TRATADO.
	    MOVLW   .0
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_1
	    
	BOTAO_2
	    MOVLW   .1
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_2
	    
	BOTAO_3
	    MOVLW   .2
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_3
	    
	BOTAO_4
	    MOVLW   .3
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_4
	    
	BOTAO_5
	    MOVLW   .4
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_5
	    
	BOTAO_6
	    MOVLW   .5
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_6
	    
	BOTAO_7
	    MOVLW   .6
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_7
	    
	BOTAO_8
	    MOVLW   .7
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_8
	    
	BOTAO_9
	    MOVLW   .8
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_9
	
	BOTAO_QUALQUER
	    BSF	    GPIO,GP5
	    CALL    delay_100ms
	    BCF	    GPIO,GP5
	    
	    BSF	    GPIO,GP0	;1
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	;==========FIM TRATA SINAL=============
	
	;==========CONFIGURA��O DISPLAYS=============
	;GP0 - MSB
	;GP1
	;GP2
	;GP4 - LSB
	DISPLAY_0
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms	   ;ESTE DELAY FOI NECESS�RIO POIS AO SE FAZER
				   ;TESTES NA BANCADA, O DISPLAY ENCONTRAVA ALGUM
				   ;LIXO COMO SINAL E FICAVA INST�VEL.
	GOTO	MAIN
	
	DISPLAY_1
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_2
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BSF	    GPIO,GP2	;1
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_3
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_4
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_5
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_6
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_7
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_8
	    BSF	    GPIO,GP0	;1
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_9
	    BSF	    GPIO,GP0	;1
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	;==========FIM CONFIGURA��O DISPLAYS=============

;=================== DELAYS =====================	
;NA BASE DE TESTES, TANTO NA BANCADA QUANDO NO SIMULADOR, TEMOS OS SEGUINTES 
;DELAYS. ONDE CADA UM RECEBE UM VALOR ESPEC�FICO DE NOP'S E NOS CONTADORES
;AFIM DE QUE ALCANCE O TEMPO DESEJADO.
delay_25us
	    MOVLW   D'2'   
	    MOVWF   CONT_7  

aux7
	    MOVLW   D'2'  
	    MOVWF   CONT_8  

aux8			    
	    DECFSZ CONT_8
	    goto aux8
	    
	    DECFSZ CONT_7
	    goto aux7
return
	    
delay_2.2ms
	    MOVLW   D'30'  			    
	    MOVWF   CONT_5  

aux5
	    MOVLW   D'8'  
	    MOVWF   CONT_6  

aux6			    
	    nop		    
	    nop		    
	    nop		    
	    nop		    
	    nop		    
	    NOP
	    NOP
	    NOP
	    
	    DECFSZ CONT_6
	    goto aux6
	    
	    DECFSZ CONT_5
	    goto aux5
return

delay_100ms
	    MOVLW   D'400'  			    
	    MOVWF   CONT_9  

aux9
	    MOVLW   D'125'  
	    MOVWF   CONT_10  

aux10	
	    NOP
	    NOP
	    NOP
	    
	    DECFSZ CONT_10
	    goto aux10
	    
	    DECFSZ CONT_9
	    goto aux9
return	    

;=================== FIM DELAYS =====================	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
