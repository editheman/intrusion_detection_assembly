%include "../include/io.mac"

extern printf
extern position
global solve_labyrinth

; you can declare any helper variables in .data or .bss
section.data
format db "Line: %d column: %d", 10, 0
section .text

; void solve_labyrinth(int *out_line, int *out_col, int m, int n, char **labyrinth);
solve_labyrinth:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; unsigned int *out_line, pointer to structure containing exit position
    mov     ebx, [ebp + 12] ; unsigned int *out_col, pointer to structure containing exit position
    mov     ecx, [ebp + 16] ; unsigned int m, number of lines in the labyrinth
    mov     edx, [ebp + 20] ; unsigned int n, number of colons in the labyrinth
    mov     esi, [ebp + 24] ; char **a, matrix represantation of the labyrinth
    ;; DO NOT MODIFY
   
    ;; Freestyle starts here
    ; eax este linia curenta
    mov dword [eax], 0
    ; ebx este coloana curenta
    mov dword [ebx], 0
    ; decrementez deoarece indexii mei se vor duce pana la m-1 respectiv n-1
    dec ecx
    dec edx
    ; fac verificarea pentru elementul din dreapta celui curent
find_path:
    ; salvez valoarea lui eax in stiva pentru a nu o modifica accidental
    mov edi, [eax]
    push eax
    ; pastrez in eax valoarea sa
    mov eax, edi
    xor edi, edi
    ; cu ajutorul lui eax voi memora linia la care ma aflu (spatul de memorie)
    imul eax, 4
    ; inmultesc cu 4 deoarece liniile merg din 4 in 4 (sizeof(pointer))
    ; extrag valoarea din celula a[eax][ebx]
    mov edi, [esi + eax]
    mov eax, [ebx]
    ; elementul curent il inlocuiesc cu zid, pentru a mi limita puterea de a ma intoarce
    mov byte [edi + eax], '1'
    ; compar daca elementul din drepta este zid
    cmp byte [edi + eax + 1], '1'
    ; daca este zid, verific in celelalte parti
    je not_right
    ; daca nu, incrementez coloana pe care ma aflu
    add dword [ebx], 1
    ; verific daca am ajuns la final
    cmp [ebx], edx
    ; recuperez valoare initiala a lui eax
    pop eax
    je end
    jmp find_path
    ; fac verificarea pentru elementul de sub cel curent
not_right:
    pop eax
    mov edi, [eax]
    push eax
    mov eax, edi
    add eax, 1
    imul eax, 4
    mov edi, [esi + eax]
    mov eax, [ebx]
    ; verific daca este zid
    cmp byte [edi + eax], '1'
    ; daca este, caut in partile ramase (stanga sus)
    je not_under
    ; altfel, scot valoarea lui eax din stiva si o incrementez,
    ; pentru a ajunge pe urmatoarea linie a matricii
    xor eax, eax
    pop eax
    add dword [eax], 1
    ; verific daca am ajuns la final
    cmp [eax], ecx
    je end
    jmp find_path
    ; fac verificarea pentru elementul din stanga elementului curent
not_under:
    pop eax
    mov edi, [eax]
    push eax
    mov eax, edi
    xor edi, edi
    imul eax, 4
    ; extrag valoarea elementului curent (pentru a putea sa iterez din 1 in 1 pe linie)
    mov edi, [esi + eax]
    ; scad indexul coloanei
    mov eax, [ebx]
    sub eax, 1
    ; verific daca este perete
    cmp byte [edi + eax], '1'
    je not_left
    ; in acest caz, scad valoarea indexului coloanei
    mov dword [ebx], eax
    pop eax
    jmp find_path
    ; fac verificarea pentru elementul de deasupra elementului curent
not_left:
    pop eax
    mov edi, [eax]
    push eax
    mov eax, edi
    ; scad contorul liniei, dar nu inainte de al salva in stiva
    sub eax, 1
    imul eax, 4
    mov edi, [esi + eax]
    pop eax
    ; scad indexul liniei
    ; nu mai exista nici un fel de restrictie de oprire, deoarece ne este garantat
    ; ca exista in drum pana la final, asa ca daca celelalte miscari un au putu fi 
    ; executate, aceasta este singura ramasa posibila
    sub dword [eax], 1
    jmp find_path
    ; Freestyle ends here
end:
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
