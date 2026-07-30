; MAPEDIT.EXE named disasm — module fgets.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _fgets  file 0x01560A..0x01567E  seg 0x1388:0x78a  (fgets.asm.obj) ----
  01560A  55               push bp
  01560B  8bec             mov bp, sp
  01560D  56               push si
  01560E  57               push di
  01560F  8b5608           mov dx, word ptr [bp + 8]
  015612  0bd2             or dx, dx
  015614  7e54             jle 0x1566a
  015616  4a               dec dx
  015617  8b5e0a           mov bx, word ptr [bp + 0xa]
  01561A  1e               push ds
  01561B  07               pop es
  01561C  8b7e06           mov di, word ptr [bp + 6]
  01561F  0bd2             or dx, dx
  015621  7450             je 0x15673
  015623  8b4f02           mov cx, word ptr [bx + 2]
  015626  e31e             jcxz 0x15646
  015628  3bca             cmp cx, dx
  01562A  7602             jbe 0x1562e
  01562C  8bca             mov cx, dx
  01562E  8b37             mov si, word ptr [bx]
  015630  b40a             mov ah, 0xa
  015632  51               push cx
  015633  90               nop
  015634  ac               lodsb al, byte ptr [si]
  015635  aa               stosb byte ptr es:[di], al
  015636  3ac4             cmp al, ah
  015638  e0fa             loopne 0x15634
  01563A  58               pop ax
  01563B  8937             mov word ptr [bx], si
  01563D  742f             je 0x1566e
  01563F  294702           sub word ptr [bx + 2], ax
  015642  2bd0             sub dx, ax
  015644  ebd9             jmp 0x1561f
  015646  06               push es
  015647  53               push bx
  015648  52               push dx
  015649  53               push bx
  01564A  0e               push cs
  01564B  e8c00a           call 0x1610e
  01564E  5a               pop dx
  01564F  5a               pop dx
  015650  5b               pop bx
  015651  07               pop es
  015652  3dffff           cmp ax, 0xffff
  015655  7408             je 0x1565f
  015657  aa               stosb byte ptr es:[di], al
  015658  3c0a             cmp al, 0xa
  01565A  7417             je 0x15673
  01565C  4a               dec dx
  01565D  ebc0             jmp 0x1561f
  01565F  3b7e06           cmp di, word ptr [bp + 6]
  015662  7406             je 0x1566a
  015664  f6470620         test byte ptr [bx + 6], 0x20
  015668  7409             je 0x15673
  01566A  33c0             xor ax, ax
  01566C  eb0b             jmp 0x15679
  01566E  2bc1             sub ax, cx
  015670  294702           sub word ptr [bx + 2], ax
  015673  33c0             xor ax, ax
  015675  aa               stosb byte ptr es:[di], al
  015676  8b4606           mov ax, word ptr [bp + 6]
  015679  5f               pop di
  01567A  5e               pop si
  01567B  5d               pop bp
  01567C  cb               retf
  01567D  00               .byte 0x00
