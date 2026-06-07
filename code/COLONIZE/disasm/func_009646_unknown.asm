; ============================================================================
; func_009646_unknown
; Region   : load_image
; Bytes    : file 0x009646..0x009653  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009646  55                    PUSH   bp                           ; UNKNOWN
009647  8B EC                 MOV    bp, sp                       ; UNKNOWN
009649  B4 52                 MOV    ah, 0x52                     ; UNKNOWN
00964B  CD 21                 INT    0x21                         ; UNKNOWN
00964D  26 8B 47 FE           MOV    ax, word ptr es:[bx - 2]     ; UNKNOWN
009651  C9                    LEAVE                               ; UNKNOWN
009652  C3                    RET                                 ; UNKNOWN
