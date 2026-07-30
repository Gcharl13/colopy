; MAPEDIT.EXE named disasm — module ECHO_1.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @echo  file 0x013DB0..0x013DEC  seg 0x127B:0x0  (ECHO_1.C.obj) ----
  013DB0  c8020000         enter 2, 0
  013DB4  50               push ax
  013DB5  ff7608           push word ptr [bp + 8]
  013DB8  ff7606           push word ptr [bp + 6]
  013DBB  9ad40d8813       lcall 0x1388, 0xdd4
  013DC0  83c404           add sp, 4
  013DC3  8946fe           mov word ptr [bp - 2], ax
  013DC6  1e               push ds
  013DC7  8b4efe           mov cx, word ptr [bp - 2]
  013DCA  bb0100           mov bx, 1
  013DCD  c55606           lds dx, ptr [bp + 6]
  013DD0  b440             mov ah, 0x40
  013DD2  cd21             int 0x21
  013DD4  1f               pop ds
  013DD5  8b46fc           mov ax, word ptr [bp - 4]
  013DD8  0bc0             or ax, ax
  013DDA  740c             je 0x13de8
  013DDC  b20a             mov dl, 0xa
  013DDE  b402             mov ah, 2
  013DE0  cd21             int 0x21
  013DE2  b20d             mov dl, 0xd
  013DE4  b402             mov ah, 2
  013DE6  cd21             int 0x21
  013DE8  c9               leave
  013DE9  ca0400           retf 4
