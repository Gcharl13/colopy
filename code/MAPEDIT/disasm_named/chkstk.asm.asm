; MAPEDIT.EXE named disasm — module chkstk.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __aFchkstk  file 0x01511E..0x015142  seg 0x1388:0x29e  (chkstk.asm.obj) ----
  01511E  59               pop cx
  01511F  5a               pop dx
  015120  8bdc             mov bx, sp
  015122  2bd8             sub bx, ax
  015124  720b             jb 0x15131
  015126  3b1ea245         cmp bx, word ptr [0x45a2]
  01512A  7205             jb 0x15131
  01512C  8be3             mov sp, bx
  01512E  52               push dx
  01512F  51               push cx
  015130  cb               retf
  015131  52               push dx
  015132  51               push cx
  015133  a19e45           mov ax, word ptr [0x459e]
  015136  40               inc ax
  015137  7505             jne 0x1513e
  015139  33c0             xor ax, ax
  01513B  e933fe           jmp 0x14f71
  01513E  ff2e9e45         ljmp [0x459e]
