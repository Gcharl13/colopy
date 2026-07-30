; MAPEDIT.EXE named disasm — module buffer_t.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_preserve  file 0x00DFDE..0x00E0BC  seg 0xC9D:0xe  (buffer_t.c.obj) ----
  00DFDE  c8020000         enter 2, 0
  00DFE2  52               push dx
  00DFE3  53               push bx
  00DFE4  56               push si
  00DFE5  8bf0             mov si, ax
  00DFE7  c746fefdff       mov word ptr [bp - 2], 0xfffd
  00DFEC  8d4608           lea ax, [bp + 8]
  00DFEF  50               push ax
  00DFF0  8d4606           lea ax, [bp + 6]
  00DFF3  50               push ax
  00DFF4  8b5efa           mov bx, word ptr [bp - 6]
  00DFF7  8d460c           lea ax, [bp + 0xc]
  00DFFA  8d560a           lea dx, [bp + 0xa]
  00DFFD  9a4400910c       lcall 0xc91, 0x44
  00E002  0bc0             or ax, ax
  00E004  7403             je 0xe009
  00E006  e9aa00           jmp 0xe0b3
  00E009  83fef8           cmp si, -8
  00E00C  7556             jne 0xe064
  00E00E  683c07           push 0x73c
  00E011  8d1e9e49         lea bx, [0x499e]
  00E015  8b4608           mov ax, word ptr [bp + 8]
  00E018  8b5606           mov dx, word ptr [bp + 6]
  00E01B  9a44003e0c       lcall 0xc3e, 0x44
  00E020  a1a449           mov ax, word ptr [0x49a4]
  00E023  0b06a249         or ax, word ptr [0x49a2]
  00E027  743b             je 0xe064
  00E029  8b5efa           mov bx, word ptr [bp - 6]
  00E02C  ff7706           push word ptr [bx + 6]
  00E02F  ff7704           push word ptr [bx + 4]
  00E032  ff7702           push word ptr [bx + 2]
  00E035  ff37             push word ptr [bx]
  00E037  ff36a449         push word ptr [0x49a4]
  00E03B  ff36a249         push word ptr [0x49a2]
  00E03F  ff36a049         push word ptr [0x49a0]
  00E043  ff369e49         push word ptr [0x499e]
  00E047  6a00             push 0
  00E049  ff7608           push word ptr [bp + 8]
  00E04C  ff7606           push word ptr [bp + 6]
  00E04F  8b460c           mov ax, word ptr [bp + 0xc]
  00E052  8b560a           mov dx, word ptr [bp + 0xa]
  00E055  2bdb             sub bx, bx
  00E057  9a0000670c       lcall 0xc67, 0
  00E05C  c746feffff       mov word ptr [bp - 2], 0xffff
  00E061  eb50             jmp 0xe0b3
  00E063  90               nop
  00E064  ff760c           push word ptr [bp + 0xc]
  00E067  ff760a           push word ptr [bp + 0xa]
  00E06A  ff7608           push word ptr [bp + 8]
  00E06D  ff7606           push word ptr [bp + 6]
  00E070  8b5efa           mov bx, word ptr [bp - 6]
  00E073  8bc6             mov ax, si
  00E075  8b56fc           mov dx, word ptr [bp - 4]
  00E078  9a0a003d10       lcall 0x103d, 0xa
  00E07D  8946fe           mov word ptr [bp - 2], ax
  00E080  0bc0             or ax, ax
  00E082  7d2f             jge 0xe0b3
  00E084  83fefe           cmp si, -2
  00E087  7425             je 0xe0ae
  00E089  ff7608           push word ptr [bp + 8]
  00E08C  ff7606           push word ptr [bp + 6]
  00E08F  8b5efa           mov bx, word ptr [bp - 6]
  00E092  8b460c           mov ax, word ptr [bp + 0xc]
  00E095  8b560a           mov dx, word ptr [bp + 0xa]
  00E098  9a0c002510       lcall 0x1025, 0xc
  00E09D  8bf0             mov si, ax
  00E09F  0bf6             or si, si
  00E0A1  7c0b             jl 0xe0ae
  00E0A3  83eef6           sub si, -0xa
  00E0A6  f7de             neg si
  00E0A8  8976fe           mov word ptr [bp - 2], si
  00E0AB  eb06             jmp 0xe0b3
  00E0AD  90               nop
  00E0AE  c746fefdff       mov word ptr [bp - 2], 0xfffd
  00E0B3  8b46fe           mov ax, word ptr [bp - 2]
  00E0B6  5e               pop si
  00E0B7  c9               leave
  00E0B8  ca0800           retf 8
  00E0BB  90               nop

