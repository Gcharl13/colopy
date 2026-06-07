; ============================================================================
; func_02EDAC_unknown
; Region   : load_image
; Bytes    : file 0x02EDAC..0x02EE9D  (241 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EDAC  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02EDB0  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02EDB5  83 7E 06 09           CMP    word ptr [bp + 6], 9         ; UNKNOWN
02EDB9  75 0B                 JNE    0x2edc6                      ; UNKNOWN
02EDBB  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
02EDBF  75 05                 JNE    0x2edc6                      ; UNKNOWN
02EDC1  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; UNKNOWN
02EDC6  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; UNKNOWN
02EDCA  75 0A                 JNE    0x2edd6                      ; UNKNOWN
02EDCC  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
02EDD0  75 04                 JNE    0x2edd6                      ; UNKNOWN
02EDD2  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
02EDD6  83 7E 06 02           CMP    word ptr [bp + 6], 2         ; UNKNOWN
02EDDA  75 0A                 JNE    0x2ede6                      ; UNKNOWN
02EDDC  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
02EDE0  75 04                 JNE    0x2ede6                      ; UNKNOWN
02EDE2  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
02EDE6  83 7E 06 09           CMP    word ptr [bp + 6], 9         ; UNKNOWN
02EDEA  75 0A                 JNE    0x2edf6                      ; UNKNOWN
02EDEC  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
02EDF0  75 04                 JNE    0x2edf6                      ; UNKNOWN
02EDF2  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
02EDF6  83 7E 06 08           CMP    word ptr [bp + 6], 8         ; UNKNOWN
02EDFA  75 0A                 JNE    0x2ee06                      ; UNKNOWN
02EDFC  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
02EE00  75 04                 JNE    0x2ee06                      ; UNKNOWN
02EE02  83 46 FE 03           ADD    word ptr [bp - 2], 3         ; UNKNOWN
02EE06  83 7E 06 03           CMP    word ptr [bp + 6], 3         ; UNKNOWN
02EE0A  75 0B                 JNE    0x2ee17                      ; UNKNOWN
02EE0C  83 7E 08 03           CMP    word ptr [bp + 8], 3         ; UNKNOWN
02EE10  75 05                 JNE    0x2ee17                      ; UNKNOWN
02EE12  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
02EE17  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
02EE1B  75 0B                 JNE    0x2ee28                      ; UNKNOWN
02EE1D  83 7E 08 02           CMP    word ptr [bp + 8], 2         ; UNKNOWN
02EE21  75 05                 JNE    0x2ee28                      ; UNKNOWN
02EE23  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
02EE28  83 7E 06 05           CMP    word ptr [bp + 6], 5         ; UNKNOWN
02EE2C  75 0B                 JNE    0x2ee39                      ; UNKNOWN
02EE2E  83 7E 08 01           CMP    word ptr [bp + 8], 1         ; UNKNOWN
02EE32  75 05                 JNE    0x2ee39                      ; UNKNOWN
02EE34  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
02EE39  83 7E 06 0A           CMP    word ptr [bp + 6], 0xa       ; UNKNOWN
02EE3D  75 0A                 JNE    0x2ee49                      ; UNKNOWN
02EE3F  83 7E 08 05           CMP    word ptr [bp + 8], 5         ; UNKNOWN
02EE43  75 04                 JNE    0x2ee49                      ; UNKNOWN
02EE45  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
02EE49  83 7E 06 06           CMP    word ptr [bp + 6], 6         ; UNKNOWN
02EE4D  75 0A                 JNE    0x2ee59                      ; UNKNOWN
02EE4F  83 7E 08 06           CMP    word ptr [bp + 8], 6         ; UNKNOWN
02EE53  75 04                 JNE    0x2ee59                      ; UNKNOWN
02EE55  83 46 FE 03           ADD    word ptr [bp - 2], 3         ; UNKNOWN
02EE59  83 7E 06 0D           CMP    word ptr [bp + 6], 0xd       ; UNKNOWN
02EE5D  75 0A                 JNE    0x2ee69                      ; UNKNOWN
02EE5F  83 7E 08 06           CMP    word ptr [bp + 8], 6         ; UNKNOWN
02EE63  75 04                 JNE    0x2ee69                      ; UNKNOWN
02EE65  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
02EE69  83 7E 06 06           CMP    word ptr [bp + 6], 6         ; UNKNOWN
02EE6D  75 09                 JNE    0x2ee78                      ; UNKNOWN
02EE6F  83 7E 08 07           CMP    word ptr [bp + 8], 7         ; UNKNOWN
02EE73  75 03                 JNE    0x2ee78                      ; UNKNOWN
02EE75  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02EE78  83 7E 06 0C           CMP    word ptr [bp + 6], 0xc       ; UNKNOWN
02EE7C  75 0A                 JNE    0x2ee88                      ; UNKNOWN
02EE7E  83 7E 08 07           CMP    word ptr [bp + 8], 7         ; UNKNOWN
02EE82  75 04                 JNE    0x2ee88                      ; UNKNOWN
02EE84  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
02EE88  83 7E 06 07           CMP    word ptr [bp + 6], 7         ; UNKNOWN
02EE8C  75 0A                 JNE    0x2ee98                      ; UNKNOWN
02EE8E  83 7E 08 08           CMP    word ptr [bp + 8], 8         ; UNKNOWN
02EE92  75 04                 JNE    0x2ee98                      ; UNKNOWN
02EE94  83 46 FE 03           ADD    word ptr [bp - 2], 3         ; UNKNOWN
02EE98  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02EE9B  C9                    LEAVE                               ; UNKNOWN
02EE9C  CB                    RETF                                ; UNKNOWN
