; ============================================================================
; func_022B2B_unknown
; Region   : load_image
; Bytes    : file 0x022B2B..0x022BEA  (191 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022B2B  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
022B2F  50                    PUSH   ax                           ; UNKNOWN
022B30  57                    PUSH   di                           ; UNKNOWN
022B31  56                    PUSH   si                           ; UNKNOWN
022B32  C4 76 06              LES    si, ptr [bp + 6]             ; UNKNOWN
022B35  2B C0                 SUB    ax, ax                       ; UNKNOWN
022B37  99                    CDQ                                 ; UNKNOWN
022B38  8B C8                 MOV    cx, ax                       ; UNKNOWN
022B3A  89 56 F4              MOV    word ptr [bp - 0xc], dx      ; UNKNOWN
022B3D  26 8B 44 38           MOV    ax, word ptr es:[si + 0x38]  ; UNKNOWN
022B41  26 8B 54 3A           MOV    dx, word ptr es:[si + 0x3a]  ; UNKNOWN
022B45  8B D8                 MOV    bx, ax                       ; UNKNOWN
022B47  89 56 F0              MOV    word ptr [bp - 0x10], dx     ; UNKNOWN
022B4A  2B FF                 SUB    di, di                       ; UNKNOWN
022B4C  89 7E EC              MOV    word ptr [bp - 0x14], di     ; UNKNOWN
022B4F  26 89 3C              MOV    word ptr es:[si], di         ; UNKNOWN
022B52  89 7E FA              MOV    word ptr [bp - 6], di        ; UNKNOWN
022B55  89 4E F2              MOV    word ptr [bp - 0xe], cx      ; UNKNOWN
022B58  0B D0                 OR     dx, ax                       ; UNKNOWN
022B5A  74 73                 JE     0x22bcf                      ; UNKNOWN
022B5C  8B F1                 MOV    si, cx                       ; UNKNOWN
022B5E  8B 4E FA              MOV    cx, word ptr [bp - 6]        ; UNKNOWN
022B61  0B C9                 OR     cx, cx                       ; UNKNOWN
022B63  75 67                 JNE    0x22bcc                      ; UNKNOWN
022B65  8E 46 F0              MOV    es, word ptr [bp - 0x10]     ; UNKNOWN
022B68  26 F6 47 0C 01        TEST   byte ptr es:[bx + 0xc], 1    ; UNKNOWN
022B6D  75 49                 JNE    0x22bb8                      ; UNKNOWN
022B6F  26 8B 47 1E           MOV    ax, word ptr es:[bx + 0x1e]  ; UNKNOWN
022B73  26 8B 57 20           MOV    dx, word ptr es:[bx + 0x20]  ; UNKNOWN
022B77  8B F0                 MOV    si, ax                       ; UNKNOWN
022B79  89 56 F4              MOV    word ptr [bp - 0xc], dx      ; UNKNOWN
022B7C  0B D0                 OR     dx, ax                       ; UNKNOWN
022B7E  74 38                 JE     0x22bb8                      ; UNKNOWN
022B80  89 5E EE              MOV    word ptr [bp - 0x12], bx     ; UNKNOWN
022B83  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
022B86  0B C9                 OR     cx, cx                       ; UNKNOWN
022B88  75 28                 JNE    0x22bb2                      ; UNKNOWN
022B8A  8E 46 F4              MOV    es, word ptr [bp - 0xc]      ; UNKNOWN
022B8D  26 39 5C 02           CMP    word ptr es:[si + 2], bx     ; UNKNOWN
022B91  75 0B                 JNE    0x22b9e                      ; UNKNOWN
022B93  26 F6 04 03           TEST   byte ptr es:[si], 3          ; UNKNOWN
022B97  75 05                 JNE    0x22b9e                      ; UNKNOWN
022B99  B9 01 00              MOV    cx, 1                        ; UNKNOWN
022B9C  EB 0D                 JMP    0x22bab                      ; UNKNOWN
022B9E  26 8B 44 0E           MOV    ax, word ptr es:[si + 0xe]   ; UNKNOWN
022BA2  26 8B 54 10           MOV    dx, word ptr es:[si + 0x10]  ; UNKNOWN
022BA6  8B F0                 MOV    si, ax                       ; UNKNOWN
022BA8  89 56 F4              MOV    word ptr [bp - 0xc], dx      ; UNKNOWN
022BAB  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
022BAE  0B C6                 OR     ax, si                       ; UNKNOWN
022BB0  75 D4                 JNE    0x22b86                      ; UNKNOWN
022BB2  89 4E FA              MOV    word ptr [bp - 6], cx        ; UNKNOWN
022BB5  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
022BB8  8E 46 F0              MOV    es, word ptr [bp - 0x10]     ; UNKNOWN
022BBB  26 8B 47 16           MOV    ax, word ptr es:[bx + 0x16]  ; UNKNOWN
022BBF  26 8B 57 18           MOV    dx, word ptr es:[bx + 0x18]  ; UNKNOWN
022BC3  8B D8                 MOV    bx, ax                       ; UNKNOWN
022BC5  89 56 F0              MOV    word ptr [bp - 0x10], dx     ; UNKNOWN
022BC8  0B D0                 OR     dx, ax                       ; UNKNOWN
022BCA  75 92                 JNE    0x22b5e                      ; UNKNOWN
022BCC  89 76 F2              MOV    word ptr [bp - 0xe], si      ; UNKNOWN
022BCF  8B 5E EC              MOV    bx, word ptr [bp - 0x14]     ; UNKNOWN
022BD2  8B 7E F2              MOV    di, word ptr [bp - 0xe]      ; UNKNOWN
022BD5  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
022BD9  74 0D                 JE     0x22be8                      ; UNKNOWN
022BDB  8E 46 F4              MOV    es, word ptr [bp - 0xc]      ; UNKNOWN
022BDE  26 8B 5D 04           MOV    bx, word ptr es:[di + 4]     ; UNKNOWN
022BE2  C4 76 06              LES    si, ptr [bp + 6]             ; UNKNOWN
022BE5  26 89 1C              MOV    word ptr es:[si], bx         ; UNKNOWN
022BE8  8B C3                 MOV    ax, bx                       ; UNKNOWN
