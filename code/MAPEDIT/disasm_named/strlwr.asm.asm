; MAPEDIT.EXE named disasm — module strlwr.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strlwr  file 0x0158EA..0x015908  seg 0x1388:0xa6a  (strlwr.asm.obj) ----
  0158EA  55               push bp
  0158EB  8bec             mov bp, sp
  0158ED  8b5e06           mov bx, word ptr [bp + 6]
  0158F0  8bd3             mov dx, bx
  0158F2  eb0b             jmp 0x158ff
  0158F4  2c41             sub al, 0x41
  0158F6  3c1a             cmp al, 0x1a
  0158F8  7304             jae 0x158fe
  0158FA  0461             add al, 0x61
  0158FC  8807             mov byte ptr [bx], al
  0158FE  43               inc bx
  0158FF  8a07             mov al, byte ptr [bx]
  015901  0ac0             or al, al
  015903  75ef             jne 0x158f4
  015905  92               xchg dx, ax
  015906  5d               pop bp
  015907  cb               retf
