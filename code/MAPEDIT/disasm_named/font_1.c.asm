; MAPEDIT.EXE named disasm — module font_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @font_load  file 0x00EA3A..0x00EB38  seg 0xD43:0xa  (font_1.c.obj) ----
  00EA3A  c83e0100         enter 0x13e, 0
  00EA3E  53               push bx
  00EA3F  57               push di
  00EA40  56               push si
  00EA41  2bc0             sub ax, ax
  00EA43  99               cdq
  00EA44  8bf0             mov si, ax
  00EA46  8956f6           mov word ptr [bp - 0xa], dx
  00EA49  8946f2           mov word ptr [bp - 0xe], ax
  00EA4C  8946f0           mov word ptr [bp - 0x10], ax
  00EA4F  c7064c070f00     mov word ptr [0x74c], 0xf
  00EA55  8986c2fe         mov word ptr [bp - 0x13e], ax
  00EA59  53               push bx
  00EA5A  8d468c           lea ax, [bp - 0x74]
  00EA5D  50               push ax
  00EA5E  9a26068813       lcall 0x1388, 0x626
  00EA63  83c404           add sp, 4
  00EA66  6a2e             push 0x2e
  00EA68  8d468c           lea ax, [bp - 0x74]
  00EA6B  50               push ax
  00EA6C  9ae8098813       lcall 0x1388, 0x9e8
  00EA71  83c404           add sp, 4
  00EA74  0bc0             or ax, ax
  00EA76  750f             jne 0xea87
  00EA78  688e3a           push 0x3a8e
  00EA7B  8d468c           lea ax, [bp - 0x74]
  00EA7E  50               push ax
  00EA7F  9ae6058813       lcall 0x1388, 0x5e6
  00EA84  83c404           add sp, 4
  00EA87  8d7e8c           lea di, [bp - 0x74]
  00EA8A  803d2a           cmp byte ptr [di], 0x2a
  00EA8D  7503             jne 0xea92
  00EA8F  8d7e8d           lea di, [bp - 0x73]
  00EA92  6a08             push 8
  00EA94  57               push di
  00EA95  8d46dc           lea ax, [bp - 0x24]
  00EA98  50               push ax
  00EA99  9ad6068813       lcall 0x1388, 0x6d6
  00EA9E  83c406           add sp, 6
  00EAA1  8d86c2fe         lea ax, [bp - 0x13e]
  00EAA5  16               push ss
  00EAA6  50               push ax
  00EAA7  8d468c           lea ax, [bp - 0x74]
  00EAAA  16               push ss
  00EAAB  50               push ax
  00EAAC  8d1e923a         lea bx, [0x3a92]
  00EAB0  b8ffff           mov ax, 0xffff
  00EAB3  9a00001a12       lcall 0x121a, 0
  00EAB8  0bc0             or ax, ax
  00EABA  7547             jne 0xeb03
  00EABC  8d46dc           lea ax, [bp - 0x24]
  00EABF  16               push ss
  00EAC0  50               push ax
  00EAC1  8b86eefe         mov ax, word ptr [bp - 0x112]
  00EAC5  8b96f0fe         mov dx, word ptr [bp - 0x110]
  00EAC9  8946f8           mov word ptr [bp - 8], ax
  00EACC  8956fa           mov word ptr [bp - 6], dx
  00EACF  9a3601c90c       lcall 0xcc9, 0x136
  00EAD4  8bf0             mov si, ax
  00EAD6  8956f6           mov word ptr [bp - 0xa], dx
  00EAD9  0bd0             or dx, ax
  00EADB  7426             je 0xeb03
  00EADD  ff76f6           push word ptr [bp - 0xa]
  00EAE0  56               push si
  00EAE1  6a00             push 0
  00EAE3  6a01             push 1
  00EAE5  8d86c2fe         lea ax, [bp - 0x13e]
  00EAE9  16               push ss
  00EAEA  50               push ax
  00EAEB  8b46f8           mov ax, word ptr [bp - 8]
  00EAEE  8b56fa           mov dx, word ptr [bp - 6]
  00EAF1  9a02005812       lcall 0x1258, 2
  00EAF6  0bd0             or dx, ax
  00EAF8  7409             je 0xeb03
  00EAFA  8b46f6           mov ax, word ptr [bp - 0xa]
  00EAFD  8976f0           mov word ptr [bp - 0x10], si
  00EB00  8946f2           mov word ptr [bp - 0xe], ax
  00EB03  8b46f6           mov ax, word ptr [bp - 0xa]
  00EB06  0bc6             or ax, si
  00EB08  7412             je 0xeb1c
  00EB0A  8b46f2           mov ax, word ptr [bp - 0xe]
  00EB0D  0b46f0           or ax, word ptr [bp - 0x10]
  00EB10  750a             jne 0xeb1c
  00EB12  8b46f6           mov ax, word ptr [bp - 0xa]
  00EB15  50               push ax
  00EB16  56               push si
  00EB17  9a1003c90c       lcall 0xcc9, 0x310
  00EB1C  83bec2fe00       cmp word ptr [bp - 0x13e], 0
  00EB21  740b             je 0xeb2e
  00EB23  8d86c2fe         lea ax, [bp - 0x13e]
  00EB27  16               push ss
  00EB28  50               push ax
  00EB29  9a4e031a12       lcall 0x121a, 0x34e
  00EB2E  8b46f0           mov ax, word ptr [bp - 0x10]
  00EB31  8b56f2           mov dx, word ptr [bp - 0xe]
  00EB34  5e               pop si
  00EB35  5f               pop di
  00EB36  c9               leave
  00EB37  cb               retf
