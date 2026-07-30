; MAPEDIT.EXE named disasm — module strcmp.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strcmp  file 0x0154D8..0x015504  seg 0x1388:0x658  (strcmp.asm.obj) ----
  0154D8  55               push bp
  0154D9  8bec             mov bp, sp
  0154DB  8bd7             mov dx, di
  0154DD  8bde             mov bx, si
  0154DF  8cd8             mov ax, ds
  0154E1  8ec0             mov es, ax
  0154E3  8b7606           mov si, word ptr [bp + 6]
  0154E6  8b7e08           mov di, word ptr [bp + 8]
  0154E9  33c0             xor ax, ax
  0154EB  b9ffff           mov cx, 0xffff
  0154EE  f2ae             repne scasb al, byte ptr es:[di]
  0154F0  f7d1             not cx
  0154F2  2bf9             sub di, cx
  0154F4  f3a6             repe cmpsb byte ptr [si], byte ptr es:[di]
  0154F6  7405             je 0x154fd
  0154F8  1bc0             sbb ax, ax
  0154FA  1dffff           sbb ax, 0xffff
  0154FD  8bf3             mov si, bx
  0154FF  8bfa             mov di, dx
  015501  5d               pop bp
  015502  cb               retf
  015503  00               .byte 0x00
