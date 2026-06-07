; ============================================================================
; func_03FD4F_unknown
; Region   : load_image
; Bytes    : file 0x03FD4F..0x03FD76  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FD4F  55                    PUSH   bp                           ; UNKNOWN
03FD50  8B EC                 MOV    bp, sp                       ; UNKNOWN
03FD52  57                    PUSH   di                           ; UNKNOWN
03FD53  56                    PUSH   si                           ; UNKNOWN
03FD54  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
03FD57  2B FF                 SUB    di, di                       ; UNKNOWN
03FD59  8B C6                 MOV    ax, si                       ; UNKNOWN
03FD5B  0E                    PUSH   cs                           ; UNKNOWN
03FD5C  E8 19 FE              CALL   0x3fb78                      ; UNKNOWN
03FD5F  8B F0                 MOV    si, ax                       ; UNKNOWN
03FD61  0B F6                 OR     si, si                       ; UNKNOWN
03FD63  7C 0B                 JL     0x3fd70                      ; UNKNOWN
03FD65  47                    INC    di                           ; UNKNOWN
03FD66  0E                    PUSH   cs                           ; UNKNOWN
03FD67  E8 54 FE              CALL   0x3fbbe                      ; UNKNOWN
03FD6A  8B F0                 MOV    si, ax                       ; UNKNOWN
03FD6C  0B F6                 OR     si, si                       ; UNKNOWN
03FD6E  7D F5                 JGE    0x3fd65                      ; UNKNOWN
03FD70  8B C7                 MOV    ax, di                       ; UNKNOWN
03FD72  5E                    POP    si                           ; UNKNOWN
03FD73  5F                    POP    di                           ; UNKNOWN
03FD74  C9                    LEAVE                               ; UNKNOWN
03FD75  CB                    RETF                                ; UNKNOWN
