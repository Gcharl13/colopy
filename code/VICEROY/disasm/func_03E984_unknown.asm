; ============================================================================
; func_03E984 — declaration_already_made_guard  (BYTE_VERIFIED 2026-05-04)
; ----------------------------------------------------------------------------
; If the player has already declared independence (flag bit 0 of [0x5382]
; set), display the GAME.TXT @ALREADYREVOLUTION message and return early.
; Used as a guard at the start of any "Declare Independence" dialog flow.
;
; Pseudo-C:
;   void declaration_already_made_guard(void) {
;       if (g_revolution_flags_5382 & 1) {
;           display_text_key(1, "ALREADYREVOLUTION");
;       }
;   }
;
; Globals:
;   [0x5382] byte revolution_flags
;     bit 0 = independence already declared
;
; Region : overlay
; Bytes  : file 0x03E984..0x03E99E (26 bytes)
; Status : BYTE_VERIFIED
; ============================================================================

03E984  C8 02 00 00           ENTER  2, 0                          ; trivial 2-byte frame
03E988  F6 06 82 53 01        TEST   byte ptr [0x5382], 1          ; if independence_already_declared
03E98D  74 0F                 JE     0x3e99e                       ;   skip
03E98F  6A 01                 PUSH   1                             ; arg2 = msg_kind = 1 (info popup)
03E991  68 74 13              PUSH   0x1374                        ; arg1 = string "ALREADYREVOLUTION"
03E994  9A 52 06 1F 18        LCALL  0x181f, 0x652                 ; display_text_key(arg1, arg2)
                                                                   ; THUNK -> 0x0000:0x37A2 (overlay @file 0x0290A2)
03E999  83 C4 04              ADD    sp, 4                         ; clean up 4 bytes of stack args
03E99C  C9                    LEAVE                                 ; tear down frame
03E99D  CB                    RETF                                  ; far return
