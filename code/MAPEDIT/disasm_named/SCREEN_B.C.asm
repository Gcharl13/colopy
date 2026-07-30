; MAPEDIT.EXE named disasm — module SCREEN_B.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @screen_dominant_mode  file 0x00D9CA..0x00D9EA  seg 0xC3C:0xa  (SCREEN_B.C.obj) ----
  00D9CA  8bc8             mov cx, ax
  00D9CC  bb4000           mov bx, 0x40
  00D9CF  8ec3             mov es, bx
  00D9D1  bb1000           mov bx, 0x10
  00D9D4  268027cf         and byte ptr es:[bx], 0xcf
  00D9D8  83f907           cmp cx, 7
  00D9DB  7507             jne 0xd9e4
  00D9DD  b030             mov al, 0x30
  00D9DF  260807           or byte ptr es:[bx], al
  00D9E2  cb               retf
  00D9E3  90               nop
  00D9E4  b020             mov al, 0x20
  00D9E6  260807           or byte ptr es:[bx], al
  00D9E9  cb               retf
