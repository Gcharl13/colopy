; MAPEDIT.EXE named disasm — module flength.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _filelength  file 0x0157E2..0x015868  seg 0x1388:0x962  (flength.c.obj) ----
  0157E2  55               push bp
  0157E3  8bec             mov bp, sp
  0157E5  83ec08           sub sp, 8
  0157E8  56               push si
  0157E9  8b7606           mov si, word ptr [bp + 6]
  0157EC  0bf6             or si, si
  0157EE  7c06             jl 0x157f6
  0157F0  39367545         cmp word ptr [0x4575], si
  0157F4  7f0c             jg 0x15802
  0157F6  c70668450900     mov word ptr [0x4568], 9
  0157FC  b8ffff           mov ax, 0xffff
  0157FF  99               cdq
  015800  eb61             jmp 0x15863
  015802  b80100           mov ax, 1
  015805  50               push ax
  015806  2bc0             sub ax, ax
  015808  50               push ax
  015809  50               push ax
  01580A  56               push si
  01580B  9ad21b8813       lcall 0x1388, 0x1bd2
  015810  83c408           add sp, 8
  015813  8946f8           mov word ptr [bp - 8], ax
  015816  8956fa           mov word ptr [bp - 6], dx
  015819  3dffff           cmp ax, 0xffff
  01581C  750c             jne 0x1582a
  01581E  3bd0             cmp dx, ax
  015820  7508             jne 0x1582a
  015822  8946fc           mov word ptr [bp - 4], ax
  015825  8946fe           mov word ptr [bp - 2], ax
  015828  eb33             jmp 0x1585d
  01582A  b80200           mov ax, 2
  01582D  50               push ax
  01582E  2bc0             sub ax, ax
  015830  50               push ax
  015831  50               push ax
  015832  56               push si
  015833  9ad21b8813       lcall 0x1388, 0x1bd2
  015838  83c408           add sp, 8
  01583B  8946fc           mov word ptr [bp - 4], ax
  01583E  8956fe           mov word ptr [bp - 2], dx
  015841  3b46f8           cmp ax, word ptr [bp - 8]
  015844  7505             jne 0x1584b
  015846  3b56fa           cmp dx, word ptr [bp - 6]
  015849  7412             je 0x1585d
  01584B  2bc0             sub ax, ax
  01584D  50               push ax
  01584E  ff76fa           push word ptr [bp - 6]
  015851  ff76f8           push word ptr [bp - 8]
  015854  56               push si
  015855  9ad21b8813       lcall 0x1388, 0x1bd2
  01585A  83c408           add sp, 8
  01585D  8b46fc           mov ax, word ptr [bp - 4]
  015860  8b56fe           mov dx, word ptr [bp - 2]
  015863  5e               pop si
  015864  8be5             mov sp, bp
  015866  5d               pop bp
  015867  cb               retf
