; MAPEDIT.EXE named disasm — module buffer_4.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_rect_copy  file 0x00DAC0..0x00DBB4  seg 0xC4C:0x0  (buffer_4.c.obj) ----
  00DAC0  c80e0000         enter 0xe, 0
  00DAC4  53               push bx
  00DAC5  52               push dx
  00DAC6  50               push ax
  00DAC7  57               push di
  00DAC8  56               push si
  00DAC9  8bc3             mov ax, bx
  00DACB  2b5e12           sub bx, word ptr [bp + 0x12]
  00DACE  f7db             neg bx
  00DAD0  895ef6           mov word ptr [bp - 0xa], bx
  00DAD3  2b460a           sub ax, word ptr [bp + 0xa]
  00DAD6  f7d8             neg ax
  00DAD8  8946f2           mov word ptr [bp - 0xe], ax
  00DADB  8b4616           mov ax, word ptr [bp + 0x16]
  00DADE  0b4614           or ax, word ptr [bp + 0x14]
  00DAE1  740f             je 0xdaf2
  00DAE3  8b460e           mov ax, word ptr [bp + 0xe]
  00DAE6  0b460c           or ax, word ptr [bp + 0xc]
  00DAE9  7407             je 0xdaf2
  00DAEB  c746f40100       mov word ptr [bp - 0xc], 1
  00DAF0  eb05             jmp 0xdaf7
  00DAF2  c746f40000       mov word ptr [bp - 0xc], 0
  00DAF7  837ef400         cmp word ptr [bp - 0xc], 0
  00DAFB  7503             jne 0xdb00
  00DAFD  e9ab00           jmp 0xdbab
  00DB00  8d5e10           lea bx, [bp + 0x10]
  00DB03  8b46ec           mov ax, word ptr [bp - 0x14]
  00DB06  8b56ee           mov dx, word ptr [bp - 0x12]
  00DB09  9a0000910c       lcall 0xc91, 0
  00DB0E  52               push dx
  00DB0F  50               push ax
  00DB10  9a02004f10       lcall 0x104f, 2
  00DB15  8946fc           mov word ptr [bp - 4], ax
  00DB18  8956fe           mov word ptr [bp - 2], dx
  00DB1B  8d5e08           lea bx, [bp + 8]
  00DB1E  8b46ec           mov ax, word ptr [bp - 0x14]
  00DB21  8b56ee           mov dx, word ptr [bp - 0x12]
  00DB24  9a0000910c       lcall 0xc91, 0
  00DB29  52               push dx
  00DB2A  50               push ax
  00DB2B  9a02004f10       lcall 0x104f, 2
  00DB30  8946f8           mov word ptr [bp - 8], ax
  00DB33  8956fa           mov word ptr [bp - 6], dx
  00DB36  1e               push ds
  00DB37  c47ef8           les di, ptr [bp - 8]
  00DB3A  c576fc           lds si, ptr [bp - 4]
  00DB3D  8b4606           mov ax, word ptr [bp + 6]
  00DB40  0bc0             or ax, ax
  00DB42  7502             jne 0xdb46
  00DB44  eb64             jmp 0xdbaa
  00DB46  8b56f0           mov dx, word ptr [bp - 0x10]
  00DB49  8b5ef6           mov bx, word ptr [bp - 0xa]
  00DB4C  d1ea             shr dx, 1
  00DB4E  7330             jae 0xdb80
  00DB50  0bd2             or dx, dx
  00DB52  7404             je 0xdb58
  00DB54  8bca             mov cx, dx
  00DB56  f3a5             rep movsw word ptr es:[di], word ptr [si]
  00DB58  a4               movsb byte ptr es:[di], byte ptr [si]
  00DB59  03f3             add si, bx
  00DB5B  790c             jns 0xdb69
  00DB5D  81ee0080         sub si, 0x8000
  00DB61  8cd9             mov cx, ds
  00DB63  81c10008         add cx, 0x800
  00DB67  8ed9             mov ds, cx
  00DB69  037ef2           add di, word ptr [bp - 0xe]
  00DB6C  790c             jns 0xdb7a
  00DB6E  81ef0080         sub di, 0x8000
  00DB72  8cc1             mov cx, es
  00DB74  81c10008         add cx, 0x800
  00DB78  8ec1             mov es, cx
  00DB7A  48               dec ax
  00DB7B  75d3             jne 0xdb50
  00DB7D  eb2b             jmp 0xdbaa
  00DB7F  90               nop
  00DB80  7428             je 0xdbaa
  00DB82  8bca             mov cx, dx
  00DB84  f3a5             rep movsw word ptr es:[di], word ptr [si]
  00DB86  03f3             add si, bx
  00DB88  790c             jns 0xdb96
  00DB8A  81ee0080         sub si, 0x8000
  00DB8E  8cd9             mov cx, ds
  00DB90  81c10008         add cx, 0x800
  00DB94  8ed9             mov ds, cx
  00DB96  037ef2           add di, word ptr [bp - 0xe]
  00DB99  790c             jns 0xdba7
  00DB9B  81ef0080         sub di, 0x8000
  00DB9F  8cc1             mov cx, es
  00DBA1  81c10008         add cx, 0x800
  00DBA5  8ec1             mov es, cx
  00DBA7  48               dec ax
  00DBA8  75d8             jne 0xdb82
  00DBAA  1f               pop ds
  00DBAB  8b46f4           mov ax, word ptr [bp - 0xc]
  00DBAE  5e               pop si
  00DBAF  5f               pop di
  00DBB0  c9               leave
  00DBB1  ca1200           retf 0x12
