%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .text

check_permission:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; id and permission
    mov     ebx, [ebp + 12] ; address to return the result
    ;; DO NOT MODIFY
   
    ;; Your code starts here
    ; pun ultimii biti primii, ca sa pot sa extrag id ul
    rol eax, 8
    ; copiez id ul
    mov dl, al
    ; aflu indexul din vectorul ant_permissions
    imul edx, 4
    ; aleg elementul din vector
    mov esi, [ant_permissions + edx]
    ; intorc registrul eax in forma initiala
    ror eax, 8
    ; folosesc ecx ca si contor al functiei loop
    mov ecx, 24

check:
    ; intru intr un for de la 24 la 1
    ; compar cei 24 de biti
    mov edx, eax
    ; aplicand operatia and, aflu daca ultimul bit este 1 sau 0
    ; si il compar cu permisiunile din ant permission
    and edx, 1
    mov edi, esi
    and edi, 1
    shr eax, 1
    shr esi, 1
    ; acest loop este intrerupt doar in cazul in care furnica cere o sala
    ; (bitul curent = 1), iar disponibilitatea este 0 (bitul din esi = 0)
    cmp edx, edi
    jg not_empty
    loop check
    ; daca loop ul a trecut de fiecare data de not_empty, inseamna succes,
    ; adica toti bitii de 1 din imput au fost gasiti
    mov dword [ebx], 1
    jmp end

not_empty:
    ; in caz contrar, loop ul se incheie,
    ; deoarece o singura valoare gresita ne strica rezultatul final
    mov dword [ebx], 0
    jmp end

end:
    popa
    leave
    ret

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
