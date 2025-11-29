.include "m168pdef.inc"

.org 0x0000
    rjmp RESET

; ==================== RUTINAS DE DELAY AJUSTADAS ====================
DELAY_1S:
    ldi  r19, 8                    ; Delay de 1 segundo ajustado
OUTER_1:
    ldi  r20, 43
MIDDLE_1:
    ldi  r21, 0
INNER_1:
    dec  r21
    brne INNER_1
    dec  r20
    brne MIDDLE_1
    dec  r19
    brne OUTER_1
    ret

DELAY_01S:
    ldi  r19, 1                    
OUTER_01:
    ldi  r20, 64                   ; Delay de 0.1 segundo ajustado
MIDDLE_01:
    ldi  r21, 0
INNER_01:
    dec  r21
    brne INNER_01
    dec  r20
    brne MIDDLE_01
    dec  r19
    brne OUTER_01
    ret

DELAY_MULTIPLE:
    push r18
DELAY_LOOP:
    rcall DELAY_01S
    dec r18
    brne DELAY_LOOP
    pop r18
    ret

RETARDO_LOOP:
    push r17
RETARDO_SEGUNDO:
    rcall DELAY_1S
    dec r17
    brne RETARDO_SEGUNDO
    pop r17
    ret

; ==================== PROGRAMA PRINCIPAL ====================
RESET:
    ; Configurar todos los puertos como salida
    ldi r16, 0xFF
    out DDRC, r16
    out DDRB, r16
    out DDRD, r16

CICLO_PRINCIPAL:
    rjmp INICIAR_TURNO_1

; ==================== TURNO 1 (40 segundos) ====================
INICIAR_TURNO_1:
    ; PD0 ON, PD1 OFF, PD2 OFF
    ; PC0 OFF, PC1 OFF, PC2 ON 
    ; PB0 OFF, PB1 OFF, PB2 ON, PB3 OFF
    ldi r16, (1<<PD0)
    out PORTD, r16
    ldi r16, (1<<PC2)
    out PORTC, r16
    ldi r16, (1<<PB2)
    out PORTB, r16

    ; PB3 parpadea durante 40 segundos
    ldi r17, 200                   ; 200 ciclos de 0.2s = 40 segundos
PARPADEO_PB3_T1:
    sbi PORTB, PB3
    ldi r18, 2
    rcall DELAY_MULTIPLE
    cbi PORTB, PB3
    ldi r18, 2
    rcall DELAY_MULTIPLE
    dec r17
    brne PARPADEO_PB3_T1

TERMINAR_TURNO_1:
    ldi r16, 0x00
    out PORTB, r16
    out PORTC, r16
    out PORTD, r16
    rjmp INICIAR_TURNO_2

; ==================== TURNO 2 (5 segundos) ====================
INICIAR_TURNO_2:
    ; PD0 ON, PD1 OFF, PD2 OFF
    ; PC0 OFF, PC1 OFF, PC2 ON
    ; PB0 OFF, PB1 OFF, PB2 OFF, PB3 OFF
    ldi r16, (1<<PD0)
    out PORTD, r16
    ldi r16, (1<<PC2)
    out PORTC, r16
    ldi r16, 0x00
    out PORTB, r16

    ; PB1 parpadea durante 5 segundos
    ldi r17, 25                    ; 25 ciclos de 0.2s = 5 segundos
PARPADEO_PB1_T2:
    sbi PORTB, PB1
    ldi r18, 2
    rcall DELAY_MULTIPLE
    cbi PORTB, PB1
    ldi r18, 2
    rcall DELAY_MULTIPLE
    dec r17
    brne PARPADEO_PB1_T2

TERMINAR_TURNO_2:
    ldi r16, 0x00
    out PORTB, r16
    out PORTC, r16
    out PORTD, r16
    rjmp INICIAR_TURNO_3

