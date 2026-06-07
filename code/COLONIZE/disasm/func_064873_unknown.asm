; ============================================================================
; func_064873_unknown
; Region   : load_image
; Bytes    : file 0x064873..0x0648AE  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064873  55                    PUSH   bp                           ; UNKNOWN
064874  8B EC                 MOV    bp, sp                       ; UNKNOWN
064876  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
064879  26 80 7F 01 00        CMP    byte ptr es:[bx + 1], 0      ; UNKNOWN
06487E  74 0D                 JE     0x6488d                      ; UNKNOWN
064880  26 FF 77 04           PUSH   word ptr es:[bx + 4]         ; UNKNOWN
064884  26 FF 77 02           PUSH   word ptr es:[bx + 2]         ; UNKNOWN
064888  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
06488D  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
064890  2B C0                 SUB    ax, ax                       ; UNKNOWN
064892  26 89 47 04           MOV    word ptr es:[bx + 4], ax     ; UNKNOWN
064896  26 89 47 02           MOV    word ptr es:[bx + 2], ax     ; UNKNOWN
06489A  26 89 47 10           MOV    word ptr es:[bx + 0x10], ax  ; UNKNOWN
06489E  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax   ; UNKNOWN
0648A2  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax   ; UNKNOWN
0648A6  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax   ; UNKNOWN
0648AA  C9                    LEAVE                               ; UNKNOWN
0648AB  CA 04 00              RETF   4                            ; UNKNOWN
