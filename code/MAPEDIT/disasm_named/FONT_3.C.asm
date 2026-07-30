; MAPEDIT.EXE named disasm — module FONT_3.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @font_set_colors  file 0x00ECA6..0x00ECC2  seg 0xD6A:0x6  (FONT_3.C.obj) ----
  00ECA6  55               push bp
  00ECA7  8bec             mov bp, sp
  00ECA9  8bc8             mov cx, ax
  00ECAB  880eaa3a         mov byte ptr [0x3aaa], cl
  00ECAF  8816ab3a         mov byte ptr [0x3aab], dl
  00ECB3  8bc3             mov ax, bx
  00ECB5  a2ac3a           mov byte ptr [0x3aac], al
  00ECB8  8a4606           mov al, byte ptr [bp + 6]
  00ECBB  a2ad3a           mov byte ptr [0x3aad], al
  00ECBE  c9               leave
  00ECBF  ca0200           retf 2
