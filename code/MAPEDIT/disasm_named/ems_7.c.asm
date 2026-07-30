; MAPEDIT.EXE named disasm — module ems_7.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @ems_buffer_to_buffer  file 0x01462A..0x01469A  seg 0x1302:0xa  (ems_7.c.obj) ----
  01462A  c8060000         enter 6, 0
  01462E  52               push dx
  01462F  50               push ax
  014630  b8ffff           mov ax, 0xffff
  014633  8946fe           mov word ptr [bp - 2], ax
  014636  8946fc           mov word ptr [bp - 4], ax
  014639  c746fa0000       mov word ptr [bp - 6], 0
  01463E  8b46f6           mov ax, word ptr [bp - 0xa]
  014641  8b56fe           mov dx, word ptr [bp - 2]
  014644  9ac4014511       lcall 0x1145, 0x1c4
  014649  8946fe           mov word ptr [bp - 2], ax
  01464C  8b46f8           mov ax, word ptr [bp - 8]
  01464F  8b56fc           mov dx, word ptr [bp - 4]
  014652  9ac4014511       lcall 0x1145, 0x1c4
  014657  8946fc           mov word ptr [bp - 4], ax
  01465A  ff76fe           push word ptr [bp - 2]
  01465D  6a02             push 2
  01465F  9ad4002d11       lcall 0x112d, 0xd4
  014664  83c404           add sp, 4
  014667  ff76fc           push word ptr [bp - 4]
  01466A  6a03             push 3
  01466C  9ad4002d11       lcall 0x112d, 0xd4
  014671  83c404           add sp, 4
  014674  680040           push 0x4000
  014677  ff366644         push word ptr [0x4466]
  01467B  ff366444         push word ptr [0x4464]
  01467F  ff366a44         push word ptr [0x446a]
  014683  ff366844         push word ptr [0x4468]
  014687  9a4a0c8813       lcall 0x1388, 0xc4a
  01468C  83c40a           add sp, 0xa
  01468F  ff46fa           inc word ptr [bp - 6]
  014692  837efa04         cmp word ptr [bp - 6], 4
  014696  7ca6             jl 0x1463e
  014698  c9               leave
  014699  cb               retf
