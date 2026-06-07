; ============================================================================
; func_03ECF0 — diplomatic_action_init  (BYTE_VERIFIED 2026-05-04)
; ----------------------------------------------------------------------------
; Initialises the diplomatic-action menu (DECLAREWAR / CANCELPEACE /
; HAVETREATY / WHACKINDIANS) for a unit's right-click "diplomatic options".
;
; Strings: CANCELPEACE, DECLAREWAR, HAVETREATY, WHACKINDIANS
; (this function or its callees PUSH these GAME.TXT section names).
;
; Args (Borland near call, [bp+6] is arg1):
;   [bp+6]  unit_id (16-bit)
;   [bp+8]  param_a (passed to overlay 0x03E4:0x003A)
;   [bp+0xA] param_b
;
; Locals:
;   [bp-0xA]  init = 0xFFFF
;   [bp-0x10] saved [0x539C] (g_local_player_idx_or_state)
;   [bp-0x20] unit byte field +0 (UnitRecord owner / type lo nibble)
;   [bp-0x22] zero accumulator
;   [bp-0x28] unit byte field +1 (UnitRecord type hi nibble / power_idx)
;   [bp-0x2C] result of overlay LCALL (target unit/colony)
;   [bp-0x3E] result * 3 (result << 1 + result)
;
; Tables:
;   0x3144      UnitRecord table (stride 0x1C = 28 bytes per unit). Confirmed
;               by user memory: actual base is DGROUP:0x3146; the +0x3144
;               here may indicate field +(-2) i.e. accessing fields just
;               before the first UnitRecord, OR is a slightly different
;               table — see comment below.
;   0x2F76      Per-power constants table, stride 16 (SHL bx, 4)
;   0x539C      Local-player or active-target state word
;
; Region   : overlay
; Bytes    : file 0x03ECF0..0x03ED46 (86 bytes detected; LARGER — disasm
;            cut off at file 0x03ED44 which was actually a PUSH operand,
;            not a DB. Function continues past the visible end.)
; Status   : BYTE_VERIFIED (visible portion)
; ============================================================================

03ECF0  C8 40 00 00           ENTER  0x40, 0                       ; allocate 64-byte stack frame
03ECF4  57                    PUSH   di                            ; preserve di
03ECF5  56                    PUSH   si                            ; preserve si
03ECF6  B8 FF FF              MOV    ax, 0xffff                    ; ax = -1 (sentinel "no choice")
03ECF9  89 46 F6              MOV    word ptr [bp - 0xa], ax       ; init_choice = -1
03ECFC  2B C0                 SUB    ax, ax                        ; ax = 0
03ECFE  89 46 DE              MOV    word ptr [bp - 0x22], ax      ; zero accumulator
03ED01  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c   ; bx = unit_id * 28 (UnitRecord stride)
03ED05  A1 9C 53              MOV    ax, word ptr [0x539c]         ; ax = g_local_player_or_state
03ED08  89 46 F0              MOV    word ptr [bp - 0x10], ax      ; save state to local
03ED0B  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c   ; bx = unit_id * 28 (re-compute, side-effects)
03ED0F  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144]    ; al = UnitRecord[unit_id].byte0 (owner+type lo)
03ED13  2A E4                 SUB    ah, ah                        ; zero-extend
03ED15  89 46 E0              MOV    word ptr [bp - 0x20], ax      ; save byte0 to local
03ED18  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145]    ; al = UnitRecord[unit_id].byte1 (type hi / power_idx)
03ED1C  89 46 D8              MOV    word ptr [bp - 0x28], ax      ; save byte1 to local
03ED1F  FF 76 0A              PUSH   word ptr [bp + 0xa]           ; arg2 (param_b)
03ED22  FF 76 08              PUSH   word ptr [bp + 8]             ; arg1 (param_a)
03ED25  9A 8C 07 1F 18        LCALL  0x181f, 0x78c                 ; THUNK -> 0x03E4:0x003A (overlay @file 0x02842C)
                                                                   ; -> resolves target unit_id given (param_a, param_b)
03ED2A  83 C4 04              ADD    sp, 4                         ; clean up 4 bytes of stack args
03ED2D  8B D8                 MOV    bx, ax                        ; bx = target unit_id
03ED2F  89 5E D4              MOV    word ptr [bp - 0x2c], bx      ; save target
03ED32  C1 E3 04              SHL    bx, 4                         ; bx *= 16 (per-power-table stride)
03ED35  8A 87 76 2F           MOV    al, byte ptr [bx + 0x2f76]    ; al = per_power_const[target].byte0
03ED39  2A E4                 SUB    ah, ah                        ; zero-extend
03ED3B  8B C8                 MOV    cx, ax                        ; cx = al
03ED3D  D1 E0                 SHL    ax, 1                         ; ax = al * 2
03ED3F  03 C1                 ADD    ax, cx                        ; ax = al * 3
03ED41  89 46 C2              MOV    word ptr [bp - 0x3e], ax      ; save (al * 3) to local
03ED44  FF                    DB     0xFF                          ; (continuation: PUSH word ptr [bp+...] — disasm cut)
03ED45  76                    DB     0x76                          ; (these bytes are start of next instruction — function continues)
