; ============================================================================
; func_02195E_unknown
; Region   : load_image
; Bytes    : file 0x02195E..0x021989  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02195E  C8 20 00 00           ENTER  0x20, 0                      ; UNKNOWN
021962  57                    PUSH   di                           ; UNKNOWN
021963  56                    PUSH   si                           ; UNKNOWN
021964  2B C0                 SUB    ax, ax                       ; UNKNOWN
021966  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
021969  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
02196C  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02196F  83 C0 4E              ADD    ax, 0x4e                     ; UNKNOWN
021972  99                    CDQ                                 ; UNKNOWN
021973  9A FC 00 4F 00        LCALL  0x4f, 0xfc                   ; UNKNOWN
021978  8B F8                 MOV    di, ax                       ; UNKNOWN
02197A  89 56 F2              MOV    word ptr [bp - 0xe], dx      ; UNKNOWN
02197D  0B D0                 OR     dx, ax                       ; UNKNOWN
02197F  75 03                 JNE    0x21984                      ; UNKNOWN
021981  E9 FD 00              JMP    0x21a81                      ; UNKNOWN
021984  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
021987  8B CF                 MOV    cx, di                       ; UNKNOWN
