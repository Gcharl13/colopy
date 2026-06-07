; ============================================================================
; func_00D3BE_unknown
; Region   : load_image
; Bytes    : file 0x00D3BE..0x00D3EB  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D3BE  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00D3C2  56                    PUSH   si ; STACK_PUSH
00D3C3  6A 0A                 PUSH   0xa ; PUSH_CONST
00D3C5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00D3C8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00D3CB  9A EA 10 1D 0D        LCALL  0xd1d, 0x10ea ; LCALL
00D3D0  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00D3D3  8B F0                 MOV    si, ax ; MOV
00D3D5  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
00D3D8  0B D0                 OR     dx, ax ; LOGIC
00D3DA  74 07                 JE     0xd3e3 ; CJUMP
00D3DC  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
00D3DF  26 C6 04 00           MOV    byte ptr es:[si], 0 ; MOV
00D3E3  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
00D3E6  5E                    POP    si ; STACK_POP
00D3E7  C9                    LEAVE ; EPILOGUE
00D3E8  CA 04 00              RETF   4 ; RETURN
