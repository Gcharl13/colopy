; ============================================================================
; func_000E4C_unknown
; Region   : load_image
; Bytes    : file 0x000E4C..0x000E7A  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

000E4C  55                    PUSH   bp ; STACK_PUSH
000E4D  8B EC                 MOV    bp, sp ; MOV
000E4F  0E                    PUSH   cs ; STACK_PUSH
000E50  E8 3F FC              CALL   0xa92 ; CALL_NEAR
000E53  C7 06 54 4F 07 00     MOV    word ptr [0x4f54], 7 ; GLOBAL_LOAD
000E59  9A 02 00 4A 02        LCALL  0x24a, 2 ; LCALL
000E5E  A3 8C 48              MOV    word ptr [0x488c], ax ; GLOBAL_LOAD
000E61  89 16 8E 48           MOV    word ptr [0x488e], dx ; GLOBAL_LOAD
000E65  0E                    PUSH   cs ; STACK_PUSH
000E66  E8 A3 FD              CALL   0xc0c ; CALL_NEAR
000E69  0E                    PUSH   cs ; STACK_PUSH
000E6A  E8 55 FC              CALL   0xac2 ; CALL_NEAR
000E6D  0E                    PUSH   cs ; STACK_PUSH
000E6E  E8 27 FF              CALL   0xd98 ; CALL_NEAR
000E71  83 3E 6C 00 00        CMP    word ptr [0x6c], 0 ; CMP
000E76  75 E1                 JNE    0xe59 ; CJUMP
000E78  C9                    LEAVE ; EPILOGUE
000E79  CB                    RETF ; RETURN
