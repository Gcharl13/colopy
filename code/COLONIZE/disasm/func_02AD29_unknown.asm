; ============================================================================
; func_02AD29_unknown
; Region   : load_image
; Bytes    : file 0x02AD29..0x02AD48  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AD29  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02AD2D  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02AD32  B8 80 38              MOV    ax, 0x3880                   ; UNKNOWN
02AD35  BA 01 00              MOV    dx, 1                        ; UNKNOWN
02AD38  9A FC 00 4F 00        LCALL  0x4f, 0xfc                   ; UNKNOWN
02AD3D  A3 26 0A              MOV    word ptr [0xa26], ax         ; UNKNOWN
02AD40  89 16 28 0A           MOV    word ptr [0xa28], dx         ; UNKNOWN
02AD44  8B C2                 MOV    ax, dx                       ; UNKNOWN
02AD46  0B                    DB     0x0B                         ; UNKNOWN (raw)
02AD47  06                    DB     0x06                         ; UNKNOWN (raw)
