; MAPEDIT.EXE named disasm — module himem_6.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _himem_shutdown  file 0x0109EC..0x010A3A  seg 0xF3E:0xc  (himem_6.c.obj) ----
  0109EC  56               push si
  0109ED  9a06009012       lcall 0x1290, 6
  0109F2  0bc0             or ax, ax
  0109F4  7523             jne 0x10a19
  0109F6  2bf6             sub si, si
  0109F8  8bc6             mov ax, si
  0109FA  9a0a009212       lcall 0x1292, 0xa
  0109FF  c41e564b         les bx, ptr [0x4b56]
  010A03  26803f04         cmp byte ptr es:[bx], 4
  010A07  7509             jne 0x10a12
  010A09  268b4712         mov ax, word ptr es:[bx + 0x12]
  010A0D  9a40008b12       lcall 0x128b, 0x40
  010A12  46               inc si
  010A13  81fe9600         cmp si, 0x96
  010A17  7cdf             jl 0x109f8
  010A19  803efa4404       cmp byte ptr [0x44fa], 4
  010A1E  7508             jne 0x10a28
  010A20  a10045           mov ax, word ptr [0x4500]
  010A23  9a40008b12       lcall 0x128b, 0x40
  010A28  c70604450000     mov word ptr [0x4504], 0
  010A2E  9a00008912       lcall 0x1289, 0
  010A33  9aba002d11       lcall 0x112d, 0xba
  010A38  5e               pop si
  010A39  cb               retf

; ---- _himem_startup  file 0x010A3A..0x010A50  seg 0xF3E:0x5a  (himem_6.c.obj) ----
  010A3A  9a06002d11       lcall 0x112d, 6
  010A3F  9a36004511       lcall 0x1145, 0x36
  010A44  9a0a00360f       lcall 0xf36, 0xa
  010A49  9a0e009712       lcall 0x1297, 0xe
  010A4E  cb               retf
  010A4F  90               nop
