; MAPEDIT.EXE named disasm — module buffer_8.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_get  file 0x00DD80..0x00DD96  seg 0xC78:0x0  (buffer_8.c.obj) ----
  00DD80  55               push bp
  00DD81  8bec             mov bp, sp
  00DD83  8d5e06           lea bx, [bp + 6]
  00DD86  9a0000910c       lcall 0xc91, 0
  00DD8B  8ec2             mov es, dx
  00DD8D  8bd8             mov bx, ax
  00DD8F  268a07           mov al, byte ptr es:[bx]
  00DD92  c9               leave
  00DD93  ca0800           retf 8
