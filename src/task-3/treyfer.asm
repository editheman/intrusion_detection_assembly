section .rodata
	global sbox
	global num_rounds
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0
	num_rounds dd 10

section .text
	global treyfer_crypt
	global treyfer_dcrypt

; void treyfer_crypt(char text[8], char key[8]);
treyfer_crypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_crypt
	xor eax, eax
	; folosesc eax ca contor
	mov eax, 0
big_loop:
	add eax, 1
	; adaug valoare contorului in stiva pentru a avea registrul eax liber
	push eax
	; folosesc registrul ecx ca si contor al celei de a doua bucle repetitive (for)
	; va porni cu valoarea 8, si va fi decrementat ulterior
	mov ecx, 8
	; eliberez orice valoarea ar fi fost in eax
	xor eax, eax
	; pun in eax primul bit din textul pe care il am de criptat
    mov eax, [esi]
enc:
	; formez indexul i
	mov edx, 8
	sub edx, ecx
	; copiez in ebx caracterul de la indexul i (edi + 8 - ecx) din key
	; am folosit movzx pentru a gestiona overflow ul
	movzx ebx, byte [edi + edx]
	; fac adunarea plain textului cu cheia
	add al, bl
	; pentru a gestiona mai departe overflow ul
	; sterg toate valorile din stanga registrului al
	shl eax, 24
	; si apoi il intoc la pozitia originala
	shr eax, 24
	; atribui lui t valoarea sa din sbox
	mov al, byte [sbox + eax]
	; in cazul in care indexul meu este 1,
	; trebuie ca rotatia sa fie facuta pe primul bit, altfel as iesii din spatiul de adrese
	cmp ecx, 1
	je is_last
	add al, byte [esi + edx + 1]
	jmp is_not_last
is_last:
	add al, byte [esi]
is_not_last:
	rol al, 1
	xor edx, edx
	; asemanator cu mai devreme in cazul in care indexul meu este 1,
	; trebuie sa fie facuta operatia astfel incat sa nu ies din spatiul de adrese
	cmp ecx, 1
	je is_one
	mov edx, 9
	sub edx, ecx
	; aleg pozitia pe care voi pune valoarea criptata
	mov byte [esi + edx], al
	jmp is_not_one

is_one:
	mov byte [esi], al

is_not_one:
	
	loop enc
	; scot contorul principal din stiva
	pop eax
	; conditia de oprire
	cmp eax, 10
	jl big_loop
	

    	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

; void treyfer_dcrypt(char text[8], char key[8]);
treyfer_dcrypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_dcrypt
	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	; eliberez orice ar fi fost anterior in eax
	xor eax, eax
	; imi initializez contorul
	mov eax, 0
decript_big_loop:
	; incrementarea contotului
	add eax, 1
	; adaug contorul in stiva
	push eax
	; initializez contorul pentru cea de a doua bucla
	; la care folosesc functia de loop
	mov ecx, 8
	; eliberez eax
	xor eax, eax
inside_loop:
	; aleg ultimul bit din textul encriptat
	movzx eax, byte [esi + ecx - 1]
	; aleg si bitul din cheie
	movzx ebx, byte [edi + ecx - 1]
	; realizez adunarea
	add al, bl
	; am grija de overflow stergand tot ce e inaintea lui al
	; si apoi revenind la forma initiala
	shl eax, 24
	shr eax, 24
	; aflu valoarea sumei din sbox
	mov dl, byte [sbox + eax]  ;top
	; daca elementul meu este ultimul, trebuie sa shiftez la drapta primul element
	; deoarece altfel ies din spatul de adrese
	cmp ecx, 8
	je next_one
	; shiftez pentru orice index
	mov bl, [esi + ecx]
	ror bl, 1  ;bot
	jmp next_step
next_one:
	; shiftarea in caz ca ma aflu pe pozitia 8
	mov bl, [esi]
	ror bl, 1  ;bot
next_step:
	sub ebx, edx
	; asemanator cu mai devreme in cazul in care indexul meu este 8,
	; trebuie sa fie facuta operatia astfel incat sa nu ies din spatiul de adrese
	cmp ecx, 8
	je ceva
	mov byte [esi + ecx], bl
	jmp altceva
ceva:
	mov byte [esi], bl
altceva:
	loop inside_loop
	; scaotem valoarea contorului din stiva
	pop eax
	; conditia de oprire
	cmp eax, 10
	jl decript_big_loop


	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

