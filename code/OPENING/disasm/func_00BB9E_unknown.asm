; ============================================================================
; func_00BB9E_unknown
; Region   : load_image
; Bytes    : file 0x00BB9E..0x00BBBA  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BB9E  55                    PUSH   bp ; STACK_PUSH
00BB9F  8B EC                 MOV    bp, sp ; MOV
00BBA1  57                    PUSH   di ; STACK_PUSH
00BBA2  56                    PUSH   si ; STACK_PUSH
00BBA3  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00BBA6  26 8B 0D              MOV    cx, word ptr es:[di] ; MOV
00BBA9  A1 9C 4E              MOV    ax, word ptr [0x4e9c] ; GLOBAL_LOAD
00BBAC  8B 16 9E 4E           MOV    dx, word ptr [0x4e9e] ; GLOBAL_LOAD
00BBB0  83 FA FF              CMP    dx, -1 ; CMP
00BBB3  74 1C                 JE     0xbbd1 ; CJUMP
00BBB5  50                    PUSH   ax ; STACK_PUSH
00BBB6  0B C2                 OR     ax, dx ; LOGIC
00BBB8  58                    POP    ax ; STACK_POP
00BBB9  74                    DB     0x74 ; DATA_BYTE
