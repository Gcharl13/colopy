; MAPEDIT.EXE named disasm — module terrain.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _terrain_type  file 0x00B176..0x00B1A2  seg 0x9B7:0x6  (terrain.obj) ----
  00B176  55               push bp
  00B177  8bec             mov bp, sp
  00B179  8b5e06           mov bx, word ptr [bp + 6]
  00B17C  f6c320           test bl, 0x20
  00B17F  7415             je 0xb196
  00B181  8ac3             mov al, bl
  00B183  258000           and ax, 0x80
  00B186  3d0100           cmp ax, 1
  00B189  1bd2             sbb dx, dx
  00B18B  83e201           and dx, 1
  00B18E  83c21b           add dx, 0x1b
  00B191  8bc2             mov ax, dx
  00B193  c9               leave
  00B194  cb               retf
  00B195  90               nop
  00B196  8bd3             mov dx, bx
  00B198  80e21f           and dl, 0x1f
  00B19B  2af6             sub dh, dh
  00B19D  8bc2             mov ax, dx
  00B19F  c9               leave
  00B1A0  cb               retf
  00B1A1  90               nop

; ---- _terrain_at  file 0x00B1A2..0x00B1DC  seg 0x9B7:0x32  (terrain.obj) ----
  00B1A2  55               push bp
  00B1A3  8bec             mov bp, sp
  00B1A5  57               push di
  00B1A6  56               push si
  00B1A7  8b7e08           mov di, word ptr [bp + 8]
  00B1AA  be1900           mov si, 0x19
  00B1AD  57               push di
  00B1AE  ff7606           push word ptr [bp + 6]
  00B1B1  9a0e00ab02       lcall 0x2ab, 0xe
  00B1B6  83c404           add sp, 4
  00B1B9  0bc0             or ax, ax
  00B1BB  7418             je 0xb1d5
  00B1BD  57               push di
  00B1BE  ff7606           push word ptr [bp + 6]
  00B1C1  9a1201ab02       lcall 0x2ab, 0x112
  00B1C6  83c404           add sp, 4
  00B1C9  2ae4             sub ah, ah
  00B1CB  50               push ax
  00B1CC  0e               push cs
  00B1CD  e8a6ff           call 0xb176
  00B1D0  83c402           add sp, 2
  00B1D3  8bf0             mov si, ax
  00B1D5  8bc6             mov ax, si
  00B1D7  5e               pop si
  00B1D8  5f               pop di
  00B1D9  c9               leave
  00B1DA  cb               retf
  00B1DB  90               nop

; ---- _terrain_is_ocean  file 0x00B1DC..0x00B20A  seg 0x9B7:0x6c  (terrain.obj) ----
  00B1DC  55               push bp
  00B1DD  8bec             mov bp, sp
  00B1DF  56               push si
  00B1E0  ff7608           push word ptr [bp + 8]
  00B1E3  ff7606           push word ptr [bp + 6]
  00B1E6  9a1201ab02       lcall 0x2ab, 0x112
  00B1EB  83c404           add sp, 4
  00B1EE  2ae4             sub ah, ah
  00B1F0  241f             and al, 0x1f
  00B1F2  8bf0             mov si, ax
  00B1F4  83fe19           cmp si, 0x19
  00B1F7  740b             je 0xb204
  00B1F9  83fe1a           cmp si, 0x1a
  00B1FC  7406             je 0xb204
  00B1FE  2bc0             sub ax, ax
  00B200  5e               pop si
  00B201  c9               leave
  00B202  cb               retf
  00B203  90               nop
  00B204  b80100           mov ax, 1
  00B207  5e               pop si
  00B208  c9               leave
  00B209  cb               retf

; ---- _terrain_is_forest  file 0x00B20A..0x00B242  seg 0x9B7:0x9a  (terrain.obj) ----
  00B20A  55               push bp
  00B20B  8bec             mov bp, sp
  00B20D  56               push si
  00B20E  ff7608           push word ptr [bp + 8]
  00B211  ff7606           push word ptr [bp + 6]
  00B214  9a1201ab02       lcall 0x2ab, 0x112
  00B219  83c404           add sp, 4
  00B21C  2ae4             sub ah, ah
  00B21E  241f             and al, 0x1f
  00B220  8bf0             mov si, ax
  00B222  83fe08           cmp si, 8
  00B225  7c05             jl 0xb22c
  00B227  83fe10           cmp si, 0x10
  00B22A  7c0a             jl 0xb236
  00B22C  83fe10           cmp si, 0x10
  00B22F  7c0b             jl 0xb23c
  00B231  83fe18           cmp si, 0x18
  00B234  7d06             jge 0xb23c
  00B236  b80100           mov ax, 1
  00B239  5e               pop si
  00B23A  c9               leave
  00B23B  cb               retf
  00B23C  2bc0             sub ax, ax
  00B23E  5e               pop si
  00B23F  c9               leave
  00B240  cb               retf
  00B241  90               nop
