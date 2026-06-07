; ============================================================================
; func_02D44E_unknown
; Region   : load_image
; Bytes    : file 0x02D44E..0x02D492  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D44E  55                    PUSH   bp                           ; UNKNOWN
02D44F  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D451  57                    PUSH   di                           ; UNKNOWN
02D452  56                    PUSH   si                           ; UNKNOWN
02D453  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
02D456  FF 76 10              PUSH   word ptr [bp + 0x10]         ; UNKNOWN
02D459  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
02D45C  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02D45F  50                    PUSH   ax                           ; UNKNOWN
02D460  57                    PUSH   di                           ; UNKNOWN
02D461  8B F0                 MOV    si, ax                       ; UNKNOWN
02D463  0E                    PUSH   cs                           ; UNKNOWN
02D464  E8 E8 FE              CALL   0x2d34f                      ; UNKNOWN
02D467  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02D46A  D1 F8                 SAR    ax, 1                        ; UNKNOWN
02D46C  8B 4E 0C              MOV    cx, word ptr [bp + 0xc]      ; UNKNOWN
02D46F  D1 F9                 SAR    cx, 1                        ; UNKNOWN
02D471  8B D6                 MOV    dx, si                       ; UNKNOWN
02D473  8B F1                 MOV    si, cx                       ; UNKNOWN
02D475  2B F0                 SUB    si, ax                       ; UNKNOWN
02D477  03 76 0A              ADD    si, word ptr [bp + 0xa]      ; UNKNOWN
02D47A  8B C6                 MOV    ax, si                       ; UNKNOWN
02D47C  0B C0                 OR     ax, ax                       ; UNKNOWN
02D47E  7D 02                 JGE    0x2d482                      ; UNKNOWN
02D480  2B C0                 SUB    ax, ax                       ; UNKNOWN
02D482  8B F0                 MOV    si, ax                       ; UNKNOWN
02D484  56                    PUSH   si                           ; UNKNOWN
02D485  52                    PUSH   dx                           ; UNKNOWN
02D486  57                    PUSH   di                           ; UNKNOWN
02D487  0E                    PUSH   cs                           ; UNKNOWN
02D488  E8 34 FF              CALL   0x2d3bf                      ; UNKNOWN
02D48B  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
02D48E  5E                    POP    si                           ; UNKNOWN
02D48F  5F                    POP    di                           ; UNKNOWN
02D490  C9                    LEAVE                               ; UNKNOWN
02D491  CB                    RETF                                ; UNKNOWN
