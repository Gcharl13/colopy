; MAPEDIT.EXE named disasm — module dos_close.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _close  file 0x016A32..0x016A52  seg 0x1388:0x1bb2  (dos_close.asm.obj) ----
  016A32  55               push bp
  016A33  8bec             mov bp, sp
  016A35  8b5e06           mov bx, word ptr [bp + 6]
  016A38  3b1e7545         cmp bx, word ptr [0x4575]
  016A3C  7206             jb 0x16a44
  016A3E  b80009           mov ax, 0x900
  016A41  f9               stc
  016A42  eb0b             jmp 0x16a4f
  016A44  b43e             mov ah, 0x3e
  016A46  cd21             int 0x21
  016A48  7205             jb 0x16a4f
  016A4A  c687774500       mov byte ptr [bx + 0x4577], 0
  016A4F  e966f6           jmp 0x160b8
