; MAPEDIT.EXE named disasm — module ems_2.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @ems_activate_page_map  file 0x012A5C..0x012A86  seg 0x1145:0xc  (ems_2.c.obj) ----
  012A5C  833e484400       cmp word ptr [0x4448], 0
  012A61  7519             jne 0x12a7c
  012A63  a14044           mov ax, word ptr [0x4440]
  012A66  48               dec ax
  012A67  50               push ax
  012A68  6a01             push 1
  012A6A  9ad4002d11       lcall 0x112d, 0xd4
  012A6F  83c404           add sp, 4
  012A72  3d0100           cmp ax, 1
  012A75  1bc0             sbb ax, ax
  012A77  f7d8             neg ax
  012A79  a34844           mov word ptr [0x4448], ax
  012A7C  833e484401       cmp word ptr [0x4448], 1
  012A81  1bc0             sbb ax, ax
  012A83  f7d8             neg ax
  012A85  cb               retf

; ---- @ems_paging_setup  file 0x012A86..0x012AF0  seg 0x1145:0x36  (ems_2.c.obj) ----
  012A86  55               push bp
  012A87  8bec             mov bp, sp
  012A89  57               push di
  012A8A  56               push si
  012A8B  833e3a4400       cmp word ptr [0x443a], 0
  012A90  7452             je 0x12ae4
  012A92  833e404401       cmp word ptr [0x4440], 1
  012A97  764b             jbe 0x12ae4
  012A99  a14044           mov ax, word ptr [0x4440]
  012A9C  2d0008           sub ax, 0x800
  012A9F  1bc9             sbb cx, cx
  012AA1  23c1             and ax, cx
  012AA3  80c408           add ah, 8
  012AA6  a34044           mov word ptr [0x4440], ax
  012AA9  a16044           mov ax, word ptr [0x4460]
  012AAC  8b166244         mov dx, word ptr [0x4462]
  012AB0  a37c44           mov word ptr [0x447c], ax
  012AB3  89167e44         mov word ptr [0x447e], dx
  012AB7  0e               push cs
  012AB8  e8a1ff           call 0x12a5c
  012ABB  0bc0             or ax, ax
  012ABD  7525             jne 0x12ae4
  012ABF  c43e7c44         les di, ptr [0x447c]
  012AC3  8b0e4044         mov cx, word ptr [0x4440]
  012AC7  32c0             xor al, al
  012AC9  f3aa             rep stosb byte ptr es:[di], al
  012ACB  c41e7c44         les bx, ptr [0x447c]
  012ACF  8b364044         mov si, word ptr [0x4440]
  012AD3  26c640ffff       mov byte ptr es:[bx + si - 1], 0xff
  012AD8  8d44ff           lea ax, [si - 1]
  012ADB  a37644           mov word ptr [0x4476], ax
  012ADE  c7067a44ffff     mov word ptr [0x447a], 0xffff
  012AE4  9a5e012d11       lcall 0x112d, 0x15e
  012AE9  a17a44           mov ax, word ptr [0x447a]
  012AEC  5e               pop si
  012AED  5f               pop di
  012AEE  c9               leave
  012AEF  cb               retf

