; ============================================================================
; func_013BF7_system_init
; Region   : load_image
; Bytes    : file 0x013BF7..0x01414F  (1368 bytes)
; Purpose  : Boot-time DOS/EMS/XMS/heap initialization. Saves the initial DS/ES/SS, runs DOS Get-Version (INT 21h, AH=30h), probes for an EMS driver (INT 67h, AH=42h) and allocates a 1-page handle if present, probes for XMS (call 0x18153) and allocates an XMS block if present, queries the conventional-memory ceiling from the PSP, computes the runtime memory layout (program break, near-heap, far-heap, EMS window, XMS handle), shrinks the program memory block to the computed size via INT 21h AH=4Ah, allocates the near-heap base via INT 21h AH=48h, hooks INT 21h handlers for environment-variable lookup (function 35h/25h sub-21h), and stores all of this into globals at DS:[0x3995..0x39FF] for later use by file I/O, the asset loader and the renderer. Returns far via PUSH ES; PUSH DS; ... ; POP DS; POP ES; RETF.
; Args     : (none — runs against DOS-loader-default register state)
; Returns  : RETF at 0x1414E. Pre-existing DS/ES/SS are restored from the stack; results are written to globals at DS:[0x3995..]
; Callers  : 0x13BED (entry_point) via LCALL 110D:0727
; Callees  : 0x175D:0x6DB, 0x175D:0x700, 0x175D:0 (library thunks); 0x18153 (XMS-detect), 0x18717, 0x18776, 0x181B3, 0x182BC, 0x18835, 0x184B5 (heap-setup helpers); 0x16C61 (panic-no-memory); 0x1726B (clear-region); 0x110D:0x5DD0 (lib thunk); INT 21h AH=30h/4Ah/48h/35h/25h/45h; INT 67h AH=42h/43h/44h/45h
; Verified : boundary verified — RETF at 0x1414E; size 0x1414F - 0x13BF7 = 1368 bytes (1,368). Per-line annotation pending.
; Source   : manually identified — LCALL target of entry_point at 0x13BED with cs:ip = 110D:0727 segment-relative
; ============================================================================

