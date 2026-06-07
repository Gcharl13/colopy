; ============================================================================
; func_01A425_dos_version_far
; Region   : load_image
; Bytes    : file 0x01A425..0x01A43C  (23 bytes)
; Purpose  : Far-callable DOS Get-Version stub. Issues INT 21h, AX=3000h. If the major version (AL) is below 3 the stub sets the carry flag and unwinds an unusually large set of pushed registers (BP, ES, DI, DX, CX, BX, AX) before far-returning — it is being called from a context that pushed a 7-register save frame and wants the carry flag to signal an old-DOS error.
; Args     : (none)
; Returns  : On DOS>=3, falls through past 0x1A43B to deliver AX=version normally. On DOS<3, CF=1 and the function unwinds the caller's pushed-register frame and far-returns with the error indicated.
; Callers  : TBD
; Callees  : INT 21h AH=30h
; Verified : boundary covers the early-exit unwind. The DOS>=3 success path continues past the visible RETF and is part of a longer routine; this entry covers only the version-check prologue.
; Source   : manually identified — INT 21h AX=3000h is DOS Get-Version
; ============================================================================

01A425  55                    PUSH   bp                           ; standard frame prologue (caller has already pushed AX/BX/CX/DX/DI/ES before invoking this)
01A426  8B EC                 MOV    bp, sp                       ; BP = SP
01A428  8B F8                 MOV    di, ax                       ; save the caller's AX (its argument or saved value) into DI for later use
01A42A  B8 00 30              MOV    ax, 0x3000                   ; AX = 0x3000 — INT 21h Get DOS Version (AH=30h, AL=0=request "real DOS")
01A42D  CD 21                 INT    0x21                         ; DOS Get-Version → AL = major, AH = minor
01A42F  3C 03                 CMP    al, 3                        ; require DOS 3.0 or higher
01A431  73 09                 JAE    0x1a43c                      ; on DOS>=3 jump past the unwind to continue the caller's logic
01A433  F9                    STC                                 ; (DOS<3 path) set carry flag — signals "version too old" to the caller
01A434  5D                    POP    bp                           ; unwind the 7-register save frame the caller pushed before invoking us
01A435  07                    POP    es                           ;   POP ES
01A436  5F                    POP    di                           ;   POP DI
01A437  5A                    POP    dx                           ;   POP DX
01A438  59                    POP    cx                           ;   POP CX
01A439  5B                    POP    bx                           ;   POP BX
01A43A  58                    POP    ax                           ;   POP AX  (caller will not see CF here — but the upstream tail-callsite re-pushes the flags)
01A43B  CB                    RETF                                ; far-return to the caller's caller with CF=1 reported via the unwound flags