; ---- @ems_free_page_handle  file 0x012AF0..0x012B56  seg 0x1145:0xa0  (ems_2.c.obj) ----
  012AF0  55               push bp
  012AF1  8bec             mov bp, sp
  012AF3  50               push ax
  012AF4  57               push di
  012AF5  56               push si
  012AF6  833e7a4400       cmp word ptr [0x447a], 0
  012AFB  7455             je 0x12b52
  012AFD  833e044500       cmp word ptr [0x4504], 0
  012B02  744e             je 0x12b52
  012B04  0bc0             or ax, ax
  012B06  744a             je 0x12b52
  012B08  0e               push cs
  012B09  e850ff           call 0x12a5c
  012B0C  0bc0             or ax, ax
  012B0E  7542             jne 0x12b52
  012B10  2bdb             sub bx, bx
  012B12  39064044         cmp word ptr [0x4440], ax
  012B16  7e2e             jle 0x12b46
  012B18  8b3e7c44         mov di, word ptr [0x447c]
  012B1C  8b0e7644         mov cx, word ptr [0x4476]
  012B20  8e067e44         mov es, word ptr [0x447e]
  012B24  8bf7             mov si, di
  012B26  03f3             add si, bx
  012B28  268a04           mov al, byte ptr es:[si]
  012B2B  2a46fe           sub al, byte ptr [bp - 2]
  012B2E  fec8             dec al
  012B30  7509             jne 0x12b3b
  012B32  8bf7             mov si, di
  012B34  03f3             add si, bx
  012B36  26c60400         mov byte ptr es:[si], 0
  012B3A  41               inc cx
  012B3B  43               inc bx
  012B3C  391e4044         cmp word ptr [0x4440], bx
  012B40  7fe2             jg 0x12b24
  012B42  890e7644         mov word ptr [0x4476], cx
  012B46  6b5efe5a         imul bx, word ptr [bp - 2], 0x5a
  012B4A  c436fc44         les si, ptr [0x44fc]
  012B4E  26c600ff         mov byte ptr es:[bx + si], 0xff
  012B52  5e               pop si
  012B53  5f               pop di
  012B54  c9               leave
  012B55  cb               retf

; ---- @ems_get_page_handle  file 0x012B56..0x012C14  seg 0x1145:0x106  (ems_2.c.obj) ----
  012B56  c8080000         enter 8, 0
  012B5A  50               push ax
  012B5B  57               push di
  012B5C  56               push si
  012B5D  c746f8ffff       mov word ptr [bp - 8], 0xffff
  012B62  c746fe0000       mov word ptr [bp - 2], 0
  012B67  833e7a4400       cmp word ptr [0x447a], 0
  012B6C  7503             jne 0x12b71
  012B6E  e99b00           jmp 0x12c0c
  012B71  833e044500       cmp word ptr [0x4504], 0
  012B76  7503             jne 0x12b7b
  012B78  e99100           jmp 0x12c0c
  012B7B  a17644           mov ax, word ptr [0x4476]
  012B7E  2b067844         sub ax, word ptr [0x4478]
  012B82  3b46f6           cmp ax, word ptr [bp - 0xa]
  012B85  7d03             jge 0x12b8a
  012B87  e98200           jmp 0x12c0c
  012B8A  0e               push cs
  012B8B  e8cefe           call 0x12a5c
  012B8E  0bc0             or ax, ax
  012B90  757a             jne 0x12c0c
  012B92  50               push ax
  012B93  50               push ax
  012B94  9a0a004513       lcall 0x1345, 0xa
  012B99  83c404           add sp, 4
  012B9C  8946fa           mov word ptr [bp - 6], ax
  012B9F  0bc0             or ax, ax
  012BA1  7c69             jl 0x12c0c
  012BA3  2bc9             sub cx, cx
  012BA5  8b5efe           mov bx, word ptr [bp - 2]
  012BA8  eb40             jmp 0x12bea
  012BAA  90               nop
  012BAB  90               nop
  012BAC  894efc           mov word ptr [bp - 4], cx
  012BAF  8b0e4044         mov cx, word ptr [0x4440]
  012BB3  8b3e7c44         mov di, word ptr [0x447c]
  012BB7  8e067e44         mov es, word ptr [0x447e]
  012BBB  8bf7             mov si, di
  012BBD  03f3             add si, bx
  012BBF  26803c00         cmp byte ptr es:[si], 0
  012BC3  740f             je 0x12bd4
  012BC5  43               inc bx
  012BC6  3bd9             cmp bx, cx
  012BC8  7cf1             jl 0x12bbb
  012BCA  8b46fa           mov ax, word ptr [bp - 6]
  012BCD  0e               push cs
  012BCE  e81fff           call 0x12af0
  012BD1  eb39             jmp 0x12c0c
  012BD3  90               nop
  012BD4  8b367c44         mov si, word ptr [0x447c]
  012BD8  03f3             add si, bx
  012BDA  8a46fa           mov al, byte ptr [bp - 6]
  012BDD  fec0             inc al
  012BDF  268804           mov byte ptr es:[si], al
  012BE2  ff0e7644         dec word ptr [0x4476]
  012BE6  8b4efc           mov cx, word ptr [bp - 4]
  012BE9  41               inc cx
  012BEA  394ef6           cmp word ptr [bp - 0xa], cx
  012BED  7fbd             jg 0x12bac
  012BEF  8b76fa           mov si, word ptr [bp - 6]
  012BF2  8976f8           mov word ptr [bp - 8], si
  012BF5  6bde5a           imul bx, si, 0x5a
  012BF8  c436c849         les si, ptr [0x49c8]
  012BFC  26c60003         mov byte ptr es:[bx + si], 3
  012C00  03de             add bx, si
  012C02  26c6470300       mov byte ptr es:[bx + 3], 0
  012C07  26c6470200       mov byte ptr es:[bx + 2], 0
  012C0C  8b46f8           mov ax, word ptr [bp - 8]
  012C0F  5e               pop si
  012C10  5f               pop di
  012C11  c9               leave
  012C12  cb               retf
  012C13  90               nop

