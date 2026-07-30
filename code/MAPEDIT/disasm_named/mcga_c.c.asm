; MAPEDIT.EXE named disasm — module mcga_c.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mcga_time_palette_swap  file 0x00ED5E..0x00EDC4  seg 0xD75:0xe  (mcga_c.c.obj) ----
  00ED5E  c8040000         enter 4, 0
  00ED62  52               push dx
  00ED63  50               push ax
  00ED64  56               push si
  00ED65  8bc8             mov cx, ax
  00ED67  d1e0             shl ax, 1
  00ED69  03c1             add ax, cx
  00ED6B  8946fe           mov word ptr [bp - 2], ax
  00ED6E  8bc2             mov ax, dx
  00ED70  d1e2             shl dx, 1
  00ED72  03d0             add dx, ax
  00ED74  8956fc           mov word ptr [bp - 4], dx
  00ED77  1e               push ds
  00ED78  c57606           lds si, ptr [bp + 6]
  00ED7B  0376fe           add si, word ptr [bp - 2]
  00ED7E  fa               cli
  00ED7F  32c0             xor al, al
  00ED81  e643             out 0x43, al
  00ED83  eb00             jmp 0xed85
  00ED85  e440             in al, 0x40
  00ED87  8ad8             mov bl, al
  00ED89  eb00             jmp 0xed8b
  00ED8B  e440             in al, 0x40
  00ED8D  8af8             mov bh, al
  00ED8F  bac803           mov dx, 0x3c8
  00ED92  8b46f8           mov ax, word ptr [bp - 8]
  00ED95  ee               out dx, al
  00ED96  42               inc dx
  00ED97  8b4efc           mov cx, word ptr [bp - 4]
  00ED9A  833eb83a00       cmp word ptr [0x3ab8], 0
  00ED9F  7405             je 0xeda6
  00EDA1  f36e             rep outsb dx, byte ptr [si]
  00EDA3  eb04             jmp 0xeda9
  00EDA5  90               nop
  00EDA6  6e               outsb dx, byte ptr [si]
  00EDA7  e2fd             loop 0xeda6
  00EDA9  32c0             xor al, al
  00EDAB  e643             out 0x43, al
  00EDAD  eb00             jmp 0xedaf
  00EDAF  e440             in al, 0x40
  00EDB1  8ad0             mov dl, al
  00EDB3  eb00             jmp 0xedb5
  00EDB5  e440             in al, 0x40
  00EDB7  8af0             mov dh, al
  00EDB9  fb               sti
  00EDBA  2bd3             sub dx, bx
  00EDBC  8bc2             mov ax, dx
  00EDBE  1f               pop ds
  00EDBF  5e               pop si
  00EDC0  c9               leave
  00EDC1  ca0400           retf 4

