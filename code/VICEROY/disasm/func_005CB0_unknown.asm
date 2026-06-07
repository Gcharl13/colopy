; ============================================================================
; func_005CB0_unknown
; Region   : load_image
; Bytes    : file 0x005CB0..0x005CE6  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005CB0  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
005CB4  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
005CB9  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005CBC  39 06 28 83           CMP    word ptr [0x8328], ax ; CMP
005CC0  7F 06                 JG     0x5cc8 ; CJUMP
005CC2  39 06 04 88           CMP    word ptr [0x8804], ax ; CMP
005CC6  7D 05                 JGE    0x5ccd ; CJUMP
005CC8  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
005CCD  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005CD0  39 06 2E 83           CMP    word ptr [0x832e], ax ; CMP
005CD4  7F 06                 JG     0x5cdc ; CJUMP
005CD6  39 06 06 88           CMP    word ptr [0x8806], ax ; CMP
005CDA  7D 05                 JGE    0x5ce1 ; CJUMP
005CDC  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
005CE1  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
005CE4  C9                    LEAVE ; EPILOGUE
005CE5  CB                    RETF ; RETURN
