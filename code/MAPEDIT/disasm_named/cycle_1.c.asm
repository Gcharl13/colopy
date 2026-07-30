; MAPEDIT.EXE named disasm — module cycle_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _cycle_init  file 0x0107AA..0x010846  seg 0xF1A:0xa  (cycle_1.c.obj) ----
  0107AA  c8060000         enter 6, 0
  0107AE  9a0600180d       lcall 0xd18, 6
  0107B3  8946fc           mov word ptr [bp - 4], ax
  0107B6  8956fe           mov word ptr [bp - 2], dx
  0107B9  c746fa0000       mov word ptr [bp - 6], 0
  0107BE  8b46fc           mov ax, word ptr [bp - 4]
  0107C1  8b56fe           mov dx, word ptr [bp - 2]
  0107C4  8b5efa           mov bx, word ptr [bp - 6]
  0107C7  c1e302           shl bx, 2
  0107CA  8987e852         mov word ptr [bx + 0x52e8], ax
  0107CE  8997ea52         mov word ptr [bx + 0x52ea], dx
  0107D2  ff46fa           inc word ptr [bp - 6]
  0107D5  837efa08         cmp word ptr [bp - 6], 8
  0107D9  7ce3             jl 0x107be
  0107DB  6a22             push 0x22
  0107DD  ff7608           push word ptr [bp + 8]
  0107E0  ff7606           push word ptr [bp + 6]
  0107E3  1e               push ds
  0107E4  68fe5a           push 0x5afe
  0107E7  9a4a0c8813       lcall 0x1388, 0xc4a
  0107EC  83c40a           add sp, 0xa
  0107EF  680003           push 0x300
  0107F2  1e               push ds
  0107F3  68205b           push 0x5b20
  0107F6  1e               push ds
  0107F7  684860           push 0x6048
  0107FA  9a4a0c8813       lcall 0x1388, 0xc4a
  0107FF  83c40a           add sp, 0xa
  010802  2bc0             sub ax, ax
  010804  a39a4e           mov word ptr [0x4e9a], ax
  010807  8946fa           mov word ptr [bp - 6], ax
  01080A  eb17             jmp 0x10823
  01080C  8b5efa           mov bx, word ptr [bp - 6]
  01080F  c1e302           shl bx, 2
  010812  8a87005b         mov al, byte ptr [bx + 0x5b00]
  010816  2ae4             sub ah, ah
  010818  01069a4e         add word ptr [0x4e9a], ax
  01081C  88a7015b         mov byte ptr [bx + 0x5b01], ah
  010820  ff46fa           inc word ptr [bp - 6]
  010823  a1fe5a           mov ax, word ptr [0x5afe]
  010826  3946fa           cmp word ptr [bp - 6], ax
  010829  7ce1             jl 0x1080c
  01082B  c706104b0300     mov word ptr [0x4b10], 3
  010831  833e9a4e10       cmp word ptr [0x4e9a], 0x10
  010836  7f06             jg 0x1083e
  010838  c706104b0000     mov word ptr [0x4b10], 0
  01083E  8b460a           mov ax, word ptr [bp + 0xa]
  010841  a3643c           mov word ptr [0x3c64], ax
  010844  c9               leave
  010845  cb               retf

