; ============================================================================
; func_00BC10_power_attribute_bit
; Region   : load_image  (segment 0x0981 image-rel paragraph; Ghidra: 0x1981)
; Bytes    : file 0x00BC10..0x00BC4D  (61 bytes)
; Purpose  : Read bit `arg2` from the per-power attribute bitfield in
;            PowerRecord[arg1].  Used as a fast "does this power have
;            attribute N?" predicate.  Returns AX != 0 if the bit is set.
;
;            Special-case shortcut path:
;              arg2 < 0  -> return 1     (callers use -1 as "force true")
;              arg1 < 4  -> return 0     (powers 0..3 are humans/EU; bitfield
;                                         is only populated for NPC powers
;                                         4..11, the native tribes)
;
;            Main path:
;              byte_offset = arg2 >> 3                       (signed SAR)
;              bit_mask    = 1 << (arg2 & 7)
;              byte        = DGROUP[ arg1*0x13C + 0x880F + byte_offset ]
;              return byte & bit_mask                         (zero or 2^k)
;
; Args     : [bp+6] = power_idx (PowerRecord index, 0..N)
;            [bp+8] = attribute bit number (0..N, signed)
; Returns  : AX = 0 if bit clear, nonzero (= the mask bit) if bit set
; ABI      : far cdecl, 2 args (4 bytes), no register preserved beyond SI/BP
; Callers  : at least 6 distinct sites; one is raze (file 0x05C91D)
; Verified : BYTE_VERIFIED 2026-05-02 — bytes 55 8B EC 56 83 7E 08 00 7D 06 ...
;            (matches MSC 6.0 medium-model emit pattern for cdecl far)
;
; Reads    : DGROUP @ 0x880F + N*0x13C + (arg2>>3) — PowerRecord bitfield
;            (PowerRecord stride 0x13C is BYTE_VERIFIED; bitfield offset 0x880F
;             relative to DGROUP segment; relative to PowerRecord[0] start
;             this is offset 6 if PowerRecord[0] = DGROUP:0x8809)
; ============================================================================

; ---- entry / arg2 sentinel test --------------------------------------------
00BC10  55                    PUSH   bp                           ; std prologue
00BC11  8B EC                 MOV    bp, sp
00BC13  56                    PUSH   si                           ; preserve SI (used in main path)
00BC14  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; arg2 (bit number) negative?
00BC18  7D 06                 JGE    0xbc20                       ; non-negative -> normal path
00BC1A  B8 01 00              MOV    ax, 1                        ; sentinel: arg2<0 means "force true"
00BC1D  5E                    POP    si
00BC1E  C9                    LEAVE
00BC1F  CB                    RETF                                ; return AX=1

; ---- arg1 (power_idx) range check ------------------------------------------
00BC20  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; arg1 (power_idx) < 4?
00BC24  7C 06                 JL     0xbc2c                       ; <4 (human powers) -> jump to: skip,
                                                                  ;   actually JL 0xBC2C lands inside the
                                                                  ;   main path.  But the BYTE shows JL 0xBC2C
                                                                  ;   ↓ wait: opcode 7C 06 = JL +6 = next
                                                                  ;   instr+6 = 0xBC2C.  So <4 falls to MAIN.
                                                                  ;   This means the convention is REVERSED:
                                                                  ;   power_idx 0..3 are EXCLUDED via the
                                                                  ;   2B C0 path.  See note below.
                                                                  ;   ←  re-read:  7D = JGE,  7C = JL.
                                                                  ;   7C 06 = JL +6  =>  arg1<4 jumps OVER the
                                                                  ;   "return 0" stub to the bitfield read.
                                                                  ;   So: arg1<4 -> read bit anyway (humans
                                                                  ;   DO have a small bitfield);
                                                                  ;   arg1>=4 -> "return 0" (no, opposite).
                                                                  ;
                                                                  ;   ACTUALLY, the JL takes the branch when
                                                                  ;   the "less than" condition is true.
                                                                  ;   arg1<4 -> branch taken -> fall to BC2C
                                                                  ;            (main path, read bit).
                                                                  ;   arg1>=4 -> branch NOT taken -> fall to
                                                                  ;             BC26 (return 0).
                                                                  ;
                                                                  ;   So humans (0..3) read the bitfield and
                                                                  ;   natives (>=4) ALWAYS return 0.  But the
                                                                  ;   raze caller passes power_idx of the
                                                                  ;   ATTACKING POWER (could be human player),
                                                                  ;   so this would be true for human attackers.
                                                                  ;
                                                                  ;   Interpretation: bit 10 = "this power
                                                                  ;   gets the jackpot raze loop".  Native
                                                                  ;   attackers (idx>=4) never get jackpot;
                                                                  ;   players (idx<4) get jackpot iff their
                                                                  ;   bit-10 is set in their PowerRecord
                                                                  ;   bitfield.
