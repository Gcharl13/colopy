; MAPEDIT.EXE named disasm — module write.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _write  file 0x016BB6..0x016CF6  seg 0x1388:0x1d36  (write.asm.obj) ----
  016BB6  55               push bp
  016BB7  8bec             mov bp, sp
  016BB9  83ec08           sub sp, 8
  016BBC  8b5e06           mov bx, word ptr [bp + 6]
  016BBF  3b1e7545         cmp bx, word ptr [0x4575]
  016BC3  7207             jb 0x16bcc
  016BC5  b80009           mov ax, 0x900
  016BC8  f9               stc
  016BC9  e901f5           jmp 0x160cd
  016BCC  813e9648d6d6     cmp word ptr [0x4896], 0xd6d6
  016BD2  7504             jne 0x16bd8
  016BD4  ff169848         call word ptr [0x4898]
  016BD8  f687774520       test byte ptr [bx + 0x4577], 0x20
  016BDD  740b             je 0x16bea
  016BDF  b80242           mov ax, 0x4202
  016BE2  33c9             xor cx, cx
  016BE4  8bd1             mov dx, cx
  016BE6  cd21             int 0x21
  016BE8  72df             jb 0x16bc9
  016BEA  f687774580       test byte ptr [bx + 0x4577], 0x80
  016BEF  7470             je 0x16c61
  016BF1  8b5608           mov dx, word ptr [bp + 8]
  016BF4  1e               push ds
  016BF5  07               pop es
  016BF6  33c0             xor ax, ax
  016BF8  8946fe           mov word ptr [bp - 2], ax
  016BFB  8946fc           mov word ptr [bp - 4], ax
  016BFE  fc               cld
  016BFF  57               push di
  016C00  56               push si
  016C01  8bfa             mov di, dx
  016C03  8bf2             mov si, dx
  016C05  8966f8           mov word ptr [bp - 8], sp
  016C08  8b4e0a           mov cx, word ptr [bp + 0xa]
  016C0B  e33a             jcxz 0x16c47
  016C0D  b00a             mov al, 0xa
  016C0F  f2ae             repne scasb al, byte ptr es:[di]
  016C11  754c             jne 0x16c5f
  016C13  9ade238813       lcall 0x1388, 0x23de
  016C18  3da800           cmp ax, 0xa8
  016C1B  7646             jbe 0x16c63
  016C1D  83ec02           sub sp, 2
  016C20  8bdc             mov bx, sp
  016C22  ba0002           mov dx, 0x200
  016C25  3d2802           cmp ax, 0x228
  016C28  7303             jae 0x16c2d
  016C2A  ba8000           mov dx, 0x80
  016C2D  2be2             sub sp, dx
  016C2F  8bd4             mov dx, sp
  016C31  8bfa             mov di, dx
  016C33  16               push ss
  016C34  07               pop es
  016C35  8b4e0a           mov cx, word ptr [bp + 0xa]
  016C38  ac               lodsb al, byte ptr [si]
  016C39  3c0a             cmp al, 0xa
  016C3B  740c             je 0x16c49
  016C3D  3bfb             cmp di, bx
  016C3F  7419             je 0x16c5a
  016C41  aa               stosb byte ptr es:[di], al
  016C42  e2f4             loop 0x16c38
  016C44  e82300           call 0x16c6a
  016C47  eb6b             jmp 0x16cb4
  016C49  b00d             mov al, 0xd
  016C4B  3bfb             cmp di, bx
  016C4D  7503             jne 0x16c52
  016C4F  e81800           call 0x16c6a
  016C52  aa               stosb byte ptr es:[di], al
  016C53  b00a             mov al, 0xa
  016C55  ff46fc           inc word ptr [bp - 4]
  016C58  ebe3             jmp 0x16c3d
  016C5A  e80d00           call 0x16c6a
  016C5D  ebe2             jmp 0x16c41
  016C5F  5e               pop si
  016C60  5f               pop di
  016C61  eb5f             jmp 0x16cc2
  016C63  b8fcff           mov ax, 0xfffc
  016C66  0e               push cs
  016C67  e8b4e4           call 0x1511e
  016C6A  50               push ax
  016C6B  53               push bx
  016C6C  51               push cx
  016C6D  8bcf             mov cx, di
  016C6F  2bca             sub cx, dx
  016C71  e312             jcxz 0x16c85
  016C73  51               push cx
  016C74  8b5e06           mov bx, word ptr [bp + 6]
  016C77  b440             mov ah, 0x40
  016C79  cd21             int 0x21
  016C7B  59               pop cx
  016C7C  720d             jb 0x16c8b
  016C7E  0146fe           add word ptr [bp - 2], ax
  016C81  3bc8             cmp cx, ax
  016C83  7706             ja 0x16c8b
  016C85  59               pop cx
  016C86  5b               pop bx
  016C87  58               pop ax
  016C88  8bfa             mov di, dx
  016C8A  c3               ret
  016C8B  9f               lahf
  016C8C  83c408           add sp, 8
  016C8F  837efe00         cmp word ptr [bp - 2], 0
  016C93  751f             jne 0x16cb4
  016C95  9e               sahf
  016C96  7304             jae 0x16c9c
  016C98  b409             mov ah, 9
  016C9A  eb1e             jmp 0x16cba
  016C9C  f687774540       test byte ptr [bx + 0x4577], 0x40
  016CA1  740b             je 0x16cae
  016CA3  8b5e08           mov bx, word ptr [bp + 8]
  016CA6  803f1a           cmp byte ptr [bx], 0x1a
  016CA9  7503             jne 0x16cae
  016CAB  f8               clc
  016CAC  eb0c             jmp 0x16cba
  016CAE  f9               stc
  016CAF  b8001c           mov ax, 0x1c00
  016CB2  eb06             jmp 0x16cba
  016CB4  8b46fe           mov ax, word ptr [bp - 2]
  016CB7  2b46fc           sub ax, word ptr [bp - 4]
  016CBA  8b66f8           mov sp, word ptr [bp - 8]
  016CBD  5e               pop si
  016CBE  5f               pop di
  016CBF  e90bf4           jmp 0x160cd
  016CC2  8b4e0a           mov cx, word ptr [bp + 0xa]
  016CC5  0bc9             or cx, cx
  016CC7  7505             jne 0x16cce
  016CC9  8bc1             mov ax, cx
  016CCB  e9fff3           jmp 0x160cd
  016CCE  8b5608           mov dx, word ptr [bp + 8]
  016CD1  b440             mov ah, 0x40
  016CD3  cd21             int 0x21
  016CD5  7304             jae 0x16cdb
  016CD7  b409             mov ah, 9
  016CD9  ebe4             jmp 0x16cbf
  016CDB  0bc0             or ax, ax
  016CDD  75e0             jne 0x16cbf
  016CDF  f687774540       test byte ptr [bx + 0x4577], 0x40
  016CE4  740a             je 0x16cf0
  016CE6  8bda             mov bx, dx
  016CE8  803f1a           cmp byte ptr [bx], 0x1a
  016CEB  7503             jne 0x16cf0
  016CED  f8               clc
  016CEE  ebcf             jmp 0x16cbf
  016CF0  f9               stc
  016CF1  b8001c           mov ax, 0x1c00
  016CF4  ebc9             jmp 0x16cbf
