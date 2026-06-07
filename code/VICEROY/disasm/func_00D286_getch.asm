; ============================================================================
; func_00D286_getch
; Region   : load_image
; Bytes    : file 0x00D286..0x00D295  (15 bytes)
; Purpose  : C `getch()` / `_getch()`: BIOS keyboard blocking read. Issues INT 16h, AH=0 (Get Key). The BIOS waits for a key, returns scan-code in AH and ASCII in AL. If AL is 0 it's an extended key (function key, arrow, etc.) — the runtime convention here returns the full AX (preserves AH); if AL!=0 it returns AL with AH zeroed (return just the ASCII character).
; Args     : (none)
; Returns  : AX = the keystroke. AL is the ASCII character (or 0 for extended keys, in which case AH is the scan code).
; Callers  : TBD (xrefs not yet gathered)
; Callees  : INT 16h AH=00h (BIOS keyboard Get Key)
; Verified : boundary verified: PUSH BP / MOV BP, SP at 0xD286; LEAVE / RETF at 0xD293-0xD294
; Source   : manually identified — INT 16h with AH=00 is the canonical getch() implementation
; ============================================================================

00D286  55                    PUSH   bp                           ; standard frame prologue
00D287  8B EC                 MOV    bp, sp                       ; BP = SP for stack-frame addressing
00D289  B4 00                 MOV    ah, 0                        ; INT 16h subfunction 0 = BIOS keyboard "Get Key" (blocking read)
00D28B  CD 16                 INT    0x16                         ; BIOS keyboard: blocks until a key is pressed → AL = ASCII, AH = scan code
00D28D  0A C0                 OR     al, al                       ; AL == 0 means an extended key (function key / arrow / etc.) — preserve full AX
00D28F  74 05                 JE     0xd296                       ; if extended key, jump past the AH-clear so caller sees the scan code
00D291  32 E4                 XOR    ah, ah                       ; ordinary ASCII key → clear AH so the return value is just the ASCII character
00D293  C9                    LEAVE                               ; restore BP, deallocate frame
00D294  CB                    RETF                                ; far-return to the caller
