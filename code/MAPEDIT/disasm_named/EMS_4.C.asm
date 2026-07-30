; MAPEDIT.EXE named disasm — module EMS_4.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @ems_copy_it_down  file 0x0144C8..0x0145B6  seg 0x12EC:0x8  (EMS_4.C.obj) ----
  0144C8  c8060000         enter 6, 0
  0144CC  50               push ax
  0144CD  c746fcffff       mov word ptr [bp - 4], 0xffff
  0144D2  c45e12           les bx, ptr [bp + 0x12]
  0144D5  26833f00         cmp word ptr es:[bx], 0
  0144D9  7c14             jl 0x144ef
  0144DB  26ff37           push word ptr es:[bx]
  0144DE  6a02             push 2
  0144E0  9ad4002d11       lcall 0x112d, 0xd4
  0144E5  83c404           add sp, 4
  0144E8  0bc0             or ax, ax
  0144EA  7403             je 0x144ef
  0144EC  e9c000           jmp 0x145af
  0144EF  837e0800         cmp word ptr [bp + 8], 0
  0144F3  7d03             jge 0x144f8
  0144F5  e9b200           jmp 0x145aa
  0144F8  7f09             jg 0x14503
  0144FA  837e0600         cmp word ptr [bp + 6], 0
  0144FE  7503             jne 0x14503
  014500  e9a700           jmp 0x145aa
  014503  c45e0e           les bx, ptr [bp + 0xe]
  014506  26813f0040       cmp word ptr es:[bx], 0x4000
  01450B  7c35             jl 0x14542
  01450D  c45e12           les bx, ptr [bp + 0x12]
  014510  268b17           mov dx, word ptr es:[bx]
  014513  8b46f8           mov ax, word ptr [bp - 8]
  014516  9ac4014511       lcall 0x1145, 0x1c4
  01451B  c45e12           les bx, ptr [bp + 0x12]
  01451E  268907           mov word ptr es:[bx], ax
  014521  0bc0             or ax, ax
  014523  7d03             jge 0x14528
  014525  e98700           jmp 0x145af
  014528  c45e12           les bx, ptr [bp + 0x12]
  01452B  26ff37           push word ptr es:[bx]
  01452E  6a02             push 2
  014530  9ad4002d11       lcall 0x112d, 0xd4
  014535  83c404           add sp, 4
  014538  0bc0             or ax, ax
  01453A  7573             jne 0x145af
  01453C  c45e0e           les bx, ptr [bp + 0xe]
  01453F  268907           mov word ptr es:[bx], ax
  014542  b80040           mov ax, 0x4000
  014545  c45e0e           les bx, ptr [bp + 0xe]
  014548  262b07           sub ax, word ptr es:[bx]
  01454B  2bd2             sub dx, dx
  01454D  3b5608           cmp dx, word ptr [bp + 8]
  014550  7c0d             jl 0x1455f
  014552  7f05             jg 0x14559
  014554  3b4606           cmp ax, word ptr [bp + 6]
  014557  7606             jbe 0x1455f
  014559  8b5608           mov dx, word ptr [bp + 8]
  01455C  8b4606           mov ax, word ptr [bp + 6]
  01455F  8946fe           mov word ptr [bp - 2], ax
  014562  0bc0             or ax, ax
  014564  7430             je 0x14596
  014566  50               push ax
  014567  268b07           mov ax, word ptr es:[bx]
  01456A  03066444         add ax, word ptr [0x4464]
  01456E  8b166644         mov dx, word ptr [0x4466]
  014572  52               push dx
  014573  50               push ax
  014574  ff760c           push word ptr [bp + 0xc]
  014577  ff760a           push word ptr [bp + 0xa]
  01457A  9a4a0c8813       lcall 0x1388, 0xc4a
  01457F  83c40a           add sp, 0xa
  014582  8b46fe           mov ax, word ptr [bp - 2]
  014585  01460a           add word ptr [bp + 0xa], ax
  014588  c45e0e           les bx, ptr [bp + 0xe]
  01458B  260107           add word ptr es:[bx], ax
  01458E  2bd2             sub dx, dx
  014590  294606           sub word ptr [bp + 6], ax
  014593  195608           sbb word ptr [bp + 8], dx
  014596  ff760c           push word ptr [bp + 0xc]
  014599  ff760a           push word ptr [bp + 0xa]
  01459C  9a0e005713       lcall 0x1357, 0xe
  0145A1  89460a           mov word ptr [bp + 0xa], ax
  0145A4  89560c           mov word ptr [bp + 0xc], dx
  0145A7  e945ff           jmp 0x144ef
  0145AA  c746fc0000       mov word ptr [bp - 4], 0
  0145AF  8b46fc           mov ax, word ptr [bp - 4]
  0145B2  c9               leave
  0145B3  ca1000           retf 0x10
