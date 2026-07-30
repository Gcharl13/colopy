; MAPEDIT.EXE named disasm — module _flsbuf.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __flsbuf  file 0x0161A4..0x016288  seg 0x1388:0x1324  (_flsbuf.asm.obj) ----
  0161A4  55               push bp
  0161A5  8bec             mov bp, sp
  0161A7  56               push si
  0161A8  57               push di
  0161A9  8b7608           mov si, word ptr [bp + 8]
  0161AC  8a4406           mov al, byte ptr [si + 6]
  0161AF  a882             test al, 0x82
  0161B1  7469             je 0x1621c
  0161B3  a840             test al, 0x40
  0161B5  7565             jne 0x1621c
  0161B7  c744020000       mov word ptr [si + 2], 0
  0161BC  a801             test al, 1
  0161BE  740b             je 0x161cb
  0161C0  a810             test al, 0x10
  0161C2  7458             je 0x1621c
  0161C4  8b4c04           mov cx, word ptr [si + 4]
  0161C7  890c             mov word ptr [si], cx
  0161C9  24fe             and al, 0xfe
  0161CB  0c02             or al, 2
  0161CD  24ef             and al, 0xef
  0161CF  884406           mov byte ptr [si + 6], al
  0161D2  8bfe             mov di, si
  0161D4  81efc646         sub di, 0x46c6
  0161D8  81c76647         add di, 0x4766
  0161DC  33db             xor bx, bx
  0161DE  8a5c07           mov bl, byte ptr [si + 7]
  0161E1  a808             test al, 8
  0161E3  754d             jne 0x16232
  0161E5  a804             test al, 4
  0161E7  751e             jne 0x16207
  0161E9  f60501           test byte ptr [di], 1
  0161EC  7544             jne 0x16232
  0161EE  81fece46         cmp si, 0x46ce
  0161F2  740c             je 0x16200
  0161F4  81fed646         cmp si, 0x46d6
  0161F8  7406             je 0x16200
  0161FA  81fee646         cmp si, 0x46e6
  0161FE  7525             jne 0x16225
  016200  f687774540       test byte ptr [bx + 0x4577], 0x40
  016205  741e             je 0x16225
  016207  b90100           mov cx, 1
  01620A  51               push cx
  01620B  8d7e06           lea di, [bp + 6]
  01620E  57               push di
  01620F  53               push bx
  016210  0e               push cs
  016211  e8a209           call 0x16bb6
  016214  83c406           add sp, 6
  016217  b90100           mov cx, 1
  01621A  eb3f             jmp 0x1625b
  01621C  b8ffff           mov ax, 0xffff
  01621F  804c0620         or byte ptr [si + 6], 0x20
  016223  eb5e             jmp 0x16283
  016225  53               push bx
  016226  56               push si
  016227  e8340e           call 0x1705e
  01622A  5b               pop bx
  01622B  5b               pop bx
  01622C  f6440608         test byte ptr [si + 6], 8
  016230  74d5             je 0x16207
  016232  8b0c             mov cx, word ptr [si]
  016234  8b5404           mov dx, word ptr [si + 4]
  016237  2bca             sub cx, dx
  016239  42               inc dx
  01623A  8914             mov word ptr [si], dx
  01623C  8b5502           mov dx, word ptr [di + 2]
  01623F  4a               dec dx
  016240  895402           mov word ptr [si + 2], dx
  016243  e321             jcxz 0x16266
  016245  51               push cx
  016246  51               push cx
  016247  ff7404           push word ptr [si + 4]
  01624A  53               push bx
  01624B  0e               push cs
  01624C  e86709           call 0x16bb6
  01624F  83c406           add sp, 6
  016252  59               pop cx
  016253  8b7c04           mov di, word ptr [si + 4]
  016256  8b5606           mov dx, word ptr [bp + 6]
  016259  8815             mov byte ptr [di], dl
  01625B  3bc1             cmp ax, cx
  01625D  75bd             jne 0x1621c
  01625F  33c0             xor ax, ax
  016261  8a4606           mov al, byte ptr [bp + 6]
  016264  eb1d             jmp 0x16283
  016266  33c0             xor ax, ax
  016268  f687774520       test byte ptr [bx + 0x4577], 0x20
  01626D  74e4             je 0x16253
  01626F  b90200           mov cx, 2
  016272  51               push cx
  016273  50               push ax
  016274  50               push ax
  016275  53               push bx
  016276  0e               push cs
  016277  e8d807           call 0x16a52
  01627A  83c408           add sp, 8
  01627D  33c0             xor ax, ax
  01627F  8bc8             mov cx, ax
  016281  ebd0             jmp 0x16253
  016283  5f               pop di
  016284  5e               pop si
  016285  5d               pop bp
  016286  cb               retf
  016287  00               .byte 0x00
