; ============================================================================
; func_015544_unknown
; Region   : load_image
; Bytes    : file 0x015544..0x01559B  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015544  C8 E4 00 00           ENTER  0xe4, 0                      ; UNKNOWN
015548  56                    PUSH   si                           ; UNKNOWN
015549  0E                    PUSH   cs                           ; UNKNOWN
01554A  E8 BB FB              CALL   0x15108                      ; UNKNOWN
01554D  6A 00                 PUSH   0                            ; UNKNOWN
01554F  A1 8E 82              MOV    ax, word ptr [0x828e]        ; UNKNOWN
015552  8B 16 8C 82           MOV    dx, word ptr [0x828c]        ; UNKNOWN
015556  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
01555B  89 86 58 FF           MOV    word ptr [bp - 0xa8], ax     ; UNKNOWN
01555F  50                    PUSH   ax                           ; UNKNOWN
015560  9A D3 04 B7 36        LCALL  0x36b7, 0x4d3                ; UNKNOWN
015565  83 C4 04              ADD    sp, 4                        ; UNKNOWN
015568  8B 86 58 FF           MOV    ax, word ptr [bp - 0xa8]     ; UNKNOWN
01556C  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
015571  89 86 58 FF           MOV    word ptr [bp - 0xa8], ax     ; UNKNOWN
015575  83 3E 0E 3E 04        CMP    word ptr [0x3e0e], 4         ; UNKNOWN
01557A  7D 2E                 JGE    0x155aa                      ; UNKNOWN
01557C  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
015580  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
015584  9A E8 02 C9 33        LCALL  0x33c9, 0x2e8                ; UNKNOWN
015589  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01558C  2A E4                 SUB    ah, ah                       ; UNKNOWN
01558E  8A 0E 0E 3E           MOV    cl, byte ptr [0x3e0e]        ; UNKNOWN
015592  BA 10 00              MOV    dx, 0x10                     ; UNKNOWN
015595  D3 E2                 SHL    dx, cl                       ; UNKNOWN
015597  85 C2                 TEST   dx, ax                       ; UNKNOWN
015599  75 0F                 JNE    0x155aa                      ; UNKNOWN
