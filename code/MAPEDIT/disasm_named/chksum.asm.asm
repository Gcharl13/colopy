; MAPEDIT.EXE named disasm — module chksum.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __nullcheck  file 0x015E22..0x015E46  seg 0x1388:0xfa2  (chksum.asm.obj) ----
  015E22  56               push si
  015E23  33f6             xor si, si
  015E25  b94200           mov cx, 0x42
  015E28  32e4             xor ah, ah
  015E2A  fc               cld
  015E2B  ac               lodsb al, byte ptr [si]
  015E2C  32e0             xor ah, al
  015E2E  e2fb             loop 0x15e2b
  015E30  80f455           xor ah, 0x55
  015E33  740f             je 0x15e44
  015E35  0e               push cs
  015E36  e8c1ff           call 0x15dfa
  015E39  b80100           mov ax, 1
  015E3C  50               push ax
  015E3D  0e               push cs
  015E3E  e84002           call 0x16081
  015E41  b80100           mov ax, 1
  015E44  5e               pop si
  015E45  cb               retf
