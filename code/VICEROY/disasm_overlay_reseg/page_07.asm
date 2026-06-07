; ============================================================
; VICEROY.EXE overlay page 0x07 (record 6) -- RE-SEGMENTED
; file_offset (disk image) = 0x03EA60
; code_offset (first insn) = 0x03ECF0
; code_end (next reloc hdr)= 0x0400F0  [resident size 320 para -> nominal_end 0x03FE60; on-disk code spills past it]
; reloc_count = 152  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x03EA60)
; functions in page = 5
; ============================================================

; ---- func_03ECF0  size=3101  insns=991  prologue=ENTER 0x0040,0  terminal=RETF ----
  03ECF0  0290: c8400000         enter 0x40, 0
  03ECF4  0294: 57               push di
  03ECF5  0295: 56               push si
  03ECF6  0296: b8ffff           mov ax, 0xffff
  03ECF9  0299: 8946f6           mov word ptr [bp - 0xa], ax
  03ECFC  029C: 2bc0             sub ax, ax
  03ECFE  029E: 8946de           mov word ptr [bp - 0x22], ax
  03ED01  02A1: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03ED05  02A5: a19c53           mov ax, word ptr [0x539c]
  03ED08  02A8: 8946f0           mov word ptr [bp - 0x10], ax
  03ED0B  02AB: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03ED0F  02AF: 8a874431         mov al, byte ptr [bx + 0x3144]
  03ED13  02B3: 2ae4             sub ah, ah
  03ED15  02B5: 8946e0           mov word ptr [bp - 0x20], ax
  03ED18  02B8: 8a874531         mov al, byte ptr [bx + 0x3145]
  03ED1C  02BC: 8946d8           mov word ptr [bp - 0x28], ax
  03ED1F  02BF: ff760a           push word ptr [bp + 0xa]
  03ED22  02C2: ff7608           push word ptr [bp + 8]
  03ED25  02C5: 9a8c071f18       lcall 0x181f, 0x78c
  03ED2A  02CA: 83c404           add sp, 4
  03ED2D  02CD: 8bd8             mov bx, ax
  03ED2F  02CF: 895ed4           mov word ptr [bp - 0x2c], bx
  03ED32  02D2: c1e304           shl bx, 4
  03ED35  02D5: 8a87762f         mov al, byte ptr [bx + 0x2f76]
  03ED39  02D9: 2ae4             sub ah, ah
  03ED3B  02DB: 8bc8             mov cx, ax
  03ED3D  02DD: d1e0             shl ax, 1
  03ED3F  02DF: 03c1             add ax, cx
  03ED41  02E1: 8946c2           mov word ptr [bp - 0x3e], ax
  03ED44  02E4: ff76d8           push word ptr [bp - 0x28]
  03ED47  02E7: ff76e0           push word ptr [bp - 0x20]
  03ED4A  02EA: 9a54071f18       lcall 0x181f, 0x754
  03ED4F  02EF: 83c404           add sp, 4
  03ED52  02F2: a80a             test al, 0xa
  03ED54  02F4: 7417             je 0x30d
  03ED56  02F6: ff760a           push word ptr [bp + 0xa]
  03ED59  02F9: ff7608           push word ptr [bp + 8]
  03ED5C  02FC: 9a54071f18       lcall 0x181f, 0x754
  03ED61  0301: 83c404           add sp, 4
  03ED64  0304: a80a             test al, 0xa
  03ED66  0306: 7405             je 0x30d
  03ED68  0308: c746c20100       mov word ptr [bp - 0x3e], 1
  03ED6D  030D: ff76d8           push word ptr [bp - 0x28]
  03ED70  0310: ff76e0           push word ptr [bp - 0x20]
  03ED73  0313: 9a2c071f18       lcall 0x181f, 0x72c
  03ED78  0318: 83c404           add sp, 4
  03ED7B  031B: a840             test al, 0x40
  03ED7D  031D: 7427             je 0x346
  03ED7F  031F: ff760a           push word ptr [bp + 0xa]
  03ED82  0322: ff7608           push word ptr [bp + 8]
  03ED85  0325: 9a2c071f18       lcall 0x181f, 0x72c
  03ED8A  032A: 83c404           add sp, 4
  03ED8D  032D: a840             test al, 0x40
  03ED8F  032F: 7415             je 0x346
  03ED91  0331: 8b4608           mov ax, word ptr [bp + 8]
  03ED94  0334: 3946e0           cmp word ptr [bp - 0x20], ax
  03ED97  0337: 7408             je 0x341
  03ED99  0339: 8b460a           mov ax, word ptr [bp + 0xa]
  03ED9C  033C: 3946d8           cmp word ptr [bp - 0x28], ax
  03ED9F  033F: 7505             jne 0x346
  03EDA1  0341: c746c20100       mov word ptr [bp - 0x3e], 1
  03EDA6  0346: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03EDAA  034A: 8a874731         mov al, byte ptr [bx + 0x3147]
  03EDAE  034E: 250f00           and ax, 0xf
  03EDB1  0351: 8946c8           mov word ptr [bp - 0x38], ax
  03EDB4  0354: ff760a           push word ptr [bp + 0xa]
  03EDB7  0357: ff7608           push word ptr [bp + 8]
  03EDBA  035A: 9abe061f18       lcall 0x181f, 0x6be
  03EDBF  035F: 83c404           add sp, 4
  03EDC2  0362: 8946fe           mov word ptr [bp - 2], ax
  03EDC5  0365: 0bc0             or ax, ax
  03EDC7  0367: 7c0e             jl 0x377
  03EDC9  0369: 8b46c2           mov ax, word ptr [bp - 0x3e]
  03EDCC  036C: 3d0300           cmp ax, 3
  03EDCF  036F: 7e03             jle 0x374
  03EDD1  0371: b80300           mov ax, 3
  03EDD4  0374: 8946c2           mov word ptr [bp - 0x3e], ax
  03EDD7  0377: 8b4608           mov ax, word ptr [bp + 8]
  03EDDA  037A: 8b560a           mov dx, word ptr [bp + 0xa]
  03EDDD  037D: 9ae0071f18       lcall 0x181f, 0x7e0
  03EDE2  0382: 8946fa           mov word ptr [bp - 6], ax
  03EDE5  0385: 0bc0             or ax, ax
  03EDE7  0387: 7c0d             jl 0x396
  03EDE9  0389: 6bd81c           imul bx, ax, 0x1c
  03EDEC  038C: 8a874731         mov al, byte ptr [bx + 0x3147]
  03EDF0  0390: 250f00           and ax, 0xf
  03EDF3  0393: 8946fe           mov word ptr [bp - 2], ax
  03EDF6  0396: 837efe00         cmp word ptr [bp - 2], 0
  03EDFA  039A: 7c10             jl 0x3ac
  03EDFC  039C: 8b46c8           mov ax, word ptr [bp - 0x38]
  03EDFF  039F: 3946fe           cmp word ptr [bp - 2], ax
  03EE02  03A2: 7408             je 0x3ac
  03EE04  03A4: c746e80100       mov word ptr [bp - 0x18], 1
  03EE09  03A9: eb06             jmp 0x3b1
  03EE0B  03AB: 90               nop 
  03EE0C  03AC: c746e80000       mov word ptr [bp - 0x18], 0
  03EE11  03B1: 837ec804         cmp word ptr [bp - 0x38], 4
  03EE15  03B5: 7d2a             jge 0x3e1
  03EE17  03B7: ff760a           push word ptr [bp + 0xa]
  03EE1A  03BA: ff7608           push word ptr [bp + 8]
  03EE1D  03BD: 9af0061f18       lcall 0x181f, 0x6f0
  03EE22  03C2: 83c404           add sp, 4
  03EE25  03C5: 0bc0             or ax, ax
  03EE27  03C7: 7c18             jl 0x3e1
  03EE29  03C9: ff760a           push word ptr [bp + 0xa]
  03EE2C  03CC: ff7608           push word ptr [bp + 8]
  03EE2F  03CF: ff7606           push word ptr [bp + 6]
  03EE32  03D2: 9a6c011f1a       lcall 0x1a1f, 0x16c
  03EE37  03D7: 83c406           add sp, 6
  03EE3A  03DA: 0bc0             or ax, ax
  03EE3C  03DC: 7403             je 0x3e1
  03EE3E  03DE: e9800a           jmp 0xe61
  03EE41  03E1: 837ee800         cmp word ptr [bp - 0x18], 0
  03EE45  03E5: 743d             je 0x424
  03EE47  03E7: 837ec804         cmp word ptr [bp - 0x38], 4
  03EE4B  03EB: 7d37             jge 0x424
  03EE4D  03ED: 837efe04         cmp word ptr [bp - 2], 4
  03EE51  03F1: 7d31             jge 0x424
  03EE53  03F3: ff760a           push word ptr [bp + 0xa]
  03EE56  03F6: ff7608           push word ptr [bp + 8]
  03EE59  03F9: 9abe071f18       lcall 0x181f, 0x7be
  03EE5E  03FE: 83c404           add sp, 4
  03EE61  0401: 0bc0             or ax, ax
  03EE63  0403: 7c1f             jl 0x424
  03EE65  0405: 50               push ax
  03EE66  0406: ff7606           push word ptr [bp + 6]
  03EE69  0409: 9a5e011f1a       lcall 0x1a1f, 0x15e
  03EE6E  040E: 83c404           add sp, 4
  03EE71  0411: 0bc0             or ax, ax
  03EE73  0413: 7403             je 0x418
  03EE75  0415: e9490a           jmp 0xe61
  03EE78  0418: 8b46f0           mov ax, word ptr [bp - 0x10]
  03EE7B  041B: 39069c53         cmp word ptr [0x539c], ax
  03EE7F  041F: 7403             je 0x424
  03EE81  0421: e93d0a           jmp 0xe61
  03EE84  0424: ff7606           push word ptr [bp + 6]
  03EE87  0427: 9a0c091f18       lcall 0x181f, 0x90c
  03EE8C  042C: 83c402           add sp, 2
  03EE8F  042F: 2ae4             sub ah, ah
  03EE91  0431: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03EE95  0435: 8a8f4931         mov cl, byte ptr [bx + 0x3149]
  03EE99  0439: 2aed             sub ch, ch
  03EE9B  043B: 2bc1             sub ax, cx
  03EE9D  043D: 8946dc           mov word ptr [bp - 0x24], ax
  03EEA0  0440: 837ee800         cmp word ptr [bp - 0x18], 0
  03EEA4  0444: 7503             jne 0x449
  03EEA6  0446: e91104           jmp 0x85a
  03EEA9  0449: 3d0300           cmp ax, 3
  03EEAC  044C: 7d1e             jge 0x46c
  03EEAE  044E: 837ec804         cmp word ptr [bp - 0x38], 4
  03EEB2  0452: 7d0a             jge 0x45e
  03EEB4  0454: 6b5ec834         imul bx, word ptr [bp - 0x38], 0x34
  03EEB8  0458: 38af3f54         cmp byte ptr [bx + 0x543f], ch
  03EEBC  045C: 740e             je 0x46c
  03EEBE  045E: ff7606           push word ptr [bp + 6]
  03EEC1  0461: 9a34091f18       lcall 0x181f, 0x934
  03EEC6  0466: 83c402           add sp, 2
  03EEC9  0469: e9f509           jmp 0xe61
  03EECC  046C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03EED0  0470: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03EED4  0474: 8bc3             mov ax, bx
  03EED6  0476: 2aff             sub bh, bh
  03EED8  0478: 8bcb             mov cx, bx
  03EEDA  047A: d1e3             shl bx, 1
  03EEDC  047C: 03d9             add bx, cx
  03EEDE  047E: d1e3             shl bx, 1
  03EEE0  0480: 03d9             add bx, cx
  03EEE2  0482: d1e3             shl bx, 1
  03EEE4  0484: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  03EEE9  0489: 752f             jne 0x4ba
  03EEEB  048B: 3c0d             cmp al, 0xd
  03EEED  048D: 7207             jb 0x496
  03EEEF  048F: 3c12             cmp al, 0x12
  03EEF1  0491: 7703             ja 0x496
  03EEF3  0493: e9cb09           jmp 0xe61
  03EEF6  0496: 837ec804         cmp word ptr [bp - 0x38], 4
  03EEFA  049A: 7c03             jl 0x49f
  03EEFC  049C: e9c209           jmp 0xe61
  03EEFF  049F: 6b5ec834         imul bx, word ptr [bp - 0x38], 0x34
  03EF03  04A3: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03EF08  04A8: 7403             je 0x4ad
  03EF0A  04AA: e9b409           jmp 0xe61
  03EF0D  04AD: 8d1ea013         lea bx, [0x13a0]
  03EF11  04B1: 9afe031f18       lcall 0x181f, 0x3fe
  03EF16  04B6: e9a809           jmp 0xe61
  03EF19  04B9: 90               nop 
  03EF1A  04BA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03EF1E  04BE: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  03EF23  04C3: 7215             jb 0x4da
  03EF25  04C5: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03EF2A  04CA: 770e             ja 0x4da
  03EF2C  04CC: 837ed419         cmp word ptr [bp - 0x2c], 0x19
  03EF30  04D0: 741a             je 0x4ec
  03EF32  04D2: 837ed41a         cmp word ptr [bp - 0x2c], 0x1a
  03EF36  04D6: 7414             je 0x4ec
  03EF38  04D8: eb84             jmp 0x45e
  03EF3A  04DA: 837ed419         cmp word ptr [bp - 0x2c], 0x19
  03EF3E  04DE: 7503             jne 0x4e3
  03EF40  04E0: e97bff           jmp 0x45e
  03EF43  04E3: 837ed41a         cmp word ptr [bp - 0x2c], 0x1a
  03EF47  04E7: 7503             jne 0x4ec
  03EF49  04E9: e972ff           jmp 0x45e
  03EF4C  04EC: f606825301       test byte ptr [0x5382], 1
  03EF51  04F1: 7421             je 0x514
  03EF53  04F3: a1d253           mov ax, word ptr [0x53d2]
  03EF56  04F6: 3946c8           cmp word ptr [bp - 0x38], ax
  03EF59  04F9: 7519             jne 0x514
  03EF5B  04FB: 837efe04         cmp word ptr [bp - 2], 4
  03EF5F  04FF: 7d13             jge 0x514
  03EF61  0501: 7c03             jl 0x506
  03EF63  0503: e95b09           jmp 0xe61
  03EF66  0506: 6b5efe34         imul bx, word ptr [bp - 2], 0x34
  03EF6A  050A: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03EF6F  050F: 7403             je 0x514
  03EF71  0511: e94d09           jmp 0xe61
  03EF74  0514: 837efe04         cmp word ptr [bp - 2], 4
  03EF78  0518: 7d03             jge 0x51d
  03EF7A  051A: e9f700           jmp 0x614
  03EF7D  051D: 8b46fe           mov ax, word ptr [bp - 2]
  03EF80  0520: 2d0400           sub ax, 4
  03EF83  0523: 50               push ax
  03EF84  0524: 9a420a1f18       lcall 0x181f, 0xa42
  03EF89  0529: 83c402           add sp, 2
  03EF8C  052C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03EF90  0530: 8a874731         mov al, byte ptr [bx + 0x3147]
  03EF94  0534: 250f00           and ax, 0xf
  03EF97  0537: 50               push ax
  03EF98  0538: ff36528d         push word ptr [0x8d52]
  03EF9C  053C: 9a0c031f18       lcall 0x181f, 0x30c
  03EFA1  0541: 83c404           add sp, 4
  03EFA4  0544: 3d4b00           cmp ax, 0x4b
  03EFA7  0547: 7d5c             jge 0x5a5
  03EFA9  0549: 837ec804         cmp word ptr [bp - 0x38], 4
  03EFAD  054D: 7d56             jge 0x5a5
  03EFAF  054F: 6b5ec834         imul bx, word ptr [bp - 0x38], 0x34
  03EFB3  0553: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03EFB8  0558: 754b             jne 0x5a5
  03EFBA  055A: ff76fe           push word ptr [bp - 2]
  03EFBD  055D: ff76c8           push word ptr [bp - 0x38]
  03EFC0  0560: 9a380a1f18       lcall 0x181f, 0xa38
  03EFC5  0565: 83c404           add sp, 4
  03EFC8  0568: a804             test al, 4
  03EFCA  056A: 7539             jne 0x5a5
  03EFCC  056C: ff76fe           push word ptr [bp - 2]
  03EFCF  056F: 9a1a0a1f18       lcall 0x181f, 0xa1a
  03EFD4  0574: 83c402           add sp, 2
  03EFD7  0577: 50               push ax
  03EFD8  0578: 6a00             push 0
  03EFDA  057A: 9a38041f18       lcall 0x181f, 0x438
  03EFDF  057F: 83c404           add sp, 4
  03EFE2  0582: 6a01             push 1
  03EFE4  0584: 68ad13           push 0x13ad
  03EFE7  0587: 9a52061f18       lcall 0x181f, 0x652
  03EFEC  058C: 83c404           add sp, 4
  03EFEF  058F: 48               dec ax
  03EFF0  0590: 7403             je 0x595
  03EFF2  0592: e9cc08           jmp 0xe61
  03EFF5  0595: 6a04             push 4
  03EFF7  0597: ff76fe           push word ptr [bp - 2]
  03EFFA  059A: ff76c8           push word ptr [bp - 0x38]
  03EFFD  059D: 9a060a1f18       lcall 0x181f, 0xa06
  03F002  05A2: 83c406           add sp, 6
  03F005  05A5: a0a653           mov al, byte ptr [0x53a6]
  03F008  05A8: 2ae4             sub ah, ah
  03F00A  05AA: 050500           add ax, 5
  03F00D  05AD: 8946cc           mov word ptr [bp - 0x34], ax
  03F010  05B0: ff760a           push word ptr [bp + 0xa]
  03F013  05B3: ff7608           push word ptr [bp + 8]
  03F016  05B6: 9af0091f18       lcall 0x181f, 0x9f0
  03F01B  05BB: 83c404           add sp, 4
  03F01E  05BE: 0bc0             or ax, ax
  03F020  05C0: 7c32             jl 0x5f4
  03F022  05C2: 50               push ax
  03F023  05C3: 9a4c0a1f18       lcall 0x181f, 0xa4c
  03F028  05C8: 83c402           add sp, 2
  03F02B  05CB: d166cc           shl word ptr [bp - 0x34], 1
  03F02E  05CE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F032  05D2: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F036  05D6: 250f00           and ax, 0xf
  03F039  05D9: 8bf0             mov si, ax
  03F03B  05DB: d1e6             shl si, 1
  03F03D  05DD: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  03F041  05E1: 80400b01         add byte ptr [bx + si + 0xb], 1
  03F045  05E5: f6470304         test byte ptr [bx + 3], 4
  03F049  05E9: 7409             je 0x5f4
  03F04B  05EB: b80300           mov ax, 3
  03F04E  05EE: f76ecc           imul word ptr [bp - 0x34]
  03F051  05F1: 8946cc           mov word ptr [bp - 0x34], ax
  03F054  05F4: 6a00             push 0
  03F056  05F6: ff76cc           push word ptr [bp - 0x34]
  03F059  05F9: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F05D  05FD: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F061  0601: 250f00           and ax, 0xf
  03F064  0604: 50               push ax
  03F065  0605: ff36528d         push word ptr [0x8d52]
  03F069  0609: 9a6c0d1f18       lcall 0x181f, 0xd6c
  03F06E  060E: 83c408           add sp, 8
  03F071  0611: e94602           jmp 0x85a
  03F074  0614: 837ec804         cmp word ptr [bp - 0x38], 4
  03F078  0618: 7d0e             jge 0x628
  03F07A  061A: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  03F07E  061E: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  03F083  0623: 7503             jne 0x628
  03F085  0625: e93202           jmp 0x85a
  03F088  0628: 837ec804         cmp word ptr [bp - 0x38], 4
  03F08C  062C: 7d62             jge 0x690
  03F08E  062E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F092  0632: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  03F097  0637: 7557             jne 0x690
  03F099  0639: 6976fe3c01       imul si, word ptr [bp - 2], 0x13c
  03F09E  063E: 8b5ec8           mov bx, word ptr [bp - 0x38]
  03F0A1  0641: 80883c8880       or byte ptr [bx + si - 0x77c4], 0x80
  03F0A6  0646: 6a64             push 0x64
  03F0A8  0648: 6a00             push 0
  03F0AA  064A: 9ad4041f18       lcall 0x181f, 0x4d4
  03F0AF  064F: 83c404           add sp, 4
  03F0B2  0652: 8a0ea653         mov cl, byte ptr [0x53a6]
  03F0B6  0656: 2aed             sub ch, ch
  03F0B8  0658: 41               inc cx
  03F0B9  0659: 3bc1             cmp ax, cx
  03F0BB  065B: 7c03             jl 0x660
  03F0BD  065D: e9fa01           jmp 0x85a
  03F0C0  0660: 8b5ec8           mov bx, word ptr [bp - 0x38]
  03F0C3  0663: d1e3             shl bx, 1
  03F0C5  0665: 8b871c94         mov ax, word ptr [bx - 0x6be4]
  03F0C9  0669: 8b5efe           mov bx, word ptr [bp - 2]
  03F0CC  066C: d1e3             shl bx, 1
  03F0CE  066E: 39871c94         cmp word ptr [bx - 0x6be4], ax
  03F0D2  0672: 720c             jb 0x680
  03F0D4  0674: 8b5ec8           mov bx, word ptr [bp - 0x38]
  03F0D7  0677: 80883c8808       or byte ptr [bx + si - 0x77c4], 8
  03F0DC  067C: e9db01           jmp 0x85a
  03F0DF  067F: 90               nop 
  03F0E0  0680: 6976fe3c01       imul si, word ptr [bp - 2], 0x13c
  03F0E5  0685: 8b5ec8           mov bx, word ptr [bp - 0x38]
  03F0E8  0688: 80883c8802       or byte ptr [bx + si - 0x77c4], 2
  03F0ED  068D: e9ca01           jmp 0x85a
  03F0F0  0690: 837ec804         cmp word ptr [bp - 0x38], 4
  03F0F4  0694: 7c03             jl 0x699
  03F0F6  0696: e9c101           jmp 0x85a
  03F0F9  0699: 7d48             jge 0x6e3
  03F0FB  069B: 6b5ec834         imul bx, word ptr [bp - 0x38], 0x34
  03F0FF  069F: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03F104  06A4: 753d             jne 0x6e3
  03F106  06A6: ff76fe           push word ptr [bp - 2]
  03F109  06A9: ff76c8           push word ptr [bp - 0x38]
  03F10C  06AC: 9a380a1f18       lcall 0x181f, 0xa38
  03F111  06B1: 83c404           add sp, 4
  03F114  06B4: a840             test al, 0x40
  03F116  06B6: 742b             je 0x6e3
  03F118  06B8: ff76fe           push word ptr [bp - 2]
  03F11B  06BB: 9a1a0a1f18       lcall 0x181f, 0xa1a
  03F120  06C0: 83c402           add sp, 2
  03F123  06C3: 50               push ax
  03F124  06C4: 6a00             push 0
  03F126  06C6: 9a38041f18       lcall 0x181f, 0x438
  03F12B  06CB: 83c404           add sp, 4
  03F12E  06CE: 6a01             push 1
  03F130  06D0: 68ba13           push 0x13ba
  03F133  06D3: 9a52061f18       lcall 0x181f, 0x652
  03F138  06D8: 83c404           add sp, 4
  03F13B  06DB: 3d0200           cmp ax, 2
  03F13E  06DE: 7403             je 0x6e3
  03F140  06E0: e97e07           jmp 0xe61
  03F143  06E3: 837ec804         cmp word ptr [bp - 0x38], 4
  03F147  06E7: 7d24             jge 0x70d
  03F149  06E9: ff76fe           push word ptr [bp - 2]
  03F14C  06EC: ff76c8           push word ptr [bp - 0x38]
  03F14F  06EF: 9a380a1f18       lcall 0x181f, 0xa38
  03F154  06F4: 83c404           add sp, 4
  03F157  06F7: a840             test al, 0x40
  03F159  06F9: 7412             je 0x70d
  03F15B  06FB: 6976c83c01       imul si, word ptr [bp - 0x38], 0x13c
  03F160  0700: 8b5efe           mov bx, word ptr [bp - 2]
  03F163  0703: 80b8488800       cmp byte ptr [bx + si - 0x77b8], 0
  03F168  0708: 7403             je 0x70d
  03F16A  070A: e95407           jmp 0xe61
  03F16D  070D: 837efe04         cmp word ptr [bp - 2], 4
  03F171  0711: 7d4c             jge 0x75f
  03F173  0713: 6b5efe34         imul bx, word ptr [bp - 2], 0x34
  03F177  0717: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03F17C  071C: 7541             jne 0x75f
  03F17E  071E: ff76c8           push word ptr [bp - 0x38]
  03F181  0721: ff76fe           push word ptr [bp - 2]
  03F184  0724: 9a380a1f18       lcall 0x181f, 0xa38
  03F189  0729: 83c404           add sp, 4
  03F18C  072C: a840             test al, 0x40
  03F18E  072E: 742f             je 0x75f
  03F190  0730: ff76c8           push word ptr [bp - 0x38]
  03F193  0733: 9a1a0a1f18       lcall 0x181f, 0xa1a
  03F198  0738: 83c402           add sp, 2
  03F19B  073B: 50               push ax
  03F19C  073C: 6a00             push 0
  03F19E  073E: 9a38041f18       lcall 0x181f, 0x438
  03F1A3  0743: 83c404           add sp, 4
  03F1A6  0746: 6a04             push 4
  03F1A8  0748: 9aac041f18       lcall 0x181f, 0x4ac
  03F1AD  074D: 83c402           add sp, 2
  03F1B0  0750: 8d1e7c08         lea bx, [0x87c]
  03F1B4  0754: 8d06c513         lea ax, [0x13c5]
  03F1B8  0758: 2bd2             sub dx, dx
  03F1BA  075A: 9a98091f18       lcall 0x181f, 0x998
  03F1BF  075F: ff76fe           push word ptr [bp - 2]
  03F1C2  0762: ff76c8           push word ptr [bp - 0x38]
  03F1C5  0765: 9a380a1f18       lcall 0x181f, 0xa38
  03F1CA  076A: 83c404           add sp, 4
  03F1CD  076D: a840             test al, 0x40
  03F1CF  076F: 7515             jne 0x786
  03F1D1  0771: ff76c8           push word ptr [bp - 0x38]
  03F1D4  0774: ff76fe           push word ptr [bp - 2]
  03F1D7  0777: 9a380a1f18       lcall 0x181f, 0xa38
  03F1DC  077C: 83c404           add sp, 4
  03F1DF  077F: a840             test al, 0x40
  03F1E1  0781: 7503             jne 0x786
  03F1E3  0783: e9c700           jmp 0x84d
  03F1E6  0786: 837ec804         cmp word ptr [bp - 0x38], 4
  03F1EA  078A: 7d48             jge 0x7d4
  03F1EC  078C: 6b5ec834         imul bx, word ptr [bp - 0x38], 0x34
  03F1F0  0790: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03F1F5  0795: 753d             jne 0x7d4
  03F1F7  0797: ff76fe           push word ptr [bp - 2]
  03F1FA  079A: 9a1a0a1f18       lcall 0x181f, 0xa1a
  03F1FF  079F: 83c402           add sp, 2
  03F202  07A2: 50               push ax
  03F203  07A3: 6a00             push 0
  03F205  07A5: 9a38041f18       lcall 0x181f, 0x438
  03F20A  07AA: 83c404           add sp, 4
  03F20D  07AD: ff76c8           push word ptr [bp - 0x38]
  03F210  07B0: 9a1a0a1f18       lcall 0x181f, 0xa1a
  03F215  07B5: 83c402           add sp, 2
  03F218  07B8: 50               push ax
  03F219  07B9: 6a01             push 1
  03F21B  07BB: 9a38041f18       lcall 0x181f, 0x438
  03F220  07C0: 83c404           add sp, 4
  03F223  07C3: 6a04             push 4
  03F225  07C5: 9aac041f18       lcall 0x181f, 0x4ac
  03F22A  07CA: 83c402           add sp, 2
  03F22D  07CD: 6a01             push 1
  03F22F  07CF: 68cb13           push 0x13cb
  03F232  07D2: eb31             jmp 0x805
  03F234  07D4: ff76c8           push word ptr [bp - 0x38]
  03F237  07D7: 9aa4091f18       lcall 0x181f, 0x9a4
  03F23C  07DC: 83c402           add sp, 2
  03F23F  07DF: 50               push ax
  03F240  07E0: 6a00             push 0
  03F242  07E2: 9a38041f18       lcall 0x181f, 0x438
  03F247  07E7: 83c404           add sp, 4
  03F24A  07EA: ff76fe           push word ptr [bp - 2]
  03F24D  07ED: 9aa4091f18       lcall 0x181f, 0x9a4
  03F252  07F2: 83c402           add sp, 2
  03F255  07F5: 50               push ax
  03F256  07F6: 6a01             push 1
  03F258  07F8: 9a38041f18       lcall 0x181f, 0x438
  03F25D  07FD: 83c404           add sp, 4
  03F260  0800: 6a02             push 2
  03F262  0802: 68d713           push 0x13d7
  03F265  0805: 9a52061f18       lcall 0x181f, 0x652
  03F26A  080A: 83c404           add sp, 4
  03F26D  080D: 837ec804         cmp word ptr [bp - 0x38], 4
  03F271  0811: 7d2a             jge 0x83d
  03F273  0813: 6b5ec834         imul bx, word ptr [bp - 0x38], 0x34
  03F277  0817: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03F27C  081C: 751f             jne 0x83d
  03F27E  081E: ff76c8           push word ptr [bp - 0x38]
  03F281  0821: ff76fe           push word ptr [bp - 2]
  03F284  0824: 9a380a1f18       lcall 0x181f, 0xa38
  03F289  0829: 83c404           add sp, 4
  03F28C  082C: a840             test al, 0x40
  03F28E  082E: 740d             je 0x83d
  03F290  0830: 6976fe3c01       imul si, word ptr [bp - 2], 0x13c
  03F295  0835: 8b5ec8           mov bx, word ptr [bp - 0x38]
  03F298  0838: 80883c8802       or byte ptr [bx + si - 0x77c4], 2
  03F29D  083D: 6a40             push 0x40
  03F29F  083F: ff76fe           push word ptr [bp - 2]
  03F2A2  0842: ff76c8           push word ptr [bp - 0x38]
  03F2A5  0845: 9a100a1f18       lcall 0x181f, 0xa10
  03F2AA  084A: 83c406           add sp, 6
  03F2AD  084D: 6976c83c01       imul si, word ptr [bp - 0x38], 0x13c
  03F2B2  0852: 8b5efe           mov bx, word ptr [bp - 2]
  03F2B5  0855: 80a03c88fe       and byte ptr [bx + si - 0x77c4], 0xfe
  03F2BA  085A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F2BE  085E: 80bf493101       cmp byte ptr [bx + 0x3149], 1
  03F2C3  0863: 1bc0             sbb ax, ax
  03F2C5  0865: f7d8             neg ax
  03F2C7  0867: 8946ca           mov word ptr [bp - 0x36], ax
  03F2CA  086A: 837ee800         cmp word ptr [bp - 0x18], 0
  03F2CE  086E: 755e             jne 0x8ce
  03F2D0  0870: 8a46c2           mov al, byte ptr [bp - 0x3e]
  03F2D3  0873: 00874931         add byte ptr [bx + 0x3149], al
  03F2D7  0877: ff760a           push word ptr [bp + 0xa]
  03F2DA  087A: ff7608           push word ptr [bp + 8]
  03F2DD  087D: 8bf3             mov si, bx
  03F2DF  087F: 9a68071f18       lcall 0x181f, 0x768
  03F2E4  0884: 83c404           add sp, 4
  03F2E7  0887: ff76d8           push word ptr [bp - 0x28]
  03F2EA  088A: ff76e0           push word ptr [bp - 0x20]
  03F2ED  088D: 8bf8             mov di, ax
  03F2EF  088F: 9a68071f18       lcall 0x181f, 0x768
  03F2F4  0894: 83c404           add sp, 4
  03F2F7  0897: 3bc7             cmp ax, di
  03F2F9  0899: 7433             je 0x8ce
  03F2FB  089B: ff76d8           push word ptr [bp - 0x28]
  03F2FE  089E: ff76e0           push word ptr [bp - 0x20]
  03F301  08A1: 9a96061f18       lcall 0x181f, 0x696
  03F306  08A6: 83c404           add sp, 4
  03F309  08A9: 0bc0             or ax, ax
  03F30B  08AB: 7d21             jge 0x8ce
  03F30D  08AD: ff760a           push word ptr [bp + 0xa]
  03F310  08B0: ff7608           push word ptr [bp + 8]
  03F313  08B3: 9a96061f18       lcall 0x181f, 0x696
  03F318  08B8: 83c404           add sp, 4
  03F31B  08BB: 0bc0             or ax, ax
  03F31D  08BD: 7d0f             jge 0x8ce
  03F31F  08BF: ff7606           push word ptr [bp + 6]
  03F322  08C2: 9a0c091f18       lcall 0x181f, 0x90c
  03F327  08C7: 83c402           add sp, 2
  03F32A  08CA: 88844931         mov byte ptr [si + 0x3149], al
  03F32E  08CE: 8b46c2           mov ax, word ptr [bp - 0x3e]
  03F331  08D1: 3946dc           cmp word ptr [bp - 0x24], ax
  03F334  08D4: 7d2d             jge 0x903
  03F336  08D6: 837eca00         cmp word ptr [bp - 0x36], 0
  03F33A  08DA: 7527             jne 0x903
  03F33C  08DC: ff36a683         push word ptr [0x83a6]
  03F340  08E0: 9aca041f18       lcall 0x181f, 0x4ca
  03F345  08E5: 83c402           add sp, 2
  03F348  08E8: 837ee800         cmp word ptr [bp - 0x18], 0
  03F34C  08EC: 7515             jne 0x903
  03F34E  08EE: ff76c2           push word ptr [bp - 0x3e]
  03F351  08F1: 6a01             push 1
  03F353  08F3: 9ad4041f18       lcall 0x181f, 0x4d4
  03F358  08F8: 83c404           add sp, 4
  03F35B  08FB: 3b46dc           cmp ax, word ptr [bp - 0x24]
  03F35E  08FE: 7e03             jle 0x903
  03F360  0900: e95905           jmp 0xe5c
  03F363  0903: 837ec804         cmp word ptr [bp - 0x38], 4
  03F367  0907: 7d41             jge 0x94a
  03F369  0909: ff76c8           push word ptr [bp - 0x38]
  03F36C  090C: ff760a           push word ptr [bp + 0xa]
  03F36F  090F: ff7608           push word ptr [bp + 8]
  03F372  0912: 9adc061f18       lcall 0x181f, 0x6dc
  03F377  0917: 83c404           add sp, 4
  03F37A  091A: 98               cwde 
  03F37B  091B: 8946fe           mov word ptr [bp - 2], ax
  03F37E  091E: 2d0400           sub ax, 4
  03F381  0921: 50               push ax
  03F382  0922: 8bf0             mov si, ax
  03F384  0924: 9a0c031f18       lcall 0x181f, 0x30c
  03F389  0929: 83c404           add sp, 4
  03F38C  092C: 837efe04         cmp word ptr [bp - 2], 4
  03F390  0930: 7c18             jl 0x94a
  03F392  0932: 3d4b00           cmp ax, 0x4b
  03F395  0935: 7d13             jge 0x94a
  03F397  0937: 56               push si
  03F398  0938: 9a420a1f18       lcall 0x181f, 0xa42
  03F39D  093D: 83c402           add sp, 2
  03F3A0  0940: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F3A4  0944: 8a874631         mov al, byte ptr [bx + 0x3146]
  03F3A8  0948: 2ae4             sub ah, ah
  03F3AA  094A: a1a253           mov ax, word ptr [0x53a2]
  03F3AD  094D: 8946e6           mov word ptr [bp - 0x1a], ax
  03F3B0  0950: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F3B4  0954: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F3B8  0958: 240f             and al, 0xf
  03F3BA  095A: 3a069653         cmp al, byte ptr [0x5396]
  03F3BE  095E: 7450             je 0x9b0
  03F3C0  0960: 2ae4             sub ah, ah
  03F3C2  0962: 50               push ax
  03F3C3  0963: ff760a           push word ptr [bp + 0xa]
  03F3C6  0966: ff7608           push word ptr [bp + 8]
  03F3C9  0969: 8bf3             mov si, bx
  03F3CB  096B: 9a26081f18       lcall 0x181f, 0x826
  03F3D0  0970: 83c406           add sp, 6
  03F3D3  0973: 8946e2           mov word ptr [bp - 0x1e], ax
  03F3D6  0976: 50               push ax
  03F3D7  0977: ff7606           push word ptr [bp + 6]
  03F3DA  097A: 9afe071f18       lcall 0x181f, 0x7fe
  03F3DF  097F: 83c404           add sp, 4
  03F3E2  0982: 8a844731         mov al, byte ptr [si + 0x3147]
  03F3E6  0986: 2ae4             sub ah, ah
  03F3E8  0988: 8a0e9653         mov cl, byte ptr [0x5396]
  03F3EC  098C: ba1000           mov dx, 0x10
  03F3EF  098F: d3e2             shl dx, cl
  03F3F1  0991: 85c2             test dx, ax
  03F3F3  0993: 7516             jne 0x9ab
  03F3F5  0995: ff369653         push word ptr [0x5396]
  03F3F9  0999: ff760a           push word ptr [bp + 0xa]
  03F3FC  099C: ff7608           push word ptr [bp + 8]
  03F3FF  099F: 9a70091f18       lcall 0x181f, 0x970
  03F404  09A4: 83c406           add sp, 6
  03F407  09A7: 0bc0             or ax, ax
  03F409  09A9: 7405             je 0x9b0
  03F40B  09AB: c746e60100       mov word ptr [bp - 0x1a], 1
  03F410  09B0: 8b46e6           mov ax, word ptr [bp - 0x1a]
  03F413  09B3: 8946f8           mov word ptr [bp - 8], ax
  03F416  09B6: 837ee800         cmp word ptr [bp - 0x18], 0
  03F41A  09BA: 7522             jne 0x9de
  03F41C  09BC: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F420  09C0: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F424  09C4: 240f             and al, 0xf
  03F426  09C6: 3c04             cmp al, 4
  03F428  09C8: 7208             jb 0x9d2
  03F42A  09CA: f606835380       test byte ptr [0x5383], 0x80
  03F42F  09CF: eb06             jmp 0x9d7
  03F431  09D1: 90               nop 
  03F432  09D2: f606835340       test byte ptr [0x5383], 0x40
  03F437  09D7: 7505             jne 0x9de
  03F439  09D9: c746f80000       mov word ptr [bp - 8], 0
  03F43E  09DE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F442  09E2: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F446  09E6: 240f             and al, 0xf
  03F448  09E8: 3a069653         cmp al, byte ptr [0x5396]
  03F44C  09EC: 7509             jne 0x9f7
  03F44E  09EE: b80100           mov ax, 1
  03F451  09F1: 8946e6           mov word ptr [bp - 0x1a], ax
  03F454  09F4: 8946f8           mov word ptr [bp - 8], ax
  03F457  09F7: 837ee800         cmp word ptr [bp - 0x18], 0
  03F45B  09FB: 7441             je 0xa3e
  03F45D  09FD: 837ec804         cmp word ptr [bp - 0x38], 4
  03F461  0A01: 7d0b             jge 0xa0e
  03F463  0A03: 6b5ec834         imul bx, word ptr [bp - 0x38], 0x34
  03F467  0A07: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03F46C  0A0C: 7411             je 0xa1f
  03F46E  0A0E: 837efe04         cmp word ptr [bp - 2], 4
  03F472  0A12: 7d10             jge 0xa24
  03F474  0A14: 6b5efe34         imul bx, word ptr [bp - 2], 0x34
  03F478  0A18: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03F47D  0A1D: 7505             jne 0xa24
  03F47F  0A1F: c746e60100       mov word ptr [bp - 0x1a], 1
  03F484  0A24: 6a01             push 1
  03F486  0A26: ff76e6           push word ptr [bp - 0x1a]
  03F489  0A29: ff760a           push word ptr [bp + 0xa]
  03F48C  0A2C: ff7608           push word ptr [bp + 8]
  03F48F  0A2F: ff7606           push word ptr [bp + 6]
  03F492  0A32: 9a140a1f19       lcall 0x191f, 0xa14
  03F497  0A37: 83c40a           add sp, 0xa
  03F49A  0A3A: e92404           jmp 0xe61
  03F49D  0A3D: 90               nop 
  03F49E  0A3E: 837ee600         cmp word ptr [bp - 0x1a], 0
  03F4A2  0A42: 740f             je 0xa53
  03F4A4  0A44: ff369653         push word ptr [0x5396]
  03F4A8  0A48: ff7606           push word ptr [bp + 6]
  03F4AB  0A4B: 9ad6071f18       lcall 0x181f, 0x7d6
  03F4B0  0A50: 83c404           add sp, 4
  03F4B3  0A53: ff7606           push word ptr [bp + 6]
  03F4B6  0A56: 9a16091f18       lcall 0x181f, 0x916
  03F4BB  0A5B: 83c402           add sp, 2
  03F4BE  0A5E: 837ef800         cmp word ptr [bp - 8], 0
  03F4C2  0A62: 7436             je 0xa9a
  03F4C4  0A64: c746cec000       mov word ptr [bp - 0x32], 0xc0
  03F4C9  0A69: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F4CD  0A6D: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F4D1  0A71: 240f             and al, 0xf
  03F4D3  0A73: 3a069653         cmp al, byte ptr [0x5396]
  03F4D7  0A77: 7405             je 0xa7e
  03F4D9  0A79: c746cee000       mov word ptr [bp - 0x32], 0xe0
  03F4DE  0A7E: ff760a           push word ptr [bp + 0xa]
  03F4E1  0A81: ff7608           push word ptr [bp + 8]
  03F4E4  0A84: ff76d8           push word ptr [bp - 0x28]
  03F4E7  0A87: ff76e0           push word ptr [bp - 0x20]
  03F4EA  0A8A: 6aff             push -1
  03F4EC  0A8C: ff76ce           push word ptr [bp - 0x32]
  03F4EF  0A8F: ff7606           push word ptr [bp + 6]
  03F4F2  0A92: 9ad0021f18       lcall 0x181f, 0x2d0
  03F4F7  0A97: 83c40e           add sp, 0xe
  03F4FA  0A9A: 8b4606           mov ax, word ptr [bp + 6]
  03F4FD  0A9D: 9ae4081f18       lcall 0x181f, 0x8e4
  03F502  0AA2: 8946e4           mov word ptr [bp - 0x1c], ax
  03F505  0AA5: eb0c             jmp 0xab3
  03F507  0AA7: 90               nop 
  03F508  0AA8: 6bd81c           imul bx, ax, 0x1c
  03F50B  0AAB: c6874c3101       mov byte ptr [bx + 0x314c], 1
  03F510  0AB0: 8b46ec           mov ax, word ptr [bp - 0x14]
  03F513  0AB3: 9ae4021f18       lcall 0x181f, 0x2e4
  03F518  0AB8: 8946ec           mov word ptr [bp - 0x14], ax
  03F51B  0ABB: 0bc0             or ax, ax
  03F51D  0ABD: 7de9             jge 0xaa8
  03F51F  0ABF: 8b4608           mov ax, word ptr [bp + 8]
  03F522  0AC2: 8b560a           mov dx, word ptr [bp + 0xa]
  03F525  0AC5: 9ae0071f18       lcall 0x181f, 0x7e0
  03F52A  0ACA: 9ae4081f18       lcall 0x181f, 0x8e4
  03F52F  0ACF: 8946ee           mov word ptr [bp - 0x12], ax
  03F532  0AD2: 0bc0             or ax, ax
  03F534  0AD4: 7c55             jl 0xb2b
  03F536  0AD6: ff760a           push word ptr [bp + 0xa]
  03F539  0AD9: ff7608           push word ptr [bp + 8]
  03F53C  0ADC: 9a68071f18       lcall 0x181f, 0x768
  03F541  0AE1: 83c404           add sp, 4
  03F544  0AE4: 0bc0             or ax, ax
  03F546  0AE6: 7443             je 0xb2b
  03F548  0AE8: ff76e4           push word ptr [bp - 0x1c]
  03F54B  0AEB: 9a8a081f18       lcall 0x181f, 0x88a
  03F550  0AF0: 83c402           add sp, 2
  03F553  0AF3: 0bc0             or ax, ax
  03F555  0AF5: 7534             jne 0xb2b
  03F557  0AF7: 6b5eee1c         imul bx, word ptr [bp - 0x12], 0x1c
  03F55B  0AFB: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  03F560  0B00: 7505             jne 0xb07
  03F562  0B02: c6874c3100       mov byte ptr [bx + 0x314c], 0
  03F567  0B07: 6a01             push 1
  03F569  0B09: ff76e4           push word ptr [bp - 0x1c]
  03F56C  0B0C: 9af8081f18       lcall 0x181f, 0x8f8
  03F571  0B11: 83c404           add sp, 4
  03F574  0B14: 8b46ee           mov ax, word ptr [bp - 0x12]
  03F577  0B17: 9a66091f18       lcall 0x181f, 0x966
  03F57C  0B1C: 0bc0             or ax, ax
  03F57E  0B1E: 740b             je 0xb2b
  03F580  0B20: ff76ee           push word ptr [bp - 0x12]
  03F583  0B23: 9a6c081f18       lcall 0x181f, 0x86c
  03F588  0B28: 83c402           add sp, 2
  03F58B  0B2B: ff7606           push word ptr [bp + 6]
  03F58E  0B2E: 9a8a081f18       lcall 0x181f, 0x88a
  03F593  0B33: 83c402           add sp, 2
  03F596  0B36: 0bc0             or ax, ax
  03F598  0B38: 750e             jne 0xb48
  03F59A  0B3A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F59E  0B3E: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  03F5A3  0B43: 7403             je 0xb48
  03F5A5  0B45: e92a01           jmp 0xc72
  03F5A8  0B48: ff760a           push word ptr [bp + 0xa]
  03F5AB  0B4B: ff7608           push word ptr [bp + 8]
  03F5AE  0B4E: 9abe071f18       lcall 0x181f, 0x7be
  03F5B3  0B53: 83c404           add sp, 4
  03F5B6  0B56: 8946fc           mov word ptr [bp - 4], ax
  03F5B9  0B59: 0bc0             or ax, ax
  03F5BB  0B5B: 7d03             jge 0xb60
  03F5BD  0B5D: e91201           jmp 0xc72
  03F5C0  0B60: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F5C4  0B64: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  03F5C9  0B69: 751d             jne 0xb88
  03F5CB  0B6B: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F5CF  0B6F: 240f             and al, 0xf
  03F5D1  0B71: 3c04             cmp al, 4
  03F5D3  0B73: 7313             jae 0xb88
  03F5D5  0B75: 2ae4             sub ah, ah
  03F5D7  0B77: 6bd834           imul bx, ax, 0x34
  03F5DA  0B7A: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  03F5DE  0B7E: 7508             jne 0xb88
  03F5E0  0B80: b85200           mov ax, 0x52
  03F5E3  0B83: 9ac0041f18       lcall 0x181f, 0x4c0
  03F5E8  0B88: ff7606           push word ptr [bp + 6]
  03F5EB  0B8B: 9a34091f18       lcall 0x181f, 0x934
  03F5F0  0B90: 83c402           add sp, 2
  03F5F3  0B93: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F5F7  0B97: c6875a3100       mov byte ptr [bx + 0x315a], 0
  03F5FC  0B9C: 8b4606           mov ax, word ptr [bp + 6]
  03F5FF  0B9F: 8946ee           mov word ptr [bp - 0x12], ax
  03F602  0BA2: 9aee021f18       lcall 0x181f, 0x2ee
  03F607  0BA7: eb18             jmp 0xbc1
  03F609  0BA9: 90               nop 
  03F60A  0BAA: 6bd81c           imul bx, ax, 0x1c
  03F60D  0BAD: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  03F612  0BB2: 7505             jne 0xbb9
  03F614  0BB4: c6874c3100       mov byte ptr [bx + 0x314c], 0
  03F619  0BB9: 8b4606           mov ax, word ptr [bp + 6]
  03F61C  0BBC: 9ae4021f18       lcall 0x181f, 0x2e4
  03F621  0BC1: 894606           mov word ptr [bp + 6], ax
  03F624  0BC4: 0bc0             or ax, ax
  03F626  0BC6: 7de2             jge 0xbaa
  03F628  0BC8: 8b46ee           mov ax, word ptr [bp - 0x12]
  03F62B  0BCB: 894606           mov word ptr [bp + 6], ax
  03F62E  0BCE: 6bd81c           imul bx, ax, 0x1c
  03F631  0BD1: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F635  0BD5: 240f             and al, 0xf
  03F637  0BD7: 3a069653         cmp al, byte ptr [0x5396]
  03F63B  0BDB: 7563             jne 0xc40
  03F63D  0BDD: 6a01             push 1
  03F63F  0BDF: 8bf3             mov si, bx
  03F641  0BE1: 9a56001f18       lcall 0x181f, 0x56
  03F646  0BE6: 83c402           add sp, 2
  03F649  0BE9: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  03F64D  0BED: 2aff             sub bh, bh
  03F64F  0BEF: 8bc3             mov ax, bx
  03F651  0BF1: d1e3             shl bx, 1
  03F653  0BF3: 03d8             add bx, ax
  03F655  0BF5: d1e3             shl bx, 1
  03F657  0BF7: 03d8             add bx, ax
  03F659  0BF9: d1e3             shl bx, 1
  03F65B  0BFB: ffb73052         push word ptr [bx + 0x5230]
  03F65F  0BFF: 9a74001f18       lcall 0x181f, 0x74
  03F664  0C04: 83c402           add sp, 2
  03F667  0C07: 80bc46310c       cmp byte ptr [si + 0x3146], 0xc
  03F66C  0C0C: 7506             jne 0xc14
  03F66E  0C0E: ff36ba2e         push word ptr [0x2eba]
  03F672  0C12: eb04             jmp 0xc18
  03F674  0C14: ff36ca2d         push word ptr [0x2dca]
  03F678  0C18: 9a74001f18       lcall 0x181f, 0x74
  03F67D  0C1D: 83c402           add sp, 2
  03F680  0C20: 6946fcca00       imul ax, word ptr [bp - 4], 0xca
  03F685  0C25: 05485d           add ax, 0x5d48
  03F688  0C28: 1e               push ds
  03F689  0C29: 50               push ax
  03F68A  0C2A: 9a6a001f18       lcall 0x181f, 0x6a
  03F68F  0C2F: 83c404           add sp, 4
  03F692  0C32: 6a00             push 0
  03F694  0C34: 6a78             push 0x78
  03F696  0C36: 6a01             push 1
  03F698  0C38: 9a60001f18       lcall 0x181f, 0x60
  03F69D  0C3D: 83c406           add sp, 6
  03F6A0  0C40: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F6A4  0C44: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  03F6A9  0C49: 7227             jb 0xc72
  03F6AB  0C4B: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03F6B0  0C50: 7720             ja 0xc72
  03F6B2  0C52: f606825380       test byte ptr [0x5382], 0x80
  03F6B7  0C57: 7419             je 0xc72
  03F6B9  0C59: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F6BD  0C5D: 240f             and al, 0xf
  03F6BF  0C5F: 3a069853         cmp al, byte ptr [0x5398]
  03F6C3  0C63: 750d             jne 0xc72
  03F6C5  0C65: f606875380       test byte ptr [0x5387], 0x80
  03F6CA  0C6A: 7506             jne 0xc72
  03F6CC  0C6C: 8b46fc           mov ax, word ptr [bp - 4]
  03F6CF  0C6F: 8946f6           mov word ptr [bp - 0xa], ax
  03F6D2  0C72: ff760a           push word ptr [bp + 0xa]
  03F6D5  0C75: ff7608           push word ptr [bp + 8]
  03F6D8  0C78: 9a5e071f18       lcall 0x181f, 0x75e
  03F6DD  0C7D: 83c404           add sp, 4
  03F6E0  0C80: 8946d6           mov word ptr [bp - 0x2a], ax
  03F6E3  0C83: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F6E7  0C87: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F6EB  0C8B: 250f00           and ax, 0xf
  03F6EE  0C8E: 50               push ax
  03F6EF  0C8F: ff760a           push word ptr [bp + 0xa]
  03F6F2  0C92: ff7608           push word ptr [bp + 8]
  03F6F5  0C95: 9a26081f18       lcall 0x181f, 0x826
  03F6FA  0C9A: 83c406           add sp, 6
  03F6FD  0C9D: 8946e2           mov word ptr [bp - 0x1e], ax
  03F700  0CA0: ff760a           push word ptr [bp + 0xa]
  03F703  0CA3: ff7608           push word ptr [bp + 8]
  03F706  0CA6: 9adc061f18       lcall 0x181f, 0x6dc
  03F70B  0CAB: 83c404           add sp, 4
  03F70E  0CAE: 98               cwde 
  03F70F  0CAF: 8946da           mov word ptr [bp - 0x26], ax
  03F712  0CB2: ff7606           push word ptr [bp + 6]
  03F715  0CB5: 9ada081f18       lcall 0x181f, 0x8da
  03F71A  0CBA: 83c402           add sp, 2
  03F71D  0CBD: ff760a           push word ptr [bp + 0xa]
  03F720  0CC0: ff7608           push word ptr [bp + 8]
  03F723  0CC3: ff7606           push word ptr [bp + 6]
  03F726  0CC6: 9a48091f18       lcall 0x181f, 0x948
  03F72B  0CCB: 83c406           add sp, 6
  03F72E  0CCE: 837eda00         cmp word ptr [bp - 0x26], 0
  03F732  0CD2: 7c0e             jl 0xce2
  03F734  0CD4: ff76da           push word ptr [bp - 0x26]
  03F737  0CD7: ff7606           push word ptr [bp + 6]
  03F73A  0CDA: 9ad6071f18       lcall 0x181f, 0x7d6
  03F73F  0CDF: 83c404           add sp, 4
  03F742  0CE2: ff7606           push word ptr [bp + 6]
  03F745  0CE5: 9a4e081f18       lcall 0x181f, 0x84e
  03F74A  0CEA: 83c402           add sp, 2
  03F74D  0CED: ff76e2           push word ptr [bp - 0x1e]
  03F750  0CF0: ff7606           push word ptr [bp + 6]
  03F753  0CF3: 9afe071f18       lcall 0x181f, 0x7fe
  03F758  0CF8: 83c404           add sp, 4
  03F75B  0CFB: ff76d8           push word ptr [bp - 0x28]
  03F75E  0CFE: ff76e0           push word ptr [bp - 0x20]
  03F761  0D01: 9a68071f18       lcall 0x181f, 0x768
  03F766  0D06: 83c404           add sp, 4
  03F769  0D09: 0bc0             or ax, ax
  03F76B  0D0B: 744d             je 0xd5a
  03F76D  0D0D: ff760a           push word ptr [bp + 0xa]
  03F770  0D10: ff7608           push word ptr [bp + 8]
  03F773  0D13: 9a68071f18       lcall 0x181f, 0x768
  03F778  0D18: 83c404           add sp, 4
  03F77B  0D1B: 0bc0             or ax, ax
  03F77D  0D1D: 753b             jne 0xd5a
  03F77F  0D1F: ff760a           push word ptr [bp + 0xa]
  03F782  0D22: ff7608           push word ptr [bp + 8]
  03F785  0D25: 9a96061f18       lcall 0x181f, 0x696
  03F78A  0D2A: 83c404           add sp, 4
  03F78D  0D2D: 0bc0             or ax, ax
  03F78F  0D2F: 7d29             jge 0xd5a
  03F791  0D31: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F795  0D35: 8a874731         mov al, byte ptr [bx + 0x3147]
  03F799  0D39: 25f000           and ax, 0xf0
  03F79C  0D3C: 8946e2           mov word ptr [bp - 0x1e], ax
  03F79F  0D3F: 8b46e0           mov ax, word ptr [bp - 0x20]
  03F7A2  0D42: 8b56d8           mov dx, word ptr [bp - 0x28]
  03F7A5  0D45: 9ae0071f18       lcall 0x181f, 0x7e0
  03F7AA  0D4A: 0bc0             or ax, ax
  03F7AC  0D4C: 7c0c             jl 0xd5a
  03F7AE  0D4E: ff76e2           push word ptr [bp - 0x1e]
  03F7B1  0D51: 50               push ax
  03F7B2  0D52: 9afe071f18       lcall 0x181f, 0x7fe
  03F7B7  0D57: 83c404           add sp, 4
  03F7BA  0D5A: 8b4606           mov ax, word ptr [bp + 6]
  03F7BD  0D5D: 9aa0071f18       lcall 0x181f, 0x7a0
  03F7C2  0D62: 837ee600         cmp word ptr [bp - 0x1a], 0
  03F7C6  0D66: 741c             je 0xd84
  03F7C8  0D68: 6a01             push 1
  03F7CA  0D6A: 6a07             push 7
  03F7CC  0D6C: 6a07             push 7
  03F7CE  0D6E: 8b460a           mov ax, word ptr [bp + 0xa]
  03F7D1  0D71: 2d0300           sub ax, 3
  03F7D4  0D74: 50               push ax
  03F7D5  0D75: 8b4608           mov ax, word ptr [bp + 8]
  03F7D8  0D78: 2d0300           sub ax, 3
  03F7DB  0D7B: 50               push ax
  03F7DC  0D7C: 9aba091f18       lcall 0x181f, 0x9ba
  03F7E1  0D81: 83c40a           add sp, 0xa
  03F7E4  0D84: 837ed600         cmp word ptr [bp - 0x2a], 0
  03F7E8  0D88: 7417             je 0xda1
  03F7EA  0D8A: 837ec804         cmp word ptr [bp - 0x38], 4
  03F7EE  0D8E: 7d11             jge 0xda1
  03F7F0  0D90: ff760a           push word ptr [bp + 0xa]
  03F7F3  0D93: ff7608           push word ptr [bp + 8]
  03F7F6  0D96: ff7606           push word ptr [bp + 6]
  03F7F9  0D99: 9a78011f1a       lcall 0x1a1f, 0x178
  03F7FE  0D9E: 83c406           add sp, 6
  03F801  0DA1: 8b46f0           mov ax, word ptr [bp - 0x10]
  03F804  0DA4: 39069c53         cmp word ptr [0x539c], ax
  03F808  0DA8: 7403             je 0xdad
  03F80A  0DAA: e9b400           jmp 0xe61
  03F80D  0DAD: ff76c8           push word ptr [bp - 0x38]
  03F810  0DB0: ff760a           push word ptr [bp + 0xa]
  03F813  0DB3: ff7608           push word ptr [bp + 8]
  03F816  0DB6: 9a84091f18       lcall 0x181f, 0x984
  03F81B  0DBB: 83c406           add sp, 6
  03F81E  0DBE: 0bc0             or ax, ax
  03F820  0DC0: 7411             je 0xdd3
  03F822  0DC2: ff760a           push word ptr [bp + 0xa]
  03F825  0DC5: ff7608           push word ptr [bp + 8]
  03F828  0DC8: ff7606           push word ptr [bp + 6]
  03F82B  0DCB: 9a92011f1a       lcall 0x1a1f, 0x192
  03F830  0DD0: 83c406           add sp, 6
  03F833  0DD3: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F837  0DD7: 80bf46310a       cmp byte ptr [bx + 0x3146], 0xa
  03F83C  0DDC: 756d             jne 0xe4b
  03F83E  0DDE: 837ec804         cmp word ptr [bp - 0x38], 4
  03F842  0DE2: 7d67             jge 0xe4b
  03F844  0DE4: 6b5ec834         imul bx, word ptr [bp - 0x38], 0x34
  03F848  0DE8: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03F84D  0DED: 755c             jne 0xe4b
  03F84F  0DEF: ff760a           push word ptr [bp + 0xa]
  03F852  0DF2: ff7608           push word ptr [bp + 8]
  03F855  0DF5: 9a96061f18       lcall 0x181f, 0x696
  03F85A  0DFA: 83c404           add sp, 4
  03F85D  0DFD: 0bc0             or ax, ax
  03F85F  0DFF: 7c4a             jl 0xe4b
  03F861  0E01: 6b5ec813         imul bx, word ptr [bp - 0x38], 0x13
  03F865  0E05: 80bf5b9200       cmp byte ptr [bx - 0x6da5], 0
  03F86A  0E0A: 7418             je 0xe24
  03F86C  0E0C: f606825301       test byte ptr [0x5382], 1
  03F871  0E11: 7511             jne 0xe24
  03F873  0E13: 6a0a             push 0xa
  03F875  0E15: ff76c8           push word ptr [bp - 0x38]
  03F878  0E18: 9ab4071f18       lcall 0x181f, 0x7b4
  03F87D  0E1D: 83c404           add sp, 4
  03F880  0E20: 0bc0             or ax, ax
  03F882  0E22: 7427             je 0xe4b
  03F884  0E24: ff760a           push word ptr [bp + 0xa]
  03F887  0E27: ff7608           push word ptr [bp + 8]
  03F88A  0E2A: 9abe071f18       lcall 0x181f, 0x7be
  03F88F  0E2F: 83c404           add sp, 4
  03F892  0E32: 69d8ca00         imul bx, ax, 0xca
  03F896  0E36: f687625d40       test byte ptr [bx + 0x5d62], 0x40
  03F89B  0E3B: 740e             je 0xe4b
  03F89D  0E3D: ff76c8           push word ptr [bp - 0x38]
  03F8A0  0E40: ff7606           push word ptr [bp + 6]
  03F8A3  0E43: 9a86011f1a       lcall 0x1a1f, 0x186
  03F8A8  0E48: 83c404           add sp, 4
  03F8AB  0E4B: 837ef600         cmp word ptr [bp - 0xa], 0
  03F8AF  0E4F: 7e0b             jle 0xe5c
  03F8B1  0E51: ff76f6           push word ptr [bp - 0xa]
  03F8B4  0E54: 9a08061f18       lcall 0x181f, 0x608
  03F8B9  0E59: 83c402           add sp, 2
  03F8BC  0E5C: c746de0100       mov word ptr [bp - 0x22], 1
  03F8C1  0E61: 8b46f0           mov ax, word ptr [bp - 0x10]
  03F8C4  0E64: 39069c53         cmp word ptr [0x539c], ax
  03F8C8  0E68: 753f             jne 0xea9
  03F8CA  0E6A: 837ede00         cmp word ptr [bp - 0x22], 0
  03F8CE  0E6E: 7539             jne 0xea9
  03F8D0  0E70: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F8D4  0E74: c6874c3100       mov byte ptr [bx + 0x314c], 0
  03F8D9  0E79: 837ec804         cmp word ptr [bp - 0x38], 4
  03F8DD  0E7D: 7d0b             jge 0xe8a
  03F8DF  0E7F: 6b5ec834         imul bx, word ptr [bp - 0x38], 0x34
  03F8E3  0E83: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  03F8E8  0E88: 741f             je 0xea9
  03F8EA  0E8A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  03F8EE  0E8E: fe875a31         inc byte ptr [bx + 0x315a]
  03F8F2  0E92: 80bf5a3114       cmp byte ptr [bx + 0x315a], 0x14
  03F8F7  0E97: 7210             jb 0xea9
  03F8F9  0E99: c6875a3100       mov byte ptr [bx + 0x315a], 0
  03F8FE  0E9E: ff7606           push word ptr [bp + 6]
  03F901  0EA1: 9a34091f18       lcall 0x181f, 0x934
  03F906  0EA6: 83c402           add sp, 2
  03F909  0EA9: 5e               pop si
  03F90A  0EAA: 5f               pop di
  03F90B  0EAB: c9               leave 
  03F90C  0EAC: cb               retf 