; ---- _cycle_colors  file 0x010846..0x01096A  seg 0xF1A:0xa6  (cycle_1.c.obj) ----
  010846  c80e0000         enter 0xe, 0
  01084A  57               push di
  01084B  56               push si
  01084C  833e643c00       cmp word ptr [0x3c64], 0
  010851  7503             jne 0x10856
  010853  e90f01           jmp 0x10965
  010856  a1104b           mov ax, word ptr [0x4b10]
  010859  ff06663c         inc word ptr [0x3c66]
  01085D  3906663c         cmp word ptr [0x3c66], ax
  010861  7d03             jge 0x10866
  010863  e9ff00           jmp 0x10965
  010866  833eb63a00       cmp word ptr [0x3ab6], 0
  01086B  7403             je 0x10870
  01086D  e9f500           jmp 0x10965
  010870  9a0600180d       lcall 0xd18, 6
  010875  8946f2           mov word ptr [bp - 0xe], ax
  010878  8956f4           mov word ptr [bp - 0xc], dx
  01087B  2bc0             sub ax, ax
  01087D  8946fe           mov word ptr [bp - 2], ax
  010880  8946f8           mov word ptr [bp - 8], ax
  010883  e9b600           jmp 0x1093c
  010886  8b5ef8           mov bx, word ptr [bp - 8]
  010889  c1e302           shl bx, 2
  01088C  8a87035b         mov al, byte ptr [bx + 0x5b03]
  010890  2ae4             sub ah, ah
  010892  2bd2             sub dx, dx
  010894  0387e852         add ax, word ptr [bx + 0x52e8]
  010898  1397ea52         adc dx, word ptr [bx + 0x52ea]
  01089C  3b56f4           cmp dx, word ptr [bp - 0xc]
  01089F  7e03             jle 0x108a4
  0108A1  e99500           jmp 0x10939
  0108A4  7c08             jl 0x108ae
  0108A6  3b46f2           cmp ax, word ptr [bp - 0xe]
  0108A9  7603             jbe 0x108ae
  0108AB  e98b00           jmp 0x10939
  0108AE  8b46f2           mov ax, word ptr [bp - 0xe]
  0108B1  8b56f4           mov dx, word ptr [bp - 0xc]
  0108B4  8987e852         mov word ptr [bx + 0x52e8], ax
  0108B8  8997ea52         mov word ptr [bx + 0x52ea], dx
  0108BC  8a87005b         mov al, byte ptr [bx + 0x5b00]
  0108C0  2ae4             sub ah, ah
  0108C2  8946fc           mov word ptr [bp - 4], ax
  0108C5  8a8f025b         mov cl, byte ptr [bx + 0x5b02]
  0108C9  2aed             sub ch, ch
  0108CB  894efa           mov word ptr [bp - 6], cx
  0108CE  8a8f015b         mov cl, byte ptr [bx + 0x5b01]
  0108D2  894ef6           mov word ptr [bp - 0xa], cx
  0108D5  c746feffff       mov word ptr [bp - 2], 0xffff
  0108DA  3d0100           cmp ax, 1
  0108DD  7e4d             jle 0x1092c
  0108DF  fd               std
  0108E0  1e               push ds
  0108E1  07               pop es
  0108E2  8b46fc           mov ax, word ptr [bp - 4]
  0108E5  0346fa           add ax, word ptr [bp - 6]
  0108E8  d1e0             shl ax, 1
  0108EA  0346fc           add ax, word ptr [bp - 4]
  0108ED  0346fa           add ax, word ptr [bp - 6]
  0108F0  8b5efc           mov bx, word ptr [bp - 4]
  0108F3  d1e3             shl bx, 1
  0108F5  035efc           add bx, word ptr [bp - 4]
  0108F8  be4860           mov si, 0x6048
  0108FB  03f0             add si, ax
  0108FD  83ee01           sub si, 1
  010900  bfa649           mov di, 0x49a6
  010903  83c702           add di, 2
  010906  57               push di
  010907  56               push si
  010908  b90300           mov cx, 3
  01090B  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  01090D  5f               pop di
  01090E  8bcb             mov cx, bx
  010910  83e903           sub cx, 3
  010913  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  010915  5e               pop si
  010916  b90300           mov cx, 3
  010919  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  01091B  fc               cld
  01091C  ff46f6           inc word ptr [bp - 0xa]
  01091F  8b46f6           mov ax, word ptr [bp - 0xa]
  010922  3b46fc           cmp ax, word ptr [bp - 4]
  010925  7205             jb 0x1092c
  010927  c746f60000       mov word ptr [bp - 0xa], 0
  01092C  8a46f6           mov al, byte ptr [bp - 0xa]
  01092F  8b5ef8           mov bx, word ptr [bp - 8]
  010932  c1e302           shl bx, 2
  010935  8887015b         mov byte ptr [bx + 0x5b01], al
  010939  ff46f8           inc word ptr [bp - 8]
  01093C  a1fe5a           mov ax, word ptr [0x5afe]
  01093F  3946f8           cmp word ptr [bp - 8], ax
  010942  7d03             jge 0x10947
  010944  e93fff           jmp 0x10886
  010947  837efe00         cmp word ptr [bp - 2], 0
  01094B  7412             je 0x1095f
  01094D  1e               push ds
  01094E  684860           push 0x6048
  010951  a0025b           mov al, byte ptr [0x5b02]
  010954  2ae4             sub ah, ah
  010956  8b169a4e         mov dx, word ptr [0x4e9a]
  01095A  9a1e006110       lcall 0x1061, 0x1e
  01095F  c706663c0000     mov word ptr [0x3c66], 0
  010965  5e               pop si
  010966  5f               pop di
  010967  c9               leave
  010968  cb               retf
  010969  90               nop
