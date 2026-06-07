; ============================================================================
; func_067E8C — compute_dialog_rect_from_cursor variant (BYTE_VERIFIED 2026-05-03)
; ----------------------------------------------------------------------------
; Identical structure to func_067DC8 (popup-rect compute + setter call).
; Reads cursor [0x174,0x176], char dims [0x1EA4,0x1EA5], font cell
; [0xA5A4,0xA5A6]. Pushes 4 args: cursor_y, cursor_x, computed Y,
; computed X. Then LEA bx,[0x839E] (struct base) and LCALLs the
; popup-rect setter (overlay function — variant per LCALL target).
;
; Region   : overlay
; Bytes    : file 0x067E8C..0x067ECC
; Status   : BYTE_VERIFIED — see docs/DIALOG_GEOMETRY.md
; ============================================================================


067E8C  C8 04 00 00           ENTER  4, 0                         ; reserve 4-byte stack frame
067E90  8B 0E 74 01           MOV    cx, word ptr [0x174]         ; cx = cursor_x
067E94  8B 16 76 01           MOV    dx, word ptr [0x176]         ; dx = cursor_y
067E98  89 4E FC              MOV    word ptr [bp - 4], cx        ; save cursor_x to local
067E9B  89 56 FE              MOV    word ptr [bp - 2], dx        ; save cursor_y to local
067E9E  83 3E 86 01 64        CMP    word ptr [0x186], 0x64       ; if dialog_state < 100 (0x64)
067EA3  7C 29                 JL     0x67ece ; CJUMP
067EA5  52                    PUSH   dx                           ; arg = cursor_y / arg = computed Y (depends on stage)
067EA6  51                    PUSH   cx                           ; arg = cursor_x / arg = computed Y
067EA7  8A 0E A5 1E           MOV    cl, byte ptr [0x1ea5]        ; cl = char_height_rows
067EAB  2A ED                 SUB    ch, ch                       ; cx = ZERO-extend cl
067EAD  03 0E A6 A5           ADD    cx, word ptr [0xa5a6]        ; cx += font_cell_height
067EB1  83 E9 0F              SUB    cx, 0xf                      ; cx -= 0xF (top padding)
067EB4  51                    PUSH   cx                           ; arg = cursor_x / arg = computed Y
067EB5  8A 16 A4 1E           MOV    dl, byte ptr [0x1ea4]        ; dl = char_width_cols
067EB9  2A F6                 SUB    dh, dh                       ; dx = ZERO-extend dl
067EBB  03 16 A4 A5           ADD    dx, word ptr [0xa5a4]        ; dx += font_cell_width
067EBF  83 EA 08              SUB    dx, 8                        ; dx -= 8 (left padding)
067EC2  8D 1E 9E 83           LEA    bx, [0x839e]                 ; bx = &dialog_rect (struct base)
067EC6  9A 8E 09 1F 1A        LCALL  0x1a1f, 0x98e ; THUNK -> 0x0C89:0x0006 (thunk @file 0x01CF7E type B)
067ECB  C9                    LEAVE                               ; tear down frame
067ECC  C3                    RET                                 ; near return (Borland ENTER convention)
