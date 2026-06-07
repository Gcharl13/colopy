; ============================================================================
; func_04072F_unknown
; Region   : load_image
; Bytes    : file 0x04072F..0x04075F  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04072F  55                    PUSH   bp                           ; UNKNOWN
040730  8B EC                 MOV    bp, sp                       ; UNKNOWN
040732  57                    PUSH   di                           ; UNKNOWN
040733  56                    PUSH   si                           ; UNKNOWN
040734  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
040737  2B F6                 SUB    si, si                       ; UNKNOWN
040739  57                    PUSH   di                           ; UNKNOWN
04073A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04073D  9A D1 03 C9 33        LCALL  0x33c9, 0x3d1                ; UNKNOWN
040742  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040745  0B C0                 OR     ax, ax                       ; UNKNOWN
040747  7D 10                 JGE    0x40759                      ; UNKNOWN
040749  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
04074C  57                    PUSH   di                           ; UNKNOWN
04074D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
040750  0E                    PUSH   cs                           ; UNKNOWN
040751  E8 15 FF              CALL   0x40669                      ; UNKNOWN
040754  83 C4 06              ADD    sp, 6                        ; UNKNOWN
040757  8B F0                 MOV    si, ax                       ; UNKNOWN
040759  8B C6                 MOV    ax, si                       ; UNKNOWN
04075B  5E                    POP    si                           ; UNKNOWN
04075C  5F                    POP    di                           ; UNKNOWN
04075D  C9                    LEAVE                               ; UNKNOWN
04075E  CB                    RETF                                ; UNKNOWN
