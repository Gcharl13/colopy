; ============================================================================
; func_008F02_check_total_exceeds_threshold
; Region   : load_image
; Bytes    : file 0x008F02..0x008F23  (33 bytes)
; Purpose  : Tests whether the per-index running total (struct.word[+0x9A + idx*2] in *(0x8542)  PLUS the global_amount at DGROUP:0x8DC8[idx*2]) exceeds the band-base value at DGROUP:0x8E0A[idx*2]. If exceeded, returns AX=1; otherwise falls through past the LEAVE/RETF into the next function (0x8F2A) — a fast-path predicate before the slower main case (just like func_00BC10_is_arg2_negative).
; Args     : [bp+6] = index (0..14, commodity slot)
; Returns  : AX = 1 if struct.word[+0x9A+idx*2] + global_amount[idx] > base[idx]; otherwise falls through into func_008F2A
; Callers  : TBD (callgraph pending)
; Callees  : (none — leaf accessor + predicate)
; Verified : Boundary verified: PUSH BP / RETF, 33 bytes. The constants 0x9A, 0x8DC8 (= -0x7238), 0x8E0A (= -0x71F6) cross-reference exactly with func_008E02 and func_008E46.
; Source   : Pattern: predicate that falls through to a follow-on function, identical shape to is_arg2_negative.
; ============================================================================

008F02  55                    PUSH   bp                           ; standard frame prologue
008F03  8B EC                 MOV    bp, sp                       ; BP = SP
008F05  56                    PUSH   si                           ; preserve SI
008F06  8B 76 06              MOV    si, word ptr [bp + 6]        ; SI = index
008F09  D1 E6                 SHL    si, 1                        ; SI = index * 2 (word stride)
008F0B  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
008F0F  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; AX = struct.word[+0x9A + idx*2] (per-index running value)
008F13  03 84 C8 8D           ADD    ax, word ptr [si - 0x7238]   ; AX += global_amount[idx*2] (DGROUP:0x8DC8 + idx*2)
008F17  3B 84 0A 8E           CMP    ax, word ptr [si - 0x71f6]   ; compare against base[idx*2] (DGROUP:0x8E0A + idx*2)
008F1B  7E 07                 JLE    0x8f24                       ; if total <= base, fall through into next function (0x8F24 → past LEAVE)
008F1D  B8 01 00              MOV    ax, 1                        ; total > base → AX = 1
008F20  5E                    POP    si                           ; restore SI
008F21  C9                    LEAVE                               ; teardown
008F22  CB                    RETF                                ; far-return: AX = 1 (threshold exceeded)
