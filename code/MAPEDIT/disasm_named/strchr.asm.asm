; MAPEDIT.EXE named disasm — module strchr.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strchr  file 0x015868..0x015892  seg 0x1388:0x9e8  (strchr.asm.obj) ----
  015868  55               push bp
  015869  8bec             mov bp, sp
  01586B  57               push di
  01586C  8b7e06           mov di, word ptr [bp + 6]
  01586F  1e               push ds
  015870  07               pop es
  015871  8bdf             mov bx, di
  015873  33c0             xor ax, ax
  015875  b9ffff           mov cx, 0xffff
  015878  f2ae             repne scasb al, byte ptr es:[di]
  01587A  41               inc cx
  01587B  f7d9             neg cx
  01587D  8a4608           mov al, byte ptr [bp + 8]
  015880  8bfb             mov di, bx
  015882  f2ae             repne scasb al, byte ptr es:[di]
  015884  4f               dec di
  015885  3805             cmp byte ptr [di], al
  015887  7402             je 0x1588b
  015889  33ff             xor di, di
  01588B  8bc7             mov ax, di
  01588D  5f               pop di
  01588E  8be5             mov sp, bp
  015890  5d               pop bp
  015891  cb               retf

; ---- __fstrchr  file 0x015B28..0x015B56  seg 0x1388:0xca8  (strchr.asm.obj) ----
  015B28  55               push bp
  015B29  8bec             mov bp, sp
  015B2B  57               push di
  015B2C  c47e06           les di, ptr [bp + 6]
  015B2F  8bdf             mov bx, di
  015B31  33c0             xor ax, ax
  015B33  b9ffff           mov cx, 0xffff
  015B36  f2ae             repne scasb al, byte ptr es:[di]
  015B38  41               inc cx
  015B39  f7d9             neg cx
  015B3B  8a460a           mov al, byte ptr [bp + 0xa]
  015B3E  8bfb             mov di, bx
  015B40  f2ae             repne scasb al, byte ptr es:[di]
  015B42  4f               dec di
  015B43  263805           cmp byte ptr es:[di], al
  015B46  7404             je 0x15b4c
  015B48  33ff             xor di, di
  015B4A  8ec7             mov es, di
  015B4C  8bc7             mov ax, di
  015B4E  8cc2             mov dx, es
  015B50  5f               pop di
  015B51  8be5             mov sp, bp
  015B53  5d               pop bp
  015B54  cb               retf
  015B55  00               .byte 0x00
