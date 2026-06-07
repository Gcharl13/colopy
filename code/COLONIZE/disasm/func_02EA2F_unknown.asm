; ============================================================================
; func_02EA2F_unknown
; Region   : load_image
; Bytes    : file 0x02EA2F..0x02EA63  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EA2F  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02EA33  FF 36 8E 3E           PUSH   word ptr [0x3e8e]            ; UNKNOWN
02EA37  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
02EA3C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EA3F  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02EA43  8A 67 01              MOV    ah, byte ptr [bx + 1]        ; UNKNOWN
02EA46  2A C0                 SUB    al, al                       ; UNKNOWN
02EA48  99                    CDQ                                 ; UNKNOWN
02EA49  8A 0F                 MOV    cl, byte ptr [bx]            ; UNKNOWN
02EA4B  2A ED                 SUB    ch, ch                       ; UNKNOWN
02EA4D  03 C1                 ADD    ax, cx                       ; UNKNOWN
02EA4F  83 D2 00              ADC    dx, 0                        ; UNKNOWN
02EA52  03 06 8A 3E           ADD    ax, word ptr [0x3e8a]        ; UNKNOWN
02EA56  13 16 8C 3E           ADC    dx, word ptr [0x3e8c]        ; UNKNOWN
02EA5A  52                    PUSH   dx                           ; UNKNOWN
02EA5B  50                    PUSH   ax                           ; UNKNOWN
02EA5C  9A 64 00 AA 0D        LCALL  0xdaa, 0x64                  ; UNKNOWN
02EA61  C9                    LEAVE                               ; UNKNOWN
02EA62  CB                    RETF                                ; UNKNOWN
