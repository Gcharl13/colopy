; MAPEDIT.EXE named disasm — module dos_read.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _read  file 0x016ACC..0x016BB6  seg 0x1388:0x1c4c  (dos_read.asm.obj) ----
  016ACC  55               push bp
  016ACD  8bec             mov bp, sp
  016ACF  83ec02           sub sp, 2
  016AD2  8b5e06           mov bx, word ptr [bp + 6]
  016AD5  3b1e7545         cmp bx, word ptr [0x4575]
  016AD9  7206             jb 0x16ae1
  016ADB  f9               stc
  016ADC  b80009           mov ax, 0x900
  016ADF  eb68             jmp 0x16b49
  016AE1  33c0             xor ax, ax
  016AE3  8b4e0a           mov cx, word ptr [bp + 0xa]
  016AE6  e361             jcxz 0x16b49
  016AE8  f687774502       test byte ptr [bx + 0x4577], 2
  016AED  755a             jne 0x16b49
  016AEF  813e9648d6d6     cmp word ptr [0x4896], 0xd6d6
  016AF5  7504             jne 0x16afb
  016AF7  ff169848         call word ptr [0x4898]
  016AFB  8b4e0a           mov cx, word ptr [bp + 0xa]
  016AFE  8b5608           mov dx, word ptr [bp + 8]
  016B01  b43f             mov ah, 0x3f
  016B03  cd21             int 0x21
  016B05  7304             jae 0x16b0b
  016B07  b409             mov ah, 9
  016B09  eb3e             jmp 0x16b49
  016B0B  f687774580       test byte ptr [bx + 0x4577], 0x80
  016B10  7437             je 0x16b49
  016B12  80a77745fb       and byte ptr [bx + 0x4577], 0xfb
  016B17  56               push si
  016B18  57               push di
  016B19  fc               cld
  016B1A  8bf2             mov si, dx
  016B1C  8bfa             mov di, dx
  016B1E  8bc8             mov cx, ax
  016B20  e325             jcxz 0x16b47
  016B22  b40d             mov ah, 0xd
  016B24  803c0a           cmp byte ptr [si], 0xa
  016B27  7505             jne 0x16b2e
  016B29  808f774504       or byte ptr [bx + 0x4577], 4
  016B2E  ac               lodsb al, byte ptr [si]
  016B2F  3ac4             cmp al, ah
  016B31  7419             je 0x16b4c
  016B33  3c1a             cmp al, 0x1a
  016B35  7507             jne 0x16b3e
  016B37  808f774502       or byte ptr [bx + 0x4577], 2
  016B3C  eb05             jmp 0x16b43
  016B3E  8805             mov byte ptr [di], al
  016B40  47               inc di
  016B41  e2eb             loop 0x16b2e
  016B43  8bc7             mov ax, di
  016B45  2bc2             sub ax, dx
  016B47  5f               pop di
  016B48  5e               pop si
  016B49  e981f5           jmp 0x160cd
  016B4C  83f901           cmp cx, 1
  016B4F  7407             je 0x16b58
  016B51  803c0a           cmp byte ptr [si], 0xa
  016B54  74eb             je 0x16b41
  016B56  ebe6             jmp 0x16b3e
  016B58  f687774540       test byte ptr [bx + 0x4577], 0x40
  016B5D  7418             je 0x16b77
  016B5F  b80044           mov ax, 0x4400
  016B62  cd21             int 0x21
  016B64  f7c22000         test dx, 0x20
  016B68  7509             jne 0x16b73
  016B6A  8d56ff           lea dx, [bp - 1]
  016B6D  b43f             mov ah, 0x3f
  016B6F  cd21             int 0x21
  016B71  72d4             jb 0x16b47
  016B73  b00a             mov al, 0xa
  016B75  eb2c             jmp 0x16ba3
  016B77  c646ff00         mov byte ptr [bp - 1], 0
  016B7B  8d56ff           lea dx, [bp - 1]
  016B7E  b43f             mov ah, 0x3f
  016B80  cd21             int 0x21
  016B82  72c3             jb 0x16b47
  016B84  0bc0             or ax, ax
  016B86  7419             je 0x16ba1
  016B88  837e0a01         cmp word ptr [bp + 0xa], 1
  016B8C  741f             je 0x16bad
  016B8E  b9ffff           mov cx, 0xffff
  016B91  8bd1             mov dx, cx
  016B93  b80142           mov ax, 0x4201
  016B96  cd21             int 0x21
  016B98  b90100           mov cx, 1
  016B9B  807eff0a         cmp byte ptr [bp - 1], 0xa
  016B9F  7407             je 0x16ba8
  016BA1  b00d             mov al, 0xd
  016BA3  8b5608           mov dx, word ptr [bp + 8]
  016BA6  eb96             jmp 0x16b3e
  016BA8  8b5608           mov dx, word ptr [bp + 8]
  016BAB  eb94             jmp 0x16b41
  016BAD  807eff0a         cmp byte ptr [bp - 1], 0xa
  016BB1  75db             jne 0x16b8e
  016BB3  ebbe             jmp 0x16b73
  016BB5  00               .byte 0x00
