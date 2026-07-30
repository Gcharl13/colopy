; MAPEDIT.EXE named disasm — module map_a.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @compute_view_parameters  file 0x00BA76..0x00C7D6  seg 0xA47:0x6  (map_a.obj) ----
  00BA76  c8040000         enter 4, 0
  00BA7A  8a0ed004         mov cl, byte ptr [0x4d0]
  00BA7E  b80f00           mov ax, 0xf
  00BA81  d3e0             shl ax, cl
  00BA83  a3d452           mov word ptr [0x52d4], ax
  00BA86  b80c00           mov ax, 0xc
  00BA89  d3e0             shl ax, cl
  00BA8B  a3d852           mov word ptr [0x52d8], ax
  00BA8E  833ed60400       cmp word ptr [0x4d6], 0
  00BA93  740f             je 0xbaa4
  00BA95  b80500           mov ax, 5
  00BA98  a3d452           mov word ptr [0x52d4], ax
  00BA9B  a3d852           mov word ptr [0x52d8], ax
  00BA9E  c706d0040000     mov word ptr [0x4d0], 0
  00BAA4  8a0ed004         mov cl, byte ptr [0x4d0]
  00BAA8  b81000           mov ax, 0x10
  00BAAB  d3f8             sar ax, cl
  00BAAD  a38a4e           mov word ptr [0x4e8a], ax
  00BAB0  a38c4e           mov word ptr [0x4e8c], ax
  00BAB3  a1d452           mov ax, word ptr [0x52d4]
  00BAB6  d1f8             sar ax, 1
  00BAB8  2b06c804         sub ax, word ptr [0x4c8]
  00BABC  f7d8             neg ax
  00BABE  a3f249           mov word ptr [0x49f2], ax
  00BAC1  8b0ed852         mov cx, word ptr [0x52d8]
  00BAC5  d1f9             sar cx, 1
  00BAC7  2b0eca04         sub cx, word ptr [0x4ca]
  00BACB  f7d9             neg cx
  00BACD  890ef449         mov word ptr [0x49f4], cx
  00BAD1  833ed60400       cmp word ptr [0x4d6], 0
  00BAD6  7534             jne 0xbb0c
  00BAD8  3d0100           cmp ax, 1
  00BADB  7d03             jge 0xbae0
  00BADD  b80100           mov ax, 1
  00BAE0  8b16124b         mov dx, word ptr [0x4b12]
  00BAE4  2b16d452         sub dx, word ptr [0x52d4]
  00BAE8  4a               dec dx
  00BAE9  3bc2             cmp ax, dx
  00BAEB  7e02             jle 0xbaef
  00BAED  8bc2             mov ax, dx
  00BAEF  a3f249           mov word ptr [0x49f2], ax
  00BAF2  83f901           cmp cx, 1
  00BAF5  7d03             jge 0xbafa
  00BAF7  b90100           mov cx, 1
  00BAFA  a1144b           mov ax, word ptr [0x4b14]
  00BAFD  2b06d852         sub ax, word ptr [0x52d8]
  00BB01  48               dec ax
  00BB02  3bc8             cmp cx, ax
  00BB04  7e02             jle 0xbb08
  00BB06  8bc8             mov cx, ax
  00BB08  890ef449         mov word ptr [0x49f4], cx
  00BB0C  2bc0             sub ax, ax
  00BB0E  a3d85a           mov word ptr [0x5ad8], ax
  00BB11  a3f45a           mov word ptr [0x5af4], ax
  00BB14  a1124b           mov ax, word ptr [0x4b12]
  00BB17  48               dec ax
  00BB18  48               dec ax
  00BB19  3b06d452         cmp ax, word ptr [0x52d4]
  00BB1D  7d19             jge 0xbb38
  00BB1F  c706f2490100     mov word ptr [0x49f2], 1
  00BB25  8b0ed452         mov cx, word ptr [0x52d4]
  00BB29  2b0e124b         sub cx, word ptr [0x4b12]
  00BB2D  41               inc cx
  00BB2E  41               inc cx
  00BB2F  d1f9             sar cx, 1
  00BB31  890ed85a         mov word ptr [0x5ad8], cx
  00BB35  a3d452           mov word ptr [0x52d4], ax
  00BB38  a1144b           mov ax, word ptr [0x4b14]
  00BB3B  48               dec ax
  00BB3C  48               dec ax
  00BB3D  3b06d852         cmp ax, word ptr [0x52d8]
  00BB41  7d19             jge 0xbb5c
  00BB43  c706f4490100     mov word ptr [0x49f4], 1
  00BB49  8b0ed852         mov cx, word ptr [0x52d8]
  00BB4D  2b0e144b         sub cx, word ptr [0x4b14]
  00BB51  41               inc cx
  00BB52  41               inc cx
  00BB53  d1f9             sar cx, 1
  00BB55  890ef45a         mov word ptr [0x5af4], cx
  00BB59  a3d852           mov word ptr [0x52d8], ax
  00BB5C  a1f249           mov ax, word ptr [0x49f2]
  00BB5F  48               dec ax
  00BB60  a3f65a           mov word ptr [0x5af6], ax
  00BB63  a1f449           mov ax, word ptr [0x49f4]
  00BB66  48               dec ax
  00BB67  a3f85a           mov word ptr [0x5af8], ax
  00BB6A  833ea60400       cmp word ptr [0x4a6], 0
  00BB6F  7471             je 0xbbe2
  00BB71  833ed60400       cmp word ptr [0x4d6], 0
  00BB76  7518             jne 0xbb90
  00BB78  8a0ed004         mov cl, byte ptr [0x4d0]
  00BB7C  b80f00           mov ax, 0xf
  00BB7F  d3e0             shl ax, cl
  00BB81  40               inc ax
  00BB82  40               inc ax
  00BB83  a3704e           mov word ptr [0x4e70], ax
  00BB86  b80c00           mov ax, 0xc
  00BB89  d3e0             shl ax, cl
  00BB8B  40               inc ax
  00BB8C  40               inc ax
  00BB8D  eb5c             jmp 0xbbeb
  00BB8F  90               nop
  00BB90  a1f65a           mov ax, word ptr [0x5af6]
  00BB93  050600           add ax, 6
  00BB96  8946fe           mov word ptr [bp - 2], ax
  00BB99  a1f85a           mov ax, word ptr [0x5af8]
  00BB9C  050600           add ax, 6
  00BB9F  8946fc           mov word ptr [bp - 4], ax
  00BBA2  a1124b           mov ax, word ptr [0x4b12]
  00BBA5  48               dec ax
  00BBA6  3b46fe           cmp ax, word ptr [bp - 2]
  00BBA9  7e03             jle 0xbbae
  00BBAB  8b46fe           mov ax, word ptr [bp - 2]
  00BBAE  8b0ef65a         mov cx, word ptr [0x5af6]
  00BBB2  0bc9             or cx, cx
  00BBB4  7d02             jge 0xbbb8
  00BBB6  2bc9             sub cx, cx
  00BBB8  890ef65a         mov word ptr [0x5af6], cx
  00BBBC  2bc1             sub ax, cx
  00BBBE  40               inc ax
  00BBBF  a3704e           mov word ptr [0x4e70], ax
  00BBC2  a1144b           mov ax, word ptr [0x4b14]
  00BBC5  48               dec ax
  00BBC6  3b46fc           cmp ax, word ptr [bp - 4]
  00BBC9  7e03             jle 0xbbce
  00BBCB  8b46fc           mov ax, word ptr [bp - 4]
  00BBCE  8b0ef85a         mov cx, word ptr [0x5af8]
  00BBD2  0bc9             or cx, cx
  00BBD4  7d02             jge 0xbbd8
  00BBD6  2bc9             sub cx, cx
  00BBD8  890ef85a         mov word ptr [0x5af8], cx
  00BBDC  2bc1             sub ax, cx
  00BBDE  40               inc ax
  00BBDF  eb0a             jmp 0xbbeb
  00BBE1  90               nop
  00BBE2  a1124b           mov ax, word ptr [0x4b12]
  00BBE5  a3704e           mov word ptr [0x4e70], ax
  00BBE8  a1144b           mov ax, word ptr [0x4b14]
  00BBEB  a3764e           mov word ptr [0x4e76], ax
  00BBEE  8a0ed004         mov cl, byte ptr [0x4d0]
  00BBF2  b86400           mov ax, 0x64
  00BBF5  d3f8             sar ax, cl
  00BBF7  a3d204           mov word ptr [0x4d2], ax
  00BBFA  b80500           mov ax, 5
  00BBFD  d3e0             shl ax, cl
  00BBFF  050500           add ax, 5
  00BC02  a3d404           mov word ptr [0x4d4], ax
  00BC05  a1d452           mov ax, word ptr [0x52d4]
  00BC08  0306f249         add ax, word ptr [0x49f2]
  00BC0C  48               dec ax
  00BC0D  a32660           mov word ptr [0x6026], ax
  00BC10  a1d852           mov ax, word ptr [0x52d8]
  00BC13  0306f449         add ax, word ptr [0x49f4]
  00BC17  48               dec ax
  00BC18  a33e60           mov word ptr [0x603e], ax
  00BC1B  c9               leave
  00BC1C  cb               retf
  00BC1D  90               nop
  00BC1E  c8100000         enter 0x10, 0
  00BC22  56               push si
  00BC23  2ac0             sub al, al
  00BC25  a27469           mov byte ptr [0x6974], al
  00BC28  a2d35a           mov byte ptr [0x5ad3], al
  00BC2B  c746fc0000       mov word ptr [bp - 4], 0
  00BC30  8b5efc           mov bx, word ptr [bp - 4]
  00BC33  c6879a4900       mov byte ptr [bx + 0x499a], 0
  00BC38  ff46fc           inc word ptr [bp - 4]
  00BC3B  837efc04         cmp word ptr [bp - 4], 4
  00BC3F  7cef             jl 0xbc30
  00BC41  833ed00400       cmp word ptr [0x4d0], 0
  00BC46  7403             je 0xbc4b
  00BC48  e9bf00           jmp 0xbd0a
  00BC4B  c746fc0000       mov word ptr [bp - 4], 0
  00BC50  e99e00           jmp 0xbcf1
  00BC53  90               nop
  00BC54  a1704e           mov ax, word ptr [0x4e70]
  00BC57  f7d8             neg ax
  00BC59  8946f2           mov word ptr [bp - 0xe], ax
  00BC5C  80bfca0600       cmp byte ptr [bx + 0x6ca], 0
  00BC61  7e05             jle 0xbc68
  00BC63  a1704e           mov ax, word ptr [0x4e70]
  00BC66  eb02             jmp 0xbc6a
  00BC68  2bc0             sub ax, ax
  00BC6A  8946f0           mov word ptr [bp - 0x10], ax
  00BC6D  8a87c006         mov al, byte ptr [bx + 0x6c0]
  00BC71  98               cwde
  00BC72  8bd8             mov bx, ax
  00BC74  031efa5a         add bx, word ptr [0x5afa]
  00BC78  8e06fc5a         mov es, word ptr [0x5afc]
  00BC7C  035ef2           add bx, word ptr [bp - 0xe]
  00BC7F  8b76f0           mov si, word ptr [bp - 0x10]
  00BC82  268a00           mov al, byte ptr es:[bx + si]
  00BC85  241f             and al, 0x1f
  00BC87  8846f6           mov byte ptr [bp - 0xa], al
  00BC8A  3c18             cmp al, 0x18
  00BC8C  7304             jae 0xbc92
  00BC8E  8066f607         and byte ptr [bp - 0xa], 7
  00BC92  8a46f6           mov al, byte ptr [bp - 0xa]
  00BC95  2ae4             sub ah, ah
  00BC97  50               push ax
  00BC98  9abc05ab02       lcall 0x2ab, 0x5bc
  00BC9D  83c402           add sp, 2
  00BCA0  3c19             cmp al, 0x19
  00BCA2  744a             je 0xbcee
  00BCA4  3c1a             cmp al, 0x1a
  00BCA6  7446             je 0xbcee
  00BCA8  8a4efc           mov cl, byte ptr [bp - 4]
  00BCAB  b001             mov al, 1
  00BCAD  d2e0             shl al, cl
  00BCAF  0806d35a         or byte ptr [0x5ad3], al
  00BCB3  fe067469         inc byte ptr [0x6974]
  00BCB7  f646fc01         test byte ptr [bp - 4], 1
  00BCBB  7411             je 0xbcce
  00BCBD  8ad9             mov bl, cl
  00BCBF  fec3             inc bl
  00BCC1  83e306           and bx, 6
  00BCC4  d1fb             sar bx, 1
  00BCC6  808f9a4902       or byte ptr [bx + 0x499a], 2
  00BCCB  eb21             jmp 0xbcee
  00BCCD  90               nop
  00BCCE  8a46f6           mov al, byte ptr [bp - 0xa]
  00BCD1  a2844e           mov byte ptr [0x4e84], al
  00BCD4  8b46fc           mov ax, word ptr [bp - 4]
  00BCD7  d1f8             sar ax, 1
  00BCD9  8bc8             mov cx, ax
  00BCDB  fec0             inc al
  00BCDD  250300           and ax, 3
  00BCE0  8bd9             mov bx, cx
  00BCE2  808f9a4904       or byte ptr [bx + 0x499a], 4
  00BCE7  8bd8             mov bx, ax
  00BCE9  808f9a4901       or byte ptr [bx + 0x499a], 1
  00BCEE  ff46fc           inc word ptr [bp - 4]
  00BCF1  837efc08         cmp word ptr [bp - 4], 8
  00BCF5  7d13             jge 0xbd0a
  00BCF7  8b5efc           mov bx, word ptr [bp - 4]
  00BCFA  80bfca0600       cmp byte ptr [bx + 0x6ca], 0
  00BCFF  7d03             jge 0xbd04
  00BD01  e950ff           jmp 0xbc54
  00BD04  2bc0             sub ax, ax
  00BD06  e950ff           jmp 0xbc59
  00BD09  90               nop
  00BD0A  a0844e           mov al, byte ptr [0x4e84]
  00BD0D  2ae4             sub ah, ah
  00BD0F  50               push ax
  00BD10  9abc05ab02       lcall 0x2ab, 0x5bc
  00BD15  83c402           add sp, 2
  00BD18  a2cc5a           mov byte ptr [0x5acc], al
  00BD1B  a07469           mov al, byte ptr [0x6974]
  00BD1E  2ae4             sub ah, ah
  00BD20  5e               pop si
  00BD21  c9               leave
  00BD22  c3               ret
  00BD23  90               nop
  00BD24  56               push si
  00BD25  c41efa5a         les bx, ptr [0x5afa]
  00BD29  8bf0             mov si, ax
  00BD2B  268a00           mov al, byte ptr es:[bx + si]
  00BD2E  3a06c449         cmp al, byte ptr [0x49c4]
  00BD32  720a             jb 0xbd3e
  00BD34  3a066e52         cmp al, byte ptr [0x526e]
  00BD38  7704             ja 0xbd3e
  00BD3A  00167469         add byte ptr [0x6974], dl
  00BD3E  5e               pop si
  00BD3F  c3               ret
  00BD40  c606746900       mov byte ptr [0x6974], 0
  00BD45  391ed004         cmp word ptr [0x4d0], bx
  00BD49  7f2d             jg 0xbd78
  00BD4B  a2c449           mov byte ptr [0x49c4], al
  00BD4E  8ac2             mov al, dl
  00BD50  a26e52           mov byte ptr [0x526e], al
  00BD53  a1704e           mov ax, word ptr [0x4e70]
  00BD56  f7d8             neg ax
  00BD58  ba0800           mov dx, 8
  00BD5B  e8c6ff           call 0xbd24
  00BD5E  a1704e           mov ax, word ptr [0x4e70]
  00BD61  ba0400           mov dx, 4
  00BD64  e8bdff           call 0xbd24
  00BD67  b8ffff           mov ax, 0xffff
  00BD6A  ba0200           mov dx, 2
  00BD6D  e8b4ff           call 0xbd24
  00BD70  b80100           mov ax, 1
  00BD73  8bd0             mov dx, ax
  00BD75  e8acff           call 0xbd24
  00BD78  a07469           mov al, byte ptr [0x6974]
  00BD7B  2ae4             sub ah, ah
  00BD7D  c3               ret
  00BD7E  c8020000         enter 2, 0
  00BD82  50               push ax
  00BD83  56               push si
  00BD84  c746fe0000       mov word ptr [bp - 2], 0
  00BD89  3b16d004         cmp dx, word ptr [0x4d0]
  00BD8D  7c49             jl 0xbdd8
  00BD8F  c41efa5a         les bx, ptr [0x5afa]
  00BD93  2b1e704e         sub bx, word ptr [0x4e70]
  00BD97  268a07           mov al, byte ptr es:[bx]
  00BD9A  2ae4             sub ah, ah
  00BD9C  8546fc           test word ptr [bp - 4], ax
  00BD9F  7404             je 0xbda5
  00BDA1  8346fe08         add word ptr [bp - 2], 8
  00BDA5  8b1efa5a         mov bx, word ptr [0x5afa]
  00BDA9  8b36704e         mov si, word ptr [0x4e70]
  00BDAD  268a00           mov al, byte ptr es:[bx + si]
  00BDB0  2ae4             sub ah, ah
  00BDB2  8546fc           test word ptr [bp - 4], ax
  00BDB5  7404             je 0xbdbb
  00BDB7  8346fe04         add word ptr [bp - 2], 4
  00BDBB  268a47ff         mov al, byte ptr es:[bx - 1]
  00BDBF  2ae4             sub ah, ah
  00BDC1  8546fc           test word ptr [bp - 4], ax
  00BDC4  7404             je 0xbdca
  00BDC6  8346fe02         add word ptr [bp - 2], 2
  00BDCA  268a4701         mov al, byte ptr es:[bx + 1]
  00BDCE  2ae4             sub ah, ah
  00BDD0  8546fc           test word ptr [bp - 4], ax
  00BDD3  7403             je 0xbdd8
  00BDD5  ff46fe           inc word ptr [bp - 2]
  00BDD8  8b46fe           mov ax, word ptr [bp - 2]
  00BDDB  5e               pop si
  00BDDC  c9               leave
  00BDDD  c3               ret
  00BDDE  c8040000         enter 4, 0
  00BDE2  50               push ax
  00BDE3  56               push si
  00BDE4  c746fc0000       mov word ptr [bp - 4], 0
  00BDE9  3916d004         cmp word ptr [0x4d0], dx
  00BDED  7f58             jg 0xbe47
  00BDEF  c746fea000       mov word ptr [bp - 2], 0xa0
  00BDF4  c41efa5a         les bx, ptr [0x5afa]
  00BDF8  2b1e704e         sub bx, word ptr [0x4e70]
  00BDFC  268a07           mov al, byte ptr es:[bx]
  00BDFF  25a000           and ax, 0xa0
  00BE02  3b46fa           cmp ax, word ptr [bp - 6]
  00BE05  7504             jne 0xbe0b
  00BE07  8346fc08         add word ptr [bp - 4], 8
  00BE0B  8b1efa5a         mov bx, word ptr [0x5afa]
  00BE0F  8b36704e         mov si, word ptr [0x4e70]
  00BE13  268a00           mov al, byte ptr es:[bx + si]
  00BE16  2246fe           and al, byte ptr [bp - 2]
  00BE19  2ae4             sub ah, ah
  00BE1B  3b46fa           cmp ax, word ptr [bp - 6]
  00BE1E  7504             jne 0xbe24
  00BE20  8346fc04         add word ptr [bp - 4], 4
  00BE24  268a47ff         mov al, byte ptr es:[bx - 1]
  00BE28  2246fe           and al, byte ptr [bp - 2]
  00BE2B  2ae4             sub ah, ah
  00BE2D  3b46fa           cmp ax, word ptr [bp - 6]
  00BE30  7504             jne 0xbe36
  00BE32  8346fc02         add word ptr [bp - 4], 2
  00BE36  268a4701         mov al, byte ptr es:[bx + 1]
  00BE3A  2246fe           and al, byte ptr [bp - 2]
  00BE3D  2ae4             sub ah, ah
  00BE3F  3b46fa           cmp ax, word ptr [bp - 6]
  00BE42  7503             jne 0xbe47
  00BE44  ff46fc           inc word ptr [bp - 4]
  00BE47  8b46fc           mov ax, word ptr [bp - 4]
  00BE4A  5e               pop si
  00BE4B  c9               leave
  00BE4C  c3               ret
  00BE4D  90               nop
  00BE4E  c8040000         enter 4, 0
  00BE52  56               push si
  00BE53  c746fc0000       mov word ptr [bp - 4], 0
  00BE58  c41efa5a         les bx, ptr [0x5afa]
  00BE5C  8b7606           mov si, word ptr [bp + 6]
  00BE5F  268a00           mov al, byte ptr es:[bx + si]
  00BE62  251f00           and ax, 0x1f
  00BE65  8946fe           mov word ptr [bp - 2], ax
  00BE68  3d1800           cmp ax, 0x18
  00BE6B  7d14             jge 0xbe81
  00BE6D  8a46fe           mov al, byte ptr [bp - 2]
  00BE70  2407             and al, 7
  00BE72  3c01             cmp al, 1
  00BE74  740b             je 0xbe81
  00BE76  837efe07         cmp word ptr [bp - 2], 7
  00BE7A  7e05             jle 0xbe81
  00BE7C  c746fc0100       mov word ptr [bp - 4], 1
  00BE81  8b46fc           mov ax, word ptr [bp - 4]
  00BE84  5e               pop si
  00BE85  c9               leave
  00BE86  c3               ret
  00BE87  90               nop
  00BE88  c8020000         enter 2, 0
  00BE8C  50               push ax
  00BE8D  c746fe0000       mov word ptr [bp - 2], 0
  00BE92  3916d004         cmp word ptr [0x4d0], dx
  00BE96  7f51             jg 0xbee9
  00BE98  a1704e           mov ax, word ptr [0x4e70]
  00BE9B  f7d8             neg ax
  00BE9D  50               push ax
  00BE9E  ff76fc           push word ptr [bp - 4]
  00BEA1  e8aaff           call 0xbe4e
  00BEA4  83c404           add sp, 4
  00BEA7  0bc0             or ax, ax
  00BEA9  7404             je 0xbeaf
  00BEAB  8346fe08         add word ptr [bp - 2], 8
  00BEAF  ff36704e         push word ptr [0x4e70]
  00BEB3  ff76fc           push word ptr [bp - 4]
  00BEB6  e895ff           call 0xbe4e
  00BEB9  83c404           add sp, 4
  00BEBC  0bc0             or ax, ax
  00BEBE  7404             je 0xbec4
  00BEC0  8346fe04         add word ptr [bp - 2], 4
  00BEC4  6aff             push -1
  00BEC6  ff76fc           push word ptr [bp - 4]
  00BEC9  e882ff           call 0xbe4e
  00BECC  83c404           add sp, 4
  00BECF  0bc0             or ax, ax
  00BED1  7404             je 0xbed7
  00BED3  8346fe02         add word ptr [bp - 2], 2
  00BED7  6a01             push 1
  00BED9  ff76fc           push word ptr [bp - 4]
  00BEDC  e86fff           call 0xbe4e
  00BEDF  83c404           add sp, 4
  00BEE2  0bc0             or ax, ax
  00BEE4  7403             je 0xbee9
  00BEE6  ff46fe           inc word ptr [bp - 2]
  00BEE9  8b46fe           mov ax, word ptr [bp - 2]
  00BEEC  c9               leave
  00BEED  c3               ret
  00BEEE  c8020000         enter 2, 0
  00BEF2  50               push ax
  00BEF3  56               push si
  00BEF4  c746fe0000       mov word ptr [bp - 2], 0
  00BEF9  3916d004         cmp word ptr [0x4d0], dx
  00BEFD  7f49             jg 0xbf48
  00BEFF  c41e7e4a         les bx, ptr [0x4a7e]
  00BF03  2b1e704e         sub bx, word ptr [0x4e70]
  00BF07  268a07           mov al, byte ptr es:[bx]
  00BF0A  2ae4             sub ah, ah
  00BF0C  8546fc           test word ptr [bp - 4], ax
  00BF0F  7404             je 0xbf15
  00BF11  8346fe08         add word ptr [bp - 2], 8
  00BF15  8b1e7e4a         mov bx, word ptr [0x4a7e]
  00BF19  8b36704e         mov si, word ptr [0x4e70]
  00BF1D  268a00           mov al, byte ptr es:[bx + si]
  00BF20  2ae4             sub ah, ah
  00BF22  8546fc           test word ptr [bp - 4], ax
  00BF25  7404             je 0xbf2b
  00BF27  8346fe04         add word ptr [bp - 2], 4
  00BF2B  268a47ff         mov al, byte ptr es:[bx - 1]
  00BF2F  2ae4             sub ah, ah
  00BF31  8546fc           test word ptr [bp - 4], ax
  00BF34  7404             je 0xbf3a
  00BF36  8346fe02         add word ptr [bp - 2], 2
  00BF3A  268a4701         mov al, byte ptr es:[bx + 1]
  00BF3E  2ae4             sub ah, ah
  00BF40  8546fc           test word ptr [bp - 4], ax
  00BF43  7403             je 0xbf48
  00BF45  ff46fe           inc word ptr [bp - 2]
  00BF48  8b46fe           mov ax, word ptr [bp - 2]
  00BF4B  5e               pop si
  00BF4C  c9               leave
  00BF4D  c3               ret
  00BF4E  c80a0000         enter 0xa, 0
  00BF52  50               push ax
  00BF53  56               push si
  00BF54  c746fc0000       mov word ptr [bp - 4], 0
  00BF59  3b16d004         cmp dx, word ptr [0x4d0]
  00BF5D  7c5d             jl 0xbfbc
  00BF5F  c746fa0100       mov word ptr [bp - 6], 1
  00BF64  c746fe0000       mov word ptr [bp - 2], 0
  00BF69  eb36             jmp 0xbfa1
  00BF6B  90               nop
  00BF6C  a1704e           mov ax, word ptr [0x4e70]
  00BF6F  f7d0             not ax
  00BF71  40               inc ax
  00BF72  eb02             jmp 0xbf76
  00BF74  2bc0             sub ax, ax
  00BF76  8946f8           mov word ptr [bp - 8], ax
  00BF79  8a87c006         mov al, byte ptr [bx + 0x6c0]
  00BF7D  98               cwde
  00BF7E  8bd8             mov bx, ax
  00BF80  031e7e4a         add bx, word ptr [0x4a7e]
  00BF84  8e06804a         mov es, word ptr [0x4a80]
  00BF88  8b76f8           mov si, word ptr [bp - 8]
  00BF8B  268a00           mov al, byte ptr es:[bx + si]
  00BF8E  2ae4             sub ah, ah
  00BF90  8546f4           test word ptr [bp - 0xc], ax
  00BF93  7406             je 0xbf9b
  00BF95  8b46fa           mov ax, word ptr [bp - 6]
  00BF98  0946fc           or word ptr [bp - 4], ax
  00BF9B  d166fa           shl word ptr [bp - 6], 1
  00BF9E  ff46fe           inc word ptr [bp - 2]
  00BFA1  837efe08         cmp word ptr [bp - 2], 8
  00BFA5  7d15             jge 0xbfbc
  00BFA7  8b5efe           mov bx, word ptr [bp - 2]
  00BFAA  8a87ca06         mov al, byte ptr [bx + 0x6ca]
  00BFAE  0ac0             or al, al
  00BFB0  74c2             je 0xbf74
  00BFB2  0ac0             or al, al
  00BFB4  7cb6             jl 0xbf6c
  00BFB6  a1704e           mov ax, word ptr [0x4e70]
  00BFB9  ebbb             jmp 0xbf76
  00BFBB  90               nop
  00BFBC  8b46fc           mov ax, word ptr [bp - 4]
  00BFBF  5e               pop si
  00BFC0  c9               leave
  00BFC1  c3               ret
  00BFC2  c8040000         enter 4, 0
  00BFC6  8b0ec004         mov cx, word ptr [0x4c0]
  00BFCA  8b16c204         mov dx, word ptr [0x4c2]
  00BFCE  894efc           mov word ptr [bp - 4], cx
  00BFD1  8956fe           mov word ptr [bp - 2], dx
  00BFD4  833ed20464       cmp word ptr [0x4d2], 0x64
  00BFD9  7c29             jl 0xc004
  00BFDB  52               push dx
  00BFDC  51               push cx
  00BFDD  8a0e1507         mov cl, byte ptr [0x715]
  00BFE1  2aed             sub ch, ch
  00BFE3  030e164b         add cx, word ptr [0x4b16]
  00BFE7  83e90f           sub cx, 0xf
  00BFEA  51               push cx
  00BFEB  8a161407         mov dl, byte ptr [0x714]
  00BFEF  2af6             sub dh, dh
  00BFF1  03160e4b         add dx, word ptr [0x4b0e]
  00BFF5  83ea08           sub dx, 8
  00BFF8  8d1efc3a         lea bx, [0x3afc]
  00BFFC  9a00008f0d       lcall 0xd8f, 0
  00C001  c9               leave
  00C002  c3               ret
  00C003  90               nop
  00C004  ff76fe           push word ptr [bp - 2]
  00C007  ff76fc           push word ptr [bp - 4]
  00C00A  ff36164b         push word ptr [0x4b16]
  00C00E  ff36d204         push word ptr [0x4d2]
  00C012  8d1efc3a         lea bx, [0x3afc]
  00C016  8b160e4b         mov dx, word ptr [0x4b0e]
  00C01A  9a0a00ae0d       lcall 0xdae, 0xa
  00C01F  c9               leave
  00C020  c3               ret
  00C021  90               nop
  00C022  c8040000         enter 4, 0
  00C026  8b0eb804         mov cx, word ptr [0x4b8]
  00C02A  8b16ba04         mov dx, word ptr [0x4ba]
  00C02E  894efc           mov word ptr [bp - 4], cx
  00C031  8956fe           mov word ptr [bp - 2], dx
  00C034  833ed00400       cmp word ptr [0x4d0], 0
  00C039  752d             jne 0xc068
  00C03B  8a1e1507         mov bl, byte ptr [0x715]
  00C03F  2aff             sub bh, bh
  00C041  031e164b         add bx, word ptr [0x4b16]
  00C045  83eb0f           sub bx, 0xf
  00C048  53               push bx
  00C049  8a1e1407         mov bl, byte ptr [0x714]
  00C04D  2aff             sub bh, bh
  00C04F  031e0e4b         add bx, word ptr [0x4b0e]
  00C053  83eb08           sub bx, 8
  00C056  53               push bx
  00C057  68fc3a           push 0x3afc
  00C05A  50               push ax
  00C05B  52               push dx
  00C05C  51               push cx
  00C05D  9a48000b03       lcall 0x30b, 0x48
  00C062  83c40c           add sp, 0xc
  00C065  c9               leave
  00C066  c3               ret
  00C067  90               nop
  00C068  ff36d004         push word ptr [0x4d0]
  00C06C  ff36164b         push word ptr [0x4b16]
  00C070  ff360e4b         push word ptr [0x4b0e]
  00C074  68fc3a           push 0x3afc
  00C077  50               push ax
  00C078  ff76fe           push word ptr [bp - 2]
  00C07B  ff76fc           push word ptr [bp - 4]
  00C07E  9a1e010b03       lcall 0x30b, 0x11e
  00C083  c9               leave
  00C084  c3               ret
  00C085  90               nop
  00C086  c8040000         enter 4, 0
  00C08A  8b0ec004         mov cx, word ptr [0x4c0]
  00C08E  8b16c204         mov dx, word ptr [0x4c2]
  00C092  894efc           mov word ptr [bp - 4], cx
  00C095  8956fe           mov word ptr [bp - 2], dx
  00C098  833ed20464       cmp word ptr [0x4d2], 0x64
  00C09D  7c29             jl 0xc0c8
  00C09F  52               push dx
  00C0A0  51               push cx
  00C0A1  8a0e1507         mov cl, byte ptr [0x715]
  00C0A5  2aed             sub ch, ch
  00C0A7  030e164b         add cx, word ptr [0x4b16]
  00C0AB  83e90f           sub cx, 0xf
  00C0AE  51               push cx
  00C0AF  8a161407         mov dl, byte ptr [0x714]
  00C0B3  2af6             sub dh, dh
  00C0B5  03160e4b         add dx, word ptr [0x4b0e]
  00C0B9  83ea08           sub dx, 8
  00C0BC  8d1efc3a         lea bx, [0x3afc]
  00C0C0  9a0c00710e       lcall 0xe71, 0xc
  00C0C5  c9               leave
  00C0C6  c3               ret
  00C0C7  90               nop
  00C0C8  ff76fe           push word ptr [bp - 2]
  00C0CB  ff76fc           push word ptr [bp - 4]
  00C0CE  ff36164b         push word ptr [0x4b16]
  00C0D2  ff36d204         push word ptr [0x4d2]
  00C0D6  8d1efc3a         lea bx, [0x3afc]
  00C0DA  8b160e4b         mov dx, word ptr [0x4b0e]
  00C0DE  9a0a00920e       lcall 0xe92, 0xa
  00C0E3  c9               leave
  00C0E4  c3               ret
  00C0E5  90               nop
  00C0E6  c8040000         enter 4, 0
  00C0EA  8b0eb804         mov cx, word ptr [0x4b8]
  00C0EE  8b16ba04         mov dx, word ptr [0x4ba]
  00C0F2  894efc           mov word ptr [bp - 4], cx
  00C0F5  8956fe           mov word ptr [bp - 2], dx
  00C0F8  833ed00400       cmp word ptr [0x4d0], 0
  00C0FD  752d             jne 0xc12c
  00C0FF  8a1e1507         mov bl, byte ptr [0x715]
  00C103  2aff             sub bh, bh
  00C105  031e164b         add bx, word ptr [0x4b16]
  00C109  83eb0f           sub bx, 0xf
  00C10C  53               push bx
  00C10D  8a1e1407         mov bl, byte ptr [0x714]
  00C111  2aff             sub bh, bh
  00C113  031e0e4b         add bx, word ptr [0x4b0e]
  00C117  83eb08           sub bx, 8
  00C11A  53               push bx
  00C11B  68fc3a           push 0x3afc
  00C11E  50               push ax
  00C11F  52               push dx
  00C120  51               push cx
  00C121  9aac000b03       lcall 0x30b, 0xac
  00C126  83c40c           add sp, 0xc
  00C129  c9               leave
  00C12A  c3               ret
  00C12B  90               nop
  00C12C  ff36d004         push word ptr [0x4d0]
  00C130  ff36164b         push word ptr [0x4b16]
  00C134  ff360e4b         push word ptr [0x4b0e]
  00C138  68fc3a           push 0x3afc
  00C13B  50               push ax
  00C13C  ff76fe           push word ptr [bp - 2]
  00C13F  ff76fc           push word ptr [bp - 4]
  00C142  9ad4010b03       lcall 0x30b, 0x1d4
  00C147  c9               leave
  00C148  c3               ret
  00C149  90               nop
  00C14A  c82c0000         enter 0x2c, 0
  00C14E  56               push si
  00C14F  a1904e           mov ax, word ptr [0x4e90]
  00C152  8946da           mov word ptr [bp - 0x26], ax
  00C155  2bc0             sub ax, ax
  00C157  a3904e           mov word ptr [0x4e90], ax
  00C15A  8946fc           mov word ptr [bp - 4], ax
  00C15D  e9c000           jmp 0xc220
  00C160  8b46ec           mov ax, word ptr [bp - 0x14]
  00C163  2b06c804         sub ax, word ptr [0x4c8]
  00C167  f7d0             not ax
  00C169  40               inc ax
  00C16A  8946dc           mov word ptr [bp - 0x24], ax
  00C16D  ff36d604         push word ptr [0x4d6]
  00C171  8b46e8           mov ax, word ptr [bp - 0x18]
  00C174  2b06ca04         sub ax, word ptr [0x4ca]
  00C178  0bc0             or ax, ax
  00C17A  7f0a             jg 0xc186
  00C17C  8b46e8           mov ax, word ptr [bp - 0x18]
  00C17F  2b06ca04         sub ax, word ptr [0x4ca]
  00C183  f7d0             not ax
  00C185  40               inc ax
  00C186  50               push ax
  00C187  ff76dc           push word ptr [bp - 0x24]
  00C18A  9a4000ab02       lcall 0x2ab, 0x40
  00C18F  83c406           add sp, 6
  00C192  3d0100           cmp ax, 1
  00C195  1bc0             sbb ax, ax
  00C197  f7d8             neg ax
  00C199  0946f8           or word ptr [bp - 8], ax
  00C19C  8b46fe           mov ax, word ptr [bp - 2]
  00C19F  8946ee           mov word ptr [bp - 0x12], ax
  00C1A2  837ef600         cmp word ptr [bp - 0xa], 0
  00C1A6  7d07             jge 0xc1af
  00C1A8  2b06704e         sub ax, word ptr [0x4e70]
  00C1AC  8946ee           mov word ptr [bp - 0x12], ax
  00C1AF  837ef600         cmp word ptr [bp - 0xa], 0
  00C1B3  7e06             jle 0xc1bb
  00C1B5  a1704e           mov ax, word ptr [0x4e70]
  00C1B8  0146ee           add word ptr [bp - 0x12], ax
  00C1BB  c41efa5a         les bx, ptr [0x5afa]
  00C1BF  8b76ee           mov si, word ptr [bp - 0x12]
  00C1C2  268a00           mov al, byte ptr es:[bx + si]
  00C1C5  241f             and al, 0x1f
  00C1C7  8846f4           mov byte ptr [bp - 0xc], al
  00C1CA  3c18             cmp al, 0x18
  00C1CC  7304             jae 0xc1d2
  00C1CE  8066f407         and byte ptr [bp - 0xc], 7
  00C1D2  8a46f4           mov al, byte ptr [bp - 0xc]
  00C1D5  2ae4             sub ah, ah
  00C1D7  50               push ax
  00C1D8  9abc05ab02       lcall 0x2ab, 0x5bc
  00C1DD  83c402           add sp, 2
  00C1E0  8846e4           mov byte ptr [bp - 0x1c], al
  00C1E3  c41e7e4a         les bx, ptr [0x4a7e]
  00C1E7  8b76ee           mov si, word ptr [bp - 0x12]
  00C1EA  c41eda52         les bx, ptr [0x52da]
  00C1EE  268a00           mov al, byte ptr es:[bx + si]
  00C1F1  803eaa5a00       cmp byte ptr [0x5aaa], 0
  00C1F6  7406             je 0xc1fe
  00C1F8  8406aa5a         test byte ptr [0x5aaa], al
  00C1FC  7406             je 0xc204
  00C1FE  837ef800         cmp word ptr [bp - 8], 0
  00C202  7408             je 0xc20c
  00C204  c746f20100       mov word ptr [bp - 0xe], 1
  00C209  eb06             jmp 0xc211
  00C20B  90               nop
  00C20C  c746f20000       mov word ptr [bp - 0xe], 0
  00C211  837e0400         cmp word ptr [bp + 4], 0
  00C215  7465             je 0xc27c
  00C217  837ef200         cmp word ptr [bp - 0xe], 0
  00C21B  745f             je 0xc27c
  00C21D  ff46fc           inc word ptr [bp - 4]
  00C220  837efc04         cmp word ptr [bp - 4], 4
  00C224  7c03             jl 0xc229
  00C226  e96f01           jmp 0xc398
  00C229  8b5efc           mov bx, word ptr [bp - 4]
  00C22C  8a87ba06         mov al, byte ptr [bx + 0x6ba]
  00C230  98               cwde
  00C231  8946f6           mov word ptr [bp - 0xa], ax
  00C234  8bc8             mov cx, ax
  00C236  8a87b406         mov al, byte ptr [bx + 0x6b4]
  00C23A  98               cwde
  00C23B  8946fe           mov word ptr [bp - 2], ax
  00C23E  0306165f         add ax, word ptr [0x5f16]
  00C242  8946ec           mov word ptr [bp - 0x14], ax
  00C245  030e4c63         add cx, word ptr [0x634c]
  00C249  894ee8           mov word ptr [bp - 0x18], cx
  00C24C  51               push cx
  00C24D  50               push ax
  00C24E  9a0e00ab02       lcall 0x2ab, 0xe
  00C253  83c404           add sp, 4
  00C256  3d0100           cmp ax, 1
  00C259  1bc0             sbb ax, ax
  00C25B  f7d8             neg ax
  00C25D  8946f8           mov word ptr [bp - 8], ax
  00C260  833ed60400       cmp word ptr [0x4d6], 0
  00C265  7503             jne 0xc26a
  00C267  e932ff           jmp 0xc19c
  00C26A  8b46ec           mov ax, word ptr [bp - 0x14]
  00C26D  2b06c804         sub ax, word ptr [0x4c8]
  00C271  0bc0             or ax, ax
  00C273  7f03             jg 0xc278
  00C275  e9e8fe           jmp 0xc160
  00C278  e9effe           jmp 0xc16a
  00C27B  90               nop
  00C27C  807ee419         cmp byte ptr [bp - 0x1c], 0x19
  00C280  7409             je 0xc28b
  00C282  807ee41a         cmp byte ptr [bp - 0x1c], 0x1a
  00C286  7403             je 0xc28b
  00C288  e9a100           jmp 0xc32c
  00C28B  837e0600         cmp word ptr [bp + 6], 0
  00C28F  7403             je 0xc294
  00C291  e99800           jmp 0xc32c
  00C294  c746f00700       mov word ptr [bp - 0x10], 7
  00C299  eb14             jmp 0xc2af
  00C29B  90               nop
  00C29C  a1124b           mov ax, word ptr [0x4b12]
  00C29F  3946ea           cmp word ptr [bp - 0x16], ax
  00C2A2  7d08             jge 0xc2ac
  00C2A4  a1144b           mov ax, word ptr [0x4b14]
  00C2A7  3946e0           cmp word ptr [bp - 0x20], ax
  00C2AA  7c40             jl 0xc2ec
  00C2AC  ff4ef0           dec word ptr [bp - 0x10]
  00C2AF  807ee419         cmp byte ptr [bp - 0x1c], 0x19
  00C2B3  7406             je 0xc2bb
  00C2B5  807ee41a         cmp byte ptr [bp - 0x1c], 0x1a
  00C2B9  755f             jne 0xc31a
  00C2BB  837ef000         cmp word ptr [bp - 0x10], 0
  00C2BF  7c59             jl 0xc31a
  00C2C1  8b5ef0           mov bx, word ptr [bp - 0x10]
  00C2C4  8a87c006         mov al, byte ptr [bx + 0x6c0]
  00C2C8  98               cwde
  00C2C9  0346ec           add ax, word ptr [bp - 0x14]
  00C2CC  8946ea           mov word ptr [bp - 0x16], ax
  00C2CF  8a87ca06         mov al, byte ptr [bx + 0x6ca]
  00C2D3  98               cwde
  00C2D4  0346e8           add ax, word ptr [bp - 0x18]
  00C2D7  8946e0           mov word ptr [bp - 0x20], ax
  00C2DA  f6c301           test bl, 1
  00C2DD  75cd             jne 0xc2ac
  00C2DF  837eea00         cmp word ptr [bp - 0x16], 0
  00C2E3  7cc7             jl 0xc2ac
  00C2E5  0bc0             or ax, ax
  00C2E7  7db3             jge 0xc29c
  00C2E9  ebc1             jmp 0xc2ac
  00C2EB  90               nop
  00C2EC  ff76e0           push word ptr [bp - 0x20]
  00C2EF  ff76ea           push word ptr [bp - 0x16]
  00C2F2  9a1201ab02       lcall 0x2ab, 0x112
  00C2F7  83c404           add sp, 4
  00C2FA  241f             and al, 0x1f
  00C2FC  2ae4             sub ah, ah
  00C2FE  8946de           mov word ptr [bp - 0x22], ax
  00C301  3d1800           cmp ax, 0x18
  00C304  7d04             jge 0xc30a
  00C306  8366de07         and word ptr [bp - 0x22], 7
  00C30A  ff76de           push word ptr [bp - 0x22]
  00C30D  9abc05ab02       lcall 0x2ab, 0x5bc
  00C312  83c402           add sp, 2
  00C315  8846e4           mov byte ptr [bp - 0x1c], al
  00C318  eb92             jmp 0xc2ac
  00C31A  807ee419         cmp byte ptr [bp - 0x1c], 0x19
  00C31E  7503             jne 0xc323
  00C320  e9fafe           jmp 0xc21d
  00C323  807ee41a         cmp byte ptr [bp - 0x1c], 0x1a
  00C327  7503             jne 0xc32c
  00C329  e9f1fe           jmp 0xc21d
  00C32C  807ee419         cmp byte ptr [bp - 0x1c], 0x19
  00C330  7406             je 0xc338
  00C332  807ee41a         cmp byte ptr [bp - 0x1c], 0x1a
  00C336  7515             jne 0xc34d
  00C338  837e0800         cmp word ptr [bp + 8], 0
  00C33C  750f             jne 0xc34d
  00C33E  837e0400         cmp word ptr [bp + 4], 0
  00C342  7509             jne 0xc34d
  00C344  837ef200         cmp word ptr [bp - 0xe], 0
  00C348  7503             jne 0xc34d
  00C34A  e9d0fe           jmp 0xc21d
  00C34D  a0cc5a           mov al, byte ptr [0x5acc]
  00C350  251f00           and ax, 0x1f
  00C353  8946e2           mov word ptr [bp - 0x1e], ax
  00C356  3d1800           cmp ax, 0x18
  00C359  7d04             jge 0xc35f
  00C35B  8366e207         and word ptr [bp - 0x1e], 7
  00C35F  ff76e2           push word ptr [bp - 0x1e]
  00C362  9abc05ab02       lcall 0x2ab, 0x5bc
  00C367  83c402           add sp, 2
  00C36A  2ae4             sub ah, ah
  00C36C  8946e2           mov word ptr [bp - 0x1e], ax
  00C36F  3a46e4           cmp al, byte ptr [bp - 0x1c]
  00C372  750f             jne 0xc383
  00C374  837e0400         cmp word ptr [bp + 4], 0
  00C378  7509             jne 0xc383
  00C37A  837ef200         cmp word ptr [bp - 0xe], 0
  00C37E  7503             jne 0xc383
  00C380  e99afe           jmp 0xc21d
  00C383  8b46fc           mov ax, word ptr [bp - 4]
  00C386  056900           add ax, 0x69
  00C389  e836fc           call 0xbfc2
  00C38C  8a46e4           mov al, byte ptr [bp - 0x1c]
  00C38F  2ae4             sub ah, ah
  00C391  e852fd           call 0xc0e6
  00C394  e986fe           jmp 0xc21d
  00C397  90               nop
  00C398  8b46da           mov ax, word ptr [bp - 0x26]
  00C39B  a3904e           mov word ptr [0x4e90], ax
  00C39E  5e               pop si
  00C39F  c9               leave
  00C3A0  c3               ret
  00C3A1  90               nop
  00C3A2  c8240000         enter 0x24, 0
  00C3A6  50               push ax
  00C3A7  56               push si
  00C3A8  c746e40000       mov word ptr [bp - 0x1c], 0
  00C3AD  c41e7e4a         les bx, ptr [0x4a7e]
  00C3B1  268a07           mov al, byte ptr es:[bx]
  00C3B4  a26a4c           mov byte ptr [0x4c6a], al
  00C3B7  c41efa5a         les bx, ptr [0x5afa]
  00C3BB  268a07           mov al, byte ptr es:[bx]
  00C3BE  a2844e           mov byte ptr [0x4e84], al
  00C3C1  c41eda52         les bx, ptr [0x52da]
  00C3C5  268a0f           mov cl, byte ptr es:[bx]
  00C3C8  880e8869         mov byte ptr [0x6988], cl
  00C3CC  2ae4             sub ah, ah
  00C3CE  50               push ax
  00C3CF  9abc05ab02       lcall 0x2ab, 0x5bc
  00C3D4  83c402           add sp, 2
  00C3D7  a2cc5a           mov byte ptr [0x5acc], al
  00C3DA  803eaa5a00       cmp byte ptr [0x5aaa], 0
  00C3DF  7409             je 0xc3ea
  00C3E1  a0aa5a           mov al, byte ptr [0x5aaa]
  00C3E4  84068869         test byte ptr [0x6988], al
  00C3E8  7406             je 0xc3f0
  00C3EA  837eda00         cmp word ptr [bp - 0x26], 0
  00C3EE  7408             je 0xc3f8
  00C3F0  c746f80100       mov word ptr [bp - 8], 1
  00C3F5  eb06             jmp 0xc3fd
  00C3F7  90               nop
  00C3F8  c746f80000       mov word ptr [bp - 8], 0
  00C3FD  a0844e           mov al, byte ptr [0x4e84]
  00C400  25c000           and ax, 0xc0
  00C403  8946ee           mov word ptr [bp - 0x12], ax
  00C406  837ef800         cmp word ptr [bp - 8], 0
  00C40A  743c             je 0xc448
  00C40C  b89500           mov ax, 0x95
  00C40F  e8b0fb           call 0xbfc2
  00C412  833ed00400       cmp word ptr [0x4d0], 0
  00C417  7403             je 0xc41c
  00C419  e9b703           jmp 0xc7d3
  00C41C  803ecc5a19       cmp byte ptr [0x5acc], 0x19
  00C421  7407             je 0xc42a
  00C423  803ecc5a1a       cmp byte ptr [0x5acc], 0x1a
  00C428  7508             jne 0xc432
  00C42A  c746de0100       mov word ptr [bp - 0x22], 1
  00C42F  eb06             jmp 0xc437
  00C431  90               nop
  00C432  c746de0000       mov word ptr [bp - 0x22], 0
  00C437  6a00             push 0
  00C439  ff76de           push word ptr [bp - 0x22]
  00C43C  6a01             push 1
  00C43E  e809fd           call 0xc14a
  00C441  83c406           add sp, 6
  00C444  5e               pop si
  00C445  c9               leave
  00C446  c3               ret
  00C447  90               nop
  00C448  c646fc00         mov byte ptr [bp - 4], 0
  00C44C  c646fe19         mov byte ptr [bp - 2], 0x19
  00C450  803ecc5a19       cmp byte ptr [0x5acc], 0x19
  00C455  7407             je 0xc45e
  00C457  803ecc5a1a       cmp byte ptr [0x5acc], 0x1a
  00C45C  7510             jne 0xc46e
  00C45E  a0cc5a           mov al, byte ptr [0x5acc]
  00C461  8846fe           mov byte ptr [bp - 2], al
  00C464  e8b7f7           call 0xbc1e
  00C467  8946e4           mov word ptr [bp - 0x1c], ax
  00C46A  c646fc01         mov byte ptr [bp - 4], 1
  00C46E  807efc00         cmp byte ptr [bp - 4], 0
  00C472  7446             je 0xc4ba
  00C474  837ee400         cmp word ptr [bp - 0x1c], 0
  00C478  7540             jne 0xc4ba
  00C47A  8a46fe           mov al, byte ptr [bp - 2]
  00C47D  2ae4             sub ah, ah
  00C47F  e8a0fb           call 0xc022
  00C482  833ed00400       cmp word ptr [0x4d0], 0
  00C487  7403             je 0xc48c
  00C489  e94703           jmp 0xc7d3
  00C48C  ff364c63         push word ptr [0x634c]
  00C490  ff36165f         push word ptr [0x5f16]
  00C494  9a5804ab02       lcall 0x2ab, 0x458
  00C499  83c404           add sp, 4
  00C49C  8946e2           mov word ptr [bp - 0x1e], ax
  00C49F  40               inc ax
  00C4A0  7410             je 0xc4b2
  00C4A2  833ed60400       cmp word ptr [0x4d6], 0
  00C4A7  7509             jne 0xc4b2
  00C4A9  8b46e2           mov ax, word ptr [bp - 0x1e]
  00C4AC  055a00           add ax, 0x5a
  00C4AF  e810fb           call 0xbfc2
  00C4B2  6a01             push 1
  00C4B4  6a01             push 1
  00C4B6  6a00             push 0
  00C4B8  eb84             jmp 0xc43e
  00C4BA  803ecc5a18       cmp byte ptr [0x5acc], 0x18
  00C4BF  7309             jae 0xc4ca
  00C4C1  a0cc5a           mov al, byte ptr [0x5acc]
  00C4C4  250700           and ax, 7
  00C4C7  eb06             jmp 0xc4cf
  00C4C9  90               nop
  00C4CA  a0cc5a           mov al, byte ptr [0x5acc]
  00C4CD  2ae4             sub ah, ah
  00C4CF  8946e0           mov word ptr [bp - 0x20], ax
  00C4D2  3d0100           cmp ax, 1
  00C4D5  751c             jne 0xc4f3
  00C4D7  803ecc5a08       cmp byte ptr [0x5acc], 8
  00C4DC  7207             jb 0xc4e5
  00C4DE  803ecc5a10       cmp byte ptr [0x5acc], 0x10
  00C4E3  7213             jb 0xc4f8
  00C4E5  803ecc5a10       cmp byte ptr [0x5acc], 0x10
  00C4EA  7207             jb 0xc4f3
  00C4EC  803ecc5a18       cmp byte ptr [0x5acc], 0x18
  00C4F1  7205             jb 0xc4f8
  00C4F3  8b46e0           mov ax, word ptr [bp - 0x20]
  00C4F6  eb03             jmp 0xc4fb
  00C4F8  b81100           mov ax, 0x11
  00C4FB  e824fb           call 0xc022
  00C4FE  833ed00400       cmp word ptr [0x4d0], 0
  00C503  7510             jne 0xc515
  00C505  6a00             push 0
  00C507  8a46fc           mov al, byte ptr [bp - 4]
  00C50A  2ae4             sub ah, ah
  00C50C  50               push ax
  00C50D  6a00             push 0
  00C50F  e838fc           call 0xc14a
  00C512  83c406           add sp, 6
  00C515  837ee001         cmp word ptr [bp - 0x20], 1
  00C519  742e             je 0xc549
  00C51B  803ecc5a08       cmp byte ptr [0x5acc], 8
  00C520  7207             jb 0xc529
  00C522  803ecc5a10       cmp byte ptr [0x5acc], 0x10
  00C527  720e             jb 0xc537
  00C529  803ecc5a10       cmp byte ptr [0x5acc], 0x10
  00C52E  7219             jb 0xc549
  00C530  803ecc5a18       cmp byte ptr [0x5acc], 0x18
  00C535  7312             jae 0xc549
  00C537  8b46e0           mov ax, word ptr [bp - 0x20]
  00C53A  ba0300           mov dx, 3
  00C53D  e848f9           call 0xbe88
  00C540  8946ec           mov word ptr [bp - 0x14], ax
  00C543  054100           add ax, 0x41
  00C546  e879fa           call 0xbfc2
  00C549  f6066a4c40       test byte ptr [0x4c6a], 0x40
  00C54E  7406             je 0xc556
  00C550  b89600           mov ax, 0x96
  00C553  e86cfa           call 0xbfc2
  00C556  f606844e20       test byte ptr [0x4e84], 0x20
  00C55B  7427             je 0xc584
  00C55D  807efc00         cmp byte ptr [bp - 4], 0
  00C561  7521             jne 0xc584
  00C563  a0844e           mov al, byte ptr [0x4e84]
  00C566  25a000           and ax, 0xa0
  00C569  ba0200           mov dx, 2
  00C56C  e86ff8           call 0xbdde
  00C56F  8946ec           mov word ptr [bp - 0x14], ax
  00C572  f606844e80       test byte ptr [0x4e84], 0x80
  00C577  7405             je 0xc57e
  00C579  052100           add ax, 0x21
  00C57C  eb03             jmp 0xc581
  00C57E  053100           add ax, 0x31
  00C581  e83efa           call 0xbfc2
  00C584  f606844e40       test byte ptr [0x4e84], 0x40
  00C589  7438             je 0xc5c3
  00C58B  807efc00         cmp byte ptr [bp - 4], 0
  00C58F  7532             jne 0xc5c3
  00C591  f606844e80       test byte ptr [0x4e84], 0x80
  00C596  7408             je 0xc5a0
  00C598  c746e80100       mov word ptr [bp - 0x18], 1
  00C59D  eb06             jmp 0xc5a5
  00C59F  90               nop
  00C5A0  c746e81100       mov word ptr [bp - 0x18], 0x11
  00C5A5  b84000           mov ax, 0x40
  00C5A8  ba0300           mov dx, 3
  00C5AB  e8d0f7           call 0xbd7e
  00C5AE  8946ec           mov word ptr [bp - 0x14], ax
  00C5B1  0bc0             or ax, ax
  00C5B3  7505             jne 0xc5ba
  00C5B5  c746ec0f00       mov word ptr [bp - 0x14], 0xf
  00C5BA  8b46e8           mov ax, word ptr [bp - 0x18]
  00C5BD  0346ec           add ax, word ptr [bp - 0x14]
  00C5C0  e8fff9           call 0xbfc2
  00C5C3  833ed00400       cmp word ptr [0x4d0], 0
  00C5C8  7547             jne 0xc611
  00C5CA  833eda0400       cmp word ptr [0x4da], 0
  00C5CF  7540             jne 0xc611
  00C5D1  ff364c63         push word ptr [0x634c]
  00C5D5  ff36165f         push word ptr [0x5f16]
  00C5D9  9a5804ab02       lcall 0x2ab, 0x458
  00C5DE  83c404           add sp, 4
  00C5E1  8946e2           mov word ptr [bp - 0x1e], ax
  00C5E4  40               inc ax
  00C5E5  7410             je 0xc5f7
  00C5E7  833ed60400       cmp word ptr [0x4d6], 0
  00C5EC  7509             jne 0xc5f7
  00C5EE  8b46e2           mov ax, word ptr [bp - 0x1e]
  00C5F1  055a00           add ax, 0x5a
  00C5F4  e8cbf9           call 0xbfc2
  00C5F7  ff364c63         push word ptr [0x634c]
  00C5FB  ff36165f         push word ptr [0x5f16]
  00C5FF  9a4005ab02       lcall 0x2ab, 0x540
  00C604  83c404           add sp, 4
  00C607  0bc0             or ax, ax
  00C609  7406             je 0xc611
  00C60B  b86800           mov ax, 0x68
  00C60E  e8b1f9           call 0xbfc2
  00C611  f6066a4c0a       test byte ptr [0x4c6a], 0xa
  00C616  744d             je 0xc665
  00C618  807efc00         cmp byte ptr [bp - 4], 0
  00C61C  7547             jne 0xc665
  00C61E  833eda0400       cmp word ptr [0x4da], 0
  00C623  7540             jne 0xc665
  00C625  b80a00           mov ax, 0xa
  00C628  ba0100           mov dx, 1
  00C62B  e820f9           call 0xbf4e
  00C62E  8946ec           mov word ptr [bp - 0x14], ax
  00C631  0bc0             or ax, ax
  00C633  7509             jne 0xc63e
  00C635  b85100           mov ax, 0x51
  00C638  e887f9           call 0xbfc2
  00C63B  eb28             jmp 0xc665
  00C63D  90               nop
  00C63E  c746e60100       mov word ptr [bp - 0x1a], 1
  00C643  c746ea0000       mov word ptr [bp - 0x16], 0
  00C648  8b46ec           mov ax, word ptr [bp - 0x14]
  00C64B  8546e6           test word ptr [bp - 0x1a], ax
  00C64E  7409             je 0xc659
  00C650  8b46ea           mov ax, word ptr [bp - 0x16]
  00C653  055200           add ax, 0x52
  00C656  e869f9           call 0xbfc2
  00C659  d166e6           shl word ptr [bp - 0x1a], 1
  00C65C  ff46ea           inc word ptr [bp - 0x16]
  00C65F  837eea08         cmp word ptr [bp - 0x16], 8
  00C663  7ce3             jl 0xc648
  00C665  807efc00         cmp byte ptr [bp - 4], 0
  00C669  7503             jne 0xc66e
  00C66B  e96501           jmp 0xc7d3
  00C66E  c746faffff       mov word ptr [bp - 6], 0xffff
  00C673  a0d35a           mov al, byte ptr [0x5ad3]
  00C676  24dd             and al, 0xdd
  00C678  3cc1             cmp al, 0xc1
  00C67A  7505             jne 0xc681
  00C67C  c746fa0000       mov word ptr [bp - 6], 0
  00C681  a0d35a           mov al, byte ptr [0x5ad3]
  00C684  2477             and al, 0x77
  00C686  3c07             cmp al, 7
  00C688  7505             jne 0xc68f
  00C68A  c746fa0100       mov word ptr [bp - 6], 1
  00C68F  a0d35a           mov al, byte ptr [0x5ad3]
  00C692  2477             and al, 0x77
  00C694  3c70             cmp al, 0x70
  00C696  7505             jne 0xc69d
  00C698  c746fa0200       mov word ptr [bp - 6], 2
  00C69D  a0d35a           mov al, byte ptr [0x5ad3]
  00C6A0  24dd             and al, 0xdd
  00C6A2  3c1c             cmp al, 0x1c
  00C6A4  7505             jne 0xc6ab
  00C6A6  c746fa0300       mov word ptr [bp - 6], 3
  00C6AB  837efa00         cmp word ptr [bp - 6], 0
  00C6AF  7d4b             jge 0xc6fc
  00C6B1  c746f40000       mov word ptr [bp - 0xc], 0
  00C6B6  8a46f4           mov al, byte ptr [bp - 0xc]
  00C6B9  fec0             inc al
  00C6BB  250300           and ax, 3
  00C6BE  8946f0           mov word ptr [bp - 0x10], ax
  00C6C1  243e             and al, 0x3e
  00C6C3  c0e002           shl al, 2
  00C6C6  a21407           mov byte ptr [0x714], al
  00C6C9  8a46f4           mov al, byte ptr [bp - 0xc]
  00C6CC  24fe             and al, 0xfe
  00C6CE  c0e002           shl al, 2
  00C6D1  a21507           mov byte ptr [0x715], al
  00C6D4  8b5ef4           mov bx, word ptr [bp - 0xc]
  00C6D7  8a879a49         mov al, byte ptr [bx + 0x499a]
  00C6DB  2ae4             sub ah, ah
  00C6DD  c1e002           shl ax, 2
  00C6E0  03c3             add ax, bx
  00C6E2  056d00           add ax, 0x6d
  00C6E5  e8daf8           call 0xbfc2
  00C6E8  ff46f4           inc word ptr [bp - 0xc]
  00C6EB  837ef404         cmp word ptr [bp - 0xc], 4
  00C6EF  7cc5             jl 0xc6b6
  00C6F1  2ac0             sub al, al
  00C6F3  a21507           mov byte ptr [0x715], al
  00C6F6  a21407           mov byte ptr [0x714], al
  00C6F9  eb12             jmp 0xc70d
  00C6FB  90               nop
  00C6FC  2ac0             sub al, al
  00C6FE  a21507           mov byte ptr [0x715], al
  00C701  a21407           mov byte ptr [0x714], al
  00C704  8b46fa           mov ax, word ptr [bp - 6]
  00C707  059700           add ax, 0x97
  00C70A  e8b5f8           call 0xbfc2
  00C70D  8a46fe           mov al, byte ptr [bp - 2]
  00C710  2ae4             sub ah, ah
  00C712  e8d1f9           call 0xc0e6
  00C715  837eee00         cmp word ptr [bp - 0x12], 0
  00C719  7503             jne 0xc71e
  00C71B  e98800           jmp 0xc7a6
  00C71E  8a46ee           mov al, byte ptr [bp - 0x12]
  00C721  258000           and ax, 0x80
  00C724  3d0100           cmp ax, 1
  00C727  1bc0             sbb ax, ax
  00C729  250400           and ax, 4
  00C72C  058d00           add ax, 0x8d
  00C72F  8946f0           mov word ptr [bp - 0x10], ax
  00C732  c746f40000       mov word ptr [bp - 0xc], 0
  00C737  eb59             jmp 0xc792
  00C739  90               nop
  00C73A  a1704e           mov ax, word ptr [0x4e70]
  00C73D  f7d8             neg ax
  00C73F  8946de           mov word ptr [bp - 0x22], ax
  00C742  80bfba0600       cmp byte ptr [bx + 0x6ba], 0
  00C747  7e05             jle 0xc74e
  00C749  a1704e           mov ax, word ptr [0x4e70]
  00C74C  eb02             jmp 0xc750
  00C74E  2bc0             sub ax, ax
  00C750  8946dc           mov word ptr [bp - 0x24], ax
  00C753  8a87b406         mov al, byte ptr [bx + 0x6b4]
  00C757  98               cwde
  00C758  8bd8             mov bx, ax
  00C75A  031efa5a         add bx, word ptr [0x5afa]
  00C75E  8e06fc5a         mov es, word ptr [0x5afc]
  00C762  035ede           add bx, word ptr [bp - 0x22]
  00C765  8b76dc           mov si, word ptr [bp - 0x24]
  00C768  268a00           mov al, byte ptr es:[bx + si]
  00C76B  2ae4             sub ah, ah
  00C76D  a840             test al, 0x40
  00C76F  741e             je 0xc78f
  00C771  50               push ax
  00C772  9abc05ab02       lcall 0x2ab, 0x5bc
  00C777  83c402           add sp, 2
  00C77A  2ae4             sub ah, ah
  00C77C  3d1900           cmp ax, 0x19
  00C77F  740e             je 0xc78f
  00C781  3d1a00           cmp ax, 0x1a
  00C784  7409             je 0xc78f
  00C786  8b46f0           mov ax, word ptr [bp - 0x10]
  00C789  0346f4           add ax, word ptr [bp - 0xc]
  00C78C  e833f8           call 0xbfc2
  00C78F  ff46f4           inc word ptr [bp - 0xc]
  00C792  837ef404         cmp word ptr [bp - 0xc], 4
  00C796  7d0e             jge 0xc7a6
  00C798  8b5ef4           mov bx, word ptr [bp - 0xc]
  00C79B  80bfba0600       cmp byte ptr [bx + 0x6ba], 0
  00C7A0  7c98             jl 0xc73a
  00C7A2  2bc0             sub ax, ax
  00C7A4  eb99             jmp 0xc73f
  00C7A6  833ed00400       cmp word ptr [0x4d0], 0
  00C7AB  7526             jne 0xc7d3
  00C7AD  833ed60400       cmp word ptr [0x4d6], 0
  00C7B2  751f             jne 0xc7d3
  00C7B4  ff364c63         push word ptr [0x634c]
  00C7B8  ff36165f         push word ptr [0x5f16]
  00C7BC  9a5804ab02       lcall 0x2ab, 0x458
  00C7C1  83c404           add sp, 4
  00C7C4  8946e2           mov word ptr [bp - 0x1e], ax
  00C7C7  40               inc ax
  00C7C8  7409             je 0xc7d3
  00C7CA  8b46e2           mov ax, word ptr [bp - 0x1e]
  00C7CD  055a00           add ax, 0x5a
  00C7D0  e8eff7           call 0xbfc2
  00C7D3  5e               pop si
  00C7D4  c9               leave
  00C7D5  c3               ret

