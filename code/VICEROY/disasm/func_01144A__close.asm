; ============================================================================
; func_01144A__close
; Region   : load_image
; Bytes    : file 0x01144A..0x01146A  (32 bytes)
; Purpose  : C `close(fd)` for the low-level file-descriptor table. Validates the fd against the open-files limit at DGROUP:0x27B9 (returns errno EBADF=9 if out of range); otherwise issues INT 21h AH=3Eh (Close Handle) and clears the corresponding entry in the file-descriptor flag table at DGROUP:0x27BB+fd. Tail-jumps to the shared errno-translation epilogue at 0x10AD0.
; Args     : [bp+6] = file descriptor (16-bit fd index, not a DOS handle directly)
; Returns  : AX = 0 on success; -1 with errno set on failure.
; Callers  : TBD
; Callees  : INT 21h AH=3Eh (Close Handle), errno_epilogue at 0x10AD0 (via JMP)
; Verified : boundary verified — function ends at JMP at 0x011467 + 3 = 0x01146A; the byte at 0x01146A starts the next function
; Source   : manually identified — INT 21h AH=3E with the fd-table check is the canonical low-level close()
; ============================================================================

01144A  55                    PUSH   bp                           ; standard frame prologue
01144B  8B EC                 MOV    bp, sp                       ; BP = SP
01144D  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; BX = fd argument (file-descriptor index)
011450  3B 1E B9 27           CMP    bx, word ptr [0x27b9]        ; compare against the open-files limit kept at DGROUP:0x27B9 (NFILE_QQ)
011454  72 06                 JB     0x1145c                      ; if fd is in range, branch to the actual close
011456  B8 00 09              MOV    ax, 0x900                    ; AX = 0x0900 — the AH high byte places this in the EBADF=9 errno region for the epilogue
011459  F9                    STC                                 ; set CF — signals "error" to the errno epilogue
01145A  EB 0B                 JMP    0x11467                      ; jump to the shared tail-call to the errno epilogue
01145C  B4 3E                 MOV    ah, 0x3e                     ; INT 21h subfunction 3Eh: Close Handle
01145E  CD 21                 INT    0x21                         ; DOS close-handle for the fd in BX. CF=1 on error, AX=DOS error code.
011460  72 05                 JB     0x11467                      ; on error, skip the fd-flag clear and go to the epilogue
011462  C6 87 BB 27 00        MOV    byte ptr [bx + 0x27bb], 0    ; clear the C runtime's fd-flag table entry at DGROUP:0x27BB[fd] = 0 (slot is now free)
011467  E9 66 F6              JMP    0x10ad0                      ; tail-jump to errno_epilogue at 0x10AD0 — translates result and returns to caller
