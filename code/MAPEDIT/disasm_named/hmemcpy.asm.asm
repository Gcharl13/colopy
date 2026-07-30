; MAPEDIT.EXE named disasm — module hmemcpy.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __fmemcpy  file 0x015ACA..0x015B28  seg 0x1388:0xc4a  (hmemcpy.asm.obj) ----
  015ACA  55               push bp
  015ACB  8bec             mov bp, sp
  015ACD  8b4e0e           mov cx, word ptr [bp + 0xe]
  015AD0  1e               push ds
  015AD1  57               push di
  015AD2  56               push si
  015AD3  e348             jcxz 0x15b1d
  015AD5  c5760a           lds si, ptr [bp + 0xa]
  015AD8  c47e06           les di, ptr [bp + 6]
  015ADB  8bc1             mov ax, cx
  015ADD  48               dec ax
  015ADE  8bd7             mov dx, di
  015AE0  f7d2             not dx
  015AE2  2bc2             sub ax, dx
  015AE4  1bdb             sbb bx, bx
  015AE6  23c3             and ax, bx
  015AE8  03c2             add ax, dx
  015AEA  8bd6             mov dx, si
  015AEC  f7d2             not dx
  015AEE  2bc2             sub ax, dx
  015AF0  1bdb             sbb bx, bx
  015AF2  23c3             and ax, bx
  015AF4  03c2             add ax, dx
  015AF6  40               inc ax
  015AF7  91               xchg cx, ax
  015AF8  2bc1             sub ax, cx
  015AFA  d1e9             shr cx, 1
  015AFC  f3a5             rep movsw word ptr es:[di], word ptr [si]
  015AFE  13c9             adc cx, cx
  015B00  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  015B02  91               xchg cx, ax
  015B03  e318             jcxz 0x15b1d
  015B05  0bf6             or si, si
  015B07  7507             jne 0x15b10
  015B09  8cd8             mov ax, ds
  015B0B  050010           add ax, 0x1000
  015B0E  8ed8             mov ds, ax
  015B10  0bff             or di, di
  015B12  75c7             jne 0x15adb
  015B14  8cc0             mov ax, es
  015B16  050010           add ax, 0x1000
  015B19  8ec0             mov es, ax
  015B1B  ebbe             jmp 0x15adb
  015B1D  8b4606           mov ax, word ptr [bp + 6]
  015B20  8b5608           mov dx, word ptr [bp + 8]
  015B23  5e               pop si
  015B24  5f               pop di
  015B25  1f               pop ds
  015B26  5d               pop bp
  015B27  cb               retf

; ---- __fmemmove  file 0x015D30..0x015DFA  seg 0x1388:0xeb0  (hmemcpy.asm.obj) ----
  015D30  55               push bp
  015D31  8bec             mov bp, sp
  015D33  8b4e0e           mov cx, word ptr [bp + 0xe]
  015D36  1e               push ds
  015D37  57               push di
  015D38  56               push si
  015D39  0bc9             or cx, cx
  015D3B  7503             jne 0x15d40
  015D3D  e9af00           jmp 0x15def
  015D40  c5760a           lds si, ptr [bp + 0xa]
  015D43  c47e06           les di, ptr [bp + 6]
  015D46  1e               push ds
  015D47  56               push si
  015D48  06               push es
  015D49  57               push di
  015D4A  9aca1e8813       lcall 0x1388, 0x1eca
  015D4F  8b4e0e           mov cx, word ptr [bp + 0xe]
  015D52  0bd2             or dx, dx
  015D54  7857             js 0x15dad
  015D56  2bc1             sub ax, cx
  015D58  83da00           sbb dx, 0
  015D5B  7350             jae 0x15dad
  015D5D  49               dec cx
  015D5E  03f1             add si, cx
  015D60  7307             jae 0x15d69
  015D62  8cd8             mov ax, ds
  015D64  050010           add ax, 0x1000
  015D67  8ed8             mov ds, ax
  015D69  03f9             add di, cx
  015D6B  7307             jae 0x15d74
  015D6D  8cc0             mov ax, es
  015D6F  050010           add ax, 0x1000
  015D72  8ec0             mov es, ax
  015D74  41               inc cx
  015D75  8bc1             mov ax, cx
  015D77  48               dec ax
  015D78  2bc7             sub ax, di
  015D7A  1bdb             sbb bx, bx
  015D7C  23c3             and ax, bx
  015D7E  03c7             add ax, di
  015D80  2bc6             sub ax, si
  015D82  1bdb             sbb bx, bx
  015D84  23c3             and ax, bx
  015D86  03c6             add ax, si
  015D88  40               inc ax
  015D89  91               xchg cx, ax
  015D8A  2bc1             sub ax, cx
  015D8C  fd               std
  015D8D  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  015D8F  fc               cld
  015D90  91               xchg cx, ax
  015D91  e35c             jcxz 0x15def
  015D93  83feff           cmp si, -1
  015D96  7507             jne 0x15d9f
  015D98  8cd8             mov ax, ds
  015D9A  2d0010           sub ax, 0x1000
  015D9D  8ed8             mov ds, ax
  015D9F  83ffff           cmp di, -1
  015DA2  75d1             jne 0x15d75
  015DA4  8cc0             mov ax, es
  015DA6  2d0010           sub ax, 0x1000
  015DA9  8ec0             mov es, ax
  015DAB  ebc8             jmp 0x15d75
  015DAD  8bc1             mov ax, cx
  015DAF  48               dec ax
  015DB0  8bd7             mov dx, di
  015DB2  f7d2             not dx
  015DB4  2bc2             sub ax, dx
  015DB6  1bdb             sbb bx, bx
  015DB8  23c3             and ax, bx
  015DBA  03c2             add ax, dx
  015DBC  8bd6             mov dx, si
  015DBE  f7d2             not dx
  015DC0  2bc2             sub ax, dx
  015DC2  1bdb             sbb bx, bx
  015DC4  23c3             and ax, bx
  015DC6  03c2             add ax, dx
  015DC8  40               inc ax
  015DC9  91               xchg cx, ax
  015DCA  2bc1             sub ax, cx
  015DCC  d1e9             shr cx, 1
  015DCE  f3a5             rep movsw word ptr es:[di], word ptr [si]
  015DD0  13c9             adc cx, cx
  015DD2  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  015DD4  91               xchg cx, ax
  015DD5  e318             jcxz 0x15def
  015DD7  0bf6             or si, si
  015DD9  7507             jne 0x15de2
  015DDB  8cd8             mov ax, ds
  015DDD  050010           add ax, 0x1000
  015DE0  8ed8             mov ds, ax
  015DE2  0bff             or di, di
  015DE4  75c7             jne 0x15dad
  015DE6  8cc0             mov ax, es
  015DE8  050010           add ax, 0x1000
  015DEB  8ec0             mov es, ax
  015DED  ebbe             jmp 0x15dad
  015DEF  8b4606           mov ax, word ptr [bp + 6]
  015DF2  8b5608           mov dx, word ptr [bp + 8]
  015DF5  5e               pop si
  015DF6  5f               pop di
  015DF7  1f               pop ds
  015DF8  5d               pop bp
  015DF9  cb               retf
