; MAPEDIT.EXE named disasm — module stackava.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _stackavail  file 0x01725E..0x017272  seg 0x1388:0x23de  (stackava.asm.obj) ----
  01725E  59               pop cx
  01725F  5a               pop dx
  017260  a1a245           mov ax, word ptr [0x45a2]
  017263  3bc4             cmp ax, sp
  017265  7307             jae 0x1726e
  017267  2bc4             sub ax, sp
  017269  f7d8             neg ax
  01726B  52               push dx
  01726C  51               push cx
  01726D  cb               retf
  01726E  33c0             xor ax, ax
  017270  ebf9             jmp 0x1726b
