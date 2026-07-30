; MAPEDIT.EXE named disasm — module btype_5.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @stoi  file 0x00E72C..0x00E786  seg 0xD12:0xc  (btype_5.c.obj) ----
  00E72C  c8020000         enter 2, 0
  00E730  56               push si
  00E731  8bf3             mov si, bx
  00E733  803c30           cmp byte ptr [si], 0x30
  00E736  7542             jne 0xe77a
  00E738  8a5c01           mov bl, byte ptr [si + 1]
  00E73B  885eff           mov byte ptr [bp - 1], bl
  00E73E  2aff             sub bh, bh
  00E740  f687a94502       test byte ptr [bx + 0x45a9], 2
  00E745  7404             je 0xe74b
  00E747  806eff20         sub byte ptr [bp - 1], 0x20
  00E74B  807eff58         cmp byte ptr [bp - 1], 0x58
  00E74F  750b             jne 0xe75c
  00E751  8d5c02           lea bx, [si + 2]
  00E754  9a0a005010       lcall 0x1050, 0xa
  00E759  5e               pop si
  00E75A  c9               leave
  00E75B  cb               retf
  00E75C  807eff42         cmp byte ptr [bp - 1], 0x42
  00E760  750c             jne 0xe76e
  00E762  8d5c02           lea bx, [si + 2]
  00E765  9a0e005610       lcall 0x1056, 0xe
  00E76A  5e               pop si
  00E76B  c9               leave
  00E76C  cb               retf
  00E76D  90               nop
  00E76E  807eff44         cmp byte ptr [bp - 1], 0x44
  00E772  7506             jne 0xe77a
  00E774  8d4402           lea ax, [si + 2]
  00E777  50               push ax
  00E778  eb01             jmp 0xe77b
  00E77A  56               push si
  00E77B  9a38078813       lcall 0x1388, 0x738
  00E780  83c402           add sp, 2
  00E783  5e               pop si
  00E784  c9               leave
  00E785  cb               retf
