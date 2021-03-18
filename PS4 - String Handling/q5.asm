section .data
    msg1 : db 'String : '
    l1 : equ $-msg1
    msg2 : db 'n(spaces) =  '
    l2 : equ $-msg2
    zero: db '0'
    num: dw 0

section .bss
    string : resb 200
    c : resb 1
    count: resb 1
    temp: resb 1

section .text

    global _start:
	_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, l1
    int 80h

    cld
    mov edi, string
    call read_str

    mov edi, string
    mov al, 32
    loop:
        cmp byte[edi], 0
        je out
        scasb
        jne skip
        inc word[num]
    skip:
        jmp loop
    out:
        mov eax, 4
        mov ebx, 1
        mov ecx, msg2
        mov edx, l2
        int 80h
        call print_num
    exit:
    mov eax, 1
    mov ebx, 0
    int 80h

read_str:
    pusha
    rstr_loop:
        mov eax, 3
        mov ebx, 0
        mov ecx, c
        mov edx, 1
        int 80h
        mov al, byte[c]
        cmp al, 0Ah
        je exit_rstr
        stosb
        jmp rstr_loop

    exit_rstr:
    mov byte[edi], 0
    popa
    ret

print_num:
    cmp word[num], 0
    je print0
    mov byte[count], 0
    pusha
    get_no:
        cmp word[num], 0
        je print_no
        inc byte[count]
        mov dx, 0
        mov ax, word[num]
        mov bx, 10
        div bx
        push dx
        mov word[num], ax
        jmp get_no
    print_no:
        cmp byte[count], 0
        je end_print
        dec byte[count]
        pop dx
        mov byte[temp], dl
        add byte[temp], 30h
        mov eax, 4
        mov ebx, 1
        mov ecx, temp
        mov edx, 1
        int 80h
        jmp print_no
    print0:
        mov eax, 4
        mov ebx, 1
        mov ecx, zero
        mov edx, 1
        int 80h
    end_print:
        mov eax, 4
        mov ebx, 1
        mov ecx, 10
        mov edx, 1
        int 80h
        popa
        ret
