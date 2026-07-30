; MAPEDIT.EXE named disasm — module strcpy.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strcpy  file 0x0154A6..0x0154D8  seg 0x1388:0x626  (strcpy.asm.obj) ----
  0154A6  55               push bp
  0154A7  8bec             mov bp, sp
  0154A9  8bd7             mov dx, di
  0154AB  8bde             mov bx, si
  0154AD  8b7608           mov si, word ptr [bp + 8]
  0154B0  8bfe             mov di, si
  0154B2  8cd8             mov ax, ds
  0154B4  8ec0             mov es, ax
  0154B6  33c0             xor ax, ax
  0154B8  b9ffff           mov cx, 0xffff
  0154BB  f2ae             repne scasb al, byte ptr es:[di]
  0154BD  f7d1             not cx
  0154BF  8b7e06           mov di, word ptr [bp + 6]
  0154C2  8bc7             mov ax, di
  0154C4  a801             test al, 1
  0154C6  7402             je 0x154ca
  0154C8  a4               movsb byte ptr es:[di], byte ptr [si]
  0154C9  49               dec cx
  0154CA  d1e9             shr cx, 1
  0154CC  f3a5             rep movsw word ptr es:[di], word ptr [si]
  0154CE  13c9             adc cx, cx
  0154D0  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  0154D2  8bf3             mov si, bx
  0154D4  8bfa             mov di, dx
  0154D6  5d               pop bp
  0154D7  cb               retf

; ---- __fstrcpy  file 0x015C6C..0x015CA2  seg 0x1388:0xdec  (strcpy.asm.obj) ----
  015C6C  55               push bp
  015C6D  8bec             mov bp, sp
  015C6F  8bd7             mov dx, di
  015C71  8bde             mov bx, si
  015C73  1e               push ds
  015C74  c5760a           lds si, ptr [bp + 0xa]
  015C77  8bfe             mov di, si
  015C79  8cd8             mov ax, ds
  015C7B  8ec0             mov es, ax
  015C7D  33c0             xor ax, ax
  015C7F  b9ffff           mov cx, 0xffff
  015C82  f2ae             repne scasb al, byte ptr es:[di]
  015C84  f7d1             not cx
  015C86  c47e06           les di, ptr [bp + 6]
  015C89  8bc7             mov ax, di
  015C8B  a801             test al, 1
  015C8D  7402             je 0x15c91
  015C8F  a4               movsb byte ptr es:[di], byte ptr [si]
  015C90  49               dec cx
  015C91  d1e9             shr cx, 1
  015C93  f3a5             rep movsw word ptr es:[di], word ptr [si]
  015C95  13c9             adc cx, cx
  015C97  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  015C99  8bf3             mov si, bx
  015C9B  8bfa             mov di, dx
  015C9D  1f               pop ds
  015C9E  8cc2             mov dx, es
  015CA0  5d               pop bp
  015CA1  cb               retf
