; MAPEDIT.EXE named disasm — module btype_4.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @btoi  file 0x011B6E..0x011BB6  seg 0x1056:0xe  (btype_4.c.obj) ----
  011B6E  57               push di
  011B6F  56               push si
  011B70  2bff             sub di, di
  011B72  803f00           cmp byte ptr [bx], 0
  011B75  7439             je 0x11bb0
  011B77  8bf3             mov si, bx
  011B79  8a04             mov al, byte ptr [si]
  011B7B  98               cwde
  011B7C  8bd0             mov dx, ax
  011B7E  46               inc si
  011B7F  8bda             mov bx, dx
  011B81  f687a94502       test byte ptr [bx + 0x45a9], 2
  011B86  7403             je 0x11b8b
  011B88  83ea20           sub dx, 0x20
  011B8B  83fa30           cmp dx, 0x30
  011B8E  7412             je 0x11ba2
  011B90  83fa31           cmp dx, 0x31
  011B93  740d             je 0x11ba2
  011B95  803c00           cmp byte ptr [si], 0
  011B98  7411             je 0x11bab
  011B9A  46               inc si
  011B9B  803c00           cmp byte ptr [si], 0
  011B9E  75fa             jne 0x11b9a
  011BA0  eb09             jmp 0x11bab
  011BA2  d1e7             shl di, 1
  011BA4  8bc2             mov ax, dx
  011BA6  2d3000           sub ax, 0x30
  011BA9  03f8             add di, ax
  011BAB  803c00           cmp byte ptr [si], 0
  011BAE  75c9             jne 0x11b79
  011BB0  8bc7             mov ax, di
  011BB2  5e               pop si
  011BB3  5f               pop di
  011BB4  cb               retf
  011BB5  90               nop
