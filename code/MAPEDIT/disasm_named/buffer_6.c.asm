; MAPEDIT.EXE named disasm — module buffer_6.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_rect_copy_2  file 0x00DC70..0x00DD64  seg 0xC67:0x0  (buffer_6.c.obj) ----
  00DC70  c80e0000         enter 0xe, 0
  00DC74  53               push bx
  00DC75  52               push dx
  00DC76  50               push ax
  00DC77  57               push di
  00DC78  56               push si
  00DC79  8b4616           mov ax, word ptr [bp + 0x16]
  00DC7C  2b4608           sub ax, word ptr [bp + 8]
  00DC7F  8946f6           mov word ptr [bp - 0xa], ax
  00DC82  8b460e           mov ax, word ptr [bp + 0xe]
  00DC85  2b4608           sub ax, word ptr [bp + 8]
  00DC88  8946f2           mov word ptr [bp - 0xe], ax
  00DC8B  8b461a           mov ax, word ptr [bp + 0x1a]
  00DC8E  0b4618           or ax, word ptr [bp + 0x18]
  00DC91  740f             je 0xdca2
  00DC93  8b4612           mov ax, word ptr [bp + 0x12]
  00DC96  0b4610           or ax, word ptr [bp + 0x10]
  00DC99  7407             je 0xdca2
  00DC9B  c746f40100       mov word ptr [bp - 0xc], 1
  00DCA0  eb05             jmp 0xdca7
  00DCA2  c746f40000       mov word ptr [bp - 0xc], 0
  00DCA7  837ef400         cmp word ptr [bp - 0xc], 0
  00DCAB  7503             jne 0xdcb0
  00DCAD  e9ab00           jmp 0xdd5b
  00DCB0  8d5e14           lea bx, [bp + 0x14]
  00DCB3  8b46ec           mov ax, word ptr [bp - 0x14]
  00DCB6  8b56ee           mov dx, word ptr [bp - 0x12]
  00DCB9  9a0000910c       lcall 0xc91, 0
  00DCBE  52               push dx
  00DCBF  50               push ax
  00DCC0  9a02004f10       lcall 0x104f, 2
  00DCC5  8946fc           mov word ptr [bp - 4], ax
  00DCC8  8956fe           mov word ptr [bp - 2], dx
  00DCCB  8d5e0c           lea bx, [bp + 0xc]
  00DCCE  8b46f0           mov ax, word ptr [bp - 0x10]
  00DCD1  8b560a           mov dx, word ptr [bp + 0xa]
  00DCD4  9a0000910c       lcall 0xc91, 0
  00DCD9  52               push dx
  00DCDA  50               push ax
  00DCDB  9a02004f10       lcall 0x104f, 2
  00DCE0  8946f8           mov word ptr [bp - 8], ax
  00DCE3  8956fa           mov word ptr [bp - 6], dx
  00DCE6  1e               push ds
  00DCE7  c47ef8           les di, ptr [bp - 8]
  00DCEA  c576fc           lds si, ptr [bp - 4]
  00DCED  8b4606           mov ax, word ptr [bp + 6]
  00DCF0  0bc0             or ax, ax
  00DCF2  7502             jne 0xdcf6
  00DCF4  eb64             jmp 0xdd5a
  00DCF6  8b5608           mov dx, word ptr [bp + 8]
  00DCF9  8b5ef6           mov bx, word ptr [bp - 0xa]
  00DCFC  d1ea             shr dx, 1
  00DCFE  7330             jae 0xdd30
  00DD00  0bd2             or dx, dx
  00DD02  7404             je 0xdd08
  00DD04  8bca             mov cx, dx
  00DD06  f3a5             rep movsw word ptr es:[di], word ptr [si]
  00DD08  a4               movsb byte ptr es:[di], byte ptr [si]
  00DD09  03f3             add si, bx
  00DD0B  790c             jns 0xdd19
  00DD0D  81ee0080         sub si, 0x8000
  00DD11  8cd9             mov cx, ds
  00DD13  81c10008         add cx, 0x800
  00DD17  8ed9             mov ds, cx
  00DD19  037ef2           add di, word ptr [bp - 0xe]
  00DD1C  790c             jns 0xdd2a
  00DD1E  81ef0080         sub di, 0x8000
  00DD22  8cc1             mov cx, es
  00DD24  81c10008         add cx, 0x800
  00DD28  8ec1             mov es, cx
  00DD2A  48               dec ax
  00DD2B  75d3             jne 0xdd00
  00DD2D  eb2b             jmp 0xdd5a
  00DD2F  90               nop
  00DD30  7428             je 0xdd5a
  00DD32  8bca             mov cx, dx
  00DD34  f3a5             rep movsw word ptr es:[di], word ptr [si]
  00DD36  03f3             add si, bx
  00DD38  790c             jns 0xdd46
  00DD3A  81ee0080         sub si, 0x8000
  00DD3E  8cd9             mov cx, ds
  00DD40  81c10008         add cx, 0x800
  00DD44  8ed9             mov ds, cx
  00DD46  037ef2           add di, word ptr [bp - 0xe]
  00DD49  790c             jns 0xdd57
  00DD4B  81ef0080         sub di, 0x8000
  00DD4F  8cc1             mov cx, es
  00DD51  81c10008         add cx, 0x800
  00DD55  8ec1             mov es, cx
  00DD57  48               dec ax
  00DD58  75d8             jne 0xdd32
  00DD5A  1f               pop ds
  00DD5B  8b46f4           mov ax, word ptr [bp - 0xc]
  00DD5E  5e               pop si
  00DD5F  5f               pop di
  00DD60  c9               leave
  00DD61  ca1600           retf 0x16
