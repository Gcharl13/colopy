; MAPEDIT.EXE named disasm — module _open.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __openfile  file 0x0162B4..0x01639C  seg 0x1388:0x1434  (_open.c.obj) ----
  0162B4  55               push bp
  0162B5  8bec             mov bp, sp
  0162B7  83ec08           sub sp, 8
  0162BA  57               push di
  0162BB  56               push si
  0162BC  8b5e08           mov bx, word ptr [bp + 8]
  0162BF  8a07             mov al, byte ptr [bx]
  0162C1  98               cwde
  0162C2  3d7700           cmp ax, 0x77
  0162C5  7445             je 0x1630c
  0162C7  7708             ja 0x162d1
  0162C9  2c61             sub al, 0x61
  0162CB  7449             je 0x16316
  0162CD  2c11             sub al, 0x11
  0162CF  7405             je 0x162d6
  0162D1  2bc0             sub ax, ax
  0162D3  e9c000           jmp 0x16396
  0162D6  2bf6             sub si, si
  0162D8  c646fc01         mov byte ptr [bp - 4], 1
  0162DC  c746fe0100       mov word ptr [bp - 2], 1
  0162E1  ff4608           inc word ptr [bp + 8]
  0162E4  8b5e08           mov bx, word ptr [bp + 8]
  0162E7  803f00           cmp byte ptr [bx], 0
  0162EA  745a             je 0x16346
  0162EC  837efe00         cmp word ptr [bp - 2], 0
  0162F0  7454             je 0x16346
  0162F2  8a07             mov al, byte ptr [bx]
  0162F4  98               cwde
  0162F5  3d7400           cmp ax, 0x74
  0162F8  7434             je 0x1632e
  0162FA  7708             ja 0x16304
  0162FC  2c2b             sub al, 0x2b
  0162FE  741c             je 0x1631c
  016300  2c37             sub al, 0x37
  016302  7436             je 0x1633a
  016304  c746fe0000       mov word ptr [bp - 2], 0
  016309  ebd6             jmp 0x162e1
  01630B  90               nop
  01630C  be0103           mov si, 0x301
  01630F  c646fc02         mov byte ptr [bp - 4], 2
  016313  ebc7             jmp 0x162dc
  016315  90               nop
  016316  be0901           mov si, 0x109
  016319  ebf4             jmp 0x1630f
  01631B  90               nop
  01631C  f7c60200         test si, 2
  016320  75e2             jne 0x16304
  016322  83ce02           or si, 2
  016325  83e6fe           and si, 0xfffe
  016328  c646fc80         mov byte ptr [bp - 4], 0x80
  01632C  ebb3             jmp 0x162e1
  01632E  f7c600c0         test si, 0xc000
  016332  75d0             jne 0x16304
  016334  81ce0040         or si, 0x4000
  016338  eba7             jmp 0x162e1
  01633A  f7c600c0         test si, 0xc000
  01633E  75c4             jne 0x16304
  016340  81ce0080         or si, 0x8000
  016344  eb9b             jmp 0x162e1
  016346  b8a401           mov ax, 0x1a4
  016349  50               push ax
  01634A  ff760a           push word ptr [bp + 0xa]
  01634D  56               push si
  01634E  ff7606           push word ptr [bp + 6]
  016351  9a22228813       lcall 0x1388, 0x2222
  016356  83c408           add sp, 8
  016359  8946fa           mov word ptr [bp - 6], ax
  01635C  0bc0             or ax, ax
  01635E  7d03             jge 0x16363
  016360  e96eff           jmp 0x162d1
  016363  ff067048         inc word ptr [0x4870]
  016367  8b7e0c           mov di, word ptr [bp + 0xc]
  01636A  8bc7             mov ax, di
  01636C  2dc646           sub ax, 0x46c6
  01636F  056647           add ax, 0x4766
  016372  8946f8           mov word ptr [bp - 8], ax
  016375  8a46fc           mov al, byte ptr [bp - 4]
  016378  884506           mov byte ptr [di + 6], al
  01637B  8b5ef8           mov bx, word ptr [bp - 8]
  01637E  c60700           mov byte ptr [bx], 0
  016381  2bc0             sub ax, ax
  016383  894502           mov word ptr [di + 2], ax
  016386  894704           mov word ptr [bx + 4], ax
  016389  8905             mov word ptr [di], ax
  01638B  894504           mov word ptr [di + 4], ax
  01638E  8a46fa           mov al, byte ptr [bp - 6]
  016391  884507           mov byte ptr [di + 7], al
  016394  8bc7             mov ax, di
  016396  5e               pop si
  016397  5f               pop di
  016398  8be5             mov sp, bp
  01639A  5d               pop bp
  01639B  cb               retf
