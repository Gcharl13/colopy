; ============================================================================
; func_078B0E_unknown
; Region   : overlay
; Bytes    : file 0x078B0E..0x078B35  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078B0E  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
078B12  0E                    PUSH   cs ; STACK_PUSH
078B13  E8 22 00              CALL   0x78b38 ; CALL_NEAR
078B16  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
078B19  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
078B1C  9A BC 0F 1F 1A        LCALL  0x1a1f, 0xfbc ; THUNK -> 0x1100:0x000E (thunk @file 0x01D5AC type B)
078B21  3B 56 FE              CMP    dx, word ptr [bp - 2] ; CMP
078B24  7F 0D                 JG     0x78b33 ; CJUMP
078B26  7C 05                 JL     0x78b2d ; CJUMP
078B28  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
078B2B  73 06                 JAE    0x78b33 ; CJUMP
078B2D  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
078B30  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
078B33  C9                    LEAVE ; EPILOGUE
078B34  CB                    RETF ; RETURN
