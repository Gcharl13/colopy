# Overlay function attribution — Track 1 (2026-06-25)

Functions attributed while tracing the orphan-overlay sites that blocked spec/systems
TBDs. Each is byte-verified against raw/COLONIZE/VICEROY.EXE. This is the durable index;
the resolved field semantics live in the spec files.

## func_04E2D6 (file 0x04E2D6..0x051D55, ~14975 bytes, 4858 insns, ENTER 0xEE)  —  overlay page 0x0D (page_0D.asm; file_offset 0x04BA50, code 0x04C1F0..0x053540)
**Purpose:** Per-unit AI order/move processor. Arg [bp+6]=unit index. On entry reads owner nibble 0x3147&0xf, order code 0x314C (gates on 0,5,6,>=0xa -> common exit 0x6218), position 0x3144/0x3145, type 0x3146; sets AI state char 0x314B. Contains a destination/heading scoring loop using accumulator word [bp-0x26] and heading field 0x314F. ALL blocking sites @0x050C75,0x050C9D,0x0516E9,0x05170A,0x051760,0x051A84,0x051A95 are inside this one function.

**Callers:** No static lcall found for its thunk (0x1A1F:0x04F4, thunk file 0x1cae4). Invoked INDIRECTLY via a far-jump dispatch table: trampoline 'ea f4 04 1f 1a' (ljmp 0x1A1F:0x04F4) sits as data/jump-table at file 0x534F8 (page 0D tail). One entry in an AI handler jump-table; live caller loads the slot at runtime.

**Evidence:** page_0D.asm:2953 header size=14975; 04E2D6 'enter 0xee,0'; 04E2EF imul bx,[bp+6],0x1c; 04E2F3 mov al,[bx+0x3147]; 04E2F7 and ax,0xf; 04E2FE cmp [bx+0x314c],0. xref.py callers 0x4e2d6 -> 1 thunk, 0 lcall callers. Far-ptr 'f4 04 1f 1a' found as data at file 0x534f9 (preceding byte 0xea => ljmp 0x1A1F:0x04F4).

## func_059B90 (file 0x059B90, size=2173)  —  overlay page 0x0F (page_0F.asm; file_offset 0x0562B0)
**Purpose:** Second AI routine that also WRITES heading 0x314F (@0x05A0C4) while iterating units and testing owner nibble 0x3147&0xf. Confirms 0x314F is set by AI, not europe/recruit code.

**Callers:** thunk 0x1A1F:0x0192; xref finds 2 callers.

**Evidence:** page_0F.asm:4254 header; 05A083 mov al,[bx+0x3147]; 05A087 and ax,0xf; 05A0C0 imul bx,[bp-0x42],0x1c; 05A0C4 mov [bx+0x314f],al (al from [bp-0x2e]).

## page 0x0C routine enclosing @0x047A6F  —  overlay page 0x0C (page_0C.asm)
**Purpose:** Direction-scoring routine: SMOKING GUN for 0x314F=heading. Reads 0x314F, 'xor al,4' (8-way compass reverse) vs candidate dir [bp-0x34]: +4 if equal (same heading), -6 if reverse. Proves 0x314F is a compass direction 0..7.

**Callers:** not separately traced (not a blocking site).

**Evidence:** page_0C.asm:1097 047A6F mov al,[bx+0x314f]; 047A74 cmp ax,[bp-0x34]; 047A79 add [bp-0x24],4. 047AA4 mov al,[bx+0x314f]; 047AA8 xor al,4; 047AAB cmp ax,[bp-0x34]; 047AB0 sub [bp-0x24],6. Guard 047A62 cmp [bp-0x34],8.

## page 0x13 AI routine(s) @0x062F71/0x063280/0x0633B8  —  overlay page 0x13 (page_13.asm)
**Purpose:** Third confirmation of 0x314F=heading: 'xor al,4' reverse test vs candidate [bp-0x1a]; writes 0x314F from [bp-0x1a] which is checked ==8 as invalid/no-direction sentinel.

**Callers:** n/a

**Evidence:** page_13.asm 062F78 mov al,[bx+0x314f]; 062F7C xor al,4; 062F7F cmp ax,[bp-0x1a]. 0633B1 mov al,[bp-0x1a]; 0633B8 mov [bx+0x314f],al; preceded by 06337C cmp [bp-0x1a],8; jne.

## func_02F052 (page_03, file 0x02F052..0x02F3A0; ENTER 0x0A)  —  overlay page 0x03
**Purpose:** Per-power AI/auto unit-movement pass. Loops all units (idx [bp-6] from count-1 down), gates on TEST [bx+0x3148],0x80 @0x2F088 AND unit_type(0x3146)==0x0B, then filters owner nibble (0x3147&0xF). Computes movement from runtime stat 0x5235 and work-counter 0x315A. CLEARS bit 0x80 (AND 0x7F @0x2F135) after consuming the unit, and SETS bit 0x40 (OR 0x40 @0x2F37A) immediately after writing goto-target x/y (0x314D/0x314E) and storing work-counter (0x315A) from a movement-plan helper (lcall 0x191F:0x0AEE).

**Callers:** type-A overlay entry; not resolved to a named caller (jmpf_seg placeholder). Reached in the per-power turn loop.

**Evidence:** @0x2F088 f687483180 test ...,0x80 / @0x2F135 80a748317f and ...,0x7f / @0x2F37A 808c483140 or ...,0x40; goto writes @0x2F358 (0x314d), @0x2F35F (0x314e); 0x315a store @0x2F376

## func_04CC50 (page_0D, file 0x04CC50; size 5733, ENTER 0x1E4)  —  overlay page 0x0D
**Purpose:** Per-unit flag classification/refresh scan. SETS 0x08|0x04 (OR 0x0C @0x04CDCC) and 0x04 (OR 0x04 @0x04CDDC) on ship-type units (gated by 0x3146 in 0x0D..0x12 = Caravel..Man-O-War) when locals [bp-0x1c]/[bp-0x1a] flags set; TESTs 0x0C @0x04CDFC (gated same ship-type range). SETS 0x20 (OR 0x20 @0x04CE44) for unit_type==0x0E (Merchantman). Resets transient bits via AND 0xD1 @0x04CEB1 (clears 0x20|0x08|0x04|0x02) after copying pos 0x3144/0x3145 to locals and converting 0x314B 'A'(0x41)->'G'(0x47). SETS 0x02 (OR 0x02 @0x04CEC9) when order code 0x314C==5 or ==6.

**Callers:** type-A overlay entry; not resolved to named caller.

**Evidence:** @0x04CDCC 808f48310c / @0x04CDDC 808f483104 / @0x04CDFA f68748310c / @0x04CE44 808f483120 / @0x04CEB1 80a74831d1 / @0x04CEC9 808f483102; type gate @0x04CDFC region cmp 0x3146,0x0d/0x12

## func_04E2D6 (page_0D, file 0x04E2D6; size 14975, ENTER 0xEE)  —  overlay page 0x0D
**Purpose:** AI movement/reachability pass. SETS bit 0x10 (OR 0x10 @0x05106E) after a path/visibility helper chain (lcall 0x181F:0x37A) returns >=8 (cmp ax,8 / jl skip); CLEARS bit 0x10 (AND 0xEF @0x051094) on the failure branch. Also TESTs 0x10 @0x050FEA, TESTs 0x04 @0x04E068 (paired with map-cell value==1) and 0x08 @0x04E08A (paired with map-cell value==7), and TESTs 0x02 @0x051AB9 (toggling order 0x314C between 5 and 6).

**Callers:** type-A overlay entry; large AI turn routine.

**Evidence:** @0x05106E 808c483110 / @0x051094 80a74831ef / @0x050FEA f687483110 / @0x04E068 f687483104 / @0x04E08A f687483108 / @0x051AB9 f687483102 (then mov 0x314c,6); cmp ax,8 @0x051069