; ==================== TURNO 3 (40 segundos) ====================
INICIAR_TURNO_3:
    ; PD0 ON, PD1 OFF, PD2 OFF
    ; PC0 ON, PC1 OFF, PC2 OFF
    ; PB0 ON, PB1 OFF, PB2 OFF, PB3 OFF
    ldi r16, (1<<PD0)
    out PORTD, r16
    ldi r16, (1<<PC0)
    out PORTC, r16
    ldi r16, (1<<PB0)
    out PORTB, r16

    ; Esperar 40 segundos
    ldi r17, 40
    rcall RETARDO_LOOP

TERMINAR_TURNO_3:
    ldi r16, 0x00
    out PORTB, r16
    out PORTC, r16
    out PORTD, r16
    rjmp INICIAR_TURNO_4

; ==================== TURNO 4 (5 segundos) ====================
INICIAR_TURNO_4:
    ; PD0 ON, PD1 OFF, PD2 OFF
    ; PC0 OFF, PC1 OFF, PC2 OFF
    ; PB0 ON, PB1 OFF, PB2 OFF, PB3 OFF
    ldi r16, (1<<PD0)
    out PORTD, r16
    ldi r16, (1<<PB0)
    out PORTB, r16
    ldi r16, 0x00                  ; PC todo OFF
    out PORTC, r16

    ; PC1 parpadea durante 5 segundos
    ldi r17, 25                    ; 25 ciclos de 0.2s = 5 segundos
PARPADEO_PC1_T4:
    sbi PORTC, PC1
    ldi r18, 2
    rcall DELAY_MULTIPLE
    cbi PORTC, PC1
    ldi r18, 2
    rcall DELAY_MULTIPLE
    dec r17
    brne PARPADEO_PC1_T4

TERMINAR_TURNO_4:
    ldi r16, 0x00
    out PORTB, r16
    out PORTC, r16
    out PORTD, r16
    rjmp INICIAR_TURNO_5

; ==================== TURNO 5 (40 segundos) ====================
INICIAR_TURNO_5:
    ; PD0 OFF, PD1 OFF, PD2 ON
    ; PC0 OFF, PC1 OFF, PC2 ON
    ; PB0 ON, PB1 OFF, PB2 OFF, PB3 OFF
    ldi r16, (1<<PD2)
    out PORTD, r16
    ldi r16, (1<<PC2)
    out PORTC, r16
    ldi r16, (1<<PB0)
    out PORTB, r16

    ; Esperar 40 segundos
    ldi r17, 40
    rcall RETARDO_LOOP

TERMINAR_TURNO_5:
    ldi r16, 0x00
    out PORTB, r16
    out PORTC, r16
    out PORTD, r16
    rjmp INICIAR_TURNO_6

; ==================== TURNO 6 (5 segundos) ====================
INICIAR_TURNO_6:
    ; PD0 OFF, PD1 OFF, PD2 OFF
    ; PC0 OFF, PC1 OFF, PC2 ON
    ; PB0 ON, PB1 OFF, PB2 OFF, PB3 OFF
    ldi r16, (1<<PC2)
    out PORTC, r16
    ldi r16, (1<<PB0)
    out PORTB, r16
    ldi r16, 0x00                  ; PD todo OFF
    out PORTD, r16

    ; PD1 parpadea durante 5 segundos
    ldi r17, 25                    ; 25 ciclos de 0.2s = 5 segundos
PARPADEO_PD1_T6:
    sbi PORTD, PD1
    ldi r18, 2
    rcall DELAY_MULTIPLE
    cbi PORTD, PD1
    ldi r18, 2
    rcall DELAY_MULTIPLE
    dec r17
    brne PARPADEO_PD1_T6

TERMINAR_TURNO_6:
    ldi r16, 0x00
    out PORTB, r16
    out PORTC, r16
    out PORTD, r16
    rjmp INICIAR_TURNO_1           ; Volver al TURNO 1 (ciclo infinito)