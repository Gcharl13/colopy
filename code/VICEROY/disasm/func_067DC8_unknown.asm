; ============================================================================
; func_067DC8 — compute_dialog_rect_from_cursor (BYTE_VERIFIED 2026-05-03)
; ----------------------------------------------------------------------------
; Computes a dialog/popup pixel rect and writes it to the 4 globals at
; [0x839E..0x83A4] via the setter at overlay 0x0C36:0x000A.
;
; Inputs (DGROUP globals):
;   [0x174]  word  cursor_x         (set by 0x0765AC)
;   [0x176]  word  cursor_y         (set by 0x0765AF)
;   [0x186]  word  dialog_state     (>= 0x64 enables popup; writer TBD)
;   [0x1EA4] byte  char_width_cols  (parsed from GAME.TXT @width; writer TBD)
;   [0x1EA5] byte  char_height_rows (writer TBD)
;   [0xA5A4] word  font_cell_width  (set by 0x068771)
;   [0xA5A6] word  font_cell_height (set by 0x06872C)
;
; Outputs (struct at &[0x839E] passed via BX to overlay 0x0C36:0x000A):
;   The setter writes 4 stack args (right-to-left order) into the struct.
;   Mapping of arg → [0x839E..0x83A4] field is TBD until segment 0x0C36
;   is resolved to a file offset (Day-6 work).
;
;   Computed values that flow into the rect:
;     dx = font_cell_width  + char_width_cols  - 8   (left-padded)
;     cx = font_cell_height + char_height_rows - 0xF (top-padded)
;     cursor_x and cursor_y from [0x174], [0x176]
;
; Region   : overlay
; Bytes    : file 0x067DC8..0x067E09  (65 bytes)
; Status   : BYTE_VERIFIED — see docs/DIALOG_GEOMETRY.md
; ============================================================================

067DC8  C8 04 00 00           ENTER  4, 0                         ; reserve 4-byte stack frame
067DCC  8B 0E 74 01           MOV    cx, word ptr [0x174]         ; cx = cursor_x
067DD0  8B 16 76 01           MOV    dx, word ptr [0x176]         ; dx = cursor_y
067DD4  89 4E FC              MOV    word ptr [bp - 4], cx        ; save cursor_x to local
067DD7  89 56 FE              MOV    word ptr [bp - 2], dx        ; save cursor_y to local
067DDA  83 3E 86 01 64        CMP    word ptr [0x186], 0x64       ; if dialog_state < 100 (0x64)
067DDF  7C 29                 JL     0x67e0a                      ;   skip popup setter call
067DE1  52                    PUSH   dx                           ; arg4 (last) = cursor_y
067DE2  51                    PUSH   cx                           ; arg3 = cursor_x
067DE3  8A 0E A5 1E           MOV    cl, byte ptr [0x1ea5]        ; cl = char_height_rows
067DE7  2A ED                 SUB    ch, ch                       ; cx = ZERO-extend cl
067DE9  03 0E A6 A5           ADD    cx, word ptr [0xa5a6]        ; cx += font_cell_height
067DED  83 E9 0F              SUB    cx, 0xf                      ; cx -= 0xF (top padding)
067DF0  51                    PUSH   cx                           ; arg2 = computed Y
067DF1  8A 16 A4 1E           MOV    dl, byte ptr [0x1ea4]        ; dl = char_width_cols
067DF5  2A F6                 SUB    dh, dh                       ; dx = ZERO-extend dl
067DF7  03 16 A4 A5           ADD    dx, word ptr [0xa5a4]        ; dx += font_cell_width
067DFB  83 EA 08              SUB    dx, 8                        ; dx -= 8 (left padding)
067DFE  8D 1E 9E 83           LEA    bx, [0x839e]                 ; bx = &dialog_rect (struct base)
067E02  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B); setter writes 4 args via BX
067E07  C9                    LEAVE                               ; tear down frame
067E08  C3                    RET                                 ; near return (Borland ENTER convention)
