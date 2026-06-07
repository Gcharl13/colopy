; ============================================================================
; func_030709_unknown
; Region   : load_image
; Bytes    : file 0x030709..0x030793  (138 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030709  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03070D  56                    PUSH   si                           ; UNKNOWN
03070E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
030711  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030714  0E                    PUSH   cs                           ; UNKNOWN
030715  E8 6A FE              CALL   0x30582                      ; UNKNOWN
030718  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03071B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03071E  0B C0                 OR     ax, ax                       ; UNKNOWN
030720  7C 6B                 JL     0x3078d                      ; UNKNOWN
030722  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
030725  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030728  0E                    PUSH   cs                           ; UNKNOWN
030729  E8 A3 FE              CALL   0x305cf                      ; UNKNOWN
03072C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03072F  A3 84 73              MOV    word ptr [0x7384], ax        ; UNKNOWN
030732  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
030735  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
030738  EB 3B                 JMP    0x30775                      ; UNKNOWN
03073A  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03073D  40                    INC    ax                           ; UNKNOWN
03073E  50                    PUSH   ax                           ; UNKNOWN
03073F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030742  8B F0                 MOV    si, ax                       ; UNKNOWN
030744  0E                    PUSH   cs                           ; UNKNOWN
030745  E8 3A FE              CALL   0x30582                      ; UNKNOWN
030748  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03074B  50                    PUSH   ax                           ; UNKNOWN
03074C  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03074F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030752  0E                    PUSH   cs                           ; UNKNOWN
030753  E8 A2 FE              CALL   0x305f8                      ; UNKNOWN
030756  83 C4 06              ADD    sp, 6                        ; UNKNOWN
030759  56                    PUSH   si                           ; UNKNOWN
03075A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03075D  0E                    PUSH   cs                           ; UNKNOWN
03075E  E8 6E FE              CALL   0x305cf                      ; UNKNOWN
030761  83 C4 04              ADD    sp, 4                        ; UNKNOWN
030764  50                    PUSH   ax                           ; UNKNOWN
030765  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
030768  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03076B  0E                    PUSH   cs                           ; UNKNOWN
03076C  E8 74 FE              CALL   0x305e3                      ; UNKNOWN
03076F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
030772  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
030775  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
030779  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
03077D  2A E4                 SUB    ah, ah                       ; UNKNOWN
03077F  48                    DEC    ax                           ; UNKNOWN
030780  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
030783  7F B5                 JG     0x3073a                      ; UNKNOWN
030785  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
030789  FE 8F 8C 88           DEC    byte ptr [bx - 0x7774]       ; UNKNOWN
03078D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
030790  5E                    POP    si                           ; UNKNOWN
030791  C9                    LEAVE                               ; UNKNOWN
030792  CB                    RETF                                ; UNKNOWN
