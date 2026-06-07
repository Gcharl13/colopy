; ============================================================================
; func_00466C_unknown
; Region   : load_image
; Bytes    : file 0x00466C..0x00469A  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00466C  55                    PUSH   bp ; STACK_PUSH
00466D  8B EC                 MOV    bp, sp ; MOV
00466F  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
004672  24 1F                 AND    al, 0x1f ; LOGIC
004674  2A E4                 SUB    ah, ah ; ARITH
004676  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
004679  A1 DA 04              MOV    ax, word ptr [0x4da] ; GLOBAL_LOAD
00467C  EB 2C                 JMP    0x46aa ; JUMP
00467E  83 7E 06 18           CMP    word ptr [bp + 6], 0x18 ; CMP
004682  7D 2D                 JGE    0x46b1 ; CJUMP
004684  83 7E 06 08           CMP    word ptr [bp + 6], 8 ; CMP
004688  7C 27                 JL     0x46b1 ; CJUMP
00468A  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
00468D  25 07 00              AND    ax, 7 ; LOGIC
004690  0C 08                 OR     al, 8 ; LOGIC
004692  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
004695  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
004698  C9                    LEAVE ; EPILOGUE
004699  CB                    RETF ; RETURN
