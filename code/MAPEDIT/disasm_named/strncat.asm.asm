; MAPEDIT.EXE named disasm — module strncat.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strncat  file 0x015520..0x015556  seg 0x1388:0x6a0  (strncat.asm.obj) ----
  015520  55               push bp
  015521  8bec             mov bp, sp
  015523  57               push di
  015524  56               push si
  015525  1e               push ds
  015526  07               pop es
  015527  8b7e06           mov di, word ptr [bp + 6]
  01552A  8bd7             mov dx, di
  01552C  33c0             xor ax, ax
  01552E  b9ffff           mov cx, 0xffff
  015531  f2ae             repne scasb al, byte ptr es:[di]
  015533  4f               dec di
  015534  8bf7             mov si, di
  015536  8b7e08           mov di, word ptr [bp + 8]
  015539  8bdf             mov bx, di
  01553B  8b4e0a           mov cx, word ptr [bp + 0xa]
  01553E  f2ae             repne scasb al, byte ptr es:[di]
  015540  7501             jne 0x15543
  015542  41               inc cx
  015543  2b4e0a           sub cx, word ptr [bp + 0xa]
  015546  f7d9             neg cx
  015548  8bfe             mov di, si
  01554A  8bf3             mov si, bx
  01554C  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  01554E  aa               stosb byte ptr es:[di], al
  01554F  8bc2             mov ax, dx
  015551  5e               pop si
  015552  5f               pop di
  015553  5d               pop bp
  015554  cb               retf
  015555  00               .byte 0x00
