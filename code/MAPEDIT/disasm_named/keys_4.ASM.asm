; MAPEDIT.EXE named disasm — module keys_4.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _KEYS_9_HANDLER  file 0x011605..0x011684  seg 0xFFE:0x25  (keys_4.ASM.obj) ----
  011605  fb               sti
  011606  50               push ax
  011607  2e803e150000     cmp byte ptr cs:[0x15], 0
  01160D  745c             je 0x1166b
  01160F  e460             in al, 0x60
  011611  3ce0             cmp al, 0xe0
  011613  7506             jne 0x1161b
  011615  2ec606170002     mov byte ptr cs:[0x17], 2
  01161B  3ce1             cmp al, 0xe1
  01161D  7506             jne 0x11625
  01161F  2ec606170003     mov byte ptr cs:[0x17], 3
  011625  8ae0             mov ah, al
  011627  247f             and al, 0x7f
  011629  3c47             cmp al, 0x47
  01162B  723e             jb 0x1166b
  01162D  3c53             cmp al, 0x53
  01162F  773a             ja 0x1166b
  011631  53               push bx
  011632  2c47             sub al, 0x47
  011634  bb1800           mov bx, 0x18
  011637  2ed7             xlatb
  011639  5b               pop bx
  01163A  d0e4             shl ah, 1
  01163C  720a             jb 0x11648
  01163E  0c80             or al, 0x80
  011640  2e08061600       or byte ptr cs:[0x16], al
  011645  eb0e             jmp 0x11655
  011647  90               nop
  011648  f6d0             not al
  01164A  2e22061600       and al, byte ptr cs:[0x16]
  01164F  0c80             or al, 0x80
  011651  2ea21600         mov byte ptr cs:[0x16], al
  011655  e461             in al, 0x61
  011657  eb00             jmp 0x11659
  011659  0c80             or al, 0x80
  01165B  e661             out 0x61, al
  01165D  eb00             jmp 0x1165f
  01165F  247f             and al, 0x7f
  011661  e661             out 0x61, al
  011663  eb00             jmp 0x11665
  011665  b020             mov al, 0x20
  011667  e620             out 0x20, al
  011669  58               pop ax
  01166A  cf               iret
  01166B  2e8a261700       mov ah, byte ptr cs:[0x17]
  011670  0ae4             or ah, ah
  011672  7409             je 0x1167d
  011674  fecc             dec ah
  011676  2e88261700       mov byte ptr cs:[0x17], ah
  01167B  ebd8             jmp 0x11655
  01167D  58               pop ax
  01167E  fa               cli
  01167F  2eff2e0c00       ljmp cs:[0xc]

; ---- _KEYS_1C_HANDLER  file 0x011684..0x011752  seg 0xFFE:0xa4  (keys_4.ASM.obj) ----
  011684  50               push ax
  011685  1e               push ds
  011686  b8e715           mov ax, 0x15e7
  011689  8ed8             mov ds, ax
  01168B  a1de52           mov ax, word ptr [0x52de]
  01168E  0bc0             or ax, ax
  011690  7503             jne 0x11695
  011692  e99e00           jmp 0x11733
  011695  2ea01600         mov al, byte ptr cs:[0x16]
  011699  32e4             xor ah, ah
  01169B  0bc0             or ax, ax
  01169D  7503             jne 0x116a2
  01169F  e99100           jmp 0x11733
  0116A2  2e802616007f     and byte ptr cs:[0x16], 0x7f
  0116A8  53               push bx
  0116A9  51               push cx
  0116AA  52               push dx
  0116AB  1e               push ds
  0116AC  33db             xor bx, bx
  0116AE  8edb             mov ds, bx
  0116B0  bb1704           mov bx, 0x417
  0116B3  8a1f             mov bl, byte ptr [bx]
  0116B5  1f               pop ds
  0116B6  50               push ax
  0116B7  50               push ax
  0116B8  50               push ax
  0116B9  c1e804           shr ax, 4
  0116BC  250300           and ax, 3
  0116BF  a36e4c           mov word ptr [0x4c6e], ax
  0116C2  58               pop ax
  0116C3  c1e806           shr ax, 6
  0116C6  250100           and ax, 1
  0116C9  a38a4a           mov word ptr [0x4a8a], ax
  0116CC  58               pop ax
  0116CD  240c             and al, 0xc
  0116CF  c1c803           ror ax, 3
  0116D2  99               cdq
  0116D3  32e4             xor ah, ah
  0116D5  03d0             add dx, ax
  0116D7  f6c310           test bl, 0x10
  0116DA  750b             jne 0x116e7
  0116DC  03d2             add dx, dx
  0116DE  03d2             add dx, dx
  0116E0  f6c303           test bl, 3
  0116E3  7402             je 0x116e7
  0116E5  03d2             add dx, dx
  0116E7  8b0e225e         mov cx, word ptr [0x5e22]
  0116EB  03ca             add cx, dx
  0116ED  0bc9             or cx, cx
  0116EF  7902             jns 0x116f3
  0116F1  33c9             xor cx, cx
  0116F3  81f93f01         cmp cx, 0x13f
  0116F7  7e03             jle 0x116fc
  0116F9  b93f01           mov cx, 0x13f
  0116FC  d1e1             shl cx, 1
  0116FE  58               pop ax
  0116FF  2403             and al, 3
  011701  d1c8             ror ax, 1
  011703  99               cdq
  011704  32e4             xor ah, ah
  011706  03d0             add dx, ax
  011708  f6c310           test bl, 0x10
  01170B  750b             jne 0x11718
  01170D  03d2             add dx, dx
  01170F  03d2             add dx, dx
  011711  f6c303           test bl, 3
  011714  7402             je 0x11718
  011716  03d2             add dx, dx
  011718  0316245e         add dx, word ptr [0x5e24]
  01171C  0bd2             or dx, dx
  01171E  7902             jns 0x11722
  011720  33d2             xor dx, dx
  011722  81fac700         cmp dx, 0xc7
  011726  7e03             jle 0x1172b
  011728  bac700           mov dx, 0xc7
  01172B  9af803650f       lcall 0xf65, 0x3f8
  011730  5a               pop dx
  011731  59               pop cx
  011732  5b               pop bx
  011733  a10e45           mov ax, word ptr [0x450e]
  011736  0bc0             or ax, ax
  011738  7411             je 0x1174b
  01173A  53               push bx
  01173B  51               push cx
  01173C  52               push dx
  01173D  56               push si
  01173E  57               push di
  01173F  06               push es
  011740  9a0c00ad12       lcall 0x12ad, 0xc
  011745  07               pop es
  011746  5f               pop di
  011747  5e               pop si
  011748  5a               pop dx
  011749  59               pop cx
  01174A  5b               pop bx
  01174B  1f               pop ds
  01174C  58               pop ax
  01174D  2eff2e1000       ljmp cs:[0x10]

