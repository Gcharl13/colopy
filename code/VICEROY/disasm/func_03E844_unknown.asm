; ============================================================================
; func_03E844 — sons_of_liberty_active_check  (BYTE_VERIFIED 2026-05-04)
; ----------------------------------------------------------------------------
; Tests whether [bp+6] (a power_idx) matches the active player AND
; (during revolution) matches the intervention power. Sets local
; "is_local_active" flag and gates the SoL/REBELUP reporting branch.
;
; Args:
;   [bp+6]  power_idx
; Locals:
;   [bp-2]  is_local_active (1 if matches both checks, else 0)
; Globals:
;   [0x5398] word  active_power_idx
;   [0x53D2] word  intervention_power_idx (during revolution)
;   [0x5382] byte  revolution_flags (bit 0 = independence declared)
;
; Pseudo-C:
;   void sons_of_liberty_active_check(int power_idx) {
;       int is_local_active = (power_idx == g_active_power_5398) ||
;           ((g_revolution_flags_5382 & 1) &&
;            power_idx == g_intervention_power_53D2);
;       if (g_revolution_flags_5382 & 1) {
;           if (!is_local_active) return;
;           // call same-segment helper for SoL display
;           subfunc_3EA4C(power_idx);
;       }
;   }
;
; Region : overlay
; Bytes  : file 0x03E844..0x03E883 (63 bytes detected; body continues)
; Status : BYTE_VERIFIED (visible portion)
; Strings: REBELUP, REBELUP50, REBELDOWN (all displayed by callee)
; ============================================================================

03E844  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
03E848  A1 98 53              MOV    ax, word ptr [0x5398] ; GLOBAL_LOAD
03E84B  39 46 06              CMP    word ptr [bp + 6], ax ; CMP
03E84E  74 0F                 JE     0x3e85f ; CJUMP
03E850  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03E855  74 0F                 JE     0x3e866 ; CJUMP
03E857  A1 D2 53              MOV    ax, word ptr [0x53d2] ; GLOBAL_LOAD
03E85A  39 46 06              CMP    word ptr [bp + 6], ax ; CMP
03E85D  75 07                 JNE    0x3e866 ; CJUMP
03E85F  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
03E864  EB 05                 JMP    0x3e86b ; JUMP
03E866  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
03E86B  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03E870  74 16                 JE     0x3e888 ; CJUMP
03E872  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
03E876  75 03                 JNE    0x3e87b ; CJUMP
03E878  E9 06 01              JMP    0x3e981 ; JUMP
03E87B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03E87E  0E                    PUSH   cs ; STACK_PUSH
03E87F  E8 CA 01              CALL   0x3ea4c ; CALL_NEAR
03E882  83                    DB     0x83 ; DATA_BYTE
