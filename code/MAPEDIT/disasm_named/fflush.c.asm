; MAPEDIT.EXE named disasm — module fflush.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _fflush  file 0x01644E..0x0164C2  seg 0x1388:0x15ce  (fflush.c.obj) ----
  01644E  55               push bp
  01644F  8bec             mov bp, sp
  016451  83ec02           sub sp, 2
  016454  57               push di
  016455  56               push si
  016456  2bff             sub di, di
  016458  397e06           cmp word ptr [bp + 6], di
  01645B  7509             jne 0x16466
  01645D  2bc0             sub ax, ax
  01645F  50               push ax
  016460  e86700           call 0x164ca
  016463  eb57             jmp 0x164bc
  016465  90               nop
  016466  8b7606           mov si, word ptr [bp + 6]
  016469  8a4406           mov al, byte ptr [si + 6]
  01646C  8bc8             mov cx, ax
  01646E  2403             and al, 3
  016470  3c02             cmp al, 2
  016472  753c             jne 0x164b0
  016474  f6c108           test cl, 8
  016477  750d             jne 0x16486
  016479  8bde             mov bx, si
  01647B  81ebc646         sub bx, 0x46c6
  01647F  f687664701       test byte ptr [bx + 0x4766], 1
  016484  742a             je 0x164b0
  016486  8b04             mov ax, word ptr [si]
  016488  2b4404           sub ax, word ptr [si + 4]
  01648B  8946fe           mov word ptr [bp - 2], ax
  01648E  0bc0             or ax, ax
  016490  7e1e             jle 0x164b0
  016492  50               push ax
  016493  ff7404           push word ptr [si + 4]
  016496  8a4c07           mov cl, byte ptr [si + 7]
  016499  2aed             sub ch, ch
  01649B  51               push cx
  01649C  9a361d8813       lcall 0x1388, 0x1d36
  0164A1  83c406           add sp, 6
  0164A4  3946fe           cmp word ptr [bp - 2], ax
  0164A7  7407             je 0x164b0
  0164A9  804c0620         or byte ptr [si + 6], 0x20
  0164AD  bfffff           mov di, 0xffff
  0164B0  8b4404           mov ax, word ptr [si + 4]
  0164B3  8904             mov word ptr [si], ax
  0164B5  c744020000       mov word ptr [si + 2], 0
  0164BA  8bc7             mov ax, di
  0164BC  5e               pop si
  0164BD  5f               pop di
  0164BE  8be5             mov sp, bp
  0164C0  5d               pop bp
  0164C1  cb               retf

; ---- _flushall  file 0x0164C2..0x016526  seg 0x1388:0x1642  (fflush.c.obj) ----
  0164C2  b80100           mov ax, 1
  0164C5  50               push ax
  0164C6  e80100           call 0x164ca
  0164C9  cb               retf
  0164CA  55               push bp
  0164CB  8bec             mov bp, sp
  0164CD  83ec02           sub sp, 2
  0164D0  57               push di
  0164D1  56               push si
  0164D2  bec646           mov si, 0x46c6
  0164D5  2bff             sub di, di
  0164D7  897efe           mov word ptr [bp - 2], di
  0164DA  eb08             jmp 0x164e4
  0164DC  c746feffff       mov word ptr [bp - 2], 0xffff
  0164E1  83c608           add si, 8
  0164E4  39360648         cmp word ptr [0x4806], si
  0164E8  7216             jb 0x16500
  0164EA  f6440683         test byte ptr [si + 6], 0x83
  0164EE  74f1             je 0x164e1
  0164F0  56               push si
  0164F1  9ace158813       lcall 0x1388, 0x15ce
  0164F6  83c402           add sp, 2
  0164F9  40               inc ax
  0164FA  74e0             je 0x164dc
  0164FC  47               inc di
  0164FD  ebe2             jmp 0x164e1
  0164FF  90               nop
  016500  837e0401         cmp word ptr [bp + 4], 1
  016504  7504             jne 0x1650a
  016506  8bc7             mov ax, di
  016508  eb03             jmp 0x1650d
  01650A  8b46fe           mov ax, word ptr [bp - 2]
  01650D  5e               pop si
  01650E  5f               pop di
  01650F  8be5             mov sp, bp
  016511  5d               pop bp
  016512  c20200           ret 2
  016515  90               nop
  016516  fd               std
  016517  16               push ss
  016518  0817             or byte ptr [bx], dl
  01651A  1c17             sbb al, 0x17
  01651C  50               push ax
  01651D  17               pop ss
  01651E  7c17             jl 0x16537
  016520  8417             test byte ptr [bx], dl
  016522  ad               lodsw ax, word ptr [si]
  016523  17               pop ss
  016524  df17             fist word ptr [bx]
