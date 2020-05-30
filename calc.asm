;; Proyecto calculador
;; Alfonso Reyes Cortés y Oscar Oswaldo León Meza
;; Viva la Mexico
.MODEL medium
.STACK 100
ORG 100h
.386
.data
    mostrarMenu db '===============.MENU.===============',13,10
                db '1. Suma',13,10
                db '2. Resta',13,10
                db '3. Division',13,10
                db '4. Multiplicacion',13,10
                db '5. Salir',13,10,13,10
				db 'Seleccione una Opcion -->$',13,10
	new_line db 10,13, " $"
	msg_op_suma db 10,13, 'SUMA','$'
	msg_op_resta db 10,13, 'RESTA','$'
	msg_op_div db 10,13, 'DIVISION','$'
	msg_op_multi db 10,13, 'MULTIPLICACION','$'
    num1 db ?
	num2 db ?
    msg_num db 10,13,'Proporciona un num: ', 	'$'
    msg_suma db 10,13,'Suma: = ',				'$'
	msg_resta db 10,13,'Resta: = ',				'$'
    msg_div db 10,13,'Division: = ',			'$'
    msg_multi db 10,13,'Multiplicacion: = ',	'$'
    decenas db ?
    unidades db ?
; MACROS

; Este macro imprime un mensaje
imprimir macro dato
    mov ah,09h
    lea dx,dato ; Cargar dato
	int 21h ; Interrupción servicio de video
endm

pedirNum macro dato
	imprimir msg_num
	mov ah,01h
	int 21h
	sub al,30h
	mov dato,al
endm

operacionSuma macro
		imprimir msg_suma
        mov al,num1
        add al,num2
        aam
        mov decenas,ah
        mov unidades,al
        add decenas,30h ;ajuste manual
		add unidades,30h
		; imprimir valores
        mov ah,02h
        mov dl,decenas
        int 21h
        mov ah,02h
        mov dl,unidades
        int 21h
endm
operacionResta macro
		imprimir msg_resta
        xor ax,ax
        mov al, num1
        mov bl,num2
        div bl
        aam
        
        mov decenas,ah
        mov unidades,al
        
        add decenas,30h
        add unidades,30h
        ; imprimir valores
        mov ah,02h
        mov dl,decenas
        int 21h
        
        mov ah,02h
        mov dl,unidades
        int 21h
endm
operacionMultiplicacion macro
		imprimir msg_multi
        mov al,num1
        mov bl,num2
        mul bl
        aam
        
        mov decenas,ah
        mov unidades,al
        
        add decenas,30h ;ajuste manual
        add unidades,30h
        ; imprimir valores
        mov ah,02h
        mov dl,decenas
        int 21h
        
        mov ah,02h
        mov dl,unidades
        int 21h
endm
operacionDivision macro
		imprimir msg_div
        xor ax,ax
        mov al, num1
        mov bl,num2
        div bl
        aam
        
        mov decenas,ah
        mov unidades,al
        
        add decenas,30h
        add unidades,30h
        ; imprimir valores
        mov ah,02h
        mov dl,decenas
        int 21h
        
        mov ah,02h
        mov dl,unidades
        int 21h
endm
.code
; PROCEDIMIENTOS
limpiar proc far
;; codigo proc
	mov ah,00h;	Limpiar Pantalla
	mov al,03h
 	int 10h
	mov cx,02h
ret
endp
Inicio:
	; Colocar apuntador
    mov ax, @data
	mov ds,ax
Menu:
	imprimir new_line
	imprimir mostrarMenu
	mov ah,01h ; Pide caracter
	int 21h
	xor ah,ah
	sub al,30h
	; Salto condicional jump equals opción n saltar si es igual a la opcion n
	cmp al,1
	je Suma
	cmp al,2
	je Resta
	cmp al,3
	je Division
	cmp al,4
	je Multiplicacion
	cmp al,5
	je Salir
	jmp Menu ; Si es alguna otra opción, mostrar el menu de nuevo
Salir:
	mov ah,04ch
	int 21h
Suma:
	imprimir msg_op_suma
	pedirNum num1
	pedirNum num2
	operacionSuma
	mov ah,01;pausa y captura de datos
	int 21h
	; cmp al,27 ; ASCII de ESC
	jmp Menu ; usar je para validar que solo con ESC continue a menu, no olvides quitar el comentario de cmp jaja salu2
Resta:
	imprimir msg_op_resta
	pedirNum num1
	pedirNum num2
	operacionResta
	mov ah,01; Pausar y pedir un nuevo caracter para continuar, puede ser ESC o cualquiera
	int 21h
    jmp Menu
Division:
	imprimir msg_op_div
	pedirNum num1
	pedirNum num2
	operacionDivision
	mov ah,01; Pausar y pedir un nuevo caracter para continuar, puede ser ESC o cualquiera
	int 21h
    jmp Menu
Multiplicacion:
	imprimir msg_op_multi
	pedirNum num1
	pedirNum num2
	operacionMultiplicacion
	mov ah,01; Pausar y pedir un nuevo caracter para continuar, puede ser ESC o cualquiera
	int 21h
    jmp Menu
.exit
end Inicio
