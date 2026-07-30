; MAPEDIT.EXE named disasm — module fseek.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _fseek  file 0x01567E..0x0156FE  seg 0x1388:0x7fe  (fseek.c.obj) ----
  01567E  55               push bp
  01567F  8bec             mov bp, sp
  015681  56               push si
  015682  8b7606           mov si, word ptr [bp + 6]
  015685  f6440683         test byte ptr [si + 6], 0x83
  015689  740c             je 0x15697
  01568B  837e0c02         cmp word ptr [bp + 0xc], 2
  01568F  7f06             jg 0x15697
  015691  837e0c00         cmp word ptr [bp + 0xc], 0
  015695  7d09             jge 0x156a0
  015697  c70668451600     mov word ptr [0x4568], 0x16
  01569D  eb52             jmp 0x156f1
  01569F  90               nop
  0156A0  806406ef         and byte ptr [si + 6], 0xef
  0156A4  837e0c01         cmp word ptr [bp + 0xc], 1
  0156A8  7514             jne 0x156be
  0156AA  56               push si
  0156AB  9af61e8813       lcall 0x1388, 0x1ef6
  0156B0  83c402           add sp, 2
  0156B3  014608           add word ptr [bp + 8], ax
  0156B6  11560a           adc word ptr [bp + 0xa], dx
  0156B9  c7460c0000       mov word ptr [bp + 0xc], 0
  0156BE  56               push si
  0156BF  9ace158813       lcall 0x1388, 0x15ce
  0156C4  83c402           add sp, 2
  0156C7  f6440680         test byte ptr [si + 6], 0x80
  0156CB  7404             je 0x156d1
  0156CD  806406fc         and byte ptr [si + 6], 0xfc
  0156D1  ff760c           push word ptr [bp + 0xc]
  0156D4  ff760a           push word ptr [bp + 0xa]
  0156D7  ff7608           push word ptr [bp + 8]
  0156DA  8a4407           mov al, byte ptr [si + 7]
  0156DD  2ae4             sub ah, ah
  0156DF  50               push ax
  0156E0  9ad21b8813       lcall 0x1388, 0x1bd2
  0156E5  83c408           add sp, 8
  0156E8  3dffff           cmp ax, 0xffff
  0156EB  7509             jne 0x156f6
  0156ED  3bd0             cmp dx, ax
  0156EF  7505             jne 0x156f6
  0156F1  b8ffff           mov ax, 0xffff
  0156F4  eb02             jmp 0x156f8
  0156F6  2bc0             sub ax, ax
  0156F8  5e               pop si
  0156F9  8be5             mov sp, bp
  0156FB  5d               pop bp
  0156FC  cb               retf
  0156FD  90               nop