; ---- _mcga_compute_retrace_parameters  file 0x00EDC4..0x00EEF0  seg 0xD75:0x74  (mcga_c.c.obj) ----
  00EDC4  c80a0600         enter 0x60a, 0
  00EDC8  57               push di
  00EDC9  c706b83a0000     mov word ptr [0x3ab8], 0
  00EDCF  33ff             xor di, di
  00EDD1  b92000           mov cx, 0x20
  00EDD4  fa               cli
  00EDD5  bada03           mov dx, 0x3da
  00EDD8  b408             mov ah, 8
  00EDDA  ec               in al, dx
  00EDDB  22c4             and al, ah
  00EDDD  75fb             jne 0xedda
  00EDDF  ec               in al, dx
  00EDE0  22c4             and al, ah
  00EDE2  74fb             je 0xeddf
  00EDE4  32c0             xor al, al
  00EDE6  e643             out 0x43, al
  00EDE8  eb00             jmp 0xedea
  00EDEA  e440             in al, 0x40
  00EDEC  8ad8             mov bl, al
  00EDEE  eb00             jmp 0xedf0
  00EDF0  e440             in al, 0x40
  00EDF2  8af8             mov bh, al
  00EDF4  bada03           mov dx, 0x3da
  00EDF7  b408             mov ah, 8
  00EDF9  ec               in al, dx
  00EDFA  22c4             and al, ah
  00EDFC  75fb             jne 0xedf9
  00EDFE  32c0             xor al, al
  00EE00  e643             out 0x43, al
  00EE02  eb00             jmp 0xee04
  00EE04  e440             in al, 0x40
  00EE06  8ad0             mov dl, al
  00EE08  eb00             jmp 0xee0a
  00EE0A  e440             in al, 0x40
  00EE0C  8af0             mov dh, al
  00EE0E  fb               sti
  00EE0F  2bd3             sub dx, bx
  00EE11  03fa             add di, dx
  00EE13  e2bf             loop 0xedd4
  00EE15  c1ef05           shr di, 5
  00EE18  893eb03a         mov word ptr [0x3ab0], di
  00EE1C  8d8600fd         lea ax, [bp - 0x300]
  00EE20  16               push ss
  00EE21  50               push ax
  00EE22  9a0a005c10       lcall 0x105c, 0xa
  00EE27  c786f6fc4000     mov word ptr [bp - 0x30a], 0x40
  00EE2D  c786fefc8000     mov word ptr [bp - 0x302], 0x80
  00EE33  2bc0             sub ax, ax
  00EE35  8986fafc         mov word ptr [bp - 0x306], ax
  00EE39  8986fcfc         mov word ptr [bp - 0x304], ax
  00EE3D  83bef6fc02       cmp word ptr [bp - 0x30a], 2
  00EE42  7f07             jg 0xee4b
  00EE44  83befafc00       cmp word ptr [bp - 0x306], 0
  00EE49  756d             jne 0xeeb8
  00EE4B  83befcfc20       cmp word ptr [bp - 0x304], 0x20
  00EE50  7d66             jge 0xeeb8
  00EE52  8d8600fd         lea ax, [bp - 0x300]
  00EE56  16               push ss
  00EE57  50               push ax
  00EE58  2bc0             sub ax, ax
  00EE5A  8b96fefc         mov dx, word ptr [bp - 0x302]
  00EE5E  0e               push cs
  00EE5F  e8fcfe           call 0xed5e
  00EE62  8986f8fc         mov word ptr [bp - 0x308], ax
  00EE66  a1b03a           mov ax, word ptr [0x3ab0]
  00EE69  3986f8fc         cmp word ptr [bp - 0x308], ax
  00EE6D  771d             ja 0xee8c
  00EE6F  8b86fefc         mov ax, word ptr [bp - 0x302]
  00EE73  0386f6fc         add ax, word ptr [bp - 0x30a]
  00EE77  3d0001           cmp ax, 0x100
  00EE7A  7e03             jle 0xee7f
  00EE7C  b80001           mov ax, 0x100
  00EE7F  8986fefc         mov word ptr [bp - 0x302], ax
  00EE83  c786fafc0100     mov word ptr [bp - 0x306], 1
  00EE89  eb1b             jmp 0xeea6
  00EE8B  90               nop
  00EE8C  8b86fefc         mov ax, word ptr [bp - 0x302]
  00EE90  2b86f6fc         sub ax, word ptr [bp - 0x30a]
  00EE94  3d0100           cmp ax, 1
  00EE97  7d03             jge 0xee9c
  00EE99  b80100           mov ax, 1
  00EE9C  8986fefc         mov word ptr [bp - 0x302], ax
  00EEA0  c786fafc0000     mov word ptr [bp - 0x306], 0
  00EEA6  83bef6fc02       cmp word ptr [bp - 0x30a], 2
  00EEAB  7e04             jle 0xeeb1
  00EEAD  d1bef6fc         sar word ptr [bp - 0x30a], 1
  00EEB1  ff86fcfc         inc word ptr [bp - 0x304]
  00EEB5  eb86             jmp 0xee3d
  00EEB7  90               nop
  00EEB8  83befafc00       cmp word ptr [bp - 0x306], 0
  00EEBD  7509             jne 0xeec8
  00EEBF  c706b23a2000     mov word ptr [0x3ab2], 0x20
  00EEC5  eb14             jmp 0xeedb
  00EEC7  90               nop
  00EEC8  8b86fefc         mov ax, word ptr [bp - 0x302]
  00EECC  8bc8             mov cx, ax
  00EECE  d1e0             shl ax, 1
  00EED0  03c1             add ax, cx
  00EED2  d1e0             shl ax, 1
  00EED4  03c1             add ax, cx
  00EED6  d1e0             shl ax, 1
  00EED8  a3b23a           mov word ptr [0x3ab2], ax
  00EEDB  a1b23a           mov ax, word ptr [0x3ab2]
  00EEDE  8bc8             mov cx, ax
  00EEE0  d1e0             shl ax, 1
  00EEE2  03c1             add ax, cx
  00EEE4  a3b43a           mov word ptr [0x3ab4], ax
  00EEE7  c706ae3a0100     mov word ptr [0x3aae], 1
  00EEED  5f               pop di
  00EEEE  c9               leave
  00EEEF  cb               retf
