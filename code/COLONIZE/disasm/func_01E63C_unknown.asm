; ============================================================================
; func_01E63C_unknown
; Region   : load_image
; Bytes    : file 0x01E63C..0x01E6B9  (125 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E63C  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
01E640  57                    PUSH   di                           ; UNKNOWN
01E641  56                    PUSH   si                           ; UNKNOWN
01E642  2B C0                 SUB    ax, ax                       ; UNKNOWN
01E644  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01E647  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01E64A  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01E64D  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01E650  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
01E653  EB 3E                 JMP    0x1e693                      ; UNKNOWN
01E655  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
01E658  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
01E65D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01E660  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
01E663  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01E667  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
01E66A  75 24                 JNE    0x1e690                      ; UNKNOWN
01E66C  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
01E66F  98                    CWDE                                ; UNKNOWN
01E670  99                    CDQ                                 ; UNKNOWN
01E671  01 46 F6              ADD    word ptr [bp - 0xa], ax      ; UNKNOWN
01E674  11 56 F8              ADC    word ptr [bp - 8], dx        ; UNKNOWN
01E677  8B F0                 MOV    si, ax                       ; UNKNOWN
01E679  8B FA                 MOV    di, dx                       ; UNKNOWN
01E67B  9A 71 02 5F 24        LCALL  0x245f, 0x271                ; UNKNOWN
01E680  99                    CDQ                                 ; UNKNOWN
01E681  52                    PUSH   dx                           ; UNKNOWN
01E682  50                    PUSH   ax                           ; UNKNOWN
01E683  57                    PUSH   di                           ; UNKNOWN
01E684  56                    PUSH   si                           ; UNKNOWN
01E685  9A 6C 12 65 5F        LCALL  0x5f65, 0x126c               ; UNKNOWN
01E68A  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
01E68D  11 56 FE              ADC    word ptr [bp - 2], dx        ; UNKNOWN
01E690  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
01E693  A1 16 3E              MOV    ax, word ptr [0x3e16]        ; UNKNOWN
01E696  39 46 FA              CMP    word ptr [bp - 6], ax        ; UNKNOWN
01E699  7C BA                 JL     0x1e655                      ; UNKNOWN
01E69B  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
01E69E  0B 46 F6              OR     ax, word ptr [bp - 0xa]      ; UNKNOWN
01E6A1  74 0F                 JE     0x1e6b2                      ; UNKNOWN
01E6A3  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
01E6A6  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01E6A9  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
01E6AC  50                    PUSH   ax                           ; UNKNOWN
01E6AD  9A 9E 12 65 5F        LCALL  0x5f65, 0x129e               ; UNKNOWN
01E6B2  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
01E6B5  5E                    POP    si                           ; UNKNOWN
01E6B6  5F                    POP    di                           ; UNKNOWN
01E6B7  C9                    LEAVE                               ; UNKNOWN
01E6B8  CB                    RETF                                ; UNKNOWN
