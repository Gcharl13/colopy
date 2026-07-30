; MAPEDIT.EXE named disasm — module SORT_1.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @sort_insertion  file 0x01427E..0x014408  seg 0x12C7:0xe  (SORT_1.C.obj) ----
  01427E  c8180000         enter 0x18, 0
  014282  50               push ax
  014283  57               push di
  014284  56               push si
  014285  8bc8             mov cx, ax
  014287  49               dec cx
  014288  894eec           mov word ptr [bp - 0x14], cx
  01428B  2bc0             sub ax, ax
  01428D  8946fe           mov word ptr [bp - 2], ax
  014290  8946f4           mov word ptr [bp - 0xc], ax
  014293  8b56e6           mov dx, word ptr [bp - 0x1a]
  014296  3946ec           cmp word ptr [bp - 0x14], ax
  014299  7f03             jg 0x1429e
  01429B  e95b01           jmp 0x143f9
  01429E  8bc2             mov ax, dx
  0142A0  48               dec ax
  0142A1  d1e0             shl ax, 1
  0142A3  8946f2           mov word ptr [bp - 0xe], ax
  0142A6  2bc0             sub ax, ax
  0142A8  8946f6           mov word ptr [bp - 0xa], ax
  0142AB  8946f8           mov word ptr [bp - 8], ax
  0142AE  837efe00         cmp word ptr [bp - 2], 0
  0142B2  7403             je 0x142b7
  0142B4  e94201           jmp 0x143f9
  0142B7  c45e06           les bx, ptr [bp + 6]
  0142BA  035ef8           add bx, word ptr [bp - 8]
  0142BD  895ee8           mov word ptr [bp - 0x18], bx
  0142C0  8c46ea           mov word ptr [bp - 0x16], es
  0142C3  268b07           mov ax, word ptr es:[bx]
  0142C6  268b5702         mov dx, word ptr es:[bx + 2]
  0142CA  26395706         cmp word ptr es:[bx + 6], dx
  0142CE  7e03             jle 0x142d3
  0142D0  e90c01           jmp 0x143df
  0142D3  7c09             jl 0x142de
  0142D5  26394704         cmp word ptr es:[bx + 4], ax
  0142D9  7203             jb 0x142de
  0142DB  e90101           jmp 0x143df
  0142DE  8e46ea           mov es, word ptr [bp - 0x16]
  0142E1  268b07           mov ax, word ptr es:[bx]
  0142E4  268b5702         mov dx, word ptr es:[bx + 2]
  0142E8  8946fa           mov word ptr [bp - 6], ax
  0142EB  8956fc           mov word ptr [bp - 4], dx
  0142EE  c45e0a           les bx, ptr [bp + 0xa]
  0142F1  8b76f6           mov si, word ptr [bp - 0xa]
  0142F4  268b00           mov ax, word ptr es:[bx + si]
  0142F7  8946ee           mov word ptr [bp - 0x12], ax
  0142FA  8b7ef2           mov di, word ptr [bp - 0xe]
  0142FD  0bff             or di, di
  0142FF  7e3a             jle 0x1433b
  014301  8bc7             mov ax, di
  014303  d1e7             shl di, 1
  014305  57               push di
  014306  8b4ee8           mov cx, word ptr [bp - 0x18]
  014309  8b56ea           mov dx, word ptr [bp - 0x16]
  01430C  83c104           add cx, 4
  01430F  52               push dx
  014310  51               push cx
  014311  52               push dx
  014312  ff76e8           push word ptr [bp - 0x18]
  014315  8bf0             mov si, ax
  014317  9ab00e8813       lcall 0x1388, 0xeb0
  01431C  83c40a           add sp, 0xa
  01431F  56               push si
  014320  8b460a           mov ax, word ptr [bp + 0xa]
  014323  8b560c           mov dx, word ptr [bp + 0xc]
  014326  0346f6           add ax, word ptr [bp - 0xa]
  014329  8bc8             mov cx, ax
  01432B  8bda             mov bx, dx
  01432D  40               inc ax
  01432E  40               inc ax
  01432F  52               push dx
  014330  50               push ax
  014331  53               push bx
  014332  51               push cx
  014333  9ab00e8813       lcall 0x1388, 0xeb0
  014338  83c40a           add sp, 0xa
  01433B  2bff             sub di, di
  01433D  397eec           cmp word ptr [bp - 0x14], di
  014340  7e29             jle 0x1436b
  014342  c55e06           lds bx, ptr [bp + 6]
  014345  8b4efe           mov cx, word ptr [bp - 2]
  014348  0bc9             or cx, cx
  01434A  751f             jne 0x1436b
  01434C  8b46fa           mov ax, word ptr [bp - 6]
  01434F  8b56fc           mov dx, word ptr [bp - 4]
  014352  8bf3             mov si, bx
  014354  83c304           add bx, 4
  014357  395402           cmp word ptr [si + 2], dx
  01435A  7c09             jl 0x14365
  01435C  7f04             jg 0x14362
  01435E  3904             cmp word ptr [si], ax
  014360  7603             jbe 0x14365
  014362  b90100           mov cx, 1
  014365  47               inc di
  014366  397eec           cmp word ptr [bp - 0x14], di
  014369  7fdd             jg 0x14348
  01436B  b8e715           mov ax, 0x15e7
  01436E  8ed8             mov ds, ax
  014370  c746feffff       mov word ptr [bp - 2], 0xffff
  014375  8b76e6           mov si, word ptr [bp - 0x1a]
  014378  2bf7             sub si, di
  01437A  4e               dec si
  01437B  d1e6             shl si, 1
  01437D  0bf6             or si, si
  01437F  7e3a             jle 0x143bb
  014381  8bc6             mov ax, si
  014383  d1e6             shl si, 1
  014385  56               push si
  014386  8bcf             mov cx, di
  014388  c1e102           shl cx, 2
  01438B  034e06           add cx, word ptr [bp + 6]
  01438E  8b5608           mov dx, word ptr [bp + 8]
  014391  52               push dx
  014392  51               push cx
  014393  83c104           add cx, 4
  014396  52               push dx
  014397  51               push cx
  014398  8bf0             mov si, ax
  01439A  9ab00e8813       lcall 0x1388, 0xeb0
  01439F  83c40a           add sp, 0xa
  0143A2  56               push si
  0143A3  8bc7             mov ax, di
  0143A5  d1e0             shl ax, 1
  0143A7  03460a           add ax, word ptr [bp + 0xa]
  0143AA  8b560c           mov dx, word ptr [bp + 0xc]
  0143AD  52               push dx
  0143AE  50               push ax
  0143AF  40               inc ax
  0143B0  40               inc ax
  0143B1  52               push dx
  0143B2  50               push ax
  0143B3  9ab00e8813       lcall 0x1388, 0xeb0
  0143B8  83c40a           add sp, 0xa
  0143BB  8b46fa           mov ax, word ptr [bp - 6]
  0143BE  8b56fc           mov dx, word ptr [bp - 4]
  0143C1  8bdf             mov bx, di
  0143C3  8bcf             mov cx, di
  0143C5  c1e302           shl bx, 2
  0143C8  c47606           les si, ptr [bp + 6]
  0143CB  268900           mov word ptr es:[bx + si], ax
  0143CE  26895002         mov word ptr es:[bx + si + 2], dx
  0143D2  8b46ee           mov ax, word ptr [bp - 0x12]
  0143D5  8bd9             mov bx, cx
  0143D7  d1e3             shl bx, 1
  0143D9  c4760a           les si, ptr [bp + 0xa]
  0143DC  268900           mov word ptr es:[bx + si], ax
  0143DF  8346f602         add word ptr [bp - 0xa], 2
  0143E3  836ef202         sub word ptr [bp - 0xe], 2
  0143E7  8346f804         add word ptr [bp - 8], 4
  0143EB  ff46f4           inc word ptr [bp - 0xc]
  0143EE  8b46f4           mov ax, word ptr [bp - 0xc]
  0143F1  3946ec           cmp word ptr [bp - 0x14], ax
  0143F4  7e03             jle 0x143f9
  0143F6  e9b5fe           jmp 0x142ae
  0143F9  837efe00         cmp word ptr [bp - 2], 0
  0143FD  7403             je 0x14402
  0143FF  e989fe           jmp 0x1428b
  014402  5e               pop si
  014403  5f               pop di
  014404  c9               leave
  014405  ca0800           retf 8
