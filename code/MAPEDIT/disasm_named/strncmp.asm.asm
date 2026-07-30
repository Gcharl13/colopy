; MAPEDIT.EXE named disasm — module strncmp.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strncmp  file 0x01557E..0x0155B8  seg 0x1388:0x6fe  (strncmp.asm.obj) ----
  01557E  55               push bp
  01557F  8bec             mov bp, sp
  015581  57               push di
  015582  56               push si
  015583  1e               push ds
  015584  07               pop es
  015585  8b4e0a           mov cx, word ptr [bp + 0xa]
  015588  e326             jcxz 0x155b0
  01558A  8bd9             mov bx, cx
  01558C  8b7e06           mov di, word ptr [bp + 6]
  01558F  8bf7             mov si, di
  015591  33c0             xor ax, ax
  015593  f2ae             repne scasb al, byte ptr es:[di]
  015595  f7d9             neg cx
  015597  03cb             add cx, bx
  015599  8bfe             mov di, si
  01559B  8b7608           mov si, word ptr [bp + 8]
  01559E  f3a6             repe cmpsb byte ptr [si], byte ptr es:[di]
  0155A0  8a44ff           mov al, byte ptr [si - 1]
  0155A3  33c9             xor cx, cx
  0155A5  3a45ff           cmp al, byte ptr [di - 1]
  0155A8  7704             ja 0x155ae
  0155AA  7404             je 0x155b0
  0155AC  49               dec cx
  0155AD  49               dec cx
  0155AE  f7d1             not cx
  0155B0  8bc1             mov ax, cx
  0155B2  5e               pop si
  0155B3  5f               pop di
  0155B4  8be5             mov sp, bp
  0155B6  5d               pop bp
  0155B7  cb               retf

; ---- __fstrncmp  file 0x015B9C..0x015BD8  seg 0x1388:0xd1c  (strncmp.asm.obj) ----
  015B9C  55               push bp
  015B9D  8bec             mov bp, sp
  015B9F  57               push di
  015BA0  56               push si
  015BA1  1e               push ds
  015BA2  8b4e0e           mov cx, word ptr [bp + 0xe]
  015BA5  e327             jcxz 0x15bce
  015BA7  8bd9             mov bx, cx
  015BA9  c47e06           les di, ptr [bp + 6]
  015BAC  8bf7             mov si, di
  015BAE  33c0             xor ax, ax
  015BB0  f2ae             repne scasb al, byte ptr es:[di]
  015BB2  f7d9             neg cx
  015BB4  03cb             add cx, bx
  015BB6  8bfe             mov di, si
  015BB8  c5760a           lds si, ptr [bp + 0xa]
  015BBB  f3a6             repe cmpsb byte ptr [si], byte ptr es:[di]
  015BBD  8a44ff           mov al, byte ptr [si - 1]
  015BC0  33c9             xor cx, cx
  015BC2  263a45ff         cmp al, byte ptr es:[di - 1]
  015BC6  7704             ja 0x15bcc
  015BC8  7404             je 0x15bce
  015BCA  49               dec cx
  015BCB  49               dec cx
  015BCC  f7d1             not cx
  015BCE  8bc1             mov ax, cx
  015BD0  1f               pop ds
  015BD1  5e               pop si
  015BD2  5f               pop di
  015BD3  8be5             mov sp, bp
  015BD5  5d               pop bp
  015BD6  cb               retf
  015BD7  00               .byte 0x00
