; MAPEDIT.EXE named disasm — module sprintf.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _sprintf  file 0x015788..0x0157E2  seg 0x1388:0x908  (sprintf.c.obj) ----
  015788  55               push bp
  015789  8bec             mov bp, sp
  01578B  83ec02           sub sp, 2
  01578E  57               push di
  01578F  56               push si
  015790  c606b04942       mov byte ptr [0x49b0], 0x42
  015795  8b4606           mov ax, word ptr [bp + 6]
  015798  a3ae49           mov word ptr [0x49ae], ax
  01579B  beaa49           mov si, 0x49aa
  01579E  8904             mov word ptr [si], ax
  0157A0  c706ac49ff7f     mov word ptr [0x49ac], 0x7fff
  0157A6  8d460a           lea ax, [bp + 0xa]
  0157A9  50               push ax
  0157AA  ff7608           push word ptr [bp + 8]
  0157AD  8bc6             mov ax, si
  0157AF  50               push ax
  0157B0  9aa6168813       lcall 0x1388, 0x16a6
  0157B5  83c406           add sp, 6
  0157B8  8bf8             mov di, ax
  0157BA  ff0eac49         dec word ptr [0x49ac]
  0157BE  780e             js 0x157ce
  0157C0  8b1eaa49         mov bx, word ptr [0x49aa]
  0157C4  ff06aa49         inc word ptr [0x49aa]
  0157C8  c60700           mov byte ptr [bx], 0
  0157CB  eb0d             jmp 0x157da
  0157CD  90               nop
  0157CE  56               push si
  0157CF  2bc0             sub ax, ax
  0157D1  50               push ax
  0157D2  9a24138813       lcall 0x1388, 0x1324
  0157D7  83c404           add sp, 4
  0157DA  8bc7             mov ax, di
  0157DC  5e               pop si
  0157DD  5f               pop di
  0157DE  8be5             mov sp, bp
  0157E0  5d               pop bp
  0157E1  cb               retf
