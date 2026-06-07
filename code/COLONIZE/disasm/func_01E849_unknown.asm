; ============================================================================
; func_01E849_unknown
; Region   : load_image
; Bytes    : file 0x01E849..0x01E86B  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E849  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
01E84D  56                    PUSH   si                           ; UNKNOWN
01E84E  F6 06 F9 3D 80        TEST   byte ptr [0x3df9], 0x80      ; UNKNOWN
01E853  74 03                 JE     0x1e858                      ; UNKNOWN
01E855  E9 E1 02              JMP    0x1eb39                      ; UNKNOWN
01E858  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
01E85D  8A 46 F0              MOV    al, byte ptr [bp - 0x10]     ; UNKNOWN
01E860  8B 76 F0              MOV    si, word ptr [bp - 0x10]     ; UNKNOWN
01E863  88 42 EC              MOV    byte ptr [bp + si - 0x14], al ; UNKNOWN
01E866  8A 84 C2 86           MOV    al, byte ptr [si - 0x793e]   ; UNKNOWN
01E86A  2A                    DB     0x2A                         ; UNKNOWN (raw)
