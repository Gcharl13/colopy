; MAPEDIT.EXE named disasm — module SPRITE_H.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @sprite_color_translate  file 0x011C96..0x011D6C  seg 0x1069:0x6  (SPRITE_H.C.obj) ----
  011C96  c80a0000         enter 0xa, 0
  011C9A  57               push di
  011C9B  56               push si
  011C9C  8b4606           mov ax, word ptr [bp + 6]
  011C9F  8b5608           mov dx, word ptr [bp + 8]
  011CA2  050500           add ax, 5
  011CA5  8946f8           mov word ptr [bp - 8], ax
  011CA8  8956fa           mov word ptr [bp - 6], dx
  011CAB  c746f60000       mov word ptr [bp - 0xa], 0
  011CB0  e98500           jmp 0x11d38
  011CB3  90               nop
  011CB4  8bf0             mov si, ax
  011CB6  d1e6             shl si, 1
  011CB8  03f0             add si, ax
  011CBA  c1e602           shl si, 2
  011CBD  268b4042         mov ax, word ptr es:[bx + si + 0x42]
  011CC1  268b5044         mov dx, word ptr es:[bx + si + 0x44]
  011CC5  8946fc           mov word ptr [bp - 4], ax
  011CC8  8956fe           mov word ptr [bp - 2], dx
  011CCB  0bd0             or dx, ax
  011CCD  7478             je 0x11d47
  011CCF  1e               push ds
  011CD0  c47ef8           les di, ptr [bp - 8]
  011CD3  c576fc           lds si, ptr [bp - 4]
  011CD6  33db             xor bx, bx
  011CD8  ac               lodsb al, byte ptr [si]
  011CD9  3cfc             cmp al, 0xfc
  011CDB  7457             je 0x11d34
  011CDD  3cff             cmp al, 0xff
  011CDF  74f7             je 0x11cd8
  011CE1  3cfd             cmp al, 0xfd
  011CE3  7403             je 0x11ce8
  011CE5  eb21             jmp 0x11d08
  011CE7  90               nop
  011CE8  ac               lodsb al, byte ptr [si]
  011CE9  3cff             cmp al, 0xff
  011CEB  74eb             je 0x11cd8
  011CED  8a04             mov al, byte ptr [si]
  011CEF  3cfd             cmp al, 0xfd
  011CF1  7412             je 0x11d05
  011CF3  32ff             xor bh, bh
  011CF5  8ad8             mov bl, al
  011CF7  d1e3             shl bx, 1
  011CF9  8bcb             mov cx, bx
  011CFB  d1e3             shl bx, 1
  011CFD  03d9             add bx, cx
  011CFF  268a01           mov al, byte ptr es:[bx + di]
  011D02  3e8804           mov byte ptr ds:[si], al
  011D05  46               inc si
  011D06  ebe0             jmp 0x11ce8
  011D08  8a04             mov al, byte ptr [si]
  011D0A  3cff             cmp al, 0xff
  011D0C  7422             je 0x11d30
  011D0E  3cfe             cmp al, 0xfe
  011D10  7505             jne 0x11d17
  011D12  83c602           add si, 2
  011D15  8a04             mov al, byte ptr [si]
  011D17  3cfd             cmp al, 0xfd
  011D19  7411             je 0x11d2c
  011D1B  32ff             xor bh, bh
  011D1D  8ad8             mov bl, al
  011D1F  d1e3             shl bx, 1
  011D21  8bcb             mov cx, bx
  011D23  d1e3             shl bx, 1
  011D25  03d9             add bx, cx
  011D27  268a01           mov al, byte ptr es:[bx + di]
  011D2A  8804             mov byte ptr [si], al
  011D2C  46               inc si
  011D2D  ebd9             jmp 0x11d08
  011D2F  90               nop
  011D30  46               inc si
  011D31  eba5             jmp 0x11cd8
  011D33  90               nop
  011D34  1f               pop ds
  011D35  ff46f6           inc word ptr [bp - 0xa]
  011D38  8b46f6           mov ax, word ptr [bp - 0xa]
  011D3B  c45e0a           les bx, ptr [bp + 0xa]
  011D3E  26394704         cmp word ptr es:[bx + 4], ax
  011D42  7e03             jle 0x11d47
  011D44  e96dff           jmp 0x11cb4
  011D47  5e               pop si
  011D48  5f               pop di
  011D49  c9               leave
  011D4A  ca0800           retf 8
  011D4D  90               nop
  011D4E  55               push bp
  011D4F  8bec             mov bp, sp
  011D51  8b4604           mov ax, word ptr [bp + 4]
  011D54  0b4606           or ax, word ptr [bp + 6]
  011D57  7410             je 0x11d69
  011D59  8b5e08           mov bx, word ptr [bp + 8]
  011D5C  891e1044         mov word ptr [0x4410], bx
  011D60  ff5e04           lcall [bp + 4]
  011D63  c70610440000     mov word ptr [0x4410], 0
  011D69  c9               leave
  011D6A  c3               ret
  011D6B  90               nop
