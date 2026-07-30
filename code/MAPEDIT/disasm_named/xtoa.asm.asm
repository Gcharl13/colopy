; MAPEDIT.EXE named disasm — module xtoa.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __cltoasub  file 0x016FD8..0x016FE4  seg 0x1388:0x2158  (xtoa.asm.obj) ----
  016FD8  8b4e0c           mov cx, word ptr [bp + 0xc]
  016FDB  8b4606           mov ax, word ptr [bp + 6]
  016FDE  8b5608           mov dx, word ptr [bp + 8]
  016FE1  8b7e0a           mov di, word ptr [bp + 0xa]

; ---- __cxtoa  file 0x016FE4..0x017038  seg 0x1388:0x2164  (xtoa.asm.obj) ----
  016FE4  57               push di
  016FE5  1e               push ds
  016FE6  07               pop es
  016FE7  fc               cld
  016FE8  93               xchg bx, ax
  016FE9  0ac0             or al, al
  016FEB  7413             je 0x17000
  016FED  83f90a           cmp cx, 0xa
  016FF0  750e             jne 0x17000
  016FF2  0bd2             or dx, dx
  016FF4  790a             jns 0x17000
  016FF6  b02d             mov al, 0x2d
  016FF8  aa               stosb byte ptr es:[di], al
  016FF9  f7db             neg bx
  016FFB  83d200           adc dx, 0
  016FFE  f7da             neg dx
  017000  8bf7             mov si, di
  017002  92               xchg dx, ax
  017003  33d2             xor dx, dx
  017005  0bc0             or ax, ax
  017007  7402             je 0x1700b
  017009  f7f1             div cx
  01700B  93               xchg bx, ax
  01700C  f7f1             div cx
  01700E  92               xchg dx, ax
  01700F  87d3             xchg bx, dx
  017011  0430             add al, 0x30
  017013  3c39             cmp al, 0x39
  017015  7602             jbe 0x17019
  017017  0427             add al, 0x27
  017019  aa               stosb byte ptr es:[di], al
  01701A  8bc2             mov ax, dx
  01701C  0bc3             or ax, bx
  01701E  75e2             jne 0x17002
  017020  8805             mov byte ptr [di], al
  017022  4f               dec di
  017023  ac               lodsb al, byte ptr [si]
  017024  8605             xchg byte ptr [di], al
  017026  8844ff           mov byte ptr [si - 1], al
  017029  8d4401           lea ax, [si + 1]
  01702C  3bc7             cmp ax, di
  01702E  72f2             jb 0x17022
  017030  58               pop ax
  017031  5f               pop di
  017032  5e               pop si
  017033  8be5             mov sp, bp
  017035  5d               pop bp
  017036  cb               retf
  017037  00               .byte 0x00
