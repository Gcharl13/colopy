; MAPEDIT.EXE named disasm — module timer_3.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _TIMER_INTERRUPT_8_HANDLER  file 0x00E7CC..0x00E931  seg 0xD1C:0xc  (timer_3.ASM.obj) ----
  00E7CC  50               push ax
  00E7CD  1e               push ds
  00E7CE  b8e715           mov ax, 0x15e7
  00E7D1  8ed8             mov ds, ax
  00E7D3  8306b65001       add word ptr [0x50b6], 1
  00E7D8  8316b85000       adc word ptr [0x50b8], 0
  00E7DD  f706b6500100     test word ptr [0x50b6], 1
  00E7E3  7418             je 0xe7fd
  00E7E5  eb0f             jmp 0xe7f6
  00E7E7  90               nop
  00E7E8  b8e715           mov ax, 0x15e7
  00E7EB  8ed8             mov ds, ax
  00E7ED  fa               cli
  00E7EE  8e168507         mov ss, word ptr [0x785]
  00E7F2  8b268307         mov sp, word ptr [0x783]
  00E7F6  b020             mov al, 0x20
  00E7F8  e620             out 0x20, al
  00E7FA  1f               pop ds
  00E7FB  58               pop ax
  00E7FC  cf               iret
  00E7FD  8c168507         mov word ptr [0x785], ss
  00E801  89268307         mov word ptr [0x783], sp
  00E805  b8e715           mov ax, 0x15e7
  00E808  8ed0             mov ss, ax
  00E80A  bc8c39           mov sp, 0x398c
  00E80D  81c4fe00         add sp, 0xfe
  00E811  803e7c4a00       cmp byte ptr [0x4a7c], 0
  00E816  7415             je 0xe82d
  00E818  53               push bx
  00E819  51               push cx
  00E81A  52               push dx
  00E81B  56               push si
  00E81C  57               push di
  00E81D  55               push bp
  00E81E  1e               push ds
  00E81F  06               push es
  00E820  9a61002711       lcall 0x1127, 0x61
  00E825  07               pop es
  00E826  1f               pop ds
  00E827  5d               pop bp
  00E828  5f               pop di
  00E829  5e               pop si
  00E82A  5a               pop dx
  00E82B  59               pop cx
  00E82C  5b               pop bx
  00E82D  fe0e7e07         dec byte ptr [0x77e]
  00E831  7410             je 0xe843
  00E833  833e824a00       cmp word ptr [0x4a82], 0
  00E838  74ae             je 0xe7e8
  00E83A  c706824a0000     mov word ptr [0x4a82], 0
  00E840  e9ad00           jmp 0xe8f0
  00E843  c6067e0705       mov byte ptr [0x77e], 5
  00E848  803e8c4a00       cmp byte ptr [0x4a8c], 0
  00E84D  742a             je 0xe879
  00E84F  53               push bx
  00E850  51               push cx
  00E851  52               push dx
  00E852  56               push si
  00E853  57               push di
  00E854  06               push es
  00E855  1e               push ds
  00E856  55               push bp
  00E857  9a5d002711       lcall 0x1127, 0x5d
  00E85C  5d               pop bp
  00E85D  1f               pop ds
  00E85E  07               pop es
  00E85F  5f               pop di
  00E860  5e               pop si
  00E861  5a               pop dx
  00E862  59               pop cx
  00E863  5b               pop bx
  00E864  0bc0             or ax, ax
  00E866  7411             je 0xe879
  00E868  7809             js 0xe873
  00E86A  c7067c4affff     mov word ptr [0x4a7c], 0xffff
  00E870  eb07             jmp 0xe879
  00E872  90               nop
  00E873  c7067c4a0000     mov word ptr [0x4a7c], 0
  00E879  8306724e01       add word ptr [0x4e72], 1
  00E87E  8316744e00       adc word ptr [0x4e74], 0
  00E883  833ea84e00       cmp word ptr [0x4ea8], 0
  00E888  745d             je 0xe8e7
  00E88A  833e6a4a00       cmp word ptr [0x4a6a], 0
  00E88F  7407             je 0xe898
  00E891  ff066c4c         inc word ptr [0x4c6c]
  00E895  eb50             jmp 0xe8e7
  00E897  90               nop
  00E898  fe0e7f07         dec byte ptr [0x77f]
  00E89C  7506             jne 0xe8a4
  00E89E  c706824affff     mov word ptr [0x4a82], 0xffff
  00E8A4  fa               cli
  00E8A5  c7066a4a0100     mov word ptr [0x4a6a], 1
  00E8AB  b020             mov al, 0x20
  00E8AD  e620             out 0x20, al
  00E8AF  a18507           mov ax, word ptr [0x785]
  00E8B2  a38907           mov word ptr [0x789], ax
  00E8B5  a18307           mov ax, word ptr [0x783]
  00E8B8  a38707           mov word ptr [0x787], ax
  00E8BB  b8e715           mov ax, 0x15e7
  00E8BE  8ed0             mov ss, ax
  00E8C0  bc8c07           mov sp, 0x78c
  00E8C3  81c4fe31         add sp, 0x31fe
  00E8C7  fb               sti
  00E8C8  53               push bx
  00E8C9  51               push cx
  00E8CA  52               push dx
  00E8CB  06               push es
  00E8CC  fc               cld
  00E8CD  ff1e265e         lcall [0x5e26]
  00E8D1  07               pop es
  00E8D2  5a               pop dx
  00E8D3  59               pop cx
  00E8D4  5b               pop bx
  00E8D5  fa               cli
  00E8D6  8e168907         mov ss, word ptr [0x789]
  00E8DA  8b268707         mov sp, word ptr [0x787]
  00E8DE  c7066a4a0000     mov word ptr [0x4a6a], 0
  00E8E4  1f               pop ds
  00E8E5  58               pop ax
  00E8E6  cf               iret
  00E8E7  fe0e7f07         dec byte ptr [0x77f]
  00E8EB  7403             je 0xe8f0
  00E8ED  e9f8fe           jmp 0xe7e8
  00E8F0  c6067f0703       mov byte ptr [0x77f], 3
  00E8F5  fe0e8007         dec byte ptr [0x780]
  00E8F9  7521             jne 0xe91c
  00E8FB  53               push bx
  00E8FC  bb7f07           mov bx, 0x77f
  00E8FF  8a470c           mov al, byte ptr [bx + 0xc]
  00E902  bb743a           mov bx, 0x3a74
  00E905  884718           mov byte ptr [bx + 0x18], al
  00E908  06               push es
  00E909  33db             xor bx, bx
  00E90B  8edb             mov ds, bx
  00E90D  c45f0c           les bx, ptr [bx + 0xc]
  00E910  26803fcf         cmp byte ptr es:[bx], 0xcf
  00E914  7404             je 0xe91a
  00E916  26c607cf         mov byte ptr es:[bx], 0xcf
  00E91A  07               pop es
  00E91B  5b               pop bx
  00E91C  b8e715           mov ax, 0x15e7
  00E91F  8ed8             mov ds, ax
  00E921  fa               cli
  00E922  8e168507         mov ss, word ptr [0x785]
  00E926  8b268307         mov sp, word ptr [0x783]
  00E92A  1f               pop ds
  00E92B  58               pop ax
  00E92C  2eff2e0800       ljmp cs:[8]

