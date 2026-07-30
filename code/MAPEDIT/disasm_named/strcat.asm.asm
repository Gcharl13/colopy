; MAPEDIT.EXE named disasm — module strcat.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strcat  file 0x015466..0x0154A6  seg 0x1388:0x5e6  (strcat.asm.obj) ----
  015466  55               push bp
  015467  8bec             mov bp, sp
  015469  8bd7             mov dx, di
  01546B  8bde             mov bx, si
  01546D  8cd8             mov ax, ds
  01546F  8ec0             mov es, ax
  015471  8b7e06           mov di, word ptr [bp + 6]
  015474  33c0             xor ax, ax
  015476  b9ffff           mov cx, 0xffff
  015479  f2ae             repne scasb al, byte ptr es:[di]
  01547B  8d75ff           lea si, [di - 1]
  01547E  8b7e08           mov di, word ptr [bp + 8]
  015481  b9ffff           mov cx, 0xffff
  015484  f2ae             repne scasb al, byte ptr es:[di]
  015486  f7d1             not cx
  015488  2bf9             sub di, cx
  01548A  87fe             xchg si, di
  01548C  8b4606           mov ax, word ptr [bp + 6]
  01548F  f7c60100         test si, 1
  015493  7402             je 0x15497
  015495  a4               movsb byte ptr es:[di], byte ptr [si]
  015496  49               dec cx
  015497  d1e9             shr cx, 1
  015499  f3a5             rep movsw word ptr es:[di], word ptr [si]
  01549B  13c9             adc cx, cx
  01549D  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  01549F  8bf3             mov si, bx
  0154A1  8bfa             mov di, dx
  0154A3  5d               pop bp
  0154A4  cb               retf
  0154A5  00               .byte 0x00

; ---- __fstrcat  file 0x015CA2..0x015CE8  seg 0x1388:0xe22  (strcat.asm.obj) ----
  015CA2  55               push bp
  015CA3  8bec             mov bp, sp
  015CA5  8bd7             mov dx, di
  015CA7  8bde             mov bx, si
  015CA9  1e               push ds
  015CAA  c47e06           les di, ptr [bp + 6]
  015CAD  33c0             xor ax, ax
  015CAF  b9ffff           mov cx, 0xffff
  015CB2  f2ae             repne scasb al, byte ptr es:[di]
  015CB4  8d75ff           lea si, [di - 1]
  015CB7  c47e0a           les di, ptr [bp + 0xa]
  015CBA  b9ffff           mov cx, 0xffff
  015CBD  f2ae             repne scasb al, byte ptr es:[di]
  015CBF  f7d1             not cx
  015CC1  2bf9             sub di, cx
  015CC3  8cc0             mov ax, es
  015CC5  8ed8             mov ds, ax
  015CC7  8e4608           mov es, word ptr [bp + 8]
  015CCA  87fe             xchg si, di
  015CCC  8b4606           mov ax, word ptr [bp + 6]
  015CCF  f7c60100         test si, 1
  015CD3  7402             je 0x15cd7
  015CD5  a4               movsb byte ptr es:[di], byte ptr [si]
  015CD6  49               dec cx
  015CD7  d1e9             shr cx, 1
  015CD9  f3a5             rep movsw word ptr es:[di], word ptr [si]
  015CDB  13c9             adc cx, cx
  015CDD  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  015CDF  8bf3             mov si, bx
  015CE1  8bfa             mov di, dx
  015CE3  1f               pop ds
  015CE4  8cc2             mov dx, es
  015CE6  5d               pop bp
  015CE7  cb               retf