## func_046FFA (page_0C, file 0x046FFA; size 4835, ENTER 0xA2)  —  overlay page 0x0C
**Purpose:** PROVEN: bit 0x08 = per-unit dirty/redraw flag. TEST 0x08 @0x0481B0 -> if set, CLEAR 0x08 (AND 0xF7 @0x0481B7) and call tile-redraw with unit x/y (push 0x3145, push 0x3144, lcall 0x1A1F:0x192). SET 0x08 (OR 0x08 @0x0481EA) is preceded by storing turn-counter [0x538E] into 0x3156, when local [bp-0x82]&0x80 is set. A pre-clear AND 0xF7 @0x0481A2 is also present. Clean set->test->clear->redraw cycle within one function.

**Callers:** type-A overlay entry.

**Evidence:** @0x0481A2 80a74831f7 / @0x0481B0 f687483108 / @0x0481B7 80a74831f7 then push 0x3145/0x3144 + lcall 0x1a1f:0x192 / @0x0481EA 808f483108 preceded by mov [0x3156],ax(=[0x538e])

## func_0696C6 (page_16, file 0x0696C6; size 1733, ENTER 0x62)  —  overlay page 0x16
**Purpose:** Bit 0x80 transient render state. Gated on unit_type(0x3146)==0x0B: SET 0x80 (OR 0x80 @0x069923), perform a draw (lcall 0x181F:0x2BC, sprite 100), then CLEAR 0x80 (AND 0x7F @0x069942). Combined with renderer TEST 0x80 @0x037AD (selects sprite offset 0x42=66 when set) and @0x0079EF (test 0x80 then check type==0x0B). Indicates 0x80 is a transient draw-time/active-unit marker, set around a blit and cleared after.

**Callers:** type-A overlay entry; sprite-blit loop (lcall 0x181F:0x2BC with sprite idx 0x64=100).

**Evidence:** @0x069923 808f483180 / @0x069942 80a448317f wrapping lcall 0x181f:0x2bc; renderer @0x037AD f687483180 then mov si,0x42; @0x0079EF f687483180 then cmp 0x3146,0x0b

## combat func @0x05B6F6/@0x05BB9E (page_10, file 0x05A950 base)  —  overlay page 0x10
**Purpose:** SET 0x80 @0x05B6F6 and @0x05BB9E during combat resolution (after message-display lcalls). @0x05BB9E set is immediately followed by zeroing work-counter 0x315A, cargo-count 0x3150, and order 0x314C -> looks like a unit captured/converted/reset. Confirms 0x80 set sites span render + combat subsystems (overloaded use).

**Callers:** combat-resolution routine.

**Evidence:** @0x05B6F6 808f483180 ; @0x05BB9E 808f483180 then mov [0x315a],0 / [0x3150],0 / [0x314c],0

## combat func @0x05BD1E / @0x05D4BF (page_10)  —  overlay page 0x10
**Purpose:** TEST 0x40 @0x05BD1E gates a 6-entry type-table damage/bombardment block (scans [bx-0x6873] by unit_type, subtracts from [bx-0x77f7]). TEST 0x10 @0x05B3A9 and SET 0x10 @0x05D4BF also in combat. Shows 0x40 (set in AI move loop func_02F052) is tested in combat — cross-subsystem, link inferential not byte-proven.

**Callers:** combat bombardment routine.

**Evidence:** @0x05BD1E f687483140 jne; @0x05B3A9 f687483110; @0x05D4BF 808f483110

## func_04E2D6 @0x04E2D6 (page_0D, overlay record 12; size 14975/4858 insns; ENTER 0xEE)  —  overlay page 0x0D
**Purpose:** Land/sea unit order+move+cargo-transfer processing block; contains BOTH the 0x3158 setter @0x04F730 and tester @0x0507E1. Derives ship/land bool into [bp-0x32]: cmp byte[bx+0x3146] vs 0x0D..0x12 -> [bp-0x32]=1 for ships (rows 13..18 Caravel..Man-O-War), =0 for land. No reassignment of [bp-0x32] between that test and the setter.

**Callers:** public entry = RTLink thunk 0x1A1F:0x04F4 (xref.find_callers -> thunk_file_off 0x1CAE4). No static lcall site found (window seg 0x1A1F runtime-patched). Internally reached via page trampoline ljmp 0x1A1F:0x4F4 @0x0534F8.

**Evidence:** @0x04E490 imul bx,[bp+6],0x1c; @0x04E494 cmp byte[bx+0x3146],0x0d/jb; @0x04E49B cmp ...,0x12/ja; @0x04E4A2 mov [bp-0x32],1; @0x04E4AA mov [bp-0x32],0. Setter @0x04F726 cmp [bp-0x32],0/jne(skip); @0x04F72C imul bx,[bp+6],0x1c; @0x04F730 mov byte[bx+0x3158],1. Tester @0x0507D7 cmp byte[bx+0x3146],0x0c/je 0x4d91; @0x0507E1 cmp byte[bx+0x3158],0/jne 0x4d9b(run) else jmp 0x4e62(skip).

## func_00B368 @0x00B368 (resident, 126 bytes) = target of LCALL 0x181F:0x0D58 (thunks_resolved typeB -> 0x05EB:0x30B8 -> file 0x00B368)  —  resident
**Purpose:** Cargo-load into unit hold: loops over cargo slots (count [bx+0x3150]), matches commodity via near-calls 0xB2A2/0xB2F0/0xB304 (cargo-slot accessors, cf get_nth_cargo @0x0B2AB), adds quantity. This is the move/turn cargo-transfer LCALL whose flow the [bp-0x32] gate guards.

**Callers:** called from func_04E2D6 @0x04F709 immediately before the 0x3158 setter; args [bp-0x34]=qty(<=0x64), [bp-0x22]=commodity id, [bp+6]=unit idx.

**Evidence:** @0x00B3C4 imul bx,[bp+6],0x1c / @0x00B3C8 mov al,[bx+0x3150] (cargo-count loop bound); calls 0xB2A2/0xB2F0/0xB304; @0x00B3BE sub [bp+0xa],ax (decrement remaining qty).

## unit-create field initializer, orphan range file 0x006DE9..0x006E94 (just after func_006D24)  —  resident
**Purpose:** Initializes a freshly created unit's fields. 0x3158 is cleared to 0 ONLY for Wagon Trains (type 0x0C): @0x006E02 cmp byte[bx+0x3146],0x0c / @0x006E07 jne 0x6e35 (skip) / @0x006E0C mov byte[bx+0x3158],0. => 0x3158 is a Wagon-Train-relevant field at creation.

**Callers:** unit-creation path (sets 0x315B class, 0x314A timer, etc. per spec lines 27-28).

**Evidence:** @0x006E02 cmp byte[bx+0x3146],0x0c; @0x006E07 jne 0x6e35; @0x006E0C C6 87 58 31 00 mov byte[bx+0x3158],0.

## func_049600 @0x049600 (page_0C, size 3451/1138 insns; ENTER 0xD8)  —  overlay page 0x0C
**Purpose:** Turn-start refresh for a unit: clears 0x3158 to 0 for LAND units (skips ships 0x0D..0x12): @0x04967B cmp byte[bx+0x3146],0x0d/jb; @0x049682 cmp ...,0x12/jbe(skip ships); @0x04968D mov byte[bx+0x3158],0. Confirms 0x3158 is a per-turn land-unit boolean cleared at refresh.

**Callers:** per-turn unit refresh (the init @0x04968D is followed by zeroing a 16-entry table at [bp-0x7a]/[bp-0x96], a movement/visited table).

**Evidence:** @0x049677 imul bx,[bp+6],0x1c; @0x04967B cmp byte[bx+0x3146],0x0d; @0x049680 jb 0x3089; @0x049682 cmp ...,0x12; @0x049687 jbe 0x3092; @0x04968D C6 87 58 31 00 mov byte[bx+0x3158],0; then 16x zero of [bp-0x7a]/[bp-0x96].