; ---- func_03F90E  size=398  insns=150  prologue=push bp;mov bp,sp  terminal=RETF ----
  03F90E  0EAE: 55               push bp
  03F90F  0EAF: 8bec             mov bp, sp
  03F911  0EB1: 56               push si
  03F912  0EB2: 8b5e08           mov bx, word ptr [bp + 8]
  03F915  0EB5: 8a87be00         mov al, byte ptr [bx + 0xbe]
  03F919  0EB9: 98               cwde 
  03F91A  0EBA: 6b76061c         imul si, word ptr [bp + 6], 0x1c
  03F91E  0EBE: 8a8c4531         mov cl, byte ptr [si + 0x3145]
  03F922  0EC2: 2aed             sub ch, ch
  03F924  0EC4: 03c1             add ax, cx
  03F926  0EC6: 50               push ax
  03F927  0EC7: 8a87b400         mov al, byte ptr [bx + 0xb4]
  03F92B  0ECB: 98               cwde 
  03F92C  0ECC: 8a8c4431         mov cl, byte ptr [si + 0x3144]
  03F930  0ED0: 03c8             add cx, ax
  03F932  0ED2: 51               push cx
  03F933  0ED3: ff7606           push word ptr [bp + 6]
  03F936  0ED6: 0e               push cs
  03F937  0ED7: e80600           call 0xee0
  03F93A  0EDA: 83c406           add sp, 6
  03F93D  0EDD: 5e               pop si
  03F93E  0EDE: c9               leave 
  03F93F  0EDF: cb               retf 
  03F940  0EE0: ea42011f1a       ljmp 0x1a1f:0x142
  03F945  0EE5: 00c8             add al, cl
  03F947  0EE7: 4e               dec si
  03F948  0EE8: 0000             add byte ptr [bx + si], al
  03F94A  0EEA: 56               push si
  03F94B  0EEB: 2bc0             sub ax, ax
  03F94D  0EED: 8946ba           mov word ptr [bp - 0x46], ax
  03F950  0EF0: 8946b6           mov word ptr [bp - 0x4a], ax
  03F953  0EF3: 39460a           cmp word ptr [bp + 0xa], ax
  03F956  0EF6: 740b             je 0xf03
  03F958  0EF8: ff7606           push word ptr [bp + 6]
  03F95B  0EFB: 9ac6081f18       lcall 0x181f, 0x8c6
  03F960  0F00: 83c402           add sp, 2
  03F963  0F03: 8b4606           mov ax, word ptr [bp + 6]
  03F966  0F06: 9aee021f18       lcall 0x181f, 0x2ee
  03F96B  0F0B: eb4a             jmp 0xf57
  03F96D  0F0D: 90               nop 
  03F96E  0F0E: 6bd81c           imul bx, ax, 0x1c
  03F971  0F11: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  03F976  0F16: 7237             jb 0xf4f
  03F978  0F18: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03F97D  0F1D: 7730             ja 0xf4f
  03F97F  0F1F: 8bc3             mov ax, bx
  03F981  0F21: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03F985  0F25: 8bf0             mov si, ax
  03F987  0F27: 8a845031         mov al, byte ptr [si + 0x3150]
  03F98B  0F2B: 2ae4             sub ah, ah
  03F98D  0F2D: 2aff             sub bh, bh
  03F98F  0F2F: 8bcb             mov cx, bx
  03F991  0F31: d1e3             shl bx, 1
  03F993  0F33: 03d9             add bx, cx
  03F995  0F35: d1e3             shl bx, 1
  03F997  0F37: 03d9             add bx, cx
  03F999  0F39: d1e3             shl bx, 1
  03F99B  0F3B: 8a8f3752         mov cl, byte ptr [bx + 0x5237]
  03F99F  0F3F: 2aed             sub ch, ch
  03F9A1  0F41: 2bc8             sub cx, ax
  03F9A3  0F43: 894eb2           mov word ptr [bp - 0x4e], cx
  03F9A6  0F46: 8b76b6           mov si, word ptr [bp - 0x4a]
  03F9A9  0F49: 884abc           mov byte ptr [bp + si - 0x44], cl
  03F9AC  0F4C: ff46b6           inc word ptr [bp - 0x4a]
  03F9AF  0F4F: 8b46b4           mov ax, word ptr [bp - 0x4c]
  03F9B2  0F52: 9ae4021f18       lcall 0x181f, 0x2e4
  03F9B7  0F57: 8946b4           mov word ptr [bp - 0x4c], ax
  03F9BA  0F5A: 0bc0             or ax, ax
  03F9BC  0F5C: 7db0             jge 0xf0e
  03F9BE  0F5E: 8b4606           mov ax, word ptr [bp + 6]
  03F9C1  0F61: 9aee021f18       lcall 0x181f, 0x2ee
  03F9C6  0F66: eb35             jmp 0xf9d
  03F9C8  0F68: 8b46b6           mov ax, word ptr [bp - 0x4a]
  03F9CB  0F6B: 3946fc           cmp word ptr [bp - 4], ax
  03F9CE  0F6E: 7d1c             jge 0xf8c
  03F9D0  0F70: 8a46b8           mov al, byte ptr [bp - 0x48]
  03F9D3  0F73: 8b76fc           mov si, word ptr [bp - 4]
  03F9D6  0F76: 3842bc           cmp byte ptr [bp + si - 0x44], al
  03F9D9  0F79: 7208             jb 0xf83
  03F9DB  0F7B: 2842bc           sub byte ptr [bp + si - 0x44], al
  03F9DE  0F7E: c746fe0000       mov word ptr [bp - 2], 0
  03F9E3  0F83: ff46fc           inc word ptr [bp - 4]
  03F9E6  0F86: 837efe00         cmp word ptr [bp - 2], 0
  03F9EA  0F8A: 75dc             jne 0xf68
  03F9EC  0F8C: 837efe00         cmp word ptr [bp - 2], 0
  03F9F0  0F90: 7403             je 0xf95
  03F9F2  0F92: e9a100           jmp 0x1036
  03F9F5  0F95: 8b46b4           mov ax, word ptr [bp - 0x4c]
  03F9F8  0F98: 9ae4021f18       lcall 0x181f, 0x2e4
  03F9FD  0F9D: 8946b4           mov word ptr [bp - 0x4c], ax
  03FA00  0FA0: 0bc0             or ax, ax
  03FA02  0FA2: 7c40             jl 0xfe4
  03FA04  0FA4: 6bd81c           imul bx, ax, 0x1c
  03FA07  0FA7: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  03FA0C  0FAC: 7207             jb 0xfb5
  03FA0E  0FAE: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03FA13  0FB3: 76e0             jbe 0xf95
  03FA15  0FB5: 6bd81c           imul bx, ax, 0x1c
  03FA18  0FB8: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03FA1C  0FBC: 2aff             sub bh, bh
  03FA1E  0FBE: 8bc3             mov ax, bx
  03FA20  0FC0: d1e3             shl bx, 1
  03FA22  0FC2: 03d8             add bx, ax
  03FA24  0FC4: d1e3             shl bx, 1
  03FA26  0FC6: 03d8             add bx, ax
  03FA28  0FC8: d1e3             shl bx, 1
  03FA2A  0FCA: 8a873852         mov al, byte ptr [bx + 0x5238]
  03FA2E  0FCE: 2ae4             sub ah, ah
  03FA30  0FD0: 8946b8           mov word ptr [bp - 0x48], ax
  03FA33  0FD3: 3d6300           cmp ax, 0x63
  03FA36  0FD6: 7dbd             jge 0xf95
  03FA38  0FD8: c746fe0100       mov word ptr [bp - 2], 1
  03FA3D  0FDD: c746fc0000       mov word ptr [bp - 4], 0
  03FA42  0FE2: eba2             jmp 0xf86
  03FA44  0FE4: 837eb600         cmp word ptr [bp - 0x4a], 0
  03FA48  0FE8: 744c             je 0x1036
  03FA4A  0FEA: 837e0a00         cmp word ptr [bp + 0xa], 0
  03FA4E  0FEE: 741a             je 0x100a
  03FA50  0FF0: 8a4608           mov al, byte ptr [bp + 8]
  03FA53  0FF3: 8b76b6           mov si, word ptr [bp - 0x4a]
  03FA56  0FF6: 3842bb           cmp byte ptr [bp + si - 0x45], al
  03FA59  0FF9: 723b             jb 0x1036
  03FA5B  0FFB: 8a42bb           mov al, byte ptr [bp + si - 0x45]
  03FA5E  0FFE: 2ae4             sub ah, ah
  03FA60  1000: 8946ba           mov word ptr [bp - 0x46], ax
  03FA63  1003: 8b46ba           mov ax, word ptr [bp - 0x46]
  03FA66  1006: 5e               pop si
  03FA67  1007: c9               leave 
  03FA68  1008: cb               retf 
  03FA69  1009: 90               nop 
  03FA6A  100A: c746fc0000       mov word ptr [bp - 4], 0
  03FA6F  100F: eb1f             jmp 0x1030
  03FA71  1011: 90               nop 
  03FA72  1012: 8b46b6           mov ax, word ptr [bp - 0x4a]
  03FA75  1015: 3946fc           cmp word ptr [bp - 4], ax
  03FA78  1018: 7d1c             jge 0x1036
  03FA7A  101A: 8a4608           mov al, byte ptr [bp + 8]
  03FA7D  101D: 8b76fc           mov si, word ptr [bp - 4]
  03FA80  1020: 3842bc           cmp byte ptr [bp + si - 0x44], al
  03FA83  1023: 7208             jb 0x102d
  03FA85  1025: 8a42bc           mov al, byte ptr [bp + si - 0x44]
  03FA88  1028: 2ae4             sub ah, ah
  03FA8A  102A: 8946ba           mov word ptr [bp - 0x46], ax
  03FA8D  102D: ff46fc           inc word ptr [bp - 4]
  03FA90  1030: 837eba00         cmp word ptr [bp - 0x46], 0
  03FA94  1034: 74dc             je 0x1012
  03FA96  1036: 8b46ba           mov ax, word ptr [bp - 0x46]
  03FA99  1039: 5e               pop si
  03FA9A  103A: c9               leave 
  03FA9B  103B: cb               retf 

