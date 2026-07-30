; MAPEDIT.EXE named disasm — module 125.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __cinit  file 0x014F96..0x01505B  seg 0x1388:0x116  (125.obj) ----
  014F96  b80035           mov ax, 0x3500
  014F99  cd21             int 0x21
  014F9B  891e5a45         mov word ptr [0x455a], bx
  014F9F  8c065c45         mov word ptr [0x455c], es
  014FA3  0e               push cs
  014FA4  1f               pop ds
  014FA5  b80025           mov ax, 0x2500
  014FA8  bae100           mov dx, 0xe1
  014FAB  cd21             int 0x21
  014FAD  16               push ss
  014FAE  1f               pop ds
  014FAF  8b0ea848         mov cx, word ptr [0x48a8]
  014FB3  e32e             jcxz 0x14fe3
  014FB5  8e066e45         mov es, word ptr [0x456e]
  014FB9  268b362c00       mov si, word ptr es:[0x2c]
  014FBE  c506aa48         lds ax, ptr [0x48aa]
  014FC2  8cda             mov dx, ds
  014FC4  33db             xor bx, bx
  014FC6  36ff1ea648       lcall ss:[0x48a6]
  014FCB  7305             jae 0x14fd2
  014FCD  16               push ss
  014FCE  1f               pop ds
  014FCF  e94a0e           jmp 0x15e1c
  014FD2  36c506ae48       lds ax, ptr ss:[0x48ae]
  014FD7  8cda             mov dx, ds
  014FD9  bb0300           mov bx, 3
  014FDC  36ff1ea648       lcall ss:[0x48a6]
  014FE1  16               push ss
  014FE2  1f               pop ds
  014FE3  8e066e45         mov es, word ptr [0x456e]
  014FE7  268b0e2c00       mov cx, word ptr es:[0x2c]
  014FEC  e33e             jcxz 0x1502c
  014FEE  8ec1             mov es, cx
  014FF0  33ff             xor di, di
  014FF2  26803d00         cmp byte ptr es:[di], 0
  014FF6  7434             je 0x1502c
  014FF8  b90d00           mov cx, 0xd
  014FFB  be4c45           mov si, 0x454c
  014FFE  f3a6             repe cmpsb byte ptr [si], byte ptr es:[di]
  015000  740b             je 0x1500d
  015002  b9ff7f           mov cx, 0x7fff
  015005  33c0             xor ax, ax
  015007  f2ae             repne scasb al, byte ptr es:[di]
  015009  7521             jne 0x1502c
  01500B  ebe5             jmp 0x14ff2
  01500D  06               push es
  01500E  1e               push ds
  01500F  07               pop es
  015010  1f               pop ds
  015011  8bf7             mov si, di
  015013  bf7745           mov di, 0x4577
  015016  b104             mov cl, 4
  015018  ac               lodsb al, byte ptr [si]
  015019  2c41             sub al, 0x41
  01501B  720d             jb 0x1502a
  01501D  d2e0             shl al, cl
  01501F  92               xchg dx, ax
  015020  ac               lodsb al, byte ptr [si]
  015021  2c41             sub al, 0x41
  015023  7205             jb 0x1502a
  015025  0ac2             or al, dl
  015027  aa               stosb byte ptr es:[di], al
  015028  ebee             jmp 0x15018
  01502A  16               push ss
  01502B  1f               pop ds
  01502C  bb0400           mov bx, 4
  01502F  80a77745bf       and byte ptr [bx + 0x4577], 0xbf
  015034  b80044           mov ax, 0x4400
  015037  cd21             int 0x21
  015039  720a             jb 0x15045
  01503B  f6c280           test dl, 0x80
  01503E  7405             je 0x15045
  015040  808f774540       or byte ptr [bx + 0x4577], 0x40
  015045  4b               dec bx
  015046  79e7             jns 0x1502f
  015048  beb248           mov si, 0x48b2
  01504B  bfb248           mov di, 0x48b2
  01504E  e8ba00           call 0x1510b
  015051  beb248           mov si, 0x48b2
  015054  bfb248           mov di, 0x48b2
  015057  e8b100           call 0x1510b
  01505A  cb               retf