## func_006D24 @0x006D24..0x006DE9 (resident, region load_image)  —  resident
**Purpose:** Unit-record constructor / spawn. Owner arg=[bp+8] (di). For owner di>=4: +0x12 (0x3156) initialized as WORD = global [0x538e] (MOV ax,[0x538e]@0x006DAD; MOV [bx+0x3156],ax@0x006DB3). For owner di<4: +0x12 left as the byte 0xFF sentinel written at 0x006DA3. So +0x12 is byte-0xFF-sentinel for player owners, word-timestamp for AI/native owners.

**Callers:** unit-spawn constructor; writes the full UnitRecord at idx [0x539c] (post-INC) with stride 0x1c via IMUL bx,si,0x1c, base 0x3144 (map_x). Sets +0x00..+0x12 of the record.

**Evidence:** 0x006DA3 C6 87 56 31 FF (mov byte[bx+0x3156],0xFF); 0x006DA8 83 FF 04 CMP di,4; 0x006DAB 7C 0A JL 0x6db7; 0x006DAD A1 8E 53 MOV ax,[0x538e]; 0x006DB3 89 87 56 31 MOV word[bx+0x3156],ax. Stride proven 0x006D6F 6B DE 1C IMUL bx,si,0x1c, writes 0x3146(type),0x3147(owner),0x314b=0x58,0x3156.

## func_046FFA @0x046FFA (overlay page 0x0C, size 4835, ENTER 0xA2)  —  overlay page 0x0C
**Purpose:** AI per-unit scorer. Computes [bp-0x7c] = [0x538e] + ([0x538e] idiv 0xffe7=-25) (0x046FFB..0x047018), then at 0x04769C/0x0476B6/0x04822B SUBs field +0x12: ax = [bp-0x7c] - [bx+0x3156] = elapsed game-progress since the unit's stored timestamp, compared against distance/score thresholds (e.g. cx=[bp-0x36]*2+5 @0x0476A0). At 0x0481E6, when flag [bp-0x82] bit 0x80 set, RE-STAMPS +0x12 = word [0x538e] and sets field +0x06 (0x3148) bit 8 (OR @0x0481EA). This is the AI scorer named in the blocking site; it READS +0x12 as a word turn-stamp, NOT as cost/sale/treasure.

**Callers:** reached via tail ljmp 0x1a1f:0x3d4 at 0x04BA1B (page_0C); thunk 0x1A1F:0x03D4 = thunk_file_offset 0x1c9c4. Per-unit AI evaluator ([bp+6]=unit idx, imul bx,[bp+6],0x1c).

**Evidence:** 0x04700B A1 8E 53 MOV ax,[0x538e]; 0x04700E B9 E7 FF MOV cx,0xffe7; 0x047011 99 CDQ; 0x047012 F7 F9 IDIV cx; 0x047014 03 06 8E 53 ADD ax,[0x538e]; 0x047018 89 46 84 MOV [bp-0x7c],ax. 0x04769C 2B 87 56 31 SUB ax,[bx+0x3156]. 0x0481DF A1 8E 53 MOV ax,[0x538e]; 0x0481E6 89 87 56 31 MOV word[bx+0x3156],ax; 0x0481EA 80 8F 48 31 08 OR byte[bx+0x3148],8.

## func_04E2D6 @0x04E2D6 (overlay page 0x0D, size 14975, ENTER 0xEE)  —  overlay page 0x0D
**Purpose:** Byte path @0x050C75: tests field +0x12 as a SIGNED BYTE (CMP byte[bx+0x3156],0; JGE). If negative (the 0xFF player-owner sentinel = unassigned), lazily assigns RNG: push 0x14; push 1; lcall RNG(0x181f:0x4d4 -> resident 0x00C322, bounded rand(1,0x14)); DEC al -> 0..0x13; store byte [si+0x3156] (@0x050C8C). Reloads byte [bx+0x3156] (@0x050C94), zero-extends, uses as [bp-0x4e]. Confirms +0x12 doubles as a lazily-initialized per-unit random byte (0..19) for player-owned units.

**Callers:** per-unit processing fn ([bp+6]=unit idx, imul bx,[bp+6],0x1c throughout).

**Evidence:** 0x050C75 80 BF 56 31 00 CMP byte[bx+0x3156],0; 0x050C7A 7D 14 JGE 0x5240; 0x050C7C 6A 14 PUSH 0x14; 0x050C7E 6A 01 PUSH 1; 0x050C82 9A D4 04 1F 18 LCALL 0x181f:0x4d4; 0x050C8A FE C8 DEC al; 0x050C8C 88 84 56 31 MOV [si+0x3156],al; 0x050C94 8A 87 56 31 MOV al,[bx+0x3156]. RNG target 0x181F:0x04D4 -> file 0x00C322 (bytes c8 04 00 00 9a 04 0e 1d 0d ... f7 e9 = bounded rand).

## global 0x538e (DGROUP)  —  resident BSS/DGROUP
**Purpose:** Monotonic game-progress / turn counter (NOT the calendar year, which is [0x538a]). Snapshotted into UnitRecord +0x12 as a per-unit timestamp for AI/native units. Recon glosses it unk_thresh; identity beyond turn/progress counter is the residual TBD.

**Callers:** init to 0 at new-game @0x0757EF (SUB ax,ax @0x0757ED; MOV [0x538e],ax). Many CMP [0x538e],{0x14,0x28,0x32,0x50} sites across overlays. Distinct from year global [0x538a] (CMP [0x538a],0x640=1600 / 0x6a4=1700).

**Evidence:** 0x0757ED 2B C0 SUB ax,ax; 0x0757EF A3 8E 53 MOV [0x538e],ax (new-game reset). 0x0556D4 83 3E 8E 53 32 CMP [0x538e],0x32. CMP[0x538e],0x50 @0x055C40. Year separate: data_extracted 0x2F3FD CMP [0x538a],0x640 year=1600.

## func_0082A0 @0x0082A0..0x82B2 (18 bytes, RETF)  —  resident (load_image region; thunk 0x181F:0x30C -> file 0x0082A0, target_seg_off 0x05DC:0x00E0, resident=true per thunks_resolved.json)
**Purpose:** 2-arg table GETTER for the 0x5B1C tension table: return word[DGROUP:0x5B1C + ([bp+6]*0x27 + [bp+8])*2]. ROW=[bp+6] (0x27=39-word stride), COL=[bp+8].

**Callers:** ~61 overlay call sites via lcall 0x181f,0x30c (pages 05,07,08,09,0B,0C,0D,0E,0F,0F,10,12,17) + 2 resident direct far-calls lcall 0x5dc,0xe0 @0x40d5 and @0xaf24 (orphans_load_image.asm). At every site the 2nd-to-last push (=COL=[bp+8]) is a European-power index in 0..3 (see evidence below).

**Evidence:** bytes @0x82A0: 55 8b ec 6b 5e 06 27 (imul bx,[bp+6],0x27) 03 5e 08 (add bx,[bp+8]) d1 e3 (shl bx,1) 8b 87 1c 5b (mov ax,[bx+0x5b1c]) c9 cb. Verified vs raw/COLONIZE/VICEROY.EXE.

## func_045DF2 @0x045DF2..0x45F16 (292 bytes, RETF)  —  overlay page_0B (thunk 0x181F:0x0D6C Type-A, target patched at runtime; func body at file 0x45DF2)
**Purpose:** tension-raise APPLIER: read tension[row*0x27+col] @0x45E57, add delta [bp+0xa] (halved for French power==1 @0x45E27/0x45E2D and for has_father(0x10,power) @0x45E35), clamp [0,100] via thunk 0x35c, write back @0x45E6C; then raise hostility flags at >=0x4b(75) and ==0x64(100). ROW=[bp+6], COL/power=[bp+8].

**Callers:** 32 call sites via lcall 0x181f,0xd6c (pages 06,07,08,0C,0F,10,12). COL/power operand at each site is a power global ([0x5398] current player, [0x53d2] rival, [0x5394] event power) or a loop counter bounded <4 (e.g. per-turn decay loop @0x4485CD: cmp [bp-0x12],4; jge) or a pass-through power param. No site passes an immediate >=4.

