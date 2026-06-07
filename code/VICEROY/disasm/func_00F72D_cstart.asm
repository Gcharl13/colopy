; ============================================================================
; func_00F72D_cstart
; Region   : load_image
; Bytes    : file 0x00F72D..0x00F7E3  (182 bytes)
; Purpose  : C-runtime startup. Relocates the program stack to its dedicated SS segment, on failure prints 'stack overflow' and exits. Then zeroes the BSS, calls the precompiled-init chain (lcall 0xD1D:0x1420 / 0x128E / 0x248 — atexit init, FPU init, _setargv equivalents). Pushes argc/argv/envp from globals at [0x27CF],[0x27D1],[0x27D3] and far-calls _main via the overlay thunk at 0x181F:0 (file 0x1A5F0). On return passes _main's exit code to the exit chain at 0xF8DD.
; Args     : Inherited from the LJMP from dos_version_check_stub at 0xF727 (DOS Get-Version's results in AX/BX/CX, plus the original DS/ES from DOS).
; Returns  : Does not return. Falls through to or calls into the exit handler at 0xF8DD which calls DOS Terminate (INT 21h, AH=4Ch).
; Callers  : 0xF727 (fall-through from dos_version_check_stub when DOS>=2)
; Callees  : 0x10812 (stack_overflow_print), 0x10A99 (panic_exit), DOS INT 21h AH=4Ch (terminate), 0xD1D:0x1420 / 0xD1D:0x128E / 0xD1D:0x248 (precompiled-init thunks), overlay thunk at 0x1A5F0 (_main entry), 0xF8DD (exit_chain)
; Verified : boundary verified — RETF at 0xF7E2; size 0xF7E3 - 0xF72D = 182 bytes
; Source   : manually identified by tracing the LJMP fall-through from dos_version_check_stub
; ============================================================================

00F72D  BF 5A 1B              MOV    di, 0x1b5a                   ; DI = paragraph-relative segment of the new stack base (DGROUP-relative; 0x1B5A paragraphs)
00F730  8B 36 02 00           MOV    si, word ptr [2]             ; SI = top-of-program-block paragraphs from PSP+2 (DOS loader supplied)
00F734  2B F7                 SUB    si, di                       ; SI = paragraphs available above DI for the stack
00F736  81 FE 00 10           CMP    si, 0x1000                   ; cap stack at 0x1000 paragraphs (= 64 KB, the 16-bit stack-segment limit)
00F73A  72 03                 JB     0xf73f                       ; if available < 64 KB, keep the smaller value
00F73C  BE 00 10              MOV    si, 0x1000                   ; clamp SI to 0x1000 paragraphs
00F73F  FA                    CLI                                 ; disable interrupts while SS and SP are momentarily inconsistent
00F740  8E D7                 MOV    ss, di                       ; SS = new stack segment (DI)
00F742  81 C4 AE A8           ADD    sp, 0xa8ae                   ; bias SP — the carry flag set by this ADD drives the JAE below; if no carry, the stack relocation overflowed
00F746  FB                    STI                                 ; re-enable interrupts now that SS:SP is consistent
00F747  73 12                 JAE    0xf75b                       ; if no overflow, jump past the stack-overflow panic
00F749  16                    PUSH   ss                           ; push SS so the called printer can address its DGROUP-allocated string
00F74A  1F                    POP    ds                           ;   DS = SS (DGROUP)
00F74B  0E                    PUSH   cs                           ; push return CS for the near-call below
00F74C  E8 C3 10              CALL   0x10812                      ; near-call stack_overflow_print at file 0x10812 — emits the "stack overflow" message via DOS write
00F74F  33 C0                 XOR    ax, ax                       ; AX = 0 — exit code argument for panic_exit
00F751  50                    PUSH   ax                           ; push exit code (0)
00F752  0E                    PUSH   cs                           ; push return CS
00F753  E8 43 13              CALL   0x10a99                      ; near-call panic_exit at file 0x10A99 — runs atexit handlers and then exits
00F756  B8 FF 4C              MOV    ax, 0x4cff                   ; INT 21h subfunction 4Ch (Terminate w/ exit code), exit code = 0xFF
00F759  CD 21                 INT    0x21                         ; DOS Terminate — does not return
00F75B  8B C6                 MOV    ax, si                       ; AX = stack-segment paragraph count
00F75D  B1 04                 MOV    cl, 4                        ; shift count = 4 (paragraphs → bytes)
00F75F  D3 E0                 SHL    ax, cl                       ; AX = stack size in bytes (paragraphs * 16)
00F761  48                    DEC    ax                           ; AX = top-of-stack offset within SS (size - 1)
00F762  36 A3 76 27           MOV    word ptr ss:[0x2776], ax     ; STKHQQ (Microsoft C runtime stack-top global) ← top of stack offset
00F766  BB 78 27              MOV    bx, 0x2778                   ; BX = address of the arena descriptor in SS
00F769  36 8C 17              MOV    word ptr ss:[bx], ss         ; arena.segment = SS
00F76C  83 E4 FE              AND    sp, 0xfffe                   ; word-align SP (clear bit 0)
00F76F  36 89 67 04           MOV    word ptr ss:[bx + 4], sp     ; arena.break = current SP — heap grows downward toward this break
00F773  B8 FE FF              MOV    ax, 0xfffe                   ; sentinel value 0xFFFE = "end of free list"
00F776  50                    PUSH   ax                           ; push end sentinel (decrements SP by 2)
00F777  36 89 67 0A           MOV    word ptr ss:[bx + 0xa], sp   ; arena.top_marker_offset = SP after pushing the end sentinel
00F77B  F7 D0                 NOT    ax                           ; AX = ~0xFFFE = 0x0001 (head-of-free-list "next" sentinel)
00F77D  50                    PUSH   ax                           ; push head sentinel (decrements SP again)
00F77E  36 89 67 06           MOV    word ptr ss:[bx + 6], sp     ; arena.free_list_head = SP
00F782  36 89 67 08           MOV    word ptr ss:[bx + 8], sp     ; arena.free_list_tail = SP (initially head==tail, list is empty)
00F786  36 89 26 72 27        MOV    word ptr ss:[0x2772], sp     ; STKBQQ (C runtime stack-bottom global) ← SP after the two sentinel pushes
00F78B  03 F7                 ADD    si, di                       ; SI = top paragraph of program (stack base + stack size)
00F78D  89 36 02 00           MOV    word ptr [2], si             ; PSP+2 ← new top-of-block paragraph (informs DOS where our memory now ends)
00F791  8C C3                 MOV    bx, es                       ; BX = current PSP segment
00F793  2B DE                 SUB    bx, si                       ; BX = -(paragraphs to shrink by)
00F795  F7 DB                 NEG    bx                           ; BX = paragraphs to keep (new size of the memory block in paragraphs)
00F797  B4 4A                 MOV    ah, 0x4a                     ; INT 21h subfunction 4Ah (Resize Memory Block)
00F799  CD 21                 INT    0x21                         ; DOS Resize Memory Block — ES = block segment (PSP), BX = new size (paragraphs)
00F79B  36 8C 1E B2 27        MOV    word ptr ss:[0x27b2], ds     ; save the C runtime's DS (DGROUP) for later restoration
00F7A0  16                    PUSH   ss                           ; ES = SS for the upcoming REP STOSB
00F7A1  07                    POP    es                           ;   ES = DGROUP
00F7A2  FC                    CLD                                 ; clear direction flag — STOSB will increment DI
00F7A3  BF C6 2C              MOV    di, 0x2cc6                   ; DI = start of BSS (DGROUP-relative offset)
00F7A6  B9 B0 A8              MOV    cx, 0xa8b0                   ; CX = end of BSS (DGROUP-relative offset)
00F7A9  2B CF                 SUB    cx, di                       ; CX = BSS length in bytes
00F7AB  33 C0                 XOR    ax, ax                       ; AL = 0 — fill byte
00F7AD  F3 AA                 REP STOSB byte ptr es:[di], al         ; zero-initialize BSS (DGROUP:[0x2CC6 .. 0xA8B0))
00F7AF  16                    PUSH   ss                           ; restore DS = SS (DGROUP) — runtime convention
00F7B0  1F                    POP    ds                           ;   DS = DGROUP
00F7B1  8B 0E 14 2B           MOV    cx, word ptr [0x2b14]        ; CX = optional pre-init function pointer (set by linker if present)
00F7B5  E3 02                 JCXZ   0xf7b9                       ; if no pre-init function, skip the call
00F7B7  FF D1                 CALL   cx                           ; near-call the pre-init function (runs C++-style global ctors if present)
00F7B9  9A 20 14 1D 0D        LCALL  0xd1d, 0x1420                ; far-call init thunk #1 at 0D1D:0x1420 — atexit/_init_chain
00F7BE  9A 8E 12 1D 0D        LCALL  0xd1d, 0x128e                ; far-call init thunk #2 at 0D1D:0x128E — file-table / FILE* init
00F7C3  33 ED                 XOR    bp, bp                       ; BP = 0 — terminates the runtime's stack-frame chain (debug aid)
00F7C5  9A 48 02 1D 0D        LCALL  0xd1d, 0x248                 ; far-call init thunk #3 at 0D1D:0x248 — _setargv / _setenvp (parse PSP cmdline + env into argc/argv/envp)
00F7CA  16                    PUSH   ss                           ; DS = SS (DGROUP) for the [0x27CF..0x27D3] reads below
00F7CB  1F                    POP    ds ; STACK_POP
00F7CC  FF 36 D3 27           PUSH   word ptr [0x27d3]            ; push envp (set by _setenvp at 0xD1D:0x248)
00F7D0  FF 36 D1 27           PUSH   word ptr [0x27d1]            ; push argv
00F7D4  FF 36 CF 27           PUSH   word ptr [0x27cf]            ; push argc
00F7D8  9A 00 00 1F 18        LCALL  0x181f, 0                    ; far-call _main via overlay-thunk-table at 0x181F:0 (file 0x1A5F0)
00F7DD  50                    PUSH   ax                           ; push _main's return value as the exit code argument
00F7DE  0E                    PUSH   cs                           ; push return CS for the near call to exit_chain
00F7DF  E8 FB 00              CALL   0xf8dd                       ; near-call exit() at 0xF8DD — runs atexit handlers, flushes FILE buffers, INT 21h AH=4Ch terminate
00F7E2  C3                    RET                                 ; never reached (exit doesn't return), but kept as a safety net
