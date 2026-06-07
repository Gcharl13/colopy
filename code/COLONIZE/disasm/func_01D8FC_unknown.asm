; ============================================================================
; func_01D8FC_unknown
; Region   : load_image
; Bytes    : file 0x01D8FC..0x01D989  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01D8FC  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
01D900  A0 13 09              MOV    al, byte ptr [0x913]         ; UNKNOWN
01D903  88 46 FC              MOV    byte ptr [bp - 4], al        ; UNKNOWN
01D906  A0 15 09              MOV    al, byte ptr [0x915]         ; UNKNOWN
01D909  88 46 FA              MOV    byte ptr [bp - 6], al        ; UNKNOWN
01D90C  A0 17 09              MOV    al, byte ptr [0x917]         ; UNKNOWN
01D90F  88 46 FE              MOV    byte ptr [bp - 2], al        ; UNKNOWN
01D912  2A C0                 SUB    al, al                       ; UNKNOWN
01D914  A2 13 09              MOV    byte ptr [0x913], al         ; UNKNOWN
01D917  A2 15 09              MOV    byte ptr [0x915], al         ; UNKNOWN
01D91A  A2 17 09              MOV    byte ptr [0x917], al         ; UNKNOWN
01D91D  0E                    PUSH   cs                           ; UNKNOWN
01D91E  E8 4C F6              CALL   0x1cf6d                      ; UNKNOWN
01D921  80 3E 13 09 00        CMP    byte ptr [0x913], 0          ; UNKNOWN
01D926  75 0F                 JNE    0x1d937                      ; UNKNOWN
01D928  80 7E FC 00           CMP    byte ptr [bp - 4], 0         ; UNKNOWN
01D92C  74 09                 JE     0x1d937                      ; UNKNOWN
01D92E  6A 01                 PUSH   1                            ; UNKNOWN
01D930  0E                    PUSH   cs                           ; UNKNOWN
01D931  E8 41 AB              CALL   0x18475                      ; UNKNOWN
01D934  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01D937  80 3E 15 09 00        CMP    byte ptr [0x915], 0          ; UNKNOWN
01D93C  75 0F                 JNE    0x1d94d                      ; UNKNOWN
01D93E  80 7E FA 00           CMP    byte ptr [bp - 6], 0         ; UNKNOWN
01D942  74 09                 JE     0x1d94d                      ; UNKNOWN
01D944  6A 01                 PUSH   1                            ; UNKNOWN
01D946  0E                    PUSH   cs                           ; UNKNOWN
01D947  E8 D8 BC              CALL   0x19622                      ; UNKNOWN
01D94A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01D94D  80 3E 17 09 00        CMP    byte ptr [0x917], 0          ; UNKNOWN
01D952  75 0F                 JNE    0x1d963                      ; UNKNOWN
01D954  80 7E FE 00           CMP    byte ptr [bp - 2], 0         ; UNKNOWN
01D958  74 09                 JE     0x1d963                      ; UNKNOWN
01D95A  6A 01                 PUSH   1                            ; UNKNOWN
01D95C  0E                    PUSH   cs                           ; UNKNOWN
01D95D  E8 AF 9F              CALL   0x1790f                      ; UNKNOWN
01D960  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01D963  80 3E 13 09 00        CMP    byte ptr [0x913], 0          ; UNKNOWN
01D968  75 05                 JNE    0x1d96f                      ; UNKNOWN
01D96A  C6 06 12 09 FE        MOV    byte ptr [0x912], 0xfe       ; UNKNOWN
01D96F  80 3E 15 09 00        CMP    byte ptr [0x915], 0          ; UNKNOWN
01D974  75 05                 JNE    0x1d97b                      ; UNKNOWN
01D976  C6 06 14 09 FE        MOV    byte ptr [0x914], 0xfe       ; UNKNOWN
01D97B  80 3E 17 09 00        CMP    byte ptr [0x917], 0          ; UNKNOWN
01D980  75 05                 JNE    0x1d987                      ; UNKNOWN
01D982  C6 06 16 09 FE        MOV    byte ptr [0x916], 0xfe       ; UNKNOWN
01D987  C9                    LEAVE                               ; UNKNOWN
01D988  C3                    RET                                 ; UNKNOWN