**Evidence:** read @0x45E4E: 6b 5e 06 27 / 03 5e 08 / d1 e3 / 8b 87 1c 5b. write @0x45E6C: 89 84 1c 5b (mov [si+0x5b1c],ax), si=bx index. @0x45ECE cmp [bp+8],4; jge — the col is explicitly treated as a European-power index (<4 path does imul bx,[bp+8],0x34; cmp [bx+0x543f],0 = PowerRecord controller). Verified vs EXE.

## func_047320 (raid-target scan, cited blocking site) — enclosing func in page_0C  —  overlay page_0C @0x47320 (getter call) 
**Purpose:** per-(tribe-row,power) tension read vs hostility threshold 75 (0x4b), parallel to +0x54F6 alarm array (threshold 128). The getter is called inside a loop over COL=[bp-0x60] with COL=0,1,2,3.

**Callers:** native-AI raid evaluation (per spec §3 War/raid)

**Evidence:** loop bound @0x47365: 83 7e a0 04 (cmp word[bp-0x60],4) 7c af (jl 0xd1a) — body runs col in {0,1,2,3} only; @0x47328 cmp ax,0x4b. The same [bp-0x60] indexes the +0x54F6 alarm array @0x47349 (add bx,[bp-0x60]) where stride is 9 words/settlement with per-power slot 0..3. Verified vs EXE.

## resident getter call @0x40d5 (orphans_load_image.asm, enclosing func enter 0x... near 0x4000)  —  resident
**Purpose:** reads tension for col=si (power), threshold 0x4b; si derived from a power index compared to [0x5396] and used to index +0x54F6 (tribe*9 + si).

**Callers:** resident native-AI tension consumer

**Evidence:** @0x40D1 push si (->ROW=[bp+6]); @0x40D2 push [bp-0xc] (->COL=[bp+8]); WAIT corrected: last push=[bp-0xc]=ROW, 2nd-to-last=si=COL. si used @0x40B4 add bx,si into [bx+0x54f6] stride-9 per-power array, and @0x40A4 cmp [0x5396],si — si is a European-power index 0..3. @0x40DD cmp ax,0x4b. Verified vs EXE.

## resident getter call @0xaf24 (orphans_load_image.asm, enclosing func enter 0x42 @0xab78)  —  resident
**Purpose:** reads tension for col=[bp-0x38]=colony owner power; result mapped to (4 - tension) @0xAF2C.

**Callers:** (not traced)

**Evidence:** COL=[bp-0x38] set once @0xab8a-0x93: mov bx,[0x8542] (current colony); mov al,[bx+0x1a] (ColonyRecord +0x1A = owner power); mov [bp-0x38],ax; immediately @0xab96 cmp ax,4; jge (European-power gate) + @0xab9b imul bx,ax,0x34; cmp [bx+0x543f],ah (PowerRecord stride 0x34 controller). So COL is a power index 0..3. Verified vs EXE.

## func_064A10 (file 0x64A10, overlay page 0x14)  —  page_14 (reseg lines 1644-3278; file 0x64A10-0x65D26)
**Purpose:** Map generator. ORs feature mask 0xA0 into the tile byte at TWO FIXED coords -- args (1,0x15) @0x65C0D and (0x44,0x2b) @0x65C21 -- via tile-pointer helper 0x181F:0x70E (type-A overlay thunk @file 0x1ACFE). Both writes gated by cmp [bp+6],0 (generator/scenario mode) AND cmp [0x2174],0/jne (map-loaded flag; sole writer @file 0x75D36 sets it=1).

**Callers:** overlay-internal (not a resident lcall-thunk target). Self-evidently the MAP GENERATOR: first act @0x64A23 stores random_int(0,0x7fff) into [0x190] -- the exact global map seed func_006188 reads @0x6191/@0x61E1.

**Evidence:** @0x65C0D: 26 80 0f a0 = 'or byte ptr es:[bx],0xa0'; @0x65C21: identical bytes. Pointer source @0x65C01/@0x65C15: 'lcall 0x181f,0x70e' after pushing the fixed coord pair. Seed init @0x64A1B: push 0x7fff; push 1; lcall 0x181f,0x4d4; mov [0x190],ax @0x64A23.

## func_006188 (file 0x6188, resident)  —  resident
**Purpose:** PROCEDURAL rumor-presence predicate -- computes presence, does NOT read a stored 0xA0/0xB0 marker. Confirms spec 6.1 instruction-by-instruction.

**Callers:** per-tile rumor-presence predicate consumed by the Lost-City path.

**Evidence:** @0x6191 cmp [0x190],0/je; @0x61A6/@0x61AB/@0x61B0 reject terrain 0x19/0x1A/0x18; @0x61BC push cs;call 0x5df0 then @0x61C2 cwde/@0x61C3 or ax,ax/@0x61C5 jge fail -- REQUIRES feature nibble==0xF(-1); @0x61C7-0x61F8 coord hash (imul cx,cx,0x13 @0x61D3; imul dx,dx,0x11 @0x61DC; add [0x190] @0x61E1; and cx,0x1f @0x61E8).

## sub @0x5DF0 (get_feature_high_nibble) + sub @0x5D9C (read_tile_byte) + sub @0x5DBA (low_nibble) + sub @0x5DCC (xor-mutate)  —  resident
**Purpose:** Tile-byte accessors. 0x5D9C reads tile = es:[ [0x166]:[0x164] + row*[0x853A] + col ] (one byte/tile, index y*width+x). 0x5DF0 does shr al,4 to get the FEATURE high nibble; returns -1 when nibble==0xF ('none').

**Callers:** @0x5DF0 called from 0x5F3C,0x5F69,0x5FBA,0x600C,0x6074,0x61BC (the last is func_006188).

**Evidence:** @0x5DA3 imul [0x853a]; @0x5DA9 add [0x164]; @0x5DAD mov es,[0x166]; @0x5DB4 mov al,es:[bx]. @0x5E01 shr al,4; @0x5E09 cmp ax,0xf/je -> @0x5E0E mov [bp-2],0xffff.



---

## Track 2b additions (2026-06-25) — overlay dialog/report/menu functions

Note: the save/load *picker geometry* proposal was rejected in adversarial verify for two
over-specific (fabricated) keyword-offset citations; the FUNCTION CHAIN below is the trace
result and is structurally sound, but treat individual DGROUP keyword offsets as pending
re-verification. The setup-menu, advisor-report, and Lost-City items WERE verified.

### func_072F7A — 0x1A (resident-overlay; file 0x072F7A..0x073158, 478 bytes)  [saveload-picker]
**Purpose:** SAVEGAME prompt orchestrator. Builds the slot-list and runs the modal picker, then dispatches save. Gated by 'SAVEGAME' key @0x72F80.

**Callers:** SAVEGAME menu action

**Evidence:** Calls the string-list builder via near-thunk CALL 0x7326b @0x72F84 (which is a JMPF trampoline EA E8 0C 1F 1A = 0x1A1F:0x0CE8 -> func_072CC2, raw bytes @file 0x7326B verified). Runs the modal dialog via LCALL 0x191F:0x16a @0x72F9B; tears it down via LCALL 0x191F:0x1a8 @0x72FB1 and again @0x73151. Disasm comments use the OLD thunk formula; corrected via typeA_thunk_targets.json.

### func_073158 — 0x1A (file 0x073158..0x073266, 270 bytes)  [saveload-picker]
**Purpose:** LOADGAME prompt orchestrator. Mirror of func_072F7A for the load side; builds the slot list and runs the same picker, then dispatches load via func_073BB0 path.

**Callers:** LOADGAME menu action

**Evidence:** CALL 0x7326b @0x73167 with key 'LOADGAME' @0x73163; LCALL 0x191F:0x16a @0x7317E (run picker), LCALL 0x191F:0x1a8 @0x731A0 (teardown). Same two 0x191F thunks as the save side.

### func_072CC2 — 0x1A (file 0x072CC2..0x072F7A, 696 bytes; entry of the 0x7326b/0x1A1F:0x0CE8 thunk)  [saveload-picker]
**Purpose:** THE SAVE/LOAD SLOT-LIST BUILDER. Creates the picker window, enumerates the COLONY*.SAV slots, and appends one list item per slot (slot display name, or '(EMPTY)' when the file is absent).

