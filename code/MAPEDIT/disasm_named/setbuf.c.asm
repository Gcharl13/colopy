; MAPEDIT.EXE named disasm — module setbuf.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _setbuf  file 0x01575C..0x015788  seg 0x1388:0x8dc  (setbuf.c.obj) ----
  01575C  55               push bp
  01575D  8bec             mov bp, sp
  01575F  837e0800         cmp word ptr [bp + 8], 0
  015763  750d             jne 0x15772
  015765  2bc0             sub ax, ax
  015767  50               push ax
  015768  b80400           mov ax, 4
  01576B  50               push ax
  01576C  2bc0             sub ax, ax
  01576E  50               push ax
  01576F  eb0b             jmp 0x1577c
  015771  90               nop
  015772  b80002           mov ax, 0x200
  015775  50               push ax
  015776  2bc0             sub ax, ax
  015778  50               push ax
  015779  ff7608           push word ptr [bp + 8]
  01577C  ff7606           push word ptr [bp + 6]
  01577F  9a6c208813       lcall 0x1388, 0x206c
  015784  8be5             mov sp, bp
  015786  5d               pop bp
  015787  cb               retf
