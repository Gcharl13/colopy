; MAPEDIT.EXE named disasm — module HSPOT_7.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @hspot_which  file 0x00D0A2..0x00D0F4  seg 0xBAA:0x2  (HSPOT_7.C.obj) ----
  00D0A2  55               push bp
  00D0A3  8bec             mov bp, sp
  00D0A5  53               push bx
  00D0A6  52               push dx
  00D0A7  50               push ax
  00D0A8  b80100           mov ax, 1
  00D0AB  bb0a53           mov bx, 0x530a
  00D0AE  83c310           add bx, 0x10
  00D0B1  3b061607         cmp ax, word ptr [0x716]
  00D0B5  7739             ja 0xd0f0
  00D0B7  8b4f0e           mov cx, word ptr [bx + 0xe]
  00D0BA  0bc9             or cx, cx
  00D0BC  742b             je 0xd0e9
  00D0BE  8b4efa           mov cx, word ptr [bp - 6]
  00D0C1  8b17             mov dx, word ptr [bx]
  00D0C3  3bca             cmp cx, dx
  00D0C5  7222             jb 0xd0e9
  00D0C7  8b5704           mov dx, word ptr [bx + 4]
  00D0CA  3bca             cmp cx, dx
  00D0CC  771b             ja 0xd0e9
  00D0CE  8b4efc           mov cx, word ptr [bp - 4]
  00D0D1  8b5702           mov dx, word ptr [bx + 2]
  00D0D4  3bca             cmp cx, dx
  00D0D6  7211             jb 0xd0e9
  00D0D8  8b5706           mov dx, word ptr [bx + 6]
  00D0DB  3bca             cmp cx, dx
  00D0DD  770a             ja 0xd0e9
  00D0DF  8b4efe           mov cx, word ptr [bp - 2]
  00D0E2  8b570c           mov dx, word ptr [bx + 0xc]
  00D0E5  3bca             cmp cx, dx
  00D0E7  7409             je 0xd0f2
  00D0E9  40               inc ax
  00D0EA  83c310           add bx, 0x10
  00D0ED  ebc2             jmp 0xd0b1
  00D0EF  90               nop
  00D0F0  33c0             xor ax, ax
  00D0F2  c9               leave
  00D0F3  cb               retf
