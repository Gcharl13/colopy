; MAPEDIT.EXE named disasm — module KEYS_1.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @keys_any  file 0x00D0F4..0x00D108  seg 0xBAF:0x4  (KEYS_1.C.obj) ----
  00D0F4  55               push bp
  00D0F5  8bec             mov bp, sp
  00D0F7  b401             mov ah, 1
  00D0F9  cd16             int 0x16
  00D0FB  7505             jne 0xd102
  00D0FD  33c0             xor ax, ax
  00D0FF  c9               leave
  00D100  cb               retf
  00D101  90               nop
  00D102  b80100           mov ax, 1
  00D105  c9               leave
  00D106  cb               retf
  00D107  90               nop

; ---- @keys_get  file 0x00D108..0x00D11E  seg 0xBAF:0x18  (KEYS_1.C.obj) ----
  00D108  55               push bp
  00D109  8bec             mov bp, sp
  00D10B  b400             mov ah, 0
  00D10D  cd16             int 0x16
  00D10F  0ac0             or al, al
  00D111  7405             je 0xd118
  00D113  32e4             xor ah, ah
  00D115  c9               leave
  00D116  cb               retf
  00D117  90               nop
  00D118  8ac4             mov al, ah
  00D11A  b401             mov ah, 1
  00D11C  c9               leave
  00D11D  cb               retf

; ---- @keys_flush  file 0x00D11E..0x00D12E  seg 0xBAF:0x2e  (KEYS_1.C.obj) ----
  00D11E  eb04             jmp 0xd124
  00D120  0e               push cs
  00D121  e8e4ff           call 0xd108
  00D124  0e               push cs
  00D125  e8ccff           call 0xd0f4
  00D128  0bc0             or ax, ax
  00D12A  75f4             jne 0xd120
  00D12C  cb               retf
  00D12D  90               nop
