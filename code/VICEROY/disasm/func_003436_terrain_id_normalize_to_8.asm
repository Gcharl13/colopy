; ============================================================================
; func_003436_terrain_id_normalize_to_8
; Region   : load_image
; Bytes    : file 0x003436..0x00344F  (25 bytes)
; Purpose  : Maps terrain id 17 (0x11) or 9 to 8; passes other values through. Likely converts "forested" variants to a base terrain id, or normalises a special-case terrain value used by the renderer. Returns AX = normalised id.
; Args     : [bp+6] = terrain id
; Returns  : AX = (id == 0x11 || id == 9) ? 8 : id
; Callers  : TBD (4 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: PUSH BP / LEAVE / RETF, 25 bytes.
; Source   : Pattern: 2 CMP+JE branches that funnel both into a single MOV + return.
; ============================================================================

003436  55                    PUSH   bp                           ; standard frame prologue
003437  8B EC                 MOV    bp, sp                       ; BP = SP
003439  83 7E 06 11           CMP    word ptr [bp + 6], 0x11      ; is terrain id == 17 (Forest? or specific terrain)?
00343D  74 06                 JE     0x3445                       ; if yes, normalize to 8
00343F  83 7E 06 09           CMP    word ptr [bp + 6], 9         ; is terrain id == 9?
003443  75 0B                 JNE    0x3450                       ; if neither 17 nor 9, branch out (return id unchanged via fall-through to MOV AX,[bp+6] at next func boundary)
003445  C7 46 06 08 00        MOV    word ptr [bp + 6], 8         ; replace id with 8
00344A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = (possibly normalised) id
00344D  C9                    LEAVE                               ; teardown
00344E  CB                    RETF                                ; far-return: AX = (id == 17 || id == 9) ? 8 : id
