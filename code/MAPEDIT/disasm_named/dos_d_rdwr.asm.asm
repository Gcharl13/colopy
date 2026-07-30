; MAPEDIT.EXE named disasm — module dos_d_rdwr.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __dos_read  file 0x015972..0x015979  seg 0x1388:0xaf2  (dos_d_rdwr.asm.obj) ----
  015972  55               push bp
  015973  8bec             mov bp, sp
  015975  b43f             mov ah, 0x3f
  015977  eb05             jmp 0x1597e

; ---- __dos_write  file 0x015979..0x0159A2  seg 0x1388:0xaf9  (dos_d_rdwr.asm.obj) ----
  015979  55               push bp
  01597A  8bec             mov bp, sp
  01597C  b440             mov ah, 0x40
  01597E  8b5e06           mov bx, word ptr [bp + 6]
  015981  8b4e0c           mov cx, word ptr [bp + 0xc]
  015984  813e9648d6d6     cmp word ptr [0x4896], 0xd6d6
  01598A  7504             jne 0x15990
  01598C  ff169848         call word ptr [0x4898]
  015990  1e               push ds
  015991  c55608           lds dx, ptr [bp + 8]
  015994  cd21             int 0x21
  015996  1f               pop ds
  015997  7205             jb 0x1599e
  015999  8b5e0e           mov bx, word ptr [bp + 0xe]
  01599C  8907             mov word ptr [bx], ax
  01599E  e91f07           jmp 0x160c0
  0159A1  00               .byte 0x00
