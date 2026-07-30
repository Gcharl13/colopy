; MAPEDIT.EXE named disasm — module strrchr.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __fstrrchr  file 0x015C02..0x015C30  seg 0x1388:0xd82  (strrchr.asm.obj) ----
  015C02  55               push bp
  015C03  8bec             mov bp, sp
  015C05  57               push di
  015C06  c47e06           les di, ptr [bp + 6]
  015C09  33c0             xor ax, ax
  015C0B  b9ffff           mov cx, 0xffff
  015C0E  f2ae             repne scasb al, byte ptr es:[di]
  015C10  41               inc cx
  015C11  f7d9             neg cx
  015C13  4f               dec di
  015C14  8a460a           mov al, byte ptr [bp + 0xa]
  015C17  fd               std
  015C18  f2ae             repne scasb al, byte ptr es:[di]
  015C1A  47               inc di
  015C1B  263805           cmp byte ptr es:[di], al
  015C1E  7406             je 0x15c26
  015C20  33c0             xor ax, ax
  015C22  8bd0             mov dx, ax
  015C24  eb04             jmp 0x15c2a
  015C26  8bc7             mov ax, di
  015C28  8cc2             mov dx, es
  015C2A  fc               cld
  015C2B  5f               pop di
  015C2C  8be5             mov sp, bp
  015C2E  5d               pop bp
  015C2F  cb               retf