; ---- _TIMER_SET_COPY_PROTECT  file 0x00E931..0x00E93D  seg 0xD1C:0x171  (timer_3.ASM.obj) ----
  00E931  c8000000         enter 0, 0
  00E935  8b4606           mov ax, word ptr [bp + 6]
  00E938  a28b07           mov byte ptr [0x78b], al
  00E93B  c9               leave
  00E93C  cb               retf

; ---- _timer_install  file 0x00E93D..0x00E9B3  seg 0xD1C:0x17d  (timer_3.ASM.obj) ----
  00E93D  c7068c4a0000     mov word ptr [0x4a8c], 0
  00E943  c7067c4a0000     mov word ptr [0x4a7c], 0
  00E949  c6067e0701       mov byte ptr [0x77e], 1
  00E94E  c6067f0701       mov byte ptr [0x77f], 1
  00E953  c606800701       mov byte ptr [0x780], 1
  00E958  c706724e0000     mov word ptr [0x4e72], 0
  00E95E  c706744e0000     mov word ptr [0x4e74], 0
  00E964  c706b6500000     mov word ptr [0x50b6], 0
  00E96A  c706b8500000     mov word ptr [0x50b8], 0
  00E970  c7066a4a0000     mov word ptr [0x4a6a], 0
  00E976  b008             mov al, 8
  00E978  b435             mov ah, 0x35
  00E97A  cd21             int 0x21
  00E97C  2e891e0800       mov word ptr cs:[8], bx
  00E981  8cc3             mov bx, es
  00E983  2e891e0a00       mov word ptr cs:[0xa], bx
  00E988  1e               push ds
  00E989  ba0c00           mov dx, 0xc
  00E98C  0e               push cs
  00E98D  1f               pop ds
  00E98E  b008             mov al, 8
  00E990  b425             mov ah, 0x25
  00E992  cd21             int 0x21
  00E994  1f               pop ds
  00E995  68a807           push 0x7a8
  00E998  9a06005b10       lcall 0x105b, 6
  00E99D  83c402           add sp, 2
  00E9A0  b8e715           mov ax, 0x15e7
  00E9A3  a37807           mov word ptr [0x778], ax
  00E9A6  b8724e           mov ax, 0x4e72
  00E9A9  a37607           mov word ptr [0x776], ax
  00E9AC  c7068107ffff     mov word ptr [0x781], 0xffff
  00E9B2  cb               retf