; ---- @buffer_restore  file 0x00E0BC..0x00E190  seg 0xC9D:0xec  (buffer_t.c.obj) ----
  00E0BC  55               push bp
  00E0BD  8bec             mov bp, sp
  00E0BF  53               push bx
  00E0C0  57               push di
  00E0C1  56               push si
  00E0C2  8bfa             mov di, dx
  00E0C4  8bf0             mov si, ax
  00E0C6  8d4608           lea ax, [bp + 8]
  00E0C9  50               push ax
  00E0CA  8d4606           lea ax, [bp + 6]
  00E0CD  50               push ax
  00E0CE  8b5efe           mov bx, word ptr [bp - 2]
  00E0D1  8d460c           lea ax, [bp + 0xc]
  00E0D4  8d560a           lea dx, [bp + 0xa]
  00E0D7  9a4400910c       lcall 0xc91, 0x44
  00E0DC  0bc0             or ax, ax
  00E0DE  7403             je 0xe0e3
  00E0E0  e9a700           jmp 0xe18a
  00E0E3  8bc6             mov ax, si
  00E0E5  2dedff           sub ax, 0xffed
  00E0E8  7c11             jl 0xe0fb
  00E0EA  2d0900           sub ax, 9
  00E0ED  7e35             jle 0xe124
  00E0EF  2d0700           sub ax, 7
  00E0F2  7503             jne 0xe0f7
  00E0F4  e99300           jmp 0xe18a
  00E0F7  48               dec ax
  00E0F8  48               dec ax
  00E0F9  744d             je 0xe148
  00E0FB  833e460700       cmp word ptr [0x746], 0
  00E100  7404             je 0xe106
  00E102  81e6ffbf         and si, 0xbfff
  00E106  ff760c           push word ptr [bp + 0xc]
  00E109  ff760a           push word ptr [bp + 0xa]
  00E10C  ff7608           push word ptr [bp + 8]
  00E10F  ff7606           push word ptr [bp + 6]
  00E112  8bd7             mov dx, di
  00E114  8b5efe           mov bx, word ptr [bp - 2]
  00E117  8bc6             mov ax, si
  00E119  9a9e003d10       lcall 0x103d, 0x9e
  00E11E  5e               pop si
  00E11F  5f               pop di
  00E120  c9               leave
  00E121  ca0800           retf 8
  00E124  ff760c           push word ptr [bp + 0xc]
  00E127  ff760a           push word ptr [bp + 0xa]
  00E12A  ff7608           push word ptr [bp + 8]
  00E12D  ff7606           push word ptr [bp + 6]
  00E130  8d440a           lea ax, [si + 0xa]
  00E133  f7d0             not ax
  00E135  40               inc ax
  00E136  8b5efe           mov bx, word ptr [bp - 2]
  00E139  8b164607         mov dx, word ptr [0x746]
  00E13D  9aea002510       lcall 0x1025, 0xea
  00E142  5e               pop si
  00E143  5f               pop di
  00E144  c9               leave
  00E145  ca0800           retf 8
  00E148  ff36a449         push word ptr [0x49a4]
  00E14C  ff36a249         push word ptr [0x49a2]
  00E150  ff36a049         push word ptr [0x49a0]
  00E154  ff369e49         push word ptr [0x499e]
  00E158  8b5efe           mov bx, word ptr [bp - 2]
  00E15B  ff7706           push word ptr [bx + 6]
  00E15E  ff7704           push word ptr [bx + 4]
  00E161  ff7702           push word ptr [bx + 2]
  00E164  ff37             push word ptr [bx]
  00E166  ff760a           push word ptr [bp + 0xa]
  00E169  ff7608           push word ptr [bp + 8]
  00E16C  ff7606           push word ptr [bp + 6]
  00E16F  2bc0             sub ax, ax
  00E171  99               cdq
  00E172  8b5e0c           mov bx, word ptr [bp + 0xc]
  00E175  9a0000670c       lcall 0xc67, 0
  00E17A  833e460700       cmp word ptr [0x746], 0
  00E17F  7509             jne 0xe18a
  00E181  8d1e9e49         lea bx, [0x499e]
  00E185  9a0600460c       lcall 0xc46, 6
  00E18A  5e               pop si
  00E18B  5f               pop di
  00E18C  c9               leave
  00E18D  ca0800           retf 8
