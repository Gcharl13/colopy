; MAPEDIT.EXE named disasm — module mem_4.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mem_conv_get_avail  file 0x00E6E8..0x00E702  seg 0xD08:0x68  (mem_4.c.obj) ----
  00E6E8  55               push bp
  00E6E9  8bec             mov bp, sp
  00E6EB  e8a0ff           call 0xe68e
  00E6EE  8bd8             mov bx, ax
  00E6F0  32f6             xor dh, dh
  00E6F2  8ad7             mov dl, bh
  00E6F4  c1e204           shl dx, 4
  00E6F7  8ad6             mov dl, dh
  00E6F9  32f6             xor dh, dh
  00E6FB  8bc3             mov ax, bx
  00E6FD  c1e004           shl ax, 4
  00E700  c9               leave
  00E701  cb               retf

; ---- @mem_get_avail  file 0x00E702..0x00E72A  seg 0xD08:0x82  (mem_4.c.obj) ----
  00E702  c8080000         enter 8, 0
  00E706  0e               push cs
  00E707  e8deff           call 0xe6e8
  00E70A  8946fc           mov word ptr [bp - 4], ax
  00E70D  8956fe           mov word ptr [bp - 2], dx
  00E710  9a0c007e12       lcall 0x127e, 0xc
  00E715  3b56fe           cmp dx, word ptr [bp - 2]
  00E718  7f0d             jg 0xe727
  00E71A  7c05             jl 0xe721
  00E71C  3b46fc           cmp ax, word ptr [bp - 4]
  00E71F  7306             jae 0xe727
  00E721  8b56fe           mov dx, word ptr [bp - 2]
  00E724  8b46fc           mov ax, word ptr [bp - 4]
  00E727  c9               leave
  00E728  cb               retf
  00E729  90               nop

; ---- @mem_set_video_mode  file 0x00E72A..0x00E72C  seg 0xD08:0xaa  (mem_4.c.obj) ----
  00E72A  cb               retf
  00E72B  90               nop
