; ============================================================================
; func_05C65A_unknown
; Region   : overlay
; Bytes    : file 0x05C65A..0x05C69B  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05C65A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
05C65E  C7 46 FE 15 00        MOV    word ptr [bp - 2], 0x15 ; LOCAL_STORE
05C663  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
05C668  74 0B                 JE     0x5c675 ; CJUMP
05C66A  83 7E 06 15           CMP    word ptr [bp + 6], 0x15 ; CMP
05C66E  75 05                 JNE    0x5c675 ; CJUMP
05C670  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
05C675  83 7E 06 1A           CMP    word ptr [bp + 6], 0x1a ; CMP
05C679  75 05                 JNE    0x5c680 ; CJUMP
05C67B  C7 46 FE 19 00        MOV    word ptr [bp - 2], 0x19 ; LOCAL_STORE
05C680  83 7E 06 19           CMP    word ptr [bp + 6], 0x19 ; CMP
05C684  75 05                 JNE    0x5c68b ; CJUMP
05C686  C7 46 FE 1C 00        MOV    word ptr [bp - 2], 0x1c ; LOCAL_STORE
05C68B  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b ; CMP
05C68F  75 05                 JNE    0x5c696 ; CJUMP
05C691  C7 46 FE 1B 00        MOV    word ptr [bp - 2], 0x1b ; LOCAL_STORE
05C696  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
05C699  C9                    LEAVE ; EPILOGUE
05C69A  CB                    RETF ; RETURN
