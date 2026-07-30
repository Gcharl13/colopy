; MAPEDIT.EXE named disasm — module keys_3.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @keys_fix_alt  file 0x00D12E..0x00D240  seg 0xBB2:0xe  (keys_3.c.obj) ----
  00D12E  55               push bp
  00D12F  8bec             mov bp, sp
  00D131  50               push ax
  00D132  8bd0             mov dx, ax
  00D134  2d1001           sub ax, 0x110
  00D137  3d2200           cmp ax, 0x22
  00D13A  774e             ja 0xd18a
  00D13C  d1e0             shl ax, 1
  00D13E  93               xchg bx, ax
  00D13F  2effa72400       jmp word ptr cs:[bx + 0x24]
  00D144  820088           add byte ptr [bx + si], 0x88
  00D147  008e0094         add byte ptr [bp - 0x6c00], cl
  00D14B  009c00a2         add byte ptr [si - 0x5e00], bl
  00D14F  00a800ae         add byte ptr [bx + si - 0x5200], ch
  00D153  00b400ba         add byte ptr [si - 0x4600], dh
  00D157  006a00           add byte ptr [bp + si], ch
  00D15A  6a00             push 0
  00D15C  6a00             push 0
  00D15E  6a00             push 0
  00D160  c000c6           rol byte ptr [bx + si], 0xc6
  00D163  00cc             add ah, cl
  00D165  00d2             add dl, dl
  00D167  00d8             add al, bl
  00D169  00de             add dh, bl
  00D16B  00e4             add ah, ah
  00D16D  00ea             add dl, ch
  00D16F  00f0             add al, dh
  00D171  006a00           add byte ptr [bp + si], ch
  00D174  6a00             push 0
  00D176  6a00             push 0
  00D178  6a00             push 0
  00D17A  6a00             push 0
  00D17C  f600fc           test byte ptr [bx + si], 0xfc
  00D17F  0002             add byte ptr [bp + si], al
  00D181  0108             add word ptr [bx + si], cx
  00D183  010e0114         add word ptr [0x1401], cx
  00D187  011a             add word ptr [bp + si], bx
  00D189  0183fa61         add word ptr [bp + di + 0x61fa], ax
  00D18D  7c0d             jl 0xd19c
  00D18F  83fa7a           cmp dx, 0x7a
  00D192  7f08             jg 0xd19c
  00D194  8bc2             mov ax, dx
  00D196  2d2000           sub ax, 0x20
  00D199  e9a100           jmp 0xd23d
  00D19C  8bc2             mov ax, dx
  00D19E  e99c00           jmp 0xd23d
  00D1A1  90               nop
  00D1A2  b85100           mov ax, 0x51
  00D1A5  e99500           jmp 0xd23d
  00D1A8  b85700           mov ax, 0x57
  00D1AB  e98f00           jmp 0xd23d
  00D1AE  b84500           mov ax, 0x45
  00D1B1  e98900           jmp 0xd23d
  00D1B4  b85200           mov ax, 0x52
  00D1B7  e98300           jmp 0xd23d
  00D1BA  90               nop
  00D1BB  90               nop
  00D1BC  b85400           mov ax, 0x54
  00D1BF  eb7c             jmp 0xd23d
  00D1C1  90               nop
  00D1C2  b85900           mov ax, 0x59
  00D1C5  eb76             jmp 0xd23d
  00D1C7  90               nop
  00D1C8  b85500           mov ax, 0x55
  00D1CB  eb70             jmp 0xd23d
  00D1CD  90               nop
  00D1CE  b84900           mov ax, 0x49
  00D1D1  eb6a             jmp 0xd23d
  00D1D3  90               nop
  00D1D4  b84f00           mov ax, 0x4f
  00D1D7  eb64             jmp 0xd23d
  00D1D9  90               nop
  00D1DA  b85000           mov ax, 0x50
  00D1DD  eb5e             jmp 0xd23d
  00D1DF  90               nop
  00D1E0  b84100           mov ax, 0x41
  00D1E3  eb58             jmp 0xd23d
  00D1E5  90               nop
  00D1E6  b85300           mov ax, 0x53
  00D1E9  eb52             jmp 0xd23d
  00D1EB  90               nop
  00D1EC  b84400           mov ax, 0x44
  00D1EF  eb4c             jmp 0xd23d
  00D1F1  90               nop
  00D1F2  b84600           mov ax, 0x46
  00D1F5  eb46             jmp 0xd23d
  00D1F7  90               nop
  00D1F8  b84700           mov ax, 0x47
  00D1FB  eb40             jmp 0xd23d
  00D1FD  90               nop
  00D1FE  b84800           mov ax, 0x48
  00D201  eb3a             jmp 0xd23d
  00D203  90               nop
  00D204  b84a00           mov ax, 0x4a
  00D207  eb34             jmp 0xd23d
  00D209  90               nop
  00D20A  b84b00           mov ax, 0x4b
  00D20D  eb2e             jmp 0xd23d
  00D20F  90               nop
  00D210  b84c00           mov ax, 0x4c
  00D213  eb28             jmp 0xd23d
  00D215  90               nop
  00D216  b85a00           mov ax, 0x5a
  00D219  eb22             jmp 0xd23d
  00D21B  90               nop
  00D21C  b85800           mov ax, 0x58
  00D21F  c9               leave
  00D220  cb               retf
  00D221  90               nop
  00D222  b84300           mov ax, 0x43
  00D225  c9               leave
  00D226  cb               retf
  00D227  90               nop
  00D228  b85600           mov ax, 0x56
  00D22B  c9               leave
  00D22C  cb               retf
  00D22D  90               nop
  00D22E  b84200           mov ax, 0x42
  00D231  c9               leave
  00D232  cb               retf
  00D233  90               nop
  00D234  b84e00           mov ax, 0x4e
  00D237  c9               leave
  00D238  cb               retf
  00D239  90               nop
  00D23A  b84d00           mov ax, 0x4d
  00D23D  c9               leave
  00D23E  cb               retf
  00D23F  90               nop