**Callers:** func_072F7A @0x7326b, func_073158 @0x73167

**Evidence:** Window-create LCALL 0x191F:0x182 @0x72CF8 with bx=[0x87c] (template-file name ptr) and ax=[bp+6] (section/title key 'SAVEGAME'/'LOADGAME'); returns the window handle into [bp-0x116:bp-0x114]. Per-slot loop: builds the row text via 0xd1d:0x7e4 (strcpy), tests existence via LCALL 0x1A1F:0xd04 -> func_073AB0 @0x72EFD, on absent writes '(EMPTY)' @file 0x20EE @0x72F0C, then APPENDS the list item via LCALL 0x191F:0x176 @0x72EA1 (handle, ss:[bp-0x112] text, index [bp-0x11c]+1). NO explicit per-row x/y/line-height is passed -- the item carries only its text + index.

### func_06F0F4 — 0x17 (file 0x06F0F4..0x06F519, 1061 bytes; target of window-create thunk 0x191F:0x182 -- corrected to 0x06F0F4 via typeA_thunk_targets.json, NOT the disasm-comment 0x028BA4)  [saveload-picker]
**Purpose:** GENERIC DIALOG-TEMPLATE INTERPRETER. Parses a text dialog template (section-keyed) and fills the window geometry/flags from keyword lines. This is where ALL picker geometry actually comes from -- it is DATA-DRIVEN from GAME.TXT, not from code immediates.

**Callers:** func_072CC2 @0x72CF8 (window-create thunk 0x191F:0x182)

**Evidence:** Opens the template via LCALL 0x191F:0x928 @0x06F126 (-> func_06F8FA), reads lines via 0x191F:0x91c @0x06F174, and for each line strcmp's the leading token against the keyword strings at DGROUP: 'OPTIONS' @0x1FC7, 'PROMPT' @0x1FCF, 'TEXT' @0x1FD6, 'SMALLFONT' @0x1FDB, 'Y' @0x1FE5, 'X' @0x1FE7, 'WIDTH' @0x1FE9, 'LENGTH' @0x1FEF, plus 'COLOR'@0x1FF6 / 'HELP'@0x1FFF. Numeric args parsed by atoi 0xd1d:0x8f6 and written into the window struct: X->[handle+0x0c] @0x06F2A6, Y->[handle+0x0e] @0x06F25E, WIDTH-> sizing call cs:0x3d12 @0x06F2F6, LENGTH->[0xa5b6] @0x06F347, SMALLFONT-> pos fields [handle+0x80/+0x82] from [0x89e/0x8a0] @0x06F211. (DGROUP file base = 0x1D9A0, derived from 'SAVEGAME' literal @file 0x1FA96 = DGROUP 0x20F6.)

### func_06F8FA — 0x18 (file 0x06F8FA..0x06FAB9, 447 bytes; target of 0x191F:0x928)  [saveload-picker]
**Purpose:** Dialog-template section opener. Opens the template TEXT file and seeks to the '@<section>' header, so subsequent line reads return that section's keyword lines.

**Callers:** func_06F0F4 @0x06F126

**Evidence:** Builds search token '@'+section: [bp-0x52] pre-set to 0x40 ('@'),0 @0x06F90A then strcat of [bp+8] via 0xd1d:0x7a4 @0x06F919. Builds the filename from [bp+6] (= [0x87c] -> 'GAME', verified: [0x87c] init bytes spell 'GAME' @file 0x1D9A0+0x87C+? region) with format 'TXT' @0x2016 and mode 'rt' @0x201a, fopen via 0x181F:0xe86 into handle [0x2014]. Reads 0x50(80)-byte lines via 0xd1d:0x9ca into [0x833c], strstr's for the '@section' header via 0xd1d:0x816. => template = GAME.TXT, section @SAVEGAME / @LOADGAME.

### func_06C850 — 0x17 (file 0x06C850..0x06CA38, 488 bytes; target of add-item thunk 0x191F:0x176 -- corrected to 0x06C850, NOT disasm-comment 0x026300)  [saveload-picker]
**Purpose:** List-item allocator/linker (the 'add row' primitive). Appends a 0x18-byte node to the window's item linked-list, measures the row text width, and allocates the row's draw buffer. Stores the caller-supplied item INDEX at node+4. Does NOT assign an absolute screen Y -- rows are a linked list, positioned at render time.

**Callers:** func_072CC2 @0x72EA1 (per slot), func_073270 @ multiple

**Evidence:** Walks tail via window [handle+0x54/+0x56] @0x06C858; allocs 0x18-byte node via 0x181F:0x2c @0x06C8A1; links it (node+0x10/+0x14 prev/next); measures text width via 0xd1d:0x113c @0x06C956; stores index [bp+0xe] -> node+4 @0x06C9B8; flags empty rows (node|=1) when text[0]==0 @0x06C9AE. No x/y immediates.

### func_06E3D0 — 0x17 (file 0x06E3D0..0x06EED4, 2820 bytes; target of run-modal thunk 0x191F:0x16a -- corrected to 0x06E3D0, NOT disasm-comment 0x027E80)  [saveload-picker]
**Purpose:** Modal dialog message pump / RUN-PICKER. Draws the window + its item list, hit-tests the mouse against rows, processes keyboard, and returns the chosen slot index+1 (caller does DEC ax). This is where the linked-list rows are actually laid out and drawn, using the window rect + a per-row line-height -- i.e. the row Y positions are computed HERE at runtime, not stored.

**Callers:** func_072F7A @0x72F9B, func_073158 @0x7317E, func_073270 @0x733F6

**Evidence:** Operates on the window struct at [bp+6]; window rect fields [bx+0x10..0x16] (x,y,w,h) @0x06E5BE..; iterates child controls and mouse-region tests against [0x7e8]/[0x7ea] (mouse x/y); keyboard via 0x181F:0x3e0 @0x06E2... ; returns selection. Row line-height is applied inside this loop (runtime), so per-row Y is not a byte immediate.

### func_0789FA — 0x1F (file 0x0789FA..0x078A4A, 80 bytes; target of teardown thunk 0x191F:0x1a8 -- corrected to 0x0789FA)  [saveload-picker]
**Purpose:** Dialog teardown / far-block free. Frees the picker window's allocated memory.

**Callers:** func_072F7A @0x72FB1/@0x73151, func_073158 @0x731A0, func_072CC2 @0x72F37

**Evidence:** Compares the segment [bp+8] to 0xA000 @0x078A04; for normal blocks issues INT 21h AH=49h (DOS Free Memory Block) @0x078A2B with es=[bp+6]. Paired with the window-create alloc.

### func_0759E8 — page 0x1A (file 0x0759E8..0x075F86, ~1438 bytes, ENTER 0x3F4, terminal RETF)  [setup-menu-host]
**Purpose:** New-game open-menu host. Builds/runs the top-level @BEGINMENU menu (NEW WORLD / AMERICA / CUSTOMIZE New World / LOAD Game / View Hall of Fame), reads the player's selection, and dispatches each row. Also hosts the earlier @OPENMENU splash menu and the @AMERICA sub-dialog. Already tagged OPENMENU/MAPTOLOAD in disasm/func_0759E8_unknown.asm.

**Callers:** Reached via the boot/open sequence (no RTLink-thunk caller: xref.py callers 0x0759E8 returns empty); near/far-called within the open flow.

