; ============================================================================
; func_014C78_unknown
; Region   : load_image
; Bytes    : file 0x014C78..0x014CC5  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

014C78  55                    PUSH   bp ; STACK_PUSH
014C79  8B EC                 MOV    bp, sp ; MOV
014C7B  56                    PUSH   si ; STACK_PUSH
014C7C  83 3E 92 52 00        CMP    word ptr [0x5292], 0 ; CMP
014C81  7C 21                 JL     0x14ca4 ; CJUMP
014C83  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
014C86  26 8B 07              MOV    ax, word ptr es:[bx] ; MOV
014C89  2B D2                 SUB    dx, dx ; ARITH
014C8B  3B 16 92 52           CMP    dx, word ptr [0x5292] ; CMP
014C8F  7C 0F                 JL     0x14ca0 ; CJUMP
014C91  7F 06                 JG     0x14c99 ; CJUMP
014C93  3B 06 90 52           CMP    ax, word ptr [0x5290] ; CMP
014C97  76 07                 JBE    0x14ca0 ; CJUMP
014C99  8B 16 92 52           MOV    dx, word ptr [0x5292] ; GLOBAL_LOAD
014C9D  A1 90 52              MOV    ax, word ptr [0x5290] ; GLOBAL_LOAD
014CA0  8B F0                 MOV    si, ax ; MOV
014CA2  EB 06                 JMP    0x14caa ; JUMP
014CA4  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
014CA7  26 8B 37              MOV    si, word ptr es:[bx] ; MOV
014CAA  0B F6                 OR     si, si ; LOGIC
014CAC  74 3C                 JE     0x14cea ; CJUMP
014CAE  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
014CB1  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
014CB4  6A 00                 PUSH   0 ; STACK_PUSH
014CB6  56                    PUSH   si ; STACK_PUSH
014CB7  B8 01 00              MOV    ax, 1 ; MOV
014CBA  99                    CDQ ; ARITH
014CBB  8B 1E 7C 4E           MOV    bx, word ptr [0x4e7c] ; GLOBAL_LOAD
014CBF  9A 00 00 CA 0B        LCALL  0xbca, 0 ; LCALL
014CC4  8B                    DB     0x8B ; DATA_BYTE
