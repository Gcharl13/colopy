; MAPEDIT.EXE named disasm — module memcpy.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _memcpy  file 0x016FAC..0x016FD8  seg 0x1388:0x212c  (memcpy.asm.obj) ----
  016FAC  55               push bp
  016FAD  8bec             mov bp, sp
  016FAF  8bd7             mov dx, di
  016FB1  8bde             mov bx, si
  016FB3  8cd8             mov ax, ds
  016FB5  8ec0             mov es, ax
  016FB7  8b7608           mov si, word ptr [bp + 8]
  016FBA  8b7e06           mov di, word ptr [bp + 6]
  016FBD  8bc7             mov ax, di
  016FBF  8b4e0a           mov cx, word ptr [bp + 0xa]
  016FC2  e30e             jcxz 0x16fd2
  016FC4  a801             test al, 1
  016FC6  7402             je 0x16fca
  016FC8  a4               movsb byte ptr es:[di], byte ptr [si]
  016FC9  49               dec cx
  016FCA  d1e9             shr cx, 1
  016FCC  f3a5             rep movsw word ptr es:[di], word ptr [si]
  016FCE  13c9             adc cx, cx
  016FD0  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  016FD2  8bf3             mov si, bx
  016FD4  8bfa             mov di, dx
  016FD6  5d               pop bp
  016FD7  cb               retf
