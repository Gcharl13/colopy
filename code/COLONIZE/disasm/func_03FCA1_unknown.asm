; ============================================================================
; func_03FCA1_unknown
; Region   : load_image
; Bytes    : file 0x03FCA1..0x03FCD7  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FCA1  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03FCA5  52                    PUSH   dx                           ; UNKNOWN
03FCA6  57                    PUSH   di                           ; UNKNOWN
03FCA7  56                    PUSH   si                           ; UNKNOWN
03FCA8  BF FF FF              MOV    di, 0xffff                   ; UNKNOWN
03FCAB  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
03FCAE  0E                    PUSH   cs                           ; UNKNOWN
03FCAF  E8 C6 FE              CALL   0x3fb78                      ; UNKNOWN
03FCB2  8B F0                 MOV    si, ax                       ; UNKNOWN
03FCB4  0B F6                 OR     si, si                       ; UNKNOWN
03FCB6  7C 19                 JL     0x3fcd1                      ; UNKNOWN
03FCB8  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03FCBB  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
03FCBE  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
03FCC1  75 02                 JNE    0x3fcc5                      ; UNKNOWN
03FCC3  8B FE                 MOV    di, si                       ; UNKNOWN
03FCC5  8B C6                 MOV    ax, si                       ; UNKNOWN
03FCC7  0E                    PUSH   cs                           ; UNKNOWN
03FCC8  E8 F3 FE              CALL   0x3fbbe                      ; UNKNOWN
03FCCB  8B F0                 MOV    si, ax                       ; UNKNOWN
03FCCD  0B FF                 OR     di, di                       ; UNKNOWN
03FCCF  7C E3                 JL     0x3fcb4                      ; UNKNOWN
03FCD1  8B C7                 MOV    ax, di                       ; UNKNOWN
03FCD3  5E                    POP    si                           ; UNKNOWN
03FCD4  5F                    POP    di                           ; UNKNOWN
03FCD5  C9                    LEAVE                               ; UNKNOWN
03FCD6  CB                    RETF                                ; UNKNOWN
