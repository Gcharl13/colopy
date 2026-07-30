; MAPEDIT.EXE named disasm — module stream.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __getstream  file 0x0169FE..0x016A32  seg 0x1388:0x1b7e  (stream.c.obj) ----
  0169FE  57               push di
  0169FF  56               push si
  016A00  bec646           mov si, 0x46c6
  016A03  2bff             sub di, di
  016A05  eb04             jmp 0x16a0b
  016A07  90               nop
  016A08  83c608           add si, 8
  016A0B  39360648         cmp word ptr [0x4806], si
  016A0F  721c             jb 0x16a2d
  016A11  f6440683         test byte ptr [si + 6], 0x83
  016A15  75f1             jne 0x16a08
  016A17  c744020000       mov word ptr [si + 2], 0
  016A1C  c6440600         mov byte ptr [si + 6], 0
  016A20  2bc0             sub ax, ax
  016A22  894404           mov word ptr [si + 4], ax
  016A25  8904             mov word ptr [si], ax
  016A27  c64407ff         mov byte ptr [si + 7], 0xff
  016A2B  8bfe             mov di, si
  016A2D  8bc7             mov ax, di
  016A2F  5e               pop si
  016A30  5f               pop di
  016A31  cb               retf
