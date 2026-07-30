; MAPEDIT.EXE named disasm — module fileio_c.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _FILEIO_CRITICAL_HANDLER  file 0x00D5B6..0x00D5CC  seg 0xBFB:0x6  (fileio_c.ASM.obj) ----
  00D5B6  87df             xchg di, bx
  00D5B8  80fb02           cmp bl, 2
  00D5BB  87df             xchg di, bx
  00D5BD  7508             jne 0xd5c7
  00D5BF  f6c408           test ah, 8
  00D5C2  7403             je 0xd5c7
  00D5C4  b003             mov al, 3
  00D5C6  cf               iret
  00D5C7  2eff2e0000       ljmp cs:[0]

; ---- _fileio_exist  file 0x00D5CC..0x00D64E  seg 0xBFB:0x1c  (fileio_c.ASM.obj) ----
  00D5CC  c8a40000         enter 0xa4, 0
  00D5D0  8cd8             mov ax, ds
  00D5D2  8ec0             mov es, ax
  00D5D4  56               push si
  00D5D5  57               push di
  00D5D6  8b7606           mov si, word ptr [bp + 6]
  00D5D9  8d7ead           lea di, [bp - 0x53]
  00D5DC  b94f00           mov cx, 0x4f
  00D5DF  ac               lodsb al, byte ptr [si]
  00D5E0  aa               stosb byte ptr es:[di], al
  00D5E1  0ac0             or al, al
  00D5E3  e0fa             loopne 0xd5df
  00D5E5  5f               pop di
  00D5E6  5e               pop si
  00D5E7  8d5ead           lea bx, [bp - 0x53]
  00D5EA  8d8e5cff         lea cx, [bp - 0xa4]
  00D5EE  1e               push ds
  00D5EF  53               push bx
  00D5F0  1e               push ds
  00D5F1  51               push cx
  00D5F2  9aba009702       lcall 0x297, 0xba
  00D5F7  83c408           add sp, 8
  00D5FA  b82435           mov ax, 0x3524
  00D5FD  cd21             int 0x21
  00D5FF  8cc0             mov ax, es
  00D601  2e891e0000       mov word ptr cs:[0], bx
  00D606  2ea30200         mov word ptr cs:[2], ax
  00D60A  1e               push ds
  00D60B  0e               push cs
  00D60C  1f               pop ds
  00D60D  ba0600           mov dx, 6
  00D610  b82425           mov ax, 0x2524
  00D613  cd21             int 0x21
  00D615  1f               pop ds
  00D616  8d9e5cff         lea bx, [bp - 0xa4]
  00D61A  8bd3             mov dx, bx
  00D61C  b8003d           mov ax, 0x3d00
  00D61F  cd21             int 0x21
  00D621  720e             jb 0xd631
  00D623  8bd8             mov bx, ax
  00D625  b43e             mov ah, 0x3e
  00D627  cd21             int 0x21
  00D629  c746feffff       mov word ptr [bp - 2], 0xffff
  00D62E  eb06             jmp 0xd636
  00D630  90               nop
  00D631  c746fe0000       mov word ptr [bp - 2], 0
  00D636  1e               push ds
  00D637  2e8b160000       mov dx, word ptr cs:[0]
  00D63C  2ea10200         mov ax, word ptr cs:[2]
  00D640  8ed8             mov ds, ax
  00D642  b82425           mov ax, 0x2524
  00D645  cd21             int 0x21
  00D647  1f               pop ds
  00D648  8b46fe           mov ax, word ptr [bp - 2]
  00D64B  c9               leave
  00D64C  cb               retf
  00D64D  00               .byte 0x00
