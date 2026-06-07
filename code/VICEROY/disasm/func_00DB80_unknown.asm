; ============================================================================
; func_00DB80_unknown
; Region   : load_image
; Bytes    : file 0x00DB80..0x00DC62  (226 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DB80  C8 0E 01 00           ENTER  0x10e, 0 ; PROLOGUE
00DB84  52                    PUSH   dx ; STACK_PUSH
00DB85  50                    PUSH   ax ; STACK_PUSH
00DB86  57                    PUSH   di ; STACK_PUSH
00DB87  56                    PUSH   si ; STACK_PUSH
00DB88  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
00DB8B  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
00DB8E  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00DB91  2B C0                 SUB    ax, ax ; ARITH
00DB93  B9 04 00              MOV    cx, 4 ; MOV
00DB96  8D 7E F6              LEA    di, [bp - 0xa] ; ADDR
00DB99  16                    PUSH   ss ; STACK_PUSH
00DB9A  07                    POP    es ; STACK_POP
00DB9B  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
00DB9D  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
00DBA2  8D 86 F2 FE           LEA    ax, [bp - 0x10e] ; ADDR
00DBA6  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
00DBA9  8C 56 F8              MOV    word ptr [bp - 8], ss ; LOCAL_STORE
00DBAC  16                    PUSH   ss ; STACK_PUSH
00DBAD  50                    PUSH   ax ; STACK_PUSH
00DBAE  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
00DBB1  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
00DBB4  B0 FF                 MOV    al, 0xff ; CONST_LOAD
00DBB6  9A 04 00 8D 0B        LCALL  0xb8d, 4 ; LCALL
00DBBB  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00DBBE  83 BE F0 FE 00        CMP    word ptr [bp - 0x110], 0 ; CMP
00DBC3  74 1B                 JE     0xdbe0 ; CJUMP
00DBC5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00DBC8  56                    PUSH   si ; STACK_PUSH
00DBC9  6A 00                 PUSH   0 ; STACK_PUSH
00DBCB  6A 00                 PUSH   0 ; STACK_PUSH
00DBCD  8B 86 EE FE           MOV    ax, word ptr [bp - 0x112] ; LOCAL_LOAD
00DBD1  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
00DBD4  2B D2                 SUB    dx, dx ; ARITH
00DBD6  9A 04 00 D8 0C        LCALL  0xcd8, 4 ; LCALL
00DBDB  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2 ; LOCAL_STORE
00DBE0  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00DBE3  50                    PUSH   ax ; STACK_PUSH
00DBE4  56                    PUSH   si ; STACK_PUSH
00DBE5  6A 00                 PUSH   0 ; STACK_PUSH
00DBE7  8B F8                 MOV    di, ax ; MOV
00DBE9  8B 86 EE FE           MOV    ax, word ptr [bp - 0x112] ; LOCAL_LOAD
00DBED  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
00DBF0  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
00DBF3  9A 0A 00 36 0C        LCALL  0xc36, 0xa ; LCALL
00DBF8  8B 86 EE FE           MOV    ax, word ptr [bp - 0x112] ; LOCAL_LOAD
00DBFC  8B C8                 MOV    cx, ax ; MOV
00DBFE  D1 E0                 SHL    ax, 1 ; LOGIC
00DC00  03 C1                 ADD    ax, cx ; ARITH
00DC02  C1 E0 02              SHL    ax, 2 ; LOGIC
00DC05  8E C7                 MOV    es, di ; MOV
00DC07  03 F0                 ADD    si, ax ; ARITH
00DC09  26 8B 44 3E           MOV    ax, word ptr es:[si + 0x3e] ; MOV
00DC0D  D1 F8                 SAR    ax, 1 ; LOGIC
00DC0F  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00DC12  26 8B 4C 40           MOV    cx, word ptr es:[si + 0x40] ; MOV
00DC16  D1 F9                 SAR    cx, 1 ; LOGIC
00DC18  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
00DC1B  3B 06 2C 26           CMP    ax, word ptr [0x262c] ; CMP
00DC1F  75 41                 JNE    0xdc62 ; CJUMP
00DC21  8B C1                 MOV    ax, cx ; MOV
00DC23  39 06 2E 26           CMP    word ptr [0x262e], ax ; CMP
00DC27  75 39                 JNE    0xdc62 ; CJUMP
00DC29  9A CE 03 58 0A        LCALL  0xa58, 0x3ce ; LCALL
00DC2E  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
00DC31  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
00DC34  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
00DC37  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
00DC3A  FF 36 06 93           PUSH   word ptr [0x9306] ; PUSH_GLOBAL
00DC3E  FF 36 04 93           PUSH   word ptr [0x9304] ; PUSH_GLOBAL
00DC42  FF 36 02 93           PUSH   word ptr [0x9302] ; PUSH_GLOBAL
00DC46  FF 36 00 93           PUSH   word ptr [0x9300] ; PUSH_GLOBAL
00DC4A  6A 10                 PUSH   0x10 ; PUSH_CONST
00DC4C  2B C0                 SUB    ax, ax ; ARITH
00DC4E  99                    CDQ ; ARITH
00DC4F  BB 10 00              MOV    bx, 0x10 ; CONST_LOAD
00DC52  9A 06 00 8F 0B        LCALL  0xb8f, 6 ; LCALL
00DC57  9A E2 03 58 0A        LCALL  0xa58, 0x3e2 ; LCALL
00DC5C  5E                    POP    si ; STACK_POP
00DC5D  5F                    POP    di ; STACK_POP
00DC5E  C9                    LEAVE ; EPILOGUE
00DC5F  CA 04 00              RETF   4 ; RETURN
