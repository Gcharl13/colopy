; MAPEDIT.EXE named disasm — module sprite_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @sprite_draw  file 0x00EEF0..0x00F0EA  seg 0xD8F:0x0  (sprite_1.c.obj) ----
  00EEF0  c8280000         enter 0x28, 0
  00EEF4  52               push dx
  00EEF5  53               push bx
  00EEF6  50               push ax
  00EEF7  57               push di
  00EEF8  56               push si
  00EEF9  8b4702           mov ax, word ptr [bx + 2]
  00EEFC  48               dec ax
  00EEFD  8946e0           mov word ptr [bp - 0x20], ax
  00EF00  8b07             mov ax, word ptr [bx]
  00EF02  48               dec ax
  00EF03  8946da           mov word ptr [bp - 0x26], ax
  00EF06  ba0100           mov dx, 1
  00EF09  8b46d2           mov ax, word ptr [bp - 0x2e]
  00EF0C  0bc0             or ax, ax
  00EF0E  7903             jns 0xef13
  00EF10  baffff           mov dx, 0xffff
  00EF13  8956f0           mov word ptr [bp - 0x10], dx
  00EF16  25ff7f           and ax, 0x7fff
  00EF19  8946d2           mov word ptr [bp - 0x2e], ax
  00EF1C  8b5ed2           mov bx, word ptr [bp - 0x2e]
  00EF1F  8bc3             mov ax, bx
  00EF21  d1e3             shl bx, 1
  00EF23  03d8             add bx, ax
  00EF25  c1e302           shl bx, 2
  00EF28  035e08           add bx, word ptr [bp + 8]
  00EF2B  8e460a           mov es, word ptr [bp + 0xa]
  00EF2E  83c336           add bx, 0x36
  00EF31  895ef2           mov word ptr [bp - 0xe], bx
  00EF34  8c46f4           mov word ptr [bp - 0xc], es
  00EF37  268b07           mov ax, word ptr es:[bx]
  00EF3A  268b5702         mov dx, word ptr es:[bx + 2]
  00EF3E  8946e4           mov word ptr [bp - 0x1c], ax
  00EF41  8956e6           mov word ptr [bp - 0x1a], dx
  00EF44  8b76d4           mov si, word ptr [bp - 0x2c]
  00EF47  8b4404           mov ax, word ptr [si + 4]
  00EF4A  8b5406           mov dx, word ptr [si + 6]
  00EF4D  8946e8           mov word ptr [bp - 0x18], ax
  00EF50  8956ea           mov word ptr [bp - 0x16], dx
  00EF53  8b4402           mov ax, word ptr [si + 2]
  00EF56  8946fe           mov word ptr [bp - 2], ax
  00EF59  268b4708         mov ax, word ptr es:[bx + 8]
  00EF5D  8946ee           mov word ptr [bp - 0x12], ax
  00EF60  268b470a         mov ax, word ptr es:[bx + 0xa]
  00EF64  8946ec           mov word ptr [bp - 0x14], ax
  00EF67  1e               push ds
  00EF68  8b5eee           mov bx, word ptr [bp - 0x12]
  00EF6B  33c9             xor cx, cx
  00EF6D  8b46d6           mov ax, word ptr [bp - 0x2a]
  00EF70  8bd0             mov dx, ax
  00EF72  03d3             add dx, bx
  00EF74  4a               dec dx
  00EF75  0bc0             or ax, ax
  00EF77  7d04             jge 0xef7d
  00EF79  03d8             add bx, ax
  00EF7B  2bc8             sub cx, ax
  00EF7D  2b56e0           sub dx, word ptr [bp - 0x20]
  00EF80  7e02             jle 0xef84
  00EF82  2bda             sub bx, dx
  00EF84  894ede           mov word ptr [bp - 0x22], cx
  00EF87  895efa           mov word ptr [bp - 6], bx
  00EF8A  03cb             add cx, bx
  00EF8C  894ee2           mov word ptr [bp - 0x1e], cx
  00EF8F  0bdb             or bx, bx
  00EF91  7f03             jg 0xef96
  00EF93  e94c01           jmp 0xf0e2
  00EF96  837ef001         cmp word ptr [bp - 0x10], 1
  00EF9A  7418             je 0xefb4
  00EF9C  8b7eee           mov di, word ptr [bp - 0x12]
  00EF9F  03c7             add ax, di
  00EFA1  48               dec ax
  00EFA2  8946d6           mov word ptr [bp - 0x2a], ax
  00EFA5  2bf9             sub di, cx
  00EFA7  f7df             neg di
  00EFA9  897ede           mov word ptr [bp - 0x22], di
  00EFAC  f7df             neg di
  00EFAE  037efa           add di, word ptr [bp - 6]
  00EFB1  897ee2           mov word ptr [bp - 0x1e], di
  00EFB4  8b5eec           mov bx, word ptr [bp - 0x14]
  00EFB7  33c9             xor cx, cx
  00EFB9  8b4606           mov ax, word ptr [bp + 6]
  00EFBC  8bd0             mov dx, ax
  00EFBE  03d3             add dx, bx
  00EFC0  4a               dec dx
  00EFC1  0bc0             or ax, ax
  00EFC3  7d04             jge 0xefc9
  00EFC5  03d8             add bx, ax
  00EFC7  2bc8             sub cx, ax
  00EFC9  2b56da           sub dx, word ptr [bp - 0x26]
  00EFCC  7e02             jle 0xefd0
  00EFCE  2bda             sub bx, dx
  00EFD0  894ed8           mov word ptr [bp - 0x28], cx
  00EFD3  895ef6           mov word ptr [bp - 0xa], bx
  00EFD6  51               push cx
  00EFD7  03cb             add cx, bx
  00EFD9  894edc           mov word ptr [bp - 0x24], cx
  00EFDC  59               pop cx
  00EFDD  0bdb             or bx, bx
  00EFDF  7f03             jg 0xefe4
  00EFE1  e9fe00           jmp 0xf0e2
  00EFE4  c45ee8           les bx, ptr [bp - 0x18]
  00EFE7  8cc2             mov dx, es
  00EFE9  8b7efe           mov di, word ptr [bp - 2]
  00EFEC  03c8             add cx, ax
  00EFEE  740e             je 0xeffe
  00EFF0  03df             add bx, di
  00EFF2  7908             jns 0xeffc
  00EFF4  81eb0070         sub bx, 0x7000
  00EFF8  81c20007         add dx, 0x700
  00EFFC  e2f2             loop 0xeff0
  00EFFE  035ed6           add bx, word ptr [bp - 0x2a]
  00F001  035ede           add bx, word ptr [bp - 0x22]
  00F004  8ec2             mov es, dx
  00F006  c576e4           lds si, ptr [bp - 0x1c]
  00F009  8b46de           mov ax, word ptr [bp - 0x22]
  00F00C  f76ef0           imul word ptr [bp - 0x10]
  00F00F  8bc8             mov cx, ax
  00F011  8b7ee2           mov di, word ptr [bp - 0x1e]
  00F014  baffff           mov dx, 0xffff
  00F017  c746fc0000       mov word ptr [bp - 4], 0
  00F01C  42               inc dx
  00F01D  3b56dc           cmp dx, word ptr [bp - 0x24]
  00F020  7c04             jl 0xf026
  00F022  e9bd00           jmp 0xf0e2
  00F025  90               nop
  00F026  3b56d8           cmp dx, word ptr [bp - 0x28]
  00F029  7d03             jge 0xf02e
  00F02B  e9a600           jmp 0xf0d4
  00F02E  53               push bx
  00F02F  52               push dx
  00F030  33d2             xor dx, dx
  00F032  ac               lodsb al, byte ptr [si]
  00F033  3cff             cmp al, 0xff
  00F035  7407             je 0xf03e
  00F037  3cfd             cmp al, 0xfd
  00F039  740b             je 0xf046
  00F03B  eb39             jmp 0xf076
  00F03D  90               nop
  00F03E  c746fcffff       mov word ptr [bp - 4], 0xffff
  00F043  eb7d             jmp 0xf0c2
  00F045  90               nop
  00F046  3bd7             cmp dx, di
  00F048  7c02             jl 0xf04c
  00F04A  eb76             jmp 0xf0c2
  00F04C  ac               lodsb al, byte ptr [si]
  00F04D  3cff             cmp al, 0xff
  00F04F  7507             jne 0xf058
  00F051  c746fcffff       mov word ptr [bp - 4], 0xffff
  00F056  eb6a             jmp 0xf0c2
  00F058  8ae0             mov ah, al
  00F05A  ac               lodsb al, byte ptr [si]
  00F05B  3bd1             cmp dx, cx
  00F05D  7c0e             jl 0xf06d
  00F05F  3bd7             cmp dx, di
  00F061  7d0a             jge 0xf06d
  00F063  3cfd             cmp al, 0xfd
  00F065  7403             je 0xf06a
  00F067  268807           mov byte ptr es:[bx], al
  00F06A  035ef0           add bx, word ptr [bp - 0x10]
  00F06D  42               inc dx
  00F06E  fecc             dec ah
  00F070  7402             je 0xf074
  00F072  ebe7             jmp 0xf05b
  00F074  ebd0             jmp 0xf046
  00F076  3bd7             cmp dx, di
  00F078  7c02             jl 0xf07c
  00F07A  eb46             jmp 0xf0c2
  00F07C  ac               lodsb al, byte ptr [si]
  00F07D  3cff             cmp al, 0xff
  00F07F  7407             je 0xf088
  00F081  3cfe             cmp al, 0xfe
  00F083  7405             je 0xf08a
  00F085  eb25             jmp 0xf0ac
  00F087  90               nop
  00F088  ebc7             jmp 0xf051
  00F08A  ac               lodsb al, byte ptr [si]
  00F08B  8ae0             mov ah, al
  00F08D  ac               lodsb al, byte ptr [si]
  00F08E  3bd1             cmp dx, cx
  00F090  7c0e             jl 0xf0a0
  00F092  3bd7             cmp dx, di
  00F094  7d0a             jge 0xf0a0
  00F096  3cfd             cmp al, 0xfd
  00F098  7403             je 0xf09d
  00F09A  268807           mov byte ptr es:[bx], al
  00F09D  035ef0           add bx, word ptr [bp - 0x10]
  00F0A0  42               inc dx
  00F0A1  fecc             dec ah
  00F0A3  7403             je 0xf0a8
  00F0A5  ebe7             jmp 0xf08e
  00F0A7  90               nop
  00F0A8  ebcc             jmp 0xf076
  00F0AA  eb12             jmp 0xf0be
  00F0AC  3bd1             cmp dx, cx
  00F0AE  7c0e             jl 0xf0be
  00F0B0  3bd7             cmp dx, di
  00F0B2  7d0a             jge 0xf0be
  00F0B4  3cfd             cmp al, 0xfd
  00F0B6  7403             je 0xf0bb
  00F0B8  268807           mov byte ptr es:[bx], al
  00F0BB  035ef0           add bx, word ptr [bp - 0x10]
  00F0BE  42               inc dx
  00F0BF  ebb5             jmp 0xf076
  00F0C1  90               nop
  00F0C2  5a               pop dx
  00F0C3  5b               pop bx
  00F0C4  035efe           add bx, word ptr [bp - 2]
  00F0C7  790b             jns 0xf0d4
  00F0C9  81eb0070         sub bx, 0x7000
  00F0CD  8cc0             mov ax, es
  00F0CF  050007           add ax, 0x700
  00F0D2  8ec0             mov es, ax
  00F0D4  837efcff         cmp word ptr [bp - 4], -1
  00F0D8  7405             je 0xf0df
  00F0DA  ac               lodsb al, byte ptr [si]
  00F0DB  3cff             cmp al, 0xff
  00F0DD  75fb             jne 0xf0da
  00F0DF  e935ff           jmp 0xf017
  00F0E2  1f               pop ds
  00F0E3  5e               pop si
  00F0E4  5f               pop di
  00F0E5  c9               leave
  00F0E6  ca0600           retf 6
  00F0E9  90               nop
