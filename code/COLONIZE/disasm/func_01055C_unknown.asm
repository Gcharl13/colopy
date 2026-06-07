; ============================================================================
; func_01055C_unknown
; Region   : load_image
; Bytes    : file 0x01055C..0x010594  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01055C  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
010560  56                    PUSH   si                           ; UNKNOWN
010561  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12  ; UNKNOWN
010565  8A 87 DE 79           MOV    al, byte ptr [bx + 0x79de]   ; UNKNOWN
010569  2A E4                 SUB    ah, ah                       ; UNKNOWN
01056B  83 E8 04              SUB    ax, 4                        ; UNKNOWN
01056E  6B F0 4E              IMUL   si, ax, 0x4e                 ; UNKNOWN
010571  8A 84 C6 7F           MOV    al, byte ptr [si + 0x7fc6]   ; UNKNOWN
010575  2A E4                 SUB    ah, ah                       ; UNKNOWN
010577  8B C8                 MOV    cx, ax                       ; UNKNOWN
010579  D1 E0                 SHL    ax, 1                        ; UNKNOWN
01057B  83 C0 03              ADD    ax, 3                        ; UNKNOWN
01057E  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
010581  F6 87 DF 79 04        TEST   byte ptr [bx + 0x79df], 4    ; UNKNOWN
010586  74 06                 JE     0x1058e                      ; UNKNOWN
010588  03 C8                 ADD    cx, ax                       ; UNKNOWN
01058A  41                    INC    cx                           ; UNKNOWN
01058B  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
01058E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
010591  5E                    POP    si                           ; UNKNOWN
010592  C9                    LEAVE                               ; UNKNOWN
010593  CB                    RETF                                ; UNKNOWN
