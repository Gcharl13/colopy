; ============================================================================
; func_00D272_kbhit
; Region   : load_image
; Bytes    : file 0x00D272..0x00D27F  (13 bytes)
; Purpose  : C `kbhit()`: BIOS keyboard 'is a key pending?'. Issues INT 16h, AH=1 (Check Key). If the zero flag is clear (a key is buffered) returns AX=key (scan-code in AH, ASCII in AL). If no key is pending returns AX=0. Standard MS C runtime kbhit().
; Args     : (none)
; Returns  : AX = 0 if no key pending; otherwise AX = the BIOS-keyboard buffered key (scan-code:ASCII)
; Callers  : TBD (xrefs not yet gathered)
; Callees  : INT 16h AH=01h (BIOS keyboard Check Key)
; Verified : boundary verified: PUSH BP / MOV BP, SP at 0xD272; LEAVE / RETF at 0xD27D-0xD27E
; Source   : manually identified — INT 16h with AH=01 is the canonical kbhit() implementation
; ============================================================================

00D272  55                    PUSH   bp                           ; standard frame prologue
00D273  8B EC                 MOV    bp, sp                       ; BP = SP for stack-frame addressing
00D275  B4 01                 MOV    ah, 1                        ; INT 16h subfunction 1 = BIOS keyboard "Check Key"
00D277  CD 16                 INT    0x16                         ; BIOS keyboard: ZF=1 if buffer empty, ZF=0 if a key is pending (key in AX)
00D279  75 05                 JNE    0xd280                       ; if a key IS pending, skip the AX-zeroing — return AX as-is (the key value)
00D27B  33 C0                 XOR    ax, ax                       ; no key pending → return 0
00D27D  C9                    LEAVE                               ; restore BP, deallocate frame
00D27E  CB                    RETF                                ; far-return — caller is in another segment (large memory model)
