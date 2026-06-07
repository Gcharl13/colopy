; ============================================================================
; func_009AAA_unknown
; Region   : load_image
; Bytes    : file 0x009AAA..0x009B9B  (241 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009AAA  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
009AAE  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
009AB3  83 7E 06 09           CMP    word ptr [bp + 6], 9 ; CMP
009AB7  75 0B                 JNE    0x9ac4 ; CJUMP
009AB9  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
009ABD  75 05                 JNE    0x9ac4 ; CJUMP
009ABF  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2 ; LOCAL_STORE
009AC4  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
009AC8  75 0A                 JNE    0x9ad4 ; CJUMP
009ACA  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
009ACE  75 04                 JNE    0x9ad4 ; CJUMP
009AD0  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
009AD4  83 7E 06 02           CMP    word ptr [bp + 6], 2 ; CMP
009AD8  75 0A                 JNE    0x9ae4 ; CJUMP
009ADA  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
009ADE  75 04                 JNE    0x9ae4 ; CJUMP
009AE0  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
009AE4  83 7E 06 09           CMP    word ptr [bp + 6], 9 ; CMP
009AE8  75 0A                 JNE    0x9af4 ; CJUMP
009AEA  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
009AEE  75 04                 JNE    0x9af4 ; CJUMP
009AF0  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
009AF4  83 7E 06 08           CMP    word ptr [bp + 6], 8 ; CMP
009AF8  75 0A                 JNE    0x9b04 ; CJUMP
009AFA  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
009AFE  75 04                 JNE    0x9b04 ; CJUMP
009B00  83 46 FE 03           ADD    word ptr [bp - 2], 3 ; ARITH
009B04  83 7E 06 03           CMP    word ptr [bp + 6], 3 ; CMP
009B08  75 0B                 JNE    0x9b15 ; CJUMP
009B0A  83 7E 08 03           CMP    word ptr [bp + 8], 3 ; CMP
009B0E  75 05                 JNE    0x9b15 ; CJUMP
009B10  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
009B15  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
009B19  75 0B                 JNE    0x9b26 ; CJUMP
009B1B  83 7E 08 02           CMP    word ptr [bp + 8], 2 ; CMP
009B1F  75 05                 JNE    0x9b26 ; CJUMP
009B21  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
009B26  83 7E 06 05           CMP    word ptr [bp + 6], 5 ; CMP
009B2A  75 0B                 JNE    0x9b37 ; CJUMP
009B2C  83 7E 08 01           CMP    word ptr [bp + 8], 1 ; CMP
009B30  75 05                 JNE    0x9b37 ; CJUMP
009B32  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
009B37  83 7E 06 0A           CMP    word ptr [bp + 6], 0xa ; CMP
009B3B  75 0A                 JNE    0x9b47 ; CJUMP
009B3D  83 7E 08 05           CMP    word ptr [bp + 8], 5 ; CMP
009B41  75 04                 JNE    0x9b47 ; CJUMP
009B43  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
009B47  83 7E 06 06           CMP    word ptr [bp + 6], 6 ; CMP
009B4B  75 0A                 JNE    0x9b57 ; CJUMP
009B4D  83 7E 08 06           CMP    word ptr [bp + 8], 6 ; CMP
009B51  75 04                 JNE    0x9b57 ; CJUMP
009B53  83 46 FE 03           ADD    word ptr [bp - 2], 3 ; ARITH
009B57  83 7E 06 0D           CMP    word ptr [bp + 6], 0xd ; CMP
009B5B  75 0A                 JNE    0x9b67 ; CJUMP
009B5D  83 7E 08 06           CMP    word ptr [bp + 8], 6 ; CMP
009B61  75 04                 JNE    0x9b67 ; CJUMP
009B63  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
009B67  83 7E 06 06           CMP    word ptr [bp + 6], 6 ; CMP
009B6B  75 09                 JNE    0x9b76 ; CJUMP
009B6D  83 7E 08 07           CMP    word ptr [bp + 8], 7 ; CMP
009B71  75 03                 JNE    0x9b76 ; CJUMP
009B73  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
009B76  83 7E 06 0C           CMP    word ptr [bp + 6], 0xc ; CMP
009B7A  75 0A                 JNE    0x9b86 ; CJUMP
009B7C  83 7E 08 07           CMP    word ptr [bp + 8], 7 ; CMP
009B80  75 04                 JNE    0x9b86 ; CJUMP
009B82  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
009B86  83 7E 06 07           CMP    word ptr [bp + 6], 7 ; CMP
009B8A  75 0A                 JNE    0x9b96 ; CJUMP
009B8C  83 7E 08 08           CMP    word ptr [bp + 8], 8 ; CMP
009B90  75 04                 JNE    0x9b96 ; CJUMP
009B92  83 46 FE 03           ADD    word ptr [bp - 2], 3 ; ARITH
009B96  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
009B99  C9                    LEAVE ; EPILOGUE
009B9A  CB                    RETF ; RETURN
