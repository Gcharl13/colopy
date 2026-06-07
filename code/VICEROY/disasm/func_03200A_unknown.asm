; ============================================================================
; func_03200A_unknown
; Region   : overlay
; Bytes    : file 0x03200A..0x032021  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03200A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03200E  6A 15                 PUSH   0x15 ; PUSH_CONST
032010  B8 0F 00              MOV    ax, 0xf ; CONST_LOAD
032013  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
032016  50                    PUSH   ax ; STACK_PUSH
032017  68 B3 00              PUSH   0xb3 ; PUSH_CONST
03201A  68 31 01              PUSH   0x131 ; PUSH_CONST
03201D  9A                    DB     0x9A ; DATA_BYTE
03201E  CA                    DB     0xCA ; DATA_BYTE
03201F  03                    DB     0x03 ; DATA_BYTE
032020  1F                    DB     0x1F ; DATA_BYTE
