; MAPEDIT.EXE named disasm — module stricmp.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __fstricmp  file 0x015B56..0x015B9C  seg 0x1388:0xcd6  (stricmp.asm.obj) ----
  015B56  55               push bp
  015B57  8bec             mov bp, sp
  015B59  8bd6             mov dx, si
  015B5B  1e               push ds
  015B5C  c5760a           lds si, ptr [bp + 0xa]
  015B5F  c45e06           les bx, ptr [bp + 6]
  015B62  b0ff             mov al, 0xff
  015B64  0ac0             or al, al
  015B66  742d             je 0x15b95
  015B68  ac               lodsb al, byte ptr [si]
  015B69  268a27           mov ah, byte ptr es:[bx]
  015B6C  43               inc bx
  015B6D  3ae0             cmp ah, al
  015B6F  74f3             je 0x15b64
  015B71  2c41             sub al, 0x41
  015B73  3c1a             cmp al, 0x1a
  015B75  1ac9             sbb cl, cl
  015B77  80e120           and cl, 0x20
  015B7A  02c1             add al, cl
  015B7C  0441             add al, 0x41
  015B7E  86e0             xchg al, ah
  015B80  2c41             sub al, 0x41
  015B82  3c1a             cmp al, 0x1a
  015B84  1ac9             sbb cl, cl
  015B86  80e120           and cl, 0x20
  015B89  02c1             add al, cl
  015B8B  0441             add al, 0x41
  015B8D  3ac4             cmp al, ah
  015B8F  74d3             je 0x15b64
  015B91  1ac0             sbb al, al
  015B93  1cff             sbb al, 0xff
  015B95  98               cwde
  015B96  1f               pop ds
  015B97  8bf2             mov si, dx
  015B99  5d               pop bp
  015B9A  cb               retf
  015B9B  00               .byte 0x00
