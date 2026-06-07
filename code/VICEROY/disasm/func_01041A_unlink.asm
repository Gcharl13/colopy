; ============================================================================
; func_01041A_unlink
; Region   : load_image
; Bytes    : file 0x01041A..0x010428  (14 bytes)
; Purpose  : C `unlink(path)` / `remove(path)`. Loads DX with the path pointer from [bp+6] and issues DOS Delete File (INT 21h, AH=41h). On success CF=0, AX=0; on failure CF=1, AX=DOS error code. Tail-jumps to the shared C-runtime errno-translation epilogue at 0x10AD0 which converts the DOS error to a C errno value and returns AX accordingly.
; Args     : [bp+6] = far pointer to NUL-terminated filename (DS:DX)
; Returns  : AX = 0 on success; -1 with errno set on failure.
; Callers  : TBD
; Callees  : INT 21h AH=41h (Delete File), errno_epilogue at 0x10AD0 (via JMP)
; Verified : boundary verified — function ends at JMP at 0x010424 + 3 = 0x010427; size = 13 bytes, +1 padding DB
; Source   : manually identified — INT 21h AH=41 is the canonical DOS unlink
; ============================================================================

01041A  55                    PUSH   bp                           ; standard frame prologue
01041B  8B EC                 MOV    bp, sp                       ; BP = SP
01041D  8B 56 06              MOV    dx, word ptr [bp + 6]        ; DX = path pointer (offset; segment is implicitly DS = caller's DGROUP)
010420  B4 41                 MOV    ah, 0x41                     ; INT 21h subfunction 41h: Delete File
010422  CD 21                 INT    0x21                         ; DOS Delete File — returns CF=0/AX=0 on success, CF=1/AX=DOS error on failure
010424  E9 A9 06              JMP    0x10ad0                      ; tail-jump to errno_epilogue at 0x10AD0 — translates DOS error → C errno, returns AX
010427  00                    DB     0x00                         ; one-byte alignment padding between functions
