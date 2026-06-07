; ============================================================================
; func_009626_count_field_at_20_matching
; Region   : load_image
; Bytes    : file 0x009626..0x00965B  (53 bytes)
; Purpose  : Counts entries in the *(0x8542)+0x20 byte-array that equal the
;            target value [bp+6]. Iterates `idx = 0 .. struct.count-1` and
;            for each idx calls `current_unit_field_at_20` (0x90C8); if the
;            returned byte equals [bp+6], increments a counter. Returns the
;            tally (a "how many slots hold value X" histogram bucket).
; Args     : [bp+6] = target byte value to match against
; Returns  : AX = count of matching entries
; Callers  : TBD
; Callees  : current_unit_field_at_20 (0x90C8 near-call, once per iteration)
; Verified : Boundary verified: ENTER 4 / LEAVE / RETF, 53 bytes. Loop uses
;            [bp-2] as tally and [bp-4] as iterator; bound is struct.byte[+0x1F].
; Source   : Pattern: classic count-while-loop with predicate.
; ============================================================================

009626  C8 04 00 00           ENTER  4, 0                         ; allocate 4-byte local frame: [bp-2]=tally, [bp-4]=idx
00962A  2B C0                 SUB    ax, ax                       ; AX = 0
00962C  89 46 FE              MOV    word ptr [bp - 2], ax        ; tally = 0
00962F  89 46 FC              MOV    word ptr [bp - 4], ax        ; idx = 0
009632  EB 15                 JMP    0x9649                       ; jump to loop test
; ----- loop body -----
009634  FF 76 FC              PUSH   word ptr [bp - 4]            ; push idx
009637  0E                    PUSH   cs                           ; push CS for near-CALL
009638  E8 8D FA              CALL   0x90c8                       ; near-call current_unit_field_at_20(idx) → AX = byte
00963B  83 C4 02              ADD    sp, 2                        ; pop arg
00963E  3B 46 06              CMP    ax, word ptr [bp + 6]        ; byte == target?
009641  75 03                 JNE    0x9646                       ; mismatch — skip increment
009643  FF 46 FE              INC    word ptr [bp - 2]            ; tally++
009646  FF 46 FC              INC    word ptr [bp - 4]            ; idx++
; ----- loop test -----
009649  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = struct ptr
00964D  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; AL = struct.count
009650  98                    CWDE                                ; AL → AX
009651  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; count vs idx
009654  7F DE                 JG     0x9634                       ; if count > idx, continue loop
009656  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; AX = tally
009659  C9                    LEAVE                               ; teardown
00965A  CB                    RETF                                ; far-return: AX = match count
