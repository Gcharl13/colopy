; MAPEDIT.EXE named disasm — module PACK_3.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- PACK_READ_FILE  file 0x014C78..0x014CF2  seg 0x1367:0x8  (PACK_3.C.obj) ----
  014C78  55               push bp
  014C79  8bec             mov bp, sp
  014C7B  56               push si
  014C7C  833e925200       cmp word ptr [0x5292], 0
  014C81  7c21             jl 0x14ca4
  014C83  c45e06           les bx, ptr [bp + 6]
  014C86  268b07           mov ax, word ptr es:[bx]
  014C89  2bd2             sub dx, dx
  014C8B  3b169252         cmp dx, word ptr [0x5292]
  014C8F  7c0f             jl 0x14ca0
  014C91  7f06             jg 0x14c99
  014C93  3b069052         cmp ax, word ptr [0x5290]
  014C97  7607             jbe 0x14ca0
  014C99  8b169252         mov dx, word ptr [0x5292]
  014C9D  a19052           mov ax, word ptr [0x5290]
  014CA0  8bf0             mov si, ax
  014CA2  eb06             jmp 0x14caa
  014CA4  c45e06           les bx, ptr [bp + 6]
  014CA7  268b37           mov si, word ptr es:[bx]
  014CAA  0bf6             or si, si
  014CAC  743c             je 0x14cea
  014CAE  ff760c           push word ptr [bp + 0xc]
  014CB1  ff760a           push word ptr [bp + 0xa]
  014CB4  6a00             push 0
  014CB6  56               push si
  014CB7  b80100           mov ax, 1
  014CBA  99               cdq
  014CBB  8b1e7c4e         mov bx, word ptr [0x4e7c]
  014CBF  9a0000ca0b       lcall 0xbca, 0
  014CC4  8bf0             mov si, ax
  014CC6  833e925200       cmp word ptr [0x5292], 0
  014CCB  7c13             jl 0x14ce0
  014CCD  7f07             jg 0x14cd6
  014CCF  833e905200       cmp word ptr [0x5290], 0
  014CD4  740a             je 0x14ce0
  014CD6  2bc0             sub ax, ax
  014CD8  29369052         sub word ptr [0x5290], si
  014CDC  19069252         sbb word ptr [0x5292], ax
  014CE0  2bc0             sub ax, ax
  014CE2  01360a4b         add word ptr [0x4b0a], si
  014CE6  11060c4b         adc word ptr [0x4b0c], ax
  014CEA  8bc6             mov ax, si
  014CEC  5e               pop si
  014CED  c9               leave
  014CEE  ca0800           retf 8
  014CF1  90               nop
