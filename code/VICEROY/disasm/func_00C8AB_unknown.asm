; ============================================================================
; func_00C8AB_unknown
; Region   : load_image
; Bytes    : file 0x00C8AB..0x00C8DB  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C8AB  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00C8AF  06                    PUSH   es ; STACK_PUSH
00C8B0  57                    PUSH   di ; STACK_PUSH
00C8B1  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00C8B4  8C C0                 MOV    ax, es ; MOV
00C8B6  9C                    PUSHF ; STACK_PUSH
00C8B7  FA                    CLI ; FLAG
00C8B8  89 3E E4 92           MOV    word ptr [0x92e4], di ; GLOBAL_LOAD
00C8BC  A3 E6 92              MOV    word ptr [0x92e6], ax ; GLOBAL_LOAD
00C8BF  0B C7                 OR     ax, di ; LOGIC
00C8C1  C7 06 F2 92 00 00     MOV    word ptr [0x92f2], 0 ; GLOBAL_LOAD
00C8C7  C7 06 EE 92 00 00     MOV    word ptr [0x92ee], 0 ; GLOBAL_LOAD
00C8CD  C7 06 EC 92 00 00     MOV    word ptr [0x92ec], 0 ; GLOBAL_LOAD
00C8D3  A3 F0 92              MOV    word ptr [0x92f0], ax ; GLOBAL_LOAD
00C8D6  9D                    POPF ; STACK_POP
00C8D7  5F                    POP    di ; STACK_POP
00C8D8  07                    POP    es ; STACK_POP
00C8D9  C9                    LEAVE ; EPILOGUE
00C8DA  CB                    RETF ; RETURN
