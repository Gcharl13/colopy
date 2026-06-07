; ============================================================================
; func_06CD66_unknown
; Region   : overlay
; Bytes    : file 0x06CD66..0x06CD8B  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06CD66  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
06CD6A  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06CD6D  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
06CD70  2A E4                 SUB    ah, ah ; ARITH
06CD72  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06CD75  3D 06 00              CMP    ax, 6 ; CMP
06CD78  75 0C                 JNE    0x6cd86 ; CJUMP
06CD7A  83 3E 8A 1F 00        CMP    word ptr [0x1f8a], 0 ; CMP
06CD7F  75 05                 JNE    0x6cd86 ; CJUMP
06CD81  C7 46 FE 05 00        MOV    word ptr [bp - 2], 5 ; LOCAL_STORE
06CD86  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
06CD89  C9                    LEAVE ; EPILOGUE
06CD8A  C3                    RET ; RETURN
