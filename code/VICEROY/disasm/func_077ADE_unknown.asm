; ============================================================================
; func_077ADE_unknown
; Region   : overlay
; Bytes    : file 0x077ADE..0x077B0F  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

077ADE  55                    PUSH   bp ; STACK_PUSH
077ADF  8B EC                 MOV    bp, sp ; MOV
077AE1  9A E2 05 1F 18        LCALL  0x181f, 0x5e2 ; THUNK -> 0x1047:0x011F (thunk @file 0x01ABD2 type B) overlay @file 0x030D7D
077AE6  0B C0                 OR     ax, ax ; LOGIC
077AE8  74 0E                 JE     0x77af8 ; CJUMP
077AEA  6A 00                 PUSH   0 ; STACK_PUSH
077AEC  9A DE 04 1F 18        LCALL  0x181f, 0x4de ; THUNK -> 0x1059:0x000A (thunk @file 0x01AACE type B)
077AF1  8B E5                 MOV    sp, bp ; MOV
077AF3  9A D8 05 1F 18        LCALL  0x181f, 0x5d8 ; THUNK -> 0x1059:0x005F (thunk @file 0x01ABC8 type B)
077AF8  9A CE 05 1F 18        LCALL  0x181f, 0x5ce ; THUNK -> 0x0A29:0x01D1 (thunk @file 0x01ABBE type B) overlay @file 0x030CDE
077AFD  6A 03                 PUSH   3 ; STACK_PUSH
077AFF  6A 00                 PUSH   0 ; STACK_PUSH
077B01  9A C4 05 1F 18        LCALL  0x181f, 0x5c4 ; THUNK -> 0x0A58:0x008C (thunk @file 0x01ABB4 type B)
077B06  8B E5                 MOV    sp, bp ; MOV
077B08  B8 03 00              MOV    ax, 3 ; MOV
077B0B  CD 10                 INT    0x10 ; SYS
077B0D  C9                    LEAVE ; EPILOGUE
077B0E  CB                    RETF ; RETURN
