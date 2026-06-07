; ============================================================================
; func_00929A_classify_pair_bounds
; Region   : load_image
; Bytes    : file 0x00929A..0x0092E0  (70 bytes)
;            NOTE: the auto-boundary detector split this into FOUR pieces
;                  (one per branch). Full function covers 0x929A..0x92DF.
; Purpose  : Classifies a (primary_index, secondary_index) pair against two
;            bound checks and returns a 0..3 dispatch code:
;              0 = primary IN  struct (idx < count) AND secondary <  0x13
;              1 = primary OUT struct (idx >= count) AND secondary >= 0x13
;              2 = primary IN  struct                AND secondary >= 0x13
;              3 = primary OUT struct                AND secondary <  0x13
;            (The mapping is NOT a packed 2-bit "primary_out, secondary_out"
;            code — it's a custom 4-case dispatch. Callers presumably switch
;            on this value to choose normal-lookup / boundary / sea / polar
;            handling. The threshold 0x13 = 19 matches the 20-entry pair-table
;            at DGROUP:0xC8/0xDE.)
; Args     : [bp+6] = primary index (compared to struct count at +0x1F),
;            [bp+8] = secondary index (compared to 0x13 = 19)
; Returns  : AX = 0..3 bound-classification code
; Callers  : TBD
; Callees  : (none — leaf classifier)
; Verified : Four LEAVE/RETF tails: 0x92B9 (=0), 0x92C4 (=2), 0x92D4 (=1),
;            0x92DE (=3). Threshold constants 0x13 and the +0x1F count match
;            the cross-references in func_008892, func_008956, func_008918.
; Source   : Pattern: cascading bound checks producing a packed 2-bit code.
; ============================================================================

00929A  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame [bp-2] = result
00929E  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
0092A2  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; AL = struct.count
0092A5  98                    CWDE                                ; AL → AX
0092A6  3B 46 06              CMP    ax, word ptr [bp + 6]        ; count vs primary_index
0092A9  7E 1B                 JLE    0x92c6                       ; if count <= primary, primary out-of-bounds
0092AB  83 7E 08 13           CMP    word ptr [bp + 8], 0x13      ; secondary vs 19
0092AF  7D 0B                 JGE    0x92bc                       ; if secondary >= 19, return 2
0092B1  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; both in-bounds → 0
0092B6  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; AX = result
0092B9  C9                    LEAVE                               ; teardown
0092BA  CB                    RETF                                ; far-return: AX=0
0092BB  90                    NOP                                 ; padding (auto-detector split here)
; ----- branch: primary in-bounds, secondary out -----
0092BC  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; AX = 2
0092C1  8B 46 FE              MOV    ax, word ptr [bp - 2]
0092C4  C9                    LEAVE                               ; teardown
0092C5  CB                    RETF                                ; far-return: AX=2
; ----- branch: primary out-of-bounds — re-test secondary -----
0092C6  83 7E 08 13           CMP    word ptr [bp + 8], 0x13      ; secondary vs 19
0092CA  7C 0A                 JL     0x92d6                       ; if secondary < 19, both out (3); else just primary (1)
0092CC  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; primary-only-out → 1
0092D1  8B 46 FE              MOV    ax, word ptr [bp - 2]
0092D4  C9                    LEAVE                               ; teardown
0092D5  CB                    RETF                                ; far-return: AX=1
; ----- branch: both out -----
0092D6  C7 46 FE 03 00        MOV    word ptr [bp - 2], 3         ; both-out → 3
0092DB  8B 46 FE              MOV    ax, word ptr [bp - 2]
0092DE  C9                    LEAVE                               ; teardown
0092DF  CB                    RETF                                ; far-return: AX=3
