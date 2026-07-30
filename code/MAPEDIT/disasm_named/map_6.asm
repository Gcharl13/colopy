; MAPEDIT.EXE named disasm — module map_6.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _map_find_continents  file 0x00B242..0x00B5F2  seg 0x9C4:0x2  (map_6.obj) ----
  00B242  c82e0000         enter 0x2e, 0
  00B246  56               push si
  00B247  2bc0             sub ax, ax
  00B249  8946f6           mov word ptr [bp - 0xa], ax
  00B24C  a18c00           mov ax, word ptr [0x8c]
  00B24F  8b168e00         mov dx, word ptr [0x8e]
  00B253  8946dc           mov word ptr [bp - 0x24], ax
  00B256  8956de           mov word ptr [bp - 0x22], dx
  00B259  80c480           add ah, 0x80
  00B25C  8946d4           mov word ptr [bp - 0x2c], ax
  00B25F  8956d6           mov word ptr [bp - 0x2a], dx
  00B262  ff36c05e         push word ptr [0x5ec0]
  00B266  ff36be5e         push word ptr [0x5ebe]
  00B26A  ff36bc5e         push word ptr [0x5ebc]
  00B26E  ff36ba5e         push word ptr [0x5eba]
  00B272  2ac0             sub al, al
  00B274  9a0e00490c       lcall 0xc49, 0xe
  00B279  c746e40100       mov word ptr [bp - 0x1c], 1
  00B27E  e9a602           jmp 0xb527
  00B281  90               nop
  00B282  c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  00B287  eb55             jmp 0xb2de
  00B289  90               nop
  00B28A  ff46fe           inc word ptr [bp - 2]
  00B28D  8b46fe           mov ax, word ptr [bp - 2]
  00B290  3906124b         cmp word ptr [0x4b12], ax
  00B294  7c2a             jl 0xb2c0
  00B296  a1124b           mov ax, word ptr [0x4b12]
  00B299  f76ef8           imul word ptr [bp - 8]
  00B29C  8bd8             mov bx, ax
  00B29E  035efe           add bx, word ptr [bp - 2]
  00B2A1  d1e3             shl bx, 1
  00B2A3  035ed4           add bx, word ptr [bp - 0x2c]
  00B2A6  8e46d6           mov es, word ptr [bp - 0x2a]
  00B2A9  895ee0           mov word ptr [bp - 0x20], bx
  00B2AC  8c46e2           mov word ptr [bp - 0x1e], es
  00B2AF  8b46f0           mov ax, word ptr [bp - 0x10]
  00B2B2  263907           cmp word ptr es:[bx], ax
  00B2B5  75d3             jne 0xb28a
  00B2B7  8b46e8           mov ax, word ptr [bp - 0x18]
  00B2BA  268907           mov word ptr es:[bx], ax
  00B2BD  ebcb             jmp 0xb28a
  00B2BF  90               nop
  00B2C0  ff46f8           inc word ptr [bp - 8]
  00B2C3  8b46e6           mov ax, word ptr [bp - 0x1a]
  00B2C6  3946f8           cmp word ptr [bp - 8], ax
  00B2C9  7f07             jg 0xb2d2
  00B2CB  c746fe0100       mov word ptr [bp - 2], 1
  00B2D0  ebbb             jmp 0xb28d
  00B2D2  8b46e8           mov ax, word ptr [bp - 0x18]
  00B2D5  8946fc           mov word ptr [bp - 4], ax
  00B2D8  8946f4           mov word ptr [bp - 0xc], ax
  00B2DB  ff46f2           inc word ptr [bp - 0xe]
  00B2DE  837ef201         cmp word ptr [bp - 0xe], 1
  00B2E2  7f64             jg 0xb348
  00B2E4  8b46e6           mov ax, word ptr [bp - 0x1a]
  00B2E7  48               dec ax
  00B2E8  f72e124b         imul word ptr [0x4b12]
  00B2EC  8bd8             mov bx, ax
  00B2EE  035eec           add bx, word ptr [bp - 0x14]
  00B2F1  035ef2           add bx, word ptr [bp - 0xe]
  00B2F4  d1e3             shl bx, 1
  00B2F6  c476d4           les si, ptr [bp - 0x2c]
  00B2F9  268b00           mov ax, word ptr es:[bx + si]
  00B2FC  8946fc           mov word ptr [bp - 4], ax
  00B2FF  0bc0             or ax, ax
  00B301  74d8             je 0xb2db
  00B303  8946e8           mov word ptr [bp - 0x18], ax
  00B306  837ef400         cmp word ptr [bp - 0xc], 0
  00B30A  74c6             je 0xb2d2
  00B30C  3b46f4           cmp ax, word ptr [bp - 0xc]
  00B30F  74c1             je 0xb2d2
  00B311  7d03             jge 0xb316
  00B313  8b46f4           mov ax, word ptr [bp - 0xc]
  00B316  8946f0           mov word ptr [bp - 0x10], ax
  00B319  8bd8             mov bx, ax
  00B31B  d1e3             shl bx, 1
  00B31D  c476dc           les si, ptr [bp - 0x24]
  00B320  268b00           mov ax, word ptr es:[bx + si]
  00B323  8bcb             mov cx, bx
  00B325  8b5efc           mov bx, word ptr [bp - 4]
  00B328  3b5ef4           cmp bx, word ptr [bp - 0xc]
  00B32B  7e03             jle 0xb330
  00B32D  8b5ef4           mov bx, word ptr [bp - 0xc]
  00B330  895ee8           mov word ptr [bp - 0x18], bx
  00B333  d1e3             shl bx, 1
  00B335  260100           add word ptr es:[bx + si], ax
  00B338  8bd9             mov bx, cx
  00B33A  26c7000000       mov word ptr es:[bx + si], 0
  00B33F  c746f80100       mov word ptr [bp - 8], 1
  00B344  e97cff           jmp 0xb2c3
  00B347  90               nop
  00B348  837ef400         cmp word ptr [bp - 0xc], 0
  00B34C  7561             jne 0xb3af
  00B34E  837efa00         cmp word ptr [bp - 6], 0
  00B352  7555             jne 0xb3a9
  00B354  c746d20000       mov word ptr [bp - 0x2e], 0
  00B359  837ee601         cmp word ptr [bp - 0x1a], 1
  00B35D  740b             je 0xb36a
  00B35F  a1144b           mov ax, word ptr [0x4b14]
  00B362  2b46e6           sub ax, word ptr [bp - 0x1a]
  00B365  3d0200           cmp ax, 2
  00B368  750b             jne 0xb375
  00B36A  837ee400         cmp word ptr [bp - 0x1c], 0
  00B36E  7505             jne 0xb375
  00B370  c746d21000       mov word ptr [bp - 0x2e], 0x10
  00B375  ff46d2           inc word ptr [bp - 0x2e]
  00B378  8b5ed2           mov bx, word ptr [bp - 0x2e]
  00B37B  d1e3             shl bx, 1
  00B37D  c476dc           les si, ptr [bp - 0x24]
  00B380  26833800         cmp word ptr es:[bx + si], 0
  00B384  7407             je 0xb38d
  00B386  817ed20240       cmp word ptr [bp - 0x2e], 0x4002
  00B38B  7ce8             jl 0xb375
  00B38D  817ed20040       cmp word ptr [bp - 0x2e], 0x4000
  00B392  7c15             jl 0xb3a9
  00B394  c746d2ff3f       mov word ptr [bp - 0x2e], 0x3fff
  00B399  680007           push 0x700
  00B39C  9aa8058813       lcall 0x1388, 0x5a8
  00B3A1  83c402           add sp, 2
  00B3A4  9a1800af0b       lcall 0xbaf, 0x18
  00B3A9  8b46d2           mov ax, word ptr [bp - 0x2e]
  00B3AC  8946f4           mov word ptr [bp - 0xc], ax
  00B3AF  a1124b           mov ax, word ptr [0x4b12]
  00B3B2  f76ee6           imul word ptr [bp - 0x1a]
  00B3B5  8bd8             mov bx, ax
  00B3B7  035eec           add bx, word ptr [bp - 0x14]
  00B3BA  d1e3             shl bx, 1
  00B3BC  035ed4           add bx, word ptr [bp - 0x2c]
  00B3BF  8e46d6           mov es, word ptr [bp - 0x2a]
  00B3C2  895ee0           mov word ptr [bp - 0x20], bx
  00B3C5  8c46e2           mov word ptr [bp - 0x1e], es
  00B3C8  8b46f4           mov ax, word ptr [bp - 0xc]
  00B3CB  268907           mov word ptr es:[bx], ax
  00B3CE  8bd8             mov bx, ax
  00B3D0  d1e3             shl bx, 1
  00B3D2  c476dc           les si, ptr [bp - 0x24]
  00B3D5  26ff00           inc word ptr es:[bx + si]
  00B3D8  c746fa0100       mov word ptr [bp - 6], 1
  00B3DD  ff4eec           dec word ptr [bp - 0x14]
  00B3E0  837eec01         cmp word ptr [bp - 0x14], 1
  00B3E4  7c32             jl 0xb418
  00B3E6  ff76e6           push word ptr [bp - 0x1a]
  00B3E9  ff76ec           push word ptr [bp - 0x14]
  00B3EC  9a0e00ab02       lcall 0x2ab, 0xe
  00B3F1  83c404           add sp, 4
  00B3F4  0bc0             or ax, ax
  00B3F6  7416             je 0xb40e
  00B3F8  ff76e6           push word ptr [bp - 0x1a]
  00B3FB  ff76ec           push word ptr [bp - 0x14]
  00B3FE  9a6c00b709       lcall 0x9b7, 0x6c
  00B403  83c404           add sp, 4
  00B406  3b46e4           cmp ax, word ptr [bp - 0x1c]
  00B409  7503             jne 0xb40e
  00B40B  e974fe           jmp 0xb282
  00B40E  2bc0             sub ax, ax
  00B410  8946fa           mov word ptr [bp - 6], ax
  00B413  8946f4           mov word ptr [bp - 0xc], ax
  00B416  ebc5             jmp 0xb3dd
  00B418  9a06000000       lcall 0, 6
  00B41D  ff46e6           inc word ptr [bp - 0x1a]
  00B420  a1144b           mov ax, word ptr [0x4b14]
  00B423  48               dec ax
  00B424  3b46e6           cmp ax, word ptr [bp - 0x1a]
  00B427  7e0b             jle 0xb434
  00B429  a1124b           mov ax, word ptr [0x4b12]
  00B42C  48               dec ax
  00B42D  48               dec ax
  00B42E  8946ec           mov word ptr [bp - 0x14], ax
  00B431  ebad             jmp 0xb3e0
  00B433  90               nop
  00B434  8b46d4           mov ax, word ptr [bp - 0x2c]
  00B437  8b56d6           mov dx, word ptr [bp - 0x2a]
  00B43A  8946e0           mov word ptr [bp - 0x20], ax
  00B43D  8956e2           mov word ptr [bp - 0x1e], dx
  00B440  a1b004           mov ax, word ptr [0x4b0]
  00B443  8b16b204         mov dx, word ptr [0x4b2]
  00B447  8946d8           mov word ptr [bp - 0x28], ax
  00B44A  8956da           mov word ptr [bp - 0x26], dx
  00B44D  c746e60000       mov word ptr [bp - 0x1a], 0
  00B452  e9bf00           jmp 0xb514
  00B455  90               nop
  00B456  c45ee0           les bx, ptr [bp - 0x20]
  00B459  268b1f           mov bx, word ptr es:[bx]
  00B45C  d1e3             shl bx, 1
  00B45E  8e46de           mov es, word ptr [bp - 0x22]
  00B461  268b00           mov ax, word ptr es:[bx + si]
  00B464  f7d0             not ax
  00B466  40               inc ax
  00B467  c45ee0           les bx, ptr [bp - 0x20]
  00B46A  268907           mov word ptr es:[bx], ax
  00B46D  eb54             jmp 0xb4c3
  00B46F  90               nop
  00B470  c746d20000       mov word ptr [bp - 0x2e], 0
  00B475  ff46d2           inc word ptr [bp - 0x2e]
  00B478  8b5ed2           mov bx, word ptr [bp - 0x2e]
  00B47B  d1e3             shl bx, 1
  00B47D  26833800         cmp word ptr es:[bx + si], 0
  00B481  75f2             jne 0xb475
  00B483  837ed20f         cmp word ptr [bp - 0x2e], 0xf
  00B487  7f27             jg 0xb4b0
  00B489  c45ee0           les bx, ptr [bp - 0x20]
  00B48C  268b1f           mov bx, word ptr es:[bx]
  00B48F  d1e3             shl bx, 1
  00B491  8e46de           mov es, word ptr [bp - 0x22]
  00B494  268b00           mov ax, word ptr es:[bx + si]
  00B497  8bcb             mov cx, bx
  00B499  8b5ed2           mov bx, word ptr [bp - 0x2e]
  00B49C  d1e3             shl bx, 1
  00B49E  268900           mov word ptr es:[bx + si], ax
  00B4A1  8b46d2           mov ax, word ptr [bp - 0x2e]
  00B4A4  f7d8             neg ax
  00B4A6  8bd9             mov bx, cx
  00B4A8  268900           mov word ptr es:[bx + si], ax
  00B4AB  8b46d2           mov ax, word ptr [bp - 0x2e]
  00B4AE  ebb7             jmp 0xb467
  00B4B0  8a4ee4           mov cl, byte ptr [bp - 0x1c]
  00B4B3  b80100           mov ax, 1
  00B4B6  d3e0             shl ax, cl
  00B4B8  0946f6           or word ptr [bp - 0xa], ax
  00B4BB  c45ee0           les bx, ptr [bp - 0x20]
  00B4BE  26c7070f00       mov word ptr es:[bx], 0xf
  00B4C3  c45ee0           les bx, ptr [bp - 0x20]
  00B4C6  268a07           mov al, byte ptr es:[bx]
  00B4C9  c45ed8           les bx, ptr [bp - 0x28]
  00B4CC  268807           mov byte ptr es:[bx], al
  00B4CF  8346e002         add word ptr [bp - 0x20], 2
  00B4D3  ff46d8           inc word ptr [bp - 0x28]
  00B4D6  ff46ec           inc word ptr [bp - 0x14]
  00B4D9  a1124b           mov ax, word ptr [0x4b12]
  00B4DC  3946ec           cmp word ptr [bp - 0x14], ax
  00B4DF  7d2b             jge 0xb50c
  00B4E1  c45ee0           les bx, ptr [bp - 0x20]
  00B4E4  26833f00         cmp word ptr es:[bx], 0
  00B4E8  74e5             je 0xb4cf
  00B4EA  26833f0f         cmp word ptr es:[bx], 0xf
  00B4EE  76d3             jbe 0xb4c3
  00B4F0  268b1f           mov bx, word ptr es:[bx]
  00B4F3  d1e3             shl bx, 1
  00B4F5  c476dc           les si, ptr [bp - 0x24]
  00B4F8  26833800         cmp word ptr es:[bx + si], 0
  00B4FC  7e03             jle 0xb501
  00B4FE  e96fff           jmp 0xb470
  00B501  7f03             jg 0xb506
  00B503  e950ff           jmp 0xb456
  00B506  268b00           mov ax, word ptr es:[bx + si]
  00B509  e95bff           jmp 0xb467
  00B50C  9a06000000       lcall 0, 6
  00B511  ff46e6           inc word ptr [bp - 0x1a]
  00B514  8b46e6           mov ax, word ptr [bp - 0x1a]
  00B517  3906144b         cmp word ptr [0x4b14], ax
  00B51B  7e07             jle 0xb524
  00B51D  c746ec0000       mov word ptr [bp - 0x14], 0
  00B522  ebb5             jmp 0xb4d9
  00B524  ff4ee4           dec word ptr [bp - 0x1c]
  00B527  837ee400         cmp word ptr [bp - 0x1c], 0
  00B52B  7c41             jl 0xb56e
  00B52D  680080           push 0x8000
  00B530  6a00             push 0
  00B532  ff76de           push word ptr [bp - 0x22]
  00B535  ff76dc           push word ptr [bp - 0x24]
  00B538  9a680e8813       lcall 0x1388, 0xe68
  00B53D  83c408           add sp, 8
  00B540  a1144b           mov ax, word ptr [0x4b14]
  00B543  f72e124b         imul word ptr [0x4b12]
  00B547  d1e0             shl ax, 1
  00B549  50               push ax
  00B54A  6a00             push 0
  00B54C  ff76d6           push word ptr [bp - 0x2a]
  00B54F  ff76d4           push word ptr [bp - 0x2c]
  00B552  9a680e8813       lcall 0x1388, 0xe68
  00B557  83c408           add sp, 8
  00B55A  2bc0             sub ax, ax
  00B55C  8946d2           mov word ptr [bp - 0x2e], ax
  00B55F  8946f4           mov word ptr [bp - 0xc], ax
  00B562  8946fa           mov word ptr [bp - 6], ax
  00B565  c746e60100       mov word ptr [bp - 0x1a], 1
  00B56A  e9b3fe           jmp 0xb420
  00B56D  90               nop
  00B56E  c746ea0000       mov word ptr [bp - 0x16], 0
  00B573  8e46de           mov es, word ptr [bp - 0x22]
  00B576  8b5eea           mov bx, word ptr [bp - 0x16]
  00B579  d1e3             shl bx, 1
  00B57B  8b76dc           mov si, word ptr [bp - 0x24]
  00B57E  268b00           mov ax, word ptr es:[bx + si]
  00B581  89877052         mov word ptr [bx + 0x5270], ax
  00B585  ff46ea           inc word ptr [bp - 0x16]
  00B588  837eea10         cmp word ptr [bp - 0x16], 0x10
  00B58C  7ce8             jl 0xb576
  00B58E  9a02000000       lcall 0, 2
  00B593  8b46f6           mov ax, word ptr [bp - 0xa]
  00B596  5e               pop si
  00B597  c9               leave
  00B598  cb               retf
  00B599  90               nop
  00B59A  a1124b           mov ax, word ptr [0x4b12]
  00B59D  a3a45a           mov word ptr [0x5aa4], ax
  00B5A0  a3bc5e           mov word ptr [0x5ebc], ax
  00B5A3  a36e4a           mov word ptr [0x4a6e], ax
  00B5A6  a3944e           mov word ptr [0x4e94], ax
  00B5A9  a1144b           mov ax, word ptr [0x4b14]
  00B5AC  a3a25a           mov word ptr [0x5aa2], ax
  00B5AF  a3ba5e           mov word ptr [0x5eba], ax
  00B5B2  a36c4a           mov word ptr [0x4a6c], ax
  00B5B5  a3924e           mov word ptr [0x4e92], ax
  00B5B8  a1a804           mov ax, word ptr [0x4a8]
  00B5BB  8b16aa04         mov dx, word ptr [0x4aa]
  00B5BF  a3964e           mov word ptr [0x4e96], ax
  00B5C2  8916984e         mov word ptr [0x4e98], dx
  00B5C6  a1ac04           mov ax, word ptr [0x4ac]
  00B5C9  8b16ae04         mov dx, word ptr [0x4ae]
  00B5CD  a3704a           mov word ptr [0x4a70], ax
  00B5D0  8916724a         mov word ptr [0x4a72], dx
  00B5D4  a1b004           mov ax, word ptr [0x4b0]
  00B5D7  8b16b204         mov dx, word ptr [0x4b2]
  00B5DB  a3be5e           mov word ptr [0x5ebe], ax
  00B5DE  8916c05e         mov word ptr [0x5ec0], dx
  00B5E2  a1b404           mov ax, word ptr [0x4b4]
  00B5E5  8b16b604         mov dx, word ptr [0x4b6]
  00B5E9  a3a65a           mov word ptr [0x5aa6], ax
  00B5EC  8916a85a         mov word ptr [0x5aa8], dx
  00B5F0  c3               ret
  00B5F1  90               nop
