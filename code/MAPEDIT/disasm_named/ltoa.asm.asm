; MAPEDIT.EXE named disasm — module ltoa.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _ltoa  file 0x0155D8..0x0155E2  seg 0x1388:0x758  (ltoa.asm.obj) ----
  0155D8  55               push bp
  0155D9  8bec             mov bp, sp
  0155DB  56               push si
  0155DC  57               push di
  0155DD  b301             mov bl, 1
  0155DF  e9f619           jmp 0x16fd8
