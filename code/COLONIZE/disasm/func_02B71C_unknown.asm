; ============================================================================
; func_02B71C_unknown
; Region   : load_image
; Bytes    : file 0x02B71C..0x02B743  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B71C  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02B720  57                    PUSH   di                           ; UNKNOWN
02B721  56                    PUSH   si                           ; UNKNOWN
02B722  BE 01 00              MOV    si, 1                        ; UNKNOWN
02B725  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
02B729  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
02B72D  68 A0 0F              PUSH   0xfa0                        ; UNKNOWN
02B730  9A EE 02 67 18        LCALL  0x1867, 0x2ee                ; UNKNOWN
02B735  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B738  A3 AC 09              MOV    word ptr [0x9ac], ax         ; UNKNOWN
02B73B  89 16 AE 09           MOV    word ptr [0x9ae], dx         ; UNKNOWN
02B73F  8B C2                 MOV    ax, dx                       ; UNKNOWN
02B741  0B                    DB     0x0B                         ; UNKNOWN (raw)
02B742  06                    DB     0x06                         ; UNKNOWN (raw)
