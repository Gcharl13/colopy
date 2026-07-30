; MAPEDIT.EXE named disasm — module dos_stdargv.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __setargv  file 0x015E46..0x015FD8  seg 0x1388:0xfc6  (dos_stdargv.asm.obj) ----
  015E46  8f06ae46         pop word ptr [0x46ae]
  015E4A  8f06b046         pop word ptr [0x46b0]
  015E4E  b430             mov ah, 0x30
  015E50  cd21             int 0x21
  015E52  a37045           mov word ptr [0x4570], ax
  015E55  ba0100           mov dx, 1
  015E58  3c02             cmp al, 2
  015E5A  7429             je 0x15e85
  015E5C  8e066e45         mov es, word ptr [0x456e]
  015E60  268e062c00       mov es, word ptr es:[0x2c]
  015E65  8c069345         mov word ptr [0x4593], es
  015E69  33c0             xor ax, ax
  015E6B  99               cdq
  015E6C  b90080           mov cx, 0x8000
  015E6F  33ff             xor di, di
  015E71  f2ae             repne scasb al, byte ptr es:[di]
  015E73  ae               scasb al, byte ptr es:[di]
  015E74  75fb             jne 0x15e71
  015E76  47               inc di
  015E77  47               inc di
  015E78  893e9145         mov word ptr [0x4591], di
  015E7C  b9ffff           mov cx, 0xffff
  015E7F  f2ae             repne scasb al, byte ptr es:[di]
  015E81  f7d1             not cx
  015E83  8bd1             mov dx, cx
  015E85  bf0100           mov di, 1
  015E88  be8100           mov si, 0x81
  015E8B  8e1e6e45         mov ds, word ptr [0x456e]
  015E8F  ac               lodsb al, byte ptr [si]
  015E90  3c20             cmp al, 0x20
  015E92  74fb             je 0x15e8f
  015E94  3c09             cmp al, 9
  015E96  74f7             je 0x15e8f
  015E98  3c0d             cmp al, 0xd
  015E9A  746f             je 0x15f0b
  015E9C  0ac0             or al, al
  015E9E  746b             je 0x15f0b
  015EA0  47               inc di
  015EA1  4e               dec si
  015EA2  ac               lodsb al, byte ptr [si]
  015EA3  3c20             cmp al, 0x20
  015EA5  74e8             je 0x15e8f
  015EA7  3c09             cmp al, 9
  015EA9  74e4             je 0x15e8f
  015EAB  3c0d             cmp al, 0xd
  015EAD  745c             je 0x15f0b
  015EAF  0ac0             or al, al
  015EB1  7458             je 0x15f0b
  015EB3  3c22             cmp al, 0x22
  015EB5  7424             je 0x15edb
  015EB7  3c5c             cmp al, 0x5c
  015EB9  7403             je 0x15ebe
  015EBB  42               inc dx
  015EBC  ebe4             jmp 0x15ea2
  015EBE  33c9             xor cx, cx
  015EC0  41               inc cx
  015EC1  ac               lodsb al, byte ptr [si]
  015EC2  3c5c             cmp al, 0x5c
  015EC4  74fa             je 0x15ec0
  015EC6  3c22             cmp al, 0x22
  015EC8  7404             je 0x15ece
  015ECA  03d1             add dx, cx
  015ECC  ebd3             jmp 0x15ea1
  015ECE  8bc1             mov ax, cx
  015ED0  d1e9             shr cx, 1
  015ED2  13d1             adc dx, cx
  015ED4  a801             test al, 1
  015ED6  75ca             jne 0x15ea2
  015ED8  eb01             jmp 0x15edb
  015EDA  4e               dec si
  015EDB  ac               lodsb al, byte ptr [si]
  015EDC  3c0d             cmp al, 0xd
  015EDE  742b             je 0x15f0b
  015EE0  0ac0             or al, al
  015EE2  7427             je 0x15f0b
  015EE4  3c22             cmp al, 0x22
  015EE6  74ba             je 0x15ea2
  015EE8  3c5c             cmp al, 0x5c
  015EEA  7403             je 0x15eef
  015EEC  42               inc dx
  015EED  ebec             jmp 0x15edb
  015EEF  33c9             xor cx, cx
  015EF1  41               inc cx
  015EF2  ac               lodsb al, byte ptr [si]
  015EF3  3c5c             cmp al, 0x5c
  015EF5  74fa             je 0x15ef1
  015EF7  3c22             cmp al, 0x22
  015EF9  7404             je 0x15eff
  015EFB  03d1             add dx, cx
  015EFD  ebdb             jmp 0x15eda
  015EFF  8bc1             mov ax, cx
  015F01  d1e9             shr cx, 1
  015F03  13d1             adc dx, cx
  015F05  a801             test al, 1
  015F07  75d2             jne 0x15edb
  015F09  eb97             jmp 0x15ea2
  015F0B  16               push ss
  015F0C  1f               pop ds
  015F0D  893e8b45         mov word ptr [0x458b], di
  015F11  03d7             add dx, di
  015F13  47               inc di
  015F14  d1e7             shl di, 1
  015F16  03d7             add dx, di
  015F18  42               inc dx
  015F19  80e2fe           and dl, 0xfe
  015F1C  2be2             sub sp, dx
  015F1E  8bc4             mov ax, sp
  015F20  a38d45           mov word ptr [0x458d], ax
  015F23  8bd8             mov bx, ax
  015F25  03fb             add di, bx
  015F27  16               push ss
  015F28  07               pop es
  015F29  36893f           mov word ptr ss:[bx], di
  015F2C  43               inc bx
  015F2D  43               inc bx
  015F2E  c5369145         lds si, ptr [0x4591]
  015F32  ac               lodsb al, byte ptr [si]
  015F33  aa               stosb byte ptr es:[di], al
  015F34  0ac0             or al, al
  015F36  75fa             jne 0x15f32
  015F38  368e1e6e45       mov ds, word ptr ss:[0x456e]
  015F3D  be8100           mov si, 0x81
  015F40  eb03             jmp 0x15f45
  015F42  33c0             xor ax, ax
  015F44  aa               stosb byte ptr es:[di], al
  015F45  ac               lodsb al, byte ptr [si]
  015F46  3c20             cmp al, 0x20
  015F48  74fb             je 0x15f45
  015F4A  3c09             cmp al, 9
  015F4C  74f7             je 0x15f45
  015F4E  3c0d             cmp al, 0xd
  015F50  747c             je 0x15fce
  015F52  0ac0             or al, al
  015F54  7478             je 0x15fce
  015F56  36893f           mov word ptr ss:[bx], di
  015F59  43               inc bx
  015F5A  43               inc bx
  015F5B  4e               dec si
  015F5C  ac               lodsb al, byte ptr [si]
  015F5D  3c20             cmp al, 0x20
  015F5F  74e1             je 0x15f42
  015F61  3c09             cmp al, 9
  015F63  74dd             je 0x15f42
  015F65  3c0d             cmp al, 0xd
  015F67  7462             je 0x15fcb
  015F69  0ac0             or al, al
  015F6B  745e             je 0x15fcb
  015F6D  3c22             cmp al, 0x22
  015F6F  7427             je 0x15f98
  015F71  3c5c             cmp al, 0x5c
  015F73  7403             je 0x15f78
  015F75  aa               stosb byte ptr es:[di], al
  015F76  ebe4             jmp 0x15f5c
  015F78  33c9             xor cx, cx
  015F7A  41               inc cx
  015F7B  ac               lodsb al, byte ptr [si]
  015F7C  3c5c             cmp al, 0x5c
  015F7E  74fa             je 0x15f7a
  015F80  3c22             cmp al, 0x22
  015F82  7406             je 0x15f8a
  015F84  b05c             mov al, 0x5c
  015F86  f3aa             rep stosb byte ptr es:[di], al
  015F88  ebd1             jmp 0x15f5b
  015F8A  b05c             mov al, 0x5c
  015F8C  d1e9             shr cx, 1
  015F8E  f3aa             rep stosb byte ptr es:[di], al
  015F90  7306             jae 0x15f98
  015F92  b022             mov al, 0x22
  015F94  aa               stosb byte ptr es:[di], al
  015F95  ebc5             jmp 0x15f5c
  015F97  4e               dec si
  015F98  ac               lodsb al, byte ptr [si]
  015F99  3c0d             cmp al, 0xd
  015F9B  742e             je 0x15fcb
  015F9D  0ac0             or al, al
  015F9F  742a             je 0x15fcb
  015FA1  3c22             cmp al, 0x22
  015FA3  74b7             je 0x15f5c
  015FA5  3c5c             cmp al, 0x5c
  015FA7  7403             je 0x15fac
  015FA9  aa               stosb byte ptr es:[di], al
  015FAA  ebec             jmp 0x15f98
  015FAC  33c9             xor cx, cx
  015FAE  41               inc cx
  015FAF  ac               lodsb al, byte ptr [si]
  015FB0  3c5c             cmp al, 0x5c
  015FB2  74fa             je 0x15fae
  015FB4  3c22             cmp al, 0x22
  015FB6  7406             je 0x15fbe
  015FB8  b05c             mov al, 0x5c
  015FBA  f3aa             rep stosb byte ptr es:[di], al
  015FBC  ebd9             jmp 0x15f97
  015FBE  b05c             mov al, 0x5c
  015FC0  d1e9             shr cx, 1
  015FC2  f3aa             rep stosb byte ptr es:[di], al
  015FC4  7396             jae 0x15f5c
  015FC6  b022             mov al, 0x22
  015FC8  aa               stosb byte ptr es:[di], al
  015FC9  ebcd             jmp 0x15f98
  015FCB  33c0             xor ax, ax
  015FCD  aa               stosb byte ptr es:[di], al
  015FCE  16               push ss
  015FCF  1f               pop ds
  015FD0  c7070000         mov word ptr [bx], 0
  015FD4  ff2eae46         ljmp [0x46ae]
