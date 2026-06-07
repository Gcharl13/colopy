; ============================================================================
; func_00275C_unknown
; Region   : load_image
; Bytes    : file 0x00275C..0x002783  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00275C  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
002760  80 3E 4A 00 00        CMP    byte ptr [0x4a], 0 ; CMP
002765  75 0B                 JNE    0x2772 ; CJUMP
002767  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00276A  0B 46 08              OR     ax, word ptr [bp + 8] ; LOGIC
00276D  75 03                 JNE    0x2772 ; CJUMP
00276F  E9 1E 01              JMP    0x2890 ; JUMP
002772  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
002776  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
00277A  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
00277E  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
002782  A1                    DB     0xA1 ; DATA_BYTE
