; MAPEDIT.EXE named disasm — module strlen.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strlen  file 0x015504..0x015520  seg 0x1388:0x684  (strlen.asm.obj) ----
  015504  55               push bp
  015505  8bec             mov bp, sp
  015507  8bd7             mov dx, di
  015509  8cd8             mov ax, ds
  01550B  8ec0             mov es, ax
  01550D  8b7e06           mov di, word ptr [bp + 6]
  015510  33c0             xor ax, ax
  015512  b9ffff           mov cx, 0xffff
  015515  f2ae             repne scasb al, byte ptr es:[di]
  015517  f7d1             not cx
  015519  49               dec cx
  01551A  91               xchg cx, ax
  01551B  8bfa             mov di, dx
  01551D  5d               pop bp
  01551E  cb               retf
  01551F  00               .byte 0x00

; ---- __fstrlen  file 0x015C54..0x015C6C  seg 0x1388:0xdd4  (strlen.asm.obj) ----
  015C54  55               push bp
  015C55  8bec             mov bp, sp
  015C57  8bd7             mov dx, di
  015C59  c47e06           les di, ptr [bp + 6]
  015C5C  33c0             xor ax, ax
  015C5E  b9ffff           mov cx, 0xffff
  015C61  f2ae             repne scasb al, byte ptr es:[di]
  015C63  f7d1             not cx
  015C65  49               dec cx
  015C66  91               xchg cx, ax
  015C67  8bfa             mov di, dx
  015C69  5d               pop bp
  015C6A  cb               retf
  015C6B  00               .byte 0x00
