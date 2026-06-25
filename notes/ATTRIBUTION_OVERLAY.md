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

