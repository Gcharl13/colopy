; ============================================================================
; func_00DDEA_unknown
; Region   : load_image
; Bytes    : file 0x00DDEA..0x00DE6E  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DDEA  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
00DDEE  53                    PUSH   bx ; STACK_PUSH
00DDEF  52                    PUSH   dx ; STACK_PUSH
00DDF0  50                    PUSH   ax ; STACK_PUSH
00DDF1  57                    PUSH   di ; STACK_PUSH
00DDF2  56                    PUSH   si ; STACK_PUSH
00DDF3  8D 46 F6              LEA    ax, [bp - 0xa] ; ADDR
00DDF6  50                    PUSH   ax ; STACK_PUSH
00DDF7  8D 46 08              LEA    ax, [bp + 8] ; ADDR
00DDFA  50                    PUSH   ax ; STACK_PUSH
00DDFB  8D 5E 0A              LEA    bx, [bp + 0xa] ; ADDR
00DDFE  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
00DE01  8D 56 F4              LEA    dx, [bp - 0xc] ; ADDR
00DE04  9A 1C 00 4E 0A        LCALL  0xa4e, 0x1c ; LCALL
00DE09  0B C0                 OR     ax, ax ; LOGIC
00DE0B  74 03                 JE     0xde10 ; CJUMP
00DE0D  E9 8D 00              JMP    0xde9d ; JUMP
00DE10  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00DE13  2B 46 F6              SUB    ax, word ptr [bp - 0xa] ; ARITH
00DE16  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00DE19  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
00DE1C  0B 46 0E              OR     ax, word ptr [bp + 0xe] ; LOGIC
00DE1F  74 05                 JE     0xde26 ; CJUMP
00DE21  B8 01 00              MOV    ax, 1 ; MOV
00DE24  EB 02                 JMP    0xde28 ; JUMP
00DE26  2B C0                 SUB    ax, ax ; ARITH
00DE28  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00DE2B  0B C0                 OR     ax, ax ; LOGIC
00DE2D  74 6E                 JE     0xde9d ; CJUMP
00DE2F  8D 5E 0A              LEA    bx, [bp + 0xa] ; ADDR
00DE32  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
00DE35  8B 56 F4              MOV    dx, word ptr [bp - 0xc] ; LOCAL_LOAD
00DE38  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
00DE3D  52                    PUSH   dx ; STACK_PUSH
00DE3E  50                    PUSH   ax ; STACK_PUSH
00DE3F  9A 04 00 05 0C        LCALL  0xc05, 4 ; LCALL
00DE44  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00DE47  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
00DE4A  C4 7E FA              LES    di, ptr [bp - 6] ; MOV_FAR
00DE4D  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
00DE50  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
00DE53  0B F6                 OR     si, si ; LOGIC
00DE55  75 03                 JNE    0xde5a ; CJUMP
00DE57  EB 44                 JMP    0xde9d ; JUMP
00DE59  90                    NOP ; NOP
00DE5A  8B 56 F6              MOV    dx, word ptr [bp - 0xa] ; LOCAL_LOAD
00DE5D  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00DE60  8A E0                 MOV    ah, al ; MOV
00DE62  D1 EA                 SHR    dx, 1 ; LOGIC
00DE64  73 1E                 JAE    0xde84 ; CJUMP
00DE66  0B D2                 OR     dx, dx ; LOGIC
00DE68  74 04                 JE     0xde6e ; CJUMP
00DE6A  8B CA                 MOV    cx, dx ; MOV
00DE6C  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
