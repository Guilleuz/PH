    AREA datos, DATA
vector 	DCB 0, 0, 0, 3, 3, 3, 6, 6, 6	
	ALIGN 4
    
    AREA Codigo, CODE
    EXPORT candidatos_actualizar_arm
	PRESERVE8 {TRUE}
	ENTRY

candidatos_actualizar_arm
    stmdb SP!, {r4-r12, LR} ; cambiar por store multiple
    ;mov r4, r0              ; r4 = @cuadricula
    mov r5, #0              ; r5 = celdas vacias
    mov r6, #0              ; r6 = i = 0

    ; borramos los candidatos
Filas_1_arm
    cmp r6, #9
    beq finB1_1_arm
    mov r7, #0              ; r7 = j = 0
Columnas_1_arm
    cmp r7, #9
    beq finB2_1_arm
    add r8, r0, r6, LSL #5  ; r8 = @base + i * 16 
    add r8, r8, r7, LSL #1  ; r8 = (@base + i * 16) + j * 2
    ldrh r9, [r8]           ; r9 = cuadricula[i][j]
    and r9, r9, #0x0000007F ; r9 = r9 AND #0x0000007F, ponemos todos los bits de candidatos a 0
    strh r9, [r8]
    add r7, r7, #1          ; j++
    b Columnas_1_arm
finB2_1_arm
    add r6, r6, #1          ; i++
    b Filas_1_arm
finB1_1_arm

    ; propagamos los candidatos
    ; contamos celdas vacias
    mov r6, #0              ; r6 = i = 0
Filas_2_arm
    cmp r6, #9
    beq finB1_2_arm
    mov r7, #0              ; r7 = j = 0
Columnas_2_arm
    cmp r7, #9
    beq finB2_2_arm
    add r8, r0, r6, LSL #5  ; r8 = @base + i * 16 
    add r8, r8, r7, LSL #1  ; r8 = (@base + i * 16) + j * 2
    ldrh r9, [r8]           ; r9 = celda[i][j]
    and r9, r9, #0x0000000f ; r9 = valor celda
    cmp r9, #0
    ; si el valor es 0, contamos celda vacía
    addeq r5, r5, #1        ; celdas_vacias++
    ; si no, propagamos el candidato
    beq sinLlamada
    ; inlining de la función candidatos_propagar_arm   
    
    add r9, r9, #6          ; r9 = valor + BIT_CANDIDATOS - 1
    add r10, r0, r6, LSL #5 ; r10 = @cuadricula[fila][0]
    add r11, r0, r7, LSL #1 ; r11 = @cuadricula[0][columna]	
    
    mov r2, #1              ; r2 = 1
    mov r1, #0              ; r1 = i
    ; Propagamos el candidato en la fila y la columna
BUCLE_arm
    cmp r1, #9
    beq finBUC_arm
    ldrh r3, [r10]          ; r3 = cuadricula[fila][i]
    orr r3, r3, r2, LSL r9  ; r3 = r3 | (#1 << r9)
    strh r3, [r10], #2      ; postincremento, r10 apuntará a cuadricula[fila][i++]
    ldrh r3, [r11]          ; r3 = cuadricula[i][columna]
    orr r3, r3, r2, LSL r9  ; r3 = r3| (#1 << r9)
    strh r3, [r11], #32     ; postincremento, r11 apuntará a cuadricula[i++][columna]
    add r1, r1, #1          ; i++
    b BUCLE_arm
finBUC_arm

    ;LDR r4, =vector         ; r4 = @vector
    ;ldrb r3, [r4, r6]       ; r3 = vector[fila] = init_i
    ;ldrb r4, [r4, r7]       ; r4 = vector[columna] = init_j
    
    mov r3, #0
    cmp r6, #3
    blt fin_init_i
    cmp r6, #6
    movlt r3, #3
    blt fin_init_i
    mov r3, #6

fin_init_i
    mov r4, #0
    cmp r7, #3
    blt fin_init_j
    cmp r7, #6
    movlt r4, #3
    blt fin_init_j
    mov r4, #6

fin_init_j
    add r8, r0, r3, LSL #5  ; @cuadricula[init_i][0]
    add r8, r8, r4, LSL #1  ; @cuadricula[init_i][init_j]
    mov r1, #0 ; r1 = i
    ; propagamos el candidato en la region correspondiente
BUC_I_arm
    cmp r1, #3
    beq finBUC_I_arm
    ;mov r10, #0             ; r10 = j = 0
    add r11, r8, r1, LSL #5 ; r11 = @cuadricula[init_i + i][init_j]
BUC_J_arm
    ;cmp r10, #3
    ;beq finBUC_J_arm
    ;ldrh r12, [r11]         ; r12 = @cuadricula[init_i + i][init_j + j]
    ;orr r12, r12, r2, LSL r9; r12 = r12 | (#1 << r9)
    ;strh r12, [r11], #2     ; guardamos r12 en @r11 con un postincremento de 2
                            ; de forma que r11 apuntara a cuadricula[init_i + i][init_j + (j++)]
    ;add r10, r10, #1        ; j++
    ;b BUC_J_arm
finBUC_J_arm

	; nueva ver
	; rebaja a 960 us
	ldrh r12, [r11]
    orr r12, r12, r2, LSL r9; r12 = r12 | (#1 << r9)
    strh r12, [r11], #2
	ldrh r12, [r11]
    orr r12, r12, r2, LSL r9; r12 = r12 | (#1 << r9)
    strh r12, [r11], #2 
	ldrh r12, [r11]
    orr r12, r12, r2, LSL r9; r12 = r12 | (#1 << r9)
    strh r12, [r11], #2 

    add r1, r1, #1          ; i++
    b BUC_I_arm
finBUC_I_arm
    
    ; fin del inlining de la funcion candidatos_propagar_arm
sinLlamada
    add r7, r7, #1          ; j++
    b Columnas_2_arm
finB2_2_arm
    add r6, r6, #1          ; i++
    b Filas_2_arm
finB1_2_arm

    ; devolvemos el numero de celdas vacias
    mov r0, r5              ; r5 = celdas_vacias
    ldmia SP!, {r4-r12, PC}         ; cambiar por load multiple
    END
