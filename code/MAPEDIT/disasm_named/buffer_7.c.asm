; MAPEDIT.EXE named disasm — module buffer_7.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_put  file 0x00DD64..0x00DD80  seg 0xC76:0x4  (buffer_7.c.obj) ----
  00DD64  55               push bp
  00DD65  8bec             mov bp, sp
  00DD67  57               push di
  00DD68  8bfb             mov di, bx
  00DD6A  8d5e06           lea bx, [bp + 6]
  00DD6D  9a0000910c       lcall 0xc91, 0
  00DD72  8ec2             mov es, dx
  00DD74  8bd8             mov bx, ax
  00DD76  8bc7             mov ax, di
  00DD78  268807           mov byte ptr es:[bx], al
  00DD7B  5f               pop di
  00DD7C  c9               leave
  00DD7D  ca0800           retf 8
