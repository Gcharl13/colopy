; MAPEDIT.EXE named disasm — module setvbuf.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _setvbuf  file 0x016EEC..0x016FAC  seg 0x1388:0x206c  (setvbuf.c.obj) ----
  016EEC  55               push bp
  016EED  8bec             mov bp, sp
  016EEF  83ec02           sub sp, 2
  016EF2  57               push di
  016EF3  56               push si
  016EF4  c746fe0000       mov word ptr [bp - 2], 0
  016EF9  837e0a04         cmp word ptr [bp + 0xa], 4
  016EFD  741f             je 0x16f1e
  016EFF  837e0c00         cmp word ptr [bp + 0xc], 0
  016F03  7413             je 0x16f18
  016F05  817e0cff7f       cmp word ptr [bp + 0xc], 0x7fff
  016F0A  770c             ja 0x16f18
  016F0C  837e0a00         cmp word ptr [bp + 0xa], 0
  016F10  740c             je 0x16f1e
  016F12  837e0a40         cmp word ptr [bp + 0xa], 0x40
  016F16  7406             je 0x16f1e
  016F18  b8ffff           mov ax, 0xffff
  016F1B  e98700           jmp 0x16fa5
  016F1E  8b7606           mov si, word ptr [bp + 6]
  016F21  8bfe             mov di, si
  016F23  81efc646         sub di, 0x46c6
  016F27  81c76647         add di, 0x4766
  016F2B  56               push si
  016F2C  9ace158813       lcall 0x1388, 0x15ce
  016F31  83c402           add sp, 2
  016F34  56               push si
  016F35  e850f3           call 0x16288
  016F38  83c402           add sp, 2
  016F3B  f6460a04         test byte ptr [bp + 0xa], 4
  016F3F  7415             je 0x16f56
  016F41  804c0604         or byte ptr [si + 6], 4
  016F45  c60500           mov byte ptr [di], 0
  016F48  8d4501           lea ax, [di + 1]
  016F4B  894608           mov word ptr [bp + 8], ax
  016F4E  c7460c0100       mov word ptr [bp + 0xc], 1
  016F53  eb3a             jmp 0x16f8f
  016F55  90               nop
  016F56  837e0800         cmp word ptr [bp + 8], 0
  016F5A  7528             jne 0x16f84
  016F5C  ff760c           push word ptr [bp + 0xc]
  016F5F  9af2238813       lcall 0x1388, 0x23f2
  016F64  83c402           add sp, 2
  016F67  894608           mov word ptr [bp + 8], ax
  016F6A  0bc0             or ax, ax
  016F6C  7508             jne 0x16f76
  016F6E  c746feffff       mov word ptr [bp - 2], 0xffff
  016F73  eb2d             jmp 0x16fa2
  016F75  90               nop
  016F76  806406fb         and byte ptr [si + 6], 0xfb
  016F7A  804c0608         or byte ptr [si + 6], 8
  016F7E  c60500           mov byte ptr [di], 0
  016F81  eb0c             jmp 0x16f8f
  016F83  90               nop
  016F84  ff067048         inc word ptr [0x4870]
  016F88  806406f3         and byte ptr [si + 6], 0xf3
  016F8C  c60501           mov byte ptr [di], 1
  016F8F  8b460c           mov ax, word ptr [bp + 0xc]
  016F92  894502           mov word ptr [di + 2], ax
  016F95  8b4608           mov ax, word ptr [bp + 8]
  016F98  894404           mov word ptr [si + 4], ax
  016F9B  8904             mov word ptr [si], ax
  016F9D  c744020000       mov word ptr [si + 2], 0
  016FA2  8b46fe           mov ax, word ptr [bp - 2]
  016FA5  5e               pop si
  016FA6  5f               pop di
  016FA7  8be5             mov sp, bp
  016FA9  5d               pop bp
  016FAA  cb               retf
  016FAB  90               nop
