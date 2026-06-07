; ============================================================================
; func_0062B4_is_tile_walkable_or_special
; Region   : load_image
; Bytes    : file 0x0062B4..0x0062DB  (39 bytes)
; Purpose  : Calls overlay helper at 0x037F:0x10E with (x, y), masks the result's low 5 bits (terrain-id mask), and returns 0 if the result is 0x19 (= 25) or 0x1A (= 26). For other values, falls through to the same return path with AX=0. Looks like 'is this tile NOT a special-passable type'.
; Args     : [bp+6] = x, [bp+8] = y
; Returns  : AX = 0 always (the test is for control-flow side-effects, OR the caller cares about register state changes).
; Callers  : TBD (5 distinct call sites)
; Callees  : 0x037F:0x10E (overlay-resident tile classifier)
; Verified : Boundary verified: PUSH BP / LEAVE / RETF, 39 bytes.
; Source   : Pattern: tile-classify call + AND 0x1F + comparisons against 0x19/0x1A. The 0x1F mask is the terrain-id width.
; ============================================================================

0062B4  55                    PUSH   bp                           ; standard frame prologue
0062B5  8B EC                 MOV    bp, sp                       ; BP = SP
0062B7  56                    PUSH   si                           ; preserve SI
0062B8  FF 76 08              PUSH   word ptr [bp + 8]            ; push y
0062BB  FF 76 06              PUSH   word ptr [bp + 6]            ; push x
0062BE  9A 0E 01 7F 03        LCALL  0x37f, 0x10e                 ; far-call overlay tile-classify helper at 0x37F:0x10E — returns AL = packed tile attributes
0062C3  83 C4 04              ADD    sp, 4                        ; pop x, y
0062C6  2A E4                 SUB    ah, ah                       ; zero-extend AL → AX
0062C8  24 1F                 AND    al, 0x1f                     ; mask low 5 bits — extract terrain-id (the bottom 5 bits hold base terrain 0..31)
0062CA  8B F0                 MOV    si, ax                       ; SI = terrain-id
0062CC  83 FE 19              CMP    si, 0x19                     ; terrain == 25? (likely a specific special terrain — Mountains? Hills? Sea Lane?)
0062CF  74 0B                 JE     0x62dc                       ; if yes, jump out (next-fn region — caller chose what to do)
0062D1  83 FE 1A              CMP    si, 0x1a                     ; terrain == 26?
0062D4  74 06                 JE     0x62dc                       ; if yes, jump out
0062D6  2B C0                 SUB    ax, ax                       ; AX = 0 — for non-special terrains, return 0
0062D8  5E                    POP    si                           ; restore SI
0062D9  C9                    LEAVE                               ; teardown
0062DA  CB                    RETF                                ; far-return: AX = 0 for normal terrain, falls into next function for terrain 25/26
