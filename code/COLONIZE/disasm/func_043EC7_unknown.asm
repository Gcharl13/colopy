; ============================================================================
; func_043EC7_unknown
; Region   : load_image
; Bytes    : file 0x043EC7..0x043F08  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043EC7  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
043ECB  8B 0E 24 0B           MOV    cx, word ptr [0xb24]         ; UNKNOWN
043ECF  8B 16 26 0B           MOV    dx, word ptr [0xb26]         ; UNKNOWN
043ED3  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
043ED6  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
043ED9  83 3E 36 0B 64        CMP    word ptr [0xb36], 0x64       ; UNKNOWN
043EDE  7C 28                 JL     0x43f08                      ; UNKNOWN
043EE0  52                    PUSH   dx                           ; UNKNOWN
043EE1  51                    PUSH   cx                           ; UNKNOWN
043EE2  8A 0E B3 0B           MOV    cl, byte ptr [0xbb3]         ; UNKNOWN
043EE6  2A ED                 SUB    ch, ch                       ; UNKNOWN
043EE8  03 0E B0 C1           ADD    cx, word ptr [0xc1b0]        ; UNKNOWN
043EEC  83 E9 0F              SUB    cx, 0xf                      ; UNKNOWN
043EEF  51                    PUSH   cx                           ; UNKNOWN
043EF0  8A 16 B2 0B           MOV    dl, byte ptr [0xbb2]         ; UNKNOWN
043EF4  2A F6                 SUB    dh, dh                       ; UNKNOWN
043EF6  03 16 AE C1           ADD    dx, word ptr [0xc1ae]        ; UNKNOWN
043EFA  83 EA 08              SUB    dx, 8                        ; UNKNOWN
043EFD  8D 1E 8A CE           LEA    bx, [0xce8a]                 ; UNKNOWN
043F01  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
043F06  C9                    LEAVE                               ; UNKNOWN
043F07  C3                    RET                                 ; UNKNOWN
