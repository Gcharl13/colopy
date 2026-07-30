; MAPEDIT.EXE named disasm — module dos_nmsghdr.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __NMSG_TEXT  file 0x016056..0x016081  seg 0x1388:0x11d6  (dos_nmsghdr.asm.obj) ----
  016056  55               push bp
  016057  8bec             mov bp, sp
  016059  56               push si
  01605A  57               push di
  01605B  1e               push ds
  01605C  07               pop es
  01605D  8b5606           mov dx, word ptr [bp + 6]
  016060  bec048           mov si, 0x48c0
  016063  ad               lodsw ax, word ptr [si]
  016064  3bc2             cmp ax, dx
  016066  7410             je 0x16078
  016068  40               inc ax
  016069  96               xchg si, ax
  01606A  740c             je 0x16078
  01606C  97               xchg di, ax
  01606D  33c0             xor ax, ax
  01606F  b9ffff           mov cx, 0xffff
  016072  f2ae             repne scasb al, byte ptr es:[di]
  016074  8bf7             mov si, di
  016076  ebeb             jmp 0x16063
  016078  96               xchg si, ax
  016079  5f               pop di
  01607A  5e               pop si
  01607B  8be5             mov sp, bp
  01607D  5d               pop bp
  01607E  ca0200           retf 2

; ---- __NMSG_WRITE  file 0x016081..0x0160B8  seg 0x1388:0x1201  (dos_nmsghdr.asm.obj) ----
  016081  55               push bp
  016082  8bec             mov bp, sp
  016084  57               push di
  016085  ff7606           push word ptr [bp + 6]
  016088  0e               push cs
  016089  e8caff           call 0x16056
  01608C  0bc0             or ax, ax
  01608E  7420             je 0x160b0
  016090  92               xchg dx, ax
  016091  8bfa             mov di, dx
  016093  33c0             xor ax, ax
  016095  b9ffff           mov cx, 0xffff
  016098  f2ae             repne scasb al, byte ptr es:[di]
  01609A  f7d1             not cx
  01609C  49               dec cx
  01609D  bb0200           mov bx, 2
  0160A0  813e9648d6d6     cmp word ptr [0x4896], 0xd6d6
  0160A6  7504             jne 0x160ac
  0160A8  ff169848         call word ptr [0x4898]
  0160AC  b440             mov ah, 0x40
  0160AE  cd21             int 0x21
  0160B0  5f               pop di
  0160B1  8be5             mov sp, bp
  0160B3  5d               pop bp
  0160B4  ca0200           retf 2
  0160B7  00               .byte 0x00