; ---- _exit  file 0x01505B..0x015062  seg 0x1388:0x1db  (125.obj) ----
  01505B  55               push bp
  01505C  8bec             mov bp, sp
  01505E  33c9             xor cx, cx
  015060  eb1a             jmp 0x1507c

; ---- __exit  file 0x015062..0x01506A  seg 0x1388:0x1e2  (125.obj) ----
  015062  55               push bp
  015063  8bec             mov bp, sp
  015065  b90100           mov cx, 1
  015068  eb12             jmp 0x1507c

; ---- __cexit  file 0x01506A..0x015074  seg 0x1388:0x1ea  (125.obj) ----
  01506A  55               push bp
  01506B  8bec             mov bp, sp
  01506D  56               push si
  01506E  57               push di
  01506F  b90001           mov cx, 0x100
  015072  eb08             jmp 0x1507c

; ---- __c_exit  file 0x015074..0x0150DE  seg 0x1388:0x1f4  (125.obj) ----
  015074  55               push bp
  015075  8bec             mov bp, sp
  015077  56               push si
  015078  57               push di
  015079  b90101           mov cx, 0x101
  01507C  51               push cx
  01507D  0ac9             or cl, cl
  01507F  751e             jne 0x1509f
  015081  beb249           mov si, 0x49b2
  015084  bfb249           mov di, 0x49b2
  015087  e88100           call 0x1510b
  01508A  beb248           mov si, 0x48b2
  01508D  bfb648           mov di, 0x48b6
  015090  e87800           call 0x1510b
  015093  813e9648d6d6     cmp word ptr [0x4896], 0xd6d6
  015099  7504             jne 0x1509f
  01509B  ff169c48         call word ptr [0x489c]
  01509F  beb648           mov si, 0x48b6
  0150A2  bfb648           mov di, 0x48b6
  0150A5  e86300           call 0x1510b
  0150A8  beb648           mov si, 0x48b6
  0150AB  bfb648           mov di, 0x48b6
  0150AE  e85a00           call 0x1510b
  0150B1  9aa20f8813       lcall 0x1388, 0xfa2
  0150B6  0bc0             or ax, ax
  0150B8  7411             je 0x150cb
  0150BA  58               pop ax
  0150BB  0ae4             or ah, ah
  0150BD  50               push ax
  0150BE  750b             jne 0x150cb
  0150C0  837e0600         cmp word ptr [bp + 6], 0
  0150C4  7505             jne 0x150cb
  0150C6  c74606ff00       mov word ptr [bp + 6], 0xff
  0150CB  e81000           call 0x150de
  0150CE  58               pop ax
  0150CF  0ae4             or ah, ah
  0150D1  7507             jne 0x150da
  0150D3  8b4606           mov ax, word ptr [bp + 6]
  0150D6  b44c             mov ah, 0x4c
  0150D8  cd21             int 0x21
  0150DA  5f               pop di
  0150DB  5e               pop si
  0150DC  5d               pop bp
  0150DD  cb               retf

; ---- __ctermsub  file 0x0150DE..0x01511E  seg 0x1388:0x25e  (125.obj) ----
  0150DE  8b0ea848         mov cx, word ptr [0x48a8]
  0150E2  e307             jcxz 0x150eb
  0150E4  bb0200           mov bx, 2
  0150E7  ff1ea648         lcall [0x48a6]
  0150EB  1e               push ds
  0150EC  c5165a45         lds dx, ptr [0x455a]
  0150F0  b80025           mov ax, 0x2500
  0150F3  cd21             int 0x21
  0150F5  1f               pop ds
  0150F6  803e984500       cmp byte ptr [0x4598], 0
  0150FB  740d             je 0x1510a
  0150FD  1e               push ds
  0150FE  a09945           mov al, byte ptr [0x4599]
  015101  c5169a45         lds dx, ptr [0x459a]
  015105  b425             mov ah, 0x25
  015107  cd21             int 0x21
  015109  1f               pop ds
  01510A  c3               ret
  01510B  3bf7             cmp si, di
  01510D  730e             jae 0x1511d
  01510F  83ef04           sub di, 4
  015112  8b05             mov ax, word ptr [di]
  015114  0b4502           or ax, word ptr [di + 2]
  015117  74f2             je 0x1510b
  015119  ff1d             lcall [di]
  01511B  ebee             jmp 0x1510b
  01511D  c3               ret
