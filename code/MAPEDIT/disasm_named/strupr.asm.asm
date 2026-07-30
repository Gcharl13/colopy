; MAPEDIT.EXE named disasm — module strupr.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strupr  file 0x015908..0x015926  seg 0x1388:0xa88  (strupr.asm.obj) ----
  015908  55               push bp
  015909  8bec             mov bp, sp
  01590B  8b5e06           mov bx, word ptr [bp + 6]
  01590E  8bd3             mov dx, bx
  015910  eb0b             jmp 0x1591d
  015912  2c61             sub al, 0x61
  015914  3c1a             cmp al, 0x1a
  015916  7304             jae 0x1591c
  015918  0441             add al, 0x41
  01591A  8807             mov byte ptr [bx], al
  01591C  43               inc bx
  01591D  8a07             mov al, byte ptr [bx]
  01591F  0ac0             or al, al
  015921  75ef             jne 0x15912
  015923  92               xchg dx, ax
  015924  5d               pop bp
  015925  cb               retf

; ---- __fstrupr  file 0x015C30..0x015C54  seg 0x1388:0xdb0  (strupr.asm.obj) ----
  015C30  55               push bp
  015C31  8bec             mov bp, sp
  015C33  8cd9             mov cx, ds
  015C35  c55e06           lds bx, ptr [bp + 6]
  015C38  8bd3             mov dx, bx
  015C3A  eb0b             jmp 0x15c47
  015C3C  2c61             sub al, 0x61
  015C3E  3c1a             cmp al, 0x1a
  015C40  7304             jae 0x15c46
  015C42  0441             add al, 0x41
  015C44  8807             mov byte ptr [bx], al
  015C46  43               inc bx
  015C47  8a07             mov al, byte ptr [bx]
  015C49  0ac0             or al, al
  015C4B  75ef             jne 0x15c3c
  015C4D  92               xchg dx, ax
  015C4E  8cda             mov dx, ds
  015C50  8ed9             mov ds, cx
  015C52  5d               pop bp
  015C53  cb               retf
