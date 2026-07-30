; MAPEDIT.EXE named disasm — module BUFFER_2.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_free  file 0x00DA66..0x00DA9E  seg 0xC46:0x6  (BUFFER_2.C.obj) ----
  00DA66  c8020000         enter 2, 0
  00DA6A  53               push bx
  00DA6B  c746fe0000       mov word ptr [bp - 2], 0
  00DA70  8b4706           mov ax, word ptr [bx + 6]
  00DA73  0b4704           or ax, word ptr [bx + 4]
  00DA76  7410             je 0xda88
  00DA78  ff7706           push word ptr [bx + 6]
  00DA7B  ff7704           push word ptr [bx + 4]
  00DA7E  9a1003c90c       lcall 0xcc9, 0x310
  00DA83  c746feffff       mov word ptr [bp - 2], 0xffff
  00DA88  8b5efc           mov bx, word ptr [bp - 4]
  00DA8B  2bc0             sub ax, ax
  00DA8D  894706           mov word ptr [bx + 6], ax
  00DA90  894704           mov word ptr [bx + 4], ax
  00DA93  894702           mov word ptr [bx + 2], ax
  00DA96  8907             mov word ptr [bx], ax
  00DA98  8b46fe           mov ax, word ptr [bp - 2]
  00DA9B  c9               leave
  00DA9C  cb               retf
  00DA9D  90               nop