; ---- @generate_terrain_map_region  file 0x00C7D6..0x00CA92  seg 0xA47:0xd66  (map_a.obj) ----
  00C7D6  c8280000         enter 0x28, 0
  00C7DA  53               push bx
  00C7DB  52               push dx
  00C7DC  50               push ax
  00C7DD  56               push si
  00C7DE  c746e20000       mov word ptr [bp - 0x1e], 0
  00C7E3  837e0600         cmp word ptr [bp + 6], 0
  00C7E7  7c0f             jl 0xc7f8
  00C7E9  8a4e06           mov cl, byte ptr [bp + 6]
  00C7EC  80c104           add cl, 4
  00C7EF  b001             mov al, 1
  00C7F1  d2e0             shl al, cl
  00C7F3  a2aa5a           mov byte ptr [0x5aaa], al
  00C7F6  eb05             jmp 0xc7fd
  00C7F8  c606aa5a00       mov byte ptr [0x5aaa], 0
  00C7FD  0e               push cs
  00C7FE  e875f2           call 0xba76
  00C801  8b46d2           mov ax, word ptr [bp - 0x2e]
  00C804  39062660         cmp word ptr [0x6026], ax
  00C808  7d03             jge 0xc80d
  00C80A  e97f02           jmp 0xca8c
  00C80D  8b46d4           mov ax, word ptr [bp - 0x2c]
  00C810  39063e60         cmp word ptr [0x603e], ax
  00C814  7d03             jge 0xc819
  00C816  e97302           jmp 0xca8c
  00C819  8b46d6           mov ax, word ptr [bp - 0x2a]
  00C81C  0346d2           add ax, word ptr [bp - 0x2e]
  00C81F  48               dec ax
  00C820  8946e4           mov word ptr [bp - 0x1c], ax
  00C823  8b4608           mov ax, word ptr [bp + 8]
  00C826  0346d4           add ax, word ptr [bp - 0x2c]
  00C829  48               dec ax
  00C82A  8946de           mov word ptr [bp - 0x22], ax
  00C82D  8b46e4           mov ax, word ptr [bp - 0x1c]
  00C830  3b062660         cmp ax, word ptr [0x6026]
  00C834  7e03             jle 0xc839
  00C836  a12660           mov ax, word ptr [0x6026]
  00C839  8946e4           mov word ptr [bp - 0x1c], ax
  00C83C  8b4ed2           mov cx, word ptr [bp - 0x2e]
  00C83F  3b0ef249         cmp cx, word ptr [0x49f2]
  00C843  7d04             jge 0xc849
  00C845  8b0ef249         mov cx, word ptr [0x49f2]
  00C849  894ed2           mov word ptr [bp - 0x2e], cx
  00C84C  a13e60           mov ax, word ptr [0x603e]
  00C84F  3b46de           cmp ax, word ptr [bp - 0x22]
  00C852  7e03             jle 0xc857
  00C854  8b46de           mov ax, word ptr [bp - 0x22]
  00C857  8946de           mov word ptr [bp - 0x22], ax
  00C85A  8b56d4           mov dx, word ptr [bp - 0x2c]
  00C85D  3b16f449         cmp dx, word ptr [0x49f4]
  00C861  7d04             jge 0xc867
  00C863  8b16f449         mov dx, word ptr [0x49f4]
  00C867  8956d4           mov word ptr [bp - 0x2c], dx
  00C86A  2bc2             sub ax, dx
  00C86C  40               inc ax
  00C86D  894608           mov word ptr [bp + 8], ax
  00C870  2b0ef249         sub cx, word ptr [0x49f2]
  00C874  894ee6           mov word ptr [bp - 0x1a], cx
  00C877  2b16f449         sub dx, word ptr [0x49f4]
  00C87B  8956e0           mov word ptr [bp - 0x20], dx
  00C87E  833ea60400       cmp word ptr [0x4a6], 0
  00C883  743d             je 0xc8c2
  00C885  8bc2             mov ax, dx
  00C887  40               inc ax
  00C888  f72e704e         imul word ptr [0x4e70]
  00C88C  03c8             add cx, ax
  00C88E  41               inc cx
  00C88F  8bc1             mov ax, cx
  00C891  030ea804         add cx, word ptr [0x4a8]
  00C895  8b16aa04         mov dx, word ptr [0x4aa]
  00C899  894ef4           mov word ptr [bp - 0xc], cx
  00C89C  8956f6           mov word ptr [bp - 0xa], dx
  00C89F  8bc8             mov cx, ax
  00C8A1  0306ac04         add ax, word ptr [0x4ac]
  00C8A5  8b16ae04         mov dx, word ptr [0x4ae]
  00C8A9  8946fa           mov word ptr [bp - 6], ax
  00C8AC  8956fc           mov word ptr [bp - 4], dx
  00C8AF  030eb404         add cx, word ptr [0x4b4]
  00C8B3  a1b604           mov ax, word ptr [0x4b6]
  00C8B6  894eda           mov word ptr [bp - 0x26], cx
  00C8B9  8946dc           mov word ptr [bp - 0x24], ax
  00C8BC  a1704e           mov ax, word ptr [0x4e70]
  00C8BF  eb56             jmp 0xc917
  00C8C1  90               nop
  00C8C2  8b46d4           mov ax, word ptr [bp - 0x2c]
  00C8C5  3d0100           cmp ax, 1
  00C8C8  7d03             jge 0xc8cd
  00C8CA  b80100           mov ax, 1
  00C8CD  8946ec           mov word ptr [bp - 0x14], ax
  00C8D0  50               push ax
  00C8D1  8b4ed2           mov cx, word ptr [bp - 0x2e]
  00C8D4  83f901           cmp cx, 1
  00C8D7  7d03             jge 0xc8dc
  00C8D9  b90100           mov cx, 1
  00C8DC  894eee           mov word ptr [bp - 0x12], cx
  00C8DF  51               push cx
  00C8E0  8bf0             mov si, ax
  00C8E2  9afa00ab02       lcall 0x2ab, 0xfa
  00C8E7  83c404           add sp, 4
  00C8EA  8946f4           mov word ptr [bp - 0xc], ax
  00C8ED  8956f6           mov word ptr [bp - 0xa], dx
  00C8F0  56               push si
  00C8F1  ff76ee           push word ptr [bp - 0x12]
  00C8F4  9a2e01ab02       lcall 0x2ab, 0x12e
  00C8F9  83c404           add sp, 4
  00C8FC  8946fa           mov word ptr [bp - 6], ax
  00C8FF  8956fc           mov word ptr [bp - 4], dx
  00C902  56               push si
  00C903  ff76ee           push word ptr [bp - 0x12]
  00C906  9ae402ab02       lcall 0x2ab, 0x2e4
  00C90B  83c404           add sp, 4
  00C90E  8946da           mov word ptr [bp - 0x26], ax
  00C911  8956dc           mov word ptr [bp - 0x24], dx
  00C914  a1124b           mov ax, word ptr [0x4b12]
  00C917  8946ea           mov word ptr [bp - 0x16], ax
  00C91A  a1f45a           mov ax, word ptr [0x5af4]
  00C91D  0346e0           add ax, word ptr [bp - 0x20]
  00C920  40               inc ax
  00C921  f72e8c4e         imul word ptr [0x4e8c]
  00C925  48               dec ax
  00C926  a3164b           mov word ptr [0x4b16], ax
  00C929  8b46d4           mov ax, word ptr [bp - 0x2c]
  00C92C  8946ec           mov word ptr [bp - 0x14], ax
  00C92F  e90601           jmp 0xca38
  00C932  c746f00000       mov word ptr [bp - 0x10], 0
  00C937  833ed60400       cmp word ptr [0x4d6], 0
  00C93C  7415             je 0xc953
  00C93E  2b06ca04         sub ax, word ptr [0x4ca]
  00C942  0bc0             or ax, ax
  00C944  7f0a             jg 0xc950
  00C946  8b46ec           mov ax, word ptr [bp - 0x14]
  00C949  2b06ca04         sub ax, word ptr [0x4ca]
  00C94D  f7d0             not ax
  00C94F  40               inc ax
  00C950  8946e2           mov word ptr [bp - 0x1e], ax
  00C953  c706904e0000     mov word ptr [0x4e90], 0
  00C959  a1d85a           mov ax, word ptr [0x5ad8]
  00C95C  0346e6           add ax, word ptr [bp - 0x1a]
  00C95F  f72e8a4e         imul word ptr [0x4e8a]
  00C963  8b0e8a4e         mov cx, word ptr [0x4e8a]
  00C967  d1f9             sar cx, 1
  00C969  03c8             add cx, ax
  00C96B  890e0e4b         mov word ptr [0x4b0e], cx
  00C96F  8b46d2           mov ax, word ptr [bp - 0x2e]
  00C972  8946ee           mov word ptr [bp - 0x12], ax
  00C975  eb7e             jmp 0xc9f5
  00C977  90               nop
  00C978  c746f80000       mov word ptr [bp - 8], 0
  00C97D  837ef800         cmp word ptr [bp - 8], 0
  00C981  7406             je 0xc989
  00C983  837ef000         cmp word ptr [bp - 0x10], 0
  00C987  7507             jne 0xc990
  00C989  c746f20100       mov word ptr [bp - 0xe], 1
  00C98E  eb05             jmp 0xc995
  00C990  c746f20000       mov word ptr [bp - 0xe], 0
  00C995  833ed60400       cmp word ptr [0x4d6], 0
  00C99A  742c             je 0xc9c8
  00C99C  ff36d604         push word ptr [0x4d6]
  00C9A0  ff76e2           push word ptr [bp - 0x1e]
  00C9A3  2b06c804         sub ax, word ptr [0x4c8]
  00C9A7  0bc0             or ax, ax
  00C9A9  7f0a             jg 0xc9b5
  00C9AB  8b46ee           mov ax, word ptr [bp - 0x12]
  00C9AE  2b06c804         sub ax, word ptr [0x4c8]
  00C9B2  f7d0             not ax
  00C9B4  40               inc ax
  00C9B5  50               push ax
  00C9B6  9a4000ab02       lcall 0x2ab, 0x40
  00C9BB  83c406           add sp, 6
  00C9BE  3d0100           cmp ax, 1
  00C9C1  1bc0             sbb ax, ax
  00C9C3  f7d8             neg ax
  00C9C5  0946f2           or word ptr [bp - 0xe], ax
  00C9C8  8b46f2           mov ax, word ptr [bp - 0xe]
  00C9CB  e8d4f9           call 0xc3a2
  00C9CE  a18a4e           mov ax, word ptr [0x4e8a]
  00C9D1  01060e4b         add word ptr [0x4b0e], ax
  00C9D5  837ef800         cmp word ptr [bp - 8], 0
  00C9D9  7412             je 0xc9ed
  00C9DB  837ef000         cmp word ptr [bp - 0x10], 0
  00C9DF  740c             je 0xc9ed
  00C9E1  ff06fa5a         inc word ptr [0x5afa]
  00C9E5  ff067e4a         inc word ptr [0x4a7e]
  00C9E9  ff06da52         inc word ptr [0x52da]
  00C9ED  8036904e01       xor byte ptr [0x4e90], 1
  00C9F2  ff46ee           inc word ptr [bp - 0x12]
  00C9F5  8b46ee           mov ax, word ptr [bp - 0x12]
  00C9F8  3946e4           cmp word ptr [bp - 0x1c], ax
  00C9FB  7c1f             jl 0xca1c
  00C9FD  a3165f           mov word ptr [0x5f16], ax
  00CA00  0bc0             or ax, ax
  00CA02  7f03             jg 0xca07
  00CA04  e971ff           jmp 0xc978
  00CA07  8b0e124b         mov cx, word ptr [0x4b12]
  00CA0B  49               dec cx
  00CA0C  3bc8             cmp cx, ax
  00CA0E  7f03             jg 0xca13
  00CA10  e965ff           jmp 0xc978
  00CA13  c746f80100       mov word ptr [bp - 8], 1
  00CA18  e962ff           jmp 0xc97d
  00CA1B  90               nop
  00CA1C  a18c4e           mov ax, word ptr [0x4e8c]
  00CA1F  0106164b         add word ptr [0x4b16], ax
  00CA23  837ef000         cmp word ptr [bp - 0x10], 0
  00CA27  740c             je 0xca35
  00CA29  8b46ea           mov ax, word ptr [bp - 0x16]
  00CA2C  0146f4           add word ptr [bp - 0xc], ax
  00CA2F  0146fa           add word ptr [bp - 6], ax
  00CA32  0146da           add word ptr [bp - 0x26], ax
  00CA35  ff46ec           inc word ptr [bp - 0x14]
  00CA38  8b46de           mov ax, word ptr [bp - 0x22]
  00CA3B  3946ec           cmp word ptr [bp - 0x14], ax
  00CA3E  7f4c             jg 0xca8c
  00CA40  8b46ec           mov ax, word ptr [bp - 0x14]
  00CA43  a34c63           mov word ptr [0x634c], ax
  00CA46  8b4ef4           mov cx, word ptr [bp - 0xc]
  00CA49  8b56f6           mov dx, word ptr [bp - 0xa]
  00CA4C  890efa5a         mov word ptr [0x5afa], cx
  00CA50  8916fc5a         mov word ptr [0x5afc], dx
  00CA54  8b4efa           mov cx, word ptr [bp - 6]
  00CA57  8b56fc           mov dx, word ptr [bp - 4]
  00CA5A  890e7e4a         mov word ptr [0x4a7e], cx
  00CA5E  8916804a         mov word ptr [0x4a80], dx
  00CA62  8b4eda           mov cx, word ptr [bp - 0x26]
  00CA65  8b56dc           mov dx, word ptr [bp - 0x24]
  00CA68  890eda52         mov word ptr [0x52da], cx
  00CA6C  8916dc52         mov word ptr [0x52dc], dx
  00CA70  0bc0             or ax, ax
  00CA72  7f03             jg 0xca77
  00CA74  e9bbfe           jmp 0xc932
  00CA77  8b0e144b         mov cx, word ptr [0x4b14]
  00CA7B  49               dec cx
  00CA7C  3bc8             cmp cx, ax
  00CA7E  7f03             jg 0xca83
  00CA80  e9affe           jmp 0xc932
  00CA83  c746f00100       mov word ptr [bp - 0x10], 1
  00CA88  e9acfe           jmp 0xc937
  00CA8B  90               nop
  00CA8C  5e               pop si
  00CA8D  c9               leave
  00CA8E  ca0400           retf 4
  00CA91  90               nop

