; ============================================================================
; func_00CECF_unknown
; Region   : load_image
; Bytes    : file 0x00CECF..0x00CEE8  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CECF  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00CED3  06                    PUSH   es ; STACK_PUSH
00CED4  C4 46 06              LES    ax, ptr [bp + 6] ; MOV_FAR
00CED7  A3 AE 05              MOV    word ptr [0x5ae], ax ; GLOBAL_LOAD
00CEDA  8C C0                 MOV    ax, es ; MOV
00CEDC  A3 AC 05              MOV    word ptr [0x5ac], ax ; GLOBAL_LOAD
00CEDF  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00CEE2  A3 B0 05              MOV    word ptr [0x5b0], ax ; GLOBAL_LOAD
00CEE5  07                    POP    es ; STACK_POP
00CEE6  C9                    LEAVE ; EPILOGUE
00CEE7  CB                    RETF ; RETURN
