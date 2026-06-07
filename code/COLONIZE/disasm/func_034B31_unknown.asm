; ============================================================================
; func_034B31_unknown
; Region   : load_image
; Bytes    : file 0x034B31..0x034B6C  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034B31  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
034B35  50                    PUSH   ax                           ; UNKNOWN
034B36  83 3E 9A 79 04        CMP    word ptr [0x799a], 4         ; UNKNOWN
034B3B  7D 18                 JGE    0x34b55                      ; UNKNOWN
034B3D  6B 1E 9A 79 34        IMUL   bx, word ptr [0x799a], 0x34  ; UNKNOWN
034B42  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
034B47  75 0C                 JNE    0x34b55                      ; UNKNOWN
034B49  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
034B4C  2A E4                 SUB    ah, ah                       ; UNKNOWN
034B4E  48                    DEC    ax                           ; UNKNOWN
034B4F  48                    DEC    ax                           ; UNKNOWN
034B50  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
034B53  EB 05                 JMP    0x34b5a                      ; UNKNOWN
034B55  C7 46 FE FE FF        MOV    word ptr [bp - 2], 0xfffe    ; UNKNOWN
034B5A  C1 66 FE 04           SHL    word ptr [bp - 2], 4         ; UNKNOWN
034B5E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
034B61  F7 6E FC              IMUL   word ptr [bp - 4]            ; UNKNOWN
034B64  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
034B67  99                    CDQ                                 ; UNKNOWN
034B68  F7 F9                 IDIV   cx                           ; UNKNOWN
034B6A  C9                    LEAVE                               ; UNKNOWN
034B6B  C3                    RET                                 ; UNKNOWN
