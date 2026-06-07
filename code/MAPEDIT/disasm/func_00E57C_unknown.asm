; ============================================================================
; func_00E57C_unknown
; Region   : load_image
; Bytes    : file 0x00E57C..0x00E5A0  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E57C  55                    PUSH   bp ; STACK_PUSH
00E57D  8B EC                 MOV    bp, sp ; MOV
00E57F  57                    PUSH   di ; STACK_PUSH
00E580  56                    PUSH   si ; STACK_PUSH
00E581  1E                    PUSH   ds ; STACK_PUSH
00E582  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00E585  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00E588  48                    DEC    ax ; ARITH
00E589  8E D8                 MOV    ds, ax ; MOV
00E58B  33 F6                 XOR    si, si ; LOGIC
00E58D  B9 08 00              MOV    cx, 8 ; MOV
00E590  AC                    LODSB  al, byte ptr [si] ; STR
00E591  0A C0                 OR     al, al ; LOGIC
00E593  AA                    STOSB  byte ptr es:[di], al ; STR
00E594  E0 FA                 LOOPNE 0xe590 ; CJUMP
00E596  32 C0                 XOR    al, al ; LOGIC
00E598  AA                    STOSB  byte ptr es:[di], al ; STR
00E599  1F                    POP    ds ; STACK_POP
00E59A  5E                    POP    si ; STACK_POP
00E59B  5F                    POP    di ; STACK_POP
00E59C  C9                    LEAVE ; EPILOGUE
00E59D  CA 08 00              RETF   8 ; RETURN
