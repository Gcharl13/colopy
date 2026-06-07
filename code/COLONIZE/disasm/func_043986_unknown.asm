; ============================================================================
; func_043986_unknown
; Region   : load_image
; Bytes    : file 0x043986..0x0439FD  (119 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043986  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04398A  8A 0E 34 0B           MOV    cl, byte ptr [0xb34]         ; UNKNOWN
04398E  B8 0F 00              MOV    ax, 0xf                      ; UNKNOWN
043991  D3 E0                 SHL    ax, cl                       ; UNKNOWN
043993  A3 90 82              MOV    word ptr [0x8290], ax        ; UNKNOWN
043996  B8 0C 00              MOV    ax, 0xc                      ; UNKNOWN
043999  D3 E0                 SHL    ax, cl                       ; UNKNOWN
04399B  A3 92 82              MOV    word ptr [0x8292], ax        ; UNKNOWN
04399E  83 3E 3A 0B 00        CMP    word ptr [0xb3a], 0          ; UNKNOWN
0439A3  74 0F                 JE     0x439b4                      ; UNKNOWN
0439A5  B8 05 00              MOV    ax, 5                        ; UNKNOWN
0439A8  A3 90 82              MOV    word ptr [0x8290], ax        ; UNKNOWN
0439AB  A3 92 82              MOV    word ptr [0x8292], ax        ; UNKNOWN
0439AE  C7 06 34 0B 00 00     MOV    word ptr [0xb34], 0          ; UNKNOWN
0439B4  8A 0E 34 0B           MOV    cl, byte ptr [0xb34]         ; UNKNOWN
0439B8  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
0439BB  D3 F8                 SAR    ax, cl                       ; UNKNOWN
0439BD  A3 7C 82              MOV    word ptr [0x827c], ax        ; UNKNOWN
0439C0  A3 7E 82              MOV    word ptr [0x827e], ax        ; UNKNOWN
0439C3  A1 90 82              MOV    ax, word ptr [0x8290]        ; UNKNOWN
0439C6  D1 F8                 SAR    ax, 1                        ; UNKNOWN
0439C8  2B 06 2C 0B           SUB    ax, word ptr [0xb2c]         ; UNKNOWN
0439CC  F7 D8                 NEG    ax                           ; UNKNOWN
0439CE  A3 80 82              MOV    word ptr [0x8280], ax        ; UNKNOWN
0439D1  8B 0E 92 82           MOV    cx, word ptr [0x8292]        ; UNKNOWN
0439D5  D1 F9                 SAR    cx, 1                        ; UNKNOWN
0439D7  2B 0E 2E 0B           SUB    cx, word ptr [0xb2e]         ; UNKNOWN
0439DB  F7 D9                 NEG    cx                           ; UNKNOWN
0439DD  89 0E 86 82           MOV    word ptr [0x8286], cx        ; UNKNOWN
0439E1  83 3E 3A 0B 00        CMP    word ptr [0xb3a], 0          ; UNKNOWN
0439E6  75 34                 JNE    0x43a1c                      ; UNKNOWN
0439E8  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0439EB  7D 03                 JGE    0x439f0                      ; UNKNOWN
0439ED  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0439F0  8B 16 88 82           MOV    dx, word ptr [0x8288]        ; UNKNOWN
0439F4  2B 16 90 82           SUB    dx, word ptr [0x8290]        ; UNKNOWN
0439F8  4A                    DEC    dx                           ; UNKNOWN
0439F9  3B C2                 CMP    ax, dx                       ; UNKNOWN
0439FB  7E 02                 JLE    0x439ff                      ; UNKNOWN
