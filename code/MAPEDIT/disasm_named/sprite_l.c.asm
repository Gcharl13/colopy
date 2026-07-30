; MAPEDIT.EXE named disasm — module sprite_l.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @sprite_draw_black  file 0x00FD1C..0x00FF2A  seg 0xE71:0xc  (sprite_l.c.obj) ----
  00FD1C  c8280000         enter 0x28, 0
  00FD20  52               push dx
  00FD21  53               push bx
  00FD22  50               push ax
  00FD23  57               push di
  00FD24  56               push si
  00FD25  8b4702           mov ax, word ptr [bx + 2]
  00FD28  48               dec ax
  00FD29  8946e0           mov word ptr [bp - 0x20], ax
  00FD2C  8b07             mov ax, word ptr [bx]
  00FD2E  48               dec ax
  00FD2F  8946da           mov word ptr [bp - 0x26], ax
  00FD32  ba0100           mov dx, 1
  00FD35  8b46d2           mov ax, word ptr [bp - 0x2e]
  00FD38  0bc0             or ax, ax
  00FD3A  7903             jns 0xfd3f
  00FD3C  baffff           mov dx, 0xffff
  00FD3F  8956f0           mov word ptr [bp - 0x10], dx
  00FD42  25ff7f           and ax, 0x7fff
  00FD45  8946d2           mov word ptr [bp - 0x2e], ax
  00FD48  8b5ed2           mov bx, word ptr [bp - 0x2e]
  00FD4B  8bc3             mov ax, bx
  00FD4D  d1e3             shl bx, 1
  00FD4F  03d8             add bx, ax
  00FD51  c1e302           shl bx, 2
  00FD54  035e08           add bx, word ptr [bp + 8]
  00FD57  8e460a           mov es, word ptr [bp + 0xa]
  00FD5A  83c336           add bx, 0x36
  00FD5D  895ef2           mov word ptr [bp - 0xe], bx
  00FD60  8c46f4           mov word ptr [bp - 0xc], es
  00FD63  268b07           mov ax, word ptr es:[bx]
  00FD66  268b5702         mov dx, word ptr es:[bx + 2]
  00FD6A  8946e4           mov word ptr [bp - 0x1c], ax
  00FD6D  8956e6           mov word ptr [bp - 0x1a], dx
  00FD70  8b76d4           mov si, word ptr [bp - 0x2c]
  00FD73  8b4404           mov ax, word ptr [si + 4]
  00FD76  8b5406           mov dx, word ptr [si + 6]
  00FD79  8946e8           mov word ptr [bp - 0x18], ax
  00FD7C  8956ea           mov word ptr [bp - 0x16], dx
  00FD7F  8b4402           mov ax, word ptr [si + 2]
  00FD82  8946fe           mov word ptr [bp - 2], ax
  00FD85  268b4708         mov ax, word ptr es:[bx + 8]
  00FD89  8946ee           mov word ptr [bp - 0x12], ax
  00FD8C  268b470a         mov ax, word ptr es:[bx + 0xa]
  00FD90  8946ec           mov word ptr [bp - 0x14], ax
  00FD93  1e               push ds
  00FD94  8b5eee           mov bx, word ptr [bp - 0x12]
  00FD97  33c9             xor cx, cx
  00FD99  8b46d6           mov ax, word ptr [bp - 0x2a]
  00FD9C  8bd0             mov dx, ax
  00FD9E  03d3             add dx, bx
  00FDA0  4a               dec dx
  00FDA1  0bc0             or ax, ax
  00FDA3  7d04             jge 0xfda9
  00FDA5  03d8             add bx, ax
  00FDA7  2bc8             sub cx, ax
  00FDA9  2b56e0           sub dx, word ptr [bp - 0x20]
  00FDAC  7e02             jle 0xfdb0
  00FDAE  2bda             sub bx, dx
  00FDB0  894ede           mov word ptr [bp - 0x22], cx
  00FDB3  895efa           mov word ptr [bp - 6], bx
  00FDB6  03cb             add cx, bx
  00FDB8  894ee2           mov word ptr [bp - 0x1e], cx
  00FDBB  0bdb             or bx, bx
  00FDBD  7f03             jg 0xfdc2
  00FDBF  e96001           jmp 0xff22
  00FDC2  837ef001         cmp word ptr [bp - 0x10], 1
  00FDC6  7418             je 0xfde0
  00FDC8  8b7eee           mov di, word ptr [bp - 0x12]
  00FDCB  03c7             add ax, di
  00FDCD  48               dec ax
  00FDCE  8946d6           mov word ptr [bp - 0x2a], ax
  00FDD1  2bf9             sub di, cx
  00FDD3  f7df             neg di
  00FDD5  897ede           mov word ptr [bp - 0x22], di
  00FDD8  f7df             neg di
  00FDDA  037efa           add di, word ptr [bp - 6]
  00FDDD  897ee2           mov word ptr [bp - 0x1e], di
  00FDE0  8b5eec           mov bx, word ptr [bp - 0x14]
  00FDE3  33c9             xor cx, cx
  00FDE5  8b4606           mov ax, word ptr [bp + 6]
  00FDE8  8bd0             mov dx, ax
  00FDEA  03d3             add dx, bx
  00FDEC  4a               dec dx
  00FDED  0bc0             or ax, ax
  00FDEF  7d04             jge 0xfdf5
  00FDF1  03d8             add bx, ax
  00FDF3  2bc8             sub cx, ax
  00FDF5  2b56da           sub dx, word ptr [bp - 0x26]
  00FDF8  7e02             jle 0xfdfc
  00FDFA  2bda             sub bx, dx
  00FDFC  894ed8           mov word ptr [bp - 0x28], cx
  00FDFF  895ef6           mov word ptr [bp - 0xa], bx
  00FE02  51               push cx
  00FE03  03cb             add cx, bx
  00FE05  894edc           mov word ptr [bp - 0x24], cx
  00FE08  59               pop cx
  00FE09  0bdb             or bx, bx
  00FE0B  7f03             jg 0xfe10
  00FE0D  e91201           jmp 0xff22
  00FE10  c45ee8           les bx, ptr [bp - 0x18]
  00FE13  8cc2             mov dx, es
  00FE15  8b7efe           mov di, word ptr [bp - 2]
  00FE18  03c8             add cx, ax
  00FE1A  740e             je 0xfe2a
  00FE1C  03df             add bx, di
  00FE1E  7908             jns 0xfe28
  00FE20  81eb0070         sub bx, 0x7000
  00FE24  81c20007         add dx, 0x700
  00FE28  e2f2             loop 0xfe1c
  00FE2A  035ed6           add bx, word ptr [bp - 0x2a]
  00FE2D  035ede           add bx, word ptr [bp - 0x22]
  00FE30  8ec2             mov es, dx
  00FE32  c576e4           lds si, ptr [bp - 0x1c]
  00FE35  8b46de           mov ax, word ptr [bp - 0x22]
  00FE38  f76ef0           imul word ptr [bp - 0x10]
  00FE3B  8bc8             mov cx, ax
  00FE3D  8b7ee2           mov di, word ptr [bp - 0x1e]
  00FE40  baffff           mov dx, 0xffff
  00FE43  c746fc0000       mov word ptr [bp - 4], 0
  00FE48  42               inc dx
  00FE49  3b56dc           cmp dx, word ptr [bp - 0x24]
  00FE4C  7c04             jl 0xfe52
  00FE4E  e9d100           jmp 0xff22
  00FE51  90               nop
  00FE52  3b56d8           cmp dx, word ptr [bp - 0x28]
  00FE55  7d03             jge 0xfe5a
  00FE57  e9ba00           jmp 0xff14
  00FE5A  53               push bx
  00FE5B  52               push dx
  00FE5C  33d2             xor dx, dx
  00FE5E  ac               lodsb al, byte ptr [si]
  00FE5F  3cff             cmp al, 0xff
  00FE61  7407             je 0xfe6a
  00FE63  3cfd             cmp al, 0xfd
  00FE65  740b             je 0xfe72
  00FE67  eb41             jmp 0xfeaa
  00FE69  90               nop
  00FE6A  c746fcffff       mov word ptr [bp - 4], 0xffff
  00FE6F  e99000           jmp 0xff02
  00FE72  3bd7             cmp dx, di
  00FE74  7c04             jl 0xfe7a
  00FE76  e98900           jmp 0xff02
  00FE79  90               nop
  00FE7A  ac               lodsb al, byte ptr [si]
  00FE7B  3cff             cmp al, 0xff
  00FE7D  7507             jne 0xfe86
  00FE7F  c746fcffff       mov word ptr [bp - 4], 0xffff
  00FE84  eb7c             jmp 0xff02
  00FE86  8ae0             mov ah, al
  00FE88  ac               lodsb al, byte ptr [si]
  00FE89  3bd1             cmp dx, cx
  00FE8B  7c14             jl 0xfea1
  00FE8D  3bd7             cmp dx, di
  00FE8F  7d10             jge 0xfea1
  00FE91  3cfd             cmp al, 0xfd
  00FE93  7409             je 0xfe9e
  00FE95  26803f00         cmp byte ptr es:[bx], 0
  00FE99  7503             jne 0xfe9e
  00FE9B  268807           mov byte ptr es:[bx], al
  00FE9E  035ef0           add bx, word ptr [bp - 0x10]
  00FEA1  42               inc dx
  00FEA2  fecc             dec ah
  00FEA4  7402             je 0xfea8
  00FEA6  ebe1             jmp 0xfe89
  00FEA8  ebc8             jmp 0xfe72
  00FEAA  3bd7             cmp dx, di
  00FEAC  7c02             jl 0xfeb0
  00FEAE  eb52             jmp 0xff02
  00FEB0  ac               lodsb al, byte ptr [si]
  00FEB1  3cff             cmp al, 0xff
  00FEB3  7407             je 0xfebc
  00FEB5  3cfe             cmp al, 0xfe
  00FEB7  7405             je 0xfebe
  00FEB9  eb2b             jmp 0xfee6
  00FEBB  90               nop
  00FEBC  ebc1             jmp 0xfe7f
  00FEBE  ac               lodsb al, byte ptr [si]
  00FEBF  8ae0             mov ah, al
  00FEC1  ac               lodsb al, byte ptr [si]
  00FEC2  3bd1             cmp dx, cx
  00FEC4  7c14             jl 0xfeda
  00FEC6  3bd7             cmp dx, di
  00FEC8  7d10             jge 0xfeda
  00FECA  3cfd             cmp al, 0xfd
  00FECC  7409             je 0xfed7
  00FECE  26803f00         cmp byte ptr es:[bx], 0
  00FED2  7503             jne 0xfed7
  00FED4  268807           mov byte ptr es:[bx], al
  00FED7  035ef0           add bx, word ptr [bp - 0x10]
  00FEDA  42               inc dx
  00FEDB  fecc             dec ah
  00FEDD  7403             je 0xfee2
  00FEDF  ebe1             jmp 0xfec2
  00FEE1  90               nop
  00FEE2  ebc6             jmp 0xfeaa
  00FEE4  eb18             jmp 0xfefe
  00FEE6  3bd1             cmp dx, cx
  00FEE8  7c14             jl 0xfefe
  00FEEA  3bd7             cmp dx, di
  00FEEC  7d10             jge 0xfefe
  00FEEE  3cfd             cmp al, 0xfd
  00FEF0  7409             je 0xfefb
  00FEF2  26803f00         cmp byte ptr es:[bx], 0
  00FEF6  7503             jne 0xfefb
  00FEF8  268807           mov byte ptr es:[bx], al
  00FEFB  035ef0           add bx, word ptr [bp - 0x10]
  00FEFE  42               inc dx
  00FEFF  eba9             jmp 0xfeaa
  00FF01  90               nop
  00FF02  5a               pop dx
  00FF03  5b               pop bx
  00FF04  035efe           add bx, word ptr [bp - 2]
  00FF07  790b             jns 0xff14
  00FF09  81eb0070         sub bx, 0x7000
  00FF0D  8cc0             mov ax, es
  00FF0F  050007           add ax, 0x700
  00FF12  8ec0             mov es, ax
  00FF14  837efcff         cmp word ptr [bp - 4], -1
  00FF18  7405             je 0xff1f
  00FF1A  ac               lodsb al, byte ptr [si]
  00FF1B  3cff             cmp al, 0xff
  00FF1D  75fb             jne 0xff1a
  00FF1F  e921ff           jmp 0xfe43
  00FF22  1f               pop ds
  00FF23  5e               pop si
  00FF24  5f               pop di
  00FF25  c9               leave
  00FF26  ca0600           retf 6
  00FF29  90               nop