; ---- @generate_terrain_map  file 0x00CA92..0x00CB18  seg 0xA47:0x1022  (map_a.obj) ----
  00CA92  55               push bp
  00CA93  8bec             mov bp, sp
  00CA95  50               push ax
  00CA96  0e               push cs
  00CA97  e8dcef           call 0xba76
  00CA9A  833ed85a00       cmp word ptr [0x5ad8], 0
  00CA9F  7507             jne 0xcaa8
  00CAA1  833ef45a00       cmp word ptr [0x5af4], 0
  00CAA6  7457             je 0xcaff
  00CAA8  833e900000       cmp word ptr [0x90], 0
  00CAAD  7439             je 0xcae8
  00CAAF  6af8             push -8
  00CAB1  6a00             push 0
  00CAB3  ff36fc3a         push word ptr [0x3afc]
  00CAB7  ff36fe3a         push word ptr [0x3afe]
  00CABB  6a00             push 0
  00CABD  6a00             push 0
  00CABF  8b1e9000         mov bx, word ptr [0x90]
  00CAC3  ff7706           push word ptr [bx + 6]
  00CAC6  ff7704           push word ptr [bx + 4]
  00CAC9  ff7702           push word ptr [bx + 2]
  00CACC  ff37             push word ptr [bx]
  00CACE  ff36023b         push word ptr [0x3b02]
  00CAD2  ff36003b         push word ptr [0x3b00]
  00CAD6  ff36fe3a         push word ptr [0x3afe]
  00CADA  ff36fc3a         push word ptr [0x3afc]
  00CADE  9a0000b90c       lcall 0xcb9, 0
  00CAE3  83c41c           add sp, 0x1c
  00CAE6  eb17             jmp 0xcaff
  00CAE8  ff36023b         push word ptr [0x3b02]
  00CAEC  ff36003b         push word ptr [0x3b00]
  00CAF0  ff36fe3a         push word ptr [0x3afe]
  00CAF4  ff36fc3a         push word ptr [0x3afc]
  00CAF8  2ac0             sub al, al
  00CAFA  9a0e00490c       lcall 0xc49, 0xe
  00CAFF  ff36d852         push word ptr [0x52d8]
  00CB03  ff76fe           push word ptr [bp - 2]
  00CB06  a1f249           mov ax, word ptr [0x49f2]
  00CB09  8b16f449         mov dx, word ptr [0x49f4]
  00CB0D  8b1ed452         mov bx, word ptr [0x52d4]
  00CB11  0e               push cs
  00CB12  e8c1fc           call 0xc7d6
  00CB15  c9               leave
  00CB16  cb               retf
  00CB17  90               nop

