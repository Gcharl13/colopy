; MAPEDIT.EXE named disasm — module HIMEM_1.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _himem_activate_directory  file 0x013F06..0x013F2A  seg 0x1290:0x6  (HIMEM_1.C.obj) ----
  013F06  56               push si
  013F07  2bf6             sub si, si
  013F09  803efa4403       cmp byte ptr [0x44fa], 3
  013F0E  7516             jne 0x13f26
  013F10  9a0c004511       lcall 0x1145, 0xc
  013F15  3d0100           cmp ax, 1
  013F18  1bc0             sbb ax, ax
  013F1A  f7d8             neg ax
  013F1C  a30245           mov word ptr [0x4502], ax
  013F1F  3d0100           cmp ax, 1
  013F22  1bf6             sbb si, si
  013F24  f7de             neg si
  013F26  8bc6             mov ax, si
  013F28  5e               pop si
  013F29  cb               retf
