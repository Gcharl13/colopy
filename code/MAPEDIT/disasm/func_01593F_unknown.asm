; ============================================================================
; func_01593F_unknown
; Region   : load_image
; Bytes    : file 0x01593F..0x015965  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01593F  55                    PUSH   bp ; STACK_PUSH
015940  8B EC                 MOV    bp, sp ; MOV
015942  1E                    PUSH   ds ; STACK_PUSH
015943  B0 4E                 MOV    al, 0x4e ; CONST_LOAD
015945  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
015948  B4 2F                 MOV    ah, 0x2f ; CONST_LOAD
01594A  CD 21                 INT    0x21 ; SYS
01594C  B4 1A                 MOV    ah, 0x1a ; CONST_LOAD
01594E  CD 21                 INT    0x21 ; SYS
015950  3C 4E                 CMP    al, 0x4e ; CMP
015952  75 06                 JNE    0x1595a ; CJUMP
015954  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
015957  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
01595A  8A E0                 MOV    ah, al ; MOV
01595C  CD 21                 INT    0x21 ; SYS
01595E  50                    PUSH   ax ; STACK_PUSH
01595F  9F                    LAHF ; FLAG
015960  50                    PUSH   ax ; STACK_PUSH
015961  8C C2                 MOV    dx, es ; MOV
015963  8E DA                 MOV    ds, dx ; MOV
