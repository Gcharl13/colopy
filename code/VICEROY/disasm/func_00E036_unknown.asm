; ============================================================================
; func_00E036_unknown
; Region   : load_image
; Bytes    : file 0x00E036..0x00E04E  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E036  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00E03A  53                    PUSH   bx ; STACK_PUSH
00E03B  52                    PUSH   dx ; STACK_PUSH
00E03C  50                    PUSH   ax ; STACK_PUSH
00E03D  57                    PUSH   di ; STACK_PUSH
00E03E  0B C0                 OR     ax, ax ; LOGIC
00E040  7C 5A                 JL     0xe09c ; CJUMP
00E042  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00E045  39 46 F4              CMP    word ptr [bp - 0xc], ax ; CMP
00E048  7D 52                 JGE    0xe09c ; CJUMP
00E04A  8B C2                 MOV    ax, dx ; MOV
00E04C  0B C0                 OR     ax, ax ; LOGIC
