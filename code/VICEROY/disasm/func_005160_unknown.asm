; ============================================================================
; func_005160_unknown
; Region   : load_image
; Bytes    : file 0x005160..0x00518D  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005160  55                    PUSH   bp ; STACK_PUSH
005161  8B EC                 MOV    bp, sp ; MOV
005163  9A 54 00 58 0A        LCALL  0xa58, 0x54 ; LCALL
005168  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00516B  68 00 A0              PUSH   0xa000 ; PUSH_CONST
00516E  6A 00                 PUSH   0 ; STACK_PUSH
005170  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
005174  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
005178  9A 32 01 1D 0D        LCALL  0xd1d, 0x132 ; LCALL
00517D  8B E5                 MOV    sp, bp ; MOV
00517F  83 3E AC 83 00        CMP    word ptr [0x83ac], 0 ; CMP
005184  74 05                 JE     0x518b ; CJUMP
005186  9A 0D 00 58 0A        LCALL  0xa58, 0xd ; LCALL
00518B  C9                    LEAVE ; EPILOGUE
00518C  CB                    RETF ; RETURN
