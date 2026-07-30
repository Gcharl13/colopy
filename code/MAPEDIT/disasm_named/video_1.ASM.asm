; MAPEDIT.EXE named disasm — module video_1.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _video_init  file 0x010258..0x010274  seg 0xEC5:0x8  (video_1.ASM.obj) ----
  010258  c8000000         enter 0, 0
  01025C  8b4606           mov ax, word ptr [bp + 6]
  01025F  a3c649           mov word ptr [0x49c6], ax
  010262  eb01             jmp 0x10265
  010264  90               nop
  010265  837e0800         cmp word ptr [bp + 8], 0
  010269  7407             je 0x10272
  01026B  8b4606           mov ax, word ptr [bp + 6]
  01026E  32e4             xor ah, ah
  010270  cd10             int 0x10
  010272  c9               leave
  010273  cb               retf

; ---- _video_update  file 0x010274..0x0103AC  seg 0xEC5:0x24  (video_1.ASM.obj) ----
  010274  c8040000         enter 4, 0
  010278  1e               push ds
  010279  06               push es
  01027A  56               push si
  01027B  57               push di
  01027C  c47e06           les di, ptr [bp + 6]
  01027F  268b5d02         mov bx, word ptr es:[di + 2]
  010283  268b7504         mov si, word ptr es:[di + 4]
  010287  268b4d06         mov cx, word ptr es:[di + 6]
  01028B  8b460c           mov ax, word ptr [bp + 0xc]
  01028E  f7e3             mul bx
  010290  c1e20c           shl dx, 0xc
  010293  03ca             add cx, dx
  010295  8bd0             mov dx, ax
  010297  83e2f0           and dx, 0xfff0
  01029A  c1ea04           shr dx, 4
  01029D  03ca             add cx, dx
  01029F  250f00           and ax, 0xf
  0102A2  03f0             add si, ax
  0102A4  03760a           add si, word ptr [bp + 0xa]
  0102A7  b800a0           mov ax, 0xa000
  0102AA  8ec0             mov es, ax
  0102AC  b84001           mov ax, 0x140
  0102AF  f76610           mul word ptr [bp + 0x10]
  0102B2  8b7e0e           mov di, word ptr [bp + 0xe]
  0102B5  03f8             add di, ax
  0102B7  8b5612           mov dx, word ptr [bp + 0x12]
  0102BA  2bda             sub bx, dx
  0102BC  8b4614           mov ax, word ptr [bp + 0x14]
  0102BF  55               push bp
  0102C0  bd4001           mov bp, 0x140
  0102C3  2bea             sub bp, dx
  0102C5  8ed9             mov ds, cx
  0102C7  0bc0             or ax, ax
  0102C9  7503             jne 0x102ce
  0102CB  eb33             jmp 0x10300
  0102CD  90               nop
  0102CE  d1ea             shr dx, 1
  0102D0  7313             jae 0x102e5
  0102D2  0bd2             or dx, dx
  0102D4  7404             je 0x102da
  0102D6  8bca             mov cx, dx
  0102D8  f3a5             rep movsw word ptr es:[di], word ptr [si]
  0102DA  a4               movsb byte ptr es:[di], byte ptr [si]
  0102DB  03f3             add si, bx
  0102DD  03fd             add di, bp
  0102DF  48               dec ax
  0102E0  75f0             jne 0x102d2
  0102E2  eb1c             jmp 0x10300
  0102E4  90               nop
  0102E5  7419             je 0x10300
  0102E7  8bca             mov cx, dx
  0102E9  f3a5             rep movsw word ptr es:[di], word ptr [si]
  0102EB  03f3             add si, bx
  0102ED  790c             jns 0x102fb
  0102EF  81ee0080         sub si, 0x8000
  0102F3  8cd9             mov cx, ds
  0102F5  81c10008         add cx, 0x800
  0102F9  8ed9             mov ds, cx
  0102FB  03fd             add di, bp
  0102FD  48               dec ax
  0102FE  75e7             jne 0x102e7
  010300  5d               pop bp
  010301  5f               pop di
  010302  5e               pop si
  010303  07               pop es
  010304  1f               pop ds
  010305  c9               leave
  010306  cb               retf
  010307  00c8             add al, cl
  010309  2e0000           add byte ptr cs:[bx + si], al
  01030C  52               push dx
  01030D  50               push ax
  01030E  53               push bx
  01030F  56               push si
  010310  c746d6ffff       mov word ptr [bp - 0x2a], 0xffff
  010315  1e               push ds
  010316  50               push ax
  010317  8d1e243b         lea bx, [0x3b24]
  01031B  9a04019702       lcall 0x297, 0x104
  010320  8946d2           mov word ptr [bp - 0x2e], ax
  010323  0bc0             or ax, ax
  010325  746e             je 0x10395
  010327  c746d40100       mov word ptr [bp - 0x2c], 1
  01032C  eb03             jmp 0x10331
  01032E  ff46d4           inc word ptr [bp - 0x2c]
  010331  8b46d0           mov ax, word ptr [bp - 0x30]
  010334  3946d4           cmp word ptr [bp - 0x2c], ax
  010337  7f1f             jg 0x10358
  010339  8b5ed2           mov bx, word ptr [bp - 0x2e]
  01033C  f6470610         test byte ptr [bx + 6], 0x10
  010340  7553             jne 0x10395
  010342  53               push bx
  010343  6a24             push 0x24
  010345  8d46d8           lea ax, [bp - 0x28]
  010348  50               push ax
  010349  9a8a078813       lcall 0x1388, 0x78a
  01034E  83c406           add sp, 6
  010351  0bc0             or ax, ax
  010353  75d9             jne 0x1032e
  010355  eb3e             jmp 0x10395
  010357  90               nop
  010358  c746d40000       mov word ptr [bp - 0x2c], 0
  01035D  eb11             jmp 0x10370
  01035F  90               nop
  010360  8b76d4           mov si, word ptr [bp - 0x2c]
  010363  807ad820         cmp byte ptr [bp + si - 0x28], 0x20
  010367  7d04             jge 0x1036d
  010369  c642d800         mov byte ptr [bp + si - 0x28], 0
  01036D  ff46d4           inc word ptr [bp - 0x2c]
  010370  8d46d8           lea ax, [bp - 0x28]
  010373  50               push ax
  010374  9a84068813       lcall 0x1388, 0x684
  010379  83c402           add sp, 2
  01037C  3b46d4           cmp ax, word ptr [bp - 0x2c]
  01037F  7fdf             jg 0x10360
  010381  8d46d8           lea ax, [bp - 0x28]
  010384  50               push ax
  010385  ff76cc           push word ptr [bp - 0x34]
  010388  9a26068813       lcall 0x1388, 0x626
  01038D  83c404           add sp, 4
  010390  c746d60000       mov word ptr [bp - 0x2a], 0
  010395  837ed200         cmp word ptr [bp - 0x2e], 0
  010399  740b             je 0x103a6
  01039B  ff76d2           push word ptr [bp - 0x2e]
  01039E  9ac2028813       lcall 0x1388, 0x2c2
  0103A3  83c402           add sp, 2
  0103A6  8b46d6           mov ax, word ptr [bp - 0x2a]
  0103A9  5e               pop si
  0103AA  c9               leave
  0103AB  c3               ret
