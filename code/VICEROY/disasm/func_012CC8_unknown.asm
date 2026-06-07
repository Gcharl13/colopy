; ============================================================================
; func_012CC8_unknown
; Region   : load_image
; Bytes    : file 0x012CC8..0x012D4A  (130 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012CC8  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
012CCC  C7 06 E4 26 00 00     MOV    word ptr [0x26e4], 0 ; GLOBAL_LOAD
012CD2  83 3E E6 26 00        CMP    word ptr [0x26e6], 0 ; CMP
012CD7  75 2A                 JNE    0x12d03 ; CJUMP
012CD9  B8 00 43              MOV    ax, 0x4300 ; CONST_LOAD
012CDC  CD 2F                 INT    0x2f ; SYS
012CDE  3C 80                 CMP    al, 0x80 ; CMP
012CE0  75 21                 JNE    0x12d03 ; CJUMP
012CE2  B8 10 43              MOV    ax, 0x4310 ; CONST_LOAD
012CE5  CD 2F                 INT    0x2f ; SYS
012CE7  89 1E E8 26           MOV    word ptr [0x26e8], bx ; GLOBAL_LOAD
012CEB  8C 06 EA 26           MOV    word ptr [0x26ea], es ; GLOBAL_LOAD
012CEF  32 E4                 XOR    ah, ah ; LOGIC
012CF1  FF 1E E8 26           LCALL  [0x26e8] ; LCALL
012CF5  A3 68 A6              MOV    word ptr [0xa668], ax ; GLOBAL_LOAD
012CF8  3D 00 02              CMP    ax, 0x200 ; CMP
012CFB  72 06                 JB     0x12d03 ; CJUMP
012CFD  C7 06 E4 26 FF FF     MOV    word ptr [0x26e4], 0xffff ; GLOBAL_LOAD
012D03  C7 06 66 26 FF FF     MOV    word ptr [0x2666], 0xffff ; GLOBAL_LOAD
012D09  C7 06 68 26 FF FF     MOV    word ptr [0x2668], 0xffff ; GLOBAL_LOAD
012D0F  C6 06 4E 26 00        MOV    byte ptr [0x264e], 0 ; GLOBAL_LOAD
012D14  83 3E E4 26 00        CMP    word ptr [0x26e4], 0 ; CMP
012D19  74 2A                 JE     0x12d45 ; CJUMP
012D1B  6A 00                 PUSH   0 ; STACK_PUSH
012D1D  6A 01                 PUSH   1 ; STACK_PUSH
012D1F  9A 0A 00 03 11        LCALL  0x1103, 0xa ; LCALL
012D24  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
012D27  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
012D2A  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
012D2D  0B D0                 OR     dx, ax ; LOGIC
012D2F  74 14                 JE     0x12d45 ; CJUMP
012D31  C4 46 FC              LES    ax, ptr [bp - 4] ; MOV_FAR
012D34  8C C0                 MOV    ax, es ; MOV
012D36  48                    DEC    ax ; ARITH
012D37  A3 EC 26              MOV    word ptr [0x26ec], ax ; GLOBAL_LOAD
012D3A  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
012D3D  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
012D40  9A 4C 00 03 11        LCALL  0x1103, 0x4c ; LCALL
012D45  A1 E4 26              MOV    ax, word ptr [0x26e4] ; GLOBAL_LOAD
012D48  C9                    LEAVE ; EPILOGUE
012D49  CB                    RETF ; RETURN