; ---- func_03FA9C  size=834  insns=280  prologue=ENTER 0x001C,0  terminal=RETF ----
  03FA9C  103C: c81c0000         enter 0x1c, 0
  03FAA0  1040: 53               push bx
  03FAA1  1041: 52               push dx
  03FAA2  1042: 50               push ax
  03FAA3  1043: 56               push si
  03FAA4  1044: 2bc0             sub ax, ax
  03FAA6  1046: 8946f6           mov word ptr [bp - 0xa], ax
  03FAA9  1049: a34e9e           mov word ptr [0x9e4e], ax
  03FAAC  104C: 83fb01           cmp bx, 1
  03FAAF  104F: 7d03             jge 0x1054
  03FAB1  1051: e92403           jmp 0x1378
  03FAB4  1054: a13c85           mov ax, word ptr [0x853c]
  03FAB7  1057: 48               dec ax
  03FAB8  1058: 3bc3             cmp ax, bx
  03FABA  105A: 7f03             jg 0x105f
  03FABC  105C: e91903           jmp 0x1378
  03FABF  105F: a13a85           mov ax, word ptr [0x853a]
  03FAC2  1062: 48               dec ax
  03FAC3  1063: 3bc2             cmp ax, dx
  03FAC5  1065: 7e05             jle 0x106c
  03FAC7  1067: 83fa01           cmp dx, 1
  03FACA  106A: 7d24             jge 0x1090
  03FACC  106C: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FAD0  1070: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  03FAD5  1075: 7303             jae 0x107a
  03FAD7  1077: e9fe02           jmp 0x1378
  03FADA  107A: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03FADF  107F: 7603             jbe 0x1084
  03FAE1  1081: e9f402           jmp 0x1378
  03FAE4  1084: c7064e9e0400     mov word ptr [0x9e4e], 4
  03FAEA  108A: 8b46f6           mov ax, word ptr [bp - 0xa]
  03FAED  108D: 5e               pop si
  03FAEE  108E: c9               leave 
  03FAEF  108F: cb               retf 
  03FAF0  1090: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FAF4  1094: 8a874431         mov al, byte ptr [bx + 0x3144]
  03FAF8  1098: 2ae4             sub ah, ah
  03FAFA  109A: 8946ea           mov word ptr [bp - 0x16], ax
  03FAFD  109D: 8a874531         mov al, byte ptr [bx + 0x3145]
  03FB01  10A1: 8946e6           mov word ptr [bp - 0x1a], ax
  03FB04  10A4: ff76e2           push word ptr [bp - 0x1e]
  03FB07  10A7: 52               push dx
  03FB08  10A8: 8bf3             mov si, bx
  03FB0A  10AA: 9abe061f18       lcall 0x181f, 0x6be
  03FB0F  10AF: 83c404           add sp, 4
  03FB12  10B2: 8946ec           mov word ptr [bp - 0x14], ax
  03FB15  10B5: ff76e2           push word ptr [bp - 0x1e]
  03FB18  10B8: ff76e0           push word ptr [bp - 0x20]
  03FB1B  10BB: 9ad2061f18       lcall 0x181f, 0x6d2
  03FB20  10C0: 83c404           add sp, 4
  03FB23  10C3: 8946f2           mov word ptr [bp - 0xe], ax
  03FB26  10C6: ff76de           push word ptr [bp - 0x22]
  03FB29  10C9: 9a16091f18       lcall 0x181f, 0x916
  03FB2E  10CE: 83c402           add sp, 2
  03FB31  10D1: ff76e2           push word ptr [bp - 0x1e]
  03FB34  10D4: ff76e0           push word ptr [bp - 0x20]
  03FB37  10D7: 9a2c071f18       lcall 0x181f, 0x72c
  03FB3C  10DC: 83c404           add sp, 4
  03FB3F  10DF: 2ae4             sub ah, ah
  03FB41  10E1: 8946fa           mov word ptr [bp - 6], ax
  03FB44  10E4: 8a46fa           mov al, byte ptr [bp - 6]
  03FB47  10E7: 241f             and al, 0x1f
  03FB49  10E9: 8946e8           mov word ptr [bp - 0x18], ax
  03FB4C  10EC: ff76e6           push word ptr [bp - 0x1a]
  03FB4F  10EF: ff76ea           push word ptr [bp - 0x16]
  03FB52  10F2: 9a2c071f18       lcall 0x181f, 0x72c
  03FB57  10F7: 83c404           add sp, 4
  03FB5A  10FA: 241f             and al, 0x1f
  03FB5C  10FC: 2ae4             sub ah, ah
  03FB5E  10FE: 8946f8           mov word ptr [bp - 8], ax
  03FB61  1101: 837ee819         cmp word ptr [bp - 0x18], 0x19
  03FB65  1105: 7406             je 0x110d
  03FB67  1107: 837ee81a         cmp word ptr [bp - 0x18], 0x1a
  03FB6B  110B: 756d             jne 0x117a
  03FB6D  110D: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FB71  1111: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  03FB76  1116: 7207             jb 0x111f
  03FB78  1118: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03FB7D  111D: 765b             jbe 0x117a
  03FB7F  111F: 8b46e0           mov ax, word ptr [bp - 0x20]
  03FB82  1122: 8b56e2           mov dx, word ptr [bp - 0x1e]
  03FB85  1125: 9ae0071f18       lcall 0x181f, 0x7e0
  03FB8A  112A: 8946fc           mov word ptr [bp - 4], ax
  03FB8D  112D: 0bc0             or ax, ax
  03FB8F  112F: 7d03             jge 0x1134
  03FB91  1131: e93302           jmp 0x1367
  03FB94  1134: 6bd81c           imul bx, ax, 0x1c
  03FB97  1137: 8a874731         mov al, byte ptr [bx + 0x3147]
  03FB9B  113B: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FB9F  113F: 32874731         xor al, byte ptr [bx + 0x3147]
  03FBA3  1143: a80f             test al, 0xf
  03FBA5  1145: 7403             je 0x114a
  03FBA7  1147: e91d02           jmp 0x1367
  03FBAA  114A: 6a00             push 0
  03FBAC  114C: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FBB0  1150: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03FBB4  1154: 2aff             sub bh, bh
  03FBB6  1156: 8bc3             mov ax, bx
  03FBB8  1158: d1e3             shl bx, 1
  03FBBA  115A: 03d8             add bx, ax
  03FBBC  115C: d1e3             shl bx, 1
  03FBBE  115E: 03d8             add bx, ax
  03FBC0  1160: d1e3             shl bx, 1
  03FBC2  1162: 8a873852         mov al, byte ptr [bx + 0x5238]
  03FBC6  1166: 2ae4             sub ah, ah
  03FBC8  1168: 50               push ax
  03FBC9  1169: ff76fc           push word ptr [bp - 4]
  03FBCC  116C: 0e               push cs
  03FBCD  116D: e82804           call 0x1598
  03FBD0  1170: 83c406           add sp, 6
  03FBD3  1173: 0bc0             or ax, ax
  03FBD5  1175: 7503             jne 0x117a
  03FBD7  1177: e9ed01           jmp 0x1367
  03FBDA  117A: 837ee819         cmp word ptr [bp - 0x18], 0x19
  03FBDE  117E: 743c             je 0x11bc
  03FBE0  1180: 837ee81a         cmp word ptr [bp - 0x18], 0x1a
  03FBE4  1184: 7436             je 0x11bc
  03FBE6  1186: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FBEA  118A: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  03FBEF  118F: 7303             jae 0x1194
  03FBF1  1191: e93401           jmp 0x12c8
  03FBF4  1194: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03FBF9  1199: 7603             jbe 0x119e
  03FBFB  119B: e92a01           jmp 0x12c8
  03FBFE  119E: 8a874731         mov al, byte ptr [bx + 0x3147]
  03FC02  11A2: 250f00           and ax, 0xf
  03FC05  11A5: 3b46ec           cmp ax, word ptr [bp - 0x14]
  03FC08  11A8: 7412             je 0x11bc
  03FC0A  11AA: 837eec04         cmp word ptr [bp - 0x14], 4
  03FC0E  11AE: 7d0c             jge 0x11bc
  03FC10  11B0: 837eec00         cmp word ptr [bp - 0x14], 0
  03FC14  11B4: 7c4c             jl 0x1202
  03FC16  11B6: 837eec04         cmp word ptr [bp - 0x14], 4
  03FC1A  11BA: 7d46             jge 0x1202
  03FC1C  11BC: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FC20  11C0: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  03FC25  11C5: 7303             jae 0x11ca
  03FC27  11C7: e99801           jmp 0x1362
  03FC2A  11CA: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03FC2F  11CF: 7603             jbe 0x11d4
  03FC31  11D1: e98e01           jmp 0x1362
  03FC34  11D4: 837ee819         cmp word ptr [bp - 0x18], 0x19
  03FC38  11D8: 7409             je 0x11e3
  03FC3A  11DA: 837ee81a         cmp word ptr [bp - 0x18], 0x1a
  03FC3E  11DE: 7403             je 0x11e3
  03FC40  11E0: e95101           jmp 0x1334
  03FC43  11E3: ff76e2           push word ptr [bp - 0x1e]
  03FC46  11E6: ff76e0           push word ptr [bp - 0x20]
  03FC49  11E9: 9ab4061f18       lcall 0x181f, 0x6b4
  03FC4E  11EE: 83c404           add sp, 4
  03FC51  11F1: fec8             dec al
  03FC53  11F3: 7503             jne 0x11f8
  03FC55  11F5: e90401           jmp 0x12fc
  03FC58  11F8: c7064e9e0800     mov word ptr [0x9e4e], 8
  03FC5E  11FE: e96601           jmp 0x1367
  03FC61  1201: 90               nop 
  03FC62  1202: 837ef200         cmp word ptr [bp - 0xe], 0
  03FC66  1206: 7c13             jl 0x121b
  03FC68  1208: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FC6C  120C: 8a874731         mov al, byte ptr [bx + 0x3147]
  03FC70  1210: 250f00           and ax, 0xf
  03FC73  1213: 3b46f2           cmp ax, word ptr [bp - 0xe]
  03FC76  1216: 7403             je 0x121b
  03FC78  1218: e94c01           jmp 0x1367
  03FC7B  121B: 837ef819         cmp word ptr [bp - 8], 0x19
  03FC7F  121F: 741b             je 0x123c
  03FC81  1221: 837ef81a         cmp word ptr [bp - 8], 0x1a
  03FC85  1225: 7415             je 0x123c
  03FC87  1227: ff76e6           push word ptr [bp - 0x1a]
  03FC8A  122A: ff76ea           push word ptr [bp - 0x16]
  03FC8D  122D: 9a96061f18       lcall 0x181f, 0x696
  03FC92  1232: 83c404           add sp, 4
  03FC95  1235: 0bc0             or ax, ax
  03FC97  1237: 7d03             jge 0x123c
  03FC99  1239: e92b01           jmp 0x1367
  03FC9C  123C: c746f0ffff       mov word ptr [bp - 0x10], 0xffff
  03FCA1  1241: 8b46de           mov ax, word ptr [bp - 0x22]
  03FCA4  1244: 8946ee           mov word ptr [bp - 0x12], ax
  03FCA7  1247: 9aee021f18       lcall 0x181f, 0x2ee
  03FCAC  124C: eb43             jmp 0x1291
  03FCAE  124E: 0bc0             or ax, ax
  03FCB0  1250: 7c48             jl 0x129a
  03FCB2  1252: 6bd81c           imul bx, ax, 0x1c
  03FCB5  1255: 8bc3             mov ax, bx
  03FCB7  1257: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03FCBB  125B: 2aff             sub bh, bh
  03FCBD  125D: 8bcb             mov cx, bx
  03FCBF  125F: d1e3             shl bx, 1
  03FCC1  1261: 03d9             add bx, cx
  03FCC3  1263: d1e3             shl bx, 1
  03FCC5  1265: 03d9             add bx, cx
  03FCC7  1267: d1e3             shl bx, 1
  03FCC9  1269: 80bf385263       cmp byte ptr [bx + 0x5238], 0x63
  03FCCE  126E: 7319             jae 0x1289
  03FCD0  1270: ff76de           push word ptr [bp - 0x22]
  03FCD3  1273: 8bf0             mov si, ax
  03FCD5  1275: 9a0c091f18       lcall 0x181f, 0x90c
  03FCDA  127A: 83c402           add sp, 2
  03FCDD  127D: 38844931         cmp byte ptr [si + 0x3149], al
  03FCE1  1281: 7306             jae 0x1289
  03FCE3  1283: 8b46de           mov ax, word ptr [bp - 0x22]
  03FCE6  1286: 8946f0           mov word ptr [bp - 0x10], ax
  03FCE9  1289: 8b46de           mov ax, word ptr [bp - 0x22]
  03FCEC  128C: 9ae4021f18       lcall 0x181f, 0x2e4
  03FCF1  1291: 8946de           mov word ptr [bp - 0x22], ax
  03FCF4  1294: 837ef000         cmp word ptr [bp - 0x10], 0
  03FCF8  1298: 7cb4             jl 0x124e
  03FCFA  129A: 8b46ee           mov ax, word ptr [bp - 0x12]
  03FCFD  129D: 8946de           mov word ptr [bp - 0x22], ax
  03FD00  12A0: 837ef000         cmp word ptr [bp - 0x10], 0
  03FD04  12A4: 7d03             jge 0x12a9
  03FD06  12A6: e9be00           jmp 0x1367
  03FD09  12A9: 8b46f0           mov ax, word ptr [bp - 0x10]
  03FD0C  12AC: a3509e           mov word ptr [0x9e50], ax
  03FD0F  12AF: f646fa40         test byte ptr [bp - 6], 0x40
  03FD13  12B3: 7409             je 0x12be
  03FD15  12B5: c7064e9e0300     mov word ptr [0x9e4e], 3
  03FD1B  12BB: e9a900           jmp 0x1367
  03FD1E  12BE: c7064e9e0200     mov word ptr [0x9e4e], 2
  03FD24  12C4: e9a000           jmp 0x1367
  03FD27  12C7: 90               nop 
  03FD28  12C8: 837ef819         cmp word ptr [bp - 8], 0x19
  03FD2C  12CC: 7409             je 0x12d7
  03FD2E  12CE: 837ef81a         cmp word ptr [bp - 8], 0x1a
  03FD32  12D2: 7403             je 0x12d7
  03FD34  12D4: e9e5fe           jmp 0x11bc
  03FD37  12D7: 837ef200         cmp word ptr [bp - 0xe], 0
  03FD3B  12DB: 7d03             jge 0x12e0
  03FD3D  12DD: e9dcfe           jmp 0x11bc
  03FD40  12E0: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FD44  12E4: 8a874731         mov al, byte ptr [bx + 0x3147]
  03FD48  12E8: 250f00           and ax, 0xf
  03FD4B  12EB: 3b46f2           cmp ax, word ptr [bp - 0xe]
  03FD4E  12EE: 7503             jne 0x12f3
  03FD50  12F0: e9c9fe           jmp 0x11bc
  03FD53  12F3: c7064e9e0900     mov word ptr [0x9e4e], 9
  03FD59  12F9: eb6c             jmp 0x1367
  03FD5B  12FB: 90               nop 
  03FD5C  12FC: ff76e2           push word ptr [bp - 0x1e]
  03FD5F  12FF: ff76e0           push word ptr [bp - 0x20]
  03FD62  1302: 9a82061f18       lcall 0x181f, 0x682
  03FD67  1307: 83c404           add sp, 4
  03FD6A  130A: 0bc0             or ax, ax
  03FD6C  130C: 7c26             jl 0x1334
  03FD6E  130E: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FD72  1312: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  03FD76  1316: 83e10f           and cx, 0xf
  03FD79  1319: 3bc8             cmp cx, ax
  03FD7B  131B: 7417             je 0x1334
  03FD7D  131D: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  03FD82  1322: 7207             jb 0x132b
  03FD84  1324: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03FD89  1329: 7609             jbe 0x1334
  03FD8B  132B: c7064e9e0700     mov word ptr [0x9e4e], 7
  03FD91  1331: eb34             jmp 0x1367
  03FD93  1333: 90               nop 
  03FD94  1334: 837ee81a         cmp word ptr [bp - 0x18], 0x1a
  03FD98  1338: 7528             jne 0x1362
  03FD9A  133A: 837ef81a         cmp word ptr [bp - 8], 0x1a
  03FD9E  133E: 7522             jne 0x1362
  03FDA0  1340: 8b46e0           mov ax, word ptr [bp - 0x20]
  03FDA3  1343: 3946ea           cmp word ptr [bp - 0x16], ax
  03FDA6  1346: 7d1a             jge 0x1362
  03FDA8  1348: 6b5ede1c         imul bx, word ptr [bp - 0x22], 0x1c
  03FDAC  134C: 80bf4c3103       cmp byte ptr [bx + 0x314c], 3
  03FDB1  1351: 740f             je 0x1362
  03FDB3  1353: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  03FDB8  1358: 7408             je 0x1362
  03FDBA  135A: c7064e9e0500     mov word ptr [0x9e4e], 5
  03FDC0  1360: eb05             jmp 0x1367
  03FDC2  1362: c746f60100       mov word ptr [bp - 0xa], 1
  03FDC7  1367: ff76e6           push word ptr [bp - 0x1a]
  03FDCA  136A: ff76ea           push word ptr [bp - 0x16]
  03FDCD  136D: ff76de           push word ptr [bp - 0x22]
  03FDD0  1370: 9a48091f18       lcall 0x181f, 0x948
  03FDD5  1375: 83c406           add sp, 6
  03FDD8  1378: 8b46f6           mov ax, word ptr [bp - 0xa]
  03FDDB  137B: 5e               pop si
  03FDDC  137C: c9               leave 
  03FDDD  137D: cb               retf 

