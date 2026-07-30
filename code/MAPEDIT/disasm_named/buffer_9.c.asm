; MAPEDIT.EXE named disasm — module buffer_9.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_hline  file 0x00DD96..0x00DE00  seg 0xC79:0x6  (buffer_9.c.obj) ----
  00DD96  c8060000         enter 6, 0
  00DD9A  53               push bx
  00DD9B  52               push dx
  00DD9C  50               push ax
  00DD9D  57               push di
  00DD9E  0bdb             or bx, bx
  00DDA0  7c59             jl 0xddfb
  00DDA2  8b4608           mov ax, word ptr [bp + 8]
  00DDA5  3bd8             cmp bx, ax
  00DDA7  7d52             jge 0xddfb
  00DDA9  8b46f4           mov ax, word ptr [bp - 0xc]
  00DDAC  0bc0             or ax, ax
  00DDAE  7d02             jge 0xddb2
  00DDB0  2bc0             sub ax, ax
  00DDB2  8946f4           mov word ptr [bp - 0xc], ax
  00DDB5  8b460a           mov ax, word ptr [bp + 0xa]
  00DDB8  48               dec ax
  00DDB9  3bc2             cmp ax, dx
  00DDBB  7e02             jle 0xddbf
  00DDBD  8bc2             mov ax, dx
  00DDBF  8946f6           mov word ptr [bp - 0xa], ax
  00DDC2  8b460e           mov ax, word ptr [bp + 0xe]
  00DDC5  8946fa           mov word ptr [bp - 6], ax
  00DDC8  8b460c           mov ax, word ptr [bp + 0xc]
  00DDCB  8946fc           mov word ptr [bp - 4], ax
  00DDCE  8b460a           mov ax, word ptr [bp + 0xa]
  00DDD1  8946fe           mov word ptr [bp - 2], ax
  00DDD4  06               push es
  00DDD5  8b46fa           mov ax, word ptr [bp - 6]
  00DDD8  8ec0             mov es, ax
  00DDDA  8b46fe           mov ax, word ptr [bp - 2]
  00DDDD  8b5ef8           mov bx, word ptr [bp - 8]
  00DDE0  f7e3             mul bx
  00DDE2  0346f4           add ax, word ptr [bp - 0xc]
  00DDE5  8bf8             mov di, ax
  00DDE7  037efc           add di, word ptr [bp - 4]
  00DDEA  8b4ef6           mov cx, word ptr [bp - 0xa]
  00DDED  2b4ef4           sub cx, word ptr [bp - 0xc]
  00DDF0  41               inc cx
  00DDF1  8a4606           mov al, byte ptr [bp + 6]
  00DDF4  268805           mov byte ptr es:[di], al
  00DDF7  47               inc di
  00DDF8  e0fa             loopne 0xddf4
  00DDFA  07               pop es
  00DDFB  5f               pop di
  00DDFC  c9               leave
  00DDFD  ca0a00           retf 0xa
