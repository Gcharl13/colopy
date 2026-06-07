; ============================================================================
; func_013AEE_unknown
; Region   : load_image
; Bytes    : file 0x013AEE..0x013B55  (103 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013AEE  55                    PUSH   bp ; STACK_PUSH
013AEF  8B EC                 MOV    bp, sp ; MOV
013AF1  57                    PUSH   di ; STACK_PUSH
013AF2  56                    PUSH   si ; STACK_PUSH
013AF3  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
013AF6  2B FF                 SUB    di, di ; ARITH
013AF8  26 39 3C              CMP    word ptr es:[si], di ; CMP
013AFB  74 75                 JE     0x13b72 ; CJUMP
013AFD  26 80 7C 04 01        CMP    byte ptr es:[si + 4], 1 ; CMP
013B02  74 58                 JE     0x13b5c ; CJUMP
013B04  26 80 7C 04 02        CMP    byte ptr es:[si + 4], 2 ; CMP
013B09  74 51                 JE     0x13b5c ; CJUMP
013B0B  26 39 7C 02           CMP    word ptr es:[si + 2], di ; CMP
013B0F  75 39                 JNE    0x13b4a ; CJUMP
013B11  26 FF 74 06           PUSH   word ptr es:[si + 6] ; STACK_PUSH
013B15  8C C7                 MOV    di, es ; MOV
013B17  9A 98 08 88 13        LCALL  0x1388, 0x898 ; LCALL
013B1C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
013B1F  8B C6                 MOV    ax, si ; MOV
013B21  8B D7                 MOV    dx, di ; MOV
013B23  05 1A 00              ADD    ax, 0x1a ; ARITH
013B26  52                    PUSH   dx ; STACK_PUSH
013B27  50                    PUSH   ax ; STACK_PUSH
013B28  6A 00                 PUSH   0 ; STACK_PUSH
013B2A  6A 01                 PUSH   1 ; STACK_PUSH
013B2C  8E C7                 MOV    es, di ; MOV
013B2E  8B DE                 MOV    bx, si ; MOV
013B30  26 8B 5F 06           MOV    bx, word ptr es:[bx + 6] ; MOV
013B34  B8 B0 00              MOV    ax, 0xb0 ; CONST_LOAD
013B37  99                    CDQ ; ARITH
013B38  9A 08 00 EA 0B        LCALL  0xbea, 8 ; LCALL
013B3D  0B D0                 OR     dx, ax ; LOGIC
013B3F  75 07                 JNE    0x13b48 ; CJUMP
013B41  BF 01 00              MOV    di, 1 ; MOV
013B44  EB 04                 JMP    0x13b4a ; JUMP
013B46  90                    NOP ; NOP
013B47  90                    NOP ; NOP
013B48  2B FF                 SUB    di, di ; ARITH
013B4A  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
013B4D  26 FF 74 06           PUSH   word ptr es:[si + 6] ; STACK_PUSH
013B51  9A                    DB     0x9A ; DATA_BYTE
013B52  C2                    DB     0xC2 ; DATA_BYTE
013B53  02                    DB     0x02 ; DATA_BYTE
013B54  88                    DB     0x88 ; DATA_BYTE