**Evidence:** BEGINMENU key string at file 0x1FCE5 (verified raw bytes b'BEGINMENU\x00'); its DGROUP immediate 0x2345 is loaded by `075C60: lea bx,[0x2345]` then run via `075C64: lcall 0x181f,0x3fe` (menu-run primitive: bx=section-key addr, returns 1-based selection in ax). Selection stored `075C69: mov [bp-0xe0],ax`. Dispatch dec-chain at 075C6D..075C83: sel 0 -> 0x4afd (cancel); sel 1/2/3 -> 0x47f6 (shared world-build setup loop); sel 4 -> 0x495a (LOAD); sel 5 -> 0x4a20 (Hall of Fame). Row2 AMERICA branch `075CDE: cmp [bp-0xe0],2; jne` then `075CE5: lea bx,[0x234f]` (AMERICA key, file 0x1FCEF) + `lcall 0x181f,0x3fe` = the @AMERICA 'Original Americas / Map Editor' sub-dialog (with *.MP imm 0x2357 / MAPTOLOAD imm 0x235c). Row3 CUSTOMIZE branch `075CC4: cmp [bp-0xe0],3; jne 0x484a` then `075CCB: lcall 0x1a1f,0xbe4` -> func_070060.

### func_070060 — page 0x19 (file 0x070060..0x07020F, 431 bytes, ENTER 0x312)  [setup-menu-host]
**Purpose:** Customize-New-World sub-menu (4-row 3-way enums @CLAND/@CCONT/@CTEMP/@CCLIM writing the DGROUP:0x1E7E parameter array). Already decoded; confirmed here as the dispatch target of @BEGINMENU row 3.

**Callers:** func_0759E8 @0x75CCB (only)

**Evidence:** Sole caller is func_0759E8 at file 0x75CCB via thunk 0x1A1F:0xBE4 (byte sig 9a e4 0b 1f 1a, thunk record file 0x1D1D4), resolved by tools/rtlink/xref.py callers 0x070060. func_070060 itself pushes its own key 'CUSTOMIZ' (imm 0x2022, file 0x1F9C2) to menu builder thunk 0x181f:0x44e at 0x070088.

### menu primitive thunk 0x181F:0x3FE — thunk record file 0x1A9EE (type A, window 0x181F)  [setup-menu-host]
**Purpose:** Run-named-menu primitive: input bx = far/near address of an 8-char GAME.TXT section key (e.g. BEGINMENU/AMERICA); returns the 1-based selected row in ax (0 = cancelled). Distinct from the lower-level 0x181F:0x44E menu builder that func_070060/OPENMENU use with explicit x/y/string args.

**Callers:** func_0759E8 @0x75C64, @0x75CE9

**Evidence:** Used twice in func_0759E8: 075C64 (BEGINMENU) and 075CE9 (AMERICA); each immediately preceded by a `lea bx,[<key DGROUP imm>]` and followed by storing ax into a local selection var.

### func_037958 — page_05 (record 4), file 0x037958..0x037A0F (184 bytes), reseg IP 0x0FC8  [advisor-report-fields]
**Purpose:** F2 Religious Adviser report PAINT function. Entry confirmed via xref: reached only through thunk 0x191F:0x40C from the three dispatchers at file 0x2385D (menu-letter 'A'), 0x2BDFB (F-key F2), 0x355AE (top-menu). Resolves to page_05 code_offset 0x37340 + ljmp_off 0x618 = 0x37958 (EXACT function entry). NOTE: this CORRECTS the audit's prior claim that F2 paint = file 0x025F18 in page_02 — that offset used the wrong overlay code base. All eight F2-F9 paint functions live in overlay page_05 (code_offset 0x37340), not page_02.

**Callers:** 0x2385D, 0x2BDFB, 0x355AE (all via lcall 0x191F:0x40C)

**Evidence:** reseg page_05.asm line 576 '; ---- func_037958 size=184 ...'; thunk resolution: overlay_thunks.json trailer page_id=0x05, ljmp_off=0x618, page_05 code_offset=0x37340 => 0x37958; xref.py callers 0x037958 lists the 3 dispatchers via 0x191F:0x40C

### func_037340 (load_report_pik) — page_05, file 0x037340..0x0373C8 (137 bytes), reseg IP 0x09B0  [advisor-report-fields]
**Purpose:** PIK background loader. Pushes data-string 0x11A2 = 'REPORT' (overlay data segment base = file 0x1D9A0, so 0x11A2 -> file 0x1EB42 = "REPORT"), strcat via lcall 0xD1D:0x7E4, appends the report-number arg [bp+6] via lcall 0x181F:0x182 (sprintf), then loads the PIK via lcall 0x181F:0x44E. Reached intra-overlay as 0x191F:0xF4A through the near-trampoline at reseg IP 0x34C3. F2 calls it with arg 2 => REPORT2.PIK (was GUESS, now byte-cited).

**Callers:** all 8 report paint funcs via call 0x34C3 -> 0x191F:0xF4A

**Evidence:** page_05.asm lines 12-58; 'push 0x11a2' then 'lcall 0xd1d,0x7e4'; F2 site page_05.asm line 581-583 'push 2 / push cs / call 0x34c3' and IP 0x34C3 = 'ljmp 0x191f:0xf4a' (page_05.asm line 3842) resolving to 0x37340

### func_0373CA (report teardown / OK-bar painter) — page_05, file 0x0373CA..0x037449 (128 bytes), reseg IP 0x0A3A  [advisor-report-fields]
**Purpose:** Bottom-bar / cleanup painter invoked after body draw. Reached as 0x191F:0xEE8 via near-trampoline at reseg IP 0x34A0. F2 calls it with (-1,-2); func_0373CA remaps -1->0x91 and -2->0x11E, then draws a box via lcall 0x181F:0xCE and an icon/sprite via lcall 0x181F:0x100.

**Callers:** F2..F9 paint funcs via call 0x34A0 -> 0x191F:0xEE8

**Evidence:** page_05.asm lines 60-103; F2 site lines 629-633 'push -1 / push -2 / push cs / call 0x34a0', IP 0x34A0 = 'ljmp 0x191f:0xee8' (page_05.asm line 3835) -> 0x373CA

### func_030550 (set_current_power) — page_04, file 0x030550..0x030564 (21 bytes), reseg IP 0x0A60  [advisor-report-fields]
**Purpose:** Every report paint func calls this FIRST with the power_idx [bp+6] via lcall 0x181F:0x582 (type-A, page_id 0x04, resolves to 0x30550). It stores power_idx at [0x9E12], computes power_idx*0x13C + 0x8808, and stores the result at [0x84FC] (active PowerRecord pointer). BYTE-VERIFIES PowerRecord stride = 0x13C (316) and base = DGROUP:0x8808 — values the audit previously asserted from 'project memory'.

**Callers:** all F2-F9 paint funcs (first lcall 0x181F:0x582)

**Evidence:** page_04.asm lines 12-20: 'mov ax,[bp+6]; mov [0x9e12],ax; imul ax,ax,0x13c; add ax,0x8808; mov [0x84fc],ax'

### func_002B38 (set-color + draw-text primitive) — resident load_image, file 0x002B38..0x002B71 (58 bytes)  [advisor-report-fields]
**Purpose:** The combined text primitive behind lcall 0x181F:0x13C. Sets text color via lcall 0xC28:0xA (the palette-color setter) then draws the string via lcall 0xC11:0xC (text-draw-with-rect, using region globals [0x89E]/[0x8A0]). Call convention at F2 site: push color, push y, push x, push ss:strptr. F2 draws the formatted body string with color=0xF(15), y=0x19(25), x=0x0A(10).

**Callers:** F2 (0x181F:0x13C), F5, F9 and most report bodies

**Evidence:** func_002B38_unknown.asm lines 13-37: lcall 0xc28,0xa then lcall 0xc11,0xc; F2 call site page_05.asm lines 621-628 'push 0xf / push 0x19 / push 0xa / lea [bp-0x28] / push ss / push ax / lcall 0x181f,0x13c'

### func_002EE4 (sprite/bitmap blit) — resident load_image, file 0x002EE4..0x00304A (358 bytes)  [advisor-report-fields]
**Purpose:** The sprite-sheet blit primitive behind lcall 0x181F:0x236. Uses the far sheet pointer [0x83E]/[0x840] with per-row shift/clip and lcall 0xC36:0xA. NOT a string draw. F2 invokes it with sprite index ax=0x39 (57) and two PowerRecord-derived params (bx=[0x84FC+0x2E], dx=[0x84FC+0x30]) to draw the religious progress graphic.

