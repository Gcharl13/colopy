; MAPEDIT.EXE named disasm — module fopen.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __fsopen  file 0x0151FC..0x015228  seg 0x1388:0x37c  (fopen.c.obj) ----
  0151FC  55               push bp
  0151FD  8bec             mov bp, sp
  0151FF  56               push si
  015200  9a7e1b8813       lcall 0x1388, 0x1b7e
  015205  8bf0             mov si, ax
  015207  0bf6             or si, si
  015209  7505             jne 0x15210
  01520B  2bc0             sub ax, ax
  01520D  eb13             jmp 0x15222
  01520F  90               nop
  015210  56               push si
  015211  ff760a           push word ptr [bp + 0xa]
  015214  ff7608           push word ptr [bp + 8]
  015217  ff7606           push word ptr [bp + 6]
  01521A  9a34148813       lcall 0x1388, 0x1434
  01521F  83c408           add sp, 8
  015222  5e               pop si
  015223  8be5             mov sp, bp
  015225  5d               pop bp
  015226  cb               retf
  015227  90               nop

; ---- _fopen  file 0x015228..0x01523E  seg 0x1388:0x3a8  (fopen.c.obj) ----
  015228  55               push bp
  015229  8bec             mov bp, sp
  01522B  2bc0             sub ax, ax
  01522D  50               push ax
  01522E  ff7608           push word ptr [bp + 8]
  015231  ff7606           push word ptr [bp + 6]
  015234  9a7c038813       lcall 0x1388, 0x37c
  015239  8be5             mov sp, bp
  01523B  5d               pop bp
  01523C  cb               retf
  01523D  90               nop
