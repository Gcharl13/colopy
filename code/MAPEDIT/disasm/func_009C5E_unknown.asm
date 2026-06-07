; ============================================================================
; clamp_value_lo_hi  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x0048cc (29 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: clamp(value, lo, hi)
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x009C5E..0x009C7B  (29 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x0048cc)
; ============================================================================

009C5E  55                    PUSH   bp ; STACK_PUSH
009C5F  8B EC                 MOV    bp, sp ; MOV
009C61  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
009C64  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
009C67  3B C2                 CMP    ax, dx ; CMP
009C69  7D 02                 JGE    0x9c6d ; CJUMP
