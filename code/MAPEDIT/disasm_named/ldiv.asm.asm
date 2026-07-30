; MAPEDIT.EXE named disasm — module ldiv.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __aFldiv  file 0x0159A2..0x015A3C  seg 0x1388:0xb22  (ldiv.asm.obj) ----
  0159A2  55               push bp
  0159A3  8bec             mov bp, sp
  0159A5  57               push di
  0159A6  56               push si
  0159A7  53               push bx
  0159A8  33ff             xor di, di
  0159AA  8b4608           mov ax, word ptr [bp + 8]
  0159AD  0bc0             or ax, ax
  0159AF  7d11             jge 0x159c2
  0159B1  47               inc di
  0159B2  8b5606           mov dx, word ptr [bp + 6]
  0159B5  f7d8             neg ax
  0159B7  f7da             neg dx
  0159B9  1d0000           sbb ax, 0
  0159BC  894608           mov word ptr [bp + 8], ax
  0159BF  895606           mov word ptr [bp + 6], dx
  0159C2  8b460c           mov ax, word ptr [bp + 0xc]
  0159C5  0bc0             or ax, ax
  0159C7  7d11             jge 0x159da
  0159C9  47               inc di
  0159CA  8b560a           mov dx, word ptr [bp + 0xa]
  0159CD  f7d8             neg ax
  0159CF  f7da             neg dx
  0159D1  1d0000           sbb ax, 0
  0159D4  89460c           mov word ptr [bp + 0xc], ax
  0159D7  89560a           mov word ptr [bp + 0xa], dx
  0159DA  0bc0             or ax, ax
  0159DC  7515             jne 0x159f3
  0159DE  8b4e0a           mov cx, word ptr [bp + 0xa]
  0159E1  8b4608           mov ax, word ptr [bp + 8]
  0159E4  33d2             xor dx, dx
  0159E6  f7f1             div cx
  0159E8  8bd8             mov bx, ax
  0159EA  8b4606           mov ax, word ptr [bp + 6]
  0159ED  f7f1             div cx
  0159EF  8bd3             mov dx, bx
  0159F1  eb38             jmp 0x15a2b
  0159F3  8bd8             mov bx, ax
  0159F5  8b4e0a           mov cx, word ptr [bp + 0xa]
  0159F8  8b5608           mov dx, word ptr [bp + 8]
  0159FB  8b4606           mov ax, word ptr [bp + 6]
  0159FE  d1eb             shr bx, 1
  015A00  d1d9             rcr cx, 1
  015A02  d1ea             shr dx, 1
  015A04  d1d8             rcr ax, 1
  015A06  0bdb             or bx, bx
  015A08  75f4             jne 0x159fe
  015A0A  f7f1             div cx
  015A0C  8bf0             mov si, ax
  015A0E  f7660c           mul word ptr [bp + 0xc]
  015A11  91               xchg cx, ax
  015A12  8b460a           mov ax, word ptr [bp + 0xa]
  015A15  f7e6             mul si
  015A17  03d1             add dx, cx
  015A19  720c             jb 0x15a27
  015A1B  3b5608           cmp dx, word ptr [bp + 8]
  015A1E  7707             ja 0x15a27
  015A20  7206             jb 0x15a28
  015A22  3b4606           cmp ax, word ptr [bp + 6]
  015A25  7601             jbe 0x15a28
  015A27  4e               dec si
  015A28  33d2             xor dx, dx
  015A2A  96               xchg si, ax
  015A2B  4f               dec di
  015A2C  7507             jne 0x15a35
  015A2E  f7da             neg dx
  015A30  f7d8             neg ax
  015A32  83da00           sbb dx, 0
  015A35  5b               pop bx
  015A36  5e               pop si
  015A37  5f               pop di
  015A38  5d               pop bp
  015A39  ca0800           retf 8
