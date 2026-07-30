; MAPEDIT.EXE named disasm — module fsetpos.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _fsetpos  file 0x0156FE..0x015718  seg 0x1388:0x87e  (fsetpos.c.obj) ----
  0156FE  55               push bp
  0156FF  8bec             mov bp, sp
  015701  2bc0             sub ax, ax
  015703  50               push ax
  015704  8b5e08           mov bx, word ptr [bp + 8]
  015707  ff7702           push word ptr [bx + 2]
  01570A  ff37             push word ptr [bx]
  01570C  ff7606           push word ptr [bp + 6]
  01570F  9afe078813       lcall 0x1388, 0x7fe
  015714  8be5             mov sp, bp
  015716  5d               pop bp
  015717  cb               retf
