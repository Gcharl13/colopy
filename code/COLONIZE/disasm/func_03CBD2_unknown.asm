; ============================================================================
; func_03CBD2_unknown
; Region   : load_image
; Bytes    : file 0x03CBD2..0x03CBF4  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CBD2  55                    PUSH   bp                           ; UNKNOWN
03CBD3  8B EC                 MOV    bp, sp                       ; UNKNOWN
03CBD5  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03CBD8  A3 36 82              MOV    word ptr [0x8236], ax        ; UNKNOWN
03CBDB  0B C0                 OR     ax, ax                       ; UNKNOWN
03CBDD  7C 28                 JL     0x3cc07                      ; UNKNOWN
03CBDF  0B C0                 OR     ax, ax                       ; UNKNOWN
03CBE1  7C 06                 JL     0x3cbe9                      ; UNKNOWN
03CBE3  39 06 12 3E           CMP    word ptr [0x3e12], ax        ; UNKNOWN
03CBE7  7F 05                 JG     0x3cbee                      ; UNKNOWN
03CBE9  C7 46 06 00 00        MOV    word ptr [bp + 6], 0         ; UNKNOWN
03CBEE  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12  ; UNKNOWN
03CBF2  81                    DB     0x81                         ; UNKNOWN (raw)
03CBF3  C3                    DB     0xC3                         ; UNKNOWN (raw)
