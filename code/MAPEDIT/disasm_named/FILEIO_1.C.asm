; MAPEDIT.EXE named disasm — module FILEIO_1.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @fileio_purge_trailing_spaces  file 0x0117FC..0x01185C  seg 0x101F:0xc  (FILEIO_1.C.obj) ----
  0117FC  c8040000         enter 4, 0
  011800  57               push di
  011801  56               push si
  011802  ff7608           push word ptr [bp + 8]
  011805  ff7606           push word ptr [bp + 6]
  011808  9ad40d8813       lcall 0x1388, 0xdd4
  01180D  83c404           add sp, 4
  011810  beffff           mov si, 0xffff
  011813  ff7608           push word ptr [bp + 8]
  011816  ff7606           push word ptr [bp + 6]
  011819  9ad40d8813       lcall 0x1388, 0xdd4
  01181E  83c404           add sp, 4
  011821  8bd8             mov bx, ax
  011823  035e06           add bx, word ptr [bp + 6]
  011826  8e4608           mov es, word ptr [bp + 8]
  011829  4b               dec bx
  01182A  8bfb             mov di, bx
  01182C  8c46fe           mov word ptr [bp - 2], es
  01182F  26803f20         cmp byte ptr es:[bx], 0x20
  011833  740b             je 0x11840
  011835  26803d09         cmp byte ptr es:[di], 9
  011839  7405             je 0x11840
  01183B  2bf6             sub si, si
  01183D  eb08             jmp 0x11847
  01183F  90               nop
  011840  8e46fe           mov es, word ptr [bp - 2]
  011843  26c60500         mov byte ptr es:[di], 0
  011847  8d45ff           lea ax, [di - 1]
  01184A  3b4606           cmp ax, word ptr [bp + 6]
  01184D  7302             jae 0x11851
  01184F  2bf6             sub si, si
  011851  0bf6             or si, si
  011853  75bb             jne 0x11810
  011855  5e               pop si
  011856  5f               pop di
  011857  c9               leave
  011858  ca0400           retf 4
  01185B  90               nop
