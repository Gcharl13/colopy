; ============================================================================
; func_078B3E_unknown
; Region   : overlay
; Bytes    : file 0x078B3E..0x078B72  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078B3E  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
078B42  56                    PUSH   si ; STACK_PUSH
078B43  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
078B48  8B C8                 MOV    cx, ax ; MOV
078B4A  C4 5E 0E              LES    bx, ptr [bp + 0xe] ; MOV_FAR
078B4D  26 88 07              MOV    byte ptr es:[bx], al ; MOV
078B50  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
078B53  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
078B56  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
078B59  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
078B5C  8B F1                 MOV    si, cx ; MOV
078B5E  9A 90 0E 1F 1A        LCALL  0x1a1f, 0xe90 ; THUNK -> 0x0000:0x0022 (thunk @file 0x01D480 type A) overlay @file 0x025922
078B63  C4 5E 0E              LES    bx, ptr [bp + 0xe] ; MOV_FAR
078B66  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
078B6A  26 89 57 04           MOV    word ptr es:[bx + 4], dx ; MOV
078B6E  8B C2                 MOV    ax, dx ; MOV
078B70  26                    DB     0x26 ; DATA_BYTE
078B71  0B                    DB     0x0B ; DATA_BYTE
