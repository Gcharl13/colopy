; MAPEDIT.EXE named disasm — module itoa.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _itoa  file 0x0155BC..0x0155D8  seg 0x1388:0x73c  (itoa.asm.obj) ----
  0155BC  55               push bp
  0155BD  8bec             mov bp, sp
  0155BF  56               push si
  0155C0  57               push di
  0155C1  b301             mov bl, 1
  0155C3  8b4e0a           mov cx, word ptr [bp + 0xa]
  0155C6  8b4606           mov ax, word ptr [bp + 6]
  0155C9  33d2             xor dx, dx
  0155CB  83f90a           cmp cx, 0xa
  0155CE  7501             jne 0x155d1
  0155D0  99               cdq
  0155D1  8b7e08           mov di, word ptr [bp + 8]
  0155D4  e90d1a           jmp 0x16fe4
  0155D7  00               .byte 0x00
