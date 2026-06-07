; ============================================================================
; func_01CCB3_unknown
; Region   : load_image
; Bytes    : file 0x01CCB3..0x01CCDF  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01CCB3  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
01CCB7  A1 08 09              MOV    ax, word ptr [0x908]         ; UNKNOWN
01CCBA  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01CCBD  C7 06 08 09 FF FF     MOV    word ptr [0x908], 0xffff     ; UNKNOWN
01CCC3  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01CCC7  80 BF 94 00 00        CMP    byte ptr [bx + 0x94], 0      ; UNKNOWN
01CCCC  7C 39                 JL     0x1cd07                      ; UNKNOWN
01CCCE  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
01CCD1  50                    PUSH   ax                           ; UNKNOWN
01CCD2  8D 4E FA              LEA    cx, [bp - 6]                 ; UNKNOWN
01CCD5  51                    PUSH   cx                           ; UNKNOWN
01CCD6  FF 36 9D 3B           PUSH   word ptr [0x3b9d]            ; UNKNOWN
01CCDA  0E                    PUSH   cs                           ; UNKNOWN
01CCDB  E8 CA C0              CALL   0x18da8                      ; UNKNOWN
01CCDE  83                    DB     0x83                         ; UNKNOWN (raw)