; ---- @ems_next_handle_page  file 0x012C14..0x012C66  seg 0x1145:0x1c4  (ems_2.c.obj) ----
  012C14  c8020000         enter 2, 0
  012C18  52               push dx
  012C19  50               push ax
  012C1A  57               push di
  012C1B  56               push si
  012C1C  bfffff           mov di, 0xffff
  012C1F  833e7a4400       cmp word ptr [0x447a], 0
  012C24  743a             je 0x12c60
  012C26  0e               push cs
  012C27  e832fe           call 0x12a5c
  012C2A  0bc0             or ax, ax
  012C2C  7532             jne 0x12c60
  012C2E  897efe           mov word ptr [bp - 2], di
  012C31  8b5efc           mov bx, word ptr [bp - 4]
  012C34  43               inc bx
  012C35  8b0e7c44         mov cx, word ptr [0x447c]
  012C39  8b3e4044         mov di, word ptr [0x4440]
  012C3D  8e067e44         mov es, word ptr [0x447e]
  012C41  8bf1             mov si, cx
  012C43  03f3             add si, bx
  012C45  268a04           mov al, byte ptr es:[si]
  012C48  2a46fa           sub al, byte ptr [bp - 6]
  012C4B  fec8             dec al
  012C4D  740f             je 0x12c5e
  012C4F  43               inc bx
  012C50  3bdf             cmp bx, di
  012C52  7ced             jl 0x12c41
  012C54  8b7efe           mov di, word ptr [bp - 2]
  012C57  8bc7             mov ax, di
  012C59  5e               pop si
  012C5A  5f               pop di
  012C5B  c9               leave
  012C5C  cb               retf
  012C5D  90               nop
  012C5E  8bfb             mov di, bx
  012C60  8bc7             mov ax, di
  012C62  5e               pop si
  012C63  5f               pop di
  012C64  c9               leave
  012C65  cb               retf

; ---- @ems_paging_shutdown  file 0x012C66..0x012C7A  seg 0x1145:0x216  (ems_2.c.obj) ----
  012C66  833e7a4400       cmp word ptr [0x447a], 0
  012C6B  740b             je 0x12c78
  012C6D  9a5e012d11       lcall 0x112d, 0x15e
  012C72  c7067a440000     mov word ptr [0x447a], 0
  012C78  cb               retf
  012C79  90               nop

; ---- @ems_paging_mode  file 0x012C7A..0x012C86  seg 0x1145:0x22a  (ems_2.c.obj) ----
  012C7A  8bd8             mov bx, ax
  012C7C  d1e3             shl bx, 1
  012C7E  8b878044         mov ax, word ptr [bx + 0x4480]
  012C82  a37844           mov word ptr [0x4478], ax
  012C85  cb               retf
