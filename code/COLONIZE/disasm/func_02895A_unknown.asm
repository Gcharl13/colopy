; ============================================================================
; func_02895A_unknown
; Region   : load_image
; Bytes    : file 0x02895A..0x02899D  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02895A  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02895E  57                    PUSH   di                           ; UNKNOWN
02895F  56                    PUSH   si                           ; UNKNOWN
028960  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
028965  EB 1B                 JMP    0x28982                      ; UNKNOWN
028967  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02896A  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
02896D  7E 10                 JLE    0x2897f                      ; UNKNOWN
02896F  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
028972  48                    DEC    ax                           ; UNKNOWN
028973  50                    PUSH   ax                           ; UNKNOWN
028974  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
028977  9A 83 0F B7 36        LCALL  0x36b7, 0xf83                ; UNKNOWN
02897C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02897F  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
028982  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
028985  39 06 14 3E           CMP    word ptr [0x3e14], ax        ; UNKNOWN
028989  7E 66                 JLE    0x289f1                      ; UNKNOWN
02898B  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
02898E  8A 8F 83 88           MOV    cl, byte ptr [bx - 0x777d]   ; UNKNOWN
028992  80 E1 0F              AND    cl, 0xf                      ; UNKNOWN
028995  3A 0E 0C 3E           CMP    cl, byte ptr [0x3e0c]        ; UNKNOWN
028999  75 E4                 JNE    0x2897f                      ; UNKNOWN
02899B  8B CB                 MOV    cx, bx                       ; UNKNOWN