; ---- @generate_colony_map  file 0x00CB18..0x00CB28  seg 0xA47:0x10a8  (map_a.obj) ----
  00CB18  8916d604         mov word ptr [0x4d6], dx
  00CB1C  0e               push cs
  00CB1D  e872ff           call 0xca92
  00CB20  c706d6040000     mov word ptr [0x4d6], 0
  00CB26  cb               retf
  00CB27  90               nop

; ---- _map_init  file 0x00CB28..0x00CB64  seg 0xA47:0x10b8  (map_a.obj) ----
  00CB28  c8080000         enter 8, 0
  00CB2C  c746fc0000       mov word ptr [bp - 4], 0
  00CB31  eb20             jmp 0xcb53
  00CB33  90               nop
  00CB34  ff46fe           inc word ptr [bp - 2]
  00CB37  8b46fe           mov ax, word ptr [bp - 2]
  00CB3A  3906124b         cmp word ptr [0x4b12], ax
  00CB3E  7e10             jle 0xcb50
  00CB40  6aff             push -1
  00CB42  ff76fc           push word ptr [bp - 4]
  00CB45  50               push ax
  00CB46  9a2c02ab02       lcall 0x2ab, 0x22c
  00CB4B  83c406           add sp, 6
  00CB4E  ebe4             jmp 0xcb34
  00CB50  ff46fc           inc word ptr [bp - 4]
  00CB53  a1144b           mov ax, word ptr [0x4b14]
  00CB56  3946fc           cmp word ptr [bp - 4], ax
  00CB59  7d07             jge 0xcb62
  00CB5B  c746fe0000       mov word ptr [bp - 2], 0
  00CB60  ebd5             jmp 0xcb37
  00CB62  c9               leave
  00CB63  cb               retf
