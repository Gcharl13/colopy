; MAPEDIT.EXE named disasm — module buffer_i.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_pointer  file 0x00DF10..0x00DF54  seg 0xC91:0x0  (buffer_i.c.obj) ----
  00DF10  c8060000         enter 6, 0
  00DF14  52               push dx
  00DF15  50               push ax
  00DF16  53               push bx
  00DF17  8b4704           mov ax, word ptr [bx + 4]
  00DF1A  8b5706           mov dx, word ptr [bx + 6]
  00DF1D  8946fc           mov word ptr [bp - 4], ax
  00DF20  8956fe           mov word ptr [bp - 2], dx
  00DF23  8b4702           mov ax, word ptr [bx + 2]
  00DF26  8946fa           mov word ptr [bp - 6], ax
  00DF29  c44efc           les cx, ptr [bp - 4]
  00DF2C  8cc3             mov bx, es
  00DF2E  8b46fa           mov ax, word ptr [bp - 6]
  00DF31  f766f8           mul word ptr [bp - 8]
  00DF34  0346f6           add ax, word ptr [bp - 0xa]
  00DF37  83d200           adc dx, 0
  00DF3A  c1e20c           shl dx, 0xc
  00DF3D  03d3             add dx, bx
  00DF3F  03c1             add ax, cx
  00DF41  7304             jae 0xdf47
  00DF43  81c20010         add dx, 0x1000
  00DF47  8bd8             mov bx, ax
  00DF49  c1eb04           shr bx, 4
  00DF4C  03d3             add dx, bx
  00DF4E  250f00           and ax, 0xf
  00DF51  c9               leave
  00DF52  cb               retf
  00DF53  90               nop

; ---- @buffer_conform  file 0x00DF54..0x00DFDE  seg 0xC91:0x44  (buffer_i.c.obj) ----
  00DF54  c8040000         enter 4, 0
  00DF58  52               push dx
  00DF59  50               push ax
  00DF5A  53               push bx
  00DF5B  57               push di
  00DF5C  56               push si
  00DF5D  8bd8             mov bx, ax
  00DF5F  833f00           cmp word ptr [bx], 0
  00DF62  7d0b             jge 0xdf6f
  00DF64  8b0f             mov cx, word ptr [bx]
  00DF66  8b7608           mov si, word ptr [bp + 8]
  00DF69  010c             add word ptr [si], cx
  00DF6B  c7070000         mov word ptr [bx], 0
  00DF6F  8b5efa           mov bx, word ptr [bp - 6]
  00DF72  833f00           cmp word ptr [bx], 0
  00DF75  7d0b             jge 0xdf82
  00DF77  8b07             mov ax, word ptr [bx]
  00DF79  8b7606           mov si, word ptr [bp + 6]
  00DF7C  0104             add word ptr [si], ax
  00DF7E  c7070000         mov word ptr [bx], 0
  00DF82  8b5e08           mov bx, word ptr [bp + 8]
  00DF85  8b07             mov ax, word ptr [bx]
  00DF87  8b76f8           mov si, word ptr [bp - 8]
  00DF8A  0304             add ax, word ptr [si]
  00DF8C  48               dec ax
  00DF8D  8b7ef6           mov di, word ptr [bp - 0xa]
  00DF90  8b4d02           mov cx, word ptr [di + 2]
  00DF93  49               dec cx
  00DF94  3bc1             cmp ax, cx
  00DF96  7e02             jle 0xdf9a
  00DF98  8bc1             mov ax, cx
  00DF9A  8b5e06           mov bx, word ptr [bp + 6]
  00DF9D  8b0f             mov cx, word ptr [bx]
  00DF9F  8b5efa           mov bx, word ptr [bp - 6]
  00DFA2  030f             add cx, word ptr [bx]
  00DFA4  49               dec cx
  00DFA5  8b15             mov dx, word ptr [di]
  00DFA7  4a               dec dx
  00DFA8  3bca             cmp cx, dx
  00DFAA  7e02             jle 0xdfae
  00DFAC  8bca             mov cx, dx
  00DFAE  894efc           mov word ptr [bp - 4], cx
  00DFB1  2b04             sub ax, word ptr [si]
  00DFB3  40               inc ax
  00DFB4  8b7608           mov si, word ptr [bp + 8]
  00DFB7  8904             mov word ptr [si], ax
  00DFB9  8b46fc           mov ax, word ptr [bp - 4]
  00DFBC  2b07             sub ax, word ptr [bx]
  00DFBE  40               inc ax
  00DFBF  8b5e06           mov bx, word ptr [bp + 6]
  00DFC2  8907             mov word ptr [bx], ax
  00DFC4  833c00           cmp word ptr [si], 0
  00DFC7  7e04             jle 0xdfcd
  00DFC9  0bc0             or ax, ax
  00DFCB  7f09             jg 0xdfd6
  00DFCD  b80100           mov ax, 1
  00DFD0  5e               pop si
  00DFD1  5f               pop di
  00DFD2  c9               leave
  00DFD3  ca0400           retf 4
  00DFD6  2bc0             sub ax, ax
  00DFD8  5e               pop si
  00DFD9  5f               pop di
  00DFDA  c9               leave
  00DFDB  ca0400           retf 4
