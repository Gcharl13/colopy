; ============================================================================
; func_01427B_rtlink_loader_A
; Region   : load_image
; Bytes    : file 0x01427B..0x014293  (24 bytes)
; Purpose  : Type-A entry point for the RTLink Plus overlay runtime. Called from the second instruction of every type-A thunk in the overlay-thunk table at 0x1A5F0. Sets cs:[0x39F1] = 0 (the runtime DOES need to patch the LJMP's segment word with the actual runtime address of the loaded overlay segment), then falls through to the shared loader body at 0x14293. Called approximately 127 times per game session — the single most-called load-image function.
; Args     : Saved CS:IP from the LCALL is on the stack, pointing at the LJMP that immediately follows the LCALL in the calling thunk. The LJMP's target seg:off identifies which overlay segment to load.
; Returns  : Far return path (see rtlink_loader_B).
; Callers  : Every type-A thunk in the table at 0x1A5F0..0x1D5E6 (658 thunks).
; Callees  : rtlink_loader_shared at 0x14293 (via fall-through).
; Verified : Boundary verified: PUSHF / CLI prologue at 0x1427B; falls through into 0x14293 at 0x14293.
; Source   : manually identified by tracing the LCALL target of the type-A thunk pattern.
; ============================================================================

01427B  9C                    PUSHF ; STACK_PUSH
01427C  FA                    CLI ; FLAG
01427D  2E F6 06 E1 39 FF     TEST   byte ptr cs:[0x39e1], 0xff ; LOGIC
014283  75 D7                 JNE    0x1425c ; CJUMP
014285  2E F6 06 DE 39 0C     TEST   byte ptr cs:[0x39de], 0xc ; LOGIC
01428B  75 CF                 JNE    0x1425c ; CJUMP
01428D  2E C6 06 F1 39 00     MOV    byte ptr cs:[0x39f1], 0 ; GLOBAL_LOAD
