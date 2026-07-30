; MAPEDIT.EXE named disasm — module strnicmp.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _strnicmp  file 0x015892..0x0158EA  seg 0x1388:0xa12  (strnicmp.asm.obj) ----
  015892  55               push bp
  015893  8bec             mov bp, sp
  015895  57               push di
  015896  56               push si
  015897  8b7606           mov si, word ptr [bp + 6]
  01589A  8b7e08           mov di, word ptr [bp + 8]
  01589D  1e               push ds
  01589E  07               pop es
  01589F  8b4e0a           mov cx, word ptr [bp + 0xa]
  0158A2  e33d             jcxz 0x158e1
  0158A4  b741             mov bh, 0x41
  0158A6  b35a             mov bl, 0x5a
  0158A8  b620             mov dh, 0x20
  0158AA  8a24             mov ah, byte ptr [si]
  0158AC  8a05             mov al, byte ptr [di]
  0158AE  0ae4             or ah, ah
  0158B0  7420             je 0x158d2
  0158B2  0ac0             or al, al
  0158B4  741c             je 0x158d2
  0158B6  46               inc si
  0158B7  47               inc di
  0158B8  3ae7             cmp ah, bh
  0158BA  7206             jb 0x158c2
  0158BC  3ae3             cmp ah, bl
  0158BE  7702             ja 0x158c2
  0158C0  02e6             add ah, dh
  0158C2  3ac7             cmp al, bh
  0158C4  7206             jb 0x158cc
  0158C6  3ac3             cmp al, bl
  0158C8  7702             ja 0x158cc
  0158CA  02c6             add al, dh
  0158CC  3ae0             cmp ah, al
  0158CE  7508             jne 0x158d8
  0158D0  e2d8             loop 0x158aa
  0158D2  33c9             xor cx, cx
  0158D4  3ae0             cmp ah, al
  0158D6  7409             je 0x158e1
  0158D8  b90000           mov cx, 0
  0158DB  7202             jb 0x158df
  0158DD  49               dec cx
  0158DE  49               dec cx
  0158DF  f7d1             not cx
  0158E1  8bc1             mov ax, cx
  0158E3  5e               pop si
  0158E4  5f               pop di
  0158E5  8be5             mov sp, bp
  0158E7  5d               pop bp
  0158E8  cb               retf
  0158E9  00               .byte 0x00
