; ============================================================================
; func_00B848_unknown
; Region   : load_image
; Bytes    : file 0x00B848..0x00B883  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B848  55                    PUSH   bp ; STACK_PUSH
00B849  8B EC                 MOV    bp, sp ; MOV
00B84B  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
00B84F  75 06                 JNE    0xb857 ; CJUMP
00B851  C7 06 18 42 00 00     MOV    word ptr [0x4218], 0 ; GLOBAL_LOAD
00B857  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00B85A  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00B85D  D1 E3                 SHL    bx, 1 ; LOGIC
00B85F  39 87 1C 42           CMP    word ptr [bx + 0x421c], ax ; CMP
00B863  74 1F                 JE     0xb884 ; CJUMP
00B865  89 87 1C 42           MOV    word ptr [bx + 0x421c], ax ; MOV
00B869  C7 06 1A 42 FF FF     MOV    word ptr [0x421a], 0xffff ; GLOBAL_LOAD
00B86F  B4 44                 MOV    ah, 0x44 ; CONST_LOAD
00B871  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
00B874  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00B877  8B 16 0E 42           MOV    dx, word ptr [0x420e] ; GLOBAL_LOAD
00B87B  CD 67                 INT    0x67 ; SYS
00B87D  32 C0                 XOR    al, al ; LOGIC
00B87F  86 E0                 XCHG   al, ah ; MOV
00B881  C9                    LEAVE ; EPILOGUE
00B882  CB                    RETF ; RETURN
