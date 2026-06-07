; ============================================================================
; func_048B98_unknown
; Region   : load_image
; Bytes    : file 0x048B98..0x048BBE  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048B98  C8 1C 00 00           ENTER  0x1c, 0                      ; UNKNOWN
048B9C  57                    PUSH   di                           ; UNKNOWN
048B9D  56                    PUSH   si                           ; UNKNOWN
048B9E  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
048BA3  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
048BA8  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
048BAB  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
048BAE  E9 CD 00              JMP    0x48c7e                      ; UNKNOWN
048BB1  A1 3E C6              MOV    ax, word ptr [0xc63e]        ; UNKNOWN
048BB4  48                    DEC    ax                           ; UNKNOWN
048BB5  3B 46 F4              CMP    ax, word ptr [bp - 0xc]      ; UNKNOWN
048BB8  7F 03                 JG     0x48bbd                      ; UNKNOWN
048BBA  E9 CA 00              JMP    0x48c87                      ; UNKNOWN
048BBD  8B                    DB     0x8B                         ; UNKNOWN (raw)
