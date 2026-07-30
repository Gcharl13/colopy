; MAPEDIT.EXE named disasm — module _freebuf.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __freebuf  file 0x016288..0x0162B4  seg 0x1388:0x1408  (_freebuf.asm.obj) ----
  016288  55               push bp
  016289  8bec             mov bp, sp
  01628B  56               push si
  01628C  8b7604           mov si, word ptr [bp + 4]
  01628F  8a4406           mov al, byte ptr [si + 6]
  016292  a883             test al, 0x83
  016294  741b             je 0x162b1
  016296  a808             test al, 8
  016298  7417             je 0x162b1
  01629A  ff7404           push word ptr [si + 4]
  01629D  9af8238813       lcall 0x1388, 0x23f8
  0162A2  59               pop cx
  0162A3  806406f7         and byte ptr [si + 6], 0xf7
  0162A7  33c0             xor ax, ax
  0162A9  894404           mov word ptr [si + 4], ax
  0162AC  8904             mov word ptr [si], ax
  0162AE  894402           mov word ptr [si + 2], ax
  0162B1  5e               pop si
  0162B2  5d               pop bp
  0162B3  c3               ret
