; MAPEDIT.EXE named disasm — module dos_unlink.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _unlink  file 0x015926..0x015934  seg 0x1388:0xaa6  (dos_unlink.asm.obj) ----
  015926  55               push bp
  015927  8bec             mov bp, sp
  015929  8b5606           mov dx, word ptr [bp + 6]
  01592C  b441             mov ah, 0x41
  01592E  cd21             int 0x21
  015930  e98507           jmp 0x160b8
  015933  00               .byte 0x00