; ---- _KEYS_INSTALL  file 0x011752..0x0117A7  seg 0xFFE:0x172  (keys_4.ASM.obj) ----
  011752  1e               push ds
  011753  2ec606160000     mov byte ptr cs:[0x16], 0
  011759  c7066e4c0000     mov word ptr [0x4c6e], 0
  01175F  b009             mov al, 9
  011761  b435             mov ah, 0x35
  011763  cd21             int 0x21
  011765  2e891e0c00       mov word ptr cs:[0xc], bx
  01176A  8cc3             mov bx, es
  01176C  2e891e0e00       mov word ptr cs:[0xe], bx
  011771  ba2500           mov dx, 0x25
  011774  0e               push cs
  011775  1f               pop ds
  011776  b009             mov al, 9
  011778  b425             mov ah, 0x25
  01177A  cd21             int 0x21
  01177C  b01c             mov al, 0x1c
  01177E  b435             mov ah, 0x35
  011780  cd21             int 0x21
  011782  2e891e1000       mov word ptr cs:[0x10], bx
  011787  8cc3             mov bx, es
  011789  2e891e1200       mov word ptr cs:[0x12], bx
  01178E  baa400           mov dx, 0xa4
  011791  0e               push cs
  011792  1f               pop ds
  011793  b01c             mov al, 0x1c
  011795  b425             mov ah, 0x25
  011797  cd21             int 0x21
  011799  1f               pop ds
  01179A  2ec6061400ff     mov byte ptr cs:[0x14], 0xff
  0117A0  2ec6061500ff     mov byte ptr cs:[0x15], 0xff
  0117A6  cb               retf

; ---- _keys_remove  file 0x0117A7..0x0117E2  seg 0xFFE:0x1c7  (keys_4.ASM.obj) ----
  0117A7  2e803e140000     cmp byte ptr cs:[0x14], 0
  0117AD  7426             je 0x117d5
  0117AF  1e               push ds
  0117B0  2e8b160e00       mov dx, word ptr cs:[0xe]
  0117B5  8eda             mov ds, dx
  0117B7  2e8b160c00       mov dx, word ptr cs:[0xc]
  0117BC  b009             mov al, 9
  0117BE  b425             mov ah, 0x25
  0117C0  cd21             int 0x21
  0117C2  2e8b161200       mov dx, word ptr cs:[0x12]
  0117C7  8eda             mov ds, dx
  0117C9  2e8b161000       mov dx, word ptr cs:[0x10]
  0117CE  b01c             mov al, 0x1c
  0117D0  b425             mov ah, 0x25
  0117D2  cd21             int 0x21
  0117D4  1f               pop ds
  0117D5  2ec606140000     mov byte ptr cs:[0x14], 0
  0117DB  c7066e4c0000     mov word ptr [0x4c6e], 0
  0117E1  cb               retf

; ---- _KEYS_CHECK_INSTALLED  file 0x0117E2..0x0117E8  seg 0xFFE:0x202  (keys_4.ASM.obj) ----
  0117E2  2ea01400         mov al, byte ptr cs:[0x14]
  0117E6  98               cwde
  0117E7  cb               retf

; ---- _KEYS_ENABLE  file 0x0117E8..0x0117EF  seg 0xFFE:0x208  (keys_4.ASM.obj) ----
  0117E8  2ec6061500ff     mov byte ptr cs:[0x15], 0xff
  0117EE  cb               retf

; ---- _KEYS_DISABLE  file 0x0117EF..0x0117FC  seg 0xFFE:0x20f  (keys_4.ASM.obj) ----
  0117EF  2ec606150000     mov byte ptr cs:[0x15], 0
  0117F5  2ec606160000     mov byte ptr cs:[0x16], 0
  0117FB  cb               retf
