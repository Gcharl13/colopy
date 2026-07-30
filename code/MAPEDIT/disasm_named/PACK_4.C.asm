; MAPEDIT.EXE named disasm — module PACK_4.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- PACK_WRITE_FILE  file 0x014CF2..0x014D84  seg 0x136F:0x2  (PACK_4.C.obj) ----
  014CF2  c8040000         enter 4, 0
  014CF6  56               push si
  014CF7  833e864a00       cmp word ptr [0x4a86], 0
  014CFC  7c22             jl 0x14d20
  014CFE  c45e06           les bx, ptr [bp + 6]
  014D01  268b07           mov ax, word ptr es:[bx]
  014D04  2bd2             sub dx, dx
  014D06  3b16864a         cmp dx, word ptr [0x4a86]
  014D0A  7c0f             jl 0x14d1b
  014D0C  7f06             jg 0x14d14
  014D0E  3b06844a         cmp ax, word ptr [0x4a84]
  014D12  7607             jbe 0x14d1b
  014D14  8b16864a         mov dx, word ptr [0x4a86]
  014D18  a1844a           mov ax, word ptr [0x4a84]
  014D1B  8bf0             mov si, ax
  014D1D  eb07             jmp 0x14d26
  014D1F  90               nop
  014D20  c45e06           les bx, ptr [bp + 6]
  014D23  268b37           mov si, word ptr es:[bx]
  014D26  0bf6             or si, si
  014D28  7452             je 0x14d7c
  014D2A  ff760c           push word ptr [bp + 0xc]
  014D2D  ff760a           push word ptr [bp + 0xa]
  014D30  6a00             push 0
  014D32  6a01             push 1
  014D34  8bc6             mov ax, si
  014D36  2bd2             sub dx, dx
  014D38  8946fc           mov word ptr [bp - 4], ax
  014D3B  8956fe           mov word ptr [bp - 2], dx
  014D3E  8b1e7a4e         mov bx, word ptr [0x4e7a]
  014D42  9a0800ea0b       lcall 0xbea, 8
  014D47  0bd0             or dx, ax
  014D49  7505             jne 0x14d50
  014D4B  2bf6             sub si, si
  014D4D  eb2d             jmp 0x14d7c
  014D4F  90               nop
  014D50  833e864a00       cmp word ptr [0x4a86], 0
  014D55  7c17             jl 0x14d6e
  014D57  7f07             jg 0x14d60
  014D59  833e844a00       cmp word ptr [0x4a84], 0
  014D5E  740e             je 0x14d6e
  014D60  8b46fc           mov ax, word ptr [bp - 4]
  014D63  8b56fe           mov dx, word ptr [bp - 2]
  014D66  2906844a         sub word ptr [0x4a84], ax
  014D6A  1916864a         sbb word ptr [0x4a86], dx
  014D6E  8b46fc           mov ax, word ptr [bp - 4]
  014D71  8b56fe           mov dx, word ptr [bp - 2]
  014D74  01068469         add word ptr [0x6984], ax
  014D78  11168669         adc word ptr [0x6986], dx
  014D7C  8bc6             mov ax, si
  014D7E  5e               pop si
  014D7F  c9               leave
  014D80  ca0800           retf 8
  014D83  90               nop
