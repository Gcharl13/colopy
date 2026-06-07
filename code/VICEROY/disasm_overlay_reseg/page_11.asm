; ============================================================
; VICEROY.EXE overlay page 0x11 (record 16) -- RE-SEGMENTED
; file_offset (disk image) = 0x05E740
; code_offset (first insn) = 0x05E9B0
; code_end (next reloc hdr)= 0x05FAD0  [resident size 274 para -> nominal_end 0x05F860; on-disk code spills past it]
; reloc_count = 145  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x05E740)
; functions in page = 1
; ============================================================

; ---- func_05E9B0  size=4371  insns=1553  prologue=ENTER 0x00CC,0  terminal=RETF ----
  05E9B0  0270: c8cc0000         enter 0xcc, 0
  05E9B4  0274: 56               push si
  05E9B5  0275: 837e1600         cmp word ptr [bp + 0x16], 0
  05E9B9  0279: 7c0b             jl 0x286
  05E9BB  027B: ff7616           push word ptr [bp + 0x16]
  05E9BE  027E: 9ae6091f18       lcall 0x181f, 0x9e6
  05E9C3  0283: 83c402           add sp, 2
  05E9C6  0286: 837e1800         cmp word ptr [bp + 0x18], 0
  05E9CA  028A: 7c0b             jl 0x297
  05E9CC  028C: ff7618           push word ptr [bp + 0x18]
  05E9CF  028F: 9a4c0a1f18       lcall 0x181f, 0xa4c
  05E9D4  0294: 83c402           add sp, 2
  05E9D7  0297: 2bc0             sub ax, ax
  05E9D9  0299: 8946fc           mov word ptr [bp - 4], ax
  05E9DC  029C: 8946fa           mov word ptr [bp - 6], ax
  05E9DF  029F: 8946ea           mov word ptr [bp - 0x16], ax
  05E9E2  02A2: 8946ec           mov word ptr [bp - 0x14], ax
  05E9E5  02A5: 8946e4           mov word ptr [bp - 0x1c], ax
  05E9E8  02A8: e99410           jmp 0x133f
  05E9EB  02AB: 90               nop 
  05E9EC  02AC: 8b46ec           mov ax, word ptr [bp - 0x14]
  05E9EF  02AF: 3b46ea           cmp ax, word ptr [bp - 0x16]
  05E9F2  02B2: 7d03             jge 0x2b7
  05E9F4  02B4: 8b46ea           mov ax, word ptr [bp - 0x16]
  05E9F7  02B7: 6bc014           imul ax, ax, 0x14
  05E9FA  02BA: 050600           add ax, 6
  05E9FD  02BD: 89468e           mov word ptr [bp - 0x72], ax
  05EA00  02C0: 8bc8             mov cx, ax
  05EA02  02C2: d1f8             sar ax, 1
  05EA04  02C4: 2d6400           sub ax, 0x64
  05EA07  02C7: f7d8             neg ax
  05EA09  02C9: 8946e6           mov word ptr [bp - 0x1a], ax
  05EA0C  02CC: 51               push cx
  05EA0D  02CD: b9d600           mov cx, 0xd6
  05EA10  02D0: 894e92           mov word ptr [bp - 0x6e], cx
  05EA13  02D3: 51               push cx
  05EA14  02D4: 50               push ax
  05EA15  02D5: b93500           mov cx, 0x35
  05EA18  02D8: 894ef0           mov word ptr [bp - 0x10], cx
  05EA1B  02DB: 51               push cx
  05EA1C  02DC: 6a00             push 0
  05EA1E  02DE: 6a00             push 0
  05EA20  02E0: 8bf0             mov si, ax
  05EA22  02E2: 9a10071f1a       lcall 0x1a1f, 0x710
  05EA27  02E7: 83c40c           add sp, 0xc
  05EA2A  02EA: 8d4403           lea ax, [si + 3]
  05EA2D  02ED: 8946fa           mov word ptr [bp - 6], ax
  05EA30  02F0: 8a0e3008         mov cl, byte ptr [0x830]
  05EA34  02F4: 2aed             sub ch, ch
  05EA36  02F6: 51               push cx
  05EA37  02F7: 8bc8             mov cx, ax
  05EA39  02F9: 050600           add ax, 6
  05EA3C  02FC: 50               push ax
  05EA3D  02FD: 68d000           push 0xd0
  05EA40  0300: b83800           mov ax, 0x38
  05EA43  0303: 8946fc           mov word ptr [bp - 4], ax
  05EA46  0306: 8946f4           mov word ptr [bp - 0xc], ax
  05EA49  0309: 50               push ax
  05EA4A  030A: ff36502e         push word ptr [0x2e50]
  05EA4E  030E: 8bf1             mov si, cx
  05EA50  0310: 9a22001f18       lcall 0x181f, 0x22
  05EA55  0315: 83c402           add sp, 2
  05EA58  0318: 52               push dx
  05EA59  0319: 50               push ax
  05EA5A  031A: 9a00011f18       lcall 0x181f, 0x100
  05EA5F  031F: 83c40c           add sp, 0xc
  05EA62  0322: 8d4414           lea ax, [si + 0x14]
  05EA65  0325: 8946f2           mov word ptr [bp - 0xe], ax
  05EA68  0328: 8b46f2           mov ax, word ptr [bp - 0xe]
  05EA6B  032B: 8946f6           mov word ptr [bp - 0xa], ax
  05EA6E  032E: c746e80000       mov word ptr [bp - 0x18], 0
  05EA73  0333: e9c50f           jmp 0x12fb
  05EA76  0336: 8b4608           mov ax, word ptr [bp + 8]
  05EA79  0339: 894688           mov word ptr [bp - 0x78], ax
  05EA7C  033C: 837ee800         cmp word ptr [bp - 0x18], 0
  05EA80  0340: 7506             jne 0x348
  05EA82  0342: 8b4612           mov ax, word ptr [bp + 0x12]
  05EA85  0345: eb04             jmp 0x34b
  05EA87  0347: 90               nop 
  05EA88  0348: 8b4614           mov ax, word ptr [bp + 0x14]
  05EA8B  034B: 898636ff         mov word ptr [bp - 0xca], ax
  05EA8F  034F: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EA92  0352: 89468c           mov word ptr [bp - 0x74], ax
  05EA95  0355: 837ee400         cmp word ptr [bp - 0x1c], 0
  05EA99  0359: 7413             je 0x36e
  05EA9B  035B: ff76f2           push word ptr [bp - 0xe]
  05EA9E  035E: 6a00             push 0
  05EAA0  0360: 6a64             push 0x64
  05EAA2  0362: 8bd8             mov bx, ax
  05EAA4  0364: 8b4688           mov ax, word ptr [bp - 0x78]
  05EAA7  0367: 2bd2             sub dx, dx
  05EAA9  0369: 9abc021f18       lcall 0x181f, 0x2bc
  05EAAE  036E: 83468c11         add word ptr [bp - 0x74], 0x11
  05EAB2  0372: f6468b02         test byte ptr [bp - 0x75], 2
  05EAB6  0376: 742a             je 0x3a2
  05EAB8  0378: c6469400         mov byte ptr [bp - 0x6c], 0
  05EABC  037C: 6b5e881c         imul bx, word ptr [bp - 0x78], 0x1c
  05EAC0  0380: 8a875b31         mov al, byte ptr [bx + 0x315b]
  05EAC4  0384: 98               cwde 
  05EAC5  0385: 50               push ax
  05EAC6  0386: 9a180c1f18       lcall 0x181f, 0xc18
  05EACB  038B: 83c402           add sp, 2
  05EACE  038E: 50               push ax
  05EACF  038F: 8d4694           lea ax, [bp - 0x6c]
  05EAD2  0392: 50               push ax
  05EAD3  0393: 9a6e011f18       lcall 0x181f, 0x16e
  05EAD8  0398: 83c404           add sp, 4
  05EADB  039B: c746fe0100       mov word ptr [bp - 2], 1
  05EAE0  03A0: eb36             jmp 0x3d8
  05EAE2  03A2: c6469400         mov byte ptr [bp - 0x6c], 0
  05EAE6  03A6: 6b5e881c         imul bx, word ptr [bp - 0x78], 0x1c
  05EAEA  03AA: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05EAEE  03AE: 2aff             sub bh, bh
  05EAF0  03B0: 8bc3             mov ax, bx
  05EAF2  03B2: d1e3             shl bx, 1
  05EAF4  03B4: 03d8             add bx, ax
  05EAF6  03B6: d1e3             shl bx, 1
  05EAF8  03B8: 03d8             add bx, ax
  05EAFA  03BA: d1e3             shl bx, 1
  05EAFC  03BC: ffb73052         push word ptr [bx + 0x5230]
  05EB00  03C0: 8d4694           lea ax, [bp - 0x6c]
  05EB03  03C3: 50               push ax
  05EB04  03C4: 9a6e011f18       lcall 0x181f, 0x16e
  05EB09  03C9: 83c404           add sp, 4
  05EB0C  03CC: 8b5ee8           mov bx, word ptr [bp - 0x18]
  05EB0F  03CF: d1e3             shl bx, 1
  05EB11  03D1: 8b87068d         mov ax, word ptr [bx - 0x72fa]
  05EB15  03D5: 8946fe           mov word ptr [bp - 2], ax
  05EB18  03D8: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05EB1D  03DD: ff76fe           push word ptr [bp - 2]
  05EB20  03E0: 8d8638ff         lea ax, [bp - 0xc8]
  05EB24  03E4: 16               push ss
  05EB25  03E5: 50               push ax
  05EB26  03E6: 9a82011f18       lcall 0x181f, 0x182
  05EB2B  03EB: 83c406           add sp, 6
  05EB2E  03EE: 837ee400         cmp word ptr [bp - 0x1c], 0
  05EB32  03F2: 7448             je 0x43c
  05EB34  03F4: a03008           mov al, byte ptr [0x830]
  05EB37  03F7: 2ae4             sub ah, ah
  05EB39  03F9: 50               push ax
  05EB3A  03FA: 8b46f2           mov ax, word ptr [bp - 0xe]
  05EB3D  03FD: 050600           add ax, 6
  05EB40  0400: 50               push ax
  05EB41  0401: ff768c           push word ptr [bp - 0x74]
  05EB44  0404: 8d4e94           lea cx, [bp - 0x6c]
  05EB47  0407: 16               push ss
  05EB48  0408: 51               push cx
  05EB49  0409: 8bf0             mov si, ax
  05EB4B  040B: 9a3c011f18       lcall 0x181f, 0x13c
  05EB50  0410: 83c40a           add sp, 0xa
  05EB53  0413: a03108           mov al, byte ptr [0x831]
  05EB56  0416: 2ae4             sub ah, ah
  05EB58  0418: 50               push ax
  05EB59  0419: 56               push si
  05EB5A  041A: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EB5D  041D: 055000           add ax, 0x50
  05EB60  0420: 50               push ax
  05EB61  0421: 8d8638ff         lea ax, [bp - 0xc8]
  05EB65  0425: 16               push ss
  05EB66  0426: 50               push ax
  05EB67  0427: 9a50011f18       lcall 0x181f, 0x150
  05EB6C  042C: 83c40a           add sp, 0xa
  05EB6F  042F: 8346f214         add word ptr [bp - 0xe], 0x14
  05EB73  0433: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EB76  0436: 89468c           mov word ptr [bp - 0x74], ax
  05EB79  0439: eb09             jmp 0x444
  05EB7B  043B: 90               nop 
  05EB7C  043C: 8b76e8           mov si, word ptr [bp - 0x18]
  05EB7F  043F: d1e6             shl si, 1
  05EB81  0441: ff42ea           inc word ptr [bp + si - 0x16]
  05EB84  0444: f6468b04         test byte ptr [bp - 0x75], 4
  05EB88  0448: 7503             jne 0x44d
  05EB8A  044A: e9b300           jmp 0x500
  05EB8D  044D: 837ee400         cmp word ptr [bp - 0x1c], 0
  05EB91  0451: 741d             je 0x470
  05EB93  0453: ff364008         push word ptr [0x840]
  05EB97  0457: ff363e08         push word ptr [0x83e]
  05EB9B  045B: 8b46f2           mov ax, word ptr [bp - 0xe]
  05EB9E  045E: 40               inc ax
  05EB9F  045F: 40               inc ax
  05EBA0  0460: 50               push ax
  05EBA1  0461: b82600           mov ax, 0x26
  05EBA4  0464: 8d1ea82d         lea bx, [0x2da8]
  05EBA8  0468: 8b568c           mov dx, word ptr [bp - 0x74]
  05EBAB  046B: 9a54021f18       lcall 0x181f, 0x254
  05EBB0  0470: 83468c08         add word ptr [bp - 0x74], 8
  05EBB4  0474: c6469400         mov byte ptr [bp - 0x6c], 0
  05EBB8  0478: ff36de97         push word ptr [0x97de]
  05EBBC  047C: 8d4694           lea ax, [bp - 0x6c]
  05EBBF  047F: 50               push ax
  05EBC0  0480: 9a6e011f18       lcall 0x181f, 0x16e
  05EBC5  0485: 83c404           add sp, 4
  05EBC8  0488: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05EBCD  048D: 8d8638ff         lea ax, [bp - 0xc8]
  05EBD1  0491: 50               push ax
  05EBD2  0492: 9a46011f18       lcall 0x181f, 0x146
  05EBD7  0497: 83c402           add sp, 2
  05EBDA  049A: 6a01             push 1
  05EBDC  049C: 8d8638ff         lea ax, [bp - 0xc8]
  05EBE0  04A0: 16               push ss
  05EBE1  04A1: 50               push ax
  05EBE2  04A2: 9a82011f18       lcall 0x181f, 0x182
  05EBE7  04A7: 83c406           add sp, 6
  05EBEA  04AA: 837ee400         cmp word ptr [bp - 0x1c], 0
  05EBEE  04AE: 7448             je 0x4f8
  05EBF0  04B0: a03008           mov al, byte ptr [0x830]
  05EBF3  04B3: 2ae4             sub ah, ah
  05EBF5  04B5: 50               push ax
  05EBF6  04B6: 8b46f2           mov ax, word ptr [bp - 0xe]
  05EBF9  04B9: 050600           add ax, 6
  05EBFC  04BC: 50               push ax
  05EBFD  04BD: ff768c           push word ptr [bp - 0x74]
  05EC00  04C0: 8d4e94           lea cx, [bp - 0x6c]
  05EC03  04C3: 16               push ss
  05EC04  04C4: 51               push cx
  05EC05  04C5: 8bf0             mov si, ax
  05EC07  04C7: 9a3c011f18       lcall 0x181f, 0x13c
  05EC0C  04CC: 83c40a           add sp, 0xa
  05EC0F  04CF: a03108           mov al, byte ptr [0x831]
  05EC12  04D2: 2ae4             sub ah, ah
  05EC14  04D4: 50               push ax
  05EC15  04D5: 56               push si
  05EC16  04D6: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EC19  04D9: 055000           add ax, 0x50
  05EC1C  04DC: 50               push ax
  05EC1D  04DD: 8d8638ff         lea ax, [bp - 0xc8]
  05EC21  04E1: 16               push ss
  05EC22  04E2: 50               push ax
  05EC23  04E3: 9a50011f18       lcall 0x181f, 0x150
  05EC28  04E8: 83c40a           add sp, 0xa
  05EC2B  04EB: 8346f214         add word ptr [bp - 0xe], 0x14
  05EC2F  04EF: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EC32  04F2: 89468c           mov word ptr [bp - 0x74], ax
  05EC35  04F5: eb09             jmp 0x500
  05EC37  04F7: 90               nop 
  05EC38  04F8: 8b76e8           mov si, word ptr [bp - 0x18]
  05EC3B  04FB: d1e6             shl si, 1
  05EC3D  04FD: ff42ea           inc word ptr [bp + si - 0x16]
  05EC40  0500: f6468a02         test byte ptr [bp - 0x76], 2
  05EC44  0504: 7503             jne 0x509
  05EC46  0506: e9bb00           jmp 0x5c4
  05EC49  0509: 6b5e881c         imul bx, word ptr [bp - 0x78], 0x1c
  05EC4D  050D: 80bf463101       cmp byte ptr [bx + 0x3146], 1
  05EC52  0512: 740a             je 0x51e
  05EC54  0514: 80bf463104       cmp byte ptr [bx + 0x3146], 4
  05EC59  0519: 7403             je 0x51e
  05EC5B  051B: e9a600           jmp 0x5c4
  05EC5E  051E: 6b5e881c         imul bx, word ptr [bp - 0x78], 0x1c
  05EC62  0522: 80bf5b3115       cmp byte ptr [bx + 0x315b], 0x15
  05EC67  0527: 7403             je 0x52c
  05EC69  0529: e99800           jmp 0x5c4
  05EC6C  052C: c6469400         mov byte ptr [bp - 0x6c], 0
  05EC70  0530: ff363c2e         push word ptr [0x2e3c]
  05EC74  0534: 8d4694           lea ax, [bp - 0x6c]
  05EC77  0537: 50               push ax
  05EC78  0538: 9a6e011f18       lcall 0x181f, 0x16e
  05EC7D  053D: 83c404           add sp, 4
  05EC80  0540: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05EC85  0545: 8d8638ff         lea ax, [bp - 0xc8]
  05EC89  0549: 50               push ax
  05EC8A  054A: 9a46011f18       lcall 0x181f, 0x146
  05EC8F  054F: 83c402           add sp, 2
  05EC92  0552: 6a32             push 0x32
  05EC94  0554: 8d8638ff         lea ax, [bp - 0xc8]
  05EC98  0558: 16               push ss
  05EC99  0559: 50               push ax
  05EC9A  055A: 9a82011f18       lcall 0x181f, 0x182
  05EC9F  055F: 83c406           add sp, 6
  05ECA2  0562: 8d8638ff         lea ax, [bp - 0xc8]
  05ECA6  0566: 50               push ax
  05ECA7  0567: 9a0a011f18       lcall 0x181f, 0x10a
  05ECAC  056C: 83c402           add sp, 2
  05ECAF  056F: 837ee400         cmp word ptr [bp - 0x1c], 0
  05ECB3  0573: 7447             je 0x5bc
  05ECB5  0575: a03008           mov al, byte ptr [0x830]
  05ECB8  0578: 2ae4             sub ah, ah
  05ECBA  057A: 50               push ax
  05ECBB  057B: 8b46f2           mov ax, word ptr [bp - 0xe]
  05ECBE  057E: 050600           add ax, 6
  05ECC1  0581: 50               push ax
  05ECC2  0582: ff768c           push word ptr [bp - 0x74]
  05ECC5  0585: 8d4e94           lea cx, [bp - 0x6c]
  05ECC8  0588: 16               push ss
  05ECC9  0589: 51               push cx
  05ECCA  058A: 8bf0             mov si, ax
  05ECCC  058C: 9a3c011f18       lcall 0x181f, 0x13c
  05ECD1  0591: 83c40a           add sp, 0xa
  05ECD4  0594: a03108           mov al, byte ptr [0x831]
  05ECD7  0597: 2ae4             sub ah, ah
  05ECD9  0599: 50               push ax
  05ECDA  059A: 56               push si
  05ECDB  059B: 8b46f4           mov ax, word ptr [bp - 0xc]
  05ECDE  059E: 055000           add ax, 0x50
  05ECE1  05A1: 50               push ax
  05ECE2  05A2: 8d8638ff         lea ax, [bp - 0xc8]
  05ECE6  05A6: 16               push ss
  05ECE7  05A7: 50               push ax
  05ECE8  05A8: 9a50011f18       lcall 0x181f, 0x150
  05ECED  05AD: 83c40a           add sp, 0xa
  05ECF0  05B0: 8346f214         add word ptr [bp - 0xe], 0x14
  05ECF4  05B4: 8b46f4           mov ax, word ptr [bp - 0xc]
  05ECF7  05B7: 89468c           mov word ptr [bp - 0x74], ax
  05ECFA  05BA: eb08             jmp 0x5c4
  05ECFC  05BC: 8b76e8           mov si, word ptr [bp - 0x18]
  05ECFF  05BF: d1e6             shl si, 1
  05ED01  05C1: ff42ea           inc word ptr [bp + si - 0x16]
  05ED04  05C4: f6468a04         test byte ptr [bp - 0x76], 4
  05ED08  05C8: 7503             jne 0x5cd
  05ED0A  05CA: e9d300           jmp 0x6a0
  05ED0D  05CD: c6469400         mov byte ptr [bp - 0x6c], 0
  05ED11  05D1: ff36362e         push word ptr [0x2e36]
  05ED15  05D5: 8d4694           lea ax, [bp - 0x6c]
  05ED18  05D8: 50               push ax
  05ED19  05D9: 9a6e011f18       lcall 0x181f, 0x16e
  05ED1E  05DE: 83c404           add sp, 4
  05ED21  05E1: 8d4694           lea ax, [bp - 0x6c]
  05ED24  05E4: 50               push ax
  05ED25  05E5: 9abe011f18       lcall 0x181f, 0x1be
  05ED2A  05EA: 83c402           add sp, 2
  05ED2D  05ED: 8d4694           lea ax, [bp - 0x6c]
  05ED30  05F0: 50               push ax
  05ED31  05F1: 9a78011f18       lcall 0x181f, 0x178
  05ED36  05F6: 83c402           add sp, 2
  05ED39  05F9: 6b5e881c         imul bx, word ptr [bp - 0x78], 0x1c
  05ED3D  05FD: 8a875031         mov al, byte ptr [bx + 0x3150]
  05ED41  0601: 2ae4             sub ah, ah
  05ED43  0603: 50               push ax
  05ED44  0604: 8d4694           lea ax, [bp - 0x6c]
  05ED47  0607: 16               push ss
  05ED48  0608: 50               push ax
  05ED49  0609: 8bf3             mov si, bx
  05ED4B  060B: 9a82011f18       lcall 0x181f, 0x182
  05ED50  0610: 83c406           add sp, 6
  05ED53  0613: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05ED58  0618: 8d8638ff         lea ax, [bp - 0xc8]
  05ED5C  061C: 50               push ax
  05ED5D  061D: 9a5a011f18       lcall 0x181f, 0x15a
  05ED62  0622: 83c402           add sp, 2
  05ED65  0625: b064             mov al, 0x64
  05ED67  0627: f6a45031         mul byte ptr [si + 0x3150]
  05ED6B  062B: c1f803           sar ax, 3
  05ED6E  062E: 50               push ax
  05ED6F  062F: 8d8638ff         lea ax, [bp - 0xc8]
  05ED73  0633: 16               push ss
  05ED74  0634: 50               push ax
  05ED75  0635: 9a82011f18       lcall 0x181f, 0x182
  05ED7A  063A: 83c406           add sp, 6
  05ED7D  063D: 8d8638ff         lea ax, [bp - 0xc8]
  05ED81  0641: 50               push ax
  05ED82  0642: 9a0a011f18       lcall 0x181f, 0x10a
  05ED87  0647: 83c402           add sp, 2
  05ED8A  064A: 837ee400         cmp word ptr [bp - 0x1c], 0
  05ED8E  064E: 7448             je 0x698
  05ED90  0650: a03008           mov al, byte ptr [0x830]
  05ED93  0653: 2ae4             sub ah, ah
  05ED95  0655: 50               push ax
  05ED96  0656: 8b46f2           mov ax, word ptr [bp - 0xe]
  05ED99  0659: 050600           add ax, 6
  05ED9C  065C: 50               push ax
  05ED9D  065D: ff768c           push word ptr [bp - 0x74]
  05EDA0  0660: 8d4e94           lea cx, [bp - 0x6c]
  05EDA3  0663: 16               push ss
  05EDA4  0664: 51               push cx
  05EDA5  0665: 8bf0             mov si, ax
  05EDA7  0667: 9a3c011f18       lcall 0x181f, 0x13c
  05EDAC  066C: 83c40a           add sp, 0xa
  05EDAF  066F: a03108           mov al, byte ptr [0x831]
  05EDB2  0672: 2ae4             sub ah, ah
  05EDB4  0674: 50               push ax
  05EDB5  0675: 56               push si
  05EDB6  0676: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EDB9  0679: 055000           add ax, 0x50
  05EDBC  067C: 50               push ax
  05EDBD  067D: 8d8638ff         lea ax, [bp - 0xc8]
  05EDC1  0681: 16               push ss
  05EDC2  0682: 50               push ax
  05EDC3  0683: 9a50011f18       lcall 0x181f, 0x150
  05EDC8  0688: 83c40a           add sp, 0xa
  05EDCB  068B: 8346f214         add word ptr [bp - 0xe], 0x14
  05EDCF  068F: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EDD2  0692: 89468c           mov word ptr [bp - 0x74], ax
  05EDD5  0695: eb09             jmp 0x6a0
  05EDD7  0697: 90               nop 
  05EDD8  0698: 8b76e8           mov si, word ptr [bp - 0x18]
  05EDDB  069B: d1e6             shl si, 1
  05EDDD  069D: ff42ea           inc word ptr [bp + si - 0x16]
  05EDE0  06A0: f6468b01         test byte ptr [bp - 0x75], 1
  05EDE4  06A4: 7503             jne 0x6a9
  05EDE6  06A6: e99900           jmp 0x742
  05EDE9  06A9: c6469400         mov byte ptr [bp - 0x6c], 0
  05EDED  06AD: ff36522e         push word ptr [0x2e52]
  05EDF1  06B1: 8d4694           lea ax, [bp - 0x6c]
  05EDF4  06B4: 50               push ax
  05EDF5  06B5: 9a6e011f18       lcall 0x181f, 0x16e
  05EDFA  06BA: 83c404           add sp, 4
  05EDFD  06BD: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05EE02  06C2: 8d8638ff         lea ax, [bp - 0xc8]
  05EE06  06C6: 50               push ax
  05EE07  06C7: 9a5a011f18       lcall 0x181f, 0x15a
  05EE0C  06CC: 83c402           add sp, 2
  05EE0F  06CF: 6a21             push 0x21
  05EE11  06D1: 8d8638ff         lea ax, [bp - 0xc8]
  05EE15  06D5: 16               push ss
  05EE16  06D6: 50               push ax
  05EE17  06D7: 9a82011f18       lcall 0x181f, 0x182
  05EE1C  06DC: 83c406           add sp, 6
  05EE1F  06DF: 8d8638ff         lea ax, [bp - 0xc8]
  05EE23  06E3: 50               push ax
  05EE24  06E4: 9a0a011f18       lcall 0x181f, 0x10a
  05EE29  06E9: 83c402           add sp, 2
  05EE2C  06EC: 837ee400         cmp word ptr [bp - 0x1c], 0
  05EE30  06F0: 7448             je 0x73a
  05EE32  06F2: a03008           mov al, byte ptr [0x830]
  05EE35  06F5: 2ae4             sub ah, ah
  05EE37  06F7: 50               push ax
  05EE38  06F8: 8b46f2           mov ax, word ptr [bp - 0xe]
  05EE3B  06FB: 050600           add ax, 6
  05EE3E  06FE: 50               push ax
  05EE3F  06FF: ff768c           push word ptr [bp - 0x74]
  05EE42  0702: 8d4e94           lea cx, [bp - 0x6c]
  05EE45  0705: 16               push ss
  05EE46  0706: 51               push cx
  05EE47  0707: 8bf0             mov si, ax
  05EE49  0709: 9a3c011f18       lcall 0x181f, 0x13c
  05EE4E  070E: 83c40a           add sp, 0xa
  05EE51  0711: a03108           mov al, byte ptr [0x831]
  05EE54  0714: 2ae4             sub ah, ah
  05EE56  0716: 50               push ax
  05EE57  0717: 56               push si
  05EE58  0718: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EE5B  071B: 055000           add ax, 0x50
  05EE5E  071E: 50               push ax
  05EE5F  071F: 8d8638ff         lea ax, [bp - 0xc8]
  05EE63  0723: 16               push ss
  05EE64  0724: 50               push ax
  05EE65  0725: 9a50011f18       lcall 0x181f, 0x150
  05EE6A  072A: 83c40a           add sp, 0xa
  05EE6D  072D: 8346f214         add word ptr [bp - 0xe], 0x14
  05EE71  0731: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EE74  0734: 89468c           mov word ptr [bp - 0x74], ax
  05EE77  0737: eb09             jmp 0x742
  05EE79  0739: 90               nop 
  05EE7A  073A: 8b76e8           mov si, word ptr [bp - 0x18]
  05EE7D  073D: d1e6             shl si, 1
  05EE7F  073F: ff42ea           inc word ptr [bp + si - 0x16]
  05EE82  0742: f68634ff08       test byte ptr [bp - 0xcc], 8
  05EE87  0747: 7503             jne 0x74c
  05EE89  0749: e99800           jmp 0x7e4
  05EE8C  074C: c6469400         mov byte ptr [bp - 0x6c], 0
  05EE90  0750: ff36522e         push word ptr [0x2e52]
  05EE94  0754: 8d4694           lea ax, [bp - 0x6c]
  05EE97  0757: 50               push ax
  05EE98  0758: 9a6e011f18       lcall 0x181f, 0x16e
  05EE9D  075D: 83c404           add sp, 4
  05EEA0  0760: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05EEA5  0765: 8d8638ff         lea ax, [bp - 0xc8]
  05EEA9  0769: 50               push ax
  05EEAA  076A: 9a5a011f18       lcall 0x181f, 0x15a
  05EEAF  076F: 83c402           add sp, 2
  05EEB2  0772: 6a42             push 0x42
  05EEB4  0774: 8d8638ff         lea ax, [bp - 0xc8]
  05EEB8  0778: 16               push ss
  05EEB9  0779: 50               push ax
  05EEBA  077A: 9a82011f18       lcall 0x181f, 0x182
  05EEBF  077F: 83c406           add sp, 6
  05EEC2  0782: 8d8638ff         lea ax, [bp - 0xc8]
  05EEC6  0786: 50               push ax
  05EEC7  0787: 9a0a011f18       lcall 0x181f, 0x10a
  05EECC  078C: 83c402           add sp, 2
  05EECF  078F: 837ee400         cmp word ptr [bp - 0x1c], 0
  05EED3  0793: 7447             je 0x7dc
  05EED5  0795: a03008           mov al, byte ptr [0x830]
  05EED8  0798: 2ae4             sub ah, ah
  05EEDA  079A: 50               push ax
  05EEDB  079B: 8b46f2           mov ax, word ptr [bp - 0xe]
  05EEDE  079E: 050600           add ax, 6
  05EEE1  07A1: 50               push ax
  05EEE2  07A2: ff768c           push word ptr [bp - 0x74]
  05EEE5  07A5: 8d4e94           lea cx, [bp - 0x6c]
  05EEE8  07A8: 16               push ss
  05EEE9  07A9: 51               push cx
  05EEEA  07AA: 8bf0             mov si, ax
  05EEEC  07AC: 9a3c011f18       lcall 0x181f, 0x13c
  05EEF1  07B1: 83c40a           add sp, 0xa
  05EEF4  07B4: a03108           mov al, byte ptr [0x831]
  05EEF7  07B7: 2ae4             sub ah, ah
  05EEF9  07B9: 50               push ax
  05EEFA  07BA: 56               push si
  05EEFB  07BB: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EEFE  07BE: 055000           add ax, 0x50
  05EF01  07C1: 50               push ax
  05EF02  07C2: 8d8638ff         lea ax, [bp - 0xc8]
  05EF06  07C6: 16               push ss
  05EF07  07C7: 50               push ax
  05EF08  07C8: 9a50011f18       lcall 0x181f, 0x150
  05EF0D  07CD: 83c40a           add sp, 0xa
  05EF10  07D0: 8346f214         add word ptr [bp - 0xe], 0x14
  05EF14  07D4: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EF17  07D7: 89468c           mov word ptr [bp - 0x74], ax
  05EF1A  07DA: eb08             jmp 0x7e4
  05EF1C  07DC: 8b76e8           mov si, word ptr [bp - 0x18]
  05EF1F  07DF: d1e6             shl si, 1
  05EF21  07E1: ff42ea           inc word ptr [bp + si - 0x16]
  05EF24  07E4: f6468a01         test byte ptr [bp - 0x76], 1
  05EF28  07E8: 7503             jne 0x7ed
  05EF2A  07EA: e99900           jmp 0x886
  05EF2D  07ED: c6469400         mov byte ptr [bp - 0x6c], 0
  05EF31  07F1: ff36542e         push word ptr [0x2e54]
  05EF35  07F5: 8d4694           lea ax, [bp - 0x6c]
  05EF38  07F8: 50               push ax
  05EF39  07F9: 9a6e011f18       lcall 0x181f, 0x16e
  05EF3E  07FE: 83c404           add sp, 4
  05EF41  0801: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05EF46  0806: 8d8638ff         lea ax, [bp - 0xc8]
  05EF4A  080A: 50               push ax
  05EF4B  080B: 9a46011f18       lcall 0x181f, 0x146
  05EF50  0810: 83c402           add sp, 2
  05EF53  0813: 6a32             push 0x32
  05EF55  0815: 8d8638ff         lea ax, [bp - 0xc8]
  05EF59  0819: 16               push ss
  05EF5A  081A: 50               push ax
  05EF5B  081B: 9a82011f18       lcall 0x181f, 0x182
  05EF60  0820: 83c406           add sp, 6
  05EF63  0823: 8d8638ff         lea ax, [bp - 0xc8]
  05EF67  0827: 50               push ax
  05EF68  0828: 9a0a011f18       lcall 0x181f, 0x10a
  05EF6D  082D: 83c402           add sp, 2
  05EF70  0830: 837ee400         cmp word ptr [bp - 0x1c], 0
  05EF74  0834: 7448             je 0x87e
  05EF76  0836: a03008           mov al, byte ptr [0x830]
  05EF79  0839: 2ae4             sub ah, ah
  05EF7B  083B: 50               push ax
  05EF7C  083C: 8b46f2           mov ax, word ptr [bp - 0xe]
  05EF7F  083F: 050600           add ax, 6
  05EF82  0842: 50               push ax
  05EF83  0843: ff768c           push word ptr [bp - 0x74]
  05EF86  0846: 8d4e94           lea cx, [bp - 0x6c]
  05EF89  0849: 16               push ss
  05EF8A  084A: 51               push cx
  05EF8B  084B: 8bf0             mov si, ax
  05EF8D  084D: 9a3c011f18       lcall 0x181f, 0x13c
  05EF92  0852: 83c40a           add sp, 0xa
  05EF95  0855: a03108           mov al, byte ptr [0x831]
  05EF98  0858: 2ae4             sub ah, ah
  05EF9A  085A: 50               push ax
  05EF9B  085B: 56               push si
  05EF9C  085C: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EF9F  085F: 055000           add ax, 0x50
  05EFA2  0862: 50               push ax
  05EFA3  0863: 8d8638ff         lea ax, [bp - 0xc8]
  05EFA7  0867: 16               push ss
  05EFA8  0868: 50               push ax
  05EFA9  0869: 9a50011f18       lcall 0x181f, 0x150
  05EFAE  086E: 83c40a           add sp, 0xa
  05EFB1  0871: 8346f214         add word ptr [bp - 0xe], 0x14
  05EFB5  0875: 8b46f4           mov ax, word ptr [bp - 0xc]
  05EFB8  0878: 89468c           mov word ptr [bp - 0x74], ax
  05EFBB  087B: eb09             jmp 0x886
  05EFBD  087D: 90               nop 
  05EFBE  087E: 8b76e8           mov si, word ptr [bp - 0x18]
  05EFC1  0881: d1e6             shl si, 1
  05EFC3  0883: ff42ea           inc word ptr [bp + si - 0x16]
  05EFC6  0886: f6468b80         test byte ptr [bp - 0x75], 0x80
  05EFCA  088A: 7503             jne 0x88f
  05EFCC  088C: e9ff00           jmp 0x98e
  05EFCF  088F: c746ee0100       mov word ptr [bp - 0x12], 1
  05EFD4  0894: ff7610           push word ptr [bp + 0x10]
  05EFD7  0897: ff760e           push word ptr [bp + 0xe]
  05EFDA  089A: 9abe071f18       lcall 0x181f, 0x7be
  05EFDF  089F: 83c404           add sp, 4
  05EFE2  08A2: 894616           mov word ptr [bp + 0x16], ax
  05EFE5  08A5: 0bc0             or ax, ax
  05EFE7  08A7: 7c10             jl 0x8b9
  05EFE9  08A9: 69d8ca00         imul bx, ax, 0xca
  05EFED  08AD: f687625d40       test byte ptr [bx + 0x5d62], 0x40
  05EFF2  08B2: 7505             jne 0x8b9
  05EFF4  08B4: c746ee0000       mov word ptr [bp - 0x12], 0
  05EFF9  08B9: 837ee400         cmp word ptr [bp - 0x1c], 0
  05EFFD  08BD: 7433             je 0x8f2
  05EFFF  08BF: 837eee00         cmp word ptr [bp - 0x12], 0
  05F003  08C3: 7411             je 0x8d6
  05F005  08C5: ff364008         push word ptr [0x840]
  05F009  08C9: ff363e08         push word ptr [0x83e]
  05F00D  08CD: ff76f2           push word ptr [bp - 0xe]
  05F010  08D0: a02e53           mov al, byte ptr [0x532e]
  05F013  08D3: eb0f             jmp 0x8e4
  05F015  08D5: 90               nop 
  05F016  08D6: ff364008         push word ptr [0x840]
  05F01A  08DA: ff363e08         push word ptr [0x83e]
  05F01E  08DE: ff76f2           push word ptr [bp - 0xe]
  05F021  08E1: a0cc52           mov al, byte ptr [0x52cc]
  05F024  08E4: 2ae4             sub ah, ah
  05F026  08E6: 8d1ea82d         lea bx, [0x2da8]
  05F02A  08EA: 8b568c           mov dx, word ptr [bp - 0x74]
  05F02D  08ED: 9a54021f18       lcall 0x181f, 0x254
  05F032  08F2: 83468c10         add word ptr [bp - 0x74], 0x10
  05F036  08F6: c6469400         mov byte ptr [bp - 0x6c], 0
  05F03A  08FA: ff368a2e         push word ptr [0x2e8a]
  05F03E  08FE: 8d4694           lea ax, [bp - 0x6c]
  05F041  0901: 50               push ax
  05F042  0902: 9a6e011f18       lcall 0x181f, 0x16e
  05F047  0907: 83c404           add sp, 4
  05F04A  090A: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F04F  090F: 8d8638ff         lea ax, [bp - 0xc8]
  05F053  0913: 50               push ax
  05F054  0914: 9a46011f18       lcall 0x181f, 0x146
  05F059  0919: 83c402           add sp, 2
  05F05C  091C: 6a32             push 0x32
  05F05E  091E: 8d8638ff         lea ax, [bp - 0xc8]
  05F062  0922: 16               push ss
  05F063  0923: 50               push ax
  05F064  0924: 9a82011f18       lcall 0x181f, 0x182
  05F069  0929: 83c406           add sp, 6
  05F06C  092C: 8d8638ff         lea ax, [bp - 0xc8]
  05F070  0930: 50               push ax
  05F071  0931: 9a0a011f18       lcall 0x181f, 0x10a
  05F076  0936: 83c402           add sp, 2
  05F079  0939: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F07D  093D: 7447             je 0x986
  05F07F  093F: a03008           mov al, byte ptr [0x830]
  05F082  0942: 2ae4             sub ah, ah
  05F084  0944: 50               push ax
  05F085  0945: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F088  0948: 050600           add ax, 6
  05F08B  094B: 50               push ax
  05F08C  094C: ff768c           push word ptr [bp - 0x74]
  05F08F  094F: 8d4e94           lea cx, [bp - 0x6c]
  05F092  0952: 16               push ss
  05F093  0953: 51               push cx
  05F094  0954: 8bf0             mov si, ax
  05F096  0956: 9a3c011f18       lcall 0x181f, 0x13c
  05F09B  095B: 83c40a           add sp, 0xa
  05F09E  095E: a03108           mov al, byte ptr [0x831]
  05F0A1  0961: 2ae4             sub ah, ah
  05F0A3  0963: 50               push ax
  05F0A4  0964: 56               push si
  05F0A5  0965: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F0A8  0968: 055000           add ax, 0x50
  05F0AB  096B: 50               push ax
  05F0AC  096C: 8d8638ff         lea ax, [bp - 0xc8]
  05F0B0  0970: 16               push ss
  05F0B1  0971: 50               push ax
  05F0B2  0972: 9a50011f18       lcall 0x181f, 0x150
  05F0B7  0977: 83c40a           add sp, 0xa
  05F0BA  097A: 8346f214         add word ptr [bp - 0xe], 0x14
  05F0BE  097E: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F0C1  0981: 89468c           mov word ptr [bp - 0x74], ax
  05F0C4  0984: eb08             jmp 0x98e
  05F0C6  0986: 8b76e8           mov si, word ptr [bp - 0x18]
  05F0C9  0989: d1e6             shl si, 1
  05F0CB  098B: ff42ea           inc word ptr [bp + si - 0x16]
  05F0CE  098E: f68634ff02       test byte ptr [bp - 0xcc], 2
  05F0D3  0993: 7503             jne 0x998
  05F0D5  0995: e9bc00           jmp 0xa54
  05F0D8  0998: ff7610           push word ptr [bp + 0x10]
  05F0DB  099B: ff760e           push word ptr [bp + 0xe]
  05F0DE  099E: 9abe071f18       lcall 0x181f, 0x7be
  05F0E3  09A3: 83c404           add sp, 4
  05F0E6  09A6: 894616           mov word ptr [bp + 0x16], ax
  05F0E9  09A9: 50               push ax
  05F0EA  09AA: 9ae6091f18       lcall 0x181f, 0x9e6
  05F0EF  09AF: 83c402           add sp, 2
  05F0F2  09B2: c6469400         mov byte ptr [bp - 0x6c], 0
  05F0F6  09B6: ff36c22e         push word ptr [0x2ec2]
  05F0FA  09BA: 8d4694           lea ax, [bp - 0x6c]
  05F0FD  09BD: 50               push ax
  05F0FE  09BE: 9a6e011f18       lcall 0x181f, 0x16e
  05F103  09C3: 83c404           add sp, 4
  05F106  09C6: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F10B  09CB: 8d8638ff         lea ax, [bp - 0xc8]
  05F10F  09CF: 50               push ax
  05F110  09D0: 9a46011f18       lcall 0x181f, 0x146
  05F115  09D5: 83c402           add sp, 2
  05F118  09D8: 9a860c1f18       lcall 0x181f, 0xc86
  05F11D  09DD: 2d6400           sub ax, 0x64
  05F120  09E0: f7d8             neg ax
  05F122  09E2: 50               push ax
  05F123  09E3: 8d8638ff         lea ax, [bp - 0xc8]
  05F127  09E7: 16               push ss
  05F128  09E8: 50               push ax
  05F129  09E9: 9a82011f18       lcall 0x181f, 0x182
  05F12E  09EE: 83c406           add sp, 6
  05F131  09F1: 8d8638ff         lea ax, [bp - 0xc8]
  05F135  09F5: 50               push ax
  05F136  09F6: 9a0a011f18       lcall 0x181f, 0x10a
  05F13B  09FB: 83c402           add sp, 2
  05F13E  09FE: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F142  0A02: 7448             je 0xa4c
  05F144  0A04: a03008           mov al, byte ptr [0x830]
  05F147  0A07: 2ae4             sub ah, ah
  05F149  0A09: 50               push ax
  05F14A  0A0A: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F14D  0A0D: 050600           add ax, 6
  05F150  0A10: 50               push ax
  05F151  0A11: ff768c           push word ptr [bp - 0x74]
  05F154  0A14: 8d4e94           lea cx, [bp - 0x6c]
  05F157  0A17: 16               push ss
  05F158  0A18: 51               push cx
  05F159  0A19: 8bf0             mov si, ax
  05F15B  0A1B: 9a3c011f18       lcall 0x181f, 0x13c
  05F160  0A20: 83c40a           add sp, 0xa
  05F163  0A23: a03108           mov al, byte ptr [0x831]
  05F166  0A26: 2ae4             sub ah, ah
  05F168  0A28: 50               push ax
  05F169  0A29: 56               push si
  05F16A  0A2A: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F16D  0A2D: 055000           add ax, 0x50
  05F170  0A30: 50               push ax
  05F171  0A31: 8d8638ff         lea ax, [bp - 0xc8]
  05F175  0A35: 16               push ss
  05F176  0A36: 50               push ax
  05F177  0A37: 9a50011f18       lcall 0x181f, 0x150
  05F17C  0A3C: 83c40a           add sp, 0xa
  05F17F  0A3F: 8346f214         add word ptr [bp - 0xe], 0x14
  05F183  0A43: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F186  0A46: 89468c           mov word ptr [bp - 0x74], ax
  05F189  0A49: eb09             jmp 0xa54
  05F18B  0A4B: 90               nop 
  05F18C  0A4C: 8b76e8           mov si, word ptr [bp - 0x18]
  05F18F  0A4F: d1e6             shl si, 1
  05F191  0A51: ff42ea           inc word ptr [bp + si - 0x16]
  05F194  0A54: f68634ff04       test byte ptr [bp - 0xcc], 4
  05F199  0A59: 7503             jne 0xa5e
  05F19B  0A5B: e99c00           jmp 0xafa
  05F19E  0A5E: c6469400         mov byte ptr [bp - 0x6c], 0
  05F1A2  0A62: ff36c42e         push word ptr [0x2ec4]
  05F1A6  0A66: 8d4694           lea ax, [bp - 0x6c]
  05F1A9  0A69: 50               push ax
  05F1AA  0A6A: 9a6e011f18       lcall 0x181f, 0x16e
  05F1AF  0A6F: 83c404           add sp, 4
  05F1B2  0A72: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F1B7  0A77: 8d8638ff         lea ax, [bp - 0xc8]
  05F1BB  0A7B: 50               push ax
  05F1BC  0A7C: 9a46011f18       lcall 0x181f, 0x146
  05F1C1  0A81: 83c402           add sp, 2
  05F1C4  0A84: 9a860c1f18       lcall 0x181f, 0xc86
  05F1C9  0A89: 50               push ax
  05F1CA  0A8A: 8d8638ff         lea ax, [bp - 0xc8]
  05F1CE  0A8E: 16               push ss
  05F1CF  0A8F: 50               push ax
  05F1D0  0A90: 9a82011f18       lcall 0x181f, 0x182
  05F1D5  0A95: 83c406           add sp, 6
  05F1D8  0A98: 8d8638ff         lea ax, [bp - 0xc8]
  05F1DC  0A9C: 50               push ax
  05F1DD  0A9D: 9a0a011f18       lcall 0x181f, 0x10a
  05F1E2  0AA2: 83c402           add sp, 2
  05F1E5  0AA5: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F1E9  0AA9: 7447             je 0xaf2
  05F1EB  0AAB: a03008           mov al, byte ptr [0x830]
  05F1EE  0AAE: 2ae4             sub ah, ah
  05F1F0  0AB0: 50               push ax
  05F1F1  0AB1: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F1F4  0AB4: 050600           add ax, 6
  05F1F7  0AB7: 50               push ax
  05F1F8  0AB8: ff768c           push word ptr [bp - 0x74]
  05F1FB  0ABB: 8d4e94           lea cx, [bp - 0x6c]
  05F1FE  0ABE: 16               push ss
  05F1FF  0ABF: 51               push cx
  05F200  0AC0: 8bf0             mov si, ax
  05F202  0AC2: 9a3c011f18       lcall 0x181f, 0x13c
  05F207  0AC7: 83c40a           add sp, 0xa
  05F20A  0ACA: a03108           mov al, byte ptr [0x831]
  05F20D  0ACD: 2ae4             sub ah, ah
  05F20F  0ACF: 50               push ax
  05F210  0AD0: 56               push si
  05F211  0AD1: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F214  0AD4: 055000           add ax, 0x50
  05F217  0AD7: 50               push ax
  05F218  0AD8: 8d8638ff         lea ax, [bp - 0xc8]
  05F21C  0ADC: 16               push ss
  05F21D  0ADD: 50               push ax
  05F21E  0ADE: 9a50011f18       lcall 0x181f, 0x150
  05F223  0AE3: 83c40a           add sp, 0xa
  05F226  0AE6: 8346f214         add word ptr [bp - 0xe], 0x14
  05F22A  0AEA: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F22D  0AED: 89468c           mov word ptr [bp - 0x74], ax
  05F230  0AF0: eb08             jmp 0xafa
  05F232  0AF2: 8b76e8           mov si, word ptr [bp - 0x18]
  05F235  0AF5: d1e6             shl si, 1
  05F237  0AF7: ff42ea           inc word ptr [bp + si - 0x16]
  05F23A  0AFA: f6468a80         test byte ptr [bp - 0x76], 0x80
  05F23E  0AFE: 7503             jne 0xb03
  05F240  0B00: e93f01           jmp 0xc42
  05F243  0B03: 837ee800         cmp word ptr [bp - 0x18], 0
  05F247  0B07: 7505             jne 0xb0e
  05F249  0B09: 8026028d7f       and byte ptr [0x8d02], 0x7f
  05F24E  0B0E: ff7610           push word ptr [bp + 0x10]
  05F251  0B11: ff760e           push word ptr [bp + 0xe]
  05F254  0B14: 9a8c071f18       lcall 0x181f, 0x78c
  05F259  0B19: 83c404           add sp, 4
  05F25C  0B1C: 8bd8             mov bx, ax
  05F25E  0B1E: 895e90           mov word ptr [bp - 0x70], bx
  05F261  0B21: c1e304           shl bx, 4
  05F264  0B24: 8a87772f         mov al, byte ptr [bx + 0x2f77]
  05F268  0B28: 2ae4             sub ah, ah
  05F26A  0B2A: 8946f8           mov word ptr [bp - 8], ax
  05F26D  0B2D: 0bc0             or ax, ax
  05F26F  0B2F: 7503             jne 0xb34
  05F271  0B31: e90e01           jmp 0xc42
  05F274  0B34: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F278  0B38: 7457             je 0xb91
  05F27A  0B3A: ff36a483         push word ptr [0x83a4]
  05F27E  0B3E: ff36a283         push word ptr [0x83a2]
  05F282  0B42: ff36a083         push word ptr [0x83a0]
  05F286  0B46: ff369e83         push word ptr [0x839e]
  05F28A  0B4A: ff36ae2d         push word ptr [0x2dae]
  05F28E  0B4E: ff36ac2d         push word ptr [0x2dac]
  05F292  0B52: ff36aa2d         push word ptr [0x2daa]
  05F296  0B56: ff36a82d         push word ptr [0x2da8]
  05F29A  0B5A: ff76f2           push word ptr [bp - 0xe]
  05F29D  0B5D: ff36d45a         push word ptr [0x5ad4]
  05F2A1  0B61: ff362683         push word ptr [0x8326]
  05F2A5  0B65: 8b4610           mov ax, word ptr [bp + 0x10]
  05F2A8  0B68: 2b062e83         sub ax, word ptr [0x832e]
  05F2AC  0B6C: 03062c83         add ax, word ptr [0x832c]
  05F2B0  0B70: f72e2683         imul word ptr [0x8326]
  05F2B4  0B74: 8bd0             mov dx, ax
  05F2B6  0B76: 8b460e           mov ax, word ptr [bp + 0xe]
  05F2B9  0B79: 2b062883         sub ax, word ptr [0x8328]
  05F2BD  0B7D: 03062a83         add ax, word ptr [0x832a]
  05F2C1  0B81: 8bca             mov cx, dx
  05F2C3  0B83: f72ed45a         imul word ptr [0x5ad4]
  05F2C7  0B87: 8bd1             mov dx, cx
  05F2C9  0B89: 8b5e8c           mov bx, word ptr [bp - 0x74]
  05F2CC  0B8C: 9a3a031f18       lcall 0x181f, 0x33a
  05F2D1  0B91: 83468c11         add word ptr [bp - 0x74], 0x11
  05F2D5  0B95: 837ee800         cmp word ptr [bp - 0x18], 0
  05F2D9  0B99: 750b             jne 0xba6
  05F2DB  0B9B: c6469400         mov byte ptr [bp - 0x6c], 0
  05F2DF  0B9F: ff36562e         push word ptr [0x2e56]
  05F2E3  0BA3: eb09             jmp 0xbae
  05F2E5  0BA5: 90               nop 
  05F2E6  0BA6: c6469400         mov byte ptr [bp - 0x6c], 0
  05F2EA  0BAA: ff36582e         push word ptr [0x2e58]
  05F2EE  0BAE: 8d4694           lea ax, [bp - 0x6c]
  05F2F1  0BB1: 50               push ax
  05F2F2  0BB2: 9a6e011f18       lcall 0x181f, 0x16e
  05F2F7  0BB7: 83c404           add sp, 4
  05F2FA  0BBA: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F2FF  0BBF: 8d8638ff         lea ax, [bp - 0xc8]
  05F303  0BC3: 50               push ax
  05F304  0BC4: 9a46011f18       lcall 0x181f, 0x146
  05F309  0BC9: 83c402           add sp, 2
  05F30C  0BCC: 6b46f819         imul ax, word ptr [bp - 8], 0x19
  05F310  0BD0: 50               push ax
  05F311  0BD1: 8d8638ff         lea ax, [bp - 0xc8]
  05F315  0BD5: 16               push ss
  05F316  0BD6: 50               push ax
  05F317  0BD7: 9a82011f18       lcall 0x181f, 0x182
  05F31C  0BDC: 83c406           add sp, 6
  05F31F  0BDF: 8d8638ff         lea ax, [bp - 0xc8]
  05F323  0BE3: 50               push ax
  05F324  0BE4: 9a0a011f18       lcall 0x181f, 0x10a
  05F329  0BE9: 83c402           add sp, 2
  05F32C  0BEC: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F330  0BF0: 7448             je 0xc3a
  05F332  0BF2: a03008           mov al, byte ptr [0x830]
  05F335  0BF5: 2ae4             sub ah, ah
  05F337  0BF7: 50               push ax
  05F338  0BF8: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F33B  0BFB: 050600           add ax, 6
  05F33E  0BFE: 50               push ax
  05F33F  0BFF: ff768c           push word ptr [bp - 0x74]
  05F342  0C02: 8d4e94           lea cx, [bp - 0x6c]
  05F345  0C05: 16               push ss
  05F346  0C06: 51               push cx
  05F347  0C07: 8bf0             mov si, ax
  05F349  0C09: 9a3c011f18       lcall 0x181f, 0x13c
  05F34E  0C0E: 83c40a           add sp, 0xa
  05F351  0C11: a03108           mov al, byte ptr [0x831]
  05F354  0C14: 2ae4             sub ah, ah
  05F356  0C16: 50               push ax
  05F357  0C17: 56               push si
  05F358  0C18: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F35B  0C1B: 055000           add ax, 0x50
  05F35E  0C1E: 50               push ax
  05F35F  0C1F: 8d8638ff         lea ax, [bp - 0xc8]
  05F363  0C23: 16               push ss
  05F364  0C24: 50               push ax
  05F365  0C25: 9a50011f18       lcall 0x181f, 0x150
  05F36A  0C2A: 83c40a           add sp, 0xa
  05F36D  0C2D: 8346f214         add word ptr [bp - 0xe], 0x14
  05F371  0C31: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F374  0C34: 89468c           mov word ptr [bp - 0x74], ax
  05F377  0C37: eb09             jmp 0xc42
  05F379  0C39: 90               nop 
  05F37A  0C3A: 8b76e8           mov si, word ptr [bp - 0x18]
  05F37D  0C3D: d1e6             shl si, 1
  05F37F  0C3F: ff42ea           inc word ptr [bp + si - 0x16]
  05F382  0C42: f6468a40         test byte ptr [bp - 0x76], 0x40
  05F386  0C46: 7503             jne 0xc4b
  05F388  0C48: e9f900           jmp 0xd44
  05F38B  0C4B: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F38F  0C4F: 7424             je 0xc75
  05F391  0C51: ff36ae2d         push word ptr [0x2dae]
  05F395  0C55: ff36ac2d         push word ptr [0x2dac]
  05F399  0C59: ff36aa2d         push word ptr [0x2daa]
  05F39D  0C5D: ff36a82d         push word ptr [0x2da8]
  05F3A1  0C61: 6a64             push 0x64
  05F3A3  0C63: 6a00             push 0
  05F3A5  0C65: 6a00             push 0
  05F3A7  0C67: 8b4616           mov ax, word ptr [bp + 0x16]
  05F3AA  0C6A: 8b568c           mov dx, word ptr [bp - 0x74]
  05F3AD  0C6D: 8b5ef2           mov bx, word ptr [bp - 0xe]
  05F3B0  0C70: 9aa8021f18       lcall 0x181f, 0x2a8
  05F3B5  0C75: 83468c14         add word ptr [bp - 0x74], 0x14
  05F3B9  0C79: 6a00             push 0
  05F3BB  0C7B: 9afc091f18       lcall 0x181f, 0x9fc
  05F3C0  0C80: 83c402           add sp, 2
  05F3C3  0C83: 0bc0             or ax, ax
  05F3C5  0C85: 741d             je 0xca4
  05F3C7  0C87: c6469400         mov byte ptr [bp - 0x6c], 0
  05F3CB  0C8B: 6a00             push 0
  05F3CD  0C8D: 9adc0b1f18       lcall 0x181f, 0xbdc
  05F3D2  0C92: 83c402           add sp, 2
  05F3D5  0C95: 8bd8             mov bx, ax
  05F3D7  0C97: d1e3             shl bx, 1
  05F3D9  0C99: 03d8             add bx, ax
  05F3DB  0C9B: c1e302           shl bx, 2
  05F3DE  0C9E: ffb7828f         push word ptr [bx - 0x707e]
  05F3E2  0CA2: eb08             jmp 0xcac
  05F3E4  0CA4: c6469400         mov byte ptr [bp - 0x6c], 0
  05F3E8  0CA8: ff365a2e         push word ptr [0x2e5a]
  05F3EC  0CAC: 8d4694           lea ax, [bp - 0x6c]
  05F3EF  0CAF: 50               push ax
  05F3F0  0CB0: 9a6e011f18       lcall 0x181f, 0x16e
  05F3F5  0CB5: 83c404           add sp, 4
  05F3F8  0CB8: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F3FD  0CBD: 8d8638ff         lea ax, [bp - 0xc8]
  05F401  0CC1: 50               push ax
  05F402  0CC2: 9a46011f18       lcall 0x181f, 0x146
  05F407  0CC7: 83c402           add sp, 2
  05F40A  0CCA: 9ad2091f18       lcall 0x181f, 0x9d2
  05F40F  0CCF: 40               inc ax
  05F410  0CD0: 6bc032           imul ax, ax, 0x32
  05F413  0CD3: 50               push ax
  05F414  0CD4: 8d8638ff         lea ax, [bp - 0xc8]
  05F418  0CD8: 16               push ss
  05F419  0CD9: 50               push ax
  05F41A  0CDA: 9a82011f18       lcall 0x181f, 0x182
  05F41F  0CDF: 83c406           add sp, 6
  05F422  0CE2: 8d8638ff         lea ax, [bp - 0xc8]
  05F426  0CE6: 50               push ax
  05F427  0CE7: 9a0a011f18       lcall 0x181f, 0x10a
  05F42C  0CEC: 83c402           add sp, 2
  05F42F  0CEF: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F433  0CF3: 7447             je 0xd3c
  05F435  0CF5: a03008           mov al, byte ptr [0x830]
  05F438  0CF8: 2ae4             sub ah, ah
  05F43A  0CFA: 50               push ax
  05F43B  0CFB: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F43E  0CFE: 050600           add ax, 6
  05F441  0D01: 50               push ax
  05F442  0D02: ff768c           push word ptr [bp - 0x74]
  05F445  0D05: 8d4e94           lea cx, [bp - 0x6c]
  05F448  0D08: 16               push ss
  05F449  0D09: 51               push cx
  05F44A  0D0A: 8bf0             mov si, ax
  05F44C  0D0C: 9a3c011f18       lcall 0x181f, 0x13c
  05F451  0D11: 83c40a           add sp, 0xa
  05F454  0D14: a03108           mov al, byte ptr [0x831]
  05F457  0D17: 2ae4             sub ah, ah
  05F459  0D19: 50               push ax
  05F45A  0D1A: 56               push si
  05F45B  0D1B: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F45E  0D1E: 055000           add ax, 0x50
  05F461  0D21: 50               push ax
  05F462  0D22: 8d8638ff         lea ax, [bp - 0xc8]
  05F466  0D26: 16               push ss
  05F467  0D27: 50               push ax
  05F468  0D28: 9a50011f18       lcall 0x181f, 0x150
  05F46D  0D2D: 83c40a           add sp, 0xa
  05F470  0D30: 8346f214         add word ptr [bp - 0xe], 0x14
  05F474  0D34: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F477  0D37: 89468c           mov word ptr [bp - 0x74], ax
  05F47A  0D3A: eb08             jmp 0xd44
  05F47C  0D3C: 8b76e8           mov si, word ptr [bp - 0x18]
  05F47F  0D3F: d1e6             shl si, 1
  05F481  0D41: ff42ea           inc word ptr [bp + si - 0x16]
  05F484  0D44: f6468a08         test byte ptr [bp - 0x76], 8
  05F488  0D48: 7503             jne 0xd4d
  05F48A  0D4A: e9f900           jmp 0xe46
  05F48D  0D4D: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F491  0D51: 7420             je 0xd73
  05F493  0D53: ff36ae2d         push word ptr [0x2dae]
  05F497  0D57: ff36ac2d         push word ptr [0x2dac]
  05F49B  0D5B: ff36aa2d         push word ptr [0x2daa]
  05F49F  0D5F: ff36a82d         push word ptr [0x2da8]
  05F4A3  0D63: 6a64             push 0x64
  05F4A5  0D65: 8b4618           mov ax, word ptr [bp + 0x18]
  05F4A8  0D68: 8b568c           mov dx, word ptr [bp - 0x74]
  05F4AB  0D6B: 8b5ef2           mov bx, word ptr [bp - 0xe]
  05F4AE  0D6E: 9ab2021f18       lcall 0x181f, 0x2b2
  05F4B3  0D73: 83468c14         add word ptr [bp - 0x74], 0x14
  05F4B7  0D77: c746f80100       mov word ptr [bp - 8], 1
  05F4BC  0D7C: f6468a10         test byte ptr [bp - 0x76], 0x10
  05F4C0  0D80: 7405             je 0xd87
  05F4C2  0D82: c746f80200       mov word ptr [bp - 8], 2
  05F4C7  0D87: f6468a20         test byte ptr [bp - 0x76], 0x20
  05F4CB  0D8B: 740d             je 0xd9a
  05F4CD  0D8D: d166f8           shl word ptr [bp - 8], 1
  05F4D0  0D90: c6469400         mov byte ptr [bp - 0x6c], 0
  05F4D4  0D94: ff364c96         push word ptr [0x964c]
  05F4D8  0D98: eb19             jmp 0xdb3
  05F4DA  0D9A: c6469400         mov byte ptr [bp - 0x6c], 0
  05F4DE  0D9E: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05F4E2  0DA2: 8a5f02           mov bl, byte ptr [bx + 2]
  05F4E5  0DA5: 2aff             sub bh, bh
  05F4E7  0DA7: 8bc3             mov ax, bx
  05F4E9  0DA9: d1e3             shl bx, 1
  05F4EB  0DAB: 03d8             add bx, ax
  05F4ED  0DAD: d1e3             shl bx, 1
  05F4EF  0DAF: ffb73496         push word ptr [bx - 0x69cc]
  05F4F3  0DB3: 8d4694           lea ax, [bp - 0x6c]
  05F4F6  0DB6: 50               push ax
  05F4F7  0DB7: 9a6e011f18       lcall 0x181f, 0x16e
  05F4FC  0DBC: 83c404           add sp, 4
  05F4FF  0DBF: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F504  0DC4: 8d8638ff         lea ax, [bp - 0xc8]
  05F508  0DC8: 50               push ax
  05F509  0DC9: 9a46011f18       lcall 0x181f, 0x146
  05F50E  0DCE: 83c402           add sp, 2
  05F511  0DD1: 6b46f832         imul ax, word ptr [bp - 8], 0x32
  05F515  0DD5: 50               push ax
  05F516  0DD6: 8d8638ff         lea ax, [bp - 0xc8]
  05F51A  0DDA: 16               push ss
  05F51B  0DDB: 50               push ax
  05F51C  0DDC: 9a82011f18       lcall 0x181f, 0x182
  05F521  0DE1: 83c406           add sp, 6
  05F524  0DE4: 8d8638ff         lea ax, [bp - 0xc8]
  05F528  0DE8: 50               push ax
  05F529  0DE9: 9a0a011f18       lcall 0x181f, 0x10a
  05F52E  0DEE: 83c402           add sp, 2
  05F531  0DF1: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F535  0DF5: 7447             je 0xe3e
  05F537  0DF7: a03008           mov al, byte ptr [0x830]
  05F53A  0DFA: 2ae4             sub ah, ah
  05F53C  0DFC: 50               push ax
  05F53D  0DFD: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F540  0E00: 050600           add ax, 6
  05F543  0E03: 50               push ax
  05F544  0E04: ff768c           push word ptr [bp - 0x74]
  05F547  0E07: 8d4e94           lea cx, [bp - 0x6c]
  05F54A  0E0A: 16               push ss
  05F54B  0E0B: 51               push cx
  05F54C  0E0C: 8bf0             mov si, ax
  05F54E  0E0E: 9a3c011f18       lcall 0x181f, 0x13c
  05F553  0E13: 83c40a           add sp, 0xa
  05F556  0E16: a03108           mov al, byte ptr [0x831]
  05F559  0E19: 2ae4             sub ah, ah
  05F55B  0E1B: 50               push ax
  05F55C  0E1C: 56               push si
  05F55D  0E1D: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F560  0E20: 055000           add ax, 0x50
  05F563  0E23: 50               push ax
  05F564  0E24: 8d8638ff         lea ax, [bp - 0xc8]
  05F568  0E28: 16               push ss
  05F569  0E29: 50               push ax
  05F56A  0E2A: 9a50011f18       lcall 0x181f, 0x150
  05F56F  0E2F: 83c40a           add sp, 0xa
  05F572  0E32: 8346f214         add word ptr [bp - 0xe], 0x14
  05F576  0E36: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F579  0E39: 89468c           mov word ptr [bp - 0x74], ax
  05F57C  0E3C: eb08             jmp 0xe46
  05F57E  0E3E: 8b76e8           mov si, word ptr [bp - 0x18]
  05F581  0E41: d1e6             shl si, 1
  05F583  0E43: ff42ea           inc word ptr [bp + si - 0x16]
  05F586  0E46: f6468b08         test byte ptr [bp - 0x75], 8
  05F58A  0E4A: 7503             jne 0xe4f
  05F58C  0E4C: e99900           jmp 0xee8
  05F58F  0E4F: c6469400         mov byte ptr [bp - 0x6c], 0
  05F593  0E53: ff36622e         push word ptr [0x2e62]
  05F597  0E57: 8d4694           lea ax, [bp - 0x6c]
  05F59A  0E5A: 50               push ax
  05F59B  0E5B: 9a6e011f18       lcall 0x181f, 0x16e
  05F5A0  0E60: 83c404           add sp, 4
  05F5A3  0E63: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F5A8  0E68: 8d8638ff         lea ax, [bp - 0xc8]
  05F5AC  0E6C: 50               push ax
  05F5AD  0E6D: 9a5a011f18       lcall 0x181f, 0x15a
  05F5B2  0E72: 83c402           add sp, 2
  05F5B5  0E75: 6a4b             push 0x4b
  05F5B7  0E77: 8d8638ff         lea ax, [bp - 0xc8]
  05F5BB  0E7B: 16               push ss
  05F5BC  0E7C: 50               push ax
  05F5BD  0E7D: 9a82011f18       lcall 0x181f, 0x182
  05F5C2  0E82: 83c406           add sp, 6
  05F5C5  0E85: 8d8638ff         lea ax, [bp - 0xc8]
  05F5C9  0E89: 50               push ax
  05F5CA  0E8A: 9a0a011f18       lcall 0x181f, 0x10a
  05F5CF  0E8F: 83c402           add sp, 2
  05F5D2  0E92: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F5D6  0E96: 7448             je 0xee0
  05F5D8  0E98: a03008           mov al, byte ptr [0x830]
  05F5DB  0E9B: 2ae4             sub ah, ah
  05F5DD  0E9D: 50               push ax
  05F5DE  0E9E: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F5E1  0EA1: 050600           add ax, 6
  05F5E4  0EA4: 50               push ax
  05F5E5  0EA5: ff768c           push word ptr [bp - 0x74]
  05F5E8  0EA8: 8d4e94           lea cx, [bp - 0x6c]
  05F5EB  0EAB: 16               push ss
  05F5EC  0EAC: 51               push cx
  05F5ED  0EAD: 8bf0             mov si, ax
  05F5EF  0EAF: 9a3c011f18       lcall 0x181f, 0x13c
  05F5F4  0EB4: 83c40a           add sp, 0xa
  05F5F7  0EB7: a03108           mov al, byte ptr [0x831]
  05F5FA  0EBA: 2ae4             sub ah, ah
  05F5FC  0EBC: 50               push ax
  05F5FD  0EBD: 56               push si
  05F5FE  0EBE: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F601  0EC1: 055000           add ax, 0x50
  05F604  0EC4: 50               push ax
  05F605  0EC5: 8d8638ff         lea ax, [bp - 0xc8]
  05F609  0EC9: 16               push ss
  05F60A  0ECA: 50               push ax
  05F60B  0ECB: 9a50011f18       lcall 0x181f, 0x150
  05F610  0ED0: 83c40a           add sp, 0xa
  05F613  0ED3: 8346f214         add word ptr [bp - 0xe], 0x14
  05F617  0ED7: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F61A  0EDA: 89468c           mov word ptr [bp - 0x74], ax
  05F61D  0EDD: eb09             jmp 0xee8
  05F61F  0EDF: 90               nop 
  05F620  0EE0: 8b76e8           mov si, word ptr [bp - 0x18]
  05F623  0EE3: d1e6             shl si, 1
  05F625  0EE5: ff42ea           inc word ptr [bp + si - 0x16]
  05F628  0EE8: f68634ff01       test byte ptr [bp - 0xcc], 1
  05F62D  0EED: 7503             jne 0xef2
  05F62F  0EEF: e99800           jmp 0xf8a
  05F632  0EF2: c6469400         mov byte ptr [bp - 0x6c], 0
  05F636  0EF6: ff36bc2e         push word ptr [0x2ebc]
  05F63A  0EFA: 8d4694           lea ax, [bp - 0x6c]
  05F63D  0EFD: 50               push ax
  05F63E  0EFE: 9a6e011f18       lcall 0x181f, 0x16e
  05F643  0F03: 83c404           add sp, 4
  05F646  0F06: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F64B  0F0B: 8d8638ff         lea ax, [bp - 0xc8]
  05F64F  0F0F: 50               push ax
  05F650  0F10: 9a46011f18       lcall 0x181f, 0x146
  05F655  0F15: 83c402           add sp, 2
  05F658  0F18: 6a64             push 0x64
  05F65A  0F1A: 8d8638ff         lea ax, [bp - 0xc8]
  05F65E  0F1E: 16               push ss
  05F65F  0F1F: 50               push ax
  05F660  0F20: 9a82011f18       lcall 0x181f, 0x182
  05F665  0F25: 83c406           add sp, 6
  05F668  0F28: 8d8638ff         lea ax, [bp - 0xc8]
  05F66C  0F2C: 50               push ax
  05F66D  0F2D: 9a0a011f18       lcall 0x181f, 0x10a
  05F672  0F32: 83c402           add sp, 2
  05F675  0F35: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F679  0F39: 7447             je 0xf82
  05F67B  0F3B: a03008           mov al, byte ptr [0x830]
  05F67E  0F3E: 2ae4             sub ah, ah
  05F680  0F40: 50               push ax
  05F681  0F41: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F684  0F44: 050600           add ax, 6
  05F687  0F47: 50               push ax
  05F688  0F48: ff768c           push word ptr [bp - 0x74]
  05F68B  0F4B: 8d4e94           lea cx, [bp - 0x6c]
  05F68E  0F4E: 16               push ss
  05F68F  0F4F: 51               push cx
  05F690  0F50: 8bf0             mov si, ax
  05F692  0F52: 9a3c011f18       lcall 0x181f, 0x13c
  05F697  0F57: 83c40a           add sp, 0xa
  05F69A  0F5A: a03108           mov al, byte ptr [0x831]
  05F69D  0F5D: 2ae4             sub ah, ah
  05F69F  0F5F: 50               push ax
  05F6A0  0F60: 56               push si
  05F6A1  0F61: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F6A4  0F64: 055000           add ax, 0x50
  05F6A7  0F67: 50               push ax
  05F6A8  0F68: 8d8638ff         lea ax, [bp - 0xc8]
  05F6AC  0F6C: 16               push ss
  05F6AD  0F6D: 50               push ax
  05F6AE  0F6E: 9a50011f18       lcall 0x181f, 0x150
  05F6B3  0F73: 83c40a           add sp, 0xa
  05F6B6  0F76: 8346f214         add word ptr [bp - 0xe], 0x14
  05F6BA  0F7A: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F6BD  0F7D: 89468c           mov word ptr [bp - 0x74], ax
  05F6C0  0F80: eb08             jmp 0xf8a
  05F6C2  0F82: 8b76e8           mov si, word ptr [bp - 0x18]
  05F6C5  0F85: d1e6             shl si, 1
  05F6C7  0F87: ff42ea           inc word ptr [bp + si - 0x16]
  05F6CA  0F8A: f6468b20         test byte ptr [bp - 0x75], 0x20
  05F6CE  0F8E: 7503             jne 0xf93
  05F6D0  0F90: e99900           jmp 0x102c
  05F6D3  0F93: c6469400         mov byte ptr [bp - 0x6c], 0
  05F6D7  0F97: ff365c2e         push word ptr [0x2e5c]
  05F6DB  0F9B: 8d4694           lea ax, [bp - 0x6c]
  05F6DE  0F9E: 50               push ax
  05F6DF  0F9F: 9a6e011f18       lcall 0x181f, 0x16e
  05F6E4  0FA4: 83c404           add sp, 4
  05F6E7  0FA7: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F6EC  0FAC: 8d8638ff         lea ax, [bp - 0xc8]
  05F6F0  0FB0: 50               push ax
  05F6F1  0FB1: 9a46011f18       lcall 0x181f, 0x146
  05F6F6  0FB6: 83c402           add sp, 2
  05F6F9  0FB9: 6a32             push 0x32
  05F6FB  0FBB: 8d8638ff         lea ax, [bp - 0xc8]
  05F6FF  0FBF: 16               push ss
  05F700  0FC0: 50               push ax
  05F701  0FC1: 9a82011f18       lcall 0x181f, 0x182
  05F706  0FC6: 83c406           add sp, 6
  05F709  0FC9: 8d8638ff         lea ax, [bp - 0xc8]
  05F70D  0FCD: 50               push ax
  05F70E  0FCE: 9a0a011f18       lcall 0x181f, 0x10a
  05F713  0FD3: 83c402           add sp, 2
  05F716  0FD6: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F71A  0FDA: 7448             je 0x1024
  05F71C  0FDC: a03008           mov al, byte ptr [0x830]
  05F71F  0FDF: 2ae4             sub ah, ah
  05F721  0FE1: 50               push ax
  05F722  0FE2: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F725  0FE5: 050600           add ax, 6
  05F728  0FE8: 50               push ax
  05F729  0FE9: ff768c           push word ptr [bp - 0x74]
  05F72C  0FEC: 8d4e94           lea cx, [bp - 0x6c]
  05F72F  0FEF: 16               push ss
  05F730  0FF0: 51               push cx
  05F731  0FF1: 8bf0             mov si, ax
  05F733  0FF3: 9a3c011f18       lcall 0x181f, 0x13c
  05F738  0FF8: 83c40a           add sp, 0xa
  05F73B  0FFB: a03108           mov al, byte ptr [0x831]
  05F73E  0FFE: 2ae4             sub ah, ah
  05F740  1000: 50               push ax
  05F741  1001: 56               push si
  05F742  1002: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F745  1005: 055000           add ax, 0x50
  05F748  1008: 50               push ax
  05F749  1009: 8d8638ff         lea ax, [bp - 0xc8]
  05F74D  100D: 16               push ss
  05F74E  100E: 50               push ax
  05F74F  100F: 9a50011f18       lcall 0x181f, 0x150
  05F754  1014: 83c40a           add sp, 0xa
  05F757  1017: 8346f214         add word ptr [bp - 0xe], 0x14
  05F75B  101B: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F75E  101E: 89468c           mov word ptr [bp - 0x74], ax
  05F761  1021: eb09             jmp 0x102c
  05F763  1023: 90               nop 
  05F764  1024: 8b76e8           mov si, word ptr [bp - 0x18]
  05F767  1027: d1e6             shl si, 1
  05F769  1029: ff42ea           inc word ptr [bp + si - 0x16]
  05F76C  102C: f6468b10         test byte ptr [bp - 0x75], 0x10
  05F770  1030: 7503             jne 0x1035
  05F772  1032: e99900           jmp 0x10ce
  05F775  1035: c6469400         mov byte ptr [bp - 0x6c], 0
  05F779  1039: ff365e2e         push word ptr [0x2e5e]
  05F77D  103D: 8d4694           lea ax, [bp - 0x6c]
  05F780  1040: 50               push ax
  05F781  1041: 9a6e011f18       lcall 0x181f, 0x16e
  05F786  1046: 83c404           add sp, 4
  05F789  1049: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F78E  104E: 8d8638ff         lea ax, [bp - 0xc8]
  05F792  1052: 50               push ax
  05F793  1053: 9a46011f18       lcall 0x181f, 0x146
  05F798  1058: 83c402           add sp, 2
  05F79B  105B: 6a32             push 0x32
  05F79D  105D: 8d8638ff         lea ax, [bp - 0xc8]
  05F7A1  1061: 16               push ss
  05F7A2  1062: 50               push ax
  05F7A3  1063: 9a82011f18       lcall 0x181f, 0x182
  05F7A8  1068: 83c406           add sp, 6
  05F7AB  106B: 8d8638ff         lea ax, [bp - 0xc8]
  05F7AF  106F: 50               push ax
  05F7B0  1070: 9a0a011f18       lcall 0x181f, 0x10a
  05F7B5  1075: 83c402           add sp, 2
  05F7B8  1078: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F7BC  107C: 7448             je 0x10c6
  05F7BE  107E: a03008           mov al, byte ptr [0x830]
  05F7C1  1081: 2ae4             sub ah, ah
  05F7C3  1083: 50               push ax
  05F7C4  1084: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F7C7  1087: 050600           add ax, 6
  05F7CA  108A: 50               push ax
  05F7CB  108B: ff768c           push word ptr [bp - 0x74]
  05F7CE  108E: 8d4e94           lea cx, [bp - 0x6c]
  05F7D1  1091: 16               push ss
  05F7D2  1092: 51               push cx
  05F7D3  1093: 8bf0             mov si, ax
  05F7D5  1095: 9a3c011f18       lcall 0x181f, 0x13c
  05F7DA  109A: 83c40a           add sp, 0xa
  05F7DD  109D: a03108           mov al, byte ptr [0x831]
  05F7E0  10A0: 2ae4             sub ah, ah
  05F7E2  10A2: 50               push ax
  05F7E3  10A3: 56               push si
  05F7E4  10A4: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F7E7  10A7: 055000           add ax, 0x50
  05F7EA  10AA: 50               push ax
  05F7EB  10AB: 8d8638ff         lea ax, [bp - 0xc8]
  05F7EF  10AF: 16               push ss
  05F7F0  10B0: 50               push ax
  05F7F1  10B1: 9a50011f18       lcall 0x181f, 0x150
  05F7F6  10B6: 83c40a           add sp, 0xa
  05F7F9  10B9: 8346f214         add word ptr [bp - 0xe], 0x14
  05F7FD  10BD: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F800  10C0: 89468c           mov word ptr [bp - 0x74], ax
  05F803  10C3: eb09             jmp 0x10ce
  05F805  10C5: 90               nop 
  05F806  10C6: 8b76e8           mov si, word ptr [bp - 0x18]
  05F809  10C9: d1e6             shl si, 1
  05F80B  10CB: ff42ea           inc word ptr [bp + si - 0x16]
  05F80E  10CE: f6468b40         test byte ptr [bp - 0x75], 0x40
  05F812  10D2: 7503             jne 0x10d7
  05F814  10D4: e99900           jmp 0x1170
  05F817  10D7: c6469400         mov byte ptr [bp - 0x6c], 0
  05F81B  10DB: ff366e2e         push word ptr [0x2e6e]
  05F81F  10DF: 8d4694           lea ax, [bp - 0x6c]
  05F822  10E2: 50               push ax
  05F823  10E3: 9a6e011f18       lcall 0x181f, 0x16e
  05F828  10E8: 83c404           add sp, 4
  05F82B  10EB: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F830  10F0: 8d8638ff         lea ax, [bp - 0xc8]
  05F834  10F4: 50               push ax
  05F835  10F5: 9a46011f18       lcall 0x181f, 0x146
  05F83A  10FA: 83c402           add sp, 2
  05F83D  10FD: 6a32             push 0x32
  05F83F  10FF: 8d8638ff         lea ax, [bp - 0xc8]
  05F843  1103: 16               push ss
  05F844  1104: 50               push ax
  05F845  1105: 9a82011f18       lcall 0x181f, 0x182
  05F84A  110A: 83c406           add sp, 6
  05F84D  110D: 8d8638ff         lea ax, [bp - 0xc8]
  05F851  1111: 50               push ax
  05F852  1112: 9a0a011f18       lcall 0x181f, 0x10a
  05F857  1117: 83c402           add sp, 2
  05F85A  111A: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F85E  111E: 7448             je 0x1168
  05F860  1120: a03008           mov al, byte ptr [0x830]
  05F863  1123: 2ae4             sub ah, ah
  05F865  1125: 50               push ax
  05F866  1126: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F869  1129: 050600           add ax, 6
  05F86C  112C: 50               push ax
  05F86D  112D: ff768c           push word ptr [bp - 0x74]
  05F870  1130: 8d4e94           lea cx, [bp - 0x6c]
  05F873  1133: 16               push ss
  05F874  1134: 51               push cx
  05F875  1135: 8bf0             mov si, ax
  05F877  1137: 9a3c011f18       lcall 0x181f, 0x13c
  05F87C  113C: 83c40a           add sp, 0xa
  05F87F  113F: a03108           mov al, byte ptr [0x831]
  05F882  1142: 2ae4             sub ah, ah
  05F884  1144: 50               push ax
  05F885  1145: 56               push si
  05F886  1146: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F889  1149: 055000           add ax, 0x50
  05F88C  114C: 50               push ax
  05F88D  114D: 8d8638ff         lea ax, [bp - 0xc8]
  05F891  1151: 16               push ss
  05F892  1152: 50               push ax
  05F893  1153: 9a50011f18       lcall 0x181f, 0x150
  05F898  1158: 83c40a           add sp, 0xa
  05F89B  115B: 8346f214         add word ptr [bp - 0xe], 0x14
  05F89F  115F: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F8A2  1162: 89468c           mov word ptr [bp - 0x74], ax
  05F8A5  1165: eb09             jmp 0x1170
  05F8A7  1167: 90               nop 
  05F8A8  1168: 8b76e8           mov si, word ptr [bp - 0x18]
  05F8AB  116B: d1e6             shl si, 1
  05F8AD  116D: ff42ea           inc word ptr [bp + si - 0x16]
  05F8B0  1170: f606835320       test byte ptr [0x5383], 0x20
  05F8B5  1175: 7503             jne 0x117a
  05F8B7  1177: e97e01           jmp 0x12f8
  05F8BA  117A: f6468b02         test byte ptr [bp - 0x75], 2
  05F8BE  117E: 741a             je 0x119a
  05F8C0  1180: c6469400         mov byte ptr [bp - 0x6c], 0
  05F8C4  1184: 6b5e881c         imul bx, word ptr [bp - 0x78], 0x1c
  05F8C8  1188: 8a875b31         mov al, byte ptr [bx + 0x315b]
  05F8CC  118C: 98               cwde 
  05F8CD  118D: 50               push ax
  05F8CE  118E: 9a180c1f18       lcall 0x181f, 0xc18
  05F8D3  1193: 83c402           add sp, 2
  05F8D6  1196: 50               push ax
  05F8D7  1197: eb1f             jmp 0x11b8
  05F8D9  1199: 90               nop 
  05F8DA  119A: c6469400         mov byte ptr [bp - 0x6c], 0
  05F8DE  119E: 6b5e881c         imul bx, word ptr [bp - 0x78], 0x1c
  05F8E2  11A2: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05F8E6  11A6: 2aff             sub bh, bh
  05F8E8  11A8: 8bc3             mov ax, bx
  05F8EA  11AA: d1e3             shl bx, 1
  05F8EC  11AC: 03d8             add bx, ax
  05F8EE  11AE: d1e3             shl bx, 1
  05F8F0  11B0: 03d8             add bx, ax
  05F8F2  11B2: d1e3             shl bx, 1
  05F8F4  11B4: ffb73052         push word ptr [bx + 0x5230]
  05F8F8  11B8: 8d4694           lea ax, [bp - 0x6c]
  05F8FB  11BB: 50               push ax
  05F8FC  11BC: 9a6e011f18       lcall 0x181f, 0x16e
  05F901  11C1: 83c404           add sp, 4
  05F904  11C4: 837ee800         cmp word ptr [bp - 0x18], 0
  05F908  11C8: 7518             jne 0x11e2
  05F90A  11CA: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F90F  11CF: 8d8638ff         lea ax, [bp - 0xc8]
  05F913  11D3: 50               push ax
  05F914  11D4: 9a46011f18       lcall 0x181f, 0x146
  05F919  11D9: 83c402           add sp, 2
  05F91C  11DC: ff761a           push word ptr [bp + 0x1a]
  05F91F  11DF: eb16             jmp 0x11f7
  05F921  11E1: 90               nop 
  05F922  11E2: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F927  11E7: 8d8638ff         lea ax, [bp - 0xc8]
  05F92B  11EB: 50               push ax
  05F92C  11EC: 9a46011f18       lcall 0x181f, 0x146
  05F931  11F1: 83c402           add sp, 2
  05F934  11F4: ff761c           push word ptr [bp + 0x1c]
  05F937  11F7: 8d8638ff         lea ax, [bp - 0xc8]
  05F93B  11FB: 16               push ss
  05F93C  11FC: 50               push ax
  05F93D  11FD: 9a82011f18       lcall 0x181f, 0x182
  05F942  1202: 83c406           add sp, 6
  05F945  1205: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F949  1209: 7447             je 0x1252
  05F94B  120B: a03008           mov al, byte ptr [0x830]
  05F94E  120E: 2ae4             sub ah, ah
  05F950  1210: 50               push ax
  05F951  1211: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F954  1214: 050600           add ax, 6
  05F957  1217: 50               push ax
  05F958  1218: ff768c           push word ptr [bp - 0x74]
  05F95B  121B: 8d4e94           lea cx, [bp - 0x6c]
  05F95E  121E: 16               push ss
  05F95F  121F: 51               push cx
  05F960  1220: 8bf0             mov si, ax
  05F962  1222: 9a3c011f18       lcall 0x181f, 0x13c
  05F967  1227: 83c40a           add sp, 0xa
  05F96A  122A: a03108           mov al, byte ptr [0x831]
  05F96D  122D: 2ae4             sub ah, ah
  05F96F  122F: 50               push ax
  05F970  1230: 56               push si
  05F971  1231: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F974  1234: 055000           add ax, 0x50
  05F977  1237: 50               push ax
  05F978  1238: 8d8638ff         lea ax, [bp - 0xc8]
  05F97C  123C: 16               push ss
  05F97D  123D: 50               push ax
  05F97E  123E: 9a50011f18       lcall 0x181f, 0x150
  05F983  1243: 83c40a           add sp, 0xa
  05F986  1246: 8346f214         add word ptr [bp - 0xe], 0x14
  05F98A  124A: 8b46f4           mov ax, word ptr [bp - 0xc]
  05F98D  124D: 89468c           mov word ptr [bp - 0x74], ax
  05F990  1250: eb08             jmp 0x125a
  05F992  1252: 8b76e8           mov si, word ptr [bp - 0x18]
  05F995  1255: d1e6             shl si, 1
  05F997  1257: ff42ea           inc word ptr [bp + si - 0x16]
  05F99A  125A: 837ee800         cmp word ptr [bp - 0x18], 0
  05F99E  125E: 7518             jne 0x1278
  05F9A0  1260: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F9A5  1265: 8d8638ff         lea ax, [bp - 0xc8]
  05F9A9  1269: 50               push ax
  05F9AA  126A: 9a46011f18       lcall 0x181f, 0x146
  05F9AF  126F: 83c402           add sp, 2
  05F9B2  1272: ff761e           push word ptr [bp + 0x1e]
  05F9B5  1275: eb1a             jmp 0x1291
  05F9B7  1277: 90               nop 
  05F9B8  1278: c68638ff00       mov byte ptr [bp - 0xc8], 0
  05F9BD  127D: 8d8638ff         lea ax, [bp - 0xc8]
  05F9C1  1281: 50               push ax
  05F9C2  1282: 9a46011f18       lcall 0x181f, 0x146
  05F9C7  1287: 83c402           add sp, 2
  05F9CA  128A: 8b461c           mov ax, word ptr [bp + 0x1c]
  05F9CD  128D: 03461a           add ax, word ptr [bp + 0x1a]
  05F9D0  1290: 50               push ax
  05F9D1  1291: 8d8638ff         lea ax, [bp - 0xc8]
  05F9D5  1295: 16               push ss
  05F9D6  1296: 50               push ax
  05F9D7  1297: 9a82011f18       lcall 0x181f, 0x182
  05F9DC  129C: 83c406           add sp, 6
  05F9DF  129F: c6469400         mov byte ptr [bp - 0x6c], 0
  05F9E3  12A3: 837ee400         cmp word ptr [bp - 0x1c], 0
  05F9E7  12A7: 7447             je 0x12f0
  05F9E9  12A9: a03008           mov al, byte ptr [0x830]
  05F9EC  12AC: 2ae4             sub ah, ah
  05F9EE  12AE: 50               push ax
  05F9EF  12AF: 8b46f2           mov ax, word ptr [bp - 0xe]
  05F9F2  12B2: 050600           add ax, 6
  05F9F5  12B5: 50               push ax
  05F9F6  12B6: ff768c           push word ptr [bp - 0x74]
  05F9F9  12B9: 8d4e94           lea cx, [bp - 0x6c]
  05F9FC  12BC: 16               push ss
  05F9FD  12BD: 51               push cx
  05F9FE  12BE: 8bf0             mov si, ax
  05FA00  12C0: 9a3c011f18       lcall 0x181f, 0x13c
  05FA05  12C5: 83c40a           add sp, 0xa
  05FA08  12C8: a03108           mov al, byte ptr [0x831]
  05FA0B  12CB: 2ae4             sub ah, ah
  05FA0D  12CD: 50               push ax
  05FA0E  12CE: 56               push si
  05FA0F  12CF: 8b46f4           mov ax, word ptr [bp - 0xc]
  05FA12  12D2: 055000           add ax, 0x50
  05FA15  12D5: 50               push ax
  05FA16  12D6: 8d8638ff         lea ax, [bp - 0xc8]
  05FA1A  12DA: 16               push ss
  05FA1B  12DB: 50               push ax
  05FA1C  12DC: 9a50011f18       lcall 0x181f, 0x150
  05FA21  12E1: 83c40a           add sp, 0xa
  05FA24  12E4: 8346f214         add word ptr [bp - 0xe], 0x14
  05FA28  12E8: 8b46f4           mov ax, word ptr [bp - 0xc]
  05FA2B  12EB: 89468c           mov word ptr [bp - 0x74], ax
  05FA2E  12EE: eb08             jmp 0x12f8
  05FA30  12F0: 8b76e8           mov si, word ptr [bp - 0x18]
  05FA33  12F3: d1e6             shl si, 1
  05FA35  12F5: ff42ea           inc word ptr [bp + si - 0x16]
  05FA38  12F8: ff46e8           inc word ptr [bp - 0x18]
  05FA3B  12FB: 837ee801         cmp word ptr [bp - 0x18], 1
  05FA3F  12FF: 7f3b             jg 0x133c
  05FA41  1301: 8b46f6           mov ax, word ptr [bp - 0xa]
  05FA44  1304: 8946f2           mov word ptr [bp - 0xe], ax
  05FA47  1307: 8b5ee8           mov bx, word ptr [bp - 0x18]
  05FA4A  130A: d1e3             shl bx, 1
  05FA4C  130C: 8b87008d         mov ax, word ptr [bx - 0x7300]
  05FA50  1310: 89468a           mov word ptr [bp - 0x76], ax
  05FA53  1313: 8b8756a1         mov ax, word ptr [bx - 0x5eaa]
  05FA57  1317: 898634ff         mov word ptr [bp - 0xcc], ax
  05FA5B  131B: 837ee801         cmp word ptr [bp - 0x18], 1
  05FA5F  131F: 1bc0             sbb ax, ax
  05FA61  1321: 249a             and al, 0x9a
  05FA63  1323: 056800           add ax, 0x68
  05FA66  1326: 0346fc           add ax, word ptr [bp - 4]
  05FA69  1329: 8946f4           mov word ptr [bp - 0xc], ax
  05FA6C  132C: 837ee800         cmp word ptr [bp - 0x18], 0
  05FA70  1330: 7403             je 0x1335
  05FA72  1332: e901f0           jmp 0x336
  05FA75  1335: 8b4606           mov ax, word ptr [bp + 6]
  05FA78  1338: e9feef           jmp 0x339
  05FA7B  133B: 90               nop 
  05FA7C  133C: ff46e4           inc word ptr [bp - 0x1c]
  05FA7F  133F: 837ee402         cmp word ptr [bp - 0x1c], 2
  05FA83  1343: 7d1f             jge 0x1364
  05FA85  1345: 8b46fc           mov ax, word ptr [bp - 4]
  05FA88  1348: 8946f4           mov word ptr [bp - 0xc], ax
  05FA8B  134B: 8b46fa           mov ax, word ptr [bp - 6]
  05FA8E  134E: 8946f2           mov word ptr [bp - 0xe], ax
  05FA91  1351: 837ee400         cmp word ptr [bp - 0x1c], 0
  05FA95  1355: 7403             je 0x135a
  05FA97  1357: e952ef           jmp 0x2ac
  05FA9A  135A: ff46ea           inc word ptr [bp - 0x16]
  05FA9D  135D: ff46ec           inc word ptr [bp - 0x14]
  05FAA0  1360: e9c5ef           jmp 0x328
  05FAA3  1363: 90               nop 
  05FAA4  1364: 6a00             push 0
  05FAA6  1366: 684001           push 0x140
  05FAA9  1369: 68c800           push 0xc8
  05FAAC  136C: 2bc0             sub ax, ax
  05FAAE  136E: 99               cdq 
  05FAAF  136F: 2bdb             sub bx, bx
  05FAB1  1371: 9ae2001f18       lcall 0x181f, 0xe2
  05FAB6  1376: 9ac0031f18       lcall 0x181f, 0x3c0
  05FABB  137B: 9a6a051f18       lcall 0x181f, 0x56a
  05FAC0  1380: 5e               pop si
  05FAC1  1381: c9               leave 
  05FAC2  1382: cb               retf 
