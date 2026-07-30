; MAPEDIT.EXE named disasm — module growseg.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __growseg  file 0x0172C8..0x017354  seg 0x1388:0x2448  (growseg.asm.obj) ----
  0172C8  51               push cx
  0172C9  57               push di
  0172CA  f6470201         test byte ptr [bx + 2], 1
  0172CE  7463             je 0x17333
  0172D0  e8d200           call 0x173a5
  0172D3  8bfe             mov di, si
  0172D5  8b04             mov ax, word ptr [si]
  0172D7  a801             test al, 1
  0172D9  7403             je 0x172de
  0172DB  2bc8             sub cx, ax
  0172DD  49               dec cx
  0172DE  41               inc cx
  0172DF  41               inc cx
  0172E0  8b7704           mov si, word ptr [bx + 4]
  0172E3  0bf6             or si, si
  0172E5  744c             je 0x17333
  0172E7  03ce             add cx, si
  0172E9  7309             jae 0x172f4
  0172EB  33c0             xor ax, ax
  0172ED  baf0ff           mov dx, 0xfff0
  0172F0  e330             jcxz 0x17322
  0172F2  eb3f             jmp 0x17333
  0172F4  16               push ss
  0172F5  07               pop es
  0172F6  26a19248         mov ax, word ptr es:[0x4892]
  0172FA  3d0020           cmp ax, 0x2000
  0172FD  7416             je 0x17315
  0172FF  ba0080           mov dx, 0x8000
  017302  3bd0             cmp dx, ax
  017304  7206             jb 0x1730c
  017306  d1ea             shr dx, 1
  017308  75f8             jne 0x17302
  01730A  eb22             jmp 0x1732e
  01730C  83fa08           cmp dx, 8
  01730F  721d             jb 0x1732e
  017311  d1e2             shl dx, 1
  017313  8bc2             mov ax, dx
  017315  48               dec ax
  017316  8bd0             mov dx, ax
  017318  03c1             add ax, cx
  01731A  7302             jae 0x1731e
  01731C  33c0             xor ax, ax
  01731E  f7d2             not dx
  017320  23c2             and ax, dx
  017322  52               push dx
  017323  e82e00           call 0x17354
  017326  5a               pop dx
  017327  730d             jae 0x17336
  017329  83faf0           cmp dx, -0x10
  01732C  7405             je 0x17333
  01732E  b81000           mov ax, 0x10
  017331  ebe2             jmp 0x17315
  017333  f9               stc
  017334  eb1b             jmp 0x17351
  017336  8bd0             mov dx, ax
  017338  2b5704           sub dx, word ptr [bx + 4]
  01733B  894704           mov word ptr [bx + 4], ax
  01733E  897f08           mov word ptr [bx + 8], di
  017341  8b770a           mov si, word ptr [bx + 0xa]
  017344  4a               dec dx
  017345  8914             mov word ptr [si], dx
  017347  42               inc dx
  017348  03f2             add si, dx
  01734A  c704feff         mov word ptr [si], 0xfffe
  01734E  89770a           mov word ptr [bx + 0xa], si
  017351  5f               pop di
  017352  59               pop cx
  017353  c3               ret

; ---- __incseg  file 0x017354..0x0173A5  seg 0x1388:0x24d4  (growseg.asm.obj) ----
  017354  8bd0             mov dx, ax
  017356  f6470204         test byte ptr [bx + 2], 4
  01735A  740f             je 0x1736b
  01735C  4a               dec dx
  01735D  8b7704           mov si, word ptr [bx + 4]
  017360  4e               dec si
  017361  3bd6             cmp dx, si
  017363  7205             jb 0x1736a
  017365  3957fe           cmp word ptr [bx - 2], dx
  017368  7336             jae 0x173a0
  01736A  42               inc dx
  01736B  53               push bx
  01736C  51               push cx
  01736D  8cde             mov si, ds
  01736F  8ec6             mov es, si
  017371  b104             mov cl, 4
  017373  d3e8             shr ax, cl
  017375  7503             jne 0x1737a
  017377  b80010           mov ax, 0x1000
  01737A  f6470204         test byte ptr [bx + 2], 4
  01737E  740a             je 0x1738a
  017380  03c6             add ax, si
  017382  8b1e6e45         mov bx, word ptr [0x456e]
  017386  2bc3             sub ax, bx
  017388  8ec3             mov es, bx
  01738A  8bd8             mov bx, ax
  01738C  b44a             mov ah, 0x4a
  01738E  cd21             int 0x21
  017390  59               pop cx
  017391  5b               pop bx
  017392  7210             jb 0x173a4
  017394  8bc2             mov ax, dx
  017396  f6470204         test byte ptr [bx + 2], 4
  01739A  7404             je 0x173a0
  01739C  4a               dec dx
  01739D  8957fe           mov word ptr [bx - 2], dx
  0173A0  f8               clc
  0173A1  eb01             jmp 0x173a4
  0173A3  f9               stc
  0173A4  c3               ret

; ---- __findlast  file 0x0173A5..0x0173C6  seg 0x1388:0x2525  (growseg.asm.obj) ----
  0173A5  57               push di
  0173A6  8b7708           mov si, word ptr [bx + 8]
  0173A9  3b770a           cmp si, word ptr [bx + 0xa]
  0173AC  7503             jne 0x173b1
  0173AE  8b7706           mov si, word ptr [bx + 6]
  0173B1  ad               lodsw ax, word ptr [si]
  0173B2  3dfeff           cmp ax, 0xfffe
  0173B5  7408             je 0x173bf
  0173B7  8bfe             mov di, si
  0173B9  24fe             and al, 0xfe
  0173BB  03f0             add si, ax
  0173BD  ebf2             jmp 0x173b1
  0173BF  4f               dec di
  0173C0  4f               dec di
  0173C1  8bf7             mov si, di
  0173C3  5f               pop di
  0173C4  c3               ret
  0173C5  00               .byte 0x00
