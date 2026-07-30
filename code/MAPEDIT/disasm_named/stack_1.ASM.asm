; MAPEDIT.EXE named disasm — module stack_1.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _STACK_FILL  file 0x0140A0..0x0140BB  seg 0x12AA:0x0  (stack_1.ASM.obj) ----
  0140A0  56               push si
  0140A1  33d2             xor dx, dx
  0140A3  8b3ea245         mov di, word ptr [0x45a2]
  0140A7  8bcf             mov cx, di
  0140A9  2bcc             sub cx, sp
  0140AB  730a             jae 0x140b7
  0140AD  f7d9             neg cx
  0140AF  8bd1             mov dx, cx
  0140B1  1e               push ds
  0140B2  07               pop es
  0140B3  32c0             xor al, al
  0140B5  f3aa             rep stosb byte ptr es:[di], al
  0140B7  8bc2             mov ax, dx
  0140B9  5e               pop si
  0140BA  cb               retf

; ---- _stack_check  file 0x0140BB..0x0140DC  seg 0x12AA:0x1b  (stack_1.ASM.obj) ----
  0140BB  56               push si
  0140BC  33db             xor bx, bx
  0140BE  8b36a245         mov si, word ptr [0x45a2]
  0140C2  8bce             mov cx, si
  0140C4  2bcc             sub cx, sp
  0140C6  730f             jae 0x140d7
  0140C8  f7d9             neg cx
  0140CA  8bd1             mov dx, cx
  0140CC  ac               lodsb al, byte ptr [si]
  0140CD  0ac0             or al, al
  0140CF  7502             jne 0x140d3
  0140D1  e2f9             loop 0x140cc
  0140D3  8bda             mov bx, dx
  0140D5  2bd9             sub bx, cx
  0140D7  8bc3             mov ax, bx
  0140D9  5e               pop si
  0140DA  cb               retf
  0140DB  00               .byte 0x00
