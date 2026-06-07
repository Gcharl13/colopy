; ============================================================================
; func_062E7A_unknown
; Region   : load_image
; Bytes    : file 0x062E7A..0x062ECF  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

062E7A  C8 74 00 00           ENTER  0x74, 0                      ; UNKNOWN
062E7E  56                    PUSH   si                           ; UNKNOWN
062E7F  C7 46 98 01 00        MOV    word ptr [bp - 0x68], 1      ; UNKNOWN
062E84  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
062E88  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
062E8C  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
062E8F  89 46 8C              MOV    word ptr [bp - 0x74], ax     ; UNKNOWN
062E92  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
062E96  8A 4F 1A              MOV    cl, byte ptr [bx + 0x1a]     ; UNKNOWN
062E99  2A ED                 SUB    ch, ch                       ; UNKNOWN
062E9B  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
062E9E  83 F8 04              CMP    ax, 4                        ; UNKNOWN
062EA1  7C 03                 JL     0x62ea6                      ; UNKNOWN
062EA3  E9 1B 04              JMP    0x632c1                      ; UNKNOWN
062EA6  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
062EA9  38 AF B7 C0           CMP    byte ptr [bx - 0x3f49], ch   ; UNKNOWN
062EAD  74 03                 JE     0x62eb2                      ; UNKNOWN
062EAF  E9 0F 04              JMP    0x632c1                      ; UNKNOWN
062EB2  51                    PUSH   cx                           ; UNKNOWN
062EB3  50                    PUSH   ax                           ; UNKNOWN
062EB4  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
062EB9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
062EBC  A8 40                 TEST   al, 0x40                     ; UNKNOWN
062EBE  75 0F                 JNE    0x62ecf                      ; UNKNOWN
062EC0  8D 1E 2A 30           LEA    bx, [0x302a]                 ; UNKNOWN
062EC4  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
062EC9  8B 46 98              MOV    ax, word ptr [bp - 0x68]     ; UNKNOWN
062ECC  5E                    POP    si                           ; UNKNOWN
062ECD  C9                    LEAVE                               ; UNKNOWN
062ECE  CB                    RETF                                ; UNKNOWN