; ---- _timer_remove  file 0x00E9B3..0x00E9EB  seg 0xD1C:0x1f3  (timer_3.ASM.obj) ----
  00E9B3  833e810700       cmp word ptr [0x781], 0
  00E9B8  742a             je 0xe9e4
  00E9BA  1e               push ds
  00E9BB  2e8b160a00       mov dx, word ptr cs:[0xa]
  00E9C0  8eda             mov ds, dx
  00E9C2  2e8b160800       mov dx, word ptr cs:[8]
  00E9C7  b008             mov al, 8
  00E9C9  b425             mov ah, 0x25
  00E9CB  cd21             int 0x21
  00E9CD  1f               pop ds
  00E9CE  6a00             push 0
  00E9D0  9a06005b10       lcall 0x105b, 6
  00E9D5  83c402           add sp, 2
  00E9D8  b84000           mov ax, 0x40
  00E9DB  a37807           mov word ptr [0x778], ax
  00E9DE  b86c00           mov ax, 0x6c
  00E9E1  a37607           mov word ptr [0x776], ax
  00E9E4  c70681070000     mov word ptr [0x781], 0
  00E9EA  cb               retf

; ---- _TIMER_SET_SOUND_FLAG  file 0x00E9EB..0x00E9FD  seg 0xD1C:0x22b  (timer_3.ASM.obj) ----
  00E9EB  c8000000         enter 0, 0
  00E9EF  8b4606           mov ax, word ptr [bp + 6]
  00E9F2  a38c4a           mov word ptr [0x4a8c], ax
  00E9F5  c7067c4a0000     mov word ptr [0x4a7c], 0
  00E9FB  c9               leave
  00E9FC  cb               retf

; ---- _TIMER_ACTIVATE_LOW_PRIORITY  file 0x00E9FD..0x00EA2D  seg 0xD1C:0x23d  (timer_3.ASM.obj) ----
  00E9FD  c8000000         enter 0, 0
  00EA01  06               push es
  00EA02  57               push di
  00EA03  c47e06           les di, ptr [bp + 6]
  00EA06  8cc0             mov ax, es
  00EA08  9c               pushf
  00EA09  fa               cli
  00EA0A  893e265e         mov word ptr [0x5e26], di
  00EA0E  a3285e           mov word ptr [0x5e28], ax
  00EA11  0bc7             or ax, di
  00EA13  c7066a4a0000     mov word ptr [0x4a6a], 0
  00EA19  c7066c4c0000     mov word ptr [0x4c6c], 0
  00EA1F  c706824a0000     mov word ptr [0x4a82], 0
  00EA25  a3a84e           mov word ptr [0x4ea8], ax
  00EA28  9d               popf
  00EA29  5f               pop di
  00EA2A  07               pop es
  00EA2B  c9               leave
  00EA2C  cb               retf

; ---- _TIMER_GET_INTERRUPT_STACK  file 0x00EA2D..0x00EA34  seg 0xD1C:0x26d  (timer_3.ASM.obj) ----
  00EA2D  bae715           mov dx, 0x15e7
  00EA30  b88c07           mov ax, 0x78c
  00EA33  cb               retf

; ---- _TIMER_GET_COPY_PROTECT  file 0x00EA34..0x00EA3A  seg 0xD1C:0x274  (timer_3.ASM.obj) ----
  00EA34  a08c3a           mov al, byte ptr [0x3a8c]
  00EA37  32e4             xor ah, ah
  00EA39  cb               retf
