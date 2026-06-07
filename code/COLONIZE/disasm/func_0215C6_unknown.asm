; ============================================================================
; func_0215C6_unknown
; Region   : load_image
; Bytes    : file 0x0215C6..0x021608  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0215C6  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0215CA  57                    PUSH   di                           ; UNKNOWN
0215CB  56                    PUSH   si                           ; UNKNOWN
0215CC  8B F0                 MOV    si, ax                       ; UNKNOWN
0215CE  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
0215D1  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
0215D4  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
0215D9  72 0C                 JB     0x215e7                      ; UNKNOWN
0215DB  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
0215E0  77 05                 JA     0x215e7                      ; UNKNOWN
0215E2  BF 01 00              MOV    di, 1                        ; UNKNOWN
0215E5  EB 02                 JMP    0x215e9                      ; UNKNOWN
0215E7  2B FF                 SUB    di, di                       ; UNKNOWN
0215E9  52                    PUSH   dx                           ; UNKNOWN
0215EA  57                    PUSH   di                           ; UNKNOWN
0215EB  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0215EF  2A E4                 SUB    ah, ah                       ; UNKNOWN
0215F1  8A 9F 83 88           MOV    bl, byte ptr [bx - 0x777d]   ; UNKNOWN
0215F5  83 E3 0F              AND    bx, 0xf                      ; UNKNOWN
0215F8  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
0215FB  8A 94 81 88           MOV    dl, byte ptr [si - 0x777f]   ; UNKNOWN
0215FF  2A F6                 SUB    dh, dh                       ; UNKNOWN
021601  E8 6A FE              CALL   0x2146e                      ; UNKNOWN
021604  5E                    POP    si                           ; UNKNOWN
021605  5F                    POP    di                           ; UNKNOWN
021606  C9                    LEAVE                               ; UNKNOWN
021607  CB                    RETF                                ; UNKNOWN
