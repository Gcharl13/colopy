; MAPEDIT.EXE named disasm — module dos_dosret.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __dosret0  file 0x0160B8..0x0160C0  seg 0x1388:0x1238  (dos_dosret.asm.obj) ----
  0160B8  7215             jb 0x160cf
  0160BA  33c0             xor ax, ax
  0160BC  8be5             mov sp, bp
  0160BE  5d               pop bp
  0160BF  cb               retf

; ---- __dosreturn  file 0x0160C0..0x0160CD  seg 0x1388:0x1240  (dos_dosret.asm.obj) ----
  0160C0  73f8             jae 0x160ba
  0160C2  50               push ax
  0160C3  e81a00           call 0x160e0
  0160C6  58               pop ax
  0160C7  32e4             xor ah, ah
  0160C9  8be5             mov sp, bp
  0160CB  5d               pop bp
  0160CC  cb               retf

; ---- __dosretax  file 0x0160CD..0x0160DA  seg 0x1388:0x124d  (dos_dosret.asm.obj) ----
  0160CD  7307             jae 0x160d6
  0160CF  e80e00           call 0x160e0
  0160D2  b8ffff           mov ax, 0xffff
  0160D5  99               cdq
  0160D6  8be5             mov sp, bp
  0160D8  5d               pop bp
  0160D9  cb               retf

; ---- __maperror  file 0x0160DA..0x01610E  seg 0x1388:0x125a  (dos_dosret.asm.obj) ----
  0160DA  32e4             xor ah, ah
  0160DC  e80100           call 0x160e0
  0160DF  cb               retf
  0160E0  a27345           mov byte ptr [0x4573], al
  0160E3  0ae4             or ah, ah
  0160E5  7522             jne 0x16109
  0160E7  803e704503       cmp byte ptr [0x4570], 3
  0160EC  720c             jb 0x160fa
  0160EE  3c22             cmp al, 0x22
  0160F0  730c             jae 0x160fe
  0160F2  3c20             cmp al, 0x20
  0160F4  7204             jb 0x160fa
  0160F6  b005             mov al, 5
  0160F8  eb06             jmp 0x16100
  0160FA  3c13             cmp al, 0x13
  0160FC  7602             jbe 0x16100
  0160FE  b013             mov al, 0x13
  016100  bbb246           mov bx, 0x46b2
  016103  d7               xlatb
  016104  98               cwde
  016105  a36845           mov word ptr [0x4568], ax
  016108  c3               ret
  016109  8ac4             mov al, ah
  01610B  ebf7             jmp 0x16104
  01610D  00               .byte 0x00
