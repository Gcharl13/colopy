; ============================================================================
; func_0129A4_unknown
; Region   : load_image
; Bytes    : file 0x0129A4..0x0129DF  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0129A4  55                    PUSH   bp ; STACK_PUSH
0129A5  8B EC                 MOV    bp, sp ; MOV
0129A7  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
0129AB  75 06                 JNE    0x129b3 ; CJUMP
0129AD  C7 06 48 44 00 00     MOV    word ptr [0x4448], 0 ; GLOBAL_LOAD
0129B3  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0129B6  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0129B9  D1 E3                 SHL    bx, 1 ; LOGIC
0129BB  39 87 4C 44           CMP    word ptr [bx + 0x444c], ax ; CMP
0129BF  74 1F                 JE     0x129e0 ; CJUMP
0129C1  89 87 4C 44           MOV    word ptr [bx + 0x444c], ax ; MOV
0129C5  C7 06 4A 44 FF FF     MOV    word ptr [0x444a], 0xffff ; GLOBAL_LOAD
0129CB  B4 44                 MOV    ah, 0x44 ; CONST_LOAD
0129CD  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
0129D0  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0129D3  8B 16 3E 44           MOV    dx, word ptr [0x443e] ; GLOBAL_LOAD
0129D7  CD 67                 INT    0x67 ; SYS
0129D9  32 C0                 XOR    al, al ; LOGIC
0129DB  86 E0                 XCHG   al, ah ; MOV
0129DD  C9                    LEAVE ; EPILOGUE
0129DE  CB                    RETF ; RETURN
