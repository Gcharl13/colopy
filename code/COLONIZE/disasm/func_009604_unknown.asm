; ============================================================================
; func_009604_unknown
; Region   : load_image
; Bytes    : file 0x009604..0x009618  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009604  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
009608  0B D2                 OR     dx, dx                       ; UNKNOWN
00960A  7F 0C                 JG     0x9618                       ; UNKNOWN
00960C  7C 04                 JL     0x9612                       ; UNKNOWN
00960E  0B C0                 OR     ax, ax                       ; UNKNOWN
009610  75 06                 JNE    0x9618                       ; UNKNOWN
009612  2B C0                 SUB    ax, ax                       ; UNKNOWN
009614  C9                    LEAVE                               ; UNKNOWN
009615  CA 04 00              RETF   4                            ; UNKNOWN
