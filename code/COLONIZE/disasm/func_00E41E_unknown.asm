; ============================================================================
; func_00E41E_unknown
; Region   : load_image
; Bytes    : file 0x00E41E..0x00E4AD  (143 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E41E  C8 AC 00 00           ENTER  0xac, 0                      ; UNKNOWN
00E422  52                    PUSH   dx                           ; UNKNOWN
00E423  50                    PUSH   ax                           ; UNKNOWN
00E424  53                    PUSH   bx                           ; UNKNOWN
00E425  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
00E42A  53                    PUSH   bx                           ; UNKNOWN
00E42B  8D 46 A8              LEA    ax, [bp - 0x58]              ; UNKNOWN
00E42E  50                    PUSH   ax                           ; UNKNOWN
00E42F  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00E434  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00E437  8D 5E A8              LEA    bx, [bp - 0x58]              ; UNKNOWN
00E43A  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
00E43D  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
00E440  74 16                 JE     0xe458                       ; UNKNOWN
00E442  80 3F 23              CMP    byte ptr [bx], 0x23          ; UNKNOWN
00E445  75 06                 JNE    0xe44d                       ; UNKNOWN
00E447  8A 86 50 FF           MOV    al, byte ptr [bp - 0xb0]     ; UNKNOWN
00E44B  88 07                 MOV    byte ptr [bx], al            ; UNKNOWN
00E44D  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
00E450  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
00E453  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
00E456  75 EA                 JNE    0xe442                       ; UNKNOWN
00E458  83 3E 6C 04 00        CMP    word ptr [0x46c], 0          ; UNKNOWN
00E45D  74 13                 JE     0xe472                       ; UNKNOWN
00E45F  8D 46 A8              LEA    ax, [bp - 0x58]              ; UNKNOWN
00E462  50                    PUSH   ax                           ; UNKNOWN
00E463  8D 86 58 FF           LEA    ax, [bp - 0xa8]              ; UNKNOWN
00E467  50                    PUSH   ax                           ; UNKNOWN
00E468  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00E46D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00E470  EB 13                 JMP    0xe485                       ; UNKNOWN
00E472  8D 46 A8              LEA    ax, [bp - 0x58]              ; UNKNOWN
00E475  16                    PUSH   ss                           ; UNKNOWN
00E476  50                    PUSH   ax                           ; UNKNOWN
00E477  8D 86 58 FF           LEA    ax, [bp - 0xa8]              ; UNKNOWN
00E47B  16                    PUSH   ss                           ; UNKNOWN
00E47C  50                    PUSH   ax                           ; UNKNOWN
00E47D  9A B3 00 E9 5A        LCALL  0x5ae9, 0xb3                 ; UNKNOWN
00E482  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00E485  0E                    PUSH   cs                           ; UNKNOWN
00E486  E8 5D FF              CALL   0xe3e6                       ; UNKNOWN
00E489  C7 86 54 FF FF FF     MOV    word ptr [bp - 0xac], 0xffff ; UNKNOWN
00E48F  C7 86 56 FF FF FF     MOV    word ptr [bp - 0xaa], 0xffff ; UNKNOWN
00E495  8D 9E 54 FF           LEA    bx, [bp - 0xac]              ; UNKNOWN
00E499  9A CE 00 64 00        LCALL  0x64, 0xce                   ; UNKNOWN
00E49E  83 BE 56 FF 00        CMP    word ptr [bp - 0xaa], 0      ; UNKNOWN
00E4A3  7F 29                 JG     0xe4ce                       ; UNKNOWN
00E4A5  7C 08                 JL     0xe4af                       ; UNKNOWN
00E4A7  81 BE 54 FF 50 C3     CMP    word ptr [bp - 0xac], 0xc350 ; UNKNOWN
