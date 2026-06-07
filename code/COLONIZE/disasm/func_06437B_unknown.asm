; ============================================================================
; func_06437B_unknown
; Region   : load_image
; Bytes    : file 0x06437B..0x0643A9  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06437B  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
06437F  57                    PUSH   di                           ; UNKNOWN
064380  56                    PUSH   si                           ; UNKNOWN
064381  8B F3                 MOV    si, bx                       ; UNKNOWN
064383  8B F8                 MOV    di, ax                       ; UNKNOWN
064385  57                    PUSH   di                           ; UNKNOWN
064386  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
064387  98                    CWDE                                ; UNKNOWN
064388  50                    PUSH   ax                           ; UNKNOWN
064389  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
06438C  9A E8 06 65 5F        LCALL  0x5f65, 0x6e8                ; UNKNOWN
064391  83 C4 04              ADD    sp, 4                        ; UNKNOWN
064394  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
064398  75 EB                 JNE    0x64385                      ; UNKNOWN
06439A  57                    PUSH   di                           ; UNKNOWN
06439B  6A 1A                 PUSH   0x1a                         ; UNKNOWN
06439D  9A E8 06 65 5F        LCALL  0x5f65, 0x6e8                ; UNKNOWN
0643A2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0643A5  5E                    POP    si                           ; UNKNOWN
0643A6  5F                    POP    di                           ; UNKNOWN
0643A7  C9                    LEAVE                               ; UNKNOWN
0643A8  CB                    RETF                                ; UNKNOWN
