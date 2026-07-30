; MAPEDIT.EXE named disasm — module dos_open.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _sopen  file 0x0170A2..0x0170BC  seg 0x1388:0x2222  (dos_open.asm.obj) ----
  0170A2  55               push bp
  0170A3  8bec             mov bp, sp
  0170A5  83ec04           sub sp, 4
  0170A8  32ff             xor bh, bh
  0170AA  803e704503       cmp byte ptr [0x4570], 3
  0170AF  7203             jb 0x170b4
  0170B1  8a7e0a           mov bh, byte ptr [bp + 0xa]
  0170B4  8b460c           mov ax, word ptr [bp + 0xc]
  0170B7  89460a           mov word ptr [bp + 0xa], ax
  0170BA  eb08             jmp 0x170c4

; ---- _open  file 0x0170BC..0x01724D  seg 0x1388:0x223c  (dos_open.asm.obj) ----
  0170BC  55               push bp
  0170BD  8bec             mov bp, sp
  0170BF  83ec04           sub sp, 4
  0170C2  32ff             xor bh, bh
  0170C4  887efe           mov byte ptr [bp - 2], bh
  0170C7  8b4608           mov ax, word ptr [bp + 8]
  0170CA  8bc8             mov cx, ax
  0170CC  c646fc00         mov byte ptr [bp - 4], 0
  0170D0  a90080           test ax, 0x8000
  0170D3  7510             jne 0x170e5
  0170D5  a90040           test ax, 0x4000
  0170D8  7507             jne 0x170e1
  0170DA  f606914880       test byte ptr [0x4891], 0x80
  0170DF  7504             jne 0x170e5
  0170E1  c646fc80         mov byte ptr [bp - 4], 0x80
  0170E5  8b5606           mov dx, word ptr [bp + 6]
  0170E8  2403             and al, 3
  0170EA  0ac7             or al, bh
  0170EC  b43d             mov ah, 0x3d
  0170EE  cd21             int 0x21
  0170F0  7312             jae 0x17104
  0170F2  3d0200           cmp ax, 2
  0170F5  7509             jne 0x17100
  0170F7  f7c10001         test cx, 0x100
  0170FB  7403             je 0x17100
  0170FD  e99f00           jmp 0x1719f
  017100  f9               stc
  017101  e9c9ef           jmp 0x160cd
  017104  93               xchg bx, ax
  017105  8bc1             mov ax, cx
  017107  250005           and ax, 0x500
  01710A  3d0005           cmp ax, 0x500
  01710D  7509             jne 0x17118
  01710F  b43e             mov ah, 0x3e
  017111  cd21             int 0x21
  017113  b80011           mov ax, 0x1100
  017116  ebe8             jmp 0x17100
  017118  c646fd01         mov byte ptr [bp - 3], 1
  01711C  b80044           mov ax, 0x4400
  01711F  cd21             int 0x21
  017121  f6c280           test dl, 0x80
  017124  7404             je 0x1712a
  017126  804efc40         or byte ptr [bp - 4], 0x40
  01712A  f646fc40         test byte ptr [bp - 4], 0x40
  01712E  7403             je 0x17133
  017130  e9d300           jmp 0x17206
  017133  8b4608           mov ax, word ptr [bp + 8]
  017136  a90002           test ax, 0x200
  017139  741c             je 0x17157
  01713B  a90300           test ax, 3
  01713E  7409             je 0x17149
  017140  33c9             xor cx, cx
  017142  b440             mov ah, 0x40
  017144  cd21             int 0x21
  017146  e9bd00           jmp 0x17206
  017149  b43e             mov ah, 0x3e
  01714B  cd21             int 0x21
  01714D  8b5606           mov dx, word ptr [bp + 6]
  017150  b80043           mov ax, 0x4300
  017153  cd21             int 0x21
  017155  eb65             jmp 0x171bc
  017157  f646fc80         test byte ptr [bp - 4], 0x80
  01715B  7503             jne 0x17160
  01715D  e9a600           jmp 0x17206
  017160  a90200           test ax, 2
  017163  7503             jne 0x17168
  017165  e99e00           jmp 0x17206
  017168  b9ffff           mov cx, 0xffff
  01716B  8bd1             mov dx, cx
  01716D  b80242           mov ax, 0x4202
  017170  cd21             int 0x21
  017172  f7d9             neg cx
  017174  8d56ff           lea dx, [bp - 1]
  017177  b43f             mov ah, 0x3f
  017179  cd21             int 0x21
  01717B  0bc0             or ax, ax
  01717D  7415             je 0x17194
  01717F  807eff1a         cmp byte ptr [bp - 1], 0x1a
  017183  750f             jne 0x17194
  017185  f7d9             neg cx
  017187  8bd1             mov dx, cx
  017189  b80242           mov ax, 0x4202
  01718C  cd21             int 0x21
  01718E  33c9             xor cx, cx
  017190  b440             mov ah, 0x40
  017192  cd21             int 0x21
  017194  33c9             xor cx, cx
  017196  8bd1             mov dx, cx
  017198  b80042           mov ax, 0x4200
  01719B  cd21             int 0x21
  01719D  eb67             jmp 0x17206
  01719F  c646fd00         mov byte ptr [bp - 3], 0
  0171A3  8b4e0a           mov cx, word ptr [bp + 0xa]
  0171A6  e8a400           call 0x1724d
  0171A9  894e0a           mov word ptr [bp + 0xa], cx
  0171AC  f646feff         test byte ptr [bp - 2], 0xff
  0171B0  7507             jne 0x171b9
  0171B2  f746080200       test word ptr [bp + 8], 2
  0171B7  7503             jne 0x171bc
  0171B9  80e1fe           and cl, 0xfe
  0171BC  8b5606           mov dx, word ptr [bp + 6]
  0171BF  b43c             mov ah, 0x3c
  0171C1  cd21             int 0x21
  0171C3  7303             jae 0x171c8
  0171C5  e905ef           jmp 0x160cd
  0171C8  93               xchg bx, ax
  0171C9  f646feff         test byte ptr [bp - 2], 0xff
  0171CD  7507             jne 0x171d6
  0171CF  f746080200       test word ptr [bp + 8], 2
  0171D4  7530             jne 0x17206
  0171D6  b43e             mov ah, 0x3e
  0171D8  cd21             int 0x21
  0171DA  8a4608           mov al, byte ptr [bp + 8]
  0171DD  2403             and al, 3
  0171DF  0a46fe           or al, byte ptr [bp - 2]
  0171E2  8b5606           mov dx, word ptr [bp + 6]
  0171E5  b43d             mov ah, 0x3d
  0171E7  cd21             int 0x21
  0171E9  72da             jb 0x171c5
  0171EB  93               xchg bx, ax
  0171EC  f646fd01         test byte ptr [bp - 3], 1
  0171F0  7514             jne 0x17206
  0171F2  f7460a0100       test word ptr [bp + 0xa], 1
  0171F7  740d             je 0x17206
  0171F9  80c901           or cl, 1
  0171FC  8b5606           mov dx, word ptr [bp + 6]
  0171FF  b80143           mov ax, 0x4301
  017202  cd21             int 0x21
  017204  72bf             jb 0x171c5
  017206  f646fc40         test byte ptr [bp - 4], 0x40
  01720A  753d             jne 0x17249
  01720C  8b5606           mov dx, word ptr [bp + 6]
  01720F  b80043           mov ax, 0x4300
  017212  cd21             int 0x21
  017214  8bc1             mov ax, cx
  017216  32c9             xor cl, cl
  017218  250100           and ax, 1
  01721B  7402             je 0x1721f
  01721D  b110             mov cl, 0x10
  01721F  f746080800       test word ptr [bp + 8], 8
  017224  7403             je 0x17229
  017226  80c920           or cl, 0x20
  017229  3b1e7545         cmp bx, word ptr [0x4575]
  01722D  720a             jb 0x17239
  01722F  b43e             mov ah, 0x3e
  017231  cd21             int 0x21
  017233  b80018           mov ax, 0x1800
  017236  e9c7fe           jmp 0x17100
  017239  0a4efc           or cl, byte ptr [bp - 4]
  01723C  80c901           or cl, 1
  01723F  888f7745         mov byte ptr [bx + 0x4577], cl
  017243  8bc3             mov ax, bx
  017245  8be5             mov sp, bp
  017247  5d               pop bp
  017248  cb               retf
  017249  32c9             xor cl, cl
  01724B  ebdc             jmp 0x17229

; ---- __cXENIXtoDOSmode  file 0x01724D..0x01725E  seg 0x1388:0x23cd  (dos_open.asm.obj) ----
  01724D  a16a45           mov ax, word ptr [0x456a]
  017250  f7d0             not ax
  017252  23c1             and ax, cx
  017254  33c9             xor cx, cx
  017256  a880             test al, 0x80
  017258  7503             jne 0x1725d
  01725A  80c901           or cl, 1
  01725D  c3               ret
