; MAPEDIT.EXE named disasm — module font_2.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @font_write  file 0x00EB38..0x00ECA6  seg 0xD53:0x8  (font_2.c.obj) ----
  00EB38  c8660000         enter 0x66, 0
  00EB3C  52               push dx
  00EB3D  50               push ax
  00EB3E  53               push bx
  00EB3F  57               push di
  00EB40  56               push si
  00EB41  2bc0             sub ax, ax
  00EB43  8946a4           mov word ptr [bp - 0x5c], ax
  00EB46  8946a2           mov word ptr [bp - 0x5e], ax
  00EB49  89469c           mov word ptr [bp - 0x64], ax
  00EB4C  8bca             mov cx, dx
  00EB4E  a1aa3a           mov ax, word ptr [0x3aaa]
  00EB51  8b16ac3a         mov dx, word ptr [0x3aac]
  00EB55  8946fa           mov word ptr [bp - 6], ax
  00EB58  8956fc           mov word ptr [bp - 4], dx
  00EB5B  ff760a           push word ptr [bp + 0xa]
  00EB5E  ff7608           push word ptr [bp + 8]
  00EB61  8d46aa           lea ax, [bp - 0x56]
  00EB64  16               push ss
  00EB65  50               push ax
  00EB66  8bf1             mov si, cx
  00EB68  9aec0d8813       lcall 0x1388, 0xdec
  00EB6D  83c408           add sp, 8
  00EB70  0bf6             or si, si
  00EB72  7d0a             jge 0xeb7e
  00EB74  f7de             neg si
  00EB76  8976a4           mov word ptr [bp - 0x5c], si
  00EB79  c746980000       mov word ptr [bp - 0x68], 0
  00EB7E  c45e0c           les bx, ptr [bp + 0xc]
  00EB81  268a07           mov al, byte ptr es:[bx]
  00EB84  2ae4             sub ah, ah
  00EB86  2b46a4           sub ax, word ptr [bp - 0x5c]
  00EB89  7902             jns 0xeb8d
  00EB8B  2bc0             sub ax, ax
  00EB8D  8846a6           mov byte ptr [bp - 0x5a], al
  00EB90  98               cwde
  00EB91  8bc8             mov cx, ax
  00EB93  034698           add ax, word ptr [bp - 0x68]
  00EB96  48               dec ax
  00EB97  8946a8           mov word ptr [bp - 0x58], ax
  00EB9A  8b5e94           mov bx, word ptr [bp - 0x6c]
  00EB9D  8b17             mov dx, word ptr [bx]
  00EB9F  8bda             mov bx, dx
  00EBA1  4a               dec dx
  00EBA2  3bc2             cmp ax, dx
  00EBA4  7e14             jle 0xebba
  00EBA6  2bc3             sub ax, bx
  00EBA8  40               inc ax
  00EBA9  3bc1             cmp ax, cx
  00EBAB  7e02             jle 0xebaf
  00EBAD  8bc1             mov ax, cx
  00EBAF  8946a2           mov word ptr [bp - 0x5e], ax
  00EBB2  2a46a6           sub al, byte ptr [bp - 0x5a]
  00EBB5  f6d8             neg al
  00EBB7  8846a6           mov byte ptr [bp - 0x5a], al
  00EBBA  807ea600         cmp byte ptr [bp - 0x5a], 0
  00EBBE  7f03             jg 0xebc3
  00EBC0  e9da00           jmp 0xec9d
  00EBC3  8b5e94           mov bx, word ptr [bp - 0x6c]
  00EBC6  8b4696           mov ax, word ptr [bp - 0x6a]
  00EBC9  8b5698           mov dx, word ptr [bp - 0x68]
  00EBCC  9a0000910c       lcall 0xc91, 0
  00EBD1  89469e           mov word ptr [bp - 0x62], ax
  00EBD4  8956a0           mov word ptr [bp - 0x60], dx
  00EBD7  8b5e94           mov bx, word ptr [bp - 0x6c]
  00EBDA  8b4702           mov ax, word ptr [bx + 2]
  00EBDD  8946fe           mov word ptr [bp - 2], ax
  00EBE0  8b4696           mov ax, word ptr [bp - 0x6a]
  00EBE3  89469a           mov word ptr [bp - 0x66], ax
  00EBE6  1e               push ds
  00EBE7  bbaaff           mov bx, 0xffaa
  00EBEA  03dd             add bx, bp
  00EBEC  c47e9e           les di, ptr [bp - 0x62]
  00EBEF  c5760c           lds si, ptr [bp + 0xc]
  00EBF2  368a17           mov dl, byte ptr ss:[bx]
  00EBF5  43               inc bx
  00EBF6  feca             dec dl
  00EBF8  7904             jns 0xebfe
  00EBFA  e99200           jmp 0xec8f
  00EBFD  90               nop
  00EBFE  53               push bx
  00EBFF  56               push si
  00EC00  57               push di
  00EC01  8ada             mov bl, dl
  00EC03  32ff             xor bh, bh
  00EC05  8a4002           mov al, byte ptr [bx + si + 2]
  00EC08  8ac8             mov cl, al
  00EC0A  0ac9             or cl, cl
  00EC0C  7502             jne 0xec10
  00EC0E  eb64             jmp 0xec74
  00EC10  32ed             xor ch, ch
  00EC12  014e9a           add word ptr [bp - 0x66], cx
  00EC15  8b56fe           mov dx, word ptr [bp - 2]
  00EC18  39569a           cmp word ptr [bp - 0x66], dx
  00EC1B  7603             jbe 0xec20
  00EC1D  eb6d             jmp 0xec8c
  00EC1F  90               nop
  00EC20  d1e3             shl bx, 1
  00EC22  8bb08200         mov si, word ptr [bx + si + 0x82]
  00EC26  8b46a4           mov ax, word ptr [bp - 0x5c]
  00EC29  0bc0             or ax, ax
  00EC2B  740d             je 0xec3a
  00EC2D  32f6             xor dh, dh
  00EC2F  8ad1             mov dl, cl
  00EC31  4a               dec dx
  00EC32  c1ea02           shr dx, 2
  00EC35  42               inc dx
  00EC36  f7e2             mul dx
  00EC38  03f0             add si, ax
  00EC3A  8a76a6           mov dh, byte ptr [bp - 0x5a]
  00EC3D  8ad1             mov dl, cl
  00EC3F  b504             mov ch, 4
  00EC41  ac               lodsb al, byte ptr [si]
  00EC42  57               push di
  00EC43  32e4             xor ah, ah
  00EC45  c1e002           shl ax, 2
  00EC48  8adc             mov bl, ah
  00EC4A  32ff             xor bh, bh
  00EC4C  87de             xchg si, bx
  00EC4E  8a62fa           mov ah, byte ptr [bp + si - 6]
  00EC51  87f3             xchg bx, si
  00EC53  80fcff           cmp ah, 0xff
  00EC56  7403             je 0xec5b
  00EC58  268825           mov byte ptr es:[di], ah
  00EC5B  47               inc di
  00EC5C  feca             dec dl
  00EC5E  740a             je 0xec6a
  00EC60  fecd             dec ch
  00EC62  75df             jne 0xec43
  00EC64  ac               lodsb al, byte ptr [si]
  00EC65  b504             mov ch, 4
  00EC67  ebda             jmp 0xec43
  00EC69  90               nop
  00EC6A  5f               pop di
  00EC6B  fece             dec dh
  00EC6D  7405             je 0xec74
  00EC6F  037efe           add di, word ptr [bp - 2]
  00EC72  ebc9             jmp 0xec3d
  00EC74  5f               pop di
  00EC75  8ac1             mov al, cl
  00EC77  98               cwde
  00EC78  0bc0             or ax, ax
  00EC7A  740a             je 0xec86
  00EC7C  03f8             add di, ax
  00EC7E  8b5606           mov dx, word ptr [bp + 6]
  00EC81  03fa             add di, dx
  00EC83  01569a           add word ptr [bp - 0x66], dx
  00EC86  5e               pop si
  00EC87  5b               pop bx
  00EC88  e967ff           jmp 0xebf2
  00EC8B  90               nop
  00EC8C  5f               pop di
  00EC8D  5e               pop si
  00EC8E  5b               pop bx
  00EC8F  8b769e           mov si, word ptr [bp - 0x62]
  00EC92  2bfe             sub di, si
  00EC94  8b4696           mov ax, word ptr [bp - 0x6a]
  00EC97  03c7             add ax, di
  00EC99  89469c           mov word ptr [bp - 0x64], ax
  00EC9C  1f               pop ds
  00EC9D  8b469c           mov ax, word ptr [bp - 0x64]
  00ECA0  5e               pop si
  00ECA1  5f               pop di
  00ECA2  c9               leave
  00ECA3  ca0a00           retf 0xa
