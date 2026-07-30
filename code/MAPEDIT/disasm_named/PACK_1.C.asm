; MAPEDIT.EXE named disasm — module PACK_1.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- PACK_READ_MEMORY  file 0x014B96..0x014C0A  seg 0x1359:0x6  (PACK_1.C.obj) ----
  014B96  c8020000         enter 2, 0
  014B9A  57               push di
  014B9B  56               push si
  014B9C  c47e06           les di, ptr [bp + 6]
  014B9F  268b0d           mov cx, word ptr es:[di]
  014BA2  a19052           mov ax, word ptr [0x5290]
  014BA5  8b169252         mov dx, word ptr [0x5292]
  014BA9  83faff           cmp dx, -1
  014BAC  741c             je 0x14bca
  014BAE  50               push ax
  014BAF  0bc2             or ax, dx
  014BB1  58               pop ax
  014BB2  7436             je 0x14bea
  014BB4  0bd2             or dx, dx
  014BB6  7506             jne 0x14bbe
  014BB8  3bc8             cmp cx, ax
  014BBA  7602             jbe 0x14bbe
  014BBC  8bc8             mov cx, ax
  014BBE  2bc1             sub ax, cx
  014BC0  83da00           sbb dx, 0
  014BC3  a39052           mov word ptr [0x5290], ax
  014BC6  89169252         mov word ptr [0x5292], dx
  014BCA  010e0a4b         add word ptr [0x4b0a], cx
  014BCE  83160c4b00       adc word ptr [0x4b0c], 0
  014BD3  8bc1             mov ax, cx
  014BD5  0bc9             or cx, cx
  014BD7  7411             je 0x14bea
  014BD9  1e               push ds
  014BDA  c47e0a           les di, ptr [bp + 0xa]
  014BDD  c5364863         lds si, ptr [0x6348]
  014BE1  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  014BE3  8bd6             mov dx, si
  014BE5  1f               pop ds
  014BE6  89164863         mov word ptr [0x6348], dx
  014BEA  8946fe           mov word ptr [bp - 2], ax
  014BED  ff364a63         push word ptr [0x634a]
  014BF1  ff364863         push word ptr [0x6348]
  014BF5  9a02004f10       lcall 0x104f, 2
  014BFA  a34863           mov word ptr [0x6348], ax
  014BFD  89164a63         mov word ptr [0x634a], dx
  014C01  8b46fe           mov ax, word ptr [bp - 2]
  014C04  5e               pop si
  014C05  5f               pop di
  014C06  c9               leave
  014C07  ca0800           retf 8
