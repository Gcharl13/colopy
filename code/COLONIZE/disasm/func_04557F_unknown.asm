; ============================================================================
; func_04557F_unknown
; Region   : load_image
; Bytes    : file 0x04557F..0x0455B3  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04557F  C8 7A 00 00           ENTER  0x7a, 0                      ; UNKNOWN
045583  53                    PUSH   bx                           ; UNKNOWN
045584  52                    PUSH   dx                           ; UNKNOWN
045585  50                    PUSH   ax                           ; UNKNOWN
045586  56                    PUSH   si                           ; UNKNOWN
045587  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
04558C  A1 C4 0B              MOV    ax, word ptr [0xbc4]         ; UNKNOWN
04558F  89 46 94              MOV    word ptr [bp - 0x6c], ax     ; UNKNOWN
045592  0B C0                 OR     ax, ax                       ; UNKNOWN
045594  75 1B                 JNE    0x455b1                      ; UNKNOWN
045596  F6 06 A8 09 20        TEST   byte ptr [0x9a8], 0x20       ; UNKNOWN
04559B  74 14                 JE     0x455b1                      ; UNKNOWN
04559D  39 06 1A 3E           CMP    word ptr [0x3e1a], ax        ; UNKNOWN
0455A1  75 09                 JNE    0x455ac                      ; UNKNOWN
0455A3  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
0455A6  39 06 C0 0B           CMP    word ptr [0xbc0], ax         ; UNKNOWN
0455AA  75 05                 JNE    0x455b1                      ; UNKNOWN
0455AC  C7 46 94 01 00        MOV    word ptr [bp - 0x6c], 1      ; UNKNOWN
0455B1  8B C3                 MOV    ax, bx                       ; UNKNOWN
