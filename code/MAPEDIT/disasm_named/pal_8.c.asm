; MAPEDIT.EXE named disasm — module pal_8.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @pal_load_2  file 0x01020A..0x010258  seg 0xEC0:0xa  (pal_8.c.obj) ----
  01020A  c8020000         enter 2, 0
  01020E  57               push di
  01020F  c746fe0100       mov word ptr [bp - 2], 1
  010214  1e               push ds
  010215  53               push bx
  010216  8d1ee83a         lea bx, [0x3ae8]
  01021A  9a04019702       lcall 0x297, 0x104
  01021F  8bf8             mov di, ax
  010221  0bff             or di, di
  010223  741e             je 0x10243
  010225  ff7608           push word ptr [bp + 8]
  010228  ff7606           push word ptr [bp + 6]
  01022B  6a00             push 0
  01022D  6a01             push 1
  01022F  b80003           mov ax, 0x300
  010232  99               cdq
  010233  8bdf             mov bx, di
  010235  9a0000ca0b       lcall 0xbca, 0
  01023A  0bd0             or dx, ax
  01023C  7405             je 0x10243
  01023E  c746fe0000       mov word ptr [bp - 2], 0
  010243  0bff             or di, di
  010245  7409             je 0x10250
  010247  57               push di
  010248  9ac2028813       lcall 0x1388, 0x2c2
  01024D  83c402           add sp, 2
  010250  8b46fe           mov ax, word ptr [bp - 2]
  010253  5f               pop di
  010254  c9               leave
  010255  ca0400           retf 4
