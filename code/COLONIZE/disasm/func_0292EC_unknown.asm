; ============================================================================
; func_0292EC_unknown
; Region   : load_image
; Bytes    : file 0x0292EC..0x029335  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0292EC  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0292F0  A1 E4 0E              MOV    ax, word ptr [0xee4]         ; UNKNOWN
0292F3  83 E8 3D              SUB    ax, 0x3d                     ; UNKNOWN
0292F6  B9 14 00              MOV    cx, 0x14                     ; UNKNOWN
0292F9  99                    CDQ                                 ; UNKNOWN
0292FA  F7 F9                 IDIV   cx                           ; UNKNOWN
0292FC  83 F8 03              CMP    ax, 3                        ; UNKNOWN
0292FF  7E 03                 JLE    0x29304                      ; UNKNOWN
029301  B8 03 00              MOV    ax, 3                        ; UNKNOWN
029304  50                    PUSH   ax                           ; UNKNOWN
029305  0E                    PUSH   cs                           ; UNKNOWN
029306  E8 B5 EF              CALL   0x282be                      ; UNKNOWN
029309  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02930C  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
029311  83 3E E2 0E 73        CMP    word ptr [0xee2], 0x73       ; UNKNOWN
029316  7C 05                 JL     0x2931d                      ; UNKNOWN
029318  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
02931D  81 3E E2 0E C6 00     CMP    word ptr [0xee2], 0xc6       ; UNKNOWN
029323  7C 05                 JL     0x2932a                      ; UNKNOWN
029325  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2         ; UNKNOWN
02932A  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02932D  EB 1D                 JMP    0x2934c                      ; UNKNOWN
02932F  0E                    PUSH   cs                           ; UNKNOWN
029330  E8 2E FD              CALL   0x29061                      ; UNKNOWN
029333  C9                    LEAVE                               ; UNKNOWN
029334  CB                    RETF                                ; UNKNOWN
