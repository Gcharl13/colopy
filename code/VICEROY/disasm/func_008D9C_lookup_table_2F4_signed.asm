; ============================================================================
; func_008D9C_lookup_table_2F4_signed
; Region   : load_image
; Bytes    : file 0x008D9C..0x008DBB  (31 bytes)
; Purpose  : Bounded array lookup: returns -1 if index >= 0x13 (19), else returns sign-extended byte at DGROUP:0x2F4 + index. The fixed limit 0x13 + sign-extension suggests a small ranged lookup table (perhaps terrain-attribute or unit-class table).
; Args     : [bp+6] = index (0..0x12)
; Returns  : AX = signed byte at table[index], or -1 if index out of range.
; Callers  : TBD (4 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: ENTER 2 / LEAVE / RETF, 31 bytes.
; Source   : Bounded-index pattern: CMP / JGE early-exit / array read with sign-extension.
; ============================================================================

008D9C  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame
008DA0  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; result_local = -1 (default for out-of-range)
008DA5  83 7E 06 13           CMP    word ptr [bp + 6], 0x13      ; index >= 0x13 (19)?
008DA9  7D 0B                 JGE    0x8db6                       ; if so, return -1
008DAB  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; BX = index
008DAE  8A 87 F4 02           MOV    al, byte ptr [bx + 0x2f4]    ; AL = lookup_table_2F4[index]
008DB2  98                    CWDE                                ; sign-extend AL → AX (table values are signed bytes)
008DB3  89 46 FE              MOV    word ptr [bp - 2], ax        ; result = sign-extended byte
008DB6  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; AX = result
008DB9  C9                    LEAVE                               ; teardown
008DBA  CB                    RETF                                ; far-return: AX = signed byte at table[index], or -1 if out of range
