; ============================================================================
; func_02D566_unknown
; Region   : load_image
; Bytes    : file 0x02D566..0x02D5AD  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D566  55                    PUSH   bp                           ; UNKNOWN
02D567  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D569  57                    PUSH   di                           ; UNKNOWN
02D56A  56                    PUSH   si                           ; UNKNOWN
02D56B  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
02D56E  FF 76 12              PUSH   word ptr [bp + 0x12]         ; UNKNOWN
02D571  FF 76 10              PUSH   word ptr [bp + 0x10]         ; UNKNOWN
02D574  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
02D577  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02D57A  50                    PUSH   ax                           ; UNKNOWN
02D57B  57                    PUSH   di                           ; UNKNOWN
02D57C  8B F0                 MOV    si, ax                       ; UNKNOWN
02D57E  0E                    PUSH   cs                           ; UNKNOWN
02D57F  E8 E8 FD              CALL   0x2d36a                      ; UNKNOWN
02D582  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02D585  D1 F8                 SAR    ax, 1                        ; UNKNOWN
02D587  8B 4E 0C              MOV    cx, word ptr [bp + 0xc]      ; UNKNOWN
02D58A  D1 F9                 SAR    cx, 1                        ; UNKNOWN
02D58C  8B D6                 MOV    dx, si                       ; UNKNOWN
02D58E  8B F1                 MOV    si, cx                       ; UNKNOWN
02D590  2B F0                 SUB    si, ax                       ; UNKNOWN
02D592  03 76 0A              ADD    si, word ptr [bp + 0xa]      ; UNKNOWN
02D595  8B C6                 MOV    ax, si                       ; UNKNOWN
02D597  0B C0                 OR     ax, ax                       ; UNKNOWN
02D599  7D 02                 JGE    0x2d59d                      ; UNKNOWN
02D59B  2B C0                 SUB    ax, ax                       ; UNKNOWN
02D59D  8B F0                 MOV    si, ax                       ; UNKNOWN
02D59F  56                    PUSH   si                           ; UNKNOWN
02D5A0  52                    PUSH   dx                           ; UNKNOWN
02D5A1  57                    PUSH   di                           ; UNKNOWN
02D5A2  0E                    PUSH   cs                           ; UNKNOWN
02D5A3  E8 2A FF              CALL   0x2d4d0                      ; UNKNOWN
02D5A6  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
02D5A9  5E                    POP    si                           ; UNKNOWN
02D5AA  5F                    POP    di                           ; UNKNOWN
02D5AB  C9                    LEAVE                               ; UNKNOWN
02D5AC  CB                    RETF                                ; UNKNOWN
