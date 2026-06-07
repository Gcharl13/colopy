; ============================================================================
; func_03AF16_unknown
; Region   : load_image
; Bytes    : file 0x03AF16..0x03AFAE  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03AF16  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03AF1A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03AF1F  EB 15                 JMP    0x3af36                      ; UNKNOWN
03AF21  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
03AF24  9A FC 0F 98 3A        LCALL  0x3a98, 0xffc                ; UNKNOWN
03AF29  9A 26 01 BE 17        LCALL  0x17be, 0x126                ; UNKNOWN
03AF2E  9A 5B 01 BE 17        LCALL  0x17be, 0x15b                ; UNKNOWN
03AF33  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
03AF36  83 7E FE 03           CMP    word ptr [bp - 2], 3         ; UNKNOWN
03AF3A  7F 12                 JG     0x3af4e                      ; UNKNOWN
03AF3C  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03AF3F  A3 3E 0B              MOV    word ptr [0xb3e], ax         ; UNKNOWN
03AF42  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
03AF47  74 D8                 JE     0x3af21                      ; UNKNOWN
03AF49  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03AF4C  EB D6                 JMP    0x3af24                      ; UNKNOWN
03AF4E  C7 06 3E 0B 00 00     MOV    word ptr [0xb3e], 0          ; UNKNOWN
03AF54  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
03AF59  8B D8                 MOV    bx, ax                       ; UNKNOWN
03AF5B  89 5E FC              MOV    word ptr [bp - 4], bx        ; UNKNOWN
03AF5E  F6 87 BB 13 02        TEST   byte ptr [bx + 0x13bb], 2    ; UNKNOWN
03AF63  74 06                 JE     0x3af6b                      ; UNKNOWN
03AF65  8D 47 E0              LEA    ax, [bx - 0x20]              ; UNKNOWN
03AF68  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03AF6B  83 7E FC 48           CMP    word ptr [bp - 4], 0x48      ; UNKNOWN
03AF6F  75 34                 JNE    0x3afa5                      ; UNKNOWN
03AF71  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; UNKNOWN
03AF76  EB 15                 JMP    0x3af8d                      ; UNKNOWN
03AF78  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
03AF7B  9A FC 0F 98 3A        LCALL  0x3a98, 0xffc                ; UNKNOWN
03AF80  9A 26 01 BE 17        LCALL  0x17be, 0x126                ; UNKNOWN
03AF85  9A 5B 01 BE 17        LCALL  0x17be, 0x15b                ; UNKNOWN
03AF8A  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
03AF8D  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
03AF91  7C 12                 JL     0x3afa5                      ; UNKNOWN
03AF93  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03AF96  A3 3E 0B              MOV    word ptr [0xb3e], ax         ; UNKNOWN
03AF99  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
03AF9E  74 D8                 JE     0x3af78                      ; UNKNOWN
03AFA0  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03AFA3  EB D6                 JMP    0x3af7b                      ; UNKNOWN
03AFA5  6A 01                 PUSH   1                            ; UNKNOWN
03AFA7  9A C6 00 E4 35        LCALL  0x35e4, 0xc6                 ; UNKNOWN
03AFAC  C9                    LEAVE                               ; UNKNOWN
03AFAD  CB                    RETF                                ; UNKNOWN
