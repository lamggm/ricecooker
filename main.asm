;
; ricecooker.asm
;
; Created: 06/11/2023 09:29:47
; Author : luism
;

; Maquina de Lavar em Assembly

; Definições de Macros e Constantes
#define __SFR_OFFSET 0    ; Define o deslocamento zero para os registradores especiais
#define LED PB5            ; Define a macro LED como PB5, um alias para o pino B5
#define TL1 r1             ; Define TL1 como r1, um alias para o registrador r1
#define TL2 0x100          ; Define TL2 como 0x100

#define TM r22             ; Define TM como r22, um alias para o registrador r22
#define TS r23             ; Define TS como r23, um alias para o registrador r23
#define TC r24             ; Define TC como r24, um alias para o registrador r24

#define mais PB0           ; Define mais como PB0, um alias para o pino B0
#define menos PB1          ; Define menos como PB1, um alias para o pino B1
#define enter PB2          ; Define enter como PB2, um alias para o pino B2

#define sensor_porta PB3   ; Define sensor_porta como PB3, um alias para o pino B3
#define sensor_vazio PB4   ; Define sensor_vazio como PB4, um alias para o pino B4
#define sensor_cheio PB5   ; Define sensor_cheio como PB5, um alias para o pino B5

#define motor_centr PC0    ; Define motor_centr como PC0, um alias para o pino C0
#define motor_lav PC1      ; Define motor_lav como PC1, um alias para o pino C1
#define valv_esv PC2       ; Define valv_esv como PC2, um alias para o pino C2
#define valv_cheio PC3     ; Define valv_cheio como PC3, um alias para o pino C3
#define valv_sab PC4       ; Define valv_sab como PC4, um alias para o pino C4
#define valv_amac PC5      ; Define valv_amac como PC5, um alias para o pino C5

.ORG 0x000             ; Define a origem (endereço inicial) do programa como 0x000
rjmp main              ; Realiza um salto incondicional para o rótulo "main" para iniciar a execução

#include "avr/io.h"       ; Inclui um arquivo de cabeçalho para definições específicas do microcontrolador AVR
#include "biblioteca.h"  ; Inclui um arquivo de cabeçalho chamado "biblioteca.h"

.global main           ; Define o rótulo "main" como uma função globalmente visível

main:                  ; Início da função "main" onde a execução do programa começa

; Configuração de pinos e registradores
ldi aux, 0b00000000  ; Define aux para 0b00000000 para configuração de PORTB como entrada
out DDRB, aux         ; Define DDRB como entrada
ldi aux, 0b11111111  ; Define aux para 0b11111111 para ativar resistências de pull-up
out PORTB, aux        ; Ativa resistências de pull-up em PORTB
out DDRC, aux         ; Define DDRC como saída
out DDRD, aux         ; Define DDRD como saída

rcall lcd_init        ; Chama a função "lcd_init" para inicializar o LCD
rcall lcd_clear       ; Chama a função "lcd_clear" para limpar o LCD

; Inicialização de variáveis
ldi aux, 0             ; Inicializa aux com 0
mov TL1, aux           ; Move o valor de aux para TL1
ldi aux, 5             ; Inicializa aux com 5
sts TL2, aux           ; Armazena o valor de aux em TL2
ldi TC, 0              ; Inicializa TC com 0
ldi TM, 0              ; Inicializa TM com 0
ldi TS, 0              ; Inicializa TS com 0

; Mensagem de boas-vindas por 5 segundos
Comeco:
ldi lcd_col, 7         ; Posiciona o cursor na coluna 7
rcall lcd_lin0_col      ; Posiciona o cursor na linha 0 do LCD
ldi lcd_caracter, 'O'  ; Define o caracter 'O'
rcall lcd_write_caracter ; Chama a rotina para imprimir o caracter
ldi lcd_caracter, 'L'  ; Define o caracter 'L'
rcall lcd_write_caracter ; Chama a rotina para imprimir o caracter
ldi lcd_caracter, 'A'  ; Define o caracter 'A'
rcall lcd_write_caracter ; Chama a rotina para imprimir o caracter
ldi delay_time, 5      ; Define o tempo
rcall delay_seconds    ; Chama a rotina de tempo

	; imprime mensagem de tempo para LAVAR 1
