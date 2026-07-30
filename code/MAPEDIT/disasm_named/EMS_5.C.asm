; MAPEDIT.EXE named disasm — module EMS_5.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @ems_map_buffer  file 0x0145B6..0x01462A  seg 0x12FB:0x6  (EMS_5.C.obj) ----
  0145B6  c80e0000         enter 0xe, 0
  0145BA  50               push ax
  0145BB  56               push si
  0145BC  b8ffff           mov ax, 0xffff
  0145BF  8946fc           mov word ptr [bp - 4], ax
  0145C2  8946fe           mov word ptr [bp - 2], ax
  0145C5  833e7a4400       cmp word ptr [0x447a], 0
  0145CA  7457             je 0x14623
  0145CC  c746fa0000       mov word ptr [bp - 6], 0
  0145D1  8b46f0           mov ax, word ptr [bp - 0x10]
  0145D4  8b56fe           mov dx, word ptr [bp - 2]
  0145D7  9ac4014511       lcall 0x1145, 0x1c4
  0145DC  8946fe           mov word ptr [bp - 2], ax
  0145DF  8b76fa           mov si, word ptr [bp - 6]
  0145E2  d1e6             shl si, 1
  0145E4  8942f2           mov word ptr [bp + si - 0xe], ax
  0145E7  ff46fa           inc word ptr [bp - 6]
  0145EA  837efa04         cmp word ptr [bp - 6], 4
  0145EE  7ce1             jl 0x145d1
  0145F0  c746fa0000       mov word ptr [bp - 6], 0
  0145F5  eb04             jmp 0x145fb
  0145F7  90               nop
  0145F8  ff46fa           inc word ptr [bp - 6]
  0145FB  837efa04         cmp word ptr [bp - 6], 4
  0145FF  7d1d             jge 0x1461e
  014601  8b76fa           mov si, word ptr [bp - 6]
  014604  d1e6             shl si, 1
  014606  ff72f2           push word ptr [bp + si - 0xe]
  014609  ff76fa           push word ptr [bp - 6]
  01460C  9ad4002d11       lcall 0x112d, 0xd4
  014611  83c404           add sp, 4
  014614  0bc0             or ax, ax
  014616  74e0             je 0x145f8
  014618  8b46fc           mov ax, word ptr [bp - 4]
  01461B  5e               pop si
  01461C  c9               leave
  01461D  cb               retf
  01461E  c746fc0000       mov word ptr [bp - 4], 0
  014623  8b46fc           mov ax, word ptr [bp - 4]
  014626  5e               pop si
  014627  c9               leave
  014628  cb               retf
  014629  90               nop
