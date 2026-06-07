; ============================================================================
; func_067C54_unknown
; Region   : overlay
; Bytes    : file 0x067C54..0x067C8D  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067C54  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
067C58  56                    PUSH   si ; STACK_PUSH
067C59  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
067C5E  C4 1E 98 A5           LES    bx, ptr [0xa598] ; MOV_FAR
067C62  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
067C65  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
067C68  25 1F 00              AND    ax, 0x1f ; LOGIC
067C6B  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
067C6E  3D 18 00              CMP    ax, 0x18 ; CMP
067C71  7D 14                 JGE    0x67c87 ; CJUMP
067C73  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
067C76  24 07                 AND    al, 7 ; LOGIC
067C78  3C 01                 CMP    al, 1 ; CMP
067C7A  74 0B                 JE     0x67c87 ; CJUMP
067C7C  83 7E FE 07           CMP    word ptr [bp - 2], 7 ; CMP
067C80  7E 05                 JLE    0x67c87 ; CJUMP
067C82  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
067C87  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
067C8A  5E                    POP    si ; STACK_POP
067C8B  C9                    LEAVE ; EPILOGUE
067C8C  C3                    RET ; RETURN
