; MAPEDIT.EXE named disasm — module font_4.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @font_string_width  file 0x00ECC2..0x00ECD6  seg 0xD6C:0x2  (font_4.c.obj) ----
  00ECC2  c8020000         enter 2, 0
  00ECC6  50               push ax
  00ECC7  57               push di
  00ECC8  56               push si
  00ECC9  c57606           lds si, ptr [bp + 6]
  00ECCC  c746fe0000       mov word ptr [bp - 2], 0
  00ECD1  803c00           cmp byte ptr [si], 0
  00ECD4  7426             je 0xecfc
