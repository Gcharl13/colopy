; ============================================================================
; func_02633E_unknown
; Region   : overlay
; Bytes    : file 0x02633E..0x026374  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02633E  55                    PUSH   bp ; STACK_PUSH
02633F  8B EC                 MOV    bp, sp ; MOV
026341  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
026345  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
026349  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
02634D  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
026351  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
026355  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
026359  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
02635D  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
026361  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
026364  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
026367  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
02636A  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
02636D  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
026372  C9                    LEAVE ; EPILOGUE
026373  CB                    RETF ; RETURN