Def_tp_tl1:
	rcall lcd_clear
	ldi lcd_col, 0
	rcall lcd_lin0_col
	ldi lcd_caracter, 'T'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'E'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'P'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, 'L'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'V'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, '1'
	rcall lcd_write_caracter

Imp_tl1:
	ldi lcd_col,8  
	rcall lcd_lin1_col  ; chama rotina posicionando na segunda linha 
	mov lcd_number, TL1 ; move valor para imprimir TL1
	rcall lcd_write_number

	sbis PINB, 0 ; testa pino B0 sem pressionar =1 pula linha
	rjmp Aum_1 ; botao pressionado
	
	sbis PINB, 1 ; testa pino B1 sem pressionar =1 pula linha
	rjmp Dim_1 ; botao pressionado
	
	sbis PINB, 2 ; testa pino B2 sem pressionar =1 pula linha
	rjmp soltou1 ; botao pressionado pula para proxima etapa
	rjmp Imp_tl1

soltou1:
  sbic PINB, 2   ;;  esta pressionado pula
	rjmp Def_tp_tl2
	rjmp soltou1 
 

Aum_1:
	inc TL1
	ldi delay_time,200  
	rcall delay_miliseconds  ; atraso para o botao pressionado
	rjmp Imp_tl1

Dim_1:
	dec TL1
	ldi delay_time,200  
	rcall delay_miliseconds  ; atraso para o botao pressionado
	rjmp Imp_tl1
;;;;;

	; imprime mensagem de tempo para LAVAR 1
Def_tp_tl2:
  rcall mensagem_lavar2

Imp_tl2:
	ldi lcd_col,8  
	rcall lcd_lin1_col  ; chama rotina posicionando na segunda linha 
	LDS aux, TL2
	mov lcd_number, aux ; move valor para imprimir TL1
	rcall lcd_write_number

	sbis PINB, 0 ; testa pino B0 sem pressionar =1 pula linha
	rjmp Aum_2 ; botao pressionado
	
	sbis PINB, 1 ; testa pino B1 sem pressionar =1 pula linha
	rjmp Dim_2 ; botao pressionado
	
	sbis PINB, 2 ; testa pino B2 sem pressionar =1 pula linha
	rjmp Def_tp_tl3 ; botao pressionado pula para proxima etapa
	rjmp Imp_tl2

Aum_2:
	lds aux, TL2
	inc aux
	sts TL2, aux

	ldi delay_time,200  
	rcall delay_miliseconds  ; atraso para o botao pressionado
	rjmp Imp_tl2

Dim_2:
	lds aux, TL2
	dec aux
	sts TL2, aux
	ldi delay_time,200  
	rcall delay_miliseconds  ; atraso para o botao pressionado
	rjmp Imp_tl2
;;;;;;;;;;;;;;;;;;;;;;;;;;;
Def_tp_tl3:
  rcall mensagem_molho1
		ldi delay_time,1  
	rcall delay_seconds  

Imp_TM:
	ldi lcd_col,8  
	rcall lcd_lin1_col  ; chama rotina posicionando na segunda linha 
	mov lcd_number, TM ; move valor para imprimir TL1
	rcall lcd_write_number

	sbis PINB, 0 ; testa pino B0 sem pressionar =1 pula linha
	rjmp Aum_3 ; botao pressionado
	
	sbis PINB, 1 ; testa pino B1 sem pressionar =1 pula linha
	rjmp Dim_3 ; botao pressionado
	
	sbis PINB, 2 ; testa pino B2 sem pressionar =1 pula linha
	rjmp EM_OPERACAO ; botao pressionado pula para proxima etapa
	rjmp Imp_TM

Aum_3:
	inc TM
	ldi delay_time,200  
	rcall delay_miliseconds  ; atraso para o botao pressionado
	rjmp Imp_TM

