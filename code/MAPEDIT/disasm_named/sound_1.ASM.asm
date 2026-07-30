; MAPEDIT.EXE named disasm — module sound_1.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _SOUND_DRIVER_LOAD  file 0x012754..0x012802  seg 0x1115:0x4  (sound_1.ASM.obj) ----
  012754  c8040000         enter 4, 0
  012758  06               push es
  012759  1e               push ds
  01275A  56               push si
  01275B  57               push di
  01275C  33c0             xor ax, ax
  01275E  8946fc           mov word ptr [bp - 4], ax
  012761  bbffff           mov bx, 0xffff
  012764  b448             mov ah, 0x48
  012766  cd21             int 0x21
  012768  7203             jb 0x1276d
  01276A  e98000           jmp 0x127ed
  01276D  83eb02           sub bx, 2
  012770  895efe           mov word ptr [bp - 2], bx
  012773  b448             mov ah, 0x48
  012775  cd21             int 0x21
  012777  7303             jae 0x1277c
  012779  eb7f             jmp 0x127fa
  01277B  90               nop
  01277C  8946fc           mov word ptr [bp - 4], ax
  01277F  50               push ax
  012780  48               dec ax
  012781  8ec0             mov es, ax
  012783  bf0800           mov di, 8
  012786  be1d44           mov si, 0x441d
  012789  b90800           mov cx, 8
  01278C  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  01278E  58               pop ax
  01278F  55               push bp
  012790  8cd1             mov cx, ss
  012792  890e1544         mov word ptr [0x4415], cx
  012796  89261744         mov word ptr [0x4417], sp
  01279A  1e               push ds
  01279B  07               pop es
  01279C  bb1944           mov bx, 0x4419
  01279F  8907             mov word ptr [bx], ax
  0127A1  894702           mov word ptr [bx + 2], ax
  0127A4  c55606           lds dx, ptr [bp + 6]
  0127A7  b003             mov al, 3
  0127A9  b44b             mov ah, 0x4b
  0127AB  cd21             int 0x21
  0127AD  bae715           mov dx, 0x15e7
  0127B0  8eda             mov ds, dx
  0127B2  8b161544         mov dx, word ptr [0x4415]
  0127B6  8ed2             mov ss, dx
  0127B8  8b261744         mov sp, word ptr [0x4417]
  0127BC  5d               pop bp
  0127BD  722e             jb 0x127ed
  0127BF  8e061944         mov es, word ptr [0x4419]
  0127C3  268b1e2a00       mov bx, word ptr es:[0x2a]
  0127C8  26a12c00         mov ax, word ptr es:[0x2c]
  0127CC  050f00           add ax, 0xf
  0127CF  d1d8             rcr ax, 1
  0127D1  c1e803           shr ax, 3
  0127D4  03d8             add bx, ax
  0127D6  8cc0             mov ax, es
  0127D8  2bd8             sub bx, ax
  0127DA  83c308           add bx, 8
  0127DD  3b5efe           cmp bx, word ptr [bp - 2]
  0127E0  770b             ja 0x127ed
  0127E2  b44a             mov ah, 0x4a
  0127E4  cd21             int 0x21
  0127E6  7205             jb 0x127ed
  0127E8  8cc0             mov ax, es
  0127EA  eb10             jmp 0x127fc
  0127EC  90               nop
  0127ED  8b46fc           mov ax, word ptr [bp - 4]
  0127F0  0bc0             or ax, ax
  0127F2  7406             je 0x127fa
  0127F4  8ec0             mov es, ax
  0127F6  b449             mov ah, 0x49
  0127F8  cd21             int 0x21
  0127FA  33c0             xor ax, ax
  0127FC  5f               pop di
  0127FD  5e               pop si
  0127FE  1f               pop ds
  0127FF  07               pop es
  012800  c9               leave
  012801  cb               retf

; ---- _SOUND_DRIVER_INIT  file 0x012802..0x012833  seg 0x1115:0xb2  (sound_1.ASM.obj) ----
  012802  c8000000         enter 0, 0
  012806  06               push es
  012807  1e               push ds
  012808  56               push si
  012809  57               push di
  01280A  c6061444ff       mov byte ptr [0x4414], 0xff
  01280F  8b5606           mov dx, word ptr [bp + 6]
  012812  0bd2             or dx, dx
  012814  7417             je 0x1282d
  012816  be3200           mov si, 0x32
  012819  bf2a60           mov di, 0x602a
  01281C  b8e715           mov ax, 0x15e7
  01281F  8ec0             mov es, ax
  012821  b90500           mov cx, 5
  012824  8eda             mov ds, dx
  012826  a12800           mov ax, word ptr [0x28]
  012829  a5               movsw word ptr es:[di], word ptr [si]
  01282A  ab               stosw word ptr es:[di], ax
  01282B  e2fc             loop 0x12829
  01282D  5f               pop di
  01282E  5e               pop si
  01282F  1f               pop ds
  012830  07               pop es
  012831  c9               leave
  012832  cb               retf

; ---- _SOUND_DRIVER_REMOVE  file 0x012833..0x01284D  seg 0x1115:0xe3  (sound_1.ASM.obj) ----
  012833  c8000000         enter 0, 0
  012837  06               push es
  012838  8b4606           mov ax, word ptr [bp + 6]
  01283B  0bc0             or ax, ax
  01283D  740b             je 0x1284a
  01283F  8ec0             mov es, ax
  012841  b449             mov ah, 0x49
  012843  cd21             int 0x21
  012845  9a00011511       lcall 0x1115, 0x100
  01284A  07               pop es
  01284B  c9               leave
  01284C  cb               retf

; ---- _SOUND_DUMMY  file 0x01284D..0x012850  seg 0x1115:0xfd  (sound_1.ASM.obj) ----
  01284D  33c0             xor ax, ax
  01284F  cb               retf

; ---- _sound_driver_null  file 0x012850..0x012869  seg 0x1115:0x100  (sound_1.ASM.obj) ----
  012850  57               push di
  012851  b90500           mov cx, 5
  012854  bf2a60           mov di, 0x602a
  012857  b81511           mov ax, 0x1115
  01285A  bbfd00           mov bx, 0xfd
  01285D  891d             mov word ptr [di], bx
  01285F  894502           mov word ptr [di + 2], ax
  012862  83c704           add di, 4
  012865  e2f6             loop 0x1285d
  012867  5f               pop di
  012868  cb               retf

; ---- _sound_initialized  file 0x012869..0x012870  seg 0x1115:0x119  (sound_1.ASM.obj) ----
  012869  32e4             xor ah, ah
  01286B  a01444           mov al, byte ptr [0x4414]
  01286E  cb               retf
  01286F  00               .byte 0x00
