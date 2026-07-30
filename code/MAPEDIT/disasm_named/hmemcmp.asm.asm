; MAPEDIT.EXE named disasm — module hmemcmp.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __fmemcmp  file 0x015A6E..0x015ACA  seg 0x1388:0xbee  (hmemcmp.asm.obj) ----
  015A6E  55               push bp
  015A6F  8bec             mov bp, sp
  015A71  33c0             xor ax, ax
  015A73  8b4e0e           mov cx, word ptr [bp + 0xe]
  015A76  e34f             jcxz 0x15ac7
  015A78  1e               push ds
  015A79  57               push di
  015A7A  56               push si
  015A7B  c57606           lds si, ptr [bp + 6]
  015A7E  c47e0a           les di, ptr [bp + 0xa]
  015A81  8bc1             mov ax, cx
  015A83  48               dec ax
  015A84  8bd7             mov dx, di
  015A86  f7d2             not dx
  015A88  2bc2             sub ax, dx
  015A8A  1bdb             sbb bx, bx
  015A8C  23c3             and ax, bx
  015A8E  03c2             add ax, dx
  015A90  8bd6             mov dx, si
  015A92  f7d2             not dx
  015A94  2bc2             sub ax, dx
  015A96  1bdb             sbb bx, bx
  015A98  23c3             and ax, bx
  015A9A  03c2             add ax, dx
  015A9C  40               inc ax
  015A9D  91               xchg cx, ax
  015A9E  2bc1             sub ax, cx
  015AA0  f3a6             repe cmpsb byte ptr [si], byte ptr es:[di]
  015AA2  751b             jne 0x15abf
  015AA4  91               xchg cx, ax
  015AA5  e31d             jcxz 0x15ac4
  015AA7  0bf6             or si, si
  015AA9  7507             jne 0x15ab2
  015AAB  8cd8             mov ax, ds
  015AAD  050010           add ax, 0x1000
  015AB0  8ed8             mov ds, ax
  015AB2  0bff             or di, di
  015AB4  75cb             jne 0x15a81
  015AB6  8cc0             mov ax, es
  015AB8  050010           add ax, 0x1000
  015ABB  8ec0             mov es, ax
  015ABD  ebc2             jmp 0x15a81
  015ABF  1bc0             sbb ax, ax
  015AC1  1dffff           sbb ax, 0xffff
  015AC4  5e               pop si
  015AC5  5f               pop di
  015AC6  1f               pop ds
  015AC7  5d               pop bp
  015AC8  cb               retf
  015AC9  00               .byte 0x00
