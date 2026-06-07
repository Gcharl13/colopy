; ============================================================================
; func_03B900_unknown
; Region   : overlay
; Bytes    : file 0x03B900..0x03B921  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B900  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
03B904  8A 4E 08              MOV    cl, byte ptr [bp + 8] ; LOCAL_LOAD
03B907  80 E1 07              AND    cl, 7 ; LOGIC
03B90A  B8 01 00              MOV    ax, 1 ; MOV
03B90D  D3 E0                 SHL    ax, cl ; LOGIC
03B90F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03B912  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
03B915  C1 F9 03              SAR    cx, 3 ; LOGIC
03B918  69 56 06 3C 01        IMUL   dx, word ptr [bp + 6], 0x13c ; ARITH
03B91D  03 CA                 ADD    cx, dx ; ARITH
03B91F  81                    DB     0x81 ; DATA_BYTE
03B920  C1                    DB     0xC1 ; DATA_BYTE
