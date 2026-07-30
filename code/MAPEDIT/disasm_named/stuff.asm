; MAPEDIT.EXE named disasm — module stuff.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _minimax  file 0x009C5E..0x009C7C  seg 0x865:0xe  (stuff.obj) ----
  009C5E  55               push bp
  009C5F  8bec             mov bp, sp
  009C61  8b5606           mov dx, word ptr [bp + 6]
  009C64  8b4608           mov ax, word ptr [bp + 8]
  009C67  3bc2             cmp ax, dx
  009C69  7d02             jge 0x9c6d
  009C6B  8bc2             mov ax, dx
  009C6D  8bd0             mov dx, ax
  009C6F  3b460a           cmp ax, word ptr [bp + 0xa]
  009C72  7e03             jle 0x9c77
  009C74  8b460a           mov ax, word ptr [bp + 0xa]
  009C77  8bd0             mov dx, ax
  009C79  c9               leave
  009C7A  cb               retf
  009C7B  90               nop

; ---- _swap  file 0x009C7C..0x009C92  seg 0x865:0x2c  (stuff.obj) ----
  009C7C  55               push bp
  009C7D  8bec             mov bp, sp
  009C7F  57               push di
  009C80  8b7e06           mov di, word ptr [bp + 6]
  009C83  8b5e08           mov bx, word ptr [bp + 8]
  009C86  8b15             mov dx, word ptr [di]
  009C88  8b07             mov ax, word ptr [bx]
  009C8A  8905             mov word ptr [di], ax
  009C8C  8917             mov word ptr [bx], dx
  009C8E  5f               pop di
  009C8F  c9               leave
  009C90  cb               retf
  009C91  90               nop

; ---- _xy_dist  file 0x009C92..0x009CCE  seg 0x865:0x42  (stuff.obj) ----
  009C92  55               push bp
  009C93  8bec             mov bp, sp
  009C95  57               push di
  009C96  8b5606           mov dx, word ptr [bp + 6]
  009C99  0bd2             or dx, dx
  009C9B  7f07             jg 0x9ca4
  009C9D  8bc2             mov ax, dx
  009C9F  f7d0             not ax
  009CA1  40               inc ax
  009CA2  8bd0             mov dx, ax
  009CA4  8b5e08           mov bx, word ptr [bp + 8]
  009CA7  0bdb             or bx, bx
  009CA9  7f07             jg 0x9cb2
  009CAB  8bc3             mov ax, bx
  009CAD  f7d0             not ax
  009CAF  40               inc ax
  009CB0  8bd8             mov bx, ax
  009CB2  3bda             cmp bx, dx
  009CB4  7d0c             jge 0x9cc2
  009CB6  8bfb             mov di, bx
  009CB8  d1ff             sar di, 1
  009CBA  03fa             add di, dx
  009CBC  8bc7             mov ax, di
  009CBE  5f               pop di
  009CBF  c9               leave
  009CC0  cb               retf
  009CC1  90               nop
  009CC2  8bfa             mov di, dx
  009CC4  d1ff             sar di, 1
  009CC6  03fb             add di, bx
  009CC8  8bc7             mov ax, di
  009CCA  5f               pop di
  009CCB  c9               leave
  009CCC  cb               retf
  009CCD  90               nop

; ---- _map_dist  file 0x009CCE..0x009D16  seg 0x865:0x7e  (stuff.obj) ----
  009CCE  c8040000         enter 4, 0
  009CD2  57               push di
  009CD3  56               push si
  009CD4  8b5e06           mov bx, word ptr [bp + 6]
  009CD7  8b560a           mov dx, word ptr [bp + 0xa]
  009CDA  8bc3             mov ax, bx
  009CDC  2bc2             sub ax, dx
  009CDE  8946fe           mov word ptr [bp - 2], ax
  009CE1  0bc0             or ax, ax
  009CE3  7e05             jle 0x9cea
  009CE5  8bf8             mov di, ax
  009CE7  eb06             jmp 0x9cef
  009CE9  90               nop
  009CEA  8bf8             mov di, ax
  009CEC  f7d7             not di
  009CEE  47               inc di
  009CEF  8b5608           mov dx, word ptr [bp + 8]
  009CF2  8b4e0c           mov cx, word ptr [bp + 0xc]
  009CF5  8bc2             mov ax, dx
  009CF7  2bc1             sub ax, cx
  009CF9  8946fc           mov word ptr [bp - 4], ax
  009CFC  0bc0             or ax, ax
  009CFE  7e04             jle 0x9d04
  009D00  8bf0             mov si, ax
  009D02  eb05             jmp 0x9d09
  009D04  8bf0             mov si, ax
  009D06  f7d6             not si
  009D08  46               inc si
  009D09  56               push si
  009D0A  57               push di
  009D0B  0e               push cs
  009D0C  e883ff           call 0x9c92
  009D0F  83c404           add sp, 4
  009D12  5e               pop si
  009D13  5f               pop di
  009D14  c9               leave
  009D15  cb               retf

