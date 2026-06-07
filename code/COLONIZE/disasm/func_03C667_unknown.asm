; ============================================================================
; func_03C667_unknown
; Region   : load_image
; Bytes    : file 0x03C667..0x03C698  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C667  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
03C66B  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
03C670  74 5E                 JE     0x3c6d0                      ; UNKNOWN
03C672  A1 E4 0E              MOV    ax, word ptr [0xee4]         ; UNKNOWN
03C675  83 E8 09              SUB    ax, 9                        ; UNKNOWN
03C678  03 06 B0 3E           ADD    ax, word ptr [0x3eb0]        ; UNKNOWN
03C67C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03C67F  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03C682  48                    DEC    ax                           ; UNKNOWN
03C683  48                    DEC    ax                           ; UNKNOWN
03C684  50                    PUSH   ax                           ; UNKNOWN
03C685  6A 01                 PUSH   1                            ; UNKNOWN
03C687  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
03C68A  2D FC 00              SUB    ax, 0xfc                     ; UNKNOWN
03C68D  03 06 B2 3E           ADD    ax, word ptr [0x3eb2]        ; UNKNOWN
03C691  50                    PUSH   ax                           ; UNKNOWN
03C692  9A 08 00 C2 44        LCALL  0x44c2, 8                    ; UNKNOWN
03C697  83                    DB     0x83                         ; UNKNOWN (raw)