013BF7  1E                    PUSH   ds                           ; preserve caller's DS (PSP segment as set by DOS loader)
013BF8  06                    PUSH   es                           ; preserve caller's ES (also PSP segment)
013BF9  9A DB 06 5D 17        LCALL  0x175d, 0x6db                ; library init helper #1 (segment 0x175D = RTLink runtime); details TBD
013BFE  2E 8C 06 95 39        MOV    word ptr cs:[0x3995], es     ; save initial ES (= PSP segment) into the runtime "psp_segment" global
013C03  8C C8                 MOV    ax, cs                       ; AX = our own CS (load image code segment)
013C05  8E D8                 MOV    ds, ax                       ; DS = CS — switch to load-image-relative addressing for the rest of this function
013C07  52                    PUSH   dx                           ; preserve DX across the helper call
013C08  BA C7 18              MOV    dx, 0x18c7                   ; DX = 0x18C7 (an address in the load image code segment — likely a callback)
013C0B  B0 01                 MOV    al, 1                        ; AL = 1 (mode flag)
013C0D  9A 00 07 5D 17        LCALL  0x175d, 0x700                ; library init helper #2 (RTLink runtime); installs the callback DX with mode AL
013C12  5A                    POP    dx                           ; restore DX
013C13  FC                    CLD                                 ; clear direction flag — string ops will increment indices (C convention)
013C14  B8 55 17              MOV    ax, 0x1755                   ; AX = 0x1755 (top-of-code-segment paragraph; linker constant)
013C17  2B 06 54 39           SUB    ax, word ptr [0x3954]        ; subtract the code-segment-base paragraph from a global at [0x3954]
013C1B  D1 E0                 SHL    ax, 1                        ; AX <<= 1
013C1D  D1 E0                 SHL    ax, 1                        ;     <<= 1
013C1F  D1 E0                 SHL    ax, 1                        ;     <<= 1
013C21  D1 E0                 SHL    ax, 1                        ;     <<= 1 (total = paragraphs * 16 = bytes)
013C23  A3 56 39              MOV    word ptr [0x3956], ax        ; store "code-segment size in bytes" at the runtime global [0x3956]
013C26  B8 00 30              MOV    ax, 0x3000                   ; INT 21h subfunction 0x30 (Get DOS Version)
013C29  CD 21                 INT    0x21                         ; DOS Get-Version → AL = major, AH = minor
013C2B  3C 03                 CMP    al, 3                        ; major version >= 3?
013C2D  72 05                 JB     0x13c34                      ; if DOS<3, skip the "modern DOS" feature flag
013C2F  C6 06 3A 3C A0        MOV    byte ptr [0x3c3a], 0xa0      ; DOS>=3 → set the "use modern features" byte at the runtime global [0x3C3A] = 0xA0
013C34  8C 16 62 39           MOV    word ptr [0x3962], ss        ; save initial SS into the runtime "saved_ss" global at [0x3962]
013C38  E8 18 45              CALL   0x18153                      ; near-call EMS-presence-check helper (returns ZF=0 if EMS driver installed, ZF=1 if absent)
013C3B  75 38                 JNE    0x13c75                      ; if NO EMS driver, jump past the EMS init block to the XMS phase
013C3D  B8 00 42              MOV    ax, 0x4200                   ; INT 67h, AH=0x42 (EMS Get Page Count) — returns total/free pages
013C40  CD 67                 INT    0x67                         ; EMS: BX = free pages (each = 16 KB)
013C42  89 1E A3 39           MOV    word ptr [0x39a3], bx        ; store EMS-free-pages-count at runtime global [0x39A3]
013C46  80 0E DD 39 01        OR     byte ptr [0x39dd], 1         ; set bit 0 of the runtime "memory-flags" byte at [0x39DD] — flag "EMS available"
013C4B  D1 E3                 SHL    bx, 1                        ; BX <<= 1
013C4D  D1 E3                 SHL    bx, 1                        ;     <<= 1
013C4F  D1 E3                 SHL    bx, 1                        ;     <<= 1
013C51  D1 E3                 SHL    bx, 1                        ;     <<= 1 (total = pages * 16 = paragraph count of EMS memory)
013C53  89 1E E8 39           MOV    word ptr [0x39e8], bx        ; store "EMS paragraphs available" at [0x39E8]
013C57  83 FB 00              CMP    bx, 0                        ; any EMS pages free?
013C5A  74 19                 JE     0x13c75                      ; if no free pages, skip EMS handle allocation
013C5C  B8 00 43              MOV    ax, 0x4300                   ; INT 67h, AH=0x43 (EMS Allocate Pages)
013C5F  BB 01 00              MOV    bx, 1                        ;   BX = 1 (allocate 1 page = 16 KB to test)
013C62  CD 67                 INT    0x67                         ; EMS: AH=0 on success, DX = handle
013C64  0A E4                 OR     ah, ah                       ; check error byte
013C66  74 08                 JE     0x13c70                      ; on success (AH=0), branch past the "EMS unavailable" cleanup
013C68  C7 06 E8 39 00 00     MOV    word ptr [0x39e8], 0         ; allocation failed → mark EMS as 0 paragraphs (effectively disable)
013C6E  EB 05                 JMP    0x13c75                      ; jump past the dealloc step into the XMS phase
013C70  B8 00 45              MOV    ax, 0x4500                   ; INT 67h, AH=0x45 (EMS Deallocate Pages) — release the 1-page test handle
013C73  CD 67                 INT    0x67                         ; (the test handle is freed because system_init only needs the count, not the pages)
013C75  E8 3B 45              CALL   0x181b3                      ; near-call XMS-presence-check helper (returns CF=1 if NO XMS)
013C78  72 78                 JB     0x13cf2                      ; if no XMS, jump past the entire XMS init block to the conventional-memory phase
013C7A  F7 06 E8 39 FF FF     TEST   word ptr [0x39e8], 0xffff    ; check if EMS is still flagged available
013C80  74 0A                 JE     0x13c8c                      ; if no EMS, skip EMS-handle-free
013C82  8B 1E A3 39           MOV    bx, word ptr [0x39a3]        ; BX = saved EMS-pages-count (used as handle in this code)
013C86  B8 00 43              MOV    ax, 0x4300                   ; INT 67h, AH=0x43 (EMS Allocate Pages — note this is REUSING the routine to query, not actually free)
013C89  CD 67                 INT    0x67                         ; result in DX = EMS handle
013C8B  52                    PUSH   dx                           ; preserve the EMS handle on the stack across the XMS query
013C8C  B8 00 08              MOV    ax, 0x800                    ; XMS function code 0x08 (Query Free Extended Memory)
013C8F  51                    PUSH   cx                           ; preserve CX
013C90  FF 1E 84 4E           LCALL  [0x4e84]                     ; far-call the XMS driver via its entry-point pointer at DGROUP:0x4E84 → AX = largest free KB, BL = error
013C94  59                    POP    cx                           ; restore CX
013C95  80 FB A0              CMP    bl, 0xa0                     ; XMS error 0xA0 = "all extended memory is allocated"
013C98  75 02                 JNE    0x13c9c                      ; if some other error or success, skip the AX-zero
013C9A  33 C0                 XOR    ax, ax                       ; on "all allocated" → AX = 0 KB free
013C9C  F7 06 E8 39 FF FF     TEST   word ptr [0x39e8], 0xffff    ; was EMS available?
013CA2  74 08                 JE     0x13cac                      ; if not, skip EMS dealloc
013CA4  5A                    POP    dx                           ; pop the EMS handle we saved earlier
013CA5  50                    PUSH   ax                           ; preserve XMS-free-KB result
013CA6  B8 00 45              MOV    ax, 0x4500                   ; INT 67h, AH=0x45 (EMS Deallocate)
013CA9  CD 67                 INT    0x67                         ; release the test handle in DX
013CAB  58                    POP    ax                           ; restore XMS-free-KB
013CAC  83 F8 00              CMP    ax, 0                        ; any XMS to allocate?
013CAF  74 1D                 JE     0x13cce                      ; no XMS free → skip allocation, store 0
013CB1  50                    PUSH   ax                           ; save the requested KB count
013CB2  BA 01 00              MOV    dx, 1                        ; DX = 1 KB (test allocation)
013CB5  B8 00 09              MOV    ax, 0x900                    ; XMS function 0x09 (Allocate Extended Memory Block)
013CB8  FF 1E 84 4E           LCALL  [0x4e84]                     ; XMS allocate; on success DX = handle, AX = 1
013CBC  83 F8 00              CMP    ax, 0                        ; success?
013CBF  75 05                 JNE    0x13cc6                      ; if successful, branch to free the test handle
013CC1  58                    POP    ax                           ; allocation failed → discard the saved KB count
013CC2  33 C0                 XOR    ax, ax                       ; report 0 KB available
013CC4  EB 08                 JMP    0x13cce ; JUMP
013CC6  B8 00 0A              MOV    ax, 0xa00                    ; XMS function 0x0A (Free Extended Memory Block)
013CC9  FF 1E 84 4E           LCALL  [0x4e84]                     ; release the test handle — system_init only needed the size info
013CCD  58                    POP    ax                           ; restore the KB count for storage
013CCE  A3 EA 39              MOV    word ptr [0x39ea], ax        ; runtime "XMS-free-KB" global at [0x39EA] = AX
013CD1  D1 E8                 SHR    ax, 1                        ; AX >>= 1
013CD3  D1 E8                 SHR    ax, 1                        ;     >>= 1
013CD5  D1 E8                 SHR    ax, 1                        ;     >>= 1
013CD7  D1 E8                 SHR    ax, 1                        ;     >>= 1 (KB / 16 — but XMS reports KB so this gives... hmm; check formula)
013CD9  A3 A7 39              MOV    word ptr [0x39a7], ax        ; store derived value at "XMS-shifted-paragraphs" [0x39A7]
013CDC  80 0E DD 39 02        OR     byte ptr [0x39dd], 2         ; set bit 1 of memory-flags — flag "XMS available"
013CE1  B8 00 08              MOV    ax, 0x800                    ; XMS function 0x08 again
013CE4  FF 1E 84 4E           LCALL  [0x4e84]                     ; query — now confirms how much XMS is left after the test alloc
013CE8  80 FB A0              CMP    bl, 0xa0                     ; "all allocated" error?
013CEB  75 02                 JNE    0x13cef ; CJUMP
013CED  33 C0                 XOR    ax, ax                       ; on error, treat as 0
013CEF  A3 EC 39              MOV    word ptr [0x39ec], ax        ; runtime "XMS-largest-block-KB" global at [0x39EC]
013CF2  A1 95 39              MOV    ax, word ptr [0x3995]        ; AX = saved PSP segment
013CF5  48                    DEC    ax                           ; AX = MCB segment (PSP - 1 paragraph)
013CF6  8E C0                 MOV    es, ax                       ; ES = MCB segment
013CF8  26 8B 0E 03 00        MOV    cx, word ptr es:[3]          ; CX = paragraphs allocated to this program (per MCB +3)
013CFD  40                    INC    ax                           ; AX back to PSP segment
013CFE  8E C0                 MOV    es, ax                       ; ES = PSP segment
013D00  BB FF FF              MOV    bx, 0xffff                   ; BX = 0xFFFF (impossible request)
013D03  B4 4A                 MOV    ah, 0x4a                     ; INT 21h, AH=0x4A (Resize Memory Block — ES = block)
013D05  CD 21                 INT    0x21                         ; on failure (it always fails for 0xFFFF), BX = max paragraphs available
013D07  87 D9                 XCHG   cx, bx                       ; CX <-> BX: now BX = original allocation, CX = max-available result
013D09  B4 4A                 MOV    ah, 0x4a                     ; INT 21h, AH=0x4A again
013D0B  CD 21                 INT    0x21                         ; resize program memory back to its original size (BX = original count)
013D0D  87 D9                 XCHG   cx, bx                       ; restore BX = max-available
013D0F  8B C3                 MOV    ax, bx                       ; AX = max paragraphs the program could grow to
013D11  03 06 95 39           ADD    ax, word ptr [0x3995]        ; AX += PSP-segment (so AX = absolute paragraph of memory ceiling)
013D15  A3 97 39              MOV    word ptr [0x3997], ax        ; runtime "memory_ceiling_paragraph" global at [0x3997]
013D18  8E 06 99 39           MOV    es, word ptr [0x3999] ; GLOBAL_LOAD
013D1C  26 2B 06 00 00        SUB    ax, word ptr es:[0] ; ARITH
013D21  26 2B 06 16 00        SUB    ax, word ptr es:[0x16] ; ARITH
013D26  26 8B 1E 02 00        MOV    bx, word ptr es:[2] ; MOV
013D2B  2E 89 1E A7 5D        MOV    word ptr cs:[0x5da7], bx ; GLOBAL_LOAD
013D30  F6 06 DD 39 03        TEST   byte ptr [0x39dd], 3 ; LOGIC
013D35  75 02                 JNE    0x13d39 ; CJUMP
013D37  EB 76                 JMP    0x13daf ; JUMP
013D39  26 03 1E 18 00        ADD    bx, word ptr es:[0x18] ; ARITH
013D3E  8B 0E A7 39           MOV    cx, word ptr [0x39a7] ; GLOBAL_LOAD
013D42  03 0E A3 39           ADD    cx, word ptr [0x39a3] ; ARITH
013D46  26 3B 0E 22 00        CMP    cx, word ptr es:[0x22] ; CMP
013D4B  72 05                 JB     0x13d52 ; CJUMP
013D4D  26 8B 0E 22 00        MOV    cx, word ptr es:[0x22] ; GLOBAL_LOAD
013D52  83 C1 07              ADD    cx, 7 ; ARITH
013D55  D1 E9                 SHR    cx, 1 ; LOGIC
013D57  D1 E9                 SHR    cx, 1 ; LOGIC
013D59  D1 E9                 SHR    cx, 1 ; LOGIC
013D5B  03 D9                 ADD    bx, cx ; ARITH
013D5D  F6 06 DD 39 01        TEST   byte ptr [0x39dd], 1 ; LOGIC
013D62  74 03                 JE     0x13d67 ; CJUMP
013D64  83 C3 02              ADD    bx, 2 ; ARITH
013D67  F6 06 DD 39 02        TEST   byte ptr [0x39dd], 2 ; LOGIC
013D6C  74 0B                 JE     0x13d79 ; CJUMP
013D6E  83 C3 02              ADD    bx, 2 ; ARITH
013D71  F6 06 DD 39 01        TEST   byte ptr [0x39dd], 1 ; LOGIC
013D76  74 01                 JE     0x13d79 ; CJUMP
013D78  43                    INC    bx ; ARITH
013D79  EB 34                 JMP    0x13daf ; JUMP
013D7B  8E 06 99 39           MOV    es, word ptr [0x3999] ; GLOBAL_LOAD
013D7F  26 3B 06 02 00        CMP    ax, word ptr es:[2] ; CMP
013D84  77 03                 JA     0x13d89 ; CJUMP
013D86  E9 79 01              JMP    0x13f02 ; JUMP
013D89  C7 06 A3 39 00 00     MOV    word ptr [0x39a3], 0 ; GLOBAL_LOAD
013D8F  C7 06 A7 39 00 00     MOV    word ptr [0x39a7], 0 ; GLOBAL_LOAD
013D95  C7 06 E8 39 00 00     MOV    word ptr [0x39e8], 0 ; GLOBAL_LOAD
013D9B  C7 06 EA 39 00 00     MOV    word ptr [0x39ea], 0 ; GLOBAL_LOAD
013DA1  C7 06 EC 39 00 00     MOV    word ptr [0x39ec], 0 ; GLOBAL_LOAD
013DA7  80 26 DD 39 FC        AND    byte ptr [0x39dd], 0xfc ; LOGIC
013DAC  E9 43 FF              JMP    0x13cf2 ; JUMP
013DAF  3B C3                 CMP    ax, bx ; CMP
013DB1  76 C8                 JBE    0x13d7b ; CJUMP
013DB3  2B C3                 SUB    ax, bx ; ARITH
013DB5  48                    DEC    ax ; ARITH
013DB6  A3 E6 39              MOV    word ptr [0x39e6], ax ; GLOBAL_LOAD
013DB9  89 1E B7 39           MOV    word ptr [0x39b7], bx ; GLOBAL_LOAD
013DBD  8C C8                 MOV    ax, cs ; MOV
013DBF  8E C0                 MOV    es, ax ; MOV
013DC1  BF E6 39              MOV    di, 0x39e6 ; CONST_LOAD
013DC4  8B 0E 95 39           MOV    cx, word ptr [0x3995] ; GLOBAL_LOAD
013DC8  8E 1E 99 39           MOV    ds, word ptr [0x3999] ; GLOBAL_LOAD
013DCC  8B 16 22 00           MOV    dx, word ptr [0x22] ; GLOBAL_LOAD
013DD0  42                    INC    dx ; ARITH
013DD1  D1 E2                 SHL    dx, 1 ; LOGIC
013DD3  D1 E2                 SHL    dx, 1 ; LOGIC
013DD5  D1 E2                 SHL    dx, 1 ; LOGIC
013DD7  D1 E2                 SHL    dx, 1 ; LOGIC
013DD9  33 F6                 XOR    si, si ; LOGIC
013DDB  33 C0                 XOR    ax, ax ; LOGIC
013DDD  BB 01 00              MOV    bx, 1 ; MOV
013DE0  9A 00 00 5D 17        LCALL  0x175d, 0 ; LCALL
013DE5  8C C9                 MOV    cx, cs ; MOV
013DE7  8E D9                 MOV    ds, cx ; MOV
013DE9  A3 EE 39              MOV    word ptr [0x39ee], ax ; GLOBAL_LOAD
013DEC  8B 1E E8 39           MOV    bx, word ptr [0x39e8] ; GLOBAL_LOAD
013DF0  0B C0                 OR     ax, ax ; LOGIC
013DF2  74 03                 JE     0x13df7 ; CJUMP
013DF4  B8 0F 00              MOV    ax, 0xf ; CONST_LOAD
013DF7  B1 04                 MOV    cl, 4 ; MOV
013DF9  03 D8                 ADD    bx, ax ; ARITH
013DFB  D3 EB                 SHR    bx, cl ; LOGIC
013DFD  89 1E A3 39           MOV    word ptr [0x39a3], bx ; GLOBAL_LOAD
013E01  8B 1E EA 39           MOV    bx, word ptr [0x39ea] ; GLOBAL_LOAD
013E05  03 D8                 ADD    bx, ax ; ARITH
013E07  D3 EB                 SHR    bx, cl ; LOGIC
013E09  89 1E A7 39           MOV    word ptr [0x39a7], bx ; GLOBAL_LOAD
013E0D  E8 07 49              CALL   0x18717 ; CALL_NEAR
013E10  C6 06 F2 39 00        MOV    byte ptr [0x39f2], 0 ; GLOBAL_LOAD
013E15  8E 06 99 39           MOV    es, word ptr [0x3999] ; GLOBAL_LOAD
013E19  26 A1 26 00           MOV    ax, word ptr es:[0x26] ; GLOBAL_LOAD
013E1D  25 00 30              AND    ax, 0x3000 ; LOGIC
013E20  3D 00 30              CMP    ax, 0x3000 ; CMP
013E23  75 30                 JNE    0x13e55 ; CJUMP
013E25  E8 4E 49              CALL   0x18776 ; CALL_NEAR
013E28  83 E8 03              SUB    ax, 3 ; ARITH
013E2B  72 28                 JB     0x13e55 ; CJUMP
013E2D  26 3B 06 02 00        CMP    ax, word ptr es:[2] ; CMP
013E32  76 21                 JBE    0x13e55 ; CJUMP
013E34  C6 06 F2 39 FF        MOV    byte ptr [0x39f2], 0xff ; GLOBAL_LOAD
013E39  26 81 26 26 00 FF BF  AND    word ptr es:[0x26], 0xbfff ; LOGIC
013E40  26 83 3E 2C 00 FF     CMP    word ptr es:[0x2c], -1 ; CMP
013E46  74 0D                 JE     0x13e55 ; CJUMP
013E48  26 A1 02 00           MOV    ax, word ptr es:[2] ; MOV
013E4C  03 06 E6 39           ADD    ax, word ptr [0x39e6] ; ARITH
013E50  26 01 06 2C 00        ADD    word ptr es:[0x2c], ax ; ARITH
013E55  33 DB                 XOR    bx, bx ; LOGIC
013E57  F6 06 DD 39 01        TEST   byte ptr [0x39dd], 1 ; LOGIC
013E5C  74 16                 JE     0x13e74 ; CJUMP
013E5E  89 1E A1 39           MOV    word ptr [0x39a1], bx ; GLOBAL_LOAD
013E62  83 C3 02              ADD    bx, 2 ; ARITH
013E65  A1 A3 39              MOV    ax, word ptr [0x39a3] ; GLOBAL_LOAD
013E68  0B C0                 OR     ax, ax ; LOGIC
013E6A  75 08                 JNE    0x13e74 ; CJUMP
013E6C  83 EB 02              SUB    bx, 2 ; ARITH
013E6F  80 26 DD 39 FE        AND    byte ptr [0x39dd], 0xfe ; LOGIC
013E74  A1 A3 39              MOV    ax, word ptr [0x39a3] ; GLOBAL_LOAD
013E77  83 C0 07              ADD    ax, 7 ; ARITH
013E7A  B1 03                 MOV    cl, 3 ; MOV
013E7C  D3 E8                 SHR    ax, cl ; LOGIC
013E7E  03 D8                 ADD    bx, ax ; ARITH
013E80  F6 06 DD 39 02        TEST   byte ptr [0x39dd], 2 ; LOGIC
013E85  74 16                 JE     0x13e9d ; CJUMP
013E87  89 1E A5 39           MOV    word ptr [0x39a5], bx ; GLOBAL_LOAD
013E8B  83 C3 02              ADD    bx, 2 ; ARITH
013E8E  A1 A7 39              MOV    ax, word ptr [0x39a7] ; GLOBAL_LOAD
013E91  0B C0                 OR     ax, ax ; LOGIC
013E93  75 08                 JNE    0x13e9d ; CJUMP
013E95  83 EB 02              SUB    bx, 2 ; ARITH
013E98  80 26 DD 39 FD        AND    byte ptr [0x39dd], 0xfd ; LOGIC
013E9D  A1 A7 39              MOV    ax, word ptr [0x39a7] ; GLOBAL_LOAD
013EA0  83 C0 07              ADD    ax, 7 ; ARITH
013EA3  B1 03                 MOV    cl, 3 ; MOV
013EA5  D3 E8                 SHR    ax, cl ; LOGIC
013EA7  03 D8                 ADD    bx, ax ; ARITH
013EA9  F6 06 DD 39 03        TEST   byte ptr [0x39dd], 3 ; LOGIC
013EAE  74 09                 JE     0x13eb9 ; CJUMP
013EB0  89 1E 9F 39           MOV    word ptr [0x399f], bx ; GLOBAL_LOAD
013EB4  26 03 1E 18 00        ADD    bx, word ptr es:[0x18] ; ARITH
013EB9  89 1E B5 39           MOV    word ptr [0x39b5], bx ; GLOBAL_LOAD
013EBD  26 A1 02 00           MOV    ax, word ptr es:[2] ; MOV
013EC1  03 D8                 ADD    bx, ax ; ARITH
013EC3  8B 0E B7 39           MOV    cx, word ptr [0x39b7] ; GLOBAL_LOAD
013EC7  2B CB                 SUB    cx, bx ; ARITH
013EC9  03 D9                 ADD    bx, cx ; ARITH
013ECB  03 C1                 ADD    ax, cx ; ARITH
013ECD  03 06 E6 39           ADD    ax, word ptr [0x39e6] ; ARITH
013ED1  03 1E E6 39           ADD    bx, word ptr [0x39e6] ; ARITH
013ED5  A3 B7 39              MOV    word ptr [0x39b7], ax ; GLOBAL_LOAD
013ED8  F6 06 F2 39 FF        TEST   byte ptr [0x39f2], 0xff ; LOGIC
013EDD  74 0B                 JE     0x13eea ; CJUMP
013EDF  A3 B9 39              MOV    word ptr [0x39b9], ax ; GLOBAL_LOAD
013EE2  C7 06 B7 39 00 00     MOV    word ptr [0x39b7], 0 ; GLOBAL_LOAD
013EE8  2B D8                 SUB    bx, ax ; ARITH
013EEA  A1 97 39              MOV    ax, word ptr [0x3997] ; GLOBAL_LOAD
013EED  8E 06 99 39           MOV    es, word ptr [0x3999] ; GLOBAL_LOAD
013EF1  26 2B 06 00 00        SUB    ax, word ptr es:[0] ; ARITH
013EF6  26 2B 06 16 00        SUB    ax, word ptr es:[0x16] ; ARITH
013EFB  74 05                 JE     0x13f02 ; CJUMP
013EFD  48                    DEC    ax ; ARITH
013EFE  2B C3                 SUB    ax, bx ; ARITH
013F00  77 0F                 JA     0x13f11 ; CJUMP
013F02  BB 00 3D              MOV    bx, 0x3d00 ; CONST_LOAD
013F05  BA 0A 3D              MOV    dx, 0x3d0a ; CONST_LOAD
013F08  B8 07 05              MOV    ax, 0x507 ; CONST_LOAD
013F0B  B9 04 00              MOV    cx, 4 ; MOV
013F0E  E9 50 2D              JMP    0x16c61 ; JUMP
013F11  89 1E C9 39           MOV    word ptr [0x39c9], bx ; GLOBAL_LOAD
013F15  89 1E CD 39           MOV    word ptr [0x39cd], bx ; GLOBAL_LOAD
013F19  8E 06 95 39           MOV    es, word ptr [0x3995] ; GLOBAL_LOAD
013F1D  8B 1E 97 39           MOV    bx, word ptr [0x3997] ; GLOBAL_LOAD
013F21  2B 1E 95 39           SUB    bx, word ptr [0x3995] ; ARITH
013F25  2B 1E C9 39           SUB    bx, word ptr [0x39c9] ; ARITH
013F29  4B                    DEC    bx ; ARITH
013F2A  B4 4A                 MOV    ah, 0x4a ; CONST_LOAD
013F2C  CD 21                 INT    0x21 ; SYS
013F2E  03 1E 95 39           ADD    bx, word ptr [0x3995] ; ARITH
013F32  26 A1 02 00           MOV    ax, word ptr es:[2] ; MOV
013F36  2E A3 CF 39           MOV    word ptr cs:[0x39cf], ax ; GLOBAL_LOAD
013F3A  3B D8                 CMP    bx, ax ; CMP
013F3C  73 05                 JAE    0x13f43 ; CJUMP
013F3E  26 89 1E 02 00        MOV    word ptr es:[2], bx ; MOV
013F43  8B 1E C9 39           MOV    bx, word ptr [0x39c9] ; GLOBAL_LOAD
013F47  B4 48                 MOV    ah, 0x48 ; CONST_LOAD
013F49  CD 21                 INT    0x21 ; SYS
013F4B  A3 C3 39              MOV    word ptr [0x39c3], ax ; GLOBAL_LOAD
013F4E  2E C7 06 BF 39 C3 39  MOV    word ptr cs:[0x39bf], 0x39c3 ; GLOBAL_LOAD
013F55  2E C7 06 C1 39 0D 11  MOV    word ptr cs:[0x39c1], 0x110d ; GLOBAL_LOAD
013F5C  A1 99 39              MOV    ax, word ptr [0x3999] ; GLOBAL_LOAD
013F5F  8E C0                 MOV    es, ax ; MOV
013F61  83 C0 04              ADD    ax, 4 ; ARITH
013F64  A3 9B 39              MOV    word ptr [0x399b], ax ; GLOBAL_LOAD
013F67  A1 C3 39              MOV    ax, word ptr [0x39c3] ; GLOBAL_LOAD
013F6A  01 06 B5 39           ADD    word ptr [0x39b5], ax ; ARITH
013F6E  01 06 A5 39           ADD    word ptr [0x39a5], ax ; ARITH
013F72  01 06 A1 39           ADD    word ptr [0x39a1], ax ; ARITH
013F76  01 06 9F 39           ADD    word ptr [0x399f], ax ; ARITH
013F7A  2E F6 06 DD 39 01     TEST   byte ptr cs:[0x39dd], 1 ; LOGIC
013F80  74 1D                 JE     0x13f9f ; CJUMP
013F82  B0 01                 MOV    al, 1 ; MOV
013F84  2E 8E 1E A1 39        MOV    ds, word ptr cs:[0x39a1] ; GLOBAL_LOAD
013F89  2E 8B 0E A3 39        MOV    cx, word ptr cs:[0x39a3] ; GLOBAL_LOAD
013F8E  E3 09                 JCXZ   0x13f99 ; CJUMP
013F90  E8 D8 32              CALL   0x1726b ; CALL_NEAR
013F93  73 0A                 JAE    0x13f9f ; CJUMP
013F95  0B C9                 OR     cx, cx ; LOGIC
013F97  75 06                 JNE    0x13f9f ; CJUMP
013F99  2E 80 26 DD 39 FE     AND    byte ptr cs:[0x39dd], 0xfe ; LOGIC
013F9F  2E F6 06 DD 39 02     TEST   byte ptr cs:[0x39dd], 2 ; LOGIC
013FA5  74 1D                 JE     0x13fc4 ; CJUMP
013FA7  32 C0                 XOR    al, al ; LOGIC
013FA9  2E 8E 1E A5 39        MOV    ds, word ptr cs:[0x39a5] ; GLOBAL_LOAD
013FAE  2E 8B 0E A7 39        MOV    cx, word ptr cs:[0x39a7] ; GLOBAL_LOAD
013FB3  E3 09                 JCXZ   0x13fbe ; CJUMP
013FB5  E8 B3 32              CALL   0x1726b ; CALL_NEAR
013FB8  73 0A                 JAE    0x13fc4 ; CJUMP
013FBA  0B C9                 OR     cx, cx ; LOGIC
013FBC  75 06                 JNE    0x13fc4 ; CJUMP
013FBE  2E 80 26 DD 39 FD     AND    byte ptr cs:[0x39dd], 0xfd ; LOGIC
013FC4  8C C8                 MOV    ax, cs ; MOV
013FC6  8E D8                 MOV    ds, ax ; MOV
013FC8  A1 B5 39              MOV    ax, word ptr [0x39b5] ; GLOBAL_LOAD
013FCB  8B 0E B7 39           MOV    cx, word ptr [0x39b7] ; GLOBAL_LOAD
013FCF  8E 06 9B 39           MOV    es, word ptr [0x399b] ; GLOBAL_LOAD
013FD3  BF 00 00              MOV    di, 0 ; MOV
013FD6  BB 01 00              MOV    bx, 1 ; MOV
013FD9  BA 01 00              MOV    dx, 1 ; MOV
013FDC  E8 D6 44              CALL   0x184b5 ; CALL_NEAR
013FDF  8E 06 99 39           MOV    es, word ptr [0x3999] ; GLOBAL_LOAD
013FE3  26 83 3E 2C 00 FF     CMP    word ptr es:[0x2c], -1 ; CMP
013FE9  75 42                 JNE    0x1402d ; CJUMP
013FEB  26 C7 06 2C 00 FF 7F  MOV    word ptr es:[0x2c], 0x7fff ; GLOBAL_LOAD
013FF2  26 81 3E 04 00 00 04  CMP    word ptr es:[4], 0x400 ; CMP
013FF9  73 32                 JAE    0x1402d ; CJUMP
013FFB  26 A1 04 00           MOV    ax, word ptr es:[4] ; MOV
013FFF  D1 C8                 ROR    ax, 1 ; LOGIC
014001  D1 C8                 ROR    ax, 1 ; LOGIC
014003  86 E0                 XCHG   al, ah ; MOV
014005  2B 06 B7 39           SUB    ax, word ptr [0x39b7] ; ARITH
014009  73 02                 JAE    0x1400d ; CJUMP
01400B  33 C0                 XOR    ax, ax ; LOGIC
01400D  A9 00 80              TEST   ax, 0x8000 ; LOGIC
014010  75 1B                 JNE    0x1402d ; CJUMP
014012  26 A3 2C 00           MOV    word ptr es:[0x2c], ax ; GLOBAL_LOAD
014016  2E F6 06 F2 39 FF     TEST   byte ptr cs:[0x39f2], 0xff ; LOGIC
01401C  74 0F                 JE     0x1402d ; CJUMP
01401E  26 3B 06 02 00        CMP    ax, word ptr es:[2] ; CMP
014023  73 08                 JAE    0x1402d ; CJUMP
014025  26 A1 02 00           MOV    ax, word ptr es:[2] ; MOV
014029  26 A3 2C 00           MOV    word ptr es:[0x2c], ax ; GLOBAL_LOAD
01402D  26 A1 2C 00           MOV    ax, word ptr es:[0x2c] ; GLOBAL_LOAD
014031  26 8B 0E 2E 00        MOV    cx, word ptr es:[0x2e] ; GLOBAL_LOAD
014036  0B C0                 OR     ax, ax ; LOGIC
014038  74 2C                 JE     0x14066 ; CJUMP
01403A  26 8B 1E 26 00        MOV    bx, word ptr es:[0x26] ; GLOBAL_LOAD
01403F  81 E3 00 30           AND    bx, 0x3000 ; LOGIC
014043  81 FB 00 20           CMP    bx, 0x2000 ; CMP
014047  72 07                 JB     0x14050 ; CJUMP
014049  E8 E0 47              CALL   0x1882c ; CALL_NEAR
01404C  3B C1                 CMP    ax, cx ; CMP
01404E  7E 16                 JLE    0x14066 ; CJUMP
014050  81 FB 00 30           CMP    bx, 0x3000 ; CMP
014054  74 10                 JE     0x14066 ; CJUMP
014056  E8 DC 47              CALL   0x18835 ; CALL_NEAR
014059  3B C1                 CMP    ax, cx ; CMP
01405B  7E 09                 JLE    0x14066 ; CJUMP
01405D  81 FB 00 10           CMP    bx, 0x1000 ; CMP
014061  75 03                 JNE    0x14066 ; CJUMP
014063  E8 C6 47              CALL   0x1882c ; CALL_NEAR
014066  8E 06 95 39           MOV    es, word ptr [0x3995] ; GLOBAL_LOAD
01406A  26 8B 1E 02 00        MOV    bx, word ptr es:[2] ; MOV
01406F  2B 1E 95 39           SUB    bx, word ptr [0x3995] ; ARITH
014073  B4 4A                 MOV    ah, 0x4a ; CONST_LOAD
014075  CD 21                 INT    0x21 ; SYS
014077  80 0E DD 39 04        OR     byte ptr [0x39dd], 4 ; LOGIC
01407C  B8 21 35              MOV    ax, 0x3521 ; CONST_LOAD
01407F  CD 21                 INT    0x21 ; SYS
014081  89 1E 6C 05           MOV    word ptr [0x56c], bx ; GLOBAL_LOAD
014085  8C 06 6E 05           MOV    word ptr [0x56e], es ; GLOBAL_LOAD
014089  2E 8E 06 99 39        MOV    es, word ptr cs:[0x3999] ; GLOBAL_LOAD
01408E  26 F7 06 26 00 00 40  TEST   word ptr es:[0x26], 0x4000 ; LOGIC
014095  74 0B                 JE     0x140a2 ; CJUMP
014097  26 F7 06 10 00 80 00  TEST   word ptr es:[0x10], 0x80 ; LOGIC
01409E  75 13                 JNE    0x140b3 ; CJUMP
0140A0  EB 09                 JMP    0x140ab ; JUMP
0140A2  26 F7 06 10 00 80 80  TEST   word ptr es:[0x10], 0x8080 ; LOGIC
0140A9  75 08                 JNE    0x140b3 ; CJUMP
0140AB  BA 74 05              MOV    dx, 0x574 ; CONST_LOAD
0140AE  B8 21 25              MOV    ax, 0x2521 ; CONST_LOAD
0140B1  CD 21                 INT    0x21 ; SYS
0140B3  8C C8                 MOV    ax, cs ; MOV
0140B5  8E D8                 MOV    ds, ax ; MOV
0140B7  BA 01 07              MOV    dx, 0x701 ; CONST_LOAD
0140BA  B0 03                 MOV    al, 3 ; MOV
0140BC  9A 00 07 5D 17        LCALL  0x175d, 0x700 ; LCALL
0140C1  BA 19 34              MOV    dx, 0x3419 ; CONST_LOAD
0140C4  B0 78                 MOV    al, 0x78 ; CONST_LOAD
0140C6  9A 00 07 5D 17        LCALL  0x175d, 0x700 ; LCALL
0140CB  B8 DA 3A              MOV    ax, 0x3ada ; CONST_LOAD
0140CE  83 C0 0F              ADD    ax, 0xf ; ARITH
0140D1  D1 E8                 SHR    ax, 1 ; LOGIC
0140D3  D1 E8                 SHR    ax, 1 ; LOGIC
0140D5  D1 E8                 SHR    ax, 1 ; LOGIC
0140D7  D1 E8                 SHR    ax, 1 ; LOGIC
0140D9  8C CB                 MOV    bx, cs ; MOV
0140DB  03 C3                 ADD    ax, bx ; ARITH
0140DD  A3 77 39              MOV    word ptr [0x3977], ax ; GLOBAL_LOAD
0140E0  C7 06 73 39 FE FF     MOV    word ptr [0x3973], 0xfffe ; GLOBAL_LOAD
0140E6  BB 02 00              MOV    bx, 2 ; MOV
0140E9  B4 45                 MOV    ah, 0x45 ; CONST_LOAD
0140EB  CD 21                 INT    0x21 ; SYS
0140ED  A3 75 39              MOV    word ptr [0x3975], ax ; GLOBAL_LOAD
0140F0  8E 06 99 39           MOV    es, word ptr [0x3999] ; GLOBAL_LOAD
0140F4  26 F7 06 26 00 40 00  TEST   word ptr es:[0x26], 0x40 ; LOGIC
0140FB  75 06                 JNE    0x14103 ; CJUMP
0140FD  2E 80 0E DE 39 20     OR     byte ptr cs:[0x39de], 0x20 ; LOGIC
014103  26 F7 06 26 00 00 02  TEST   word ptr es:[0x26], 0x200 ; LOGIC
01410A  74 06                 JE     0x14112 ; CJUMP
01410C  2E 80 0E DD 39 80     OR     byte ptr cs:[0x39dd], 0x80 ; LOGIC
014112  26 F7 06 26 00 00 08  TEST   word ptr es:[0x26], 0x800 ; LOGIC
014119  74 06                 JE     0x14121 ; CJUMP
01411B  2E 80 0E DF 39 01     OR     byte ptr cs:[0x39df], 1 ; LOGIC
014121  A1 C9 39              MOV    ax, word ptr [0x39c9] ; GLOBAL_LOAD
014124  2B 06 B7 39           SUB    ax, word ptr [0x39b7] ; ARITH
014128  26 03 06 02 00        ADD    ax, word ptr es:[2] ; ARITH
01412D  A3 D5 39              MOV    word ptr [0x39d5], ax ; GLOBAL_LOAD
014130  9A D0 5D 0D 11        LCALL  0x110d, 0x5dd0 ; LCALL
014135  2E 89 1E D7 39        MOV    word ptr cs:[0x39d7], bx ; GLOBAL_LOAD
01413A  2E A3 D9 39           MOV    word ptr cs:[0x39d9], ax ; GLOBAL_LOAD
01413E  2E 89 16 DB 39        MOV    word ptr cs:[0x39db], dx ; GLOBAL_LOAD
014143  43                    INC    bx ; ARITH
014144  74 06                 JE     0x1414c ; CJUMP
014146  2E 80 0E DE 39 10     OR     byte ptr cs:[0x39de], 0x10 ; LOGIC
01414C  07                    POP    es ; STACK_POP
01414D  1F                    POP    ds ; STACK_POP
01414E  CB                    RETF ; RETURN