Dim_3:
	dec TM
	ldi delay_time,200  
	rcall delay_miliseconds  ; atraso para o botao pressionado
	rjmp Imp_TM




	;;;;;;;;;;================================================================================
	;;;;;;;;;;;;;  inicializando  maquina de lavar imprime EM OPERACAO
EM_OPERACAO:
	rcall lcd_clear
	ldi lcd_col, 0
	rcall lcd_lin0_col
	ldi lcd_caracter, 'E'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'P'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'E'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'C'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
	;;;;;;;; 
Encher1:
	rcall Parar ; testa porta se porta aberta
	rcall imprime_enchendo  ; chama rotina para imprimir lcd enchendo
	sbi PORTC,valv_cheio   ; liga valvula para encher
Testa_encher:
	sbis PINB, sensor_cheio  ; testa se o sensor de cheio
	rjmp Lavar1 ; =0 pula proxima etapa
	rjmp Testa_encher ; =1 retorna para encher1

Lavar1:
	rcall imprime_lavando1  ; chama rotina para imprimir lcd lavando1
	cbi PORTC,valv_cheio ; desliga valvula encher
	sbi PORTC,valv_sab ; liga valvula sabao
	sbi PORTC,motor_lav ; liga motor lavar
	mov delay_time, TL1 ; define tempo de lavagem 1 movendo valor TL1 para delay_time
	rcall delay_seconds ; chama rotina de delay segundos
	cbi PORTC,motor_lav ; desliga motor lavar
	cbi PORTC,valv_sab ; desliga sabao

Esvaziar1:
    sbi PORTC,valv_esv  ; liga valvula esvaziar
	rcall imprime_esvaziando  ; chama rotina para imprimir lcd _esvaziando:
	rcall Parar ; testa porta se porta aberta
Testa_esvaziar1:
	sbis PINB, sensor_vazio ; testa o nivel vazio
	rjmp main  ; =0 pula proxima etapa  ENCHER
	rjmp Testa_esvaziar1 ;=1 retorna em esvaziar 1




	rjmp main ; retorna ao incio do processo

Parar:
    sbis PINB, 3 ; nao pressionado =1 pula linha retornando
	rjmp suspende ; porta aberta =0  zera saidas
	ret
suspende:
    IN r0, PORTC  ;guarda o estado da portC em aux
	;mov r0, aux  ; armazena r0 valor de aux
	clr aux
	OUT PORTC,aux; zera saidas
loop_parado:
	sbis PINB, 3 ; testa o botao =1 (porta fechada) pula, se =0(porta aberta) e fica em loop 
	rcall loop_parado
    mov aux, r0  ; recupera valor de r0 em aux
    OUT PORTC, aux  ; restaura o valor da porta
	ret
	// FIM



	;;;; rotinas para impressao de mensagem durante operacao
imprime_enchendo:
	  ldi lcd_col, 0
	  rcall lcd_lin1_col
	  ldi lcd_caracter, 'E'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'n'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'c'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'h'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'e'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'n'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'd'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'o'
		rcall lcd_write_caracter
	  ret  ; volta para onde ocorreu desvio
imprime_esvaziando:
         Ret

imprime_lavando1:
	  ldi lcd_col, 0
	  rcall lcd_lin1_col
	  ldi lcd_caracter, 'L'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'a'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'v'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'a'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'n'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'd'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, 'o'
	  rcall lcd_write_caracter
	  ldi lcd_caracter, ' '
		 rcall lcd_write_caracter
	  ret  ; volta para onde ocorreu desvio	

mensagem_lavar2:
	rcall lcd_clear
	ldi lcd_col, 0
	rcall lcd_lin0_col
	ldi lcd_caracter, 'T'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'E'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'P'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, 'L'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'V'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, '2'
	rcall lcd_write_caracter
  Ret



mensagem_molho1:
	rcall lcd_clear
	ldi lcd_col, 0
	rcall lcd_lin0_col
	ldi lcd_caracter, 'T'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'E'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'P'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'o'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'l'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'h'
	rcall lcd_write_caracter
	ldi lcd_caracter, '0'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, '1'
	rcall lcd_write_caracter
  Ret