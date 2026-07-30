; MAPEDIT.EXE named disasm — module HIMEM_2.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @himem_get_directory_entry  file 0x013F2A..0x013F7E  seg 0x1292:0xa  (HIMEM_2.C.obj) ----
  013F2A  57               push di
  013F2B  56               push si
  013F2C  8bf8             mov di, ax
  013F2E  beffff           mov si, 0xffff
  013F31  803efa4403       cmp byte ptr [0x44fa], 3
  013F36  751e             jne 0x13f56
  013F38  9a06009012       lcall 0x1290, 6
  013F3D  0bc0             or ax, ax
  013F3F  7537             jne 0x13f78
  013F41  6bc75a           imul ax, di, 0x5a
  013F44  0306fc44         add ax, word ptr [0x44fc]
  013F48  8b16fe44         mov dx, word ptr [0x44fe]
  013F4C  a3564b           mov word ptr [0x4b56], ax
  013F4F  8916584b         mov word ptr [0x4b58], dx
  013F53  eb21             jmp 0x13f76
  013F55  90               nop
  013F56  1e               push ds
  013F57  688e64           push 0x648e
  013F5A  6a00             push 0
  013F5C  b95a00           mov cx, 0x5a
  013F5F  f7e9             imul cx
  013F61  52               push dx
  013F62  50               push ax
  013F63  ff360045         push word ptr [0x4500]
  013F67  6a00             push 0
  013F69  51               push cx
  013F6A  9a04004313       lcall 0x1343, 4
  013F6F  83c410           add sp, 0x10
  013F72  0bc0             or ax, ax
  013F74  7502             jne 0x13f78
  013F76  2bf6             sub si, si
  013F78  8bc6             mov ax, si
  013F7A  5e               pop si
  013F7B  5f               pop di
  013F7C  cb               retf
  013F7D  90               nop
