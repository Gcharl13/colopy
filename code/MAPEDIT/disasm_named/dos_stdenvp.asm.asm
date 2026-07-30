; MAPEDIT.EXE named disasm — module dos_stdenvp.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __setenvp  file 0x015FD8..0x016056  seg 0x1388:0x1158  (dos_stdenvp.asm.obj) ----
  015FD8  55               push bp
  015FD9  8bec             mov bp, sp
  015FDB  1e               push ds
  015FDC  8e066e45         mov es, word ptr [0x456e]
  015FE0  268b1e2c00       mov bx, word ptr es:[0x2c]
  015FE5  8ec3             mov es, bx
  015FE7  33c0             xor ax, ax
  015FE9  33f6             xor si, si
  015FEB  33ff             xor di, di
  015FED  b9ffff           mov cx, 0xffff
  015FF0  0bdb             or bx, bx
  015FF2  740e             je 0x16002
  015FF4  26803e000000     cmp byte ptr es:[0], 0
  015FFA  7406             je 0x16002
  015FFC  f2ae             repne scasb al, byte ptr es:[di]
  015FFE  46               inc si
  015FFF  ae               scasb al, byte ptr es:[di]
  016000  75fa             jne 0x15ffc
  016002  8bc7             mov ax, di
  016004  40               inc ax
  016005  24fe             and al, 0xfe
  016007  46               inc si
  016008  8bfe             mov di, si
  01600A  d1e6             shl si, 1
  01600C  b90900           mov cx, 9
  01600F  e82610           call 0x17038
  016012  50               push ax
  016013  8bc6             mov ax, si
  016015  e82010           call 0x17038
  016018  a38f45           mov word ptr [0x458f], ax
  01601B  06               push es
  01601C  1e               push ds
  01601D  07               pop es
  01601E  1f               pop ds
  01601F  8bcf             mov cx, di
  016021  8bd8             mov bx, ax
  016023  33f6             xor si, si
  016025  5f               pop di
  016026  49               dec cx
  016027  e326             jcxz 0x1604f
  016029  8b04             mov ax, word ptr [si]
  01602B  363b064c45       cmp ax, word ptr ss:[0x454c]
  016030  7510             jne 0x16042
  016032  51               push cx
  016033  56               push si
  016034  57               push di
  016035  bf4c45           mov di, 0x454c
  016038  b90600           mov cx, 6
  01603B  f3a7             repe cmpsw word ptr [si], word ptr es:[di]
  01603D  5f               pop di
  01603E  5e               pop si
  01603F  59               pop cx
  016040  7405             je 0x16047
  016042  26893f           mov word ptr es:[bx], di
  016045  43               inc bx
  016046  43               inc bx
  016047  ac               lodsb al, byte ptr [si]
  016048  aa               stosb byte ptr es:[di], al
  016049  0ac0             or al, al
  01604B  75fa             jne 0x16047
  01604D  e2da             loop 0x16029
  01604F  26890f           mov word ptr es:[bx], cx
  016052  1f               pop ds
  016053  5d               pop bp
  016054  cb               retf
  016055  00               .byte 0x00
