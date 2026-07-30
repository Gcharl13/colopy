; MAPEDIT.EXE named disasm — module dos_d_find.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __dos_findnext  file 0x015934..0x01593F  seg 0x1388:0xab4  (dos_d_find.asm.obj) ----
  015934  55               push bp
  015935  8bec             mov bp, sp
  015937  1e               push ds
  015938  b04f             mov al, 0x4f
  01593A  8b5606           mov dx, word ptr [bp + 6]
  01593D  eb09             jmp 0x15948

; ---- __dos_findfirst  file 0x01593F..0x015972  seg 0x1388:0xabf  (dos_d_find.asm.obj) ----
  01593F  55               push bp
  015940  8bec             mov bp, sp
  015942  1e               push ds
  015943  b04e             mov al, 0x4e
  015945  8b560a           mov dx, word ptr [bp + 0xa]
  015948  b42f             mov ah, 0x2f
  01594A  cd21             int 0x21
  01594C  b41a             mov ah, 0x1a
  01594E  cd21             int 0x21
  015950  3c4e             cmp al, 0x4e
  015952  7506             jne 0x1595a
  015954  8b5606           mov dx, word ptr [bp + 6]
  015957  8b4e08           mov cx, word ptr [bp + 8]
  01595A  8ae0             mov ah, al
  01595C  cd21             int 0x21
  01595E  50               push ax
  01595F  9f               lahf
  015960  50               push ax
  015961  8cc2             mov dx, es
  015963  8eda             mov ds, dx
  015965  8bd3             mov dx, bx
  015967  b41a             mov ah, 0x1a
  015969  cd21             int 0x21
  01596B  58               pop ax
  01596C  9e               sahf
  01596D  58               pop ax
  01596E  1f               pop ds
  01596F  e94e07           jmp 0x160c0
