; MAPEDIT.EXE named disasm — module ems_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @ems_detect  file 0x0128D6..0x01298A  seg 0x112D:0x6  (ems_1.c.obj) ----
  0128D6  55               push bp
  0128D7  8bec             mov bp, sp
  0128D9  57               push di
  0128DA  56               push si
  0128DB  c70638440000     mov word ptr [0x4438], 0
  0128E1  b435             mov ah, 0x35
  0128E3  b067             mov al, 0x67
  0128E5  cd21             int 0x21
  0128E7  bf0a00           mov di, 0xa
  0128EA  be6c44           mov si, 0x446c
  0128ED  33db             xor bx, bx
  0128EF  b90800           mov cx, 8
  0128F2  f3a6             repe cmpsb byte ptr [si], byte ptr es:[di]
  0128F4  7522             jne 0x12918
  0128F6  a14644           mov ax, word ptr [0x4446]
  0128F9  0bc0             or ax, ax
  0128FB  751b             jne 0x12918
  0128FD  b440             mov ah, 0x40
  0128FF  cd67             int 0x67
  012901  0ae4             or ah, ah
  012903  7513             jne 0x12918
  012905  b446             mov ah, 0x46
  012907  cd67             int 0x67
  012909  0ae4             or ah, ah
  01290B  750b             jne 0x12918
  01290D  8ae0             mov ah, al
  01290F  c0e804           shr al, 4
  012912  3c03             cmp al, 3
  012914  7202             jb 0x12918
  012916  eb06             jmp 0x1291e
  012918  8bc3             mov ax, bx
  01291A  5e               pop si
  01291B  5f               pop di
  01291C  c9               leave
  01291D  cb               retf
  01291E  50               push ax
  01291F  32e4             xor ah, ah
  012921  a34244           mov word ptr [0x4442], ax
  012924  58               pop ax
  012925  c1e808           shr ax, 8
  012928  240f             and al, 0xf
  01292A  a34444           mov word ptr [0x4444], ax
  01292D  b441             mov ah, 0x41
  01292F  cd67             int 0x67
  012931  891e3c44         mov word ptr [0x443c], bx
  012935  33d2             xor dx, dx
  012937  1e               push ds
  012938  07               pop es
  012939  bf5c44           mov di, 0x445c
  01293C  b90400           mov cx, 4
  01293F  268915           mov word ptr es:[di], dx
  012942  26895d02         mov word ptr es:[di + 2], bx
  012946  81c20040         add dx, 0x4000
  01294A  83c704           add di, 4
  01294D  e2f0             loop 0x1293f
  01294F  33db             xor bx, bx
  012951  0ae4             or ah, ah
  012953  752e             jne 0x12983
  012955  c7063844ffff     mov word ptr [0x4438], 0xffff
  01295B  b442             mov ah, 0x42
  01295D  cd67             int 0x67
  01295F  891e4044         mov word ptr [0x4440], bx
  012963  0bdb             or bx, bx
  012965  741c             je 0x12983
  012967  b443             mov ah, 0x43
  012969  cd67             int 0x67
  01296B  0ae4             or ah, ah
  01296D  7409             je 0x12978
  01296F  33db             xor bx, bx
  012971  8bc3             mov ax, bx
  012973  5e               pop si
  012974  5f               pop di
  012975  c9               leave
  012976  cb               retf
  012977  90               nop
  012978  89163e44         mov word ptr [0x443e], dx
  01297C  bbffff           mov bx, 0xffff
  01297F  891e3a44         mov word ptr [0x443a], bx
  012983  8bc3             mov ax, bx
  012985  5e               pop si
  012986  5f               pop di
  012987  c9               leave
  012988  cb               retf
  012989  90               nop

; ---- @ems_shutdown  file 0x01298A..0x0129A4  seg 0x112D:0xba  (ems_1.c.obj) ----
  01298A  55               push bp
  01298B  8bec             mov bp, sp
  01298D  833e3a4400       cmp word ptr [0x443a], 0
  012992  7408             je 0x1299c
  012994  8b163e44         mov dx, word ptr [0x443e]
  012998  b445             mov ah, 0x45
  01299A  cd67             int 0x67
  01299C  c7063a440000     mov word ptr [0x443a], 0
  0129A2  c9               leave
  0129A3  cb               retf

