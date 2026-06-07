; ============================================================================
; func_01285A_unknown
; Region   : load_image
; Bytes    : file 0x01285A..0x01287A  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01285A  55                    PUSH   bp ; STACK_PUSH
01285B  8B EC                 MOV    bp, sp ; MOV
01285D  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
012860  B8 00 43              MOV    ax, 0x4300 ; CONST_LOAD
012863  CD 21                 INT    0x21 ; SYS
012865  72 0F                 JB     0x12876 ; CJUMP
012867  F6 46 08 02           TEST   byte ptr [bp + 8], 2 ; LOGIC
01286B  74 09                 JE     0x12876 ; CJUMP
01286D  F6 C1 01              TEST   cl, 1 ; LOGIC
012870  74 04                 JE     0x12876 ; CJUMP
012872  B8 00 0D              MOV    ax, 0xd00 ; CONST_LOAD
012875  F9                    STC ; FLAG
012876  E9 57 E2              JMP    0x10ad0 ; JUMP
012879  00                    DB     0x00 ; DATA_BYTE
