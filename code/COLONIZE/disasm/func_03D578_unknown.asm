; ============================================================================
; func_03D578_unknown
; Region   : load_image
; Bytes    : file 0x03D578..0x03D62C  (180 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D578  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
03D57C  FF 36 12 83           PUSH   word ptr [0x8312]            ; UNKNOWN
03D580  FF 36 10 83           PUSH   word ptr [0x8310]            ; UNKNOWN
03D584  FF 36 0E 83           PUSH   word ptr [0x830e]            ; UNKNOWN
03D588  FF 36 0C 83           PUSH   word ptr [0x830c]            ; UNKNOWN
03D58C  2A C0                 SUB    al, al                       ; UNKNOWN
03D58E  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
03D593  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03D596  83 E8 10              SUB    ax, 0x10                     ; UNKNOWN
03D599  50                    PUSH   ax                           ; UNKNOWN
03D59A  6A 01                 PUSH   1                            ; UNKNOWN
03D59C  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D5A1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D5A4  83 C0 07              ADD    ax, 7                        ; UNKNOWN
03D5A7  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
03D5AA  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03D5AD  83 E8 08              SUB    ax, 8                        ; UNKNOWN
03D5B0  50                    PUSH   ax                           ; UNKNOWN
03D5B1  6A 01                 PUSH   1                            ; UNKNOWN
03D5B3  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D5B8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D5BB  83 C0 03              ADD    ax, 3                        ; UNKNOWN
03D5BE  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
03D5C1  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
03D5C5  74 1F                 JE     0x3d5e6                      ; UNKNOWN
03D5C7  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03D5CB  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03D5CF  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03D5D3  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03D5D7  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
03D5DA  8B 56 F2              MOV    dx, word ptr [bp - 0xe]      ; UNKNOWN
03D5DD  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03D5E2  0A C0                 OR     al, al                       ; UNKNOWN
03D5E4  75 AD                 JNE    0x3d593                      ; UNKNOWN
03D5E6  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
03D5EA  74 41                 JE     0x3d62d                      ; UNKNOWN
03D5EC  6A 0A                 PUSH   0xa                          ; UNKNOWN
03D5EE  6A 01                 PUSH   1                            ; UNKNOWN
03D5F0  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D5F5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D5F8  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03D5FB  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
03D5FE  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
03D601  0E                    PUSH   cs                           ; UNKNOWN
03D602  E8 E8 FE              CALL   0x3d4ed                      ; UNKNOWN
03D605  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D608  83 7E FE 07           CMP    word ptr [bp - 2], 7         ; UNKNOWN
03D60C  7C 0D                 JL     0x3d61b                      ; UNKNOWN
03D60E  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
03D611  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
03D614  0E                    PUSH   cs                           ; UNKNOWN
03D615  E8 D5 FE              CALL   0x3d4ed                      ; UNKNOWN
03D618  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D61B  83 7E FE 08           CMP    word ptr [bp - 2], 8         ; UNKNOWN
03D61F  7C 2C                 JL     0x3d64d                      ; UNKNOWN
03D621  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
03D624  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
03D627  0E                    PUSH   cs                           ; UNKNOWN
03D628  E8 C2 FE              CALL   0x3d4ed                      ; UNKNOWN
03D62B  EB                    DB     0xEB                         ; UNKNOWN (raw)
