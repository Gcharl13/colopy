; ============================================================================
; func_01EC32_unknown
; Region   : load_image
; Bytes    : file 0x01EC32..0x01ECCB  (153 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01EC32  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
01EC36  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01EC3A  8B 87 B8 00           MOV    ax, word ptr [bx + 0xb8]     ; UNKNOWN
01EC3E  83 C0 32              ADD    ax, 0x32                     ; UNKNOWN
01EC41  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
01EC44  99                    CDQ                                 ; UNKNOWN
01EC45  F7 F9                 IDIV   cx                           ; UNKNOWN
01EC47  40                    INC    ax                           ; UNKNOWN
01EC48  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01EC4B  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01EC4D  2A E4                 SUB    ah, ah                       ; UNKNOWN
01EC4F  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
01EC52  2A F6                 SUB    dh, dh                       ; UNKNOWN
01EC54  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
01EC59  EB 2D                 JMP    0x1ec88                      ; UNKNOWN
01EC5B  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
01EC5F  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
01EC64  72 07                 JB     0x1ec6d                      ; UNKNOWN
01EC66  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
01EC6B  76 13                 JBE    0x1ec80                      ; UNKNOWN
01EC6D  6A 01                 PUSH   1                            ; UNKNOWN
01EC6F  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
01EC72  9A 4C 00 75 38        LCALL  0x3875, 0x4c                 ; UNKNOWN
01EC77  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01EC7A  C1 F8 04              SAR    ax, 4                        ; UNKNOWN
01EC7D  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
01EC80  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
01EC83  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
01EC88  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01EC8B  0B C0                 OR     ax, ax                       ; UNKNOWN
01EC8D  7D CC                 JGE    0x1ec5b                      ; UNKNOWN
01EC8F  6A 02                 PUSH   2                            ; UNKNOWN
01EC91  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
01EC96  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01EC99  0B C0                 OR     ax, ax                       ; UNKNOWN
01EC9B  74 05                 JE     0x1eca2                      ; UNKNOWN
01EC9D  D1 66 FC              SHL    word ptr [bp - 4], 1         ; UNKNOWN
01ECA0  EB 1C                 JMP    0x1ecbe                      ; UNKNOWN
01ECA2  6A 01                 PUSH   1                            ; UNKNOWN
01ECA4  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
01ECA9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01ECAC  0B C0                 OR     ax, ax                       ; UNKNOWN
01ECAE  74 0E                 JE     0x1ecbe                      ; UNKNOWN
01ECB0  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
01ECB3  8B C8                 MOV    cx, ax                       ; UNKNOWN
01ECB5  D1 E0                 SHL    ax, 1                        ; UNKNOWN
01ECB7  03 C1                 ADD    ax, cx                       ; UNKNOWN
01ECB9  D1 F8                 SAR    ax, 1                        ; UNKNOWN
01ECBB  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01ECBE  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
01ECC1  83 F8 01              CMP    ax, 1                        ; UNKNOWN
01ECC4  7D 03                 JGE    0x1ecc9                      ; UNKNOWN
01ECC6  B8 01 00              MOV    ax, 1                        ; UNKNOWN
01ECC9  C9                    LEAVE                               ; UNKNOWN
01ECCA  CB                    RETF                                ; UNKNOWN
