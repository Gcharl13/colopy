; MAPEDIT.EXE named disasm — module _filbuf.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __filbuf  file 0x01610E..0x0161A4  seg 0x1388:0x128e  (_filbuf.asm.obj) ----
  01610E  55               push bp
  01610F  8bec             mov bp, sp
  016111  56               push si
  016112  57               push di
  016113  8b7606           mov si, word ptr [bp + 6]
  016116  8a4406           mov al, byte ptr [si + 6]
  016119  a883             test al, 0x83
  01611B  7459             je 0x16176
  01611D  a840             test al, 0x40
  01611F  7555             jne 0x16176
  016121  a802             test al, 2
  016123  7542             jne 0x16167
  016125  0c01             or al, 1
  016127  884406           mov byte ptr [si + 6], al
  01612A  8bfe             mov di, si
  01612C  81efc646         sub di, 0x46c6
  016130  81c76647         add di, 0x4766
  016134  a80c             test al, 0xc
  016136  750a             jne 0x16142
  016138  f60501           test byte ptr [di], 1
  01613B  7505             jne 0x16142
  01613D  56               push si
  01613E  e81d0f           call 0x1705e
  016141  58               pop ax
  016142  8b4404           mov ax, word ptr [si + 4]
  016145  8904             mov word ptr [si], ax
  016147  ff7502           push word ptr [di + 2]
  01614A  50               push ax
  01614B  33db             xor bx, bx
  01614D  8a5c07           mov bl, byte ptr [si + 7]
  016150  53               push bx
  016151  0e               push cs
  016152  e87709           call 0x16acc
  016155  83c406           add sp, 6
  016158  0bc0             or ax, ax
  01615A  7411             je 0x1616d
  01615C  3dffff           cmp ax, 0xffff
  01615F  751a             jne 0x1617b
  016161  804c0620         or byte ptr [si + 6], 0x20
  016165  eb0a             jmp 0x16171
  016167  804c0620         or byte ptr [si + 6], 0x20
  01616B  eb09             jmp 0x16176
  01616D  804c0610         or byte ptr [si + 6], 0x10
  016171  c744020000       mov word ptr [si + 2], 0
  016176  b8ffff           mov ax, 0xffff
  016179  eb24             jmp 0x1619f
  01617B  8abf7745         mov bh, byte ptr [bx + 0x4577]
  01617F  80e782           and bh, 0x82
  016182  80ff82           cmp bh, 0x82
  016185  750b             jne 0x16192
  016187  8a7c06           mov bh, byte ptr [si + 6]
  01618A  f6c782           test bh, 0x82
  01618D  7503             jne 0x16192
  01618F  800d20           or byte ptr [di], 0x20
  016192  48               dec ax
  016193  894402           mov word ptr [si + 2], ax
  016196  8b1c             mov bx, word ptr [si]
  016198  33c0             xor ax, ax
  01619A  8a07             mov al, byte ptr [bx]
  01619C  43               inc bx
  01619D  891c             mov word ptr [si], bx
  01619F  5f               pop di
  0161A0  5e               pop si
  0161A1  5d               pop bp
  0161A2  cb               retf
  0161A3  00               .byte 0x00