; ---- func_03FDDE  size=366  insns=135  prologue=ENTER 0x0010,0  terminal=page-end ----
  03FDDE  137E: c8100000         enter 0x10, 0
  03FDE2  1382: c746fe0100       mov word ptr [bp - 2], 1
  03FDE7  1387: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  03FDEC  138C: 8a874431         mov al, byte ptr [bx + 0x3144]
  03FDF0  1390: 2ae4             sub ah, ah
  03FDF2  1392: 034606           add ax, word ptr [bp + 6]
  03FDF5  1395: 8946f6           mov word ptr [bp - 0xa], ax
  03FDF8  1398: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  03FDFC  139C: 2aed             sub ch, ch
  03FDFE  139E: 034e08           add cx, word ptr [bp + 8]
  03FE01  13A1: 894ef2           mov word ptr [bp - 0xe], cx
  03FE04  13A4: 8bd0             mov dx, ax
  03FE06  13A6: 8bd9             mov bx, cx
  03FE08  13A8: a19253           mov ax, word ptr [0x5392]
  03FE0B  13AB: 0e               push cs
  03FE0C  13AC: e8ee01           call 0x159d
  03FE0F  13AF: 0bc0             or ax, ax
  03FE11  13B1: 7403             je 0x13b6
  03FE13  13B3: e94601           jmp 0x14fc
  03FE16  13B6: a14e9e           mov ax, word ptr [0x9e4e]
  03FE19  13B9: e91c01           jmp 0x14d8
  03FE1C  13BC: 8d1e7c08         lea bx, [0x87c]
  03FE20  13C0: 8d06e213         lea ax, [0x13e2]
  03FE24  13C4: 2bd2             sub dx, dx
  03FE26  13C6: 9a98091f18       lcall 0x181f, 0x998
  03FE2B  13CB: 8b46fe           mov ax, word ptr [bp - 2]
  03FE2E  13CE: c9               leave 
  03FE2F  13CF: cb               retf 
  03FE30  13D0: 833e4e9e02       cmp word ptr [0x9e4e], 2
  03FE35  13D5: 7507             jne 0x13de
  03FE37  13D7: 6a03             push 3
  03FE39  13D9: 68ea13           push 0x13ea
  03FE3C  13DC: eb05             jmp 0x13e3
  03FE3E  13DE: 6a03             push 3
  03FE40  13E0: 68f313           push 0x13f3
  03FE43  13E3: 9a52061f18       lcall 0x181f, 0x652
  03FE48  13E8: 83c404           add sp, 4
  03FE4B  13EB: 8946f4           mov word ptr [bp - 0xc], ax
  03FE4E  13EE: 3d0200           cmp ax, 2
  03FE51  13F1: 7403             je 0x13f6
  03FE53  13F3: e99c01           jmp 0x1592
  03FE56  13F6: ff36509e         push word ptr [0x9e50]
  03FE5A  13FA: 9a6c081f18       lcall 0x181f, 0x86c
  03FE5F  13FF: 83c402           add sp, 2
  03FE62  1402: a19253           mov ax, word ptr [0x5392]
  03FE65  1405: 9aee021f18       lcall 0x181f, 0x2ee
  03FE6A  140A: eb08             jmp 0x1414
  03FE6C  140C: 8b46fc           mov ax, word ptr [bp - 4]
  03FE6F  140F: 9ae4021f18       lcall 0x181f, 0x2e4
  03FE74  1414: 8946fc           mov word ptr [bp - 4], ax
  03FE77  1417: 0bc0             or ax, ax
  03FE79  1419: 7d03             jge 0x141e
  03FE7B  141B: e9de00           jmp 0x14fc
  03FE7E  141E: 6bd81c           imul bx, ax, 0x1c
  03FE81  1421: 8bc3             mov ax, bx
  03FE83  1423: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03FE87  1427: 2aff             sub bh, bh
  03FE89  1429: 8bcb             mov cx, bx
  03FE8B  142B: d1e3             shl bx, 1
  03FE8D  142D: 03d9             add bx, cx
  03FE8F  142F: d1e3             shl bx, 1
  03FE91  1431: 03d9             add bx, cx
  03FE93  1433: d1e3             shl bx, 1
  03FE95  1435: 80bf385263       cmp byte ptr [bx + 0x5238], 0x63
  03FE9A  143A: 73d0             jae 0x140c
  03FE9C  143C: 8bd8             mov bx, ax
  03FE9E  143E: c6874c3100       mov byte ptr [bx + 0x314c], 0
  03FEA3  1443: ebc7             jmp 0x140c
  03FEA5  1445: 90               nop 
  03FEA6  1446: f606825301       test byte ptr [0x5382], 1
  03FEAB  144B: 7411             je 0x145e
  03FEAD  144D: 8d1efd13         lea bx, [0x13fd]
  03FEB1  1451: 9afe031f18       lcall 0x181f, 0x3fe
  03FEB6  1456: c746f40200       mov word ptr [bp - 0xc], 2
  03FEBB  145B: eb11             jmp 0x146e
  03FEBD  145D: 90               nop 
  03FEBE  145E: 6a00             push 0
  03FEC0  1460: 680c14           push 0x140c
  03FEC3  1463: 9a52061f18       lcall 0x181f, 0x652
  03FEC8  1468: 83c404           add sp, 4
  03FECB  146B: 8946f4           mov word ptr [bp - 0xc], ax
  03FECE  146E: 837ef401         cmp word ptr [bp - 0xc], 1
  03FED2  1472: 7516             jne 0x148a
  03FED4  1474: 9a08021f19       lcall 0x191f, 0x208
  03FED9  1479: ff369253         push word ptr [0x5392]
  03FEDD  147D: 9af40d1f18       lcall 0x181f, 0xdf4
  03FEE2  1482: 83c402           add sp, 2
  03FEE5  1485: 8b46fe           mov ax, word ptr [bp - 2]
  03FEE8  1488: c9               leave 
  03FEE9  1489: cb               retf 
  03FEEA  148A: 833e4e9e04       cmp word ptr [0x9e4e], 4
  03FEEF  148F: 7503             jne 0x1494
  03FEF1  1491: e9fe00           jmp 0x1592
  03FEF4  1494: eb66             jmp 0x14fc
  03FEF6  1496: 6a01             push 1
  03FEF8  1498: 6a05             push 5
  03FEFA  149A: 6a05             push 5
  03FEFC  149C: 8b46f2           mov ax, word ptr [bp - 0xe]
  03FEFF  149F: 48               dec ax
  03FF00  14A0: 48               dec ax
  03FF01  14A1: 50               push ax
  03FF02  14A2: 8b46f6           mov ax, word ptr [bp - 0xa]
  03FF05  14A5: 48               dec ax
  03FF06  14A6: 48               dec ax
  03FF07  14A7: 50               push ax
  03FF08  14A8: 9aba091f18       lcall 0x181f, 0x9ba
  03FF0D  14AD: 83c40a           add sp, 0xa
  03FF10  14B0: 8b46fe           mov ax, word ptr [bp - 2]
  03FF13  14B3: c9               leave 
  03FF14  14B4: cb               retf 
  03FF15  14B5: 90               nop 
  03FF16  14B6: 6a00             push 0
  03FF18  14B8: 681514           push 0x1415
  03FF1B  14BB: 9a52061f18       lcall 0x181f, 0x652
  03FF20  14C0: 83c404           add sp, 4
  03FF23  14C3: 8b46fe           mov ax, word ptr [bp - 2]
  03FF26  14C6: c9               leave 
  03FF27  14C7: cb               retf 
  03FF28  14C8: 6a00             push 0
  03FF2A  14CA: 682014           push 0x1420
  03FF2D  14CD: ebec             jmp 0x14bb
  03FF2F  14CF: 90               nop 
  03FF30  14D0: 6a00             push 0
  03FF32  14D2: 682914           push 0x1429
  03FF35  14D5: ebe4             jmp 0x14bb
  03FF37  14D7: 90               nop 
  03FF38  14D8: 48               dec ax
  03FF39  14D9: 3d0800           cmp ax, 8
  03FF3C  14DC: 7603             jbe 0x14e1
  03FF3E  14DE: e9b100           jmp 0x1592
  03FF41  14E1: d1e0             shl ax, 1
  03FF43  14E3: 93               xchg bx, ax
  03FF44  14E4: 2effa70a06       jmp word ptr cs:[bx + 0x60a]
  03FF49  14E9: 90               nop 
  03FF4A  14EA: dc04             fadd qword ptr [si]

; ---- func_03FF4C  size=419  insns=0  prologue=UNRECOGNISED (0xF0)  terminal=page-end ----
