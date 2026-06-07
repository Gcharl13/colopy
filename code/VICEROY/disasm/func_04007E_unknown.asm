; ============================================================================
; func_04007E_unknown
; Region   : overlay
; Bytes    : file 0x04007E..0x0400D0  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04007E  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
040082  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
040085  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
040088  FF 06 9C 53           INC    word ptr [0x539c] ; ARITH
04008C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
04008F  50                    PUSH   ax ; STACK_PUSH
040090  9A 94 08 1F 18        LCALL  0x181f, 0x894 ; THUNK -> 0x0427:0x0D1E (thunk @file 0x01AE84 type B) overlay @file 0x031A32
040095  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040098  B0 FF                 MOV    al, 0xff ; CONST_LOAD
04009A  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
04009E  88 87 44 31           MOV    byte ptr [bx + 0x3144], al ; MOV
0400A2  88 87 45 31           MOV    byte ptr [bx + 0x3145], al ; MOV
0400A6  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
0400AA  F5                    CMC ; FLAG
0400AB  1A C0                 SBB    al, al ; ARITH
0400AD  24 0D                 AND    al, 0xd ; LOGIC
0400AF  88 87 46 31           MOV    byte ptr [bx + 0x3146], al ; MOV
0400B3  C6 87 4A 31 FF        MOV    byte ptr [bx + 0x314a], 0xff ; CONST_LOAD
0400B8  C6 87 50 31 00        MOV    byte ptr [bx + 0x3150], 0 ; MOV
0400BD  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0400C0  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0400C3  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
0400C6  9A 44 08 1F 18        LCALL  0x181f, 0x844 ; THUNK -> 0x0427:0x02CA (thunk @file 0x01AE34 type B) overlay @file 0x030FDE
0400CB  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0400CE  C9                    LEAVE ; EPILOGUE
0400CF  CB                    RETF ; RETURN
