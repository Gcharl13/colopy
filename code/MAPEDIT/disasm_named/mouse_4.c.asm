; MAPEDIT.EXE named disasm — module mouse_4.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mouse_video_init  file 0x00D94C..0x00D984  seg 0xC34:0xc  (mouse_4.c.obj) ----
  00D94C  ff36f63a         push word ptr [0x3af6]
  00D950  ff36fa3a         push word ptr [0x3afa]
  00D954  ff36f83a         push word ptr [0x3af8]
  00D958  9a5e07650f       lcall 0xf65, 0x75e
  00D95D  83c406           add sp, 6
  00D960  a1f43a           mov ax, word ptr [0x3af4]
  00D963  48               dec ax
  00D964  50               push ax
  00D965  a1f63a           mov ax, word ptr [0x3af6]
  00D968  48               dec ax
  00D969  50               push ax
  00D96A  6a00             push 0
  00D96C  6a00             push 0
  00D96E  9a7707650f       lcall 0xf65, 0x777
  00D973  83c408           add sp, 8
  00D976  6a00             push 0
  00D978  6a00             push 0
  00D97A  9aa807650f       lcall 0xf65, 0x7a8
  00D97F  83c404           add sp, 4
  00D982  cb               retf
  00D983  90               nop

; ---- @mouse_video_update  file 0x00D984..0x00D9CA  seg 0xC34:0x44  (mouse_4.c.obj) ----
  00D984  55               push bp
  00D985  8bec             mov bp, sp
  00D987  53               push bx
  00D988  50               push ax
  00D989  57               push di
  00D98A  56               push si
  00D98B  8bfa             mov di, dx
  00D98D  9abf04650f       lcall 0xf65, 0x4bf
  00D992  9acd07650f       lcall 0xf65, 0x7cd
  00D997  8bf0             mov si, ax
  00D999  ff7606           push word ptr [bp + 6]
  00D99C  ff7608           push word ptr [bp + 8]
  00D99F  ff760a           push word ptr [bp + 0xa]
  00D9A2  ff76fe           push word ptr [bp - 2]
  00D9A5  57               push di
  00D9A6  ff76fc           push word ptr [bp - 4]
  00D9A9  1e               push ds
  00D9AA  68f43a           push 0x3af4
  00D9AD  9a2400c50e       lcall 0xec5, 0x24
  00D9B2  83c410           add sp, 0x10
  00D9B5  0bf6             or si, si
  00D9B7  7405             je 0xd9be
  00D9B9  9a0309650f       lcall 0xf65, 0x903
  00D9BE  9ad104650f       lcall 0xf65, 0x4d1
  00D9C3  5e               pop si
  00D9C4  5f               pop di
  00D9C5  c9               leave
  00D9C6  ca0600           retf 6
  00D9C9  90               nop
