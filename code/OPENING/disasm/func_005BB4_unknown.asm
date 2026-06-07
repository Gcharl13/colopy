; ============================================================================
; func_005BB4_unknown
; Region   : load_image
; Bytes    : file 0x005BB4..0x005BE1  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005BB4  55                    PUSH   bp ; STACK_PUSH
005BB5  8B EC                 MOV    bp, sp ; MOV
005BB7  8B D7                 MOV    dx, di ; MOV
005BB9  8C D8                 MOV    ax, ds ; MOV
005BBB  8E C0                 MOV    es, ax ; MOV
005BBD  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
005BC0  8B DF                 MOV    bx, di ; MOV
005BC2  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
005BC5  E3 15                 JCXZ   0x5bdc ; CJUMP
005BC7  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
005BCA  8A E0                 MOV    ah, al ; MOV
005BCC  F7 C7 01 00           TEST   di, 1 ; LOGIC
005BD0  74 02                 JE     0x5bd4 ; CJUMP
005BD2  AA                    STOSB  byte ptr es:[di], al ; STR
005BD3  49                    DEC    cx ; ARITH
005BD4  D1 E9                 SHR    cx, 1 ; LOGIC
005BD6  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
005BD8  13 C9                 ADC    cx, cx ; ARITH
005BDA  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
005BDC  8B FA                 MOV    di, dx ; MOV
005BDE  93                    XCHG   bx, ax ; MOV
005BDF  5D                    POP    bp ; STACK_POP
005BE0  CB                    RETF ; RETURN
