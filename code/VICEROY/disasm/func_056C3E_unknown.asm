; ============================================================================
; func_056C3E_unknown
; Region   : overlay
; Bytes    : file 0x056C3E..0x056C59  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

056C3E  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
056C42  56                    PUSH   si ; STACK_PUSH
056C43  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
056C46  89 46 C0              MOV    word ptr [bp - 0x40], ax ; LOCAL_STORE
056C49  89 46 B6              MOV    word ptr [bp - 0x4a], ax ; LOCAL_STORE
056C4C  2B C0                 SUB    ax, ax ; ARITH
056C4E  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
056C51  89 46 B0              MOV    word ptr [bp - 0x50], ax ; LOCAL_STORE
056C54  89 46 CA              MOV    word ptr [bp - 0x36], ax ; LOCAL_STORE
056C57  8B                    DB     0x8B ; DATA_BYTE
056C58  46                    DB     0x46 ; DATA_BYTE
