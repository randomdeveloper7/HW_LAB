section .data
msg1: db "n1 = "
size1: equ $-msg1
msg2: db "n2 = "
size2: equ $-msg2
msg_common: db "Common elements: "
size_common: equ $-msg_common
space: db ' '

section .bss
array: resw 50 ;Array to store 50 elements of 1 word each.
array2: resw 50
n1: resd 1
n2: resd 1
q: resw 1
num: resw 1
count: resb 1
temp: resb 1

section .text
global _start
_start:
;Printing the message to enter the number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, size1
    int 80h
;Reading the number
    call read_num
    mov ax, word[num]
    mov word[n1], ax

    mov ebx, array
    mov eax, 0
    call read_array

;Printing the message to enter the number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, size1
    int 80h
;Reading the number
    call read_num
    mov ax, word[num]
    mov word[n2], ax

    mov ebx, array2
    mov eax, 0
    call read_array2

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_common
    mov edx, size_common
    int 80h

    mov ebx, array
    mov ecx, 0

    loop1:
        mov ax, word[ebx+2*ecx]
        mov word[q], ax
        call search
        cmp word[num], 0
        je skip
        mov word[num], ax
        call print_num
    skip:
        inc ecx
        cmp ecx, dword[n1]
        jb loop1


exit:
    mov eax, 1
    mov ebx, 0
    int 80h


read_num:
    pusha
    mov word[num],  0
    loop_read:
        mov eax,  3
        mov ebx,  0
        mov ecx,  temp
        mov edx,  1
        int 80h
        cmp byte[temp],  10
        je end_read
        mov ax,  word[num]
        mov bx,  10
        mul bx
        mov bl,  byte[temp]
        sub bl,  30h
        mov bh,  0
        add ax,  bx
        mov word[num],  ax
        jmp loop_read
    end_read:
        popa
        ret

read_array:
    pusha
    read_loop:
        cmp eax, dword[n1]
        je end
        call read_num
        mov cx,  word[num]
        mov word[ebx+2*eax],  cx
        inc eax
        jmp read_loop
    end:
        popa
        ret
read_array2:
    pusha
    read_loop2:
        cmp eax, dword[n2]
        je end2
        call read_num
        mov cx,  word[num]
        mov word[ebx+2*eax],  cx
        inc eax
        jmp read_loop2
    end2:
        popa
        ret

print_num:
    mov byte[count],  0
    pusha
    get_no:
        cmp word[num],  0
        je print_no
        inc byte[count]
        mov dx,  0
        mov ax,  word[num]
        mov bx,  10
        div bx
        push dx
        mov word[num],  ax
        jmp get_no
    print_no:
        cmp byte[count],  0
        je end_print
        dec byte[count]
        pop dx
        mov byte[temp],  dl
        add byte[temp],  30h
        mov eax,  4
        mov ebx,  1
        mov ecx,  temp
        mov edx,  1
        int 80h
        jmp print_no
    end_print:
        mov eax,  4
        mov ebx,  1
        mov ecx,  space
        mov edx,  1
        int 80h
        popa
        ret

search:
    pusha
    mov ebx, array2
    mov ecx, 0
    search_loop:
        mov ax , word[ebx+2*ecx]
        cmp ax, word[q]
        je found
        inc ecx
        cmp ecx, dword[n2]
        jb search_loop
    mov word[num], 0
    jmp end_search
    found:
        mov word[num], 1
    end_search:
        popa
        ret