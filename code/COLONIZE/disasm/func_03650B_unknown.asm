; ============================================================================
; func_03650B_unknown
; Region   : load_image
; Bytes    : file 0x03650B..0x036520  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03650B  C8 6C 00 00           ENTER  0x6c, 0                      ; UNKNOWN
03650F  2B C0                 SUB    ax, ax                       ; UNKNOWN
036511  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
036514  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
036517  FF 36 AC 79           PUSH   word ptr [0x79ac]            ; UNKNOWN
03651B  0E                    PUSH   cs                           ; UNKNOWN
03651C  E8 C2 CF              CALL   0x334e1                      ; UNKNOWN
03651F  83                    DB     0x83                         ; UNKNOWN (raw)
