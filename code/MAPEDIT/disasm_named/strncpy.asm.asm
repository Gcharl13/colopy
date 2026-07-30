; MAPEDIT.EXE named disasm — module strncpy.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strncpy  file 0x015556..0x01557E  seg 0x1388:0x6d6  (strncpy.asm.obj) ----
  015556  55               push bp
  015557  8bec             mov bp, sp
  015559  57               push di
  01555A  56               push si
  01555B  1e               push ds
  01555C  07               pop es
  01555D  8b7e06           mov di, word ptr [bp + 6]
  015560  8b7608           mov si, word ptr [bp + 8]
  015563  8bdf             mov bx, di
  015565  8b4e0a           mov cx, word ptr [bp + 0xa]
  015568  e30c             jcxz 0x15576
  01556A  ac               lodsb al, byte ptr [si]
  01556B  0ac0             or al, al
  01556D  7403             je 0x15572
  01556F  aa               stosb byte ptr es:[di], al
  015570  e2f8             loop 0x1556a
  015572  32c0             xor al, al
  015574  f3aa             rep stosb byte ptr es:[di], al
  015576  8bc3             mov ax, bx
  015578  5e               pop si
  015579  5f               pop di
  01557A  8be5             mov sp, bp
  01557C  5d               pop bp
  01557D  cb               retf

; ---- __fstrncpy  file 0x015BD8..0x015C02  seg 0x1388:0xd58  (strncpy.asm.obj) ----
  015BD8  55               push bp
  015BD9  8bec             mov bp, sp
  015BDB  57               push di
  015BDC  56               push si
  015BDD  1e               push ds
  015BDE  c47e06           les di, ptr [bp + 6]
  015BE1  c5760a           lds si, ptr [bp + 0xa]
  015BE4  8bdf             mov bx, di
  015BE6  8b4e0e           mov cx, word ptr [bp + 0xe]
  015BE9  e30c             jcxz 0x15bf7
  015BEB  ac               lodsb al, byte ptr [si]
  015BEC  0ac0             or al, al
  015BEE  7403             je 0x15bf3
  015BF0  aa               stosb byte ptr es:[di], al
  015BF1  e2f8             loop 0x15beb
  015BF3  32c0             xor al, al
  015BF5  f3aa             rep stosb byte ptr es:[di], al
  015BF7  8bc3             mov ax, bx
  015BF9  8cc2             mov dx, es
  015BFB  1f               pop ds
  015BFC  5e               pop si
  015BFD  5f               pop di
  015BFE  8be5             mov sp, bp
  015C00  5d               pop bp
  015C01  cb               retf
