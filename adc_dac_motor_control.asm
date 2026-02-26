STAK    SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK    ENDS

CODE    SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK

START PROC
                
ENDLESS:
        ; Trigger ADC0804 conversion (assert WR signal)
        MOV DX, 400H        ; Load ADC0804 base address
        MOV AL, 00H         ; Dummy data to initiate conversion
        OUT DX, AL
        
        ; Poll INTR signal (Wait until D7 goes low)
INTR_KONTROL:
        MOV DX, 800H        ; Load address mapped to the INTR line
        IN AL, DX           ; Read status port
        TEST AL, 80H        ; Check D7 (INTR status bit: 10000000b)
        JNZ INTR_KONTROL    ; Loop if D7=1 (conversion in progress)
        
        ; Conversion complete, fetch data from ADC
        MOV DX, 400H        ; Load ADC0804 data port address
        IN AL, DX           ; Read digital value into AL
        
        ; Forward digital value to DAC (motor control)
        MOV DX, 200H        ; Load DAC0830 base address
        OUT DX, AL          ; Output the sampled ADC data to the DAC
        
        CALL DELAY
        
        JMP ENDLESS
        
        RET
START ENDP

; Delay subroutine
DELAY PROC NEAR
        PUSH CX
        MOV CX, 00FFH      
DELAY_LOOP:
        LOOP DELAY_LOOP
        POP CX
        RET
DELAY ENDP

CODE    ENDS
        END START