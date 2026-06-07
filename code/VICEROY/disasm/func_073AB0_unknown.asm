; ============================================================================
; func_073AB0_unknown
; Region   : overlay
; Bytes    : file 0x073AB0..0x073AD9  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

073AB0  C8 5A 00 00           ENTER  0x5a, 0 ; PROLOGUE
073AB4  57                    PUSH   di ; STACK_PUSH
073AB5  56                    PUSH   si ; STACK_PUSH
073AB6  BE 01 00              MOV    si, 1 ; MOV
073AB9  83 3E 5A 01 00        CMP    word ptr [0x15a], 0 ; CMP
073ABE  74 03                 JE     0x73ac3 ; CJUMP
073AC0  BE 05 00              MOV    si, 5 ; MOV
073AC3  68 83 21              PUSH   0x2183 ; PUSH_CONST
073AC6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
073AC9  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
073ACE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
073AD1  8B F8                 MOV    di, ax ; MOV
073AD3  0B FF                 OR     di, di ; LOGIC
073AD5  75 03                 JNE    0x73ada ; CJUMP
073AD7  E9                    DB     0xE9 ; DATA_BYTE
073AD8  C3                    DB     0xC3 ; DATA_BYTE