; ---- _xy_dist_2  file 0x009D16..0x009D46  seg 0x865:0xc6  (stuff.obj) ----
  009D16  55               push bp
  009D17  8bec             mov bp, sp
  009D19  8b5e06           mov bx, word ptr [bp + 6]
  009D1C  0bdb             or bx, bx
  009D1E  7f07             jg 0x9d27
  009D20  8bc3             mov ax, bx
  009D22  f7d0             not ax
  009D24  40               inc ax
  009D25  8bd8             mov bx, ax
  009D27  8b5608           mov dx, word ptr [bp + 8]
  009D2A  0bd2             or dx, dx
  009D2C  7f07             jg 0x9d35
  009D2E  8bc2             mov ax, dx
  009D30  f7d0             not ax
  009D32  40               inc ax
  009D33  8bd0             mov dx, ax
  009D35  3bd3             cmp dx, bx
  009D37  7d07             jge 0x9d40
  009D39  8bcb             mov cx, bx
  009D3B  8bc1             mov ax, cx
  009D3D  c9               leave
  009D3E  cb               retf
  009D3F  90               nop
  009D40  8bca             mov cx, dx
  009D42  8bc1             mov ax, cx
  009D44  c9               leave
  009D45  cb               retf

; ---- _map_dist_2  file 0x009D46..0x009D8E  seg 0x865:0xf6  (stuff.obj) ----
  009D46  c8040000         enter 4, 0
  009D4A  57               push di
  009D4B  56               push si
  009D4C  8b5e06           mov bx, word ptr [bp + 6]
  009D4F  8b560a           mov dx, word ptr [bp + 0xa]
  009D52  8bc3             mov ax, bx
  009D54  2bc2             sub ax, dx
  009D56  8946fe           mov word ptr [bp - 2], ax
  009D59  0bc0             or ax, ax
  009D5B  7e05             jle 0x9d62
  009D5D  8bf8             mov di, ax
  009D5F  eb06             jmp 0x9d67
  009D61  90               nop
  009D62  8bf8             mov di, ax
  009D64  f7d7             not di
  009D66  47               inc di
  009D67  8b5608           mov dx, word ptr [bp + 8]
  009D6A  8b4e0c           mov cx, word ptr [bp + 0xc]
  009D6D  8bc2             mov ax, dx
  009D6F  2bc1             sub ax, cx
  009D71  8946fc           mov word ptr [bp - 4], ax
  009D74  0bc0             or ax, ax
  009D76  7e04             jle 0x9d7c
  009D78  8bf0             mov si, ax
  009D7A  eb05             jmp 0x9d81
  009D7C  8bf0             mov si, ax
  009D7E  f7d6             not si
  009D80  46               inc si
  009D81  56               push si
  009D82  57               push di
  009D83  0e               push cs
  009D84  e88fff           call 0x9d16
  009D87  83c404           add sp, 4
  009D8A  5e               pop si
  009D8B  5f               pop di
  009D8C  c9               leave
  009D8D  cb               retf

; ---- _bearing_adjacent  file 0x009D8E..0x009DB4  seg 0x865:0x13e  (stuff.obj) ----
  009D8E  55               push bp
  009D8F  8bec             mov bp, sp
  009D91  8b4e08           mov cx, word ptr [bp + 8]
  009D94  8b5e06           mov bx, word ptr [bp + 6]
  009D97  2bd2             sub dx, dx
  009D99  8ac1             mov al, cl
  009D9B  fec0             inc al
  009D9D  250700           and ax, 7
  009DA0  3bc3             cmp ax, bx
  009DA2  7409             je 0x9dad
  009DA4  fec9             dec cl
  009DA6  83e107           and cx, 7
  009DA9  3bcb             cmp cx, bx
  009DAB  7503             jne 0x9db0
  009DAD  ba0100           mov dx, 1
  009DB0  8bc2             mov ax, dx
  009DB2  c9               leave
  009DB3  cb               retf
