; MAPEDIT.EXE named disasm — module dos_crt0.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __aDBdoswp  file 0x00ECD6..0x00ED0A  seg 0x0:0xd6d6  (dos_crt0.asm.obj) ----
  00ECD6  8e460c           mov es, word ptr [bp + 0xc]
  00ECD9  8a04             mov al, byte ptr [si]
  00ECDB  98               cwde
  00ECDC  8bf8             mov di, ax
  00ECDE  4f               dec di
  00ECDF  46               inc si
  00ECE0  037e0a           add di, word ptr [bp + 0xa]
  00ECE3  268a4d02         mov cl, byte ptr es:[di + 2]
  00ECE7  2aed             sub ch, ch
  00ECE9  0bc9             or cx, cx
  00ECEB  7e07             jle 0xecf4
  00ECED  382c             cmp byte ptr [si], ch
  00ECEF  7403             je 0xecf4
  00ECF1  034efc           add cx, word ptr [bp - 4]
  00ECF4  014efe           add word ptr [bp - 2], cx
  00ECF7  803c00           cmp byte ptr [si], 0
  00ECFA  75dd             jne 0xecd9
  00ECFC  b8e715           mov ax, 0x15e7
  00ECFF  8ed8             mov ds, ax
  00ED01  8b46fe           mov ax, word ptr [bp - 2]
  00ED04  5e               pop si
  00ED05  5f               pop di
  00ED06  c9               leave
  00ED07  ca0800           retf 8

; ---- __astart  file 0x014E9E..0x014F61  seg 0x1388:0x1e  (dos_crt0.asm.obj) ----
  014E9E  b430             mov ah, 0x30
  014EA0  cd21             int 0x21
  014EA2  3c02             cmp al, 2
  014EA4  7305             jae 0x14eab
  014EA6  33c0             xor ax, ax
  014EA8  06               push es
  014EA9  50               push ax
  014EAA  cb               retf
  014EAB  bfe715           mov di, 0x15e7
  014EAE  8b360200         mov si, word ptr [2]
  014EB2  2bf7             sub si, di
  014EB4  81fe0010         cmp si, 0x1000
  014EB8  7203             jb 0x14ebd
  014EBA  be0010           mov si, 0x1000
  014EBD  fa               cli
  014EBE  8ed7             mov ss, di
  014EC0  81c4ae69         add sp, 0x69ae
  014EC4  fb               sti
  014EC5  7312             jae 0x14ed9
  014EC7  16               push ss
  014EC8  1f               pop ds
  014EC9  0e               push cs
  014ECA  e82d0f           call 0x15dfa
  014ECD  33c0             xor ax, ax
  014ECF  50               push ax
  014ED0  0e               push cs
  014ED1  e8ad11           call 0x16081
  014ED4  b8ff4c           mov ax, 0x4cff
  014ED7  cd21             int 0x21
  014ED9  8bc6             mov ax, si
  014EDB  b104             mov cl, 4
  014EDD  d3e0             shl ax, cl
  014EDF  48               dec ax
  014EE0  36a33245         mov word ptr ss:[0x4532], ax
  014EE4  bb3445           mov bx, 0x4534
  014EE7  368c17           mov word ptr ss:[bx], ss
  014EEA  83e4fe           and sp, 0xfffe
  014EED  36896704         mov word ptr ss:[bx + 4], sp
  014EF1  b8feff           mov ax, 0xfffe
  014EF4  50               push ax
  014EF5  3689670a         mov word ptr ss:[bx + 0xa], sp
  014EF9  f7d0             not ax
  014EFB  50               push ax
  014EFC  36896706         mov word ptr ss:[bx + 6], sp
  014F00  36896708         mov word ptr ss:[bx + 8], sp
  014F04  3689262e45       mov word ptr ss:[0x452e], sp
  014F09  03f7             add si, di
  014F0B  89360200         mov word ptr [2], si
  014F0F  8cc3             mov bx, es
  014F11  2bde             sub bx, si
  014F13  f7db             neg bx
  014F15  b44a             mov ah, 0x4a
  014F17  cd21             int 0x21
  014F19  368c1e6e45       mov word ptr ss:[0x456e], ds
  014F1E  16               push ss
  014F1F  07               pop es
  014F20  fc               cld
  014F21  bf9a49           mov di, 0x499a
  014F24  b9b069           mov cx, 0x69b0
  014F27  2bcf             sub cx, di
  014F29  33c0             xor ax, ax
  014F2B  f3aa             rep stosb byte ptr es:[di], al
  014F2D  16               push ss
  014F2E  1f               pop ds
  014F2F  8b0e9448         mov cx, word ptr [0x4894]
  014F33  e302             jcxz 0x14f37
  014F35  ffd1             call cx
  014F37  9a58118813       lcall 0x1388, 0x1158
  014F3C  9ac60f8813       lcall 0x1388, 0xfc6
  014F41  33ed             xor bp, bp
  014F43  9a16018813       lcall 0x1388, 0x116
  014F48  16               push ss
  014F49  1f               pop ds
  014F4A  ff368f45         push word ptr [0x458f]
  014F4E  ff368d45         push word ptr [0x458d]
  014F52  ff368b45         push word ptr [0x458b]
  014F56  9ad8280000       lcall 0, 0x28d8
  014F5B  50               push ax
  014F5C  0e               push cs
  014F5D  e8fb00           call 0x1505b
  014F60  c3               ret

; ---- __cintDIV  file 0x014F61..0x014F71  seg 0x1388:0xe1  (dos_crt0.asm.obj) ----
  014F61  2ea11301         mov ax, word ptr cs:[0x113]
  014F65  8ed8             mov ds, ax
  014F67  b80300           mov ax, 3
  014F6A  36c7063045db01   mov word ptr ss:[0x4530], 0x1db

; ---- __amsg_exit  file 0x014F71..0x014F93  seg 0x1388:0xf1  (dos_crt0.asm.obj) ----
  014F71  50               push ax
  014F72  0e               push cs
  014F73  e8840e           call 0x15dfa
  014F76  0e               push cs
  014F77  e80711           call 0x16081
  014F7A  36813e9648d6d6   cmp word ptr ss:[0x4896], 0xd6d6
  014F81  7507             jne 0x14f8a
  014F83  58               pop ax
  014F84  50               push ax
  014F85  36ff169a48       call word ptr ss:[0x489a]
  014F8A  b8ff00           mov ax, 0xff
  014F8D  50               push ax
  014F8E  0e               push cs
  014F8F  ff163045         call word ptr [0x4530]

; ---- __dataseg  file 0x014F93..0x014F96  seg 0x1388:0x113  (dos_crt0.asm.obj) ----
  014F93  e715             out 0x15, ax
  014F95  00               .byte 0x00