**Callers:** F2 paint (0x181F:0x236)

**Evidence:** func_002EE4_unknown.asm lines 62-70 push [0x840]/[0x83e] + lcall 0xc36,0xa; F2 site page_05.asm lines 602-610 'push 0x12c/push 0/push 0/push 1/ mov bx,[0x84fc]+0x2e / mov dx,[+0x30] / mov ax,0x39 / lcall 0x181f,0x236'

### func_064A10 — overlay page 0x14 (code/VICEROY/disasm_overlay_reseg/page_14.asm line 1644)  [lostcity-0x10-bit]
**Purpose:** Map generator / scenario seeder. Prologue ENTER 0x3C,0 @0x64A10. First act @0x64A23 stores random_int(0,0x7fff) (lcall 0x181f:0x4d4) into word [0x190] — the global map seed func_006188 hashes. Two fixed-coordinate tile-feature writes: @0x65C0D coords (1,0x15) and @0x65C21 coords (0x44,0x2b), each `26 80 0f a0` = or byte ptr es:[bx],0xa0, pointer from tile helper lcall 0x181f:0x70e (@0x65C01/@0x65C15).

**Callers:** map-load/scenario-gen path (cmp [bp+6],0 generator-mode gate near 0x64A2C; cmp [0x2174] map-loaded flag per prior spec note)

**Evidence:** page_14.asm lines 1645-1653 (enter+seed init), 3177-3194 (the two or es:[bx],0xa0 writes with their 0x181f:0x70e tile-pointer setups and the immediately-following lcall 0xd1d:0xdae). Raw bytes at file 0x65C0D and 0x65C21 = 26 80 0f a0.

### func_006188 — resident (code/VICEROY/disasm/func_006188_unknown.asm), file 0x6188..0x61E3 (91 bytes)  [lostcity-0x10-bit]
**Purpose:** Rumor-presence predicate, called per tile entry. Returns presence procedurally — NO stored 0xA0/0xB0 marker read. Gates: seed [0x190]!=0 (@0x6191); terrain via lcall 0x3e4:0x3a rejecting 0x18/0x19/0x1a arctic/ocean/sealane (@0x61A6-0x61B3); feature high-nibble via call 0x5df0 then cwde/or ax,ax/jge-fail @0x61C5 (requires nibble==0xF, i.e. reader returned -1); then coordinate hash ((x>>2)*0x13 + (y>>2)*0x11 + ...) @0x61C7+. Contains no cmp to 0xA0 or 0xB0.

**Callers:** per-tile-entry rumor check (per prior spec note @0x30822)

**Evidence:** func_006188_unknown.asm lines 13-46: ENTER 8,0; CMP [0x190],0/JE; terrain lcall + CMP ax,0x19/0x1a/0x18 each JE-suppress; CALL 0x5df0; CWDE; OR ax,ax; JGE 0x61ff (suppress); then AND ax,3 / SAR/IMUL hash. No 0xB0/0xA0 immediate present.

### func_005DF0 — resident, file 0x5DF0 (~0x2E bytes)  [lostcity-0x10-bit]
**Purpose:** Tile feature HIGH-nibble reader. Reads tile byte (call inner 0x5d9c-region via lcall), shr al,4, sub ah,ah, then cmp ax,0x0f; jne; if nibble==0xF returns -1 (the 'none' sentinel func_006188 requires). The generator's stored 0xA high-nibble makes this return >=0, so func_006188's jge-fail SUPPRESSES a rumor on the two 0xA0 tiles.

**Callers:** func_006188 @0x61BC

**Evidence:** raw bytes @0x5DF0: c8020000 ff7608 ff7606 0e e89eff 83c404 c0e804(shr al,4) 2ae4(sub ah,ah) 8946fe 3d0f00(cmp ax,0xf) 7505 c746feffff(mov [bp-2],-1) ... cbcb. Confirms shr-4 high-nibble extraction and 0xF->-1.

### func_061454 — resident, file 0x61454  [lostcity-0x10-bit]
**Purpose:** Lost-City outcome HANDLER (consumer), invoked AFTER func_006188 signals presence. Does NOT read or compare any stored tile marker: an immediate scan of its body (0x61454..0x61D00) for cmp al,0xa0 (3c a0) and cmp al,0xb0 (3c b0) returns zero matches. Builds LOSTCITY+digit and rolls outcomes per existing §2/§3.

**Callers:** rumor-entry path

**Evidence:** byte scan of 0x61454..0x61D00: zero `3c a0` and zero `3c b0`. Consistent: no marker comparison; presence already decided procedurally upstream.



---

## Track 4 additions (2026-06-25) — input dispatch, hit-tests, report renderer

(The map-key-dispatch target is intentionally EXCLUDED: its agent mislabeled func_070060
— the Customize new-game menu — as an in-game map picker. See RULINGS 2026-06-25.)

### func_004B16 (point-in-rect, thunk 0x181F:0x3CA → ljmp 0x0262:0x00F6) — @0x4B16  [click-region-ownership]
**Purpose:** THE consumer of mouse globals 0x7E8/0x7EA. Tests a rect against current mouse pos: [bp+6]=x cmp [0x7E8], right edge = x+[bp+0xA]-1; [bp+8]=y cmp [0x7EA], bottom = y+[bp+0xC]-1. Returns AX=1 if inside, 0 if not. Stack arg order (cdecl): [bp+6]=x,[bp+8]=y,[bp+0xA]=w,[bp+0xC]=h → callers push h,w,y,x (reverse).

**Callers:** per-screen hit-test rect tables func @0x299A0 (colony), func @0x3200A (europe), and the runtime list-hit at @0x691F9

**Evidence:** @0x4B1C mov dx,[0x7e8]; @0x4B20 cmp bx,dx; @0x4B24 add bx,[bp+0xa]; dec bx; @0x4B2C mov dx,[0x7ea]; @0x4B30 mov bx,[bp+8]; @0x4B37 add bx,[bp+0xc]; thunk record @0x1A9BA = 9a 91 0d 0d 11 ea f6 00 62 02 → file 0x4B16

### colony-screen click hit-test (per-screen rect table) — func @0x299A0 (enter 2,0 @0x299A0; default id 0x14)  [click-region-ownership]
**Purpose:** Maps a click to a colony-screen region id by testing 9 static rects via func_004B16 (0x181F:0x3CA). Rects match colony_screen.md paint rects 1:1 (flag panel 303,132,17,45; SoL/cargo panel 211,130,91,48; surrounding-tile minimap 121,130,84,48; colonist plaza 0,130,120,48; stockpile strip 0,179,305,21; warehouse readout 305,179,15,21; top title bar 0,0,320,7).

**Callers:** reached via overlay/colony-screen input loop (overlay-resident; not a static lcall) — TBD caller

**Evidence:** @0x299A4 mov [bp-2],0x14 (default); 9 push-blocks: @0x299A9 (200,8,120,120)->1; @0x299D2 (305,179,15,21)->9; @0x299F1 (0,130,120,48)->0; @0x29A11 (0,8,199,120)->2; @0x29A32 (303,132,17,45)->3; @0x29A52 (0,179,305,21)->5; @0x29A70 (211,130,91,48)->4; @0x29A8D (121,130,84,48)->8; @0x29AA9 (0,0,320,7)->0xA. Each block: push h,push w,push y,push x; lcall 0x181f,0x3ca; or ax,ax; je next; mov [bp-2],id

### europe-screen click hit-test (per-screen rect table) — func @0x3200A (enter 2,0 @0x3200A; default id 0xF)  [click-region-ownership]
**Purpose:** Maps a click to a Europe-screen region id by testing 7 static rects via func_004B16 (0x181F:0x3CA). Confirms and supersedes the prior europe_screen.md §4 table; the previously-cited offset 0x032034 is the body of the SECOND rect block (id 5), not the function entry — the function starts at 0x3200A.

**Callers:** overlay-resident Europe input loop (not a static lcall) — TBD caller

