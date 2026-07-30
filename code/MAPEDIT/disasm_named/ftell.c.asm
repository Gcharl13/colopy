; MAPEDIT.EXE named disasm — module ftell.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _ftell  file 0x016D76..0x016EEC  seg 0x1388:0x1ef6  (ftell.c.obj) ----
  016D76  55               push bp
  016D77  8bec             mov bp, sp
  016D79  83ec0e           sub sp, 0xe
  016D7C  57               push di
  016D7D  56               push si
  016D7E  8b7606           mov si, word ptr [bp + 6]
  016D81  8bc6             mov ax, si
  016D83  2dc646           sub ax, 0x46c6
  016D86  056647           add ax, 0x4766
  016D89  8946f2           mov word ptr [bp - 0xe], ax
  016D8C  8a4407           mov al, byte ptr [si + 7]
  016D8F  2ae4             sub ah, ah
  016D91  8946f6           mov word ptr [bp - 0xa], ax
  016D94  837c0200         cmp word ptr [si + 2], 0
  016D98  7d05             jge 0x16d9f
  016D9A  c744020000       mov word ptr [si + 2], 0
  016D9F  b80100           mov ax, 1
  016DA2  50               push ax
  016DA3  2bc0             sub ax, ax
  016DA5  50               push ax
  016DA6  50               push ax
  016DA7  ff76f6           push word ptr [bp - 0xa]
  016DAA  9ad21b8813       lcall 0x1388, 0x1bd2
  016DAF  83c408           add sp, 8
  016DB2  8946fc           mov word ptr [bp - 4], ax
  016DB5  8956fe           mov word ptr [bp - 2], dx
  016DB8  0bd2             or dx, dx
  016DBA  7d08             jge 0x16dc4
  016DBC  b8ffff           mov ax, 0xffff
  016DBF  99               cdq
  016DC0  e92301           jmp 0x16ee6
  016DC3  90               nop
  016DC4  f6440608         test byte ptr [si + 6], 8
  016DC8  751e             jne 0x16de8
  016DCA  8b5ef2           mov bx, word ptr [bp - 0xe]
  016DCD  f60701           test byte ptr [bx], 1
  016DD0  7516             jne 0x16de8
  016DD2  8b4402           mov ax, word ptr [si + 2]
  016DD5  99               cdq
  016DD6  8bc8             mov cx, ax
  016DD8  8bda             mov bx, dx
  016DDA  8b46fc           mov ax, word ptr [bp - 4]
  016DDD  8b56fe           mov dx, word ptr [bp - 2]
  016DE0  2bc1             sub ax, cx
  016DE2  1bd3             sbb dx, bx
  016DE4  e9ff00           jmp 0x16ee6
  016DE7  90               nop
  016DE8  8b04             mov ax, word ptr [si]
  016DEA  2b4404           sub ax, word ptr [si + 4]
  016DED  8946f8           mov word ptr [bp - 8], ax
  016DF0  f6440603         test byte ptr [si + 6], 3
  016DF4  742e             je 0x16e24
  016DF6  8b5ef6           mov bx, word ptr [bp - 0xa]
  016DF9  f687774580       test byte ptr [bx + 0x4577], 0x80
  016DFE  7413             je 0x16e13
  016E00  8b7c04           mov di, word ptr [si + 4]
  016E03  eb0a             jmp 0x16e0f
  016E05  90               nop
  016E06  803d0a           cmp byte ptr [di], 0xa
  016E09  7503             jne 0x16e0e
  016E0B  ff46f8           inc word ptr [bp - 8]
  016E0E  47               inc di
  016E0F  393c             cmp word ptr [si], di
  016E11  77f3             ja 0x16e06
  016E13  8b46fe           mov ax, word ptr [bp - 2]
  016E16  0b46fc           or ax, word ptr [bp - 4]
  016E19  7517             jne 0x16e32
  016E1B  8b46f8           mov ax, word ptr [bp - 8]
  016E1E  2bd2             sub dx, dx
  016E20  e9c300           jmp 0x16ee6
  016E23  90               nop
  016E24  f6440680         test byte ptr [si + 6], 0x80
  016E28  75e9             jne 0x16e13
  016E2A  c70668451600     mov word ptr [0x4568], 0x16
  016E30  eb8a             jmp 0x16dbc
  016E32  f6440601         test byte ptr [si + 6], 1
  016E36  7503             jne 0x16e3b
  016E38  e99f00           jmp 0x16eda
  016E3B  837c0200         cmp word ptr [si + 2], 0
  016E3F  7509             jne 0x16e4a
  016E41  c746f80000       mov word ptr [bp - 8], 0
  016E46  e99100           jmp 0x16eda
  016E49  90               nop
  016E4A  8b04             mov ax, word ptr [si]
  016E4C  2b4404           sub ax, word ptr [si + 4]
  016E4F  034402           add ax, word ptr [si + 2]
  016E52  8946f4           mov word ptr [bp - 0xc], ax
  016E55  8b5ef6           mov bx, word ptr [bp - 0xa]
  016E58  f687774580       test byte ptr [bx + 0x4577], 0x80
  016E5D  7470             je 0x16ecf
  016E5F  b90200           mov cx, 2
  016E62  51               push cx
  016E63  2bc9             sub cx, cx
  016E65  51               push cx
  016E66  51               push cx
  016E67  53               push bx
  016E68  9ad21b8813       lcall 0x1388, 0x1bd2
  016E6D  83c408           add sp, 8
  016E70  3b46fc           cmp ax, word ptr [bp - 4]
  016E73  752f             jne 0x16ea4
  016E75  3b56fe           cmp dx, word ptr [bp - 2]
  016E78  752a             jne 0x16ea4
  016E7A  8b46f4           mov ax, word ptr [bp - 0xc]
  016E7D  034404           add ax, word ptr [si + 4]
  016E80  8946fa           mov word ptr [bp - 6], ax
  016E83  8b7c04           mov di, word ptr [si + 4]
  016E86  eb09             jmp 0x16e91
  016E88  803d0a           cmp byte ptr [di], 0xa
  016E8B  7503             jne 0x16e90
  016E8D  ff46f4           inc word ptr [bp - 0xc]
  016E90  47               inc di
  016E91  397efa           cmp word ptr [bp - 6], di
  016E94  77f2             ja 0x16e88
  016E96  8b5ef2           mov bx, word ptr [bp - 0xe]
  016E99  f60720           test byte ptr [bx], 0x20
  016E9C  7431             je 0x16ecf
  016E9E  ff46f4           inc word ptr [bp - 0xc]
  016EA1  eb2c             jmp 0x16ecf
  016EA3  90               nop
  016EA4  2bc0             sub ax, ax
  016EA6  50               push ax
  016EA7  ff76fe           push word ptr [bp - 2]
  016EAA  ff76fc           push word ptr [bp - 4]
  016EAD  ff76f6           push word ptr [bp - 0xa]
  016EB0  9ad21b8813       lcall 0x1388, 0x1bd2
  016EB5  83c408           add sp, 8
  016EB8  8b5ef2           mov bx, word ptr [bp - 0xe]
  016EBB  8b4702           mov ax, word ptr [bx + 2]
  016EBE  8946f4           mov word ptr [bp - 0xc], ax
  016EC1  8b5ef6           mov bx, word ptr [bp - 0xa]
  016EC4  f687774504       test byte ptr [bx + 0x4577], 4
  016EC9  7404             je 0x16ecf
  016ECB  40               inc ax
  016ECC  8946f4           mov word ptr [bp - 0xc], ax
  016ECF  8b46f4           mov ax, word ptr [bp - 0xc]
  016ED2  2bd2             sub dx, dx
  016ED4  2946fc           sub word ptr [bp - 4], ax
  016ED7  1956fe           sbb word ptr [bp - 2], dx
  016EDA  8b46fc           mov ax, word ptr [bp - 4]
  016EDD  8b56fe           mov dx, word ptr [bp - 2]
  016EE0  0346f8           add ax, word ptr [bp - 8]
  016EE3  83d200           adc dx, 0
  016EE6  5e               pop si
  016EE7  5f               pop di
  016EE8  8be5             mov sp, bp
  016EEA  5d               pop bp
  016EEB  cb               retf
