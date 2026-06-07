; ============================================================================
; func_03342C_unknown
; Region   : overlay
; Bytes    : file 0x03342C..0x03347B  (79 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03342C  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
033430  56                    PUSH   si ; STACK_PUSH
033431  C7 46 EE FF FF        MOV    word ptr [bp - 0x12], 0xffff ; LOCAL_STORE
033436  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
03343B  EB 4F                 JMP    0x3348c ; JUMP
03343D  90                    NOP ; NOP
03343E  A1 A2 0F              MOV    ax, word ptr [0xfa2] ; GLOBAL_LOAD
033441  39 46 F4              CMP    word ptr [bp - 0xc], ax ; CMP
033444  7D 4C                 JGE    0x33492 ; CJUMP
033446  8D 46 F0              LEA    ax, [bp - 0x10] ; ADDR
033449  50                    PUSH   ax ; STACK_PUSH
03344A  8D 4E F2              LEA    cx, [bp - 0xe] ; ADDR
03344D  51                    PUSH   cx ; STACK_PUSH
03344E  8D 56 F6              LEA    dx, [bp - 0xa] ; ADDR
033451  52                    PUSH   dx ; STACK_PUSH
033452  8D 5E FA              LEA    bx, [bp - 6] ; ADDR
033455  53                    PUSH   bx ; STACK_PUSH
033456  8D 76 F8              LEA    si, [bp - 8] ; ADDR
033459  56                    PUSH   si ; STACK_PUSH
03345A  6A 02                 PUSH   2 ; STACK_PUSH
03345C  6A 05                 PUSH   5 ; STACK_PUSH
03345E  68 92 00              PUSH   0x92 ; PUSH_CONST
033461  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
033464  0E                    PUSH   cs ; STACK_PUSH
033465  E8 37 34              CALL   0x3689f ; CALL_NEAR
033468  83 C4 12              ADD    sp, 0x12 ; STACK_CLEANUP
03346B  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
03346E  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
033471  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
033474  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
033477  9A                    DB     0x9A ; DATA_BYTE
033478  CA                    DB     0xCA ; DATA_BYTE
033479  03                    DB     0x03 ; DATA_BYTE
03347A  1F                    DB     0x1F ; DATA_BYTE
