; MAPEDIT.EXE named disasm — module _sftbuf.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __stbuf  file 0x01639C..0x01640F  seg 0x1388:0x151c  (_sftbuf.asm.obj) ----
  01639C  55               push bp
  01639D  8bec             mov bp, sp
  01639F  56               push si
  0163A0  57               push di
  0163A1  8b7604           mov si, word ptr [bp + 4]
  0163A4  bb0848           mov bx, 0x4808
  0163A7  81fece46         cmp si, 0x46ce
  0163AB  7412             je 0x163bf
  0163AD  bb0a48           mov bx, 0x480a
  0163B0  81fed646         cmp si, 0x46d6
  0163B4  7409             je 0x163bf
  0163B6  bb0c48           mov bx, 0x480c
  0163B9  81fee646         cmp si, 0x46e6
  0163BD  754a             jne 0x16409
  0163BF  8bfe             mov di, si
  0163C1  81efc646         sub di, 0x46c6
  0163C5  81c76647         add di, 0x4766
  0163C9  f644060c         test byte ptr [si + 6], 0xc
  0163CD  753a             jne 0x16409
  0163CF  f60501           test byte ptr [di], 1
  0163D2  7535             jne 0x16409
  0163D4  8b07             mov ax, word ptr [bx]
  0163D6  0bc0             or ax, ax
  0163D8  741b             je 0x163f5
  0163DA  894404           mov word ptr [si + 4], ax
  0163DD  8904             mov word ptr [si], ax
  0163DF  c744020002       mov word ptr [si + 2], 0x200
  0163E4  c745020002       mov word ptr [di + 2], 0x200
  0163E9  804c0602         or byte ptr [si + 6], 2
  0163ED  c60511           mov byte ptr [di], 0x11
  0163F0  b80100           mov ax, 1
  0163F3  eb16             jmp 0x1640b
  0163F5  53               push bx
  0163F6  b80002           mov ax, 0x200
  0163F9  50               push ax
  0163FA  9af2238813       lcall 0x1388, 0x23f2
  0163FF  5b               pop bx
  016400  5b               pop bx
  016401  0bc0             or ax, ax
  016403  7404             je 0x16409
  016405  8907             mov word ptr [bx], ax
  016407  ebd1             jmp 0x163da
  016409  33c0             xor ax, ax
  01640B  5f               pop di
  01640C  5e               pop si
  01640D  5d               pop bp
  01640E  c3               ret

; ---- __ftbuf  file 0x01640F..0x01644E  seg 0x1388:0x158f  (_sftbuf.asm.obj) ----
  01640F  55               push bp
  016410  8bec             mov bp, sp
  016412  56               push si
  016413  57               push di
  016414  8b7606           mov si, word ptr [bp + 6]
  016417  8bfe             mov di, si
  016419  81efc646         sub di, 0x46c6
  01641D  81c76647         add di, 0x4766
  016421  f60510           test byte ptr [di], 0x10
  016424  7424             je 0x1644a
  016426  33db             xor bx, bx
  016428  8a5c07           mov bl, byte ptr [si + 7]
  01642B  f687774540       test byte ptr [bx + 0x4577], 0x40
  016430  7418             je 0x1644a
  016432  56               push si
  016433  0e               push cs
  016434  e81700           call 0x1644e
  016437  58               pop ax
  016438  837e0400         cmp word ptr [bp + 4], 0
  01643C  740c             je 0x1644a
  01643E  33c0             xor ax, ax
  016440  8805             mov byte ptr [di], al
  016442  894502           mov word ptr [di + 2], ax
  016445  8904             mov word ptr [si], ax
  016447  894404           mov word ptr [si + 4], ax
  01644A  5f               pop di
  01644B  5e               pop si
  01644C  5d               pop bp
  01644D  c3               ret
