; ============================================================================
; func_00C646_unknown
; Region   : load_image
; Bytes    : file 0x00C646..0x00C690  (74 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C646  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
00C64A  C7 46 F6 00 FF        MOV    word ptr [bp - 0xa], 0xff00 ; LOCAL_STORE
00C64F  C7 46 F8 00 A0        MOV    word ptr [bp - 8], 0xa000 ; LOCAL_STORE
00C654  C7 46 FA 50 FD        MOV    word ptr [bp - 6], 0xfd50 ; LOCAL_STORE
00C659  C7 46 FC 00 A0        MOV    word ptr [bp - 4], 0xa000 ; LOCAL_STORE
00C65E  C7 46 FE 60 00        MOV    word ptr [bp - 2], 0x60 ; LOCAL_STORE
00C663  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
00C667  74 11                 JE     0xc67a ; CJUMP
00C669  6A 60                 PUSH   0x60 ; PUSH_CONST
00C66B  68 00 A0              PUSH   0xa000 ; PUSH_CONST
00C66E  68 50 FD              PUSH   0xfd50 ; PUSH_CONST
00C671  68 00 A0              PUSH   0xa000 ; PUSH_CONST
00C674  68 00 FF              PUSH   0xff00 ; PUSH_CONST
00C677  EB 10                 JMP    0xc689 ; JUMP
00C679  90                    NOP ; NOP
00C67A  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00C67D  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
00C680  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
00C683  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00C686  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00C689  9A B2 0F 1D 0D        LCALL  0xd1d, 0xfb2 ; LCALL
00C68E  C9                    LEAVE ; EPILOGUE
00C68F  CB                    RETF ; RETURN
