; MAPEDIT.EXE named disasm — module BUFFER_5.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @buffer_rect_fill  file 0x00DBB4..0x00DC70  seg 0xC5B:0x4  (BUFFER_5.C.obj) ----
  00DBB4  c8080000         enter 8, 0
  00DBB8  53               push bx
  00DBB9  52               push dx
  00DBBA  50               push ax
  00DBBB  57               push di
  00DBBC  56               push si
  00DBBD  8d46f6           lea ax, [bp - 0xa]
  00DBC0  50               push ax
  00DBC1  8d4608           lea ax, [bp + 8]
  00DBC4  50               push ax
  00DBC5  8d5e0a           lea bx, [bp + 0xa]
  00DBC8  8d46f2           lea ax, [bp - 0xe]
  00DBCB  8d56f4           lea dx, [bp - 0xc]
  00DBCE  9a4400910c       lcall 0xc91, 0x44
  00DBD3  0bc0             or ax, ax
  00DBD5  7403             je 0xdbda
  00DBD7  e98d00           jmp 0xdc67
  00DBDA  8b460c           mov ax, word ptr [bp + 0xc]
  00DBDD  2b46f6           sub ax, word ptr [bp - 0xa]
  00DBE0  8946fe           mov word ptr [bp - 2], ax
  00DBE3  8b4610           mov ax, word ptr [bp + 0x10]
  00DBE6  0b460e           or ax, word ptr [bp + 0xe]
  00DBE9  7405             je 0xdbf0
  00DBEB  b80100           mov ax, 1
  00DBEE  eb02             jmp 0xdbf2
  00DBF0  2bc0             sub ax, ax
  00DBF2  8946f8           mov word ptr [bp - 8], ax
  00DBF5  0bc0             or ax, ax
  00DBF7  746e             je 0xdc67
  00DBF9  8d5e0a           lea bx, [bp + 0xa]
  00DBFC  8b46f2           mov ax, word ptr [bp - 0xe]
  00DBFF  8b56f4           mov dx, word ptr [bp - 0xc]
  00DC02  9a0000910c       lcall 0xc91, 0
  00DC07  52               push dx
  00DC08  50               push ax
  00DC09  9a02004f10       lcall 0x104f, 2
  00DC0E  8946fa           mov word ptr [bp - 6], ax
  00DC11  8956fc           mov word ptr [bp - 4], dx
  00DC14  c47efa           les di, ptr [bp - 6]
  00DC17  8a4606           mov al, byte ptr [bp + 6]
  00DC1A  8b7608           mov si, word ptr [bp + 8]
  00DC1D  0bf6             or si, si
  00DC1F  7503             jne 0xdc24
  00DC21  eb44             jmp 0xdc67
  00DC23  90               nop
  00DC24  8b56f6           mov dx, word ptr [bp - 0xa]
  00DC27  8b5efe           mov bx, word ptr [bp - 2]
  00DC2A  8ae0             mov ah, al
  00DC2C  d1ea             shr dx, 1
  00DC2E  731e             jae 0xdc4e
  00DC30  0bd2             or dx, dx
  00DC32  7404             je 0xdc38
  00DC34  8bca             mov cx, dx
  00DC36  f3ab             rep stosw word ptr es:[di], ax
  00DC38  aa               stosb byte ptr es:[di], al
  00DC39  03fb             add di, bx
  00DC3B  790c             jns 0xdc49
  00DC3D  81ef0080         sub di, 0x8000
  00DC41  8cc1             mov cx, es
  00DC43  81c10008         add cx, 0x800
  00DC47  8ec1             mov es, cx
  00DC49  4e               dec si
  00DC4A  75e4             jne 0xdc30
  00DC4C  eb19             jmp 0xdc67
  00DC4E  7417             je 0xdc67
  00DC50  8bca             mov cx, dx
  00DC52  f3ab             rep stosw word ptr es:[di], ax
  00DC54  03fb             add di, bx
  00DC56  790c             jns 0xdc64
  00DC58  81ef0080         sub di, 0x8000
  00DC5C  8cc1             mov cx, es
  00DC5E  81c10008         add cx, 0x800
  00DC62  8ec1             mov es, cx
  00DC64  4e               dec si
  00DC65  75e9             jne 0xdc50
  00DC67  8b46f8           mov ax, word ptr [bp - 8]
  00DC6A  5e               pop si
  00DC6B  5f               pop di
  00DC6C  c9               leave
  00DC6D  ca0c00           retf 0xc
