; ============================================================================
; func_026BCC_unknown
; Region   : overlay
; Bytes    : file 0x026BCC..0x026C34  (104 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026BCC  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
026BD0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
026BD3  9A 82 0B 1F 18        LCALL  0x181f, 0xb82 ; THUNK -> 0x05EB:0x1376 (thunk @file 0x01B172 type B) overlay @file 0x028366
026BD8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026BDB  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
026BDE  8D 46 08              LEA    ax, [bp + 8] ; ADDR
026BE1  50                    PUSH   ax ; STACK_PUSH
026BE2  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
026BE5  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
026BE8  8A 87 48 02           MOV    al, byte ptr [bx + 0x248] ; MOV
026BEC  98                    CWDE ; ARITH
026BED  50                    PUSH   ax ; STACK_PUSH
026BEE  50                    PUSH   ax ; STACK_PUSH
026BEF  8D 46 FC              LEA    ax, [bp - 4] ; ADDR
026BF2  50                    PUSH   ax ; STACK_PUSH
026BF3  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
026BF6  50                    PUSH   ax ; STACK_PUSH
026BF7  6A 02                 PUSH   2 ; STACK_PUSH
026BF9  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
026BFC  05 52 00              ADD    ax, 0x52 ; ARITH
026BFF  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
026C02  8B DA                 MOV    bx, dx ; MOV
026C04  9A 40 02 1F 18        LCALL  0x181f, 0x240 ; THUNK -> 0x0097:0x0004 (thunk @file 0x01A830 type B) overlay @file 0x0270D0
026C09  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
026C0C  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
026C11  EB 5A                 JMP    0x26c6d ; JUMP
026C13  90                    NOP ; NOP
026C14  A1 7C 8D              MOV    ax, word ptr [0x8d7c] ; GLOBAL_LOAD
026C17  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
026C1A  39 46 F6              CMP    word ptr [bp - 0xa], ax ; CMP
026C1D  75 45                 JNE    0x26c64 ; CJUMP
026C1F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
026C23  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
026C27  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
026C2B  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
026C2F  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
026C32  8B C3                 MOV    ax, bx ; MOV
