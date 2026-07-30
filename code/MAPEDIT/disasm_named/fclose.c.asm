; MAPEDIT.EXE named disasm — module fclose.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _fclose  file 0x015142..0x0151FC  seg 0x1388:0x2c2  (fclose.c.obj) ----
  015142  55               push bp
  015143  8bec             mov bp, sp
  015145  83ec0e           sub sp, 0xe
  015148  57               push di
  015149  56               push si
  01514A  bfffff           mov di, 0xffff
  01514D  8b7606           mov si, word ptr [bp + 6]
  015150  f6440640         test byte ptr [si + 6], 0x40
  015154  7403             je 0x15159
  015156  e99700           jmp 0x151f0
  015159  f6440683         test byte ptr [si + 6], 0x83
  01515D  7503             jne 0x15162
  01515F  e98e00           jmp 0x151f0
  015162  56               push si
  015163  9ace158813       lcall 0x1388, 0x15ce
  015168  83c402           add sp, 2
  01516B  8bf8             mov di, ax
  01516D  8bde             mov bx, si
  01516F  81ebc646         sub bx, 0x46c6
  015173  8b876a47         mov ax, word ptr [bx + 0x476a]
  015177  8946fc           mov word ptr [bp - 4], ax
  01517A  56               push si
  01517B  e80a11           call 0x16288
  01517E  83c402           add sp, 2
  015181  8a4407           mov al, byte ptr [si + 7]
  015184  2ae4             sub ah, ah
  015186  50               push ax
  015187  9ab21b8813       lcall 0x1388, 0x1bb2
  01518C  83c402           add sp, 2
  01518F  0bc0             or ax, ax
  015191  7c5a             jl 0x151ed
  015193  837efc00         cmp word ptr [bp - 4], 0
  015197  7457             je 0x151f0
  015199  b8a445           mov ax, 0x45a4
  01519C  50               push ax
  01519D  8d46f2           lea ax, [bp - 0xe]
  0151A0  50               push ax
  0151A1  9a26068813       lcall 0x1388, 0x626
  0151A6  83c404           add sp, 4
  0151A9  8d46f4           lea ax, [bp - 0xc]
  0151AC  8946fe           mov word ptr [bp - 2], ax
  0151AF  807ef25c         cmp byte ptr [bp - 0xe], 0x5c
  0151B3  7413             je 0x151c8
  0151B5  b8a645           mov ax, 0x45a6
  0151B8  50               push ax
  0151B9  8d46f2           lea ax, [bp - 0xe]
  0151BC  50               push ax
  0151BD  9ae6058813       lcall 0x1388, 0x5e6
  0151C2  83c404           add sp, 4
  0151C5  eb04             jmp 0x151cb
  0151C7  90               nop
  0151C8  ff4efe           dec word ptr [bp - 2]
  0151CB  b80a00           mov ax, 0xa
  0151CE  50               push ax
  0151CF  ff76fe           push word ptr [bp - 2]
  0151D2  ff76fc           push word ptr [bp - 4]
  0151D5  9a3c078813       lcall 0x1388, 0x73c
  0151DA  83c406           add sp, 6
  0151DD  8d46f2           lea ax, [bp - 0xe]
  0151E0  50               push ax
  0151E1  9aa60a8813       lcall 0x1388, 0xaa6
  0151E6  83c402           add sp, 2
  0151E9  0bc0             or ax, ax
  0151EB  7403             je 0x151f0
  0151ED  bfffff           mov di, 0xffff
  0151F0  c6440600         mov byte ptr [si + 6], 0
  0151F4  8bc7             mov ax, di
  0151F6  5e               pop si
  0151F7  5f               pop di
  0151F8  8be5             mov sp, bp
  0151FA  5d               pop bp
  0151FB  cb               retf
