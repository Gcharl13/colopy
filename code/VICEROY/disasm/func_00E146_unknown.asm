; ============================================================================
; func_00E146_unknown
; Region   : load_image
; Bytes    : file 0x00E146..0x00E1A7  (97 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E146  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
00E14A  53                    PUSH   bx ; STACK_PUSH
00E14B  52                    PUSH   dx ; STACK_PUSH
00E14C  50                    PUSH   ax ; STACK_PUSH
00E14D  57                    PUSH   di ; STACK_PUSH
00E14E  56                    PUSH   si ; STACK_PUSH
00E14F  2B 5E 0E              SUB    bx, word ptr [bp + 0xe] ; ARITH
00E152  F7 DB                 NEG    bx ; ARITH
00E154  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
00E157  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
00E15A  89 56 F4              MOV    word ptr [bp - 0xc], dx ; LOCAL_STORE
00E15D  8B 4E 12              MOV    cx, word ptr [bp + 0x12] ; LOCAL_LOAD
00E160  0B 4E 10              OR     cx, word ptr [bp + 0x10] ; LOGIC
00E163  74 05                 JE     0xe16a ; CJUMP
00E165  B8 01 00              MOV    ax, 1 ; MOV
00E168  EB 02                 JMP    0xe16c ; JUMP
00E16A  2B C0                 SUB    ax, ax ; ARITH
00E16C  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00E16F  0B C0                 OR     ax, ax ; LOGIC
00E171  74 55                 JE     0xe1c8 ; CJUMP
00E173  8D 5E 0C              LEA    bx, [bp + 0xc] ; ADDR
00E176  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
00E179  8B 56 F4              MOV    dx, word ptr [bp - 0xc] ; LOCAL_LOAD
00E17C  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
00E181  52                    PUSH   dx ; STACK_PUSH
00E182  50                    PUSH   ax ; STACK_PUSH
00E183  9A 04 00 05 0C        LCALL  0xc05, 4 ; LCALL
00E188  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00E18B  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
00E18E  C4 7E FA              LES    di, ptr [bp - 6] ; MOV_FAR
00E191  8A 66 08              MOV    ah, byte ptr [bp + 8] ; LOCAL_LOAD
00E194  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
00E197  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
00E19A  0B F6                 OR     si, si ; LOGIC
00E19C  75 02                 JNE    0xe1a0 ; CJUMP
00E19E  EB 28                 JMP    0xe1c8 ; JUMP
00E1A0  8B 56 F2              MOV    dx, word ptr [bp - 0xe] ; LOCAL_LOAD
00E1A3  8B CA                 MOV    cx, dx ; MOV
00E1A5  26                    DB     0x26 ; DATA_BYTE
00E1A6  8A                    DB     0x8A ; DATA_BYTE