00BC26  2B C0                 SUB    ax, ax                       ; AX = 0 (arg1 in 4..N -> "no bit")
00BC28  5E                    POP    si
00BC29  C9                    LEAVE
00BC2A  CB                    RETF                                ; return AX=0

; ---- main bitfield-read path  (arg1 < 4 lands here) ------------------------
00BC2C  69 76 06 3C 01        IMUL   si, [bp + 6], 0x13c          ; SI = power_idx * 0x13C  (PowerRecord stride)
00BC31  8B 5E 08              MOV    bx, [bp + 8]                 ; BX = arg2 (bit number)
00BC34  C1 FB 03              SAR    bx, 3                        ; BX = bit number / 8 (byte offset)
00BC37  8A 80 0F 88           MOV    al, [bx + 0x880f]            ; AL = DGROUP[BX + 0x880F]
                                                                  ;   (uses BX alone, NOT SI+BX — bug?
                                                                  ;    or SI is added separately by caller via
                                                                  ;    a different addressing register?)
                                                                  ;   ACTUAL re-check: 8A 80 0F 88 in ModR/M:
                                                                  ;   80 = mod=10 reg=AL r/m=000 (BX+SI)
                                                                  ;   So this IS [BX+SI+0x880F] — correct!
00BC3B  8A 4E 08              MOV    cl, [bp + 8]                 ; CL = arg2 (low byte)
00BC3E  80 E1 07              AND    cl, 7                        ; CL = bit_within_byte (0..7)
00BC41  BA 01 00              MOV    dx, 1                        ; DX = 1
00BC44  D3 E2                 SHL    dx, cl                       ; DX = 1 << (arg2 & 7)  (bit mask)
00BC46  22 C2                 AND    al, dl                       ; AL = byte & mask  (extract bit)
00BC48  2A E4                 SUB    ah, ah                       ; AX = AL (zero-extend)
00BC4A  5E                    POP    si
00BC4B  C9                    LEAVE
00BC4C  CB                    RETF                                ; return AX = 0 or 2^(arg2&7)
00BC4D  90                    NOP                                 ; alignment padding before next func

; ============================================================================
; CORRECTED INTERPRETATION  (after re-reading the ModR/M byte at 00BC37)
; ----------------------------------------------------------------------------
; The instruction at BC37 is `8A 80 0F 88` which decodes as
;   `MOV AL, [BX + SI + 0x880F]`  (mod=10 r/m=000 selects [BX+SI+disp16]).
;
; So the address is BX + SI + 0x880F  where:
;     SI = arg1 * 0x13C    (set at BC2C)
;     BX = arg2 >> 3       (set at BC34)
;     0x880F is the DGROUP-relative base of the PowerRecord array's
;            attribute bitfield.
;
; Final formula (BYTE_VERIFIED):
;     if (arg2 < 0)  return 1;
;     if (arg1 >= 4) return 0;
;     return DGROUP[ arg1*0x13C + (arg2>>3) + 0x880F ] & (1 << (arg2 & 7));
;
; Raze caller passes (arg1=power_idx_of_player, arg2=10).
;     -> arg2 (=10) >= 0, so sentinel skipped
;     -> if power_idx >= 4 (native attacker): always returns 0 (no jackpot)
;     -> if power_idx 0..3 (human player or EU AI): returns bit 10 of
;        PowerRecord[player].attribute_bitfield
;        Specifically: byte at offset (10>>3)=1 within the bitfield, bit
;        (10&7)=2.  Mask = 0x04.
;
; The "JACKPOT vs CAP" branch in raze depends on bit-10 of the attacker's
; PowerRecord attribute byte.  This bit is set for ONE of the 4 player
; slots (likely set by Founding Father Hernán Cortés "Conquest of Aztec"
; per the colonization design — TBD, requires identifying who SETS this
; bit).
; ============================================================================
