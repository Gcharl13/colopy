; MAPEDIT.EXE named disasm — module _getbuf.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __getbuf  file 0x01705E..0x0170A2  seg 0x1388:0x21de  (_getbuf.asm.obj) ----
  01705E  55               push bp
  01705F  8bec             mov bp, sp
  017061  56               push si
  017062  8b7604           mov si, word ptr [bp + 4]
  017065  b80002           mov ax, 0x200
  017068  50               push ax
  017069  9af2238813       lcall 0x1388, 0x23f2
  01706E  59               pop cx
  01706F  8bde             mov bx, si
  017071  81ebc646         sub bx, 0x46c6
  017075  81c36647         add bx, 0x4766
  017079  0bc0             or ax, ax
  01707B  740b             je 0x17088
  01707D  804c0608         or byte ptr [si + 6], 8
  017081  c747020002       mov word ptr [bx + 2], 0x200
  017086  eb0c             jmp 0x17094
  017088  804c0604         or byte ptr [si + 6], 4
  01708C  c747020100       mov word ptr [bx + 2], 1
  017091  8d4701           lea ax, [bx + 1]
  017094  8904             mov word ptr [si], ax
  017096  894404           mov word ptr [si + 4], ax
  017099  c744020000       mov word ptr [si + 2], 0
  01709E  5e               pop si
  01709F  5d               pop bp
  0170A0  c3               ret
  0170A1  00               .byte 0x00
