	AREA datos, DATA
vector 	DCB 0, 0, 0, 3, 3, 3, 6, 6, 6	
	ALIGN 4
	
	AREA Codigo, CODE
	EXPORT candidatos_propagar_arm
	PRESERVE8 {TRUE}
		
ENTRY

candidatos_propagar_arm
	PUSH{r4-r12 ,LR}
	mov r4, r0 				; r4 = r0 = @base cuadricula
	mov r5, r1 				; r5 = r1 = fila
	mov r6, r2 				; r6 = r2 = columna
	
	mov r7, #0 				; r7 = i
	add r8, r4, r5, LSL #5 	; r8 = @cuadricula[fila][0]
	add r9, r4, r6, LSL #1 	; r9 = @cuadricula[0][columna]
	add r10, r8, r6, LSL #1 ; r10 = @cuadricula[fila][columna]	
	ldrh r10, [r10]			; r10 = celda
	and r10, r10, #0x000f 	; r10 = valor celda
	add r10, r10, #6 		; r10 = valor + BIT_CANDIDATOS - 1
	mov r5, #1 				; r5 = 1

	; propagamos el candidato en la fila y la columna
BUCLE
	cmp r7, #9
	beq finBUC
	ldrh r11, [r8]  
	orr r11, r11, r5, LSL r10 ; r11 = cuadricula[fila][i] | (#1 << r10)
	strh r11, [r8], #2		; guardamos r11 en @r8 con un postincremento de 2
	ldrh r11, [r9]
	orr r11, r11, r5, LSL r10 ; r11 = cuadricula[i][columna] | (#1 << r10)
	strh r11, [r9], #32		; guardamos r11 en @r9 con un postincremento de 32
	add r7, r7, #1 			; i++
	b BUCLE
finBUC

	LDR r9, =vector 		; r9 = @vector
	ldrb r7, [r9, r1] 		; r7 = vector[fila] = init_i
	ldrb r8, [r9, r6] 		; r8 = vector[columna] = init_j
	add r9, r0, r7, LSL #5 	; @cuadricula[init_i][0]
	add r9, r9, r8, LSL #1 	; @cuadricula[init_i][init_j]
	mov r7, #0 				; r7 = i

	; propagamos el candidato en la region
BUC_I
	cmp r7, #3
	beq finBUC_I
	mov r8, #0 				; r8 = j = 0
	add r11, r9, r7, LSL #5 ; r11 = @cuadricula[init_i + i][init_j]
BUC_J
	cmp r8, #3
	beq finBUC_J
	ldrh r12, [r11] 		; r12 = @cuadricula[init_i + i][init_j + j]
	orr r12, r12, r5, LSL r10 ; r12 = cuadricula[fila][i] | (#1 << r10)
	strh r12, [r11], #2 	; guardamos r12 en @r11 con un postincremento de 2	
	add r8, r8, #1 			; j++
	b BUC_J
finBUC_J
	add r7, r7, #1 			; i++
	b BUC_I
finBUC_I
	POP{r4-r12, PC}
	END
