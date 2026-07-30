; MAPEDIT.EXE named disasm — module buffer_s.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_to_ems  file 0x0119DA..0x011A6E  seg 0x103D:0xa  (buffer_s.c.obj) ----
  0119DA  c80a0000         enter 0xa, 0
  0119DE  50               push ax
  0119DF  53               push bx
  0119E0  56               push si
  0119E1  8bf2             mov si, dx
  0119E3  c746fe0000       mov word ptr [bp - 2], 0
  0119E8  c746f6c800       mov word ptr [bp - 0xa], 0xc8
  0119ED  c746f84001       mov word ptr [bp - 8], 0x140
  0119F2  2bc0             sub ax, ax
  0119F4  3946f4           cmp word ptr [bp - 0xc], ax
  0119F7  7d10             jge 0x11a09
  0119F9  b80400           mov ax, 4
  0119FC  9a06014511       lcall 0x1145, 0x106
  011A01  8946f4           mov word ptr [bp - 0xc], ax
  011A04  c746fe0040       mov word ptr [bp - 2], 0x4000
  011A09  837ef400         cmp word ptr [bp - 0xc], 0
  011A0D  7c56             jl 0x11a65
  011A0F  0bf6             or si, si
  011A11  7d3d             jge 0x11a50
  011A13  8b46f4           mov ax, word ptr [bp - 0xc]
  011A16  9a0600fb12       lcall 0x12fb, 6
  011A1B  a15c44           mov ax, word ptr [0x445c]
  011A1E  8b165e44         mov dx, word ptr [0x445e]
  011A22  8b5ef2           mov bx, word ptr [bp - 0xe]
  011A25  ff7706           push word ptr [bx + 6]
  011A28  ff7704           push word ptr [bx + 4]
  011A2B  ff7702           push word ptr [bx + 2]
  011A2E  ff37             push word ptr [bx]
  011A30  52               push dx
  011A31  50               push ax
  011A32  ff76f8           push word ptr [bp - 8]
  011A35  ff76f6           push word ptr [bp - 0xa]
  011A38  ff760a           push word ptr [bp + 0xa]
  011A3B  ff7608           push word ptr [bp + 8]
  011A3E  ff7606           push word ptr [bp + 6]
  011A41  8b460c           mov ax, word ptr [bp + 0xc]
  011A44  8b560a           mov dx, word ptr [bp + 0xa]
  011A47  8bd8             mov bx, ax
  011A49  9a0000670c       lcall 0xc67, 0
  011A4E  eb0a             jmp 0x11a5a
  011A50  8bc6             mov ax, si
  011A52  8b56f4           mov dx, word ptr [bp - 0xc]
  011A55  9a0a000213       lcall 0x1302, 0xa
  011A5A  8b46fe           mov ax, word ptr [bp - 2]
  011A5D  0946f4           or word ptr [bp - 0xc], ax
  011A60  9a5e012d11       lcall 0x112d, 0x15e
  011A65  8b46f4           mov ax, word ptr [bp - 0xc]
  011A68  5e               pop si
  011A69  c9               leave
  011A6A  ca0800           retf 8
  011A6D  90               nop

; ---- @buffer_from_ems  file 0x011A6E..0x011AF2  seg 0x103D:0x9e  (buffer_s.c.obj) ----
  011A6E  c80a0000         enter 0xa, 0
  011A72  50               push ax
  011A73  53               push bx
  011A74  8bca             mov cx, dx
  011A76  c746f6c800       mov word ptr [bp - 0xa], 0xc8
  011A7B  c746f84001       mov word ptr [bp - 8], 0x140
  011A80  2bc0             sub ax, ax
  011A82  8a66f5           mov ah, byte ptr [bp - 0xb]
  011A85  250040           and ax, 0x4000
  011A88  8946fe           mov word ptr [bp - 2], ax
  011A8B  8066f5bf         and byte ptr [bp - 0xb], 0xbf
  011A8F  0bc9             or cx, cx
  011A91  7d3d             jge 0x11ad0
  011A93  8b46f4           mov ax, word ptr [bp - 0xc]
  011A96  9a0600fb12       lcall 0x12fb, 6
  011A9B  a15c44           mov ax, word ptr [0x445c]
  011A9E  8b165e44         mov dx, word ptr [0x445e]
  011AA2  52               push dx
  011AA3  50               push ax
  011AA4  ff76f8           push word ptr [bp - 8]
  011AA7  ff76f6           push word ptr [bp - 0xa]
  011AAA  8b5ef2           mov bx, word ptr [bp - 0xe]
  011AAD  ff7706           push word ptr [bx + 6]
  011AB0  ff7704           push word ptr [bx + 4]
  011AB3  ff7702           push word ptr [bx + 2]
  011AB6  ff37             push word ptr [bx]
  011AB8  ff760a           push word ptr [bp + 0xa]
  011ABB  ff7608           push word ptr [bp + 8]
  011ABE  ff7606           push word ptr [bp + 6]
  011AC1  8b460c           mov ax, word ptr [bp + 0xc]
  011AC4  8b560a           mov dx, word ptr [bp + 0xa]
  011AC7  8bd8             mov bx, ax
  011AC9  9a0000670c       lcall 0xc67, 0
  011ACE  eb08             jmp 0x11ad8
  011AD0  8b46f4           mov ax, word ptr [bp - 0xc]
  011AD3  9a0a000213       lcall 0x1302, 0xa
  011AD8  837efe00         cmp word ptr [bp - 2], 0
  011ADC  7408             je 0x11ae6
  011ADE  8b46f4           mov ax, word ptr [bp - 0xc]
  011AE1  9aa0004511       lcall 0x1145, 0xa0
  011AE6  9a5e012d11       lcall 0x112d, 0x15e
  011AEB  8b46f4           mov ax, word ptr [bp - 0xc]
  011AEE  c9               leave
  011AEF  ca0800           retf 8
