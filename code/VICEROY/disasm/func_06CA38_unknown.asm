; ============================================================================
; func_06CA38_unknown
; Region   : overlay
; Bytes    : file 0x06CA38..0x06CA72  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06CA38  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
06CA3C  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06CA3F  26 80 4F 0A 05        OR     byte ptr es:[bx + 0xa], 5 ; LOGIC
06CA44  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
06CA47  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
06CA4A  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
06CA4D  06                    PUSH   es ; STACK_PUSH
06CA4E  53                    PUSH   bx ; STACK_PUSH
06CA4F  0E                    PUSH   cs ; STACK_PUSH
06CA50  E8 AB 2D              CALL   0x6f7fe ; CALL_NEAR
06CA53  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
06CA56  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06CA59  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
06CA5C  0B D0                 OR     dx, ax ; LOGIC
06CA5E  74 0A                 JE     0x6ca6a ; CJUMP
06CA60  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
06CA63  C4 5E FC              LES    bx, ptr [bp - 4] ; MOV_FAR
06CA66  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
06CA6A  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
06CA6D  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
06CA70  C9                    LEAVE ; EPILOGUE
06CA71  CB                    RETF ; RETURN
