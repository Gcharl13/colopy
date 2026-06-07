; ============================================================================
; func_06999A_unknown
; Region   : load_image
; Bytes    : file 0x06999A..0x0699DF  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06999A  55                    PUSH   bp                           ; UNKNOWN
06999B  8B EC                 MOV    bp, sp                       ; UNKNOWN
06999D  8B D6                 MOV    dx, si                       ; UNKNOWN
06999F  1E                    PUSH   ds                           ; UNKNOWN
0699A0  C5 76 0A              LDS    si, ptr [bp + 0xa]           ; UNKNOWN
0699A3  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
0699A6  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
0699A8  0A C0                 OR     al, al                       ; UNKNOWN
0699AA  74 2D                 JE     0x699d9                      ; UNKNOWN
0699AC  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
0699AD  26 8A 27              MOV    ah, byte ptr es:[bx]         ; UNKNOWN
0699B0  43                    INC    bx                           ; UNKNOWN
0699B1  3A E0                 CMP    ah, al                       ; UNKNOWN
0699B3  74 F3                 JE     0x699a8                      ; UNKNOWN
0699B5  2C 41                 SUB    al, 0x41                     ; UNKNOWN
0699B7  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
0699B9  1A C9                 SBB    cl, cl                       ; UNKNOWN
0699BB  80 E1 20              AND    cl, 0x20                     ; UNKNOWN
0699BE  02 C1                 ADD    al, cl                       ; UNKNOWN
0699C0  04 41                 ADD    al, 0x41                     ; UNKNOWN
0699C2  86 E0                 XCHG   al, ah                       ; UNKNOWN
0699C4  2C 41                 SUB    al, 0x41                     ; UNKNOWN
0699C6  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
0699C8  1A C9                 SBB    cl, cl                       ; UNKNOWN
0699CA  80 E1 20              AND    cl, 0x20                     ; UNKNOWN
0699CD  02 C1                 ADD    al, cl                       ; UNKNOWN
0699CF  04 41                 ADD    al, 0x41                     ; UNKNOWN
0699D1  3A C4                 CMP    al, ah                       ; UNKNOWN
0699D3  74 D3                 JE     0x699a8                      ; UNKNOWN
0699D5  1A C0                 SBB    al, al                       ; UNKNOWN
0699D7  1C FF                 SBB    al, 0xff                     ; UNKNOWN
0699D9  98                    CWDE                                ; UNKNOWN
0699DA  1F                    POP    ds                           ; UNKNOWN
0699DB  8B F2                 MOV    si, dx                       ; UNKNOWN
0699DD  5D                    POP    bp                           ; UNKNOWN
0699DE  CB                    RETF                                ; UNKNOWN
