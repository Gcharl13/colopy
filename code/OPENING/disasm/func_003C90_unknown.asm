; ============================================================================
; func_003C90_unknown
; Region   : load_image
; Bytes    : file 0x003C90..0x003CA5  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003C90  55                    PUSH   bp ; STACK_PUSH
003C91  8B EC                 MOV    bp, sp ; MOV
003C93  57                    PUSH   di ; STACK_PUSH
003C94  56                    PUSH   si ; STACK_PUSH
003C95  B4 52                 MOV    ah, 0x52 ; CONST_LOAD
003C97  CD 21                 INT    0x21 ; SYS
003C99  26 8B 5F FE           MOV    bx, word ptr es:[bx - 2] ; MOV
003C9D  33 FF                 XOR    di, di ; LOGIC
003C9F  33 F6                 XOR    si, si ; LOGIC
003CA1  33 C0                 XOR    ax, ax ; LOGIC
003CA3  8E C3                 MOV    es, bx ; MOV
