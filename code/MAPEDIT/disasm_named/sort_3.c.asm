; MAPEDIT.EXE named disasm — module sort_3.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @sort_insertion_8  file 0x014408..0x0144C8  seg 0x12E0:0x8  (sort_3.c.obj) ----
  014408  c8100000         enter 0x10, 0
  01440C  50               push ax
  01440D  57               push di
  01440E  56               push si
  01440F  c746f00000       mov word ptr [bp - 0x10], 0
  014414  1e               push ds
  014415  c47e06           les di, ptr [bp + 6]
  014418  8b76f0           mov si, word ptr [bp - 0x10]
  01441B  8bde             mov bx, si
  01441D  8b56ee           mov dx, word ptr [bp - 0x12]
  014420  4a               dec dx
  014421  3bf2             cmp si, dx
  014423  7c03             jl 0x14428
  014425  e99800           jmp 0x144c0
  014428  268a4101         mov al, byte ptr es:[bx + di + 1]
  01442C  263a01           cmp al, byte ptr es:[bx + di]
  01442F  7209             jb 0x1443a
  014431  46               inc si
  014432  83c301           add bx, 1
  014435  8976f0           mov word ptr [bp - 0x10], si
  014438  ebe7             jmp 0x14421
  01443A  8bca             mov cx, dx
  01443C  2bce             sub cx, si
  01443E  49               dec cx
  01443F  03fb             add di, bx
  014441  83c701           add di, 1
  014444  56               push si
  014445  51               push cx
  014446  06               push es
  014447  1f               pop ds
  014448  8bf7             mov si, di
  01444A  83c601           add si, 1
  01444D  0bc9             or cx, cx
  01444F  7402             je 0x14453
  014451  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  014453  59               pop cx
  014454  c5760a           lds si, ptr [bp + 0xa]
  014457  c47e0a           les di, ptr [bp + 0xa]
  01445A  5b               pop bx
  01445B  43               inc bx
  01445C  03f3             add si, bx
  01445E  03fb             add di, bx
  014460  46               inc si
  014461  268a15           mov dl, byte ptr es:[di]
  014464  0bc9             or cx, cx
  014466  7402             je 0x1446a
  014468  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  01446A  c47e06           les di, ptr [bp + 6]
  01446D  33f6             xor si, si
  01446F  33db             xor bx, bx
  014471  8b4eee           mov cx, word ptr [bp - 0x12]
  014474  49               dec cx
  014475  3bf1             cmp si, cx
  014477  7c03             jl 0x1447c
  014479  eb0d             jmp 0x14488
  01447B  90               nop
  01447C  263a01           cmp al, byte ptr es:[bx + di]
  01447F  7607             jbe 0x14488
  014481  46               inc si
  014482  83c301           add bx, 1
  014485  ebee             jmp 0x14475
  014487  90               nop
  014488  53               push bx
  014489  56               push si
  01448A  2bce             sub cx, si
  01448C  7421             je 0x144af
  01448E  51               push cx
  01448F  03fb             add di, bx
  014491  06               push es
  014492  1f               pop ds
  014493  03f9             add di, cx
  014495  8bf7             mov si, di
  014497  83ee01           sub si, 1
  01449A  fd               std
  01449B  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  01449D  c5760a           lds si, ptr [bp + 0xa]
  0144A0  59               pop cx
  0144A1  5f               pop di
  0144A2  57               push di
  0144A3  03fe             add di, si
  0144A5  1e               push ds
  0144A6  07               pop es
  0144A7  03f9             add di, cx
  0144A9  8bf7             mov si, di
  0144AB  4e               dec si
  0144AC  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  0144AE  fc               cld
  0144AF  c5760a           lds si, ptr [bp + 0xa]
  0144B2  5b               pop bx
  0144B3  3e8810           mov byte ptr ds:[bx + si], dl
  0144B6  c47e06           les di, ptr [bp + 6]
  0144B9  5b               pop bx
  0144BA  268801           mov byte ptr es:[bx + di], al
  0144BD  e958ff           jmp 0x14418
  0144C0  1f               pop ds
  0144C1  5e               pop si
  0144C2  5f               pop di
  0144C3  c9               leave
  0144C4  ca0800           retf 8
  0144C7  90               nop
