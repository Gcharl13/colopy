; ============================================================================
; func_02356C_unknown
; Region   : overlay
; Bytes    : file 0x02356C..0x02359C  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02356C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
023570  9A 6E 02 1F 19        LCALL  0x191f, 0x26e ; THUNK -> 0x0000:0x36FC (thunk @file 0x01B85E type A) overlay @file 0x028FFC
023575  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
02357A  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
02357D  8B C8                 MOV    cx, ax ; MOV
02357F  40                    INC    ax ; ARITH
023580  2A ED                 SUB    ch, ch ; ARITH
023582  BA 01 00              MOV    dx, 1 ; MOV
023585  D3 E2                 SHL    dx, cl ; LOGIC
023587  23 16 94 08           AND    dx, word ptr [0x894] ; LOGIC
02358B  9A 62 02 1F 19        LCALL  0x191f, 0x262 ; THUNK -> 0x0000:0x3704 (thunk @file 0x01B852 type A) overlay @file 0x029004
023590  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
023593  83 7E FE 07           CMP    word ptr [bp - 2], 7 ; CMP
023597  7C E1                 JL     0x2357a ; CJUMP
023599  8D                    DB     0x8D ; DATA_BYTE
02359A  1E                    DB     0x1E ; DATA_BYTE
02359B  C3                    DB     0xC3 ; DATA_BYTE