; ---- _ems_map_page  file 0x0129A4..0x0129E4  seg 0x112D:0xd4  (ems_1.c.obj) ----
  0129A4  55               push bp
  0129A5  8bec             mov bp, sp
  0129A7  837e0601         cmp word ptr [bp + 6], 1
  0129AB  7506             jne 0x129b3
  0129AD  c70648440000     mov word ptr [0x4448], 0
  0129B3  8b4608           mov ax, word ptr [bp + 8]
  0129B6  8b5e06           mov bx, word ptr [bp + 6]
  0129B9  d1e3             shl bx, 1
  0129BB  39874c44         cmp word ptr [bx + 0x444c], ax
  0129BF  741f             je 0x129e0
  0129C1  89874c44         mov word ptr [bx + 0x444c], ax
  0129C5  c7064a44ffff     mov word ptr [0x444a], 0xffff
  0129CB  b444             mov ah, 0x44
  0129CD  8a4606           mov al, byte ptr [bp + 6]
  0129D0  8b5e08           mov bx, word ptr [bp + 8]
  0129D3  8b163e44         mov dx, word ptr [0x443e]
  0129D7  cd67             int 0x67
  0129D9  32c0             xor al, al
  0129DB  86e0             xchg al, ah
  0129DD  c9               leave
  0129DE  cb               retf
  0129DF  90               nop
  0129E0  33c0             xor ax, ax
  0129E2  c9               leave
  0129E3  cb               retf

; ---- _ems_push  file 0x0129E4..0x012A06  seg 0x112D:0x114  (ems_1.c.obj) ----
  0129E4  c8020000         enter 2, 0
  0129E8  c746fe0000       mov word ptr [bp - 2], 0
  0129ED  8b5efe           mov bx, word ptr [bp - 2]
  0129F0  d1e3             shl bx, 1
  0129F2  8b874c44         mov ax, word ptr [bx + 0x444c]
  0129F6  89875444         mov word ptr [bx + 0x4454], ax
  0129FA  ff46fe           inc word ptr [bp - 2]
  0129FD  837efe04         cmp word ptr [bp - 2], 4
  012A01  7cea             jl 0x129ed
  012A03  c9               leave
  012A04  cb               retf
  012A05  90               nop

; ---- _ems_pop  file 0x012A06..0x012A2E  seg 0x112D:0x136  (ems_1.c.obj) ----
  012A06  c8020000         enter 2, 0
  012A0A  c746fe0000       mov word ptr [bp - 2], 0
  012A0F  8b5efe           mov bx, word ptr [bp - 2]
  012A12  d1e3             shl bx, 1
  012A14  ffb75444         push word ptr [bx + 0x4454]
  012A18  ff76fe           push word ptr [bp - 2]
  012A1B  0e               push cs
  012A1C  e885ff           call 0x129a4
  012A1F  83c404           add sp, 4
  012A22  ff46fe           inc word ptr [bp - 2]
  012A25  837efe04         cmp word ptr [bp - 2], 4
  012A29  7ce4             jl 0x12a0f
  012A2B  c9               leave
  012A2C  cb               retf
  012A2D  90               nop

; ---- _ems_unmap_all  file 0x012A2E..0x012A5C  seg 0x112D:0x15e  (ems_1.c.obj) ----
  012A2E  c8020000         enter 2, 0
  012A32  833e3a4400       cmp word ptr [0x443a], 0
  012A37  7421             je 0x12a5a
  012A39  833e424404       cmp word ptr [0x4442], 4
  012A3E  721a             jb 0x12a5a
  012A40  c746fe0000       mov word ptr [bp - 2], 0
  012A45  6aff             push -1
  012A47  ff76fe           push word ptr [bp - 2]
  012A4A  0e               push cs
  012A4B  e856ff           call 0x129a4
  012A4E  83c404           add sp, 4
  012A51  ff46fe           inc word ptr [bp - 2]
  012A54  837efe04         cmp word ptr [bp - 2], 4
  012A58  7ceb             jl 0x12a45
  012A5A  c9               leave
  012A5B  cb               retf
