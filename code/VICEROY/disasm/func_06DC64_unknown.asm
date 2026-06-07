; ============================================================================
; func_06DC64_unknown
; Region   : overlay
; Bytes    : file 0x06DC64..0x06DC98  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06DC64  C8 6A 00 00           ENTER  0x6a, 0 ; PROLOGUE
06DC68  50                    PUSH   ax ; STACK_PUSH
06DC69  57                    PUSH   di ; STACK_PUSH
06DC6A  56                    PUSH   si ; STACK_PUSH
06DC6B  C7 06 62 1F 00 00     MOV    word ptr [0x1f62], 0 ; GLOBAL_LOAD
06DC71  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06DC74  26 8B 47 24           MOV    ax, word ptr es:[bx + 0x24] ; MOV
06DC78  26 03 47 48           ADD    ax, word ptr es:[bx + 0x48] ; ARITH
06DC7C  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
06DC7F  26 8B 47 26           MOV    ax, word ptr es:[bx + 0x26] ; MOV
06DC83  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
06DC86  26 8B 47 60           MOV    ax, word ptr es:[bx + 0x60] ; MOV
06DC8A  26 8B 57 62           MOV    dx, word ptr es:[bx + 0x62] ; MOV
06DC8E  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
06DC91  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
06DC94  8B C2                 MOV    ax, dx ; MOV
06DC96  0B                    DB     0x0B ; DATA_BYTE
06DC97  46                    DB     0x46 ; DATA_BYTE
