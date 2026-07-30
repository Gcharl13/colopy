; MAPEDIT.EXE named disasm — module fgetpos.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _fgetpos  file 0x0155E2..0x01560A  seg 0x1388:0x762  (fgetpos.c.obj) ----
  0155E2  55               push bp
  0155E3  8bec             mov bp, sp
  0155E5  ff7606           push word ptr [bp + 6]
  0155E8  9af61e8813       lcall 0x1388, 0x1ef6
  0155ED  8be5             mov sp, bp
  0155EF  8b5e08           mov bx, word ptr [bp + 8]
  0155F2  8907             mov word ptr [bx], ax
  0155F4  895702           mov word ptr [bx + 2], dx
  0155F7  3dffff           cmp ax, 0xffff
  0155FA  7504             jne 0x15600
  0155FC  3bd0             cmp dx, ax
  0155FE  7404             je 0x15604
  015600  2bc0             sub ax, ax
  015602  eb03             jmp 0x15607
  015604  b8ffff           mov ax, 0xffff
  015607  5d               pop bp
  015608  cb               retf
  015609  90               nop
