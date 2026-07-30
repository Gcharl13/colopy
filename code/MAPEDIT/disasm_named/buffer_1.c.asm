; MAPEDIT.EXE named disasm — module buffer_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_init  file 0x00D9EA..0x00DA24  seg 0xC3E:0xa  (buffer_1.c.obj) ----
  00D9EA  55               push bp
  00D9EB  8bec             mov bp, sp
  00D9ED  52               push dx
  00D9EE  50               push ax
  00D9EF  53               push bx
  00D9F0  56               push si
  00D9F1  8bc8             mov cx, ax
  00D9F3  8bc2             mov ax, dx
  00D9F5  f7e1             mul cx
  00D9F7  8bf3             mov si, bx
  00D9F9  9ae202c90c       lcall 0xcc9, 0x2e2
  00D9FE  894404           mov word ptr [si + 4], ax
  00DA01  895406           mov word ptr [si + 6], dx
  00DA04  8bc2             mov ax, dx
  00DA06  0b4404           or ax, word ptr [si + 4]
  00DA09  7505             jne 0xda10
  00DA0B  2bc0             sub ax, ax
  00DA0D  5e               pop si
  00DA0E  c9               leave
  00DA0F  cb               retf
  00DA10  8b46fc           mov ax, word ptr [bp - 4]
  00DA13  8b5efa           mov bx, word ptr [bp - 6]
  00DA16  894702           mov word ptr [bx + 2], ax
  00DA19  8b46fe           mov ax, word ptr [bp - 2]
  00DA1C  8907             mov word ptr [bx], ax
  00DA1E  b8ffff           mov ax, 0xffff
  00DA21  5e               pop si
  00DA22  c9               leave
  00DA23  cb               retf

; ---- @buffer_init_name  file 0x00DA24..0x00DA66  seg 0xC3E:0x44  (buffer_1.c.obj) ----
  00DA24  55               push bp
  00DA25  8bec             mov bp, sp
  00DA27  52               push dx
  00DA28  50               push ax
  00DA29  53               push bx
  00DA2A  56               push si
  00DA2B  1e               push ds
  00DA2C  ff7606           push word ptr [bp + 6]
  00DA2F  8bc8             mov cx, ax
  00DA31  8bc2             mov ax, dx
  00DA33  f7e1             mul cx
  00DA35  8bf3             mov si, bx
  00DA37  9a3601c90c       lcall 0xcc9, 0x136
  00DA3C  894404           mov word ptr [si + 4], ax
  00DA3F  895406           mov word ptr [si + 6], dx
  00DA42  8bc2             mov ax, dx
  00DA44  0b4404           or ax, word ptr [si + 4]
  00DA47  7507             jne 0xda50
  00DA49  2bc0             sub ax, ax
  00DA4B  5e               pop si
  00DA4C  c9               leave
  00DA4D  ca0200           retf 2
  00DA50  8b46fc           mov ax, word ptr [bp - 4]
  00DA53  8b5efa           mov bx, word ptr [bp - 6]
  00DA56  894702           mov word ptr [bx + 2], ax
  00DA59  8b46fe           mov ax, word ptr [bp - 2]
  00DA5C  8907             mov word ptr [bx], ax
  00DA5E  b8ffff           mov ax, 0xffff
  00DA61  5e               pop si
  00DA62  c9               leave
  00DA63  ca0200           retf 2