**Evidence:** @0x32013 mov [bp-2],0xf (default); 7 push-blocks: @0x3201D (305,179,15,21)->0xB; @0x3203D (281,89,37,32)->5; @0x3205E (0,179,305,21)->0; @0x3207D (143,118,81,60)->1; @0x3209C (72,118,70,48)->2; @0x320BA (1,118,70,51)->3; @0x320D7 (224,120,96,59)->4

### map-view runtime list hit-test — @0x691F9 (rect computed at runtime)  [click-region-ownership]
**Purpose:** Iterates a live list (count [0xA5AA]); per item computes screen x/y via call 0x6B6AB into [bp-2]/[bp-4], then point-in-rect with fixed w=0x64(100), h=7. Top branch tests mouse-X vs 0xA0 (160) to pick a side ([bp-8]=-2 left / -3 right). This is RUNTIME-driven, not a static rect table.

**Callers:** map-view overlay

**Evidence:** @0x691B4 cmp word [0x7e8],0xa0; @0x691E3 call 0x6b6ab; @0x691EF push 7;push 0x64;push [bp-4];push [bp-2]; @0x691F9 lcall 0x181f,0x3ca

### func_037958 (page_05, file 0x037958..0x037A0F, reseg IP 0x0FC8, 184 bytes) — 0x05  [report-field-layout]
**Purpose:** F2 Religious Adviser report paint function — the renderer named in the task. Read all 67 instructions. It: (1) lcall 0x181f:0x582 set_current_power([bp+6]=power_idx); (2) push 2 / call 0x34c3 -> load_report_pik(2) => REPORT2.PIK; (3) full-screen PIK blit via lcall 0x181f:0x100; (4) sprite blit idx 0x39 via lcall 0x181f:0x236 at (bx=[0x84fc]+0x2e, dx=[0x84fc]+0x30); (5) IF test byte[0x5383]&0x20: sprintf '(%d of %d)' into [bp-0x28] then draw it via lcall 0x181f:0x13c with pushed args 0xf,0x19,0xa; (6) OK bar via call 0x34a0; (7) present/flush. NO title-bar painter call exists in the function — the heading is REPORT2.PIK artwork.

**Callers:** reached ONLY via thunk 0x191F:0x40C from dispatchers 0x2385D / 0x2BDFB / 0x355AE, confirmed by tools/rtlink/xref.py callers 0x037958.

**Evidence:** page_05.asm lines 577-643: line 581 'push 2'; lines 611-612 'test byte ptr [0x5383],0x20 / je 0x105c'; line 616 'push 0x11a9'; lines 621-627 'push 0xf / push 0x19 / push 0xa / lea ax,[bp-0x28] / push ss / push ax / lcall 0x181f,0x13c'; lines 606-610 sprite at [0x84fc]+0x2e/+0x30, ax=0x39, lcall 0x181f,0x236.

### func_002B38 (resident, file 0x002B38..0x002B72, 58 bytes) — resident  [report-field-layout]
**Purpose:** The text-draw primitive invoked by func_037958's body line. Confirmed = the target of thunk 0x181F:0x013C (thunks_resolved.json: type B, target_file_offset 0x002B38, resident). Decoded its arg order to prove the (%d of %d) pen position: di=[bp+0xa]=x, dx=[bp+0xc]=y, si=[bp+0xe]=color, far string ptr at [bp+6]/[bp+8]. Internally it sets text color via lcall 0xC28:0xA (ax=0xffff, color in stack) then draws text via lcall 0xC11:0xC using globals [0x89e]/[0x8a0] and region ptr [0x2da8]. Matching the call site pushes (0xf,0x19,0xa,ss,buf) gives x=10, y=25, color=15.

**Callers:** func_037958 @ page_05.asm line 627 (lcall 0x181f,0x13c).

**Evidence:** func_002B38_unknown.asm lines 17-32: 'MOV di,[bp+0xa]' / 'MOV si,[bp+0xe]' / 'LCALL 0xc28,0xa' (set color) / 'MOV dx,[bp+0xc]' / 'LCALL 0xc11,0xc' (draw text). thunks_resolved.json key 0x181F:0x013C -> target_file_offset 0x002B38.

### func_002EE4 (resident, file 0x002EE4..0x00304A) — resident  [report-field-layout]
**Purpose:** The sprite-blit primitive = target of thunk 0x181F:0x0236 (thunks_resolved.json type B -> 0x002EE4). func_037958 calls it with ax=0x39 (sprite index 57) and pen from PowerRecord +0x2E/+0x30. Blits from sheet ptr globals [0x83e]/[0x840]. Confirms the F2 'domain graphic' is sprite 57 at a runtime-driven position.

**Callers:** func_037958 @ page_05.asm line 610.

**Evidence:** func_002EE4_unknown.asm lines 62-63 'PUSH [0x840] / PUSH [0x83e]' (sheet ptr). thunks_resolved.json key 0x181F:0x0236 -> 0x002EE4.

### func_037340 (load_report_pik, page_05) — 0x05  [report-field-layout]
**Purpose:** PIK background loader. Concatenates data-segment string 'REPORT' (overlay offset 0x11A2) with the literal report number and loads the .PIK. For F2 the literal is 2 (page_05.asm line 581) => REPORT2.PIK. Used to confirm the background string offsets resolve to real EXE bytes.

**Callers:** func_037958 via near-call 0x34c3 (= 0x191F:0xF4A).

**Evidence:** raw/COLONIZE/VICEROY.EXE @0x1EB42 = bytes 'REPORT\0' (overlay data base 0x1D9A0 + 0x11A2 = 0x1EB42); @0x1EB49 = '(%d of %d)\0' (0x1D9A0 + 0x11A9 = 0x1EB49). Both read directly from the EXE.

### func_00D106 (mouse poll / edge-detector) @0xD106 — resident (code/VICEROY/disasm/func_00D106_unknown.asm + raw VICEROY.EXE)  [button-bit-0x7E4]
**Purpose:** Central mouse poll/edge-detector. Latches get_pos() result into the input-global block (0x7E4..0x7FA): snapshots prev x/y (0x7F8/0x7FA), calls get_pos (LCALL 0xA58:0x38B @0xD11B), stores raw buttons AX->0x7E6 (@0xD122), computes press/release/down edges, and on a fresh press down-edge writes the left/right discriminator to 0x7E4 (@0xD1AE).

**Callers:** 0xD106 is the central poll; its callers are the per-screen UI loops (not enumerated here). Only writer of 0x7E4 is 0xD1AE (verified: 'A3 E4 07' occurs exactly once in the image). Readers all test [0x7e4]==0 vs nonzero: e.g. @0x2438A,0x29C91,0x6ECBC,0x2A038 (cmp word [0x7e4],0).

**Evidence:** Disasm of 0xD1A2-0xD1AE re-verified from raw bytes (capstone CS_MODE_16): 0xD1A2 8A C3 mov al,bl ; 0xD1A4 25 01 00 and ax,1 ; 0xD1A7 3D 01 00 cmp ax,1 ; 0xD1AA 1B C0 sbb ax,ax ; 0xD1AC F7 D8 neg ax ; 0xD1AE A3 E4 07 mov [0x7e4],ax. BX was loaded from [0x7E6] at 0xD131 (8B 1E E6 07). The whole 0xD19C-0xD1AE block is gated by 'or dx,dx / je 0xd1b1' at 0xD198 (dx = fresh-press down-edge, set =1 at 0xD159 when bx!=0 and prev buttons [0x7EE]==0).

### get_pos @0xCD0B — resident segment 0xA58 module_off 0x38B  [button-bit-0x7E4]
**Purpose:** Public mouse poll; returns buttons in AX (driver int 0x33 AX=3 returns BX bitmask bit0=left, bit1=right). 0xD106 latches this AX into 0x7E6 at 0xD122, so bl&1 = left-button bit.

**Callers:** (n/a)

**Evidence:** Already byte-cited in spec §1/§2 (0xCD2E int 0x33 AX=3; 0xCD47 returns buttons in AX). 0xD122 'A3 E6 07' stores that AX to 0x7E6.

