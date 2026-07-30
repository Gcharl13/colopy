; MAPEDIT.EXE named disasm — module lmul.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __aFulmul  file 0x015A3C..0x015A6E  seg 0x1388:0xbbc  (lmul.asm.obj) ----
  015A3C  55               push bp
  015A3D  8bec             mov bp, sp
  015A3F  8b4608           mov ax, word ptr [bp + 8]
  015A42  8b4e0c           mov cx, word ptr [bp + 0xc]
  015A45  0bc8             or cx, ax
  015A47  8b4e0a           mov cx, word ptr [bp + 0xa]
  015A4A  7509             jne 0x15a55
  015A4C  8b4606           mov ax, word ptr [bp + 6]
  015A4F  f7e1             mul cx
  015A51  5d               pop bp
  015A52  ca0800           retf 8
  015A55  53               push bx
  015A56  f7e1             mul cx
  015A58  8bd8             mov bx, ax
  015A5A  8b4606           mov ax, word ptr [bp + 6]
  015A5D  f7660c           mul word ptr [bp + 0xc]
  015A60  03d8             add bx, ax
  015A62  8b4606           mov ax, word ptr [bp + 6]
  015A65  f7e1             mul cx
  015A67  03d3             add dx, bx
  015A69  5b               pop bx
  015A6A  5d               pop bp
  015A6B  ca0800           retf 8
