; ============================================================================
; func_014261_rtlink_loader_B
; Region   : load_image
; Bytes    : file 0x014261..0x01427B  (26 bytes)
; Purpose  : Type-B entry point for the RTLink Plus overlay runtime. Called from the second instruction of every type-B thunk in the overlay-thunk table at 0x1A5F0. Sets cs:[0x39F1] = 0x52 to mark this call as 'no relocation patch needed' (the runtime will load the overlay segment but the LJMP's segment word does not need rewriting), then jumps to the shared loader body at 0x14293. Called approximately 109 times per game session (most-called load-image function after the type-A entry).
; Args     : Saved CS:IP from the LCALL is on the stack, pointing at the LJMP that immediately follows the LCALL in the calling thunk. The LJMP's target seg:off identifies which overlay segment to load.
; Returns  : Far return path: after the runtime loads the overlay (if needed), the shared body re-pushes the saved CS:IP and the calling thunk's RET reactivates the LJMP, which transfers control to the overlay function. This is a register-preserving call.
; Callers  : Every type-B thunk in the table at 0x1A5F0..0x1D5E6 (362 thunks).
; Callees  : rtlink_loader_shared at 0x14293 (via JMP at 0x14279).
; Verified : Boundary verified: PUSHF / CLI prologue at 0x14261; ends with JMP 0x14293 at 0x14279. 26 bytes prefix.
; Source   : manually identified by tracing the LCALL target of the type-B thunk pattern.
; ============================================================================

014261  9C                    PUSHF ; STACK_PUSH
014262  FA                    CLI ; FLAG
014263  2E F6 06 E1 39 FF     TEST   byte ptr cs:[0x39e1], 0xff ; LOGIC
014269  75 F4                 JNE    0x1425f ; CJUMP
01426B  2E F6 06 DE 39 0C     TEST   byte ptr cs:[0x39de], 0xc ; LOGIC
014271  75 EC                 JNE    0x1425f ; CJUMP
014273  2E C6 06 F1 39 52     MOV    byte ptr cs:[0x39f1], 0x52 ; GLOBAL_LOAD
014279  EB 18                 JMP    0x14293 ; JUMP
