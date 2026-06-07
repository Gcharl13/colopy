; ============================================================================
; func_06475E_unknown
; Region   : load_image
; Bytes    : file 0x06475E..0x0647A6  (72 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06475E  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
064762  50                    PUSH   ax                           ; UNKNOWN
064763  57                    PUSH   di                           ; UNKNOWN
064764  56                    PUSH   si                           ; UNKNOWN
064765  C5 76 06              LDS    si, ptr [bp + 6]             ; UNKNOWN
064768  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
06476D  80 3C 00              CMP    byte ptr [si], 0             ; UNKNOWN
064770  74 26                 JE     0x64798                      ; UNKNOWN
064772  8E 46 0C              MOV    es, word ptr [bp + 0xc]      ; UNKNOWN
064775  8A 04                 MOV    al, byte ptr [si]            ; UNKNOWN
064777  98                    CWDE                                ; UNKNOWN
064778  8B F8                 MOV    di, ax                       ; UNKNOWN
06477A  4F                    DEC    di                           ; UNKNOWN
06477B  46                    INC    si                           ; UNKNOWN
06477C  03 7E 0A              ADD    di, word ptr [bp + 0xa]      ; UNKNOWN
06477F  26 8A 4D 02           MOV    cl, byte ptr es:[di + 2]     ; UNKNOWN
064783  2A ED                 SUB    ch, ch                       ; UNKNOWN
064785  0B C9                 OR     cx, cx                       ; UNKNOWN
064787  7E 07                 JLE    0x64790                      ; UNKNOWN
064789  38 2C                 CMP    byte ptr [si], ch            ; UNKNOWN
06478B  74 03                 JE     0x64790                      ; UNKNOWN
06478D  03 4E FC              ADD    cx, word ptr [bp - 4]        ; UNKNOWN
064790  01 4E FE              ADD    word ptr [bp - 2], cx        ; UNKNOWN
064793  80 3C 00              CMP    byte ptr [si], 0             ; UNKNOWN
064796  75 DD                 JNE    0x64775                      ; UNKNOWN
064798  B8 F7 62              MOV    ax, 0x62f7                   ; UNKNOWN
06479B  8E D8                 MOV    ds, ax                       ; UNKNOWN
06479D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0647A0  5E                    POP    si                           ; UNKNOWN
0647A1  5F                    POP    di                           ; UNKNOWN
0647A2  C9                    LEAVE                               ; UNKNOWN
0647A3  CA 08 00              RETF   8                            ; UNKNOWN
