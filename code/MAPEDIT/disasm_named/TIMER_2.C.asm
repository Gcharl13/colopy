; MAPEDIT.EXE named disasm — module TIMER_2.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _TIMER_SET_RATE  file 0x011BB6..0x011BCA  seg 0x105B:0x6  (TIMER_2.C.obj) ----
  011BB6  55               push bp
  011BB7  8bec             mov bp, sp
  011BB9  fa               cli
  011BBA  b036             mov al, 0x36
  011BBC  e643             out 0x43, al
  011BBE  8b4606           mov ax, word ptr [bp + 6]
  011BC1  e640             out 0x40, al
  011BC3  8ac4             mov al, ah
  011BC5  e640             out 0x40, al
  011BC7  fb               sti
  011BC8  c9               leave
  011BC9  cb               retf
