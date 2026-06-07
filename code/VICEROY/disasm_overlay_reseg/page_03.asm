; ============================================================
; VICEROY.EXE overlay page 0x03 (record 2) -- RE-SEGMENTED
; file_offset (disk image) = 0x02CB00
; code_offset (first insn) = 0x02CFD0
; code_end (next reloc hdr)= 0x02FAF0  [resident size 690 para -> nominal_end 0x02F620; on-disk code spills past it]
; reloc_count = 296  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x02CB00)
; functions in page = 15
; ============================================================

; ---- func_02CFD0  size=274  insns=91  prologue=ENTER 0x0008,0  terminal=RETF ----
  02CFD0  04D0: c8080000         enter 8, 0
  02CFD4  04D4: c746f80000       mov word ptr [bp - 8], 0
  02CFD9  04D9: 2bc0             sub ax, ax
  02CFDB  04DB: 8946fc           mov word ptr [bp - 4], ax
  02CFDE  04DE: 8946fa           mov word ptr [bp - 6], ax
  02CFE1  04E1: 803e97a800       cmp byte ptr [0xa897], 0
  02CFE6  04E6: 7503             jne 0x4eb
  02CFE8  04E8: e9d900           jmp 0x5c4
  02CFEB  04EB: 39069008         cmp word ptr [0x890], ax
  02CFEF  04EF: 752c             jne 0x51d
  02CFF1  04F1: 39460c           cmp word ptr [bp + 0xc], ax
  02CFF4  04F4: 7511             jne 0x507
  02CFF6  04F6: 8b1e4285         mov bx, word ptr [0x8542]
  02CFFA  04FA: 8a07             mov al, byte ptr [bx]
  02CFFC  04FC: 2ae4             sub ah, ah
  02CFFE  04FE: 89460c           mov word ptr [bp + 0xc], ax
  02D001  0501: 8a4701           mov al, byte ptr [bx + 1]
  02D004  0504: 89460e           mov word ptr [bp + 0xe], ax
  02D007  0507: 6a00             push 0
  02D009  0509: ff760e           push word ptr [bp + 0xe]
  02D00C  050C: ff760c           push word ptr [bp + 0xc]
  02D00F  050F: ff760e           push word ptr [bp + 0xe]
  02D012  0512: ff760c           push word ptr [bp + 0xc]
  02D015  0515: 9a52031f18       lcall 0x181f, 0x352
  02D01A  051A: 83c40a           add sp, 0xa
  02D01D  051D: a14285           mov ax, word ptr [0x8542]
  02D020  0520: 40               inc ax
  02D021  0521: 40               inc ax
  02D022  0522: 1e               push ds
  02D023  0523: 50               push ax
  02D024  0524: 6a00             push 0
  02D026  0526: 9a16041f18       lcall 0x181f, 0x416
  02D02B  052B: 83c406           add sp, 6
  02D02E  052E: 8b4610           mov ax, word ptr [bp + 0x10]
  02D031  0531: a35e1f           mov word ptr [0x1f5e], ax
  02D034  0534: 8d1e7c08         lea bx, [0x87c]
  02D038  0538: 8b4606           mov ax, word ptr [bp + 6]
  02D03B  053B: 2bd2             sub dx, dx
  02D03D  053D: 9a82011f19       lcall 0x191f, 0x182
  02D042  0542: 8946fa           mov word ptr [bp - 6], ax
  02D045  0545: 8956fc           mov word ptr [bp - 4], dx
  02D048  0548: 0bd0             or dx, ax
  02D04A  054A: 7478             je 0x5c4
  02D04C  054C: 837e0800         cmp word ptr [bp + 8], 0
  02D050  0550: 7443             je 0x595
  02D052  0552: 833e900800       cmp word ptr [0x890], 0
  02D057  0557: 753c             jne 0x595
  02D059  0559: 6a01             push 1
  02D05B  055B: ff36fe2d         push word ptr [0x2dfe]
  02D05F  055F: 9a22001f18       lcall 0x181f, 0x22
  02D064  0564: 83c402           add sp, 2
  02D067  0567: 52               push dx
  02D068  0568: 50               push ax
  02D069  0569: ff76fc           push word ptr [bp - 4]
  02D06C  056C: ff76fa           push word ptr [bp - 6]
  02D06F  056F: 9a76011f19       lcall 0x191f, 0x176
  02D074  0574: 83c40a           add sp, 0xa
  02D077  0577: 6a02             push 2
  02D079  0579: ff36002e         push word ptr [0x2e00]
  02D07D  057D: 9a22001f18       lcall 0x181f, 0x22
  02D082  0582: 83c402           add sp, 2
  02D085  0585: 52               push dx
  02D086  0586: 50               push ax
  02D087  0587: ff76fc           push word ptr [bp - 4]
  02D08A  058A: ff76fa           push word ptr [bp - 6]
  02D08D  058D: 9a76011f19       lcall 0x191f, 0x176
  02D092  0592: 83c40a           add sp, 0xa
  02D095  0595: 837e1200         cmp word ptr [bp + 0x12], 0
  02D099  0599: 7e08             jle 0x5a3
  02D09B  059B: 8b4612           mov ax, word ptr [bp + 0x12]
  02D09E  059E: 9ac0041f18       lcall 0x181f, 0x4c0
  02D0A3  05A3: ff76fc           push word ptr [bp - 4]
  02D0A6  05A6: ff76fa           push word ptr [bp - 6]
  02D0A9  05A9: 9a6a011f19       lcall 0x191f, 0x16a
  02D0AE  05AE: 3d0200           cmp ax, 2
  02D0B1  05B1: 7511             jne 0x5c4
  02D0B3  05B3: c746f80100       mov word ptr [bp - 8], 1
  02D0B8  05B8: 837e0a00         cmp word ptr [bp + 0xa], 0
  02D0BC  05BC: 7c06             jl 0x5c4
  02D0BE  05BE: 8a460a           mov al, byte ptr [bp + 0xa]
  02D0C1  05C1: a23703           mov byte ptr [0x337], al
  02D0C4  05C4: c7065e1fffff     mov word ptr [0x1f5e], 0xffff
  02D0CA  05CA: 8b46fc           mov ax, word ptr [bp - 4]
  02D0CD  05CD: 0b46fa           or ax, word ptr [bp - 6]
  02D0D0  05D0: 740b             je 0x5dd
  02D0D2  05D2: ff76fc           push word ptr [bp - 4]
  02D0D5  05D5: ff76fa           push word ptr [bp - 6]
  02D0D8  05D8: 9aa8011f19       lcall 0x191f, 0x1a8
  02D0DD  05DD: 8a46f8           mov al, byte ptr [bp - 8]
  02D0E0  05E0: c9               leave 
  02D0E1  05E1: cb               retf 

; ---- func_02D0E4  size=549  insns=200  prologue=ENTER 0x000A,0  terminal=RETF ----
  02D0E4  05E4: c80a0000         enter 0xa, 0
  02D0E8  05E8: 56               push si
  02D0E9  05E9: 8d46f8           lea ax, [bp - 8]
  02D0EC  05EC: 50               push ax
  02D0ED  05ED: 8b1e4285         mov bx, word ptr [0x8542]
  02D0F1  05F1: 8a879400         mov al, byte ptr [bx + 0x94]
  02D0F5  05F5: 98               cwde 
  02D0F6  05F6: 50               push ax
  02D0F7  05F7: 9ac20c1f18       lcall 0x181f, 0xcc2
  02D0FC  05FC: 83c404           add sp, 4
  02D0FF  05FF: 8946fe           mov word ptr [bp - 2], ax
  02D102  0602: 0bc0             or ax, ax
  02D104  0604: 7503             jne 0x609
  02D106  0606: e9fd01           jmp 0x806
  02D109  0609: 3d0100           cmp ax, 1
  02D10C  060C: 7403             je 0x611
  02D10E  060E: e99900           jmp 0x6aa
  02D111  0611: ff76f8           push word ptr [bp - 8]
  02D114  0614: 9afc091f18       lcall 0x181f, 0x9fc
  02D119  0619: 83c402           add sp, 2
  02D11C  061C: 0bc0             or ax, ax
  02D11E  061E: 7403             je 0x623
  02D120  0620: e9e301           jmp 0x806
  02D123  0623: 837ef810         cmp word ptr [bp - 8], 0x10
  02D127  0627: 752d             jne 0x656
  02D129  0629: 8b1e4285         mov bx, word ptr [0x8542]
  02D12D  062D: 80bf950002       cmp byte ptr [bx + 0x95], 2
  02D132  0632: 7222             jb 0x656
  02D134  0634: 50               push ax
  02D135  0635: 6a05             push 5
  02D137  0637: 50               push ax
  02D138  0638: 50               push ax
  02D139  0639: 6a02             push 2
  02D13B  063B: 803e98a801       cmp byte ptr [0xa898], 1
  02D140  0640: 1bc0             sbb ax, ax
  02D142  0642: f7d8             neg ax
  02D144  0644: 50               push ax
  02D145  0645: 68520d           push 0xd52
  02D148  0648: 0e               push cs
  02D149  0649: e8131e           call 0x245f
  02D14C  064C: 83c40e           add sp, 0xe
  02D14F  064F: 080698a8         or byte ptr [0xa898], al
  02D153  0653: 5e               pop si
  02D154  0654: c9               leave 
  02D155  0655: cb               retf 
  02D156  0656: 837ef80f         cmp word ptr [bp - 8], 0xf
  02D15A  065A: 7406             je 0x662
  02D15C  065C: 837ef810         cmp word ptr [bp - 8], 0x10
  02D160  0660: 7516             jne 0x678
  02D162  0662: 8b1e4285         mov bx, word ptr [0x8542]
  02D166  0666: fe879500         inc byte ptr [bx + 0x95]
  02D16A  066A: 837ef810         cmp word ptr [bp - 8], 0x10
  02D16E  066E: 7525             jne 0x695
  02D170  0670: 804f1c80         or byte ptr [bx + 0x1c], 0x80
  02D174  0674: e9f100           jmp 0x768
  02D177  0677: 90               nop 
  02D178  0678: 837ef81e         cmp word ptr [bp - 8], 0x1e
  02D17C  067C: 7406             je 0x684
  02D17E  067E: 837ef81f         cmp word ptr [bp - 8], 0x1f
  02D182  0682: 7511             jne 0x695
  02D184  0684: 8b1e4285         mov bx, word ptr [0x8542]
  02D188  0688: fe879600         inc byte ptr [bx + 0x96]
  02D18C  068C: 837ef81f         cmp word ptr [bp - 8], 0x1f
  02D190  0690: 7503             jne 0x695
  02D192  0692: e9d300           jmp 0x768
  02D195  0695: 6a01             push 1
  02D197  0697: ff76f8           push word ptr [bp - 8]
  02D19A  069A: 9abe0b1f18       lcall 0x181f, 0xbbe
  02D19F  069F: 83c404           add sp, 4
  02D1A2  06A2: 8b1e4285         mov bx, word ptr [0x8542]
  02D1A6  06A6: 804f1c80         or byte ptr [bx + 0x1c], 0x80
  02D1AA  06AA: 837efe02         cmp word ptr [bp - 2], 2
  02D1AE  06AE: 7403             je 0x6b3
  02D1B0  06B0: e9b500           jmp 0x768
  02D1B3  06B3: 837ef80c         cmp word ptr [bp - 8], 0xc
  02D1B7  06B7: 7553             jne 0x70c
  02D1B9  06B9: 8b1e4285         mov bx, word ptr [0x8542]
  02D1BD  06BD: 8a5f1a           mov bl, byte ptr [bx + 0x1a]
  02D1C0  06C0: 2aff             sub bh, bh
  02D1C2  06C2: 8a879892         mov al, byte ptr [bx - 0x6d68]
  02D1C6  06C6: 6bdb13           imul bx, bx, 0x13
  02D1C9  06C9: 38875892         cmp byte ptr [bx - 0x6da8], al
  02D1CD  06CD: 723d             jb 0x70c
  02D1CF  06CF: 2ae4             sub ah, ah
  02D1D1  06D1: 6a00             push 0
  02D1D3  06D3: 50               push ax
  02D1D4  06D4: 6a00             push 0
  02D1D6  06D6: 9aae091f18       lcall 0x181f, 0x9ae
  02D1DB  06DB: 83c406           add sp, 6
  02D1DE  06DE: 6a00             push 0
  02D1E0  06E0: 6a05             push 5
  02D1E2  06E2: 6a00             push 0
  02D1E4  06E4: 6a00             push 0
  02D1E6  06E6: 6a02             push 2
  02D1E8  06E8: 803e98a801       cmp byte ptr [0xa898], 1
  02D1ED  06ED: 1bc0             sbb ax, ax
  02D1EF  06EF: f7d8             neg ax
  02D1F1  06F1: 50               push ax
  02D1F2  06F2: 68620d           push 0xd62
  02D1F5  06F5: 0e               push cs
  02D1F6  06F6: e8661d           call 0x245f
  02D1F9  06F9: 83c40e           add sp, 0xe
  02D1FC  06FC: 080698a8         or byte ptr [0xa898], al
  02D200  0700: 8b1e4285         mov bx, word ptr [0x8542]
  02D204  0704: 804f1c80         or byte ptr [bx + 0x1c], 0x80
  02D208  0708: 5e               pop si
  02D209  0709: c9               leave 
  02D20A  070A: cb               retf 
  02D20B  070B: 90               nop 
  02D20C  070C: 8b1e4285         mov bx, word ptr [0x8542]
  02D210  0710: 8a4701           mov al, byte ptr [bx + 1]
  02D213  0713: 2ae4             sub ah, ah
  02D215  0715: 50               push ax
  02D216  0716: 8a07             mov al, byte ptr [bx]
  02D218  0718: 50               push ax
  02D219  0719: 8a471a           mov al, byte ptr [bx + 0x1a]
  02D21C  071C: 50               push ax
  02D21D  071D: 8b46f8           mov ax, word ptr [bp - 8]
  02D220  0720: 8946f6           mov word ptr [bp - 0xa], ax
  02D223  0723: 50               push ax
  02D224  0724: 9a5c091f18       lcall 0x181f, 0x95c
  02D229  0729: 83c408           add sp, 8
  02D22C  072C: 8946fc           mov word ptr [bp - 4], ax
  02D22F  072F: 8b1e4285         mov bx, word ptr [0x8542]
  02D233  0733: 8a471a           mov al, byte ptr [bx + 0x1a]
  02D236  0736: 8bc8             mov cx, ax
  02D238  0738: 2ae4             sub ah, ah
  02D23A  073A: 6bf013           imul si, ax, 0x13
  02D23D  073D: 8b5ef6           mov bx, word ptr [bp - 0xa]
  02D240  0740: fe804c92         inc byte ptr [bx + si - 0x6db4]
  02D244  0744: 83fb0b           cmp bx, 0xb
  02D247  0747: 751f             jne 0x768
  02D249  0749: 80f904           cmp cl, 4
  02D24C  074C: 7309             jae 0x757
  02D24E  074E: 6bd834           imul bx, ax, 0x34
  02D251  0751: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  02D255  0755: 7411             je 0x768
  02D257  0757: 8b1e4285         mov bx, word ptr [0x8542]
  02D25B  075B: 8a471a           mov al, byte ptr [bx + 0x1a]
  02D25E  075E: 2ae4             sub ah, ah
  02D260  0760: 69d83c01         imul bx, ax, 0x13c
  02D264  0764: fe875088         inc byte ptr [bx - 0x77b0]
  02D268  0768: 8b1e4285         mov bx, word ptr [0x8542]
  02D26C  076C: c78792000000     mov word ptr [bx + 0x92], 0
  02D272  0772: 8a879400         mov al, byte ptr [bx + 0x94]
  02D276  0776: 98               cwde 
  02D277  0777: 50               push ax
  02D278  0778: 9a4e0d1f18       lcall 0x181f, 0xd4e
  02D27D  077D: 83c402           add sp, 2
  02D280  0780: 52               push dx
  02D281  0781: 50               push ax
  02D282  0782: 6a01             push 1
  02D284  0784: 9a16041f18       lcall 0x181f, 0x416
  02D289  0789: 83c406           add sp, 6
  02D28C  078C: 803e97a800       cmp byte ptr [0xa897], 0
  02D291  0791: 742d             je 0x7c0
  02D293  0793: 837efe01         cmp word ptr [bp - 2], 1
  02D297  0797: 751d             jne 0x7b6
  02D299  0799: 837ef813         cmp word ptr [bp - 8], 0x13
  02D29D  079D: 7412             je 0x7b1
  02D29F  079F: 837ef814         cmp word ptr [bp - 8], 0x14
  02D2A3  07A3: 740c             je 0x7b1
  02D2A5  07A5: 837ef803         cmp word ptr [bp - 8], 3
  02D2A9  07A9: 7406             je 0x7b1
  02D2AB  07AB: 837ef804         cmp word ptr [bp - 8], 4
  02D2AF  07AF: 7505             jne 0x7b6
  02D2B1  07B1: 6a03             push 3
  02D2B3  07B3: eb03             jmp 0x7b8
  02D2B5  07B5: 90               nop 
  02D2B6  07B6: 6a02             push 2
  02D2B8  07B8: 9ab6041f18       lcall 0x181f, 0x4b6
  02D2BD  07BD: 83c402           add sp, 2
  02D2C0  07C0: 6a00             push 0
  02D2C2  07C2: 6a05             push 5
  02D2C4  07C4: 6a00             push 0
  02D2C6  07C6: 6a00             push 0
  02D2C8  07C8: 6a02             push 2
  02D2CA  07CA: 803e98a801       cmp byte ptr [0xa898], 1
  02D2CF  07CF: 1bc0             sbb ax, ax
  02D2D1  07D1: f7d8             neg ax
  02D2D3  07D3: 50               push ax
  02D2D4  07D4: 686f0d           push 0xd6f
  02D2D7  07D7: 0e               push cs
  02D2D8  07D8: e8841c           call 0x245f
  02D2DB  07DB: 83c40e           add sp, 0xe
  02D2DE  07DE: 080698a8         or byte ptr [0xa898], al
  02D2E2  07E2: 837efe01         cmp word ptr [bp - 2], 1
  02D2E6  07E6: 7512             jne 0x7fa
  02D2E8  07E8: 837ef810         cmp word ptr [bp - 8], 0x10
  02D2EC  07EC: 740c             je 0x7fa
  02D2EE  07EE: 837ef81f         cmp word ptr [bp - 8], 0x1f
  02D2F2  07F2: 7406             je 0x7fa
  02D2F4  07F4: 8b46f8           mov ax, word ptr [bp - 8]
  02D2F7  07F7: a34a03           mov word ptr [0x34a], ax
  02D2FA  07FA: 833e460300       cmp word ptr [0x346], 0
  02D2FF  07FF: 7405             je 0x806
  02D301  0801: 9ae8051f19       lcall 0x191f, 0x5e8
  02D306  0806: 5e               pop si
  02D307  0807: c9               leave 
  02D308  0808: cb               retf 

; ---- func_02D30A  size=188  insns=71  prologue=ENTER 0x000E,0  terminal=RETF ----
  02D30A  080A: c80e0000         enter 0xe, 0
  02D30E  080E: c746f60000       mov word ptr [bp - 0xa], 0
  02D313  0813: e99f00           jmp 0x8b5
  02D316  0816: ff46f8           inc word ptr [bp - 8]
  02D319  0819: 837ef805         cmp word ptr [bp - 8], 5
  02D31D  081D: 7e03             jle 0x822
  02D31F  081F: e99000           jmp 0x8b2
  02D322  0822: ff76f6           push word ptr [bp - 0xa]
  02D325  0825: ff76f8           push word ptr [bp - 8]
  02D328  0828: 9ae00c1f18       lcall 0x181f, 0xce0
  02D32D  082D: 83c404           add sp, 4
  02D330  0830: 98               cwde 
  02D331  0831: 0bc0             or ax, ax
  02D333  0833: 7ce1             jl 0x816
  02D335  0835: 50               push ax
  02D336  0836: 9a0e0c1f18       lcall 0x181f, 0xc0e
  02D33B  083B: 83c402           add sp, 2
  02D33E  083E: 3d0700           cmp ax, 7
  02D341  0841: 7405             je 0x848
  02D343  0843: 3d0600           cmp ax, 6
  02D346  0846: 75ce             jne 0x816
  02D348  0848: 8b1e4285         mov bx, word ptr [0x8542]
  02D34C  084C: 8a4701           mov al, byte ptr [bx + 1]
  02D34F  084F: 2ae4             sub ah, ah
  02D351  0851: 0346f6           add ax, word ptr [bp - 0xa]
  02D354  0854: 48               dec ax
  02D355  0855: 48               dec ax
  02D356  0856: 8946fc           mov word ptr [bp - 4], ax
  02D359  0859: 50               push ax
  02D35A  085A: 8a07             mov al, byte ptr [bx]
  02D35C  085C: 2ae4             sub ah, ah
  02D35E  085E: 0346f8           add ax, word ptr [bp - 8]
  02D361  0861: 48               dec ax
  02D362  0862: 48               dec ax
  02D363  0863: 8946fe           mov word ptr [bp - 2], ax
  02D366  0866: 50               push ax
  02D367  0867: 9a18071f18       lcall 0x181f, 0x718
  02D36C  086C: 83c404           add sp, 4
  02D36F  086F: 3d0c00           cmp ax, 0xc
  02D372  0872: 7405             je 0x879
  02D374  0874: 3d0600           cmp ax, 6
  02D377  0877: 759d             jne 0x816
  02D379  0879: 6a01             push 1
  02D37B  087B: 6a04             push 4
  02D37D  087D: ff76fc           push word ptr [bp - 4]
  02D380  0880: ff76fe           push word ptr [bp - 2]
  02D383  0883: 9a8c061f18       lcall 0x181f, 0x68c
  02D388  0888: 83c408           add sp, 8
  02D38B  088B: 6a00             push 0
  02D38D  088D: 6a03             push 3
  02D38F  088F: ff76fc           push word ptr [bp - 4]
  02D392  0892: ff76fe           push word ptr [bp - 2]
  02D395  0895: 6aff             push -1
  02D397  0897: 803e98a801       cmp byte ptr [0xa898], 1
  02D39C  089C: 1bc0             sbb ax, ax
  02D39E  089E: f7d8             neg ax
  02D3A0  08A0: 50               push ax
  02D3A1  08A1: 68750d           push 0xd75
  02D3A4  08A4: 0e               push cs
  02D3A5  08A5: e8b71b           call 0x245f
  02D3A8  08A8: 83c40e           add sp, 0xe
  02D3AB  08AB: 080698a8         or byte ptr [0xa898], al
  02D3AF  08AF: e964ff           jmp 0x816
  02D3B2  08B2: ff46f6           inc word ptr [bp - 0xa]
  02D3B5  08B5: 837ef605         cmp word ptr [bp - 0xa], 5
  02D3B9  08B9: 7d09             jge 0x8c4
  02D3BB  08BB: c746f80000       mov word ptr [bp - 8], 0
  02D3C0  08C0: e956ff           jmp 0x819
  02D3C3  08C3: 90               nop 
  02D3C4  08C4: c9               leave 
  02D3C5  08C5: cb               retf 

; ---- func_02D3C6  size=575  insns=197  prologue=ENTER 0x001A,0  terminal=RETF ----
  02D3C6  08C6: c81a0000         enter 0x1a, 0
  02D3CA  08CA: 56               push si
  02D3CB  08CB: c746f60000       mov word ptr [bp - 0xa], 0
  02D3D0  08D0: b80100           mov ax, 1
  02D3D3  08D3: 8946f0           mov word ptr [bp - 0x10], ax
  02D3D6  08D6: 50               push ax
  02D3D7  08D7: 9afc091f18       lcall 0x181f, 0x9fc
  02D3DC  08DC: 83c402           add sp, 2
  02D3DF  08DF: 0bc0             or ax, ax
  02D3E1  08E1: 740b             je 0x8ee
  02D3E3  08E3: c746f60100       mov word ptr [bp - 0xa], 1
  02D3E8  08E8: a18e8f           mov ax, word ptr [0x8f8e]
  02D3EB  08EB: 8946ea           mov word ptr [bp - 0x16], ax
  02D3EE  08EE: 6a02             push 2
  02D3F0  08F0: 9afc091f18       lcall 0x181f, 0x9fc
  02D3F5  08F5: 83c402           add sp, 2
  02D3F8  08F8: 0bc0             or ax, ax
  02D3FA  08FA: 7409             je 0x905
  02D3FC  08FC: ff46f6           inc word ptr [bp - 0xa]
  02D3FF  08FF: a19a8f           mov ax, word ptr [0x8f9a]
  02D402  0902: 8946ea           mov word ptr [bp - 0x16], ax
  02D405  0905: 8b1e4285         mov bx, word ptr [0x8542]
  02D409  0909: 8a4701           mov al, byte ptr [bx + 1]
  02D40C  090C: 2ae4             sub ah, ah
  02D40E  090E: 8946ec           mov word ptr [bp - 0x14], ax
  02D411  0911: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  02D414  0914: 2aed             sub ch, ch
  02D416  0916: 894ee6           mov word ptr [bp - 0x1a], cx
  02D419  0919: 8bd0             mov dx, ax
  02D41B  091B: 8a07             mov al, byte ptr [bx]
  02D41D  091D: 8946ee           mov word ptr [bp - 0x12], ax
  02D420  0920: 9ae0071f18       lcall 0x181f, 0x7e0
  02D425  0925: eb13             jmp 0x93a
  02D427  0927: 90               nop 
  02D428  0928: 6bd81c           imul bx, ax, 0x1c
  02D42B  092B: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  02D430  0930: 7503             jne 0x935
  02D432  0932: ff46f0           inc word ptr [bp - 0x10]
  02D435  0935: 9ae4021f18       lcall 0x181f, 0x2e4
  02D43A  093A: 8946e8           mov word ptr [bp - 0x18], ax
  02D43D  093D: 0bc0             or ax, ax
  02D43F  093F: 7de7             jge 0x928
  02D441  0941: 8b46f0           mov ax, word ptr [bp - 0x10]
  02D444  0944: f76ef6           imul word ptr [bp - 0xa]
  02D447  0947: c1e002           shl ax, 2
  02D44A  094A: 8946f2           mov word ptr [bp - 0xe], ax
  02D44D  094D: 0bc0             or ax, ax
  02D44F  094F: 7503             jne 0x954
  02D451  0951: e9ae01           jmp 0xb02
  02D454  0954: c746f40000       mov word ptr [bp - 0xc], 0
  02D459  0959: eb2b             jmp 0x986
  02D45B  095B: 90               nop 
  02D45C  095C: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  02D460  0960: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  02D465  0965: 7207             jb 0x96e
  02D467  0967: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  02D46C  096C: 760f             jbe 0x97d
  02D46E  096E: 8b46e8           mov ax, word ptr [bp - 0x18]
  02D471  0971: 9ae4021f18       lcall 0x181f, 0x2e4
  02D476  0976: 8946e8           mov word ptr [bp - 0x18], ax
  02D479  0979: 0bc0             or ax, ax
  02D47B  097B: 7ddf             jge 0x95c
  02D47D  097D: 837ee800         cmp word ptr [bp - 0x18], 0
  02D481  0981: 7d41             jge 0x9c4
  02D483  0983: ff46f4           inc word ptr [bp - 0xc]
  02D486  0986: 837ef408         cmp word ptr [bp - 0xc], 8
  02D48A  098A: 7c03             jl 0x98f
  02D48C  098C: e97301           jmp 0xb02
  02D48F  098F: 8b5ef4           mov bx, word ptr [bp - 0xc]
  02D492  0992: 8a87be00         mov al, byte ptr [bx + 0xbe]
  02D496  0996: 98               cwde 
  02D497  0997: 0346ec           add ax, word ptr [bp - 0x14]
  02D49A  099A: 8946f8           mov word ptr [bp - 8], ax
  02D49D  099D: 50               push ax
  02D49E  099E: 8a87b400         mov al, byte ptr [bx + 0xb4]
  02D4A2  09A2: 98               cwde 
  02D4A3  09A3: 0346ee           add ax, word ptr [bp - 0x12]
  02D4A6  09A6: 8946fc           mov word ptr [bp - 4], ax
  02D4A9  09A9: 50               push ax
  02D4AA  09AA: 9a68071f18       lcall 0x181f, 0x768
  02D4AF  09AF: 83c404           add sp, 4
  02D4B2  09B2: 0bc0             or ax, ax
  02D4B4  09B4: 74cd             je 0x983
  02D4B6  09B6: 8b46fc           mov ax, word ptr [bp - 4]
  02D4B9  09B9: 8b56f8           mov dx, word ptr [bp - 8]
  02D4BC  09BC: 9ae0071f18       lcall 0x181f, 0x7e0
  02D4C1  09C1: ebb3             jmp 0x976
  02D4C3  09C3: 90               nop 
  02D4C4  09C4: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  02D4C8  09C8: 8a874731         mov al, byte ptr [bx + 0x3147]
  02D4CC  09CC: 250f00           and ax, 0xf
  02D4CF  09CF: 8946fe           mov word ptr [bp - 2], ax
  02D4D2  09D2: 3b46e6           cmp ax, word ptr [bp - 0x1a]
  02D4D5  09D5: 74ac             je 0x983
  02D4D7  09D7: 50               push ax
  02D4D8  09D8: ff76e6           push word ptr [bp - 0x1a]
  02D4DB  09DB: 9a380a1f18       lcall 0x181f, 0xa38
  02D4E0  09E0: 83c404           add sp, 4
  02D4E3  09E3: a840             test al, 0x40
  02D4E5  09E5: 740b             je 0x9f2
  02D4E7  09E7: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  02D4EB  09EB: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  02D4F0  09F0: 7591             jne 0x983
  02D4F2  09F2: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  02D4F6  09F6: 8bc3             mov ax, bx
  02D4F8  09F8: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  02D4FC  09FC: 2aff             sub bh, bh
  02D4FE  09FE: 8bcb             mov cx, bx
  02D500  0A00: d1e3             shl bx, 1
  02D502  0A02: 03d9             add bx, cx
  02D504  0A04: d1e3             shl bx, 1
  02D506  0A06: 03d9             add bx, cx
  02D508  0A08: d1e3             shl bx, 1
  02D50A  0A0A: ffb73052         push word ptr [bx + 0x5230]
  02D50E  0A0E: 6a03             push 3
  02D510  0A10: 8bf0             mov si, ax
  02D512  0A12: 9a38041f18       lcall 0x181f, 0x438
  02D517  0A17: 83c404           add sp, 4
  02D51A  0A1A: ff369653         push word ptr [0x5396]
  02D51E  0A1E: ff76ec           push word ptr [bp - 0x14]
  02D521  0A21: ff76ee           push word ptr [bp - 0x12]
  02D524  0A24: 9a70091f18       lcall 0x181f, 0x970
  02D529  0A29: 83c406           add sp, 6
  02D52C  0A2C: 0bc0             or ax, ax
  02D52E  0A2E: 7513             jne 0xa43
  02D530  0A30: 8a844731         mov al, byte ptr [si + 0x3147]
  02D534  0A34: 2ae4             sub ah, ah
  02D536  0A36: 8a0e9653         mov cl, byte ptr [0x5396]
  02D53A  0A3A: ba1000           mov dx, 0x10
  02D53D  0A3D: d3e2             shl dx, cl
  02D53F  0A3F: 85c2             test dx, ax
  02D541  0A41: 7407             je 0xa4a
  02D543  0A43: c746fa0100       mov word ptr [bp - 6], 1
  02D548  0A48: eb05             jmp 0xa4f
  02D54A  0A4A: c746fa0000       mov word ptr [bp - 6], 0
  02D54F  0A4F: ff76f2           push word ptr [bp - 0xe]
  02D552  0A52: ff76e6           push word ptr [bp - 0x1a]
  02D555  0A55: ff76ec           push word ptr [bp - 0x14]
  02D558  0A58: ff76ee           push word ptr [bp - 0x12]
  02D55B  0A5B: a0cc52           mov al, byte ptr [0x52cc]
  02D55E  0A5E: 2ae4             sub ah, ah
  02D560  0A60: 50               push ax
  02D561  0A61: 9a200a1f19       lcall 0x191f, 0xa20
  02D566  0A66: 83c40a           add sp, 0xa
  02D569  0A69: 8946e8           mov word ptr [bp - 0x18], ax
  02D56C  0A6C: 8a46f2           mov al, byte ptr [bp - 0xe]
  02D56F  0A6F: a27d53           mov byte ptr [0x537d], al
  02D572  0A72: 8a46ea           mov al, byte ptr [bp - 0x16]
  02D575  0A75: 2ae4             sub ah, ah
  02D577  0A77: a37253           mov word ptr [0x5372], ax
  02D57A  0A7A: c606765308       mov byte ptr [0x5376], 8
  02D57F  0A7F: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  02D583  0A83: 88a74931         mov byte ptr [bx + 0x3149], ah
  02D587  0A87: 837efa00         cmp word ptr [bp - 6], 0
  02D58B  0A8B: 7457             je 0xae4
  02D58D  0A8D: 6a00             push 0
  02D58F  0A8F: ff76ec           push word ptr [bp - 0x14]
  02D592  0A92: ff76ee           push word ptr [bp - 0x12]
  02D595  0A95: ff76ec           push word ptr [bp - 0x14]
  02D598  0A98: ff76ee           push word ptr [bp - 0x12]
  02D59B  0A9B: 9a52031f18       lcall 0x181f, 0x352
  02D5A0  0AA0: 83c40a           add sp, 0xa
  02D5A3  0AA3: ff76ea           push word ptr [bp - 0x16]
  02D5A6  0AA6: 6a00             push 0
  02D5A8  0AA8: 9a38041f18       lcall 0x181f, 0x438
  02D5AD  0AAD: 83c404           add sp, 4
  02D5B0  0AB0: a14285           mov ax, word ptr [0x8542]
  02D5B3  0AB3: 40               inc ax
  02D5B4  0AB4: 40               inc ax
  02D5B5  0AB5: 1e               push ds
  02D5B6  0AB6: 50               push ax
  02D5B7  0AB7: 6a01             push 1
  02D5B9  0AB9: 9a16041f18       lcall 0x181f, 0x416
  02D5BE  0ABE: 83c406           add sp, 6
  02D5C1  0AC1: ff76fe           push word ptr [bp - 2]
  02D5C4  0AC4: 9aa4091f18       lcall 0x181f, 0x9a4
  02D5C9  0AC9: 83c402           add sp, 2
  02D5CC  0ACC: 50               push ax
  02D5CD  0ACD: 6a02             push 2
  02D5CF  0ACF: 9a38041f18       lcall 0x181f, 0x438
  02D5D4  0AD4: 83c404           add sp, 4
  02D5D7  0AD7: 6a00             push 0
  02D5D9  0AD9: 687f0d           push 0xd7f
  02D5DC  0ADC: 9a52061f18       lcall 0x181f, 0x652
  02D5E1  0AE1: 83c404           add sp, 4
  02D5E4  0AE4: 6a01             push 1
  02D5E6  0AE6: ff76fa           push word ptr [bp - 6]
  02D5E9  0AE9: ff76f8           push word ptr [bp - 8]
  02D5EC  0AEC: ff76fc           push word ptr [bp - 4]
  02D5EF  0AEF: ff76e8           push word ptr [bp - 0x18]
  02D5F2  0AF2: 9a140a1f19       lcall 0x191f, 0xa14
  02D5F7  0AF7: 83c40a           add sp, 0xa
  02D5FA  0AFA: 9a060a1f19       lcall 0x191f, 0xa06
  02D5FF  0AFF: e981fe           jmp 0x983
  02D602  0B02: 5e               pop si
  02D603  0B03: c9               leave 
  02D604  0B04: cb               retf 

; ---- func_02D606  size=81  insns=27  prologue=ENTER 0x0002,0  terminal=RETF ----
  02D606  0B06: c8020000         enter 2, 0
  02D60A  0B0A: c746fe0000       mov word ptr [bp - 2], 0
  02D60F  0B0F: 837e0600         cmp word ptr [bp + 6], 0
  02D613  0B13: 743d             je 0xb52
  02D615  0B15: 837e0605         cmp word ptr [bp + 6], 5
  02D619  0B19: 7437             je 0xb52
  02D61B  0B1B: 837e0608         cmp word ptr [bp + 6], 8
  02D61F  0B1F: 7431             je 0xb52
  02D621  0B21: 837e060e         cmp word ptr [bp + 6], 0xe
  02D625  0B25: 742b             je 0xb52
  02D627  0B27: 837e060f         cmp word ptr [bp + 6], 0xf
  02D62B  0B2B: 7425             je 0xb52
  02D62D  0B2D: 837e0606         cmp word ptr [bp + 6], 6
  02D631  0B31: 751a             jne 0xb4d
  02D633  0B33: 6a03             push 3
  02D635  0B35: 9afc091f18       lcall 0x181f, 0x9fc
  02D63A  0B3A: 83c402           add sp, 2
  02D63D  0B3D: 0bc0             or ax, ax
  02D63F  0B3F: 7511             jne 0xb52
  02D641  0B41: 3906e48d         cmp word ptr [0x8de4], ax
  02D645  0B45: 750b             jne 0xb52
  02D647  0B47: 3906e68d         cmp word ptr [0x8de6], ax
  02D64B  0B4B: 7505             jne 0xb52
  02D64D  0B4D: c746fe0100       mov word ptr [bp - 2], 1
  02D652  0B52: 8b46fe           mov ax, word ptr [bp - 2]
  02D655  0B55: c9               leave 
  02D656  0B56: cb               retf 

; ---- func_02D658  size=5220  insns=1789  prologue=ENTER 0x012C,0  terminal=RETF ----
  02D658  0B58: c82c0100         enter 0x12c, 0
  02D65C  0B5C: 57               push di
  02D65D  0B5D: 56               push si
  02D65E  0B5E: c60698a800       mov byte ptr [0xa898], 0
  02D663  0B63: ff7606           push word ptr [bp + 6]
  02D666  0B66: 9ae6091f18       lcall 0x181f, 0x9e6
  02D66B  0B6B: 83c402           add sp, 2
  02D66E  0B6E: 8b1e4285         mov bx, word ptr [0x8542]
  02D672  0B72: 8a471a           mov al, byte ptr [bx + 0x1a]
  02D675  0B75: 2ae4             sub ah, ah
  02D677  0B77: 8986d6fe         mov word ptr [bp - 0x12a], ax
  02D67B  0B7B: 50               push ax
  02D67C  0B7C: 9a82051f18       lcall 0x181f, 0x582
  02D681  0B81: 83c402           add sp, 2
  02D684  0B84: 0e               push cs
  02D685  0B85: e8d218           call 0x245a
  02D688  0B88: 9a720c1f18       lcall 0x181f, 0xc72
  02D68D  0B8D: 9a220c1f18       lcall 0x181f, 0xc22
  02D692  0B92: 6a00             push 0
  02D694  0B94: 6a12             push 0x12
  02D696  0B96: 9a500b1f18       lcall 0x181f, 0xb50
  02D69B  0B9B: 83c404           add sp, 4
  02D69E  0B9E: 898648ff         mov word ptr [bp - 0xb8], ax
  02D6A2  0BA2: 50               push ax
  02D6A3  0BA3: ffb6d6fe         push word ptr [bp - 0x12a]
  02D6A7  0BA7: 9af8091f19       lcall 0x191f, 0x9f8
  02D6AC  0BAC: 83c404           add sp, 4
  02D6AF  0BAF: 9a3a0d1f18       lcall 0x181f, 0xd3a
  02D6B4  0BB4: 894698           mov word ptr [bp - 0x68], ax
  02D6B7  0BB7: 8b1e4285         mov bx, word ptr [0x8542]
  02D6BB  0BBB: 8b879a00         mov ax, word ptr [bx + 0x9a]
  02D6BF  0BBF: 894696           mov word ptr [bp - 0x6a], ax
  02D6C2  0BC2: c78790000000     mov word ptr [bx + 0x90], 0
  02D6C8  0BC8: 2bc0             sub ax, ax
  02D6CA  0BCA: 89863eff         mov word ptr [bp - 0xc2], ax
  02D6CE  0BCE: 894694           mov word ptr [bp - 0x6c], ax
  02D6D1  0BD1: 89864cff         mov word ptr [bp - 0xb4], ax
  02D6D5  0BD5: e91002           jmp 0xde8
  02D6D8  0BD8: ffb64cff         push word ptr [bp - 0xb4]
  02D6DC  0BDC: 0e               push cs
  02D6DD  0BDD: e87518           call 0x2455
  02D6E0  0BE0: 83c402           add sp, 2
  02D6E3  0BE3: 8946f8           mov word ptr [bp - 8], ax
  02D6E6  0BE6: 0bc0             or ax, ax
  02D6E8  0BE8: 7503             jne 0xbed
  02D6EA  0BEA: e98a01           jmp 0xd77
  02D6ED  0BED: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02D6F1  0BF1: d1e6             shl si, 1
  02D6F3  0BF3: 8b1e4285         mov bx, word ptr [0x8542]
  02D6F7  0BF7: 83b89a0064       cmp word ptr [bx + si + 0x9a], 0x64
  02D6FC  0BFC: 7d03             jge 0xc01
  02D6FE  0BFE: e97601           jmp 0xd77
  02D701  0C01: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02D705  0C05: 2d3200           sub ax, 0x32
  02D708  0C08: 8946fe           mov word ptr [bp - 2], ax
  02D70B  0C0B: 29809a00         sub word ptr [bx + si + 0x9a], ax
  02D70F  0C0F: 8b46fe           mov ax, word ptr [bp - 2]
  02D712  0C12: 29867cff         sub word ptr [bp - 0x84], ax
  02D716  0C16: ffb64cff         push word ptr [bp - 0xb4]
  02D71A  0C1A: 9aea091f19       lcall 0x191f, 0x9ea
  02D71F  0C1F: 83c402           add sp, 2
  02D722  0C22: f76efe           imul word ptr [bp - 2]
  02D725  0C25: 89469c           mov word ptr [bp - 0x64], ax
  02D728  0C28: f606825301       test byte ptr [0x5382], 1
  02D72D  0C2D: 7521             jne 0xc50
  02D72F  0C2F: 6a00             push 0
  02D731  0C31: 6a64             push 0x64
  02D733  0C33: 8b1efc84         mov bx, word ptr [0x84fc]
  02D737  0C37: 8a4701           mov al, byte ptr [bx + 1]
  02D73A  0C3A: 98               cwde 
  02D73B  0C3B: f76e9c           imul word ptr [bp - 0x64]
  02D73E  0C3E: 52               push dx
  02D73F  0C3F: 50               push ax
  02D740  0C40: 9ac60e1d0d       lcall 0xd1d, 0xec6
  02D745  0C45: 8986d8fe         mov word ptr [bp - 0x128], ax
  02D749  0C49: 2b469c           sub ax, word ptr [bp - 0x64]
  02D74C  0C4C: f7d8             neg ax
  02D74E  0C4E: eb06             jmp 0xc56
  02D750  0C50: c786d8fe0000     mov word ptr [bp - 0x128], 0
  02D756  0C56: 8986dafe         mov word ptr [bp - 0x126], ax
  02D75A  0C5A: 99               cdq 
  02D75B  0C5B: 52               push dx
  02D75C  0C5C: 50               push ax
  02D75D  0C5D: ff36129e         push word ptr [0x9e12]
  02D761  0C61: 8bf0             mov si, ax
  02D763  0C63: 8bfa             mov di, dx
  02D765  0C65: 9aba0a1f18       lcall 0x181f, 0xaba
  02D76A  0C6A: 83c406           add sp, 6
  02D76D  0C6D: ff76fe           push word ptr [bp - 2]
  02D770  0C70: ffb64cff         push word ptr [bp - 0xb4]
  02D774  0C74: 9a2e0a1f19       lcall 0x191f, 0xa2e
  02D779  0C79: 83c404           add sp, 4
  02D77C  0C7C: 8b86d8fe         mov ax, word ptr [bp - 0x128]
  02D780  0C80: 99               cdq 
  02D781  0C81: 8b1efc84         mov bx, word ptr [0x84fc]
  02D785  0C85: 014722           add word ptr [bx + 0x22], ax
  02D788  0C88: 115724           adc word ptr [bx + 0x24], dx
  02D78B  0C8B: 017726           add word ptr [bx + 0x26], si
  02D78E  0C8E: 117f28           adc word ptr [bx + 0x28], di
  02D791  0C91: 83bed6fe04       cmp word ptr [bp - 0x12a], 4
  02D796  0C96: 7c03             jl 0xc9b
  02D798  0C98: e9dc00           jmp 0xd77
  02D79B  0C9B: 6b9ed6fe34       imul bx, word ptr [bp - 0x12a], 0x34
  02D7A0  0CA0: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02D7A5  0CA5: 7403             je 0xcaa
  02D7A7  0CA7: e9cd00           jmp 0xd77
  02D7AA  0CAA: 6a01             push 1
  02D7AC  0CAC: 9a56001f18       lcall 0x181f, 0x56
  02D7B1  0CB1: 83c402           add sp, 2
  02D7B4  0CB4: a14285           mov ax, word ptr [0x8542]
  02D7B7  0CB7: 40               inc ax
  02D7B8  0CB8: 40               inc ax
  02D7B9  0CB9: 1e               push ds
  02D7BA  0CBA: 50               push ax
  02D7BB  0CBB: 9a6a001f18       lcall 0x181f, 0x6a
  02D7C0  0CC0: 83c404           add sp, 4
  02D7C3  0CC3: ff36182e         push word ptr [0x2e18]
  02D7C7  0CC7: 9a74001f18       lcall 0x181f, 0x74
  02D7CC  0CCC: 83c402           add sp, 2
  02D7CF  0CCF: ff76fe           push word ptr [bp - 2]
  02D7D2  0CD2: 9a7e001f18       lcall 0x181f, 0x7e
  02D7D7  0CD7: 83c402           add sp, 2
  02D7DA  0CDA: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  02D7DE  0CDE: d1e3             shl bx, 1
  02D7E0  0CE0: ffb7c097         push word ptr [bx - 0x6840]
  02D7E4  0CE4: 9a74001f18       lcall 0x181f, 0x74
  02D7E9  0CE9: 83c402           add sp, 2
  02D7EC  0CEC: ff361a2e         push word ptr [0x2e1a]
  02D7F0  0CF0: 9a74001f18       lcall 0x181f, 0x74
  02D7F5  0CF5: 83c402           add sp, 2
  02D7F8  0CF8: ff769c           push word ptr [bp - 0x64]
  02D7FB  0CFB: 9a7e001f18       lcall 0x181f, 0x7e
  02D800  0D00: 83c402           add sp, 2
  02D803  0D03: 9a88001f18       lcall 0x181f, 0x88
  02D808  0D08: 1e               push ds
  02D809  0D09: 68880d           push 0xd88
  02D80C  0D0C: 9a6a001f18       lcall 0x181f, 0x6a
  02D811  0D11: 83c404           add sp, 4
  02D814  0D14: f606825301       test byte ptr [0x5382], 1
  02D819  0D19: 7547             jne 0xd62
  02D81B  0D1B: 8b1efc84         mov bx, word ptr [0x84fc]
  02D81F  0D1F: 8a4701           mov al, byte ptr [bx + 1]
  02D822  0D22: 98               cwde 
  02D823  0D23: 50               push ax
  02D824  0D24: 9a7e001f18       lcall 0x181f, 0x7e
  02D829  0D29: 83c402           add sp, 2
  02D82C  0D2C: 9a88001f18       lcall 0x181f, 0x88
  02D831  0D31: 6a11             push 0x11
  02D833  0D33: 9ad4071f19       lcall 0x191f, 0x7d4
  02D838  0D38: 83c402           add sp, 2
  02D83B  0D3B: ffb6d8fe         push word ptr [bp - 0x128]
  02D83F  0D3F: 9a7e001f18       lcall 0x181f, 0x7e
  02D844  0D44: 83c402           add sp, 2
  02D847  0D47: 9a88001f18       lcall 0x181f, 0x88
  02D84C  0D4C: 6a12             push 0x12
  02D84E  0D4E: 9ad4071f19       lcall 0x191f, 0x7d4
  02D853  0D53: 83c402           add sp, 2
  02D856  0D56: ffb6dafe         push word ptr [bp - 0x126]
  02D85A  0D5A: 9a7e001f18       lcall 0x181f, 0x7e
  02D85F  0D5F: 83c402           add sp, 2
  02D862  0D62: 803e97a800       cmp byte ptr [0xa897], 0
  02D867  0D67: 740e             je 0xd77
  02D869  0D69: 6a00             push 0
  02D86B  0D6B: 6a78             push 0x78
  02D86D  0D6D: 6a01             push 1
  02D86F  0D6F: 9ab0071f19       lcall 0x191f, 0x7b0
  02D874  0D74: 83c406           add sp, 6
  02D877  0D77: 83be4cff00       cmp word ptr [bp - 0xb4], 0
  02D87C  0D7C: 742a             je 0xda8
  02D87E  0D7E: ffb67cff         push word ptr [bp - 0x84]
  02D882  0D82: 6a00             push 0
  02D884  0D84: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02D888  0D88: d1e6             shl si, 1
  02D88A  0D8A: 8b1e4285         mov bx, word ptr [0x8542]
  02D88E  0D8E: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02D892  0D92: 2b4698           sub ax, word ptr [bp - 0x68]
  02D895  0D95: 89821eff         mov word ptr [bp + si - 0xe2], ax
  02D899  0D99: 50               push ax
  02D89A  0D9A: 9a5c031f18       lcall 0x181f, 0x35c
  02D89F  0D9F: 83c406           add sp, 6
  02D8A2  0DA2: 89821eff         mov word ptr [bp + si - 0xe2], ax
  02D8A6  0DA6: eb0c             jmp 0xdb4
  02D8A8  0DA8: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02D8AC  0DAC: d1e6             shl si, 1
  02D8AE  0DAE: c7821eff0000     mov word ptr [bp + si - 0xe2], 0
  02D8B4  0DB4: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  02D8B8  0DB8: d1e3             shl bx, 1
  02D8BA  0DBA: 83bfc88d00       cmp word ptr [bx - 0x7238], 0
  02D8BF  0DBF: 7423             je 0xde4
  02D8C1  0DC1: 83be7cff00       cmp word ptr [bp - 0x84], 0
  02D8C6  0DC6: 7f0b             jg 0xdd3
  02D8C8  0DC8: 751a             jne 0xde4
  02D8CA  0DCA: 8bf3             mov si, bx
  02D8CC  0DCC: 83ba1eff00       cmp word ptr [bp + si - 0xe2], 0
  02D8D1  0DD1: 7411             je 0xde4
  02D8D3  0DD3: 8a8e4cff         mov cl, byte ptr [bp - 0xb4]
  02D8D7  0DD7: b80100           mov ax, 1
  02D8DA  0DDA: d3e0             shl ax, cl
  02D8DC  0DDC: 8b1e4285         mov bx, word ptr [0x8542]
  02D8E0  0DE0: 09879000         or word ptr [bx + 0x90], ax
  02D8E4  0DE4: ff864cff         inc word ptr [bp - 0xb4]
  02D8E8  0DE8: 83be4cff10       cmp word ptr [bp - 0xb4], 0x10
  02D8ED  0DED: 7c03             jl 0xdf2
  02D8EF  0DEF: e9e400           jmp 0xed6
  02D8F2  0DF2: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02D8F6  0DF6: d1e6             shl si, 1
  02D8F8  0DF8: 8b1e4285         mov bx, word ptr [0x8542]
  02D8FC  0DFC: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02D900  0E00: 898254ff         mov word ptr [bp + si - 0xac], ax
  02D904  0E04: 6a00             push 0
  02D906  0E06: ffb64cff         push word ptr [bp - 0xb4]
  02D90A  0E0A: 9a500b1f18       lcall 0x181f, 0xb50
  02D90F  0E0F: 83c404           add sp, 4
  02D912  0E12: 89867cff         mov word ptr [bp - 0x84], ax
  02D916  0E16: 83bed6fe04       cmp word ptr [bp - 0x12a], 4
  02D91B  0E1B: 7d0c             jge 0xe29
  02D91D  0E1D: 6b9ed6fe34       imul bx, word ptr [bp - 0x12a], 0x34
  02D922  0E22: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02D927  0E27: 7412             je 0xe3b
  02D929  0E29: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  02D92D  0E2D: d1e3             shl bx, 1
  02D92F  0E2F: 8b87c88d         mov ax, word ptr [bx - 0x7238]
  02D933  0E33: 2b870a8e         sub ax, word ptr [bx - 0x71f6]
  02D937  0E37: 89867cff         mov word ptr [bp - 0x84], ax
  02D93B  0E3B: 83bed6fe04       cmp word ptr [bp - 0x12a], 4
  02D940  0E40: 7d0c             jge 0xe4e
  02D942  0E42: 6b9ed6fe34       imul bx, word ptr [bp - 0x12a], 0x34
  02D947  0E47: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02D94C  0E4C: 7412             je 0xe60
  02D94E  0E4E: 83be4cff00       cmp word ptr [bp - 0xb4], 0
  02D953  0E53: 750b             jne 0xe60
  02D955  0E55: a0a653           mov al, byte ptr [0x53a6]
  02D958  0E58: d0e8             shr al, 1
  02D95A  0E5A: 2ae4             sub ah, ah
  02D95C  0E5C: 01867cff         add word ptr [bp - 0x84], ax
  02D960  0E60: 8b867cff         mov ax, word ptr [bp - 0x84]
  02D964  0E64: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02D968  0E68: d1e6             shl si, 1
  02D96A  0E6A: 8b1e4285         mov bx, word ptr [0x8542]
  02D96E  0E6E: 01809a00         add word ptr [bx + si + 0x9a], ax
  02D972  0E72: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02D976  0E76: 0bc0             or ax, ax
  02D978  0E78: 7d02             jge 0xe7c
  02D97A  0E7A: 2bc0             sub ax, ax
  02D97C  0E7C: 89809a00         mov word ptr [bx + si + 0x9a], ax
  02D980  0E80: 6a12             push 0x12
  02D982  0E82: 9afc091f18       lcall 0x181f, 0x9fc
  02D987  0E87: 83c402           add sp, 2
  02D98A  0E8A: 0bc0             or ax, ax
  02D98C  0E8C: 7503             jne 0xe91
  02D98E  0E8E: e9e6fe           jmp 0xd77
  02D991  0E91: 8b1e4285         mov bx, word ptr [0x8542]
  02D995  0E95: f6471b03         test byte ptr [bx + 0x1b], 3
  02D999  0E99: 7416             je 0xeb1
  02D99B  0E9B: 83bed6fe04       cmp word ptr [bp - 0x12a], 4
  02D9A0  0EA0: 7d0f             jge 0xeb1
  02D9A2  0EA2: 6b9ed6fe34       imul bx, word ptr [bp - 0x12a], 0x34
  02D9A7  0EA7: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02D9AC  0EAC: 7503             jne 0xeb1
  02D9AE  0EAE: e9c6fe           jmp 0xd77
  02D9B1  0EB1: 83bed6fe04       cmp word ptr [bp - 0x12a], 4
  02D9B6  0EB6: 7c03             jl 0xebb
  02D9B8  0EB8: e91dfd           jmp 0xbd8
  02D9BB  0EBB: 6b9ed6fe34       imul bx, word ptr [bp - 0x12a], 0x34
  02D9C0  0EC0: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02D9C5  0EC5: 7403             je 0xeca
  02D9C7  0EC7: e90efd           jmp 0xbd8
  02D9CA  0ECA: ffb64cff         push word ptr [bp - 0xb4]
  02D9CE  0ECE: 9afe0c1f18       lcall 0x181f, 0xcfe
  02D9D3  0ED3: e90afd           jmp 0xbe0
  02D9D6  0ED6: 9a860c1f18       lcall 0x181f, 0xc86
  02D9DB  0EDB: 898674ff         mov word ptr [bp - 0x8c], ax
  02D9DF  0EDF: f606825301       test byte ptr [0x5382], 1
  02D9E4  0EE4: 741a             je 0xf00
  02D9E6  0EE6: a0d253           mov al, byte ptr [0x53d2]
  02D9E9  0EE9: 8b1e4285         mov bx, word ptr [0x8542]
  02D9ED  0EED: 38471a           cmp byte ptr [bx + 0x1a], al
  02D9F0  0EF0: 750e             jne 0xf00
  02D9F2  0EF2: 8b8648ff         mov ax, word ptr [bp - 0xb8]
  02D9F6  0EF6: d1f8             sar ax, 1
  02D9F8  0EF8: f7d8             neg ax
  02D9FA  0EFA: 898648ff         mov word ptr [bp - 0xb8], ax
  02D9FE  0EFE: eb1c             jmp 0xf1c
  02DA00  0F00: 8b1e4285         mov bx, word ptr [0x8542]
  02DA04  0F04: 8a471f           mov al, byte ptr [bx + 0x1f]
  02DA07  0F07: 98               cwde 
  02DA08  0F08: 3b8648ff         cmp ax, word ptr [bp - 0xb8]
  02DA0C  0F0C: 7e0e             jle 0xf1c
  02DA0E  0F0E: 8b8674ff         mov ax, word ptr [bp - 0x8c]
  02DA12  0F12: b9ecff           mov cx, 0xffec
  02DA15  0F15: 99               cdq 
  02DA16  0F16: f7f9             idiv cx
  02DA18  0F18: 018648ff         add word ptr [bp - 0xb8], ax
  02DA1C  0F1C: 8b87c600         mov ax, word ptr [bx + 0xc6]
  02DA20  0F20: 8b97c800         mov dx, word ptr [bx + 0xc8]
  02DA24  0F24: d1fa             sar dx, 1
  02DA26  0F26: d1d8             rcr ax, 1
  02DA28  0F28: d1fa             sar dx, 1
  02DA2A  0F2A: d1d8             rcr ax, 1
  02DA2C  0F2C: d1fa             sar dx, 1
  02DA2E  0F2E: d1d8             rcr ax, 1
  02DA30  0F30: d1fa             sar dx, 1
  02DA32  0F32: d1d8             rcr ax, 1
  02DA34  0F34: d1fa             sar dx, 1
  02DA36  0F36: d1d8             rcr ax, 1
  02DA38  0F38: d1fa             sar dx, 1
  02DA3A  0F3A: d1d8             rcr ax, 1
  02DA3C  0F3C: 2987c600         sub word ptr [bx + 0xc6], ax
  02DA40  0F40: 1997c800         sbb word ptr [bx + 0xc8], dx
  02DA44  0F44: 8b87c600         mov ax, word ptr [bx + 0xc6]
  02DA48  0F48: 8b97c800         mov dx, word ptr [bx + 0xc8]
  02DA4C  0F4C: 0bd2             or dx, dx
  02DA4E  0F4E: 7f0c             jg 0xf5c
  02DA50  0F50: 7c05             jl 0xf57
  02DA52  0F52: 3d0100           cmp ax, 1
  02DA55  0F55: 7305             jae 0xf5c
  02DA57  0F57: 2bd2             sub dx, dx
  02DA59  0F59: b80100           mov ax, 1
  02DA5C  0F5C: 8987c600         mov word ptr [bx + 0xc6], ax
  02DA60  0F60: 8997c800         mov word ptr [bx + 0xc8], dx
  02DA64  0F64: 8a471f           mov al, byte ptr [bx + 0x1f]
  02DA67  0F67: 98               cwde 
  02DA68  0F68: d1e0             shl ax, 1
  02DA6A  0F6A: 99               cdq 
  02DA6B  0F6B: 0187c600         add word ptr [bx + 0xc6], ax
  02DA6F  0F6F: 1197c800         adc word ptr [bx + 0xc8], dx
  02DA73  0F73: 8b8648ff         mov ax, word ptr [bp - 0xb8]
  02DA77  0F77: 99               cdq 
  02DA78  0F78: 8b8fc200         mov cx, word ptr [bx + 0xc2]
  02DA7C  0F7C: 8bb7c400         mov si, word ptr [bx + 0xc4]
  02DA80  0F80: d1fe             sar si, 1
  02DA82  0F82: d1d9             rcr cx, 1
  02DA84  0F84: d1fe             sar si, 1
  02DA86  0F86: d1d9             rcr cx, 1
  02DA88  0F88: d1fe             sar si, 1
  02DA8A  0F8A: d1d9             rcr cx, 1
  02DA8C  0F8C: d1fe             sar si, 1
  02DA8E  0F8E: d1d9             rcr cx, 1
  02DA90  0F90: d1fe             sar si, 1
  02DA92  0F92: d1d9             rcr cx, 1
  02DA94  0F94: d1fe             sar si, 1
  02DA96  0F96: d1d9             rcr cx, 1
  02DA98  0F98: 2bc1             sub ax, cx
  02DA9A  0F9A: 1bd6             sbb dx, si
  02DA9C  0F9C: 0187c200         add word ptr [bx + 0xc2], ax
  02DAA0  0FA0: 1197c400         adc word ptr [bx + 0xc4], dx
  02DAA4  0FA4: 8b87c200         mov ax, word ptr [bx + 0xc2]
  02DAA8  0FA8: 8b97c400         mov dx, word ptr [bx + 0xc4]
  02DAAC  0FAC: 0bd2             or dx, dx
  02DAAE  0FAE: 7f06             jg 0xfb6
  02DAB0  0FB0: 7d04             jge 0xfb6
  02DAB2  0FB2: 2bd2             sub dx, dx
  02DAB4  0FB4: 2bc0             sub ax, ax
  02DAB6  0FB6: 8987c200         mov word ptr [bx + 0xc2], ax
  02DABA  0FBA: 8997c400         mov word ptr [bx + 0xc4], dx
  02DABE  0FBE: 3b97c800         cmp dx, word ptr [bx + 0xc8]
  02DAC2  0FC2: 7c10             jl 0xfd4
  02DAC4  0FC4: 7f06             jg 0xfcc
  02DAC6  0FC6: 3b87c600         cmp ax, word ptr [bx + 0xc6]
  02DACA  0FCA: 7608             jbe 0xfd4
  02DACC  0FCC: 8b97c800         mov dx, word ptr [bx + 0xc8]
  02DAD0  0FD0: 8b87c600         mov ax, word ptr [bx + 0xc6]
  02DAD4  0FD4: 8987c200         mov word ptr [bx + 0xc2], ax
  02DAD8  0FD8: 8997c400         mov word ptr [bx + 0xc4], dx
  02DADC  0FDC: 9a860c1f18       lcall 0x181f, 0xc86
  02DAE1  0FE1: 89864aff         mov word ptr [bp - 0xb6], ax
  02DAE5  0FE5: 99               cdq 
  02DAE6  0FE6: 52               push dx
  02DAE7  0FE7: 50               push ax
  02DAE8  0FE8: 6a00             push 0
  02DAEA  0FEA: 9aae091f18       lcall 0x181f, 0x9ae
  02DAEF  0FEF: 83c406           add sp, 6
  02DAF2  0FF2: 8a268553         mov ah, byte ptr [0x5385]
  02DAF6  0FF6: 250002           and ax, 0x200
  02DAF9  0FF9: 3d0100           cmp ax, 1
  02DAFC  0FFC: 1bc0             sbb ax, ax
  02DAFE  0FFE: f7d8             neg ax
  02DB00  1000: 898652ff         mov word ptr [bp - 0xae], ax
  02DB04  1004: c646a200         mov byte ptr [bp - 0x5e], 0
  02DB08  1008: 8d46a2           lea ax, [bp - 0x5e]
  02DB0B  100B: 50               push ax
  02DB0C  100C: 6a00             push 0
  02DB0E  100E: ffb6d6fe         push word ptr [bp - 0x12a]
  02DB12  1012: 9a2e041f18       lcall 0x181f, 0x42e
  02DB17  1017: 83c406           add sp, 6
  02DB1A  101A: 8d46a2           lea ax, [bp - 0x5e]
  02DB1D  101D: 16               push ss
  02DB1E  101E: 50               push ax
  02DB1F  101F: 6a01             push 1
  02DB21  1021: 9a16041f18       lcall 0x181f, 0x416
  02DB26  1026: 83c406           add sp, 6
  02DB29  1029: 83be4aff32       cmp word ptr [bp - 0xb6], 0x32
  02DB2E  102E: 7c3e             jl 0x106e
  02DB30  1030: 8b1e4285         mov bx, word ptr [0x8542]
  02DB34  1034: f6471c04         test byte ptr [bx + 0x1c], 4
  02DB38  1038: 7534             jne 0x106e
  02DB3A  103A: 83be52ff00       cmp word ptr [bp - 0xae], 0
  02DB3F  103F: 7422             je 0x1063
  02DB41  1041: 6a00             push 0
  02DB43  1043: 6a01             push 1
  02DB45  1045: 6a00             push 0
  02DB47  1047: 6a00             push 0
  02DB49  1049: 6aff             push -1
  02DB4B  104B: 803e98a801       cmp byte ptr [0xa898], 1
  02DB50  1050: 1bc0             sbb ax, ax
  02DB52  1052: f7d8             neg ax
  02DB54  1054: 50               push ax
  02DB55  1055: 688a0d           push 0xd8a
  02DB58  1058: 0e               push cs
  02DB59  1059: e80314           call 0x245f
  02DB5C  105C: 83c40e           add sp, 0xe
  02DB5F  105F: 080698a8         or byte ptr [0xa898], al
  02DB63  1063: 8b1e4285         mov bx, word ptr [0x8542]
  02DB67  1067: 804f1c04         or byte ptr [bx + 0x1c], 4
  02DB6B  106B: e94e01           jmp 0x11bc
  02DB6E  106E: 83be4aff64       cmp word ptr [bp - 0xb6], 0x64
  02DB73  1073: 7c3f             jl 0x10b4
  02DB75  1075: 8b1e4285         mov bx, word ptr [0x8542]
  02DB79  1079: f6471c02         test byte ptr [bx + 0x1c], 2
  02DB7D  107D: 7535             jne 0x10b4
  02DB7F  107F: 83be52ff00       cmp word ptr [bp - 0xae], 0
  02DB84  1084: 7422             je 0x10a8
  02DB86  1086: 6a00             push 0
  02DB88  1088: 6a01             push 1
  02DB8A  108A: 6a00             push 0
  02DB8C  108C: 6a00             push 0
  02DB8E  108E: 6aff             push -1
  02DB90  1090: 803e98a801       cmp byte ptr [0xa898], 1
  02DB95  1095: 1bc0             sbb ax, ax
  02DB97  1097: f7d8             neg ax
  02DB99  1099: 50               push ax
  02DB9A  109A: 68980d           push 0xd98
  02DB9D  109D: 0e               push cs
  02DB9E  109E: e8be13           call 0x245f
  02DBA1  10A1: 83c40e           add sp, 0xe
  02DBA4  10A4: 080698a8         or byte ptr [0xa898], al
  02DBA8  10A8: 8b1e4285         mov bx, word ptr [0x8542]
  02DBAC  10AC: 804f1c02         or byte ptr [bx + 0x1c], 2
  02DBB0  10B0: e90901           jmp 0x11bc
  02DBB3  10B3: 90               nop 
  02DBB4  10B4: 83be4aff5f       cmp word ptr [bp - 0xb6], 0x5f
  02DBB9  10B9: 7d3f             jge 0x10fa
  02DBBB  10BB: 8b1e4285         mov bx, word ptr [0x8542]
  02DBBF  10BF: f6471c02         test byte ptr [bx + 0x1c], 2
  02DBC3  10C3: 7435             je 0x10fa
  02DBC5  10C5: 83be52ff00       cmp word ptr [bp - 0xae], 0
  02DBCA  10CA: 7422             je 0x10ee
  02DBCC  10CC: 6a00             push 0
  02DBCE  10CE: 6a01             push 1
  02DBD0  10D0: 6a00             push 0
  02DBD2  10D2: 6a00             push 0
  02DBD4  10D4: 6aff             push -1
  02DBD6  10D6: 803e98a801       cmp byte ptr [0xa898], 1
  02DBDB  10DB: 1bc0             sbb ax, ax
  02DBDD  10DD: f7d8             neg ax
  02DBDF  10DF: 50               push ax
  02DBE0  10E0: 68a70d           push 0xda7
  02DBE3  10E3: 0e               push cs
  02DBE4  10E4: e87813           call 0x245f
  02DBE7  10E7: 83c40e           add sp, 0xe
  02DBEA  10EA: 080698a8         or byte ptr [0xa898], al
  02DBEE  10EE: 8b1e4285         mov bx, word ptr [0x8542]
  02DBF2  10F2: 80671cfd         and byte ptr [bx + 0x1c], 0xfd
  02DBF6  10F6: e9c300           jmp 0x11bc
  02DBF9  10F9: 90               nop 
  02DBFA  10FA: 83be4aff32       cmp word ptr [bp - 0xb6], 0x32
  02DBFF  10FF: 7d3f             jge 0x1140
  02DC01  1101: 8b1e4285         mov bx, word ptr [0x8542]
  02DC05  1105: f6471c04         test byte ptr [bx + 0x1c], 4
  02DC09  1109: 7435             je 0x1140
  02DC0B  110B: 83be52ff00       cmp word ptr [bp - 0xae], 0
  02DC10  1110: 7422             je 0x1134
  02DC12  1112: 6a00             push 0
  02DC14  1114: 6a01             push 1
  02DC16  1116: 6a00             push 0
  02DC18  1118: 6a00             push 0
  02DC1A  111A: 6aff             push -1
  02DC1C  111C: 803e98a801       cmp byte ptr [0xa898], 1
  02DC21  1121: 1bc0             sbb ax, ax
  02DC23  1123: f7d8             neg ax
  02DC25  1125: 50               push ax
  02DC26  1126: 68b40d           push 0xdb4
  02DC29  1129: 0e               push cs
  02DC2A  112A: e83213           call 0x245f
  02DC2D  112D: 83c40e           add sp, 0xe
  02DC30  1130: 080698a8         or byte ptr [0xa898], al
  02DC34  1134: 8b1e4285         mov bx, word ptr [0x8542]
  02DC38  1138: 80671cfb         and byte ptr [bx + 0x1c], 0xfb
  02DC3C  113C: eb7e             jmp 0x11bc
  02DC3E  113E: 90               nop 
  02DC3F  113F: 90               nop 
  02DC40  1140: 8b864aff         mov ax, word ptr [bp - 0xb6]
  02DC44  1144: b90a00           mov cx, 0xa
  02DC47  1147: 99               cdq 
  02DC48  1148: f7f9             idiv cx
  02DC4A  114A: 8bd0             mov dx, ax
  02DC4C  114C: 8b8674ff         mov ax, word ptr [bp - 0x8c]
  02DC50  1150: 8bda             mov bx, dx
  02DC52  1152: 99               cdq 
  02DC53  1153: f7f9             idiv cx
  02DC55  1155: 3bc3             cmp ax, bx
  02DC57  1157: 7d21             jge 0x117a
  02DC59  1159: f606855301       test byte ptr [0x5385], 1
  02DC5E  115E: 755c             jne 0x11bc
  02DC60  1160: 6a00             push 0
  02DC62  1162: 6a01             push 1
  02DC64  1164: 6a00             push 0
  02DC66  1166: 6a00             push 0
  02DC68  1168: 6aff             push -1
  02DC6A  116A: 803e98a801       cmp byte ptr [0xa898], 1
  02DC6F  116F: 1bc0             sbb ax, ax
  02DC71  1171: f7d8             neg ax
  02DC73  1173: 50               push ax
  02DC74  1174: 68c10d           push 0xdc1
  02DC77  1177: eb38             jmp 0x11b1
  02DC79  1179: 90               nop 
  02DC7A  117A: 8b8674ff         mov ax, word ptr [bp - 0x8c]
  02DC7E  117E: 99               cdq 
  02DC7F  117F: f7f9             idiv cx
  02DC81  1181: 8bd0             mov dx, ax
  02DC83  1183: 8b864aff         mov ax, word ptr [bp - 0xb6]
  02DC87  1187: 050400           add ax, 4
  02DC8A  118A: 8bda             mov bx, dx
  02DC8C  118C: 99               cdq 
  02DC8D  118D: f7f9             idiv cx
  02DC8F  118F: 3bc3             cmp ax, bx
  02DC91  1191: 7d29             jge 0x11bc
  02DC93  1193: f606855301       test byte ptr [0x5385], 1
  02DC98  1198: 7522             jne 0x11bc
  02DC9A  119A: 6a00             push 0
  02DC9C  119C: 6a01             push 1
  02DC9E  119E: 6a00             push 0
  02DCA0  11A0: 6a00             push 0
  02DCA2  11A2: 6aff             push -1
  02DCA4  11A4: 803e98a801       cmp byte ptr [0xa898], 1
  02DCA9  11A9: 1bc0             sbb ax, ax
  02DCAB  11AB: f7d8             neg ax
  02DCAD  11AD: 50               push ax
  02DCAE  11AE: 68c80d           push 0xdc8
  02DCB1  11B1: 0e               push cs
  02DCB2  11B2: e8aa12           call 0x245f
  02DCB5  11B5: 83c40e           add sp, 0xe
  02DCB8  11B8: 080698a8         or byte ptr [0xa898], al
  02DCBC  11BC: a0a653           mov al, byte ptr [0x53a6]
  02DCBF  11BF: 2ae4             sub ah, ah
  02DCC1  11C1: 2d0a00           sub ax, 0xa
  02DCC4  11C4: f7d8             neg ax
  02DCC6  11C6: 898678ff         mov word ptr [bp - 0x88], ax
  02DCCA  11CA: b96400           mov cx, 0x64
  02DCCD  11CD: 2b8e4aff         sub cx, word ptr [bp - 0xb6]
  02DCD1  11D1: 8b1e4285         mov bx, word ptr [0x8542]
  02DCD5  11D5: 8a471f           mov al, byte ptr [bx + 0x1f]
  02DCD8  11D8: 98               cwde 
  02DCD9  11D9: f7e9             imul cx
  02DCDB  11DB: b96400           mov cx, 0x64
  02DCDE  11DE: 99               cdq 
  02DCDF  11DF: f7f9             idiv cx
  02DCE1  11E1: 894680           mov word ptr [bp - 0x80], ax
  02DCE4  11E4: 3b8678ff         cmp ax, word ptr [bp - 0x88]
  02DCE8  11E8: 7c4a             jl 0x1234
  02DCEA  11EA: f6471c08         test byte ptr [bx + 0x1c], 8
  02DCEE  11EE: 753a             jne 0x122a
  02DCF0  11F0: f606845308       test byte ptr [0x5384], 8
  02DCF5  11F5: 7533             jne 0x122a
  02DCF7  11F7: 8b8678ff         mov ax, word ptr [bp - 0x88]
  02DCFB  11FB: 99               cdq 
  02DCFC  11FC: 52               push dx
  02DCFD  11FD: 50               push ax
  02DCFE  11FE: 6a00             push 0
  02DD00  1200: 9aae091f18       lcall 0x181f, 0x9ae
  02DD05  1205: 83c406           add sp, 6
  02DD08  1208: 6a00             push 0
  02DD0A  120A: 6a05             push 5
  02DD0C  120C: 6a00             push 0
  02DD0E  120E: 6a00             push 0
  02DD10  1210: 6aff             push -1
  02DD12  1212: 803e98a801       cmp byte ptr [0xa898], 1
  02DD17  1217: 1bc0             sbb ax, ax
  02DD19  1219: f7d8             neg ax
  02DD1B  121B: 50               push ax
  02DD1C  121C: 68d10d           push 0xdd1
  02DD1F  121F: 0e               push cs
  02DD20  1220: e83c12           call 0x245f
  02DD23  1223: 83c40e           add sp, 0xe
  02DD26  1226: 080698a8         or byte ptr [0xa898], al
  02DD2A  122A: 8b1e4285         mov bx, word ptr [0x8542]
  02DD2E  122E: 804f1c08         or byte ptr [bx + 0x1c], 8
  02DD32  1232: eb37             jmp 0x126b
  02DD34  1234: f6471c08         test byte ptr [bx + 0x1c], 8
  02DD38  1238: 7429             je 0x1263
  02DD3A  123A: f606845308       test byte ptr [0x5384], 8
  02DD3F  123F: 7522             jne 0x1263
  02DD41  1241: 6a00             push 0
  02DD43  1243: 6a05             push 5
  02DD45  1245: 6a00             push 0
  02DD47  1247: 6a00             push 0
  02DD49  1249: 6aff             push -1
  02DD4B  124B: 803e98a801       cmp byte ptr [0xa898], 1
  02DD50  1250: 1bc0             sbb ax, ax
  02DD52  1252: f7d8             neg ax
  02DD54  1254: 50               push ax
  02DD55  1255: 68dd0d           push 0xddd
  02DD58  1258: 0e               push cs
  02DD59  1259: e80312           call 0x245f
  02DD5C  125C: 83c40e           add sp, 0xe
  02DD5F  125F: 080698a8         or byte ptr [0xa898], al
  02DD63  1263: 8b1e4285         mov bx, word ptr [0x8542]
  02DD67  1267: 80671cf7         and byte ptr [bx + 0x1c], 0xf7
  02DD6B  126B: c7864cff0000     mov word ptr [bp - 0xb4], 0
  02DD71  1271: 83be4cff00       cmp word ptr [bp - 0xb4], 0
  02DD76  1276: 7429             je 0x12a1
  02DD78  1278: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02DD7C  127C: d1e6             shl si, 1
  02DD7E  127E: 8b1e4285         mov bx, word ptr [0x8542]
  02DD82  1282: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02DD86  1286: 2b4698           sub ax, word ptr [bp - 0x68]
  02DD89  1289: 3b821eff         cmp ax, word ptr [bp + si - 0xe2]
  02DD8D  128D: 7e04             jle 0x1293
  02DD8F  128F: 8b821eff         mov ax, word ptr [bp + si - 0xe2]
  02DD93  1293: 89821eff         mov word ptr [bp + si - 0xe2], ax
  02DD97  1297: 0bc0             or ax, ax
  02DD99  1299: 7d02             jge 0x129d
  02DD9B  129B: 2bc0             sub ax, ax
  02DD9D  129D: 89821eff         mov word ptr [bp + si - 0xe2], ax
  02DDA1  12A1: ff864cff         inc word ptr [bp - 0xb4]
  02DDA5  12A5: 83be4cff10       cmp word ptr [bp - 0xb4], 0x10
  02DDAA  12AA: 7cc5             jl 0x1271
  02DDAC  12AC: c7864cff0000     mov word ptr [bp - 0xb4], 0
  02DDB2  12B2: eb35             jmp 0x12e9
  02DDB4  12B4: c7864eff0400     mov word ptr [bp - 0xb2], 4
  02DDBA  12BA: 8b864eff         mov ax, word ptr [bp - 0xb2]
  02DDBE  12BE: 394682           cmp word ptr [bp - 0x7e], ax
  02DDC1  12C1: 7c13             jl 0x12d6
  02DDC3  12C3: 8b46f2           mov ax, word ptr [bp - 0xe]
  02DDC6  12C6: 8b7694           mov si, word ptr [bp - 0x6c]
  02DDC9  12C9: d1e6             shl si, 1
  02DDCB  12CB: 894284           mov word ptr [bp + si - 0x7c], ax
  02DDCE  12CE: ff4694           inc word ptr [bp - 0x6c]
  02DDD1  12D1: c746820000       mov word ptr [bp - 0x7e], 0
  02DDD6  12D6: ff7682           push word ptr [bp - 0x7e]
  02DDD9  12D9: ffb64cff         push word ptr [bp - 0xb4]
  02DDDD  12DD: 9a7e0a1f18       lcall 0x181f, 0xa7e
  02DDE2  12E2: 83c404           add sp, 4
  02DDE5  12E5: ff864cff         inc word ptr [bp - 0xb4]
  02DDE9  12E9: 8b1e4285         mov bx, word ptr [0x8542]
  02DDED  12ED: 8a471f           mov al, byte ptr [bx + 0x1f]
  02DDF0  12F0: 98               cwde 
  02DDF1  12F1: 3b864cff         cmp ax, word ptr [bp - 0xb4]
  02DDF5  12F5: 7f03             jg 0x12fa
  02DDF7  12F7: e9a800           jmp 0x13a2
  02DDFA  12FA: ffb64cff         push word ptr [bp - 0xb4]
  02DDFE  12FE: 9a1c0d1f18       lcall 0x181f, 0xd1c
  02DE03  1303: 83c402           add sp, 2
  02DE06  1306: 894682           mov word ptr [bp - 0x7e], ax
  02DE09  1309: ffb64cff         push word ptr [bp - 0xb4]
  02DE0D  130D: 9a0e0c1f18       lcall 0x181f, 0xc0e
  02DE12  1312: 83c402           add sp, 2
  02DE15  1315: 898640ff         mov word ptr [bp - 0xc0], ax
  02DE19  1319: ff4682           inc word ptr [bp - 0x7e]
  02DE1C  131C: ffb64cff         push word ptr [bp - 0xb4]
  02DE20  1320: 9a540c1f18       lcall 0x181f, 0xc54
  02DE25  1325: 83c402           add sp, 2
  02DE28  1328: 8946f2           mov word ptr [bp - 0xe], ax
  02DE2B  132B: 3d1a00           cmp ax, 0x1a
  02DE2E  132E: 740f             je 0x133f
  02DE30  1330: 3d1900           cmp ax, 0x19
  02DE33  1333: 740a             je 0x133f
  02DE35  1335: 3d1c00           cmp ax, 0x1c
  02DE38  1338: 7405             je 0x133f
  02DE3A  133A: 3d1300           cmp ax, 0x13
  02DE3D  133D: 7512             jne 0x1351
  02DE3F  133F: 8b864cff         mov ax, word ptr [bp - 0xb4]
  02DE43  1343: 8bb63eff         mov si, word ptr [bp - 0xc2]
  02DE47  1347: d1e6             shl si, 1
  02DE49  1349: 8982dcfe         mov word ptr [bp + si - 0x124], ax
  02DE4D  134D: ff863eff         inc word ptr [bp - 0xc2]
  02DE51  1351: 83be40ff12       cmp word ptr [bp - 0xc0], 0x12
  02DE56  1356: 7403             je 0x135b
  02DE58  1358: e97bff           jmp 0x12d6
  02DE5B  135B: 837e9403         cmp word ptr [bp - 0x6c], 3
  02DE5F  135F: 7c03             jl 0x1364
  02DE61  1361: e972ff           jmp 0x12d6
  02DE64  1364: 837ef21c         cmp word ptr [bp - 0xe], 0x1c
  02DE68  1368: 7505             jne 0x136f
  02DE6A  136A: c746f21900       mov word ptr [bp - 0xe], 0x19
  02DE6F  136F: 8b5ef2           mov bx, word ptr [bp - 0xe]
  02DE72  1372: c1e303           shl bx, 3
  02DE75  1375: 8b87a68e         mov ax, word ptr [bx - 0x715a]
  02DE79  1379: 898676ff         mov word ptr [bp - 0x8a], ax
  02DE7D  137D: 3d0400           cmp ax, 4
  02DE80  1380: 7c03             jl 0x1385
  02DE82  1382: e951ff           jmp 0x12d6
  02DE85  1385: 48               dec ax
  02DE86  1386: 7503             jne 0x138b
  02DE88  1388: e929ff           jmp 0x12b4
  02DE8B  138B: 48               dec ax
  02DE8C  138C: 740a             je 0x1398
  02DE8E  138E: c7864eff0800     mov word ptr [bp - 0xb2], 8
  02DE94  1394: e923ff           jmp 0x12ba
  02DE97  1397: 90               nop 
  02DE98  1398: c7864eff0600     mov word ptr [bp - 0xb2], 6
  02DE9E  139E: e919ff           jmp 0x12ba
  02DEA1  13A1: 90               nop 
  02DEA2  13A2: c7864cff0000     mov word ptr [bp - 0xb4], 0
  02DEA8  13A8: e93501           jmp 0x14e0
  02DEAB  13AB: 90               nop 
  02DEAC  13AC: 803e97a800       cmp byte ptr [0xa897], 0
  02DEB1  13B1: 740a             je 0x13bd
  02DEB3  13B3: 6a02             push 2
  02DEB5  13B5: 9a98041f18       lcall 0x181f, 0x498
  02DEBA  13BA: 83c402           add sp, 2
  02DEBD  13BD: 8b863eff         mov ax, word ptr [bp - 0xc2]
  02DEC1  13C1: 48               dec ax
  02DEC2  13C2: 50               push ax
  02DEC3  13C3: 6a00             push 0
  02DEC5  13C5: 9ad4041f18       lcall 0x181f, 0x4d4
  02DECA  13CA: 83c404           add sp, 4
  02DECD  13CD: 8bf0             mov si, ax
  02DECF  13CF: 89769a           mov word ptr [bp - 0x66], si
  02DED2  13D2: d1e6             shl si, 1
  02DED4  13D4: 8b82dcfe         mov ax, word ptr [bp + si - 0x124]
  02DED8  13D8: 8946fc           mov word ptr [bp - 4], ax
  02DEDB  13DB: 8b0e4285         mov cx, word ptr [0x8542]
  02DEDF  13DF: 41               inc cx
  02DEE0  13E0: 41               inc cx
  02DEE1  13E1: 1e               push ds
  02DEE2  13E2: 51               push cx
  02DEE3  13E3: 6a00             push 0
  02DEE5  13E5: 8bf0             mov si, ax
  02DEE7  13E7: 9a16041f18       lcall 0x181f, 0x416
  02DEEC  13EC: 83c406           add sp, 6
  02DEEF  13EF: 56               push si
  02DEF0  13F0: 9a540c1f18       lcall 0x181f, 0xc54
  02DEF5  13F5: 83c402           add sp, 2
  02DEF8  13F8: 8946f2           mov word ptr [bp - 0xe], ax
  02DEFB  13FB: 3d1a00           cmp ax, 0x1a
  02DEFE  13FE: 7530             jne 0x1430
  02DF00  1400: 6a19             push 0x19
  02DF02  1402: 56               push si
  02DF03  1403: 9aae0c1f18       lcall 0x181f, 0xcae
  02DF08  1408: 83c404           add sp, 4
  02DF0B  140B: f606845380       test byte ptr [0x5384], 0x80
  02DF10  1410: 7403             je 0x1415
  02DF12  1412: e9a100           jmp 0x14b6
  02DF15  1415: 682580           push 0x8025
  02DF18  1418: 6a02             push 2
  02DF1A  141A: 6a00             push 0
  02DF1C  141C: 6a00             push 0
  02DF1E  141E: 6aff             push -1
  02DF20  1420: 803e98a801       cmp byte ptr [0xa898], 1
  02DF25  1425: 1bc0             sbb ax, ax
  02DF27  1427: f7d8             neg ax
  02DF29  1429: 50               push ax
  02DF2A  142A: 68f10d           push 0xdf1
  02DF2D  142D: eb7c             jmp 0x14ab
  02DF2F  142F: 90               nop 
  02DF30  1430: 3d1900           cmp ax, 0x19
  02DF33  1433: 752f             jne 0x1464
  02DF35  1435: 6a1c             push 0x1c
  02DF37  1437: ff76fc           push word ptr [bp - 4]
  02DF3A  143A: 9aae0c1f18       lcall 0x181f, 0xcae
  02DF3F  143F: 83c404           add sp, 4
  02DF42  1442: f606845380       test byte ptr [0x5384], 0x80
  02DF47  1447: 756d             jne 0x14b6
  02DF49  1449: 682580           push 0x8025
  02DF4C  144C: 6a02             push 2
  02DF4E  144E: 6a00             push 0
  02DF50  1450: 6a00             push 0
  02DF52  1452: 6aff             push -1
  02DF54  1454: 803e98a801       cmp byte ptr [0xa898], 1
  02DF59  1459: 1bc0             sbb ax, ax
  02DF5B  145B: f7d8             neg ax
  02DF5D  145D: 50               push ax
  02DF5E  145E: 68ff0d           push 0xdff
  02DF61  1461: eb48             jmp 0x14ab
  02DF63  1463: 90               nop 
  02DF64  1464: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02DF68  1468: d1e6             shl si, 1
  02DF6A  146A: ff7284           push word ptr [bp + si - 0x7c]
  02DF6D  146D: ff76fc           push word ptr [bp - 4]
  02DF70  1470: 9aae0c1f18       lcall 0x181f, 0xcae
  02DF75  1475: 83c404           add sp, 4
  02DF78  1478: 8b5a84           mov bx, word ptr [bp + si - 0x7c]
  02DF7B  147B: c1e303           shl bx, 3
  02DF7E  147E: ffb7a28e         push word ptr [bx - 0x715e]
  02DF82  1482: 6a01             push 1
  02DF84  1484: 9a38041f18       lcall 0x181f, 0x438
  02DF89  1489: 83c404           add sp, 4
  02DF8C  148C: f606845380       test byte ptr [0x5384], 0x80
  02DF91  1491: 7523             jne 0x14b6
  02DF93  1493: 682580           push 0x8025
  02DF96  1496: 6a02             push 2
  02DF98  1498: 6a00             push 0
  02DF9A  149A: 6a00             push 0
  02DF9C  149C: 6aff             push -1
  02DF9E  149E: 803e98a801       cmp byte ptr [0xa898], 1
  02DFA3  14A3: 1bc0             sbb ax, ax
  02DFA5  14A5: f7d8             neg ax
  02DFA7  14A7: 50               push ax
  02DFA8  14A8: 680f0e           push 0xe0f
  02DFAB  14AB: 0e               push cs
  02DFAC  14AC: e8b00f           call 0x245f
  02DFAF  14AF: 83c40e           add sp, 0xe
  02DFB2  14B2: 080698a8         or byte ptr [0xa898], al
  02DFB6  14B6: 8b469a           mov ax, word ptr [bp - 0x66]
  02DFB9  14B9: 8946fc           mov word ptr [bp - 4], ax
  02DFBC  14BC: eb10             jmp 0x14ce
  02DFBE  14BE: 8b76fc           mov si, word ptr [bp - 4]
  02DFC1  14C1: d1e6             shl si, 1
  02DFC3  14C3: 8b82defe         mov ax, word ptr [bp + si - 0x122]
  02DFC7  14C7: 8982dcfe         mov word ptr [bp + si - 0x124], ax
  02DFCB  14CB: ff46fc           inc word ptr [bp - 4]
  02DFCE  14CE: 8b863eff         mov ax, word ptr [bp - 0xc2]
  02DFD2  14D2: 48               dec ax
  02DFD3  14D3: 3b46fc           cmp ax, word ptr [bp - 4]
  02DFD6  14D6: 7fe6             jg 0x14be
  02DFD8  14D8: ff8e3eff         dec word ptr [bp - 0xc2]
  02DFDC  14DC: ff864cff         inc word ptr [bp - 0xb4]
  02DFE0  14E0: 8b864cff         mov ax, word ptr [bp - 0xb4]
  02DFE4  14E4: 394694           cmp word ptr [bp - 0x6c], ax
  02DFE7  14E7: 7e2d             jle 0x1516
  02DFE9  14E9: 83be3eff00       cmp word ptr [bp - 0xc2], 0
  02DFEE  14EE: 7403             je 0x14f3
  02DFF0  14F0: e9b9fe           jmp 0x13ac
  02DFF3  14F3: 682580           push 0x8025
  02DFF6  14F6: 6a02             push 2
  02DFF8  14F8: 6a00             push 0
  02DFFA  14FA: 6a00             push 0
  02DFFC  14FC: 6aff             push -1
  02DFFE  14FE: 803e98a801       cmp byte ptr [0xa898], 1
  02E003  1503: 1bc0             sbb ax, ax
  02E005  1505: f7d8             neg ax
  02E007  1507: 50               push ax
  02E008  1508: 68e70d           push 0xde7
  02E00B  150B: 0e               push cs
  02E00C  150C: e8500f           call 0x245f
  02E00F  150F: 83c40e           add sp, 0xe
  02E012  1512: 080698a8         or byte ptr [0xa898], al
  02E016  1516: c7864cff0000     mov word ptr [bp - 0xb4], 0
  02E01C  151C: eb0f             jmp 0x152d
  02E01E  151E: 8b9e40ff         mov bx, word ptr [bp - 0xc0]
  02E022  1522: 80bf309400       cmp byte ptr [bx - 0x6bd0], 0
  02E027  1527: 7457             je 0x1580
  02E029  1529: ff864cff         inc word ptr [bp - 0xb4]
  02E02D  152D: 8b1e4285         mov bx, word ptr [0x8542]
  02E031  1531: 8a471f           mov al, byte ptr [bx + 0x1f]
  02E034  1534: 98               cwde 
  02E035  1535: 3b864cff         cmp ax, word ptr [bp - 0xb4]
  02E039  1539: 7f03             jg 0x153e
  02E03B  153B: e9cc00           jmp 0x160a
  02E03E  153E: ffb64cff         push word ptr [bp - 0xb4]
  02E042  1542: 9a0e0c1f18       lcall 0x181f, 0xc0e
  02E047  1547: 83c402           add sp, 2
  02E04A  154A: 898640ff         mov word ptr [bp - 0xc0], ax
  02E04E  154E: ffb64cff         push word ptr [bp - 0xb4]
  02E052  1552: 9a540c1f18       lcall 0x181f, 0xc54
  02E057  1557: 83c402           add sp, 2
  02E05A  155A: 898642ff         mov word ptr [bp - 0xbe], ax
  02E05E  155E: 3d1b00           cmp ax, 0x1b
  02E061  1561: 74c6             je 0x1529
  02E063  1563: 50               push ax
  02E064  1564: 9a9a0c1f18       lcall 0x181f, 0xc9a
  02E069  1569: 83c402           add sp, 2
  02E06C  156C: 0bc0             or ax, ax
  02E06E  156E: 75b9             jne 0x1529
  02E070  1570: 83be40ff01       cmp word ptr [bp - 0xc0], 1
  02E075  1575: 7cb2             jl 0x1529
  02E077  1577: 83be40ff04       cmp word ptr [bp - 0xc0], 4
  02E07C  157C: 7ea0             jle 0x151e
  02E07E  157E: eba9             jmp 0x1529
  02E080  1580: c746a06300       mov word ptr [bp - 0x60], 0x63
  02E085  1585: 83be42ff19       cmp word ptr [bp - 0xbe], 0x19
  02E08A  158A: 7505             jne 0x1591
  02E08C  158C: c746a0c700       mov word ptr [bp - 0x60], 0xc7
  02E091  1591: 83be42ff1a       cmp word ptr [bp - 0xbe], 0x1a
  02E096  1596: 7505             jne 0x159d
  02E098  1598: 8146a0c800       add word ptr [bp - 0x60], 0xc8
  02E09D  159D: ff76a0           push word ptr [bp - 0x60]
  02E0A0  15A0: 50               push ax
  02E0A1  15A1: 9ad4041f18       lcall 0x181f, 0x4d4
  02E0A6  15A6: 83c404           add sp, 4
  02E0A9  15A9: 0bc0             or ax, ax
  02E0AB  15AB: 7403             je 0x15b0
  02E0AD  15AD: e979ff           jmp 0x1529
  02E0B0  15B0: 8b9e40ff         mov bx, word ptr [bp - 0xc0]
  02E0B4  15B4: fe873094         inc byte ptr [bx - 0x6bd0]
  02E0B8  15B8: 53               push bx
  02E0B9  15B9: ffb64cff         push word ptr [bp - 0xb4]
  02E0BD  15BD: 9aae0c1f18       lcall 0x181f, 0xcae
  02E0C2  15C2: 83c404           add sp, 4
  02E0C5  15C5: 8b9e40ff         mov bx, word ptr [bp - 0xc0]
  02E0C9  15C9: c1e303           shl bx, 3
  02E0CC  15CC: ffb7a28e         push word ptr [bx - 0x715e]
  02E0D0  15D0: 6a01             push 1
  02E0D2  15D2: 9a38041f18       lcall 0x181f, 0x438
  02E0D7  15D7: 83c404           add sp, 4
  02E0DA  15DA: f606845380       test byte ptr [0x5384], 0x80
  02E0DF  15DF: 7403             je 0x15e4
  02E0E1  15E1: e945ff           jmp 0x1529
  02E0E4  15E4: 682580           push 0x8025
  02E0E7  15E7: 6a02             push 2
  02E0E9  15E9: 6a00             push 0
  02E0EB  15EB: 6a00             push 0
  02E0ED  15ED: 6aff             push -1
  02E0EF  15EF: 803e98a801       cmp byte ptr [0xa898], 1
  02E0F4  15F4: 1bc0             sbb ax, ax
  02E0F6  15F6: f7d8             neg ax
  02E0F8  15F8: 50               push ax
  02E0F9  15F9: 681f0e           push 0xe1f
  02E0FC  15FC: 0e               push cs
  02E0FD  15FD: e85f0e           call 0x245f
  02E100  1600: 83c40e           add sp, 0xe
  02E103  1603: 080698a8         or byte ptr [0xa898], al
  02E107  1607: e91fff           jmp 0x1529
  02E10A  160A: 6a00             push 0
  02E10C  160C: 6a00             push 0
  02E10E  160E: 9ab80c1f18       lcall 0x181f, 0xcb8
  02E113  1613: 83c404           add sp, 4
  02E116  1616: 89469e           mov word ptr [bp - 0x62], ax
  02E119  1619: 8b1e4285         mov bx, word ptr [0x8542]
  02E11D  161D: 39879a00         cmp word ptr [bx + 0x9a], ax
  02E121  1621: 7c41             jl 0x1664
  02E123  1623: 29879a00         sub word ptr [bx + 0x9a], ax
  02E127  1627: 8a4701           mov al, byte ptr [bx + 1]
  02E12A  162A: 2ae4             sub ah, ah
  02E12C  162C: 50               push ax
  02E12D  162D: 8a07             mov al, byte ptr [bx]
  02E12F  162F: 50               push ax
  02E130  1630: ffb6d6fe         push word ptr [bp - 0x12a]
  02E134  1634: 6a00             push 0
  02E136  1636: 9a5c091f18       lcall 0x181f, 0x95c
  02E13B  163B: 83c408           add sp, 8
  02E13E  163E: 89867aff         mov word ptr [bp - 0x86], ax
  02E142  1642: 6a00             push 0
  02E144  1644: 6a04             push 4
  02E146  1646: 6a00             push 0
  02E148  1648: 6a00             push 0
  02E14A  164A: 6aff             push -1
  02E14C  164C: 803e98a801       cmp byte ptr [0xa898], 1
  02E151  1651: 1bc0             sbb ax, ax
  02E153  1653: f7d8             neg ax
  02E155  1655: 50               push ax
  02E156  1656: 682f0e           push 0xe2f
  02E159  1659: 0e               push cs
  02E15A  165A: e8020e           call 0x245f
  02E15D  165D: 83c40e           add sp, 0xe
  02E160  1660: 080698a8         or byte ptr [0xa898], al
  02E164  1664: 83bed6fe04       cmp word ptr [bp - 0x12a], 4
  02E169  1669: 7d0c             jge 0x1677
  02E16B  166B: 6b9ed6fe34       imul bx, word ptr [bp - 0x12a], 0x34
  02E170  1670: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02E175  1675: 740d             je 0x1684
  02E177  1677: 833e5a8e03       cmp word ptr [0x8e5a], 3
  02E17C  167C: 7d06             jge 0x1684
  02E17E  167E: c7065a8e0000     mov word ptr [0x8e5a], 0
  02E184  1684: 833e5a8e00       cmp word ptr [0x8e5a], 0
  02E189  1689: 7503             jne 0x168e
  02E18B  168B: e97c01           jmp 0x180a
  02E18E  168E: ff36a683         push word ptr [0x83a6]
  02E192  1692: 9aca041f18       lcall 0x181f, 0x4ca
  02E197  1697: 83c402           add sp, 2
  02E19A  169A: 833e8c5301       cmp word ptr [0x538c], 1
  02E19F  169F: 1bc0             sbb ax, ax
  02E1A1  16A1: f7d8             neg ax
  02E1A3  16A3: 898650ff         mov word ptr [bp - 0xb0], ax
  02E1A7  16A7: c786d4fe0100     mov word ptr [bp - 0x12c], 1
  02E1AD  16AD: 837e9600         cmp word ptr [bp - 0x6a], 0
  02E1B1  16B1: 7406             je 0x16b9
  02E1B3  16B3: c786d4fe0000     mov word ptr [bp - 0x12c], 0
  02E1B9  16B9: 803ea65301       cmp byte ptr [0x53a6], 1
  02E1BE  16BE: 7726             ja 0x16e6
  02E1C0  16C0: 813e8a53f005     cmp word ptr [0x538a], 0x5f0
  02E1C6  16C6: 7c18             jl 0x16e0
  02E1C8  16C8: a0a653           mov al, byte ptr [0x53a6]
  02E1CB  16CB: 2ae4             sub ah, ah
  02E1CD  16CD: 48               dec ax
  02E1CE  16CE: 48               dec ax
  02E1CF  16CF: f7d8             neg ax
  02E1D1  16D1: 50               push ax
  02E1D2  16D2: 6a00             push 0
  02E1D4  16D4: 9ad4041f18       lcall 0x181f, 0x4d4
  02E1D9  16D9: 83c404           add sp, 4
  02E1DC  16DC: 0bc0             or ax, ax
  02E1DE  16DE: 7406             je 0x16e6
  02E1E0  16E0: c786d4fe0000     mov word ptr [bp - 0x12c], 0
  02E1E6  16E6: 83bed4fe00       cmp word ptr [bp - 0x12c], 0
  02E1EB  16EB: 754d             jne 0x173a
  02E1ED  16ED: 803e97a800       cmp byte ptr [0xa897], 0
  02E1F2  16F2: 740a             je 0x16fe
  02E1F4  16F4: 6a01             push 1
  02E1F6  16F6: 9ab6041f18       lcall 0x181f, 0x4b6
  02E1FB  16FB: 83c402           add sp, 2
  02E1FE  16FE: 83be50ff00       cmp word ptr [bp - 0xb0], 0
  02E203  1703: 741b             je 0x1720
  02E205  1705: 6a00             push 0
  02E207  1707: 6a05             push 5
  02E209  1709: 6a00             push 0
  02E20B  170B: 6a00             push 0
  02E20D  170D: 6a00             push 0
  02E20F  170F: 803e98a801       cmp byte ptr [0xa898], 1
  02E214  1714: 1bc0             sbb ax, ax
  02E216  1716: f7d8             neg ax
  02E218  1718: 50               push ax
  02E219  1719: 683b0e           push 0xe3b
  02E21C  171C: e99400           jmp 0x17b3
  02E21F  171F: 90               nop 
  02E220  1720: 6a00             push 0
  02E222  1722: 6a05             push 5
  02E224  1724: 6a00             push 0
  02E226  1726: 6a00             push 0
  02E228  1728: 6a00             push 0
  02E22A  172A: 803e98a801       cmp byte ptr [0xa898], 1
  02E22F  172F: 1bc0             sbb ax, ax
  02E231  1731: f7d8             neg ax
  02E233  1733: 50               push ax
  02E234  1734: 68410e           push 0xe41
  02E237  1737: eb7a             jmp 0x17b3
  02E239  1739: 90               nop 
  02E23A  173A: 8b1e4285         mov bx, word ptr [0x8542]
  02E23E  173E: 8a471f           mov al, byte ptr [bx + 0x1f]
  02E241  1741: 98               cwde 
  02E242  1742: 3b86d4fe         cmp ax, word ptr [bp - 0x12c]
  02E246  1746: 7522             jne 0x176a
  02E248  1748: 803e97a800       cmp byte ptr [0xa897], 0
  02E24D  174D: 740a             je 0x1759
  02E24F  174F: 6a01             push 1
  02E251  1751: 9aac041f18       lcall 0x181f, 0x4ac
  02E256  1756: 83c402           add sp, 2
  02E259  1759: 6a00             push 0
  02E25B  175B: 6a05             push 5
  02E25D  175D: 6a00             push 0
  02E25F  175F: 6a00             push 0
  02E261  1761: 6aff             push -1
  02E263  1763: 6a00             push 0
  02E265  1765: 68470e           push 0xe47
  02E268  1768: eb49             jmp 0x17b3
  02E26A  176A: 803e97a800       cmp byte ptr [0xa897], 0
  02E26F  176F: 740a             je 0x177b
  02E271  1771: 6a01             push 1
  02E273  1773: 9aac041f18       lcall 0x181f, 0x4ac
  02E278  1778: 83c402           add sp, 2
  02E27B  177B: 83be50ff00       cmp word ptr [bp - 0xb0], 0
  02E280  1780: 741a             je 0x179c
  02E282  1782: 6a00             push 0
  02E284  1784: 6a05             push 5
  02E286  1786: 6a00             push 0
  02E288  1788: 6a00             push 0
  02E28A  178A: 6a00             push 0
  02E28C  178C: 803e98a801       cmp byte ptr [0xa898], 1
  02E291  1791: 1bc0             sbb ax, ax
  02E293  1793: f7d8             neg ax
  02E295  1795: 50               push ax
  02E296  1796: 684e0e           push 0xe4e
  02E299  1799: eb18             jmp 0x17b3
  02E29B  179B: 90               nop 
  02E29C  179C: 6a00             push 0
  02E29E  179E: 6a05             push 5
  02E2A0  17A0: 6a00             push 0
  02E2A2  17A2: 6a00             push 0
  02E2A4  17A4: 6a00             push 0
  02E2A6  17A6: 803e98a801       cmp byte ptr [0xa898], 1
  02E2AB  17AB: 1bc0             sbb ax, ax
  02E2AD  17AD: f7d8             neg ax
  02E2AF  17AF: 50               push ax
  02E2B0  17B0: 68560e           push 0xe56
  02E2B3  17B3: 0e               push cs
  02E2B4  17B4: e8a80c           call 0x245f
  02E2B7  17B7: 83c40e           add sp, 0xe
  02E2BA  17BA: 080698a8         or byte ptr [0xa898], al
  02E2BE  17BE: c7864cff0000     mov word ptr [bp - 0xb4], 0
  02E2C4  17C4: eb24             jmp 0x17ea
  02E2C6  17C6: 8b1e4285         mov bx, word ptr [0x8542]
  02E2CA  17CA: 8a471f           mov al, byte ptr [bx + 0x1f]
  02E2CD  17CD: 98               cwde 
  02E2CE  17CE: 48               dec ax
  02E2CF  17CF: 50               push ax
  02E2D0  17D0: 6a00             push 0
  02E2D2  17D2: 9ad4041f18       lcall 0x181f, 0x4d4
  02E2D7  17D7: 83c404           add sp, 4
  02E2DA  17DA: 89468a           mov word ptr [bp - 0x76], ax
  02E2DD  17DD: 50               push ax
  02E2DE  17DE: 9a9c0a1f18       lcall 0x181f, 0xa9c
  02E2E3  17E3: 83c402           add sp, 2
  02E2E6  17E6: ff864cff         inc word ptr [bp - 0xb4]
  02E2EA  17EA: 8b864cff         mov ax, word ptr [bp - 0xb4]
  02E2EE  17EE: 3986d4fe         cmp word ptr [bp - 0x12c], ax
  02E2F2  17F2: 7fd2             jg 0x17c6
  02E2F4  17F4: 8b1e4285         mov bx, word ptr [0x8542]
  02E2F8  17F8: 807f1f00         cmp byte ptr [bx + 0x1f], 0
  02E2FC  17FC: 7572             jne 0x1870
  02E2FE  17FE: ff36c68d         push word ptr [0x8dc6]
  02E302  1802: 0e               push cs
  02E303  1803: e8400c           call 0x2446
  02E306  1806: e9a607           jmp 0x1faf
  02E309  1809: 90               nop 
  02E30A  180A: 833e328e00       cmp word ptr [0x8e32], 0
  02E30F  180F: 745f             je 0x1870
  02E311  1811: a1328e           mov ax, word ptr [0x8e32]
  02E314  1814: c1e002           shl ax, 2
  02E317  1817: 8b1e4285         mov bx, word ptr [0x8542]
  02E31B  181B: 3b879a00         cmp ax, word ptr [bx + 0x9a]
  02E31F  181F: 7e4f             jle 0x1870
  02E321  1821: f606845340       test byte ptr [0x5384], 0x40
  02E326  1826: 7548             jne 0x1870
  02E328  1828: 803e97a800       cmp byte ptr [0xa897], 0
  02E32D  182D: 740a             je 0x1839
  02E32F  182F: 6a01             push 1
  02E331  1831: 9a98041f18       lcall 0x181f, 0x498
  02E336  1836: 83c402           add sp, 2
  02E339  1839: 8b1e4285         mov bx, word ptr [0x8542]
  02E33D  183D: 8b879a00         mov ax, word ptr [bx + 0x9a]
  02E341  1841: 99               cdq 
  02E342  1842: 52               push dx
  02E343  1843: 50               push ax
  02E344  1844: 6a00             push 0
  02E346  1846: 9aae091f18       lcall 0x181f, 0x9ae
  02E34B  184B: 83c406           add sp, 6
  02E34E  184E: 6a00             push 0
  02E350  1850: 6a05             push 5
  02E352  1852: 6a00             push 0
  02E354  1854: 6a00             push 0
  02E356  1856: 6aff             push -1
  02E358  1858: 803e98a801       cmp byte ptr [0xa898], 1
  02E35D  185D: 1bc0             sbb ax, ax
  02E35F  185F: f7d8             neg ax
  02E361  1861: 50               push ax
  02E362  1862: 685e0e           push 0xe5e
  02E365  1865: 0e               push cs
  02E366  1866: e8f60b           call 0x245f
  02E369  1869: 83c40e           add sp, 0xe
  02E36C  186C: 080698a8         or byte ptr [0xa898], al
  02E370  1870: f606845320       test byte ptr [0x5384], 0x20
  02E375  1875: 7403             je 0x187a
  02E377  1877: e98501           jmp 0x19ff
  02E37A  187A: 833e648e00       cmp word ptr [0x8e64], 0
  02E37F  187F: 742e             je 0x18af
  02E381  1881: 6a00             push 0
  02E383  1883: 6a10             push 0x10
  02E385  1885: 9a500b1f18       lcall 0x181f, 0xb50
  02E38A  188A: 83c404           add sp, 4
  02E38D  188D: 0bc0             or ax, ax
  02E38F  188F: 751e             jne 0x18af
  02E391  1891: 50               push ax
  02E392  1892: 6a05             push 5
  02E394  1894: 50               push ax
  02E395  1895: 50               push ax
  02E396  1896: 50               push ax
  02E397  1897: 803e98a801       cmp byte ptr [0xa898], 1
  02E39C  189C: 1bc0             sbb ax, ax
  02E39E  189E: f7d8             neg ax
  02E3A0  18A0: 50               push ax
  02E3A1  18A1: 68660e           push 0xe66
  02E3A4  18A4: 0e               push cs
  02E3A5  18A5: e8b70b           call 0x245f
  02E3A8  18A8: 83c40e           add sp, 0xe
  02E3AB  18AB: 080698a8         or byte ptr [0xa898], al
  02E3AF  18AF: 833e608e00       cmp word ptr [0x8e60], 0
  02E3B4  18B4: 742e             je 0x18e4
  02E3B6  18B6: 6a00             push 0
  02E3B8  18B8: 6a0b             push 0xb
  02E3BA  18BA: 9a500b1f18       lcall 0x181f, 0xb50
  02E3BF  18BF: 83c404           add sp, 4
  02E3C2  18C2: 0bc0             or ax, ax
  02E3C4  18C4: 751e             jne 0x18e4
  02E3C6  18C6: 50               push ax
  02E3C7  18C7: 6a05             push 5
  02E3C9  18C9: 50               push ax
  02E3CA  18CA: 50               push ax
  02E3CB  18CB: 50               push ax
  02E3CC  18CC: 803e98a801       cmp byte ptr [0xa898], 1
  02E3D1  18D1: 1bc0             sbb ax, ax
  02E3D3  18D3: f7d8             neg ax
  02E3D5  18D5: 50               push ax
  02E3D6  18D6: 686d0e           push 0xe6d
  02E3D9  18D9: 0e               push cs
  02E3DA  18DA: e8820b           call 0x245f
  02E3DD  18DD: 83c40e           add sp, 0xe
  02E3E0  18E0: 080698a8         or byte ptr [0xa898], al
  02E3E4  18E4: 833e5e8e00       cmp word ptr [0x8e5e], 0
  02E3E9  18E9: 742e             je 0x1919
  02E3EB  18EB: 6a00             push 0
  02E3ED  18ED: 6a0a             push 0xa
  02E3EF  18EF: 9a500b1f18       lcall 0x181f, 0xb50
  02E3F4  18F4: 83c404           add sp, 4
  02E3F7  18F7: 0bc0             or ax, ax
  02E3F9  18F9: 751e             jne 0x1919
  02E3FB  18FB: 50               push ax
  02E3FC  18FC: 6a05             push 5
  02E3FE  18FE: 50               push ax
  02E3FF  18FF: 50               push ax
  02E400  1900: 50               push ax
  02E401  1901: 803e98a801       cmp byte ptr [0xa898], 1
  02E406  1906: 1bc0             sbb ax, ax
  02E408  1908: f7d8             neg ax
  02E40A  190A: 50               push ax
  02E40B  190B: 68740e           push 0xe74
  02E40E  190E: 0e               push cs
  02E40F  190F: e84d0b           call 0x245f
  02E412  1912: 83c40e           add sp, 0xe
  02E415  1915: 080698a8         or byte ptr [0xa898], al
  02E419  1919: 833e5c8e00       cmp word ptr [0x8e5c], 0
  02E41E  191E: 742e             je 0x194e
  02E420  1920: 6a00             push 0
  02E422  1922: 6a09             push 9
  02E424  1924: 9a500b1f18       lcall 0x181f, 0xb50
  02E429  1929: 83c404           add sp, 4
  02E42C  192C: 0bc0             or ax, ax
  02E42E  192E: 751e             jne 0x194e
  02E430  1930: 50               push ax
  02E431  1931: 6a05             push 5
  02E433  1933: 50               push ax
  02E434  1934: 50               push ax
  02E435  1935: 50               push ax
  02E436  1936: 803e98a801       cmp byte ptr [0xa898], 1
  02E43B  193B: 1bc0             sbb ax, ax
  02E43D  193D: f7d8             neg ax
  02E43F  193F: 50               push ax
  02E440  1940: 687c0e           push 0xe7c
  02E443  1943: 0e               push cs
  02E444  1944: e8180b           call 0x245f
  02E447  1947: 83c40e           add sp, 0xe
  02E44A  194A: 080698a8         or byte ptr [0xa898], al
  02E44E  194E: 833e628e00       cmp word ptr [0x8e62], 0
  02E453  1953: 742e             je 0x1983
  02E455  1955: 6a00             push 0
  02E457  1957: 6a0c             push 0xc
  02E459  1959: 9a500b1f18       lcall 0x181f, 0xb50
  02E45E  195E: 83c404           add sp, 4
  02E461  1961: 0bc0             or ax, ax
  02E463  1963: 751e             jne 0x1983
  02E465  1965: 50               push ax
  02E466  1966: 6a05             push 5
  02E468  1968: 50               push ax
  02E469  1969: 50               push ax
  02E46A  196A: 50               push ax
  02E46B  196B: 803e98a801       cmp byte ptr [0xa898], 1
  02E470  1970: 1bc0             sbb ax, ax
  02E472  1972: f7d8             neg ax
  02E474  1974: 50               push ax
  02E475  1975: 68860e           push 0xe86
  02E478  1978: 0e               push cs
  02E479  1979: e8e30a           call 0x245f
  02E47C  197C: 83c40e           add sp, 0xe
  02E47F  197F: 080698a8         or byte ptr [0xa898], al
  02E483  1983: 833e668e00       cmp word ptr [0x8e66], 0
  02E488  1988: 7440             je 0x19ca
  02E48A  198A: 6a00             push 0
  02E48C  198C: 6a0f             push 0xf
  02E48E  198E: 9a500b1f18       lcall 0x181f, 0xb50
  02E493  1993: 83c404           add sp, 4
  02E496  1996: 6a00             push 0
  02E498  1998: 6a0e             push 0xe
  02E49A  199A: 8bf0             mov si, ax
  02E49C  199C: 9a500b1f18       lcall 0x181f, 0xb50
  02E4A1  19A1: 83c404           add sp, 4
  02E4A4  19A4: 3bc6             cmp ax, si
  02E4A6  19A6: 7522             jne 0x19ca
  02E4A8  19A8: 6a00             push 0
  02E4AA  19AA: 6a05             push 5
  02E4AC  19AC: 6a00             push 0
  02E4AE  19AE: 6a00             push 0
  02E4B0  19B0: 6a00             push 0
  02E4B2  19B2: 803e98a801       cmp byte ptr [0xa898], 1
  02E4B7  19B7: 1bc0             sbb ax, ax
  02E4B9  19B9: f7d8             neg ax
  02E4BB  19BB: 50               push ax
  02E4BC  19BC: 688b0e           push 0xe8b
  02E4BF  19BF: 0e               push cs
  02E4C0  19C0: e89c0a           call 0x245f
  02E4C3  19C3: 83c40e           add sp, 0xe
  02E4C6  19C6: 080698a8         or byte ptr [0xa898], al
  02E4CA  19CA: 833e768e00       cmp word ptr [0x8e76], 0
  02E4CF  19CF: 742e             je 0x19ff
  02E4D1  19D1: 6a00             push 0
  02E4D3  19D3: 6a0f             push 0xf
  02E4D5  19D5: 9a500b1f18       lcall 0x181f, 0xb50
  02E4DA  19DA: 83c404           add sp, 4
  02E4DD  19DD: 0bc0             or ax, ax
  02E4DF  19DF: 751e             jne 0x19ff
  02E4E1  19E1: 50               push ax
  02E4E2  19E2: 6a05             push 5
  02E4E4  19E4: 50               push ax
  02E4E5  19E5: 50               push ax
  02E4E6  19E6: 50               push ax
  02E4E7  19E7: 803e98a801       cmp byte ptr [0xa898], 1
  02E4EC  19EC: 1bc0             sbb ax, ax
  02E4EE  19EE: f7d8             neg ax
  02E4F0  19F0: 50               push ax
  02E4F1  19F1: 688f0e           push 0xe8f
  02E4F4  19F4: 0e               push cs
  02E4F5  19F5: e8670a           call 0x245f
  02E4F8  19F8: 83c40e           add sp, 0xe
  02E4FB  19FB: 080698a8         or byte ptr [0xa898], al
  02E4FF  19FF: 6a00             push 0
  02E501  1A01: 6a10             push 0x10
  02E503  1A03: 9a500b1f18       lcall 0x181f, 0xb50
  02E508  1A08: 83c404           add sp, 4
  02E50B  1A0B: 8b1e4285         mov bx, word ptr [0x8542]
  02E50F  1A0F: 01879200         add word ptr [bx + 0x92], ax
  02E513  1A13: 8b1e4285         mov bx, word ptr [0x8542]
  02E517  1A17: 8b879200         mov ax, word ptr [bx + 0x92]
  02E51B  1A1B: 0bc0             or ax, ax
  02E51D  1A1D: 7d02             jge 0x1a21
  02E51F  1A1F: 2bc0             sub ax, ax
  02E521  1A21: 89879200         mov word ptr [bx + 0x92], ax
  02E525  1A25: 8d46f4           lea ax, [bp - 0xc]
  02E528  1A28: 50               push ax
  02E529  1A29: 8a879400         mov al, byte ptr [bx + 0x94]
  02E52D  1A2D: 98               cwde 
  02E52E  1A2E: 50               push ax
  02E52F  1A2F: 9ac40a1f18       lcall 0x181f, 0xac4
  02E534  1A34: 83c404           add sp, 4
  02E537  1A37: 8b1e4285         mov bx, word ptr [0x8542]
  02E53B  1A3B: 3b879200         cmp ax, word ptr [bx + 0x92]
  02E53F  1A3F: 7e03             jle 0x1a44
  02E541  1A41: e96b01           jmp 0x1baf
  02E544  1A44: 80bf940000       cmp byte ptr [bx + 0x94], 0
  02E549  1A49: 7d03             jge 0x1a4e
  02E54B  1A4B: e96101           jmp 0x1baf
  02E54E  1A4E: 8d4692           lea ax, [bp - 0x6e]
  02E551  1A51: 50               push ax
  02E552  1A52: 8a879400         mov al, byte ptr [bx + 0x94]
  02E556  1A56: 98               cwde 
  02E557  1A57: 50               push ax
  02E558  1A58: 9ac20c1f18       lcall 0x181f, 0xcc2
  02E55D  1A5D: 83c404           add sp, 4
  02E560  1A60: 89867eff         mov word ptr [bp - 0x82], ax
  02E564  1A64: 48               dec ax
  02E565  1A65: 756f             jne 0x1ad6
  02E567  1A67: ff7692           push word ptr [bp - 0x6e]
  02E56A  1A6A: 9afc091f18       lcall 0x181f, 0x9fc
  02E56F  1A6F: 83c402           add sp, 2
  02E572  1A72: 0bc0             or ax, ax
  02E574  1A74: 7460             je 0x1ad6
  02E576  1A76: 8b1e4285         mov bx, word ptr [0x8542]
  02E57A  1A7A: 804f1c80         or byte ptr [bx + 0x1c], 0x80
  02E57E  1A7E: 83bed6fe04       cmp word ptr [bp - 0x12a], 4
  02E583  1A83: 7c03             jl 0x1a88
  02E585  1A85: e92f01           jmp 0x1bb7
  02E588  1A88: 6bb6d6fe34       imul si, word ptr [bp - 0x12a], 0x34
  02E58D  1A8D: 80bc3f5400       cmp byte ptr [si + 0x543f], 0
  02E592  1A92: 7403             je 0x1a97
  02E594  1A94: e92001           jmp 0x1bb7
  02E597  1A97: 8a879400         mov al, byte ptr [bx + 0x94]
  02E59B  1A9B: 98               cwde 
  02E59C  1A9C: 50               push ax
  02E59D  1A9D: 9a4e0d1f18       lcall 0x181f, 0xd4e
  02E5A2  1AA2: 83c402           add sp, 2
  02E5A5  1AA5: 52               push dx
  02E5A6  1AA6: 50               push ax
  02E5A7  1AA7: 6a01             push 1
  02E5A9  1AA9: 9a16041f18       lcall 0x181f, 0x416
  02E5AE  1AAE: 83c406           add sp, 6
  02E5B1  1AB1: 6a00             push 0
  02E5B3  1AB3: 6a05             push 5
  02E5B5  1AB5: 6a00             push 0
  02E5B7  1AB7: 6a00             push 0
  02E5B9  1AB9: 6a02             push 2
  02E5BB  1ABB: 803e98a801       cmp byte ptr [0xa898], 1
  02E5C0  1AC0: 1bc0             sbb ax, ax
  02E5C2  1AC2: f7d8             neg ax
  02E5C4  1AC4: 50               push ax
  02E5C5  1AC5: 68950e           push 0xe95
  02E5C8  1AC8: 0e               push cs
  02E5C9  1AC9: e89309           call 0x245f
  02E5CC  1ACC: 83c40e           add sp, 0xe
  02E5CF  1ACF: 080698a8         or byte ptr [0xa898], al
  02E5D3  1AD3: e9e100           jmp 0x1bb7
  02E5D6  1AD6: 8b46f4           mov ax, word ptr [bp - 0xc]
  02E5D9  1AD9: 8b1e4285         mov bx, word ptr [0x8542]
  02E5DD  1ADD: 3987b600         cmp word ptr [bx + 0xb6], ax
  02E5E1  1AE1: 7c03             jl 0x1ae6
  02E5E3  1AE3: e9b400           jmp 0x1b9a
  02E5E6  1AE6: 83bed6fe04       cmp word ptr [bp - 0x12a], 4
  02E5EB  1AEB: 7c03             jl 0x1af0
  02E5ED  1AED: e9a600           jmp 0x1b96
  02E5F0  1AF0: 6bb6d6fe34       imul si, word ptr [bp - 0x12a], 0x34
  02E5F5  1AF5: 80bc3f5400       cmp byte ptr [si + 0x543f], 0
  02E5FA  1AFA: 7403             je 0x1aff
  02E5FC  1AFC: e99700           jmp 0x1b96
  02E5FF  1AFF: f606845310       test byte ptr [0x5384], 0x10
  02E604  1B04: 7403             je 0x1b09
  02E606  1B06: e99100           jmp 0x1b9a
  02E609  1B09: 8a879400         mov al, byte ptr [bx + 0x94]
  02E60D  1B0D: 98               cwde 
  02E60E  1B0E: 50               push ax
  02E60F  1B0F: 9a4e0d1f18       lcall 0x181f, 0xd4e
  02E614  1B14: 83c402           add sp, 2
  02E617  1B17: 52               push dx
  02E618  1B18: 50               push ax
  02E619  1B19: 6a01             push 1
  02E61B  1B1B: 9a16041f18       lcall 0x181f, 0x416
  02E620  1B20: 83c406           add sp, 6
  02E623  1B23: 8b46f4           mov ax, word ptr [bp - 0xc]
  02E626  1B26: 99               cdq 
  02E627  1B27: 52               push dx
  02E628  1B28: 50               push ax
  02E629  1B29: 6a00             push 0
  02E62B  1B2B: 9aae091f18       lcall 0x181f, 0x9ae
  02E630  1B30: 83c406           add sp, 6
  02E633  1B33: 8b1e4285         mov bx, word ptr [0x8542]
  02E637  1B37: 8b87b600         mov ax, word ptr [bx + 0xb6]
  02E63B  1B3B: 99               cdq 
  02E63C  1B3C: 52               push dx
  02E63D  1B3D: 50               push ax
  02E63E  1B3E: 6a01             push 1
  02E640  1B40: 9aae091f18       lcall 0x181f, 0x9ae
  02E645  1B45: 83c406           add sp, 6
  02E648  1B48: 68a10e           push 0xea1
  02E64B  1B4B: 8d46a2           lea ax, [bp - 0x5e]
  02E64E  1B4E: 50               push ax
  02E64F  1B4F: 9ae4071d0d       lcall 0xd1d, 0x7e4
  02E654  1B54: 83c404           add sp, 4
  02E657  1B57: 8b1e4285         mov bx, word ptr [0x8542]
  02E65B  1B5B: 83bfb60000       cmp word ptr [bx + 0xb6], 0
  02E660  1B60: 750f             jne 0x1b71
  02E662  1B62: 68ab0e           push 0xeab
  02E665  1B65: 8d46a2           lea ax, [bp - 0x5e]
  02E668  1B68: 50               push ax
  02E669  1B69: 9aa4071d0d       lcall 0xd1d, 0x7a4
  02E66E  1B6E: 83c404           add sp, 4
  02E671  1B71: 6a00             push 0
  02E673  1B73: 6a05             push 5
  02E675  1B75: 6a00             push 0
  02E677  1B77: 6a00             push 0
  02E679  1B79: 6a02             push 2
  02E67B  1B7B: 803e98a801       cmp byte ptr [0xa898], 1
  02E680  1B80: 1bc0             sbb ax, ax
  02E682  1B82: f7d8             neg ax
  02E684  1B84: 50               push ax
  02E685  1B85: 8d46a2           lea ax, [bp - 0x5e]
  02E688  1B88: 50               push ax
  02E689  1B89: 0e               push cs
  02E68A  1B8A: e8d208           call 0x245f
  02E68D  1B8D: 83c40e           add sp, 0xe
  02E690  1B90: 080698a8         or byte ptr [0xa898], al
  02E694  1B94: eb04             jmp 0x1b9a
  02E696  1B96: 8987b600         mov word ptr [bx + 0xb6], ax
  02E69A  1B9A: 8b46f4           mov ax, word ptr [bp - 0xc]
  02E69D  1B9D: 8b1e4285         mov bx, word ptr [0x8542]
  02E6A1  1BA1: 3987b600         cmp word ptr [bx + 0xb6], ax
  02E6A5  1BA5: 7c08             jl 0x1baf
  02E6A7  1BA7: 2987b600         sub word ptr [bx + 0xb6], ax
  02E6AB  1BAB: 0e               push cs
  02E6AC  1BAC: e89c08           call 0x244b
  02E6AF  1BAF: 9a3a0d1f18       lcall 0x181f, 0xd3a
  02E6B4  1BB4: 894698           mov word ptr [bp - 0x68], ax
  02E6B7  1BB7: a1ea8d           mov ax, word ptr [0x8dea]
  02E6BA  1BBA: 699ed6fe3c01     imul bx, word ptr [bp - 0x12a], 0x13c
  02E6C0  1BC0: 01873688         add word ptr [bx - 0x77ca], ax
  02E6C4  1BC4: 803e93a805       cmp byte ptr [0xa893], 5
  02E6C9  1BC9: 7505             jne 0x1bd0
  02E6CB  1BCB: b80100           mov ax, 1
  02E6CE  1BCE: eb02             jmp 0x1bd2
  02E6D0  1BD0: 2bc0             sub ax, ax
  02E6D2  1BD2: 6a05             push 5
  02E6D4  1BD4: 8bf0             mov si, ax
  02E6D6  1BD6: 9a820b1f18       lcall 0x181f, 0xb82
  02E6DB  1BDB: 83c402           add sp, 2
  02E6DE  1BDE: d1e0             shl ax, 1
  02E6E0  1BE0: 03f0             add si, ax
  02E6E2  1BE2: 8bc6             mov ax, si
  02E6E4  1BE4: c1e602           shl si, 2
  02E6E7  1BE7: 03f0             add si, ax
  02E6E9  1BE9: d1fe             sar si, 1
  02E6EB  1BEB: 8976f6           mov word ptr [bp - 0xa], si
  02E6EE  1BEE: 8b4698           mov ax, word ptr [bp - 0x68]
  02E6F1  1BF1: 8b1e4285         mov bx, word ptr [0x8542]
  02E6F5  1BF5: 3987a400         cmp word ptr [bx + 0xa4], ax
  02E6F9  1BF9: 7e23             jle 0x1c1e
  02E6FB  1BFB: 2b87a400         sub ax, word ptr [bx + 0xa4]
  02E6FF  1BFF: f7d8             neg ax
  02E701  1C01: 898646ff         mov word ptr [bp - 0xba], ax
  02E705  1C05: 3b8628ff         cmp ax, word ptr [bp - 0xd8]
  02E709  1C09: 7e04             jle 0x1c0f
  02E70B  1C0B: 8b8628ff         mov ax, word ptr [bp - 0xd8]
  02E70F  1C0F: 2946f6           sub word ptr [bp - 0xa], ax
  02E712  1C12: 8b46f6           mov ax, word ptr [bp - 0xa]
  02E715  1C15: 0bc0             or ax, ax
  02E717  1C17: 7d02             jge 0x1c1b
  02E719  1C19: 2bc0             sub ax, ax
  02E71B  1C1B: 8946f6           mov word ptr [bp - 0xa], ax
  02E71E  1C1E: 2bc0             sub ax, ax
  02E720  1C20: 894690           mov word ptr [bp - 0x70], ax
  02E723  1C23: 89864cff         mov word ptr [bp - 0xb4], ax
  02E727  1C27: e90601           jmp 0x1d30
  02E72A  1C2A: 836e8c32         sub word ptr [bp - 0x74], 0x32
  02E72E  1C2E: 8b1e4285         mov bx, word ptr [0x8542]
  02E732  1C32: 8a471a           mov al, byte ptr [bx + 0x1a]
  02E735  1C35: 2ae4             sub ah, ah
  02E737  1C37: 69d83c01         imul bx, ax, 0x13c
  02E73B  1C3B: fe875188         inc byte ptr [bx - 0x77af]
  02E73F  1C3F: 837e8c32         cmp word ptr [bp - 0x74], 0x32
  02E743  1C43: 7de5             jge 0x1c2a
  02E745  1C45: 83be4cff08       cmp word ptr [bp - 0xb4], 8
  02E74A  1C4A: 7519             jne 0x1c65
  02E74C  1C4C: 8b468c           mov ax, word ptr [bp - 0x74]
  02E74F  1C4F: 8b1e4285         mov bx, word ptr [0x8542]
  02E753  1C53: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  02E756  1C56: 2aed             sub ch, ch
  02E758  1C58: 69d93c01         imul bx, cx, 0x13c
  02E75C  1C5C: 01875288         add word ptr [bx - 0x77ae], ax
  02E760  1C60: c7468c0000       mov word ptr [bp - 0x74], 0
  02E765  1C65: ff768c           push word ptr [bp - 0x74]
  02E768  1C68: ffb64cff         push word ptr [bp - 0xb4]
  02E76C  1C6C: 9a2e0a1f19       lcall 0x191f, 0xa2e
  02E771  1C71: 83c404           add sp, 4
  02E774  1C74: 8b864cff         mov ax, word ptr [bp - 0xb4]
  02E778  1C78: 8bd8             mov bx, ax
  02E77A  1C7A: c1e302           shl bx, 2
  02E77D  1C7D: 99               cdq 
  02E77E  1C7E: 031efc84         add bx, word ptr [0x84fc]
  02E782  1C82: 0187bc00         add word ptr [bx + 0xbc], ax
  02E786  1C86: 1197be00         adc word ptr [bx + 0xbe], dx
  02E78A  1C8A: 8b364285         mov si, word ptr [0x8542]
  02E78E  1C8E: 8a441a           mov al, byte ptr [si + 0x1a]
  02E791  1C91: 2ae4             sub ah, ah
  02E793  1C93: 8bf0             mov si, ax
  02E795  1C95: c1e604           shl si, 4
  02E798  1C98: 8bc3             mov ax, bx
  02E79A  1C9A: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  02E79E  1C9E: 8bf8             mov di, ax
  02E7A0  1CA0: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  02E7A4  1CA4: 2ae4             sub ah, ah
  02E7A6  1CA6: f76e8c           imul word ptr [bp - 0x74]
  02E7A9  1CA9: 89469c           mov word ptr [bp - 0x64], ax
  02E7AC  1CAC: 99               cdq 
  02E7AD  1CAD: 01457c           add word ptr [di + 0x7c], ax
  02E7B0  1CB0: 11557e           adc word ptr [di + 0x7e], dx
  02E7B3  1CB3: 8b1efc84         mov bx, word ptr [0x84fc]
  02E7B7  1CB7: 01472a           add word ptr [bx + 0x2a], ax
  02E7BA  1CBA: 11572c           adc word ptr [bx + 0x2c], dx
  02E7BD  1CBD: 8b8646ff         mov ax, word ptr [bp - 0xba]
  02E7C1  1CC1: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02E7C5  1CC5: d1e6             shl si, 1
  02E7C7  1CC7: 39821eff         cmp word ptr [bp + si - 0xe2], ax
  02E7CB  1CCB: 7c0d             jl 0x1cda
  02E7CD  1CCD: 8b4698           mov ax, word ptr [bp - 0x68]
  02E7D0  1CD0: 8b1e4285         mov bx, word ptr [0x8542]
  02E7D4  1CD4: 89809a00         mov word ptr [bx + si + 0x9a], ax
  02E7D8  1CD8: eb52             jmp 0x1d2c
  02E7DA  1CDA: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02E7DE  1CDE: d1e6             shl si, 1
  02E7E0  1CE0: 8b821eff         mov ax, word ptr [bp + si - 0xe2]
  02E7E4  1CE4: 298646ff         sub word ptr [bp - 0xba], ax
  02E7E8  1CE8: 8b1e4285         mov bx, word ptr [0x8542]
  02E7EC  1CEC: 29809a00         sub word ptr [bx + si + 0x9a], ax
  02E7F0  1CF0: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02E7F4  1CF4: 3b8646ff         cmp ax, word ptr [bp - 0xba]
  02E7F8  1CF8: 7e04             jle 0x1cfe
  02E7FA  1CFA: 8b8646ff         mov ax, word ptr [bp - 0xba]
  02E7FE  1CFE: 89468e           mov word ptr [bp - 0x72], ax
  02E801  1D01: 3d0200           cmp ax, 2
  02E804  1D04: 7d05             jge 0x1d0b
  02E806  1D06: c7468e0000       mov word ptr [bp - 0x72], 0
  02E80B  1D0B: 837e8e00         cmp word ptr [bp - 0x72], 0
  02E80F  1D0F: 740a             je 0x1d1b
  02E811  1D11: ff4690           inc word ptr [bp - 0x70]
  02E814  1D14: 8b864cff         mov ax, word ptr [bp - 0xb4]
  02E818  1D18: 8946fa           mov word ptr [bp - 6], ax
  02E81B  1D1B: 8b468e           mov ax, word ptr [bp - 0x72]
  02E81E  1D1E: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02E822  1D22: d1e6             shl si, 1
  02E824  1D24: 8b1e4285         mov bx, word ptr [0x8542]
  02E828  1D28: 29809a00         sub word ptr [bx + si + 0x9a], ax
  02E82C  1D2C: ff864cff         inc word ptr [bp - 0xb4]
  02E830  1D30: 83be4cff10       cmp word ptr [bp - 0xb4], 0x10
  02E835  1D35: 7d4b             jge 0x1d82
  02E837  1D37: 83be4cff00       cmp word ptr [bp - 0xb4], 0
  02E83C  1D3C: 74ee             je 0x1d2c
  02E83E  1D3E: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02E842  1D42: d1e6             shl si, 1
  02E844  1D44: 8b1e4285         mov bx, word ptr [0x8542]
  02E848  1D48: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02E84C  1D4C: 2b4698           sub ax, word ptr [bp - 0x68]
  02E84F  1D4F: 898646ff         mov word ptr [bp - 0xba], ax
  02E853  1D53: 0bc0             or ax, ax
  02E855  1D55: 7ed5             jle 0x1d2c
  02E857  1D57: 807f1a04         cmp byte ptr [bx + 0x1a], 4
  02E85B  1D5B: 7311             jae 0x1d6e
  02E85D  1D5D: 8a471a           mov al, byte ptr [bx + 0x1a]
  02E860  1D60: 2ae4             sub ah, ah
  02E862  1D62: 6bd834           imul bx, ax, 0x34
  02E865  1D65: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  02E869  1D69: 7503             jne 0x1d6e
  02E86B  1D6B: e94fff           jmp 0x1cbd
  02E86E  1D6E: 8b8646ff         mov ax, word ptr [bp - 0xba]
  02E872  1D72: 89468c           mov word ptr [bp - 0x74], ax
  02E875  1D75: 83be4cff0f       cmp word ptr [bp - 0xb4], 0xf
  02E87A  1D7A: 7403             je 0x1d7f
  02E87C  1D7C: e9c6fe           jmp 0x1c45
  02E87F  1D7F: e9bdfe           jmp 0x1c3f
  02E882  1D82: 837e9000         cmp word ptr [bp - 0x70], 0
  02E886  1D86: 7477             je 0x1dff
  02E888  1D88: 837e9001         cmp word ptr [bp - 0x70], 1
  02E88C  1D8C: 7530             jne 0x1dbe
  02E88E  1D8E: 8b468e           mov ax, word ptr [bp - 0x72]
  02E891  1D91: 99               cdq 
  02E892  1D92: a3b09c           mov word ptr [0x9cb0], ax
  02E895  1D95: 8916b29c         mov word ptr [0x9cb2], dx
  02E899  1D99: 8b5efa           mov bx, word ptr [bp - 6]
  02E89C  1D9C: d1e3             shl bx, 1
  02E89E  1D9E: ffb7c097         push word ptr [bx - 0x6840]
  02E8A2  1DA2: 9a22001f18       lcall 0x181f, 0x22
  02E8A7  1DA7: 83c402           add sp, 2
  02E8AA  1DAA: 52               push dx
  02E8AB  1DAB: 50               push ax
  02E8AC  1DAC: 1e               push ds
  02E8AD  1DAD: 68129d           push 0x9d12
  02E8B0  1DB0: 9a7e111d0d       lcall 0xd1d, 0x117e
  02E8B5  1DB5: 83c408           add sp, 8
  02E8B8  1DB8: 68ad0e           push 0xead
  02E8BB  1DBB: eb04             jmp 0x1dc1
  02E8BD  1DBD: 90               nop 
  02E8BE  1DBE: 68b40e           push 0xeb4
  02E8C1  1DC1: 8d46a2           lea ax, [bp - 0x5e]
  02E8C4  1DC4: 50               push ax
  02E8C5  1DC5: 9ae4071d0d       lcall 0xd1d, 0x7e4
  02E8CA  1DCA: 83c404           add sp, 4
  02E8CD  1DCD: 8b1e4285         mov bx, word ptr [0x8542]
  02E8D1  1DD1: 80bf950002       cmp byte ptr [bx + 0x95], 2
  02E8D6  1DD6: 7204             jb 0x1ddc
  02E8D8  1DD8: 8046a702         add byte ptr [bp - 0x59], 2
  02E8DC  1DDC: 6a00             push 0
  02E8DE  1DDE: 6a05             push 5
  02E8E0  1DE0: 6a00             push 0
  02E8E2  1DE2: 6a00             push 0
  02E8E4  1DE4: 6a00             push 0
  02E8E6  1DE6: 803e98a801       cmp byte ptr [0xa898], 1
  02E8EB  1DEB: 1bc0             sbb ax, ax
  02E8ED  1DED: f7d8             neg ax
  02E8EF  1DEF: 50               push ax
  02E8F0  1DF0: 8d46a2           lea ax, [bp - 0x5e]
  02E8F3  1DF3: 50               push ax
  02E8F4  1DF4: 0e               push cs
  02E8F5  1DF5: e86706           call 0x245f
  02E8F8  1DF8: 83c40e           add sp, 0xe
  02E8FB  1DFB: 080698a8         or byte ptr [0xa898], al
  02E8FF  1DFF: 803e97a800       cmp byte ptr [0xa897], 0
  02E904  1E04: 7503             jne 0x1e09
  02E906  1E06: e98f01           jmp 0x1f98
  02E909  1E09: f606845304       test byte ptr [0x5384], 4
  02E90E  1E0E: 7403             je 0x1e13
  02E910  1E10: e98501           jmp 0x1f98
  02E913  1E13: c7864cff0000     mov word ptr [bp - 0xb4], 0
  02E919  1E19: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02E91D  1E1D: d1e6             shl si, 1
  02E91F  1E1F: 8b8254ff         mov ax, word ptr [bp + si - 0xac]
  02E923  1E23: b96400           mov cx, 0x64
  02E926  1E26: 99               cdq 
  02E927  1E27: f7f9             idiv cx
  02E929  1E29: 8b1e4285         mov bx, word ptr [0x8542]
  02E92D  1E2D: 8bd0             mov dx, ax
  02E92F  1E2F: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02E933  1E33: 8bda             mov bx, dx
  02E935  1E35: 99               cdq 
  02E936  1E36: f7f9             idiv cx
  02E938  1E38: 3bc3             cmp ax, bx
  02E93A  1E3A: 7f03             jg 0x1e3f
  02E93C  1E3C: e91201           jmp 0x1f51
  02E93F  1E3F: 83be4cff00       cmp word ptr [bp - 0xb4], 0
  02E944  1E44: 7503             jne 0x1e49
  02E946  1E46: e90801           jmp 0x1f51
  02E949  1E49: 6a02             push 2
  02E94B  1E4B: 9a98041f18       lcall 0x181f, 0x498
  02E950  1E50: 83c402           add sp, 2
  02E953  1E53: ffb4c097         push word ptr [si - 0x6840]
  02E957  1E57: 6a01             push 1
  02E959  1E59: 9a38041f18       lcall 0x181f, 0x438
  02E95E  1E5E: 83c404           add sp, 4
  02E961  1E61: 8b4698           mov ax, word ptr [bp - 0x68]
  02E964  1E64: 99               cdq 
  02E965  1E65: a3b09c           mov word ptr [0x9cb0], ax
  02E968  1E68: 8916b29c         mov word ptr [0x9cb2], dx
  02E96C  1E6C: 68bb0e           push 0xebb
  02E96F  1E6F: 8d46a2           lea ax, [bp - 0x5e]
  02E972  1E72: 50               push ax
  02E973  1E73: 9ae4071d0d       lcall 0xd1d, 0x7e4
  02E978  1E78: 83c404           add sp, 4
  02E97B  1E7B: 8b4698           mov ax, word ptr [bp - 0x68]
  02E97E  1E7E: 8b1e4285         mov bx, word ptr [0x8542]
  02E982  1E82: 39809a00         cmp word ptr [bx + si + 0x9a], ax
  02E986  1E86: 750f             jne 0x1e97
  02E988  1E88: c646ac31         mov byte ptr [bp - 0x54], 0x31
  02E98C  1E8C: 80bf950002       cmp byte ptr [bx + 0x95], 2
  02E991  1E91: 7204             jb 0x1e97
  02E993  1E93: c646ac32         mov byte ptr [bp - 0x54], 0x32
  02E997  1E97: 6a00             push 0
  02E999  1E99: 6a05             push 5
  02E99B  1E9B: 6a00             push 0
  02E99D  1E9D: 6a00             push 0
  02E99F  1E9F: 6aff             push -1
  02E9A1  1EA1: 803e98a801       cmp byte ptr [0xa898], 1
  02E9A6  1EA6: 1bc0             sbb ax, ax
  02E9A8  1EA8: f7d8             neg ax
  02E9AA  1EAA: 50               push ax
  02E9AB  1EAB: 8d46a2           lea ax, [bp - 0x5e]
  02E9AE  1EAE: 50               push ax
  02E9AF  1EAF: 0e               push cs
  02E9B0  1EB0: e8ac05           call 0x245f
  02E9B3  1EB3: 83c40e           add sp, 0xe
  02E9B6  1EB6: 080698a8         or byte ptr [0xa898], al
  02E9BA  1EBA: 8b1e4285         mov bx, word ptr [0x8542]
  02E9BE  1EBE: 807f1a04         cmp byte ptr [bx + 0x1a], 4
  02E9C2  1EC2: 7203             jb 0x1ec7
  02E9C4  1EC4: e98a00           jmp 0x1f51
  02E9C7  1EC7: 8a471a           mov al, byte ptr [bx + 0x1a]
  02E9CA  1ECA: 2ae4             sub ah, ah
  02E9CC  1ECC: 6bf034           imul si, ax, 0x34
  02E9CF  1ECF: 38a43f54         cmp byte ptr [si + 0x543f], ah
  02E9D3  1ED3: 757c             jne 0x1f51
  02E9D5  1ED5: f606825380       test byte ptr [0x5382], 0x80
  02E9DA  1EDA: 7475             je 0x1f51
  02E9DC  1EDC: f606875302       test byte ptr [0x5387], 2
  02E9E1  1EE1: 756e             jne 0x1f51
  02E9E3  1EE3: 6936c68dca00     imul si, word ptr [0x8dc6], 0xca
  02E9E9  1EE9: f684625d40       test byte ptr [si + 0x5d62], 0x40
  02E9EE  1EEE: 7461             je 0x1f51
  02E9F0  1EF0: 8bb64cff         mov si, word ptr [bp - 0xb4]
  02E9F4  1EF4: d1e6             shl si, 1
  02E9F6  1EF6: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02E9FA  1EFA: 99               cdq 
  02E9FB  1EFB: 52               push dx
  02E9FC  1EFC: 50               push ax
  02E9FD  1EFD: 6a00             push 0
  02E9FF  1EFF: 9aae091f18       lcall 0x181f, 0x9ae
  02EA04  1F04: 83c406           add sp, 6
  02EA07  1F07: ffb4c097         push word ptr [si - 0x6840]
  02EA0B  1F0B: 6a00             push 0
  02EA0D  1F0D: 9a38041f18       lcall 0x181f, 0x438
  02EA12  1F12: 83c404           add sp, 4
  02EA15  1F15: a14285           mov ax, word ptr [0x8542]
  02EA18  1F18: 40               inc ax
  02EA19  1F19: 40               inc ax
  02EA1A  1F1A: 1e               push ds
  02EA1B  1F1B: 50               push ax
  02EA1C  1F1C: 6a01             push 1
  02EA1E  1F1E: 9a16041f18       lcall 0x181f, 0x416
  02EA23  1F23: 83c406           add sp, 6
  02EA26  1F26: 8b1e4285         mov bx, word ptr [0x8542]
  02EA2A  1F2A: 8a5f1a           mov bl, byte ptr [bx + 0x1a]
  02EA2D  1F2D: 2aff             sub bh, bh
  02EA2F  1F2F: d1e3             shl bx, 1
  02EA31  1F31: ffb78c83         push word ptr [bx - 0x7c74]
  02EA35  1F35: 6a02             push 2
  02EA37  1F37: 9a38041f18       lcall 0x181f, 0x438
  02EA3C  1F3C: 83c404           add sp, 4
  02EA3F  1F3F: 6a00             push 0
  02EA41  1F41: 68c70e           push 0xec7
  02EA44  1F44: 9a52061f18       lcall 0x181f, 0x652
  02EA49  1F49: 83c404           add sp, 4
  02EA4C  1F4C: 800e875302       or byte ptr [0x5387], 2
  02EA51  1F51: ff864cff         inc word ptr [bp - 0xb4]
  02EA55  1F55: 83be4cff10       cmp word ptr [bp - 0xb4], 0x10
  02EA5A  1F5A: 7d03             jge 0x1f5f
  02EA5C  1F5C: e9bafe           jmp 0x1e19
  02EA5F  1F5F: eb37             jmp 0x1f98
  02EA61  1F61: 90               nop 
  02EA62  1F62: a0a653           mov al, byte ptr [0x53a6]
  02EA65  1F65: 2ae4             sub ah, ah
  02EA67  1F67: 40               inc ax
  02EA68  1F68: 50               push ax
  02EA69  1F69: 6a00             push 0
  02EA6B  1F6B: 9ad4041f18       lcall 0x181f, 0x4d4
  02EA70  1F70: 83c404           add sp, 4
  02EA73  1F73: 0bc0             or ax, ax
  02EA75  1F75: 741d             je 0x1f94
  02EA77  1F77: 8b1e4285         mov bx, word ptr [0x8542]
  02EA7B  1F7B: fe879700         inc byte ptr [bx + 0x97]
  02EA7F  1F7F: 80bf970032       cmp byte ptr [bx + 0x97], 0x32
  02EA84  1F84: 720e             jb 0x1f94
  02EA86  1F86: 8a879700         mov al, byte ptr [bx + 0x97]
  02EA8A  1F8A: 2c32             sub al, 0x32
  02EA8C  1F8C: 88879700         mov byte ptr [bx + 0x97], al
  02EA90  1F90: 0e               push cs
  02EA91  1F91: e8bc04           call 0x2450
  02EA94  1F94: fe0e96a8         dec byte ptr [0xa896]
  02EA98  1F98: 803e96a800       cmp byte ptr [0xa896], 0
  02EA9D  1F9D: 75c3             jne 0x1f62
  02EA9F  1F9F: 803e98a800       cmp byte ptr [0xa898], 0
  02EAA4  1FA4: 740c             je 0x1fb2
  02EAA6  1FA6: ff36c68d         push word ptr [0x8dc6]
  02EAAA  1FAA: 9a08061f18       lcall 0x181f, 0x608
  02EAAF  1FAF: 83c402           add sp, 2
  02EAB2  1FB2: c7064a03ffff     mov word ptr [0x34a], 0xffff
  02EAB8  1FB8: 5e               pop si
  02EAB9  1FB9: 5f               pop di
  02EABA  1FBA: c9               leave 
  02EABB  1FBB: cb               retf 

; ---- func_02EABC  size=46  insns=14  prologue=ENTER 0x0004,0  terminal=RETF ----
  02EABC  1FBC: c8040000         enter 4, 0
  02EAC0  1FC0: ff7606           push word ptr [bp + 6]
  02EAC3  1FC3: 9ae6091f18       lcall 0x181f, 0x9e6
  02EAC8  1FC8: 83c402           add sp, 2
  02EACB  1FCB: 9a720c1f18       lcall 0x181f, 0xc72
  02EAD0  1FD0: 9a220c1f18       lcall 0x181f, 0xc22
  02EAD5  1FD5: 6a00             push 0
  02EAD7  1FD7: ff7608           push word ptr [bp + 8]
  02EADA  1FDA: 9a4a0c1f18       lcall 0x181f, 0xc4a
  02EADF  1FDF: 83c402           add sp, 2
  02EAE2  1FE2: 50               push ax
  02EAE3  1FE3: 9a4c051f19       lcall 0x191f, 0x54c
  02EAE8  1FE8: c9               leave 
  02EAE9  1FE9: cb               retf 

; ---- func_02EAEA  size=49  insns=15  prologue=ENTER 0x0004,0  terminal=RETF ----
  02EAEA  1FEA: c8040000         enter 4, 0
  02EAEE  1FEE: ff7606           push word ptr [bp + 6]
  02EAF1  1FF1: 9ae6091f18       lcall 0x181f, 0x9e6
  02EAF6  1FF6: 83c402           add sp, 2
  02EAF9  1FF9: 9a720c1f18       lcall 0x181f, 0xc72
  02EAFE  1FFE: 9a220c1f18       lcall 0x181f, 0xc22
  02EB03  2003: 6a00             push 0
  02EB05  2005: ff7608           push word ptr [bp + 8]
  02EB08  2008: 9a4a0c1f18       lcall 0x181f, 0xc4a
  02EB0D  200D: 83c402           add sp, 2
  02EB10  2010: 50               push ax
  02EB11  2011: 9a360c1f18       lcall 0x181f, 0xc36
  02EB16  2016: 8b46fc           mov ax, word ptr [bp - 4]
  02EB19  2019: c9               leave 
  02EB1A  201A: cb               retf 

; ---- func_02EB1C  size=42  insns=16  prologue=push bp;mov bp,sp  terminal=RETF ----
  02EB1C  201C: 55               push bp
  02EB1D  201D: 8bec             mov bp, sp
  02EB1F  201F: 56               push si
  02EB20  2020: 695e06ca00       imul bx, word ptr [bp + 6], 0xca
  02EB25  2025: 8a87655d         mov al, byte ptr [bx + 0x5d65]
  02EB29  2029: 035e08           add bx, word ptr [bp + 8]
  02EB2C  202C: 8887005e         mov byte ptr [bx + 0x5e00], al
  02EB30  2030: 6a00             push 0
  02EB32  2032: ff7606           push word ptr [bp + 6]
  02EB35  2035: 8bf3             mov si, bx
  02EB37  2037: 9a140b1f18       lcall 0x181f, 0xb14
  02EB3C  203C: 83c404           add sp, 4
  02EB3F  203F: 8884045e         mov byte ptr [si + 0x5e04], al
  02EB43  2043: 5e               pop si
  02EB44  2044: c9               leave 
  02EB45  2045: cb               retf 

; ---- func_02EB46  size=49  insns=22  prologue=push bp;mov bp,sp  terminal=RETF ----
  02EB46  2046: 55               push bp
  02EB47  2047: 8bec             mov bp, sp
  02EB49  2049: 56               push si
  02EB4A  204A: 8a4608           mov al, byte ptr [bp + 8]
  02EB4D  204D: 695e06ca00       imul bx, word ptr [bp + 6], 0xca
  02EB52  2052: 3887605d         cmp byte ptr [bx + 0x5d60], al
  02EB56  2056: 7413             je 0x206b
  02EB58  2058: 833ea25300       cmp word ptr [0x53a2], 0
  02EB5D  205D: 750c             jne 0x206b
  02EB5F  205F: 8bf3             mov si, bx
  02EB61  2061: 8b5e08           mov bx, word ptr [bp + 8]
  02EB64  2064: 80b8005e00       cmp byte ptr [bx + si + 0x5e00], 0
  02EB69  2069: 7407             je 0x2072
  02EB6B  206B: b80100           mov ax, 1
  02EB6E  206E: 5e               pop si
  02EB6F  206F: c9               leave 
  02EB70  2070: cb               retf 
  02EB71  2071: 90               nop 
  02EB72  2072: 2bc0             sub ax, ax
  02EB74  2074: 5e               pop si
  02EB75  2075: c9               leave 
  02EB76  2076: cb               retf 

; ---- func_02EB78  size=699  insns=221  prologue=ENTER 0x000A,0  terminal=RETF ----
  02EB78  2078: c80a0000         enter 0xa, 0
  02EB7C  207C: 56               push si
  02EB7D  207D: c746fcffff       mov word ptr [bp - 4], 0xffff
  02EB82  2082: 833e9e5330       cmp word ptr [0x539e], 0x30
  02EB87  2087: 7c27             jl 0x20b0
  02EB89  2089: 837e0604         cmp word ptr [bp + 6], 4
  02EB8D  208D: 7c03             jl 0x2092
  02EB8F  208F: e99b02           jmp 0x232d
  02EB92  2092: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  02EB96  2096: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02EB9B  209B: 7403             je 0x20a0
  02EB9D  209D: e98d02           jmp 0x232d
  02EBA0  20A0: 8d1ed10e         lea bx, [0xed1]
  02EBA4  20A4: 9afe031f18       lcall 0x181f, 0x3fe
  02EBA9  20A9: 8b46fc           mov ax, word ptr [bp - 4]
  02EBAC  20AC: 5e               pop si
  02EBAD  20AD: c9               leave 
  02EBAE  20AE: cb               retf 
  02EBAF  20AF: 90               nop 
  02EBB0  20B0: 8b5e06           mov bx, word ptr [bp + 6]
  02EBB3  20B3: fe879892         inc byte ptr [bx - 0x6d68]
  02EBB7  20B7: a19e53           mov ax, word ptr [0x539e]
  02EBBA  20BA: ff069e53         inc word ptr [0x539e]
  02EBBE  20BE: 8946fc           mov word ptr [bp - 4], ax
  02EBC1  20C1: 50               push ax
  02EBC2  20C2: 9ae6091f18       lcall 0x181f, 0x9e6
  02EBC7  20C7: 83c402           add sp, 2
  02EBCA  20CA: ff760a           push word ptr [bp + 0xa]
  02EBCD  20CD: ff7608           push word ptr [bp + 8]
  02EBD0  20D0: 9a40071f18       lcall 0x181f, 0x740
  02EBD5  20D5: 83c404           add sp, 4
  02EBD8  20D8: 8ec2             mov es, dx
  02EBDA  20DA: 8bd8             mov bx, ax
  02EBDC  20DC: 26800f02         or byte ptr es:[bx], 2
  02EBE0  20E0: 8a4606           mov al, byte ptr [bp + 6]
  02EBE3  20E3: 8b1e4285         mov bx, word ptr [0x8542]
  02EBE7  20E7: 88471a           mov byte ptr [bx + 0x1a], al
  02EBEA  20EA: 8a4608           mov al, byte ptr [bp + 8]
  02EBED  20ED: 8807             mov byte ptr [bx], al
  02EBEF  20EF: 8a460a           mov al, byte ptr [bp + 0xa]
  02EBF2  20F2: 884701           mov byte ptr [bx + 1], al
  02EBF5  20F5: 2ac0             sub al, al
  02EBF7  20F7: 88471b           mov byte ptr [bx + 0x1b], al
  02EBFA  20FA: 88471c           mov byte ptr [bx + 0x1c], al
  02EBFD  20FD: 88471d           mov byte ptr [bx + 0x1d], al
  02EC00  2100: 88879500         mov byte ptr [bx + 0x95], al
  02EC04  2104: 88879600         mov byte ptr [bx + 0x96], al
  02EC08  2108: 88879700         mov byte ptr [bx + 0x97], al
  02EC0C  210C: c78790000000     mov word ptr [bx + 0x90], 0
  02EC12  2112: c6878d00ff       mov byte ptr [bx + 0x8d], 0xff
  02EC17  2117: 88471f           mov byte ptr [bx + 0x1f], al
  02EC1A  211A: 88878c00         mov byte ptr [bx + 0x8c], al
  02EC1E  211E: 88878e00         mov byte ptr [bx + 0x8e], al
  02EC22  2122: 88878f00         mov byte ptr [bx + 0x8f], al
  02EC26  2126: c787c6006400     mov word ptr [bx + 0xc6], 0x64
  02EC2C  212C: c787c8000000     mov word ptr [bx + 0xc8], 0
  02EC32  2132: 2bc0             sub ax, ax
  02EC34  2134: 8987c400         mov word ptr [bx + 0xc4], ax
  02EC38  2138: 8987c200         mov word ptr [bx + 0xc2], ax
  02EC3C  213C: 6a02             push 2
  02EC3E  213E: 89879200         mov word ptr [bx + 0x92], ax
  02EC42  2142: 89879800         mov word ptr [bx + 0x98], ax
  02EC46  2146: 50               push ax
  02EC47  2147: 8d878a00         lea ax, [bx + 0x8a]
  02EC4B  214B: 50               push ax
  02EC4C  214C: 9aae0d1d0d       lcall 0xd1d, 0xdae
  02EC51  2151: 83c406           add sp, 6
  02EC54  2154: 6a01             push 1
  02EC56  2156: 6a01             push 1
  02EC58  2158: 9a260d1f18       lcall 0x181f, 0xd26
  02EC5D  215D: 83c404           add sp, 4
  02EC60  2160: 6a01             push 1
  02EC62  2162: 6a02             push 2
  02EC64  2164: 9a260d1f18       lcall 0x181f, 0xd26
  02EC69  2169: 83c404           add sp, 4
  02EC6C  216C: 6a01             push 1
  02EC6E  216E: 6a03             push 3
  02EC70  2170: 9a260d1f18       lcall 0x181f, 0xd26
  02EC75  2175: 83c404           add sp, 4
  02EC78  2178: 6a01             push 1
  02EC7A  217A: 6a04             push 4
  02EC7C  217C: 9a260d1f18       lcall 0x181f, 0xd26
  02EC81  2181: 83c404           add sp, 4
  02EC84  2184: 6a01             push 1
  02EC86  2186: 6a06             push 6
  02EC88  2188: 9a260d1f18       lcall 0x181f, 0xd26
  02EC8D  218D: 83c404           add sp, 4
  02EC90  2190: 6a01             push 1
  02EC92  2192: 6a07             push 7
  02EC94  2194: 9a260d1f18       lcall 0x181f, 0xd26
  02EC99  2199: 83c404           add sp, 4
  02EC9C  219C: 6a01             push 1
  02EC9E  219E: 6a09             push 9
  02ECA0  21A0: 9a260d1f18       lcall 0x181f, 0xd26
  02ECA5  21A5: 83c404           add sp, 4
  02ECA8  21A8: 6a01             push 1
  02ECAA  21AA: 6a0a             push 0xa
  02ECAC  21AC: 9a260d1f18       lcall 0x181f, 0xd26
  02ECB1  21B1: 83c404           add sp, 4
  02ECB4  21B4: 6a01             push 1
  02ECB6  21B6: 6a0b             push 0xb
  02ECB8  21B8: 9a260d1f18       lcall 0x181f, 0xd26
  02ECBD  21BD: 83c404           add sp, 4
  02ECC0  21C0: 6a01             push 1
  02ECC2  21C2: 6a0c             push 0xc
  02ECC4  21C4: 9a260d1f18       lcall 0x181f, 0xd26
  02ECC9  21C9: 83c404           add sp, 4
  02ECCC  21CC: 6a06             push 6
  02ECCE  21CE: 6a00             push 0
  02ECD0  21D0: a14285           mov ax, word ptr [0x8542]
  02ECD3  21D3: 058400           add ax, 0x84
  02ECD6  21D6: 50               push ax
  02ECD7  21D7: 9aae0d1d0d       lcall 0xd1d, 0xdae
  02ECDC  21DC: 83c406           add sp, 6
  02ECDF  21DF: 6a01             push 1
  02ECE1  21E1: 6a23             push 0x23
  02ECE3  21E3: 9abe0b1f18       lcall 0x181f, 0xbbe
  02ECE8  21E8: 83c404           add sp, 4
  02ECEB  21EB: 6a01             push 1
  02ECED  21ED: 6a09             push 9
  02ECEF  21EF: 9abe0b1f18       lcall 0x181f, 0xbbe
  02ECF4  21F4: 83c404           add sp, 4
  02ECF7  21F7: 9a220c1f18       lcall 0x181f, 0xc22
  02ECFC  21FC: 6a20             push 0x20
  02ECFE  21FE: 6a00             push 0
  02ED00  2200: a14285           mov ax, word ptr [0x8542]
  02ED03  2203: 059a00           add ax, 0x9a
  02ED06  2206: 50               push ax
  02ED07  2207: 9aae0d1d0d       lcall 0xd1d, 0xdae
  02ED0C  220C: 83c406           add sp, 6
  02ED0F  220F: 6a14             push 0x14
  02ED11  2211: 6aff             push -1
  02ED13  2213: a14285           mov ax, word ptr [0x8542]
  02ED16  2216: 057000           add ax, 0x70
  02ED19  2219: 50               push ax
  02ED1A  221A: 9aae0d1d0d       lcall 0xd1d, 0xdae
  02ED1F  221F: 83c406           add sp, 6
  02ED22  2222: 837e0c00         cmp word ptr [bp + 0xc], 0
  02ED26  2226: 7c3c             jl 0x2264
  02ED28  2228: ff760c           push word ptr [bp + 0xc]
  02ED2B  222B: 9a4a0c1f18       lcall 0x181f, 0xc4a
  02ED30  2230: 83c402           add sp, 2
  02ED33  2233: 0bc0             or ax, ax
  02ED35  2235: 7c0b             jl 0x2242
  02ED37  2237: 6a00             push 0
  02ED39  2239: 50               push ax
  02ED3A  223A: 9a360c1f18       lcall 0x181f, 0xc36
  02ED3F  223F: eb20             jmp 0x2261
  02ED41  2241: 90               nop 
  02ED42  2242: 695efcca00       imul bx, word ptr [bp - 4], 0xca
  02ED47  2247: c687655d01       mov byte ptr [bx + 0x5d65], 1
  02ED4C  224C: 6a00             push 0
  02ED4E  224E: 6a00             push 0
  02ED50  2250: 9a360c1f18       lcall 0x181f, 0xc36
  02ED55  2255: 83c404           add sp, 4
  02ED58  2258: 6a1c             push 0x1c
  02ED5A  225A: 6a00             push 0
  02ED5C  225C: 9aae0c1f18       lcall 0x181f, 0xcae
  02ED61  2261: 83c404           add sp, 4
  02ED64  2264: 9a720c1f18       lcall 0x181f, 0xc72
  02ED69  2269: 9a220c1f18       lcall 0x181f, 0xc22
  02ED6E  226E: c746fa0000       mov word ptr [bp - 6], 0
  02ED73  2273: 8b5efa           mov bx, word ptr [bp - 6]
  02ED76  2276: 031e4285         add bx, word ptr [0x8542]
  02ED7A  227A: c687ba0001       mov byte ptr [bx + 0xba], 1
  02ED7F  227F: c687be0000       mov byte ptr [bx + 0xbe], 0
  02ED84  2284: 837efa04         cmp word ptr [bp - 6], 4
  02ED88  2288: 7d1c             jge 0x22a6
  02ED8A  228A: ff760a           push word ptr [bp + 0xa]
  02ED8D  228D: ff7608           push word ptr [bp + 8]
  02ED90  2290: 9a4a071f18       lcall 0x181f, 0x74a
  02ED95  2295: 83c404           add sp, 4
  02ED98  2298: 2ae4             sub ah, ah
  02ED9A  229A: 8a4efa           mov cl, byte ptr [bp - 6]
  02ED9D  229D: ba1000           mov dx, 0x10
  02EDA0  22A0: d3e2             shl dx, cl
  02EDA2  22A2: 85c2             test dx, ax
  02EDA4  22A4: 740c             je 0x22b2
  02EDA6  22A6: 8b1e4285         mov bx, word ptr [0x8542]
  02EDAA  22AA: 8b76fa           mov si, word ptr [bp - 6]
  02EDAD  22AD: c680ba0001       mov byte ptr [bx + si + 0xba], 1
  02EDB2  22B2: ff46fa           inc word ptr [bp - 6]
  02EDB5  22B5: 837efa04         cmp word ptr [bp - 6], 4
  02EDB9  22B9: 7cb8             jl 0x2273
  02EDBB  22BB: ff760a           push word ptr [bp + 0xa]
  02EDBE  22BE: ff7608           push word ptr [bp + 8]
  02EDC1  22C1: 9a120d1f18       lcall 0x181f, 0xd12
  02EDC6  22C6: 83c404           add sp, 4
  02EDC9  22C9: 0bc0             or ax, ax
  02EDCB  22CB: 741e             je 0x22eb
  02EDCD  22CD: ff36bc8d         push word ptr [0x8dbc]
  02EDD1  22D1: ff36ba8d         push word ptr [0x8dba]
  02EDD5  22D5: 9ab4061f18       lcall 0x181f, 0x6b4
  02EDDA  22DA: 83c404           add sp, 4
  02EDDD  22DD: fec8             dec al
  02EDDF  22DF: 750a             jne 0x22eb
  02EDE1  22E1: 695efcca00       imul bx, word ptr [bp - 4], 0xca
  02EDE6  22E6: 808f625d40       or byte ptr [bx + 0x5d62], 0x40
  02EDEB  22EB: 8b1e4285         mov bx, word ptr [0x8542]
  02EDEF  22EF: c68794000f       mov byte ptr [bx + 0x94], 0xf
  02EDF4  22F4: f6471c40         test byte ptr [bx + 0x1c], 0x40
  02EDF8  22F8: 7405             je 0x22ff
  02EDFA  22FA: c687940006       mov byte ptr [bx + 0x94], 6
  02EDFF  22FF: c746fa0000       mov word ptr [bp - 6], 0
  02EE04  2304: 6a06             push 6
  02EE06  2306: ff76fa           push word ptr [bp - 6]
  02EE09  2309: 9ab4071f18       lcall 0x181f, 0x7b4
  02EE0E  230E: 83c404           add sp, 4
  02EE11  2311: 0bc0             or ax, ax
  02EE13  2313: 740f             je 0x2324
  02EE15  2315: ff76fa           push word ptr [bp - 6]
  02EE18  2318: ff36c68d         push word ptr [0x8dc6]
  02EE1C  231C: 9aaa071f18       lcall 0x181f, 0x7aa
  02EE21  2321: 83c404           add sp, 4
  02EE24  2324: ff46fa           inc word ptr [bp - 6]
  02EE27  2327: 837efa04         cmp word ptr [bp - 6], 4
  02EE2B  232B: 7cd7             jl 0x2304
  02EE2D  232D: 8b46fc           mov ax, word ptr [bp - 4]
  02EE30  2330: 5e               pop si
  02EE31  2331: c9               leave 
  02EE32  2332: cb               retf 

; ---- func_02EE34  size=304  insns=104  prologue=ENTER 0x0008,0  terminal=JMP-tail ----
  02EE34  2334: c8080000         enter 8, 0
  02EE38  2338: 57               push di
  02EE39  2339: 56               push si
  02EE3A  233A: 695e06ca00       imul bx, word ptr [bp + 6], 0xca
  02EE3F  233F: 8a87605d         mov al, byte ptr [bx + 0x5d60]
  02EE43  2343: 2ae4             sub ah, ah
  02EE45  2345: 8bf0             mov si, ax
  02EE47  2347: fe8c9892         dec byte ptr [si - 0x6d68]
  02EE4B  234B: 6a00             push 0
  02EE4D  234D: 6a02             push 2
  02EE4F  234F: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  02EE53  2353: 50               push ax
  02EE54  2354: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  02EE58  2358: 50               push ax
  02EE59  2359: 9a8c061f18       lcall 0x181f, 0x68c
  02EE5E  235E: 83c408           add sp, 8
  02EE61  2361: 8b4606           mov ax, word ptr [bp + 6]
  02EE64  2364: 8946fc           mov word ptr [bp - 4], ax
  02EE67  2367: eb1a             jmp 0x2383
  02EE69  2369: 90               nop 
  02EE6A  236A: 695efcca00       imul bx, word ptr [bp - 4], 0xca
  02EE6F  236F: 8dbf465d         lea di, [bx + 0x5d46]
  02EE73  2373: 8db7105e         lea si, [bx + 0x5e10]
  02EE77  2377: 8cd8             mov ax, ds
  02EE79  2379: 8ec0             mov es, ax
  02EE7B  237B: b96500           mov cx, 0x65
  02EE7E  237E: f3a5             rep movsw word ptr es:[di], word ptr [si]
  02EE80  2380: ff46fc           inc word ptr [bp - 4]
  02EE83  2383: a19e53           mov ax, word ptr [0x539e]
  02EE86  2386: 48               dec ax
  02EE87  2387: 3b46fc           cmp ax, word ptr [bp - 4]
  02EE8A  238A: 7fde             jg 0x236a
  02EE8C  238C: ff0e9e53         dec word ptr [0x539e]
  02EE90  2390: c746fc0000       mov word ptr [bp - 4], 0
  02EE95  2395: eb40             jmp 0x23d7
  02EE97  2397: 90               nop 
  02EE98  2398: 263907           cmp word ptr es:[bx], ax
  02EE9B  239B: 7e03             jle 0x23a0
  02EE9D  239D: 26ff0f           dec word ptr es:[bx]
  02EEA0  23A0: ff4efe           dec word ptr [bp - 2]
  02EEA3  23A3: 837efe00         cmp word ptr [bp - 2], 0
  02EEA7  23A7: 7c2b             jl 0x23d4
  02EEA9  23A9: ff76fe           push word ptr [bp - 2]
  02EEAC  23AC: 9a4a0a1f19       lcall 0x191f, 0xa4a
  02EEB1  23B1: 83c402           add sp, 2
  02EEB4  23B4: c41e189e         les bx, ptr [0x9e18]
  02EEB8  23B8: 26813fe703       cmp word ptr es:[bx], 0x3e7
  02EEBD  23BD: 74e1             je 0x23a0
  02EEBF  23BF: 8b4606           mov ax, word ptr [bp + 6]
  02EEC2  23C2: 263907           cmp word ptr es:[bx], ax
  02EEC5  23C5: 75d1             jne 0x2398
  02EEC7  23C7: ff76fe           push word ptr [bp - 2]
  02EECA  23CA: 9a3c0a1f19       lcall 0x191f, 0xa3c
  02EECF  23CF: 83c402           add sp, 2
  02EED2  23D2: ebcc             jmp 0x23a0
  02EED4  23D4: ff46fc           inc word ptr [bp - 4]
  02EED7  23D7: 8b46fc           mov ax, word ptr [bp - 4]
  02EEDA  23DA: 3906a053         cmp word ptr [0x53a0], ax
  02EEDE  23DE: 7e1a             jle 0x23fa
  02EEE0  23E0: 50               push ax
  02EEE1  23E1: 9ace021f19       lcall 0x191f, 0x2ce
  02EEE6  23E6: 83c402           add sp, 2
  02EEE9  23E9: c41e149e         les bx, ptr [0x9e14]
  02EEED  23ED: 268a4721         mov al, byte ptr es:[bx + 0x21]
  02EEF1  23F1: 2ae4             sub ah, ah
  02EEF3  23F3: 48               dec ax
  02EEF4  23F4: 8946fe           mov word ptr [bp - 2], ax
  02EEF7  23F7: ebaa             jmp 0x23a3
  02EEF9  23F9: 90               nop 
  02EEFA  23FA: 8b4606           mov ax, word ptr [bp + 6]
  02EEFD  23FD: 8946fa           mov word ptr [bp - 6], ax
  02EF00  2400: a19c53           mov ax, word ptr [0x539c]
  02EF03  2403: 48               dec ax
  02EF04  2404: 894606           mov word ptr [bp + 6], ax
  02EF07  2407: eb15             jmp 0x241e
  02EF09  2409: 90               nop 
  02EF0A  240A: 8a46fa           mov al, byte ptr [bp - 6]
  02EF0D  240D: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  02EF11  2411: 38874a31         cmp byte ptr [bx + 0x314a], al
  02EF15  2415: 7e04             jle 0x241b
  02EF17  2417: fe8f4a31         dec byte ptr [bx + 0x314a]
  02EF1B  241B: ff4e06           dec word ptr [bp + 6]
  02EF1E  241E: 837e0600         cmp word ptr [bp + 6], 0
  02EF22  2422: 7c1e             jl 0x2442
  02EF24  2424: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  02EF28  2428: 8a874731         mov al, byte ptr [bx + 0x3147]
  02EF2C  242C: 240f             and al, 0xf
  02EF2E  242E: 3c04             cmp al, 4
  02EF30  2430: 73e9             jae 0x241b
  02EF32  2432: 8a46fa           mov al, byte ptr [bp - 6]
  02EF35  2435: 38874a31         cmp byte ptr [bx + 0x314a], al
  02EF39  2439: 75cf             jne 0x240a
  02EF3B  243B: c6874a31ff       mov byte ptr [bx + 0x314a], 0xff
  02EF40  2440: ebd9             jmp 0x241b
  02EF42  2442: 5e               pop si
  02EF43  2443: 5f               pop di
  02EF44  2444: c9               leave 
  02EF45  2445: cb               retf 
  02EF46  2446: ea54021f19       ljmp 0x191f:0x254
  02EF4B  244B: ea7a091f19       ljmp 0x191f:0x97a
  02EF50  2450: ea88091f19       ljmp 0x191f:0x988
  02EF55  2455: eac0091f19       ljmp 0x191f:0x9c0
  02EF5A  245A: eace091f19       ljmp 0x191f:0x9ce
  02EF5F  245F: eadc091f19       ljmp 0x191f:0x9dc

; ---- func_02EF64  size=236  insns=77  prologue=ENTER 0x0008,0  terminal=RETF ----
  02EF64  2464: c8080000         enter 8, 0
  02EF68  2468: 56               push si
  02EF69  2469: c746fa0100       mov word ptr [bp - 6], 1
  02EF6E  246E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  02EF72  2472: 8a874431         mov al, byte ptr [bx + 0x3144]
  02EF76  2476: 2ae4             sub ah, ah
  02EF78  2478: 8946fe           mov word ptr [bp - 2], ax
  02EF7B  247B: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  02EF7F  247F: 2aed             sub ch, ch
  02EF81  2481: 894efc           mov word ptr [bp - 4], cx
  02EF84  2484: 51               push cx
  02EF85  2485: 50               push ax
  02EF86  2486: 9a02031f18       lcall 0x181f, 0x302
  02EF8B  248B: 83c404           add sp, 4
  02EF8E  248E: 0bc0             or ax, ax
  02EF90  2490: 7503             jne 0x2495
  02EF92  2492: e9b500           jmp 0x254a
  02EF95  2495: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  02EF99  2499: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  02EF9E  249E: 7403             je 0x24a3
  02EFA0  24A0: e9a700           jmp 0x254a
  02EFA3  24A3: 80bf5b311b       cmp byte ptr [bx + 0x315b], 0x1b
  02EFA8  24A8: 7403             je 0x24ad
  02EFAA  24AA: e99d00           jmp 0x254a
  02EFAD  24AD: ff76fc           push word ptr [bp - 4]
  02EFB0  24B0: ff76fe           push word ptr [bp - 2]
  02EFB3  24B3: 8bf3             mov si, bx
  02EFB5  24B5: 9abe061f18       lcall 0x181f, 0x6be
  02EFBA  24BA: 83c404           add sp, 4
  02EFBD  24BD: 0bc0             or ax, ax
  02EFBF  24BF: 7c03             jl 0x24c4
  02EFC1  24C1: e98600           jmp 0x254a
  02EFC4  24C4: 6a02             push 2
  02EFC6  24C6: ff7606           push word ptr [bp + 6]
  02EFC9  24C9: 9abc081f18       lcall 0x181f, 0x8bc
  02EFCE  24CE: 83c404           add sp, 4
  02EFD1  24D1: 3d0200           cmp ax, 2
  02EFD4  24D4: 7d74             jge 0x254a
  02EFD6  24D6: fe845a31         inc byte ptr [si + 0x315a]
  02EFDA  24DA: 80bc5a3108       cmp byte ptr [si + 0x315a], 8
  02EFDF  24DF: 7669             jbe 0x254a
  02EFE1  24E1: 8a844731         mov al, byte ptr [si + 0x3147]
  02EFE5  24E5: 250f00           and ax, 0xf
  02EFE8  24E8: 8946f8           mov word ptr [bp - 8], ax
  02EFEB  24EB: 3d0400           cmp ax, 4
  02EFEE  24EE: 7d18             jge 0x2508
  02EFF0  24F0: 6bd834           imul bx, ax, 0x34
  02EFF3  24F3: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02EFF8  24F8: 750e             jne 0x2508
  02EFFA  24FA: ff76fc           push word ptr [bp - 4]
  02EFFD  24FD: ff76fe           push word ptr [bp - 2]
  02F000  2500: 9a9a0d1f18       lcall 0x181f, 0xd9a
  02F005  2505: 83c404           add sp, 4
  02F008  2508: ff7606           push word ptr [bp + 6]
  02F00B  250B: 9a08081f18       lcall 0x181f, 0x808
  02F010  2510: 83c402           add sp, 2
  02F013  2513: c746fa0000       mov word ptr [bp - 6], 0
  02F018  2518: 837ef804         cmp word ptr [bp - 8], 4
  02F01C  251C: 7d2c             jge 0x254a
  02F01E  251E: 6b5ef834         imul bx, word ptr [bp - 8], 0x34
  02F022  2522: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02F027  2527: 7521             jne 0x254a
  02F029  2529: 6a01             push 1
  02F02B  252B: 6a01             push 1
  02F02D  252D: 6a01             push 1
  02F02F  252F: ff76fc           push word ptr [bp - 4]
  02F032  2532: ff76fe           push word ptr [bp - 2]
  02F035  2535: 9aba091f18       lcall 0x181f, 0x9ba
  02F03A  253A: 83c40a           add sp, 0xa
  02F03D  253D: 6a04             push 4
  02F03F  253F: 68e20e           push 0xee2
  02F042  2542: 9a52061f18       lcall 0x181f, 0x652
  02F047  2547: 83c404           add sp, 4
  02F04A  254A: 8b46fa           mov ax, word ptr [bp - 6]
  02F04D  254D: 5e               pop si
  02F04E  254E: c9               leave 
  02F04F  254F: cb               retf 

; ---- func_02F052  size=847  insns=285  prologue=ENTER 0x000A,0  terminal=RETF ----
  02F052  2552: c80a0000         enter 0xa, 0
  02F056  2556: 57               push di
  02F057  2557: 56               push si
  02F058  2558: a19453           mov ax, word ptr [0x5394]
  02F05B  255B: 8946f8           mov word ptr [bp - 8], ax
  02F05E  255E: 8bd8             mov bx, ax
  02F060  2560: 8a874808         mov al, byte ptr [bx + 0x848]
  02F064  2564: 2ae4             sub ah, ah
  02F066  2566: 50               push ax
  02F067  2567: 9a90051f18       lcall 0x181f, 0x590
  02F06C  256C: 83c402           add sp, 2
  02F06F  256F: 2bc0             sub ax, ax
  02F071  2571: a34c01           mov word ptr [0x14c], ax
  02F074  2574: c7064e01ffff     mov word ptr [0x14e], 0xffff
  02F07A  257A: a19c53           mov ax, word ptr [0x539c]
  02F07D  257D: 48               dec ax
  02F07E  257E: 8946fa           mov word ptr [bp - 6], ax
  02F081  2581: eb16             jmp 0x2599
  02F083  2583: 90               nop 
  02F084  2584: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  02F088  2588: f687483180       test byte ptr [bx + 0x3148], 0x80
  02F08D  258D: 7407             je 0x2596
  02F08F  258F: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  02F094  2594: 7546             jne 0x25dc
  02F096  2596: ff4efa           dec word ptr [bp - 6]
  02F099  2599: 837efa00         cmp word ptr [bp - 6], 0
  02F09D  259D: 7d03             jge 0x25a2
  02F09F  259F: e96801           jmp 0x270a
  02F0A2  25A2: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  02F0A6  25A6: 8a874731         mov al, byte ptr [bx + 0x3147]
  02F0AA  25AA: 240f             and al, 0xf
  02F0AC  25AC: 3a46f8           cmp al, byte ptr [bp - 8]
  02F0AF  25AF: 75e5             jne 0x2596
  02F0B1  25B1: 8b46fa           mov ax, word ptr [bp - 6]
  02F0B4  25B4: 9aa0071f18       lcall 0x181f, 0x7a0
  02F0B9  25B9: ff76fa           push word ptr [bp - 6]
  02F0BC  25BC: 0e               push cs
  02F0BD  25BD: e82a0a           call 0x2fea
  02F0C0  25C0: 83c402           add sp, 2
  02F0C3  25C3: 0bc0             or ax, ax
  02F0C5  25C5: 74cf             je 0x2596
  02F0C7  25C7: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  02F0CB  25CB: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  02F0D0  25D0: 72c4             jb 0x2596
  02F0D2  25D2: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  02F0D7  25D7: 76ab             jbe 0x2584
  02F0D9  25D9: ebbb             jmp 0x2596
  02F0DB  25DB: 90               nop 
  02F0DC  25DC: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  02F0E0  25E0: fe875a31         inc byte ptr [bx + 0x315a]
  02F0E4  25E4: 8a874531         mov al, byte ptr [bx + 0x3145]
  02F0E8  25E8: 2ae4             sub ah, ah
  02F0EA  25EA: 50               push ax
  02F0EB  25EB: 8a874431         mov al, byte ptr [bx + 0x3144]
  02F0EF  25EF: 50               push ax
  02F0F0  25F0: 8bf3             mov si, bx
  02F0F2  25F2: 9a02031f18       lcall 0x181f, 0x302
  02F0F7  25F7: 83c404           add sp, 4
  02F0FA  25FA: 0bc0             or ax, ax
  02F0FC  25FC: 7404             je 0x2602
  02F0FE  25FE: fe845a31         inc byte ptr [si + 0x315a]
  02F102  2602: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  02F106  2606: 8a875a31         mov al, byte ptr [bx + 0x315a]
  02F10A  260A: 8d8f4631         lea cx, [bx + 0x3146]
  02F10E  260E: 8bf1             mov si, cx
  02F110  2610: 8bd3             mov dx, bx
  02F112  2612: 8a1c             mov bl, byte ptr [si]
  02F114  2614: 2ae4             sub ah, ah
  02F116  2616: 2aff             sub bh, bh
  02F118  2618: 8bfb             mov di, bx
  02F11A  261A: d1e3             shl bx, 1
  02F11C  261C: 03df             add bx, di
  02F11E  261E: d1e3             shl bx, 1
  02F120  2620: 03df             add bx, di
  02F122  2622: d1e3             shl bx, 1
  02F124  2624: 8bf8             mov di, ax
  02F126  2626: 8a873552         mov al, byte ptr [bx + 0x5235]
  02F12A  262A: 2bc7             sub ax, di
  02F12C  262C: 0bc0             or ax, ax
  02F12E  262E: 7e03             jle 0x2633
  02F130  2630: e963ff           jmp 0x2596
  02F133  2633: 8bda             mov bx, dx
  02F135  2635: 80a748317f       and byte ptr [bx + 0x3148], 0x7f
  02F13A  263A: 837ef804         cmp word ptr [bp - 8], 4
  02F13E  263E: 7c03             jl 0x2643
  02F140  2640: e953ff           jmp 0x2596
  02F143  2643: 6b7ef834         imul di, word ptr [bp - 8], 0x34
  02F147  2647: 80bd3f5400       cmp byte ptr [di + 0x543f], 0
  02F14C  264C: 7403             je 0x2651
  02F14E  264E: e945ff           jmp 0x2596
  02F151  2651: 8a1c             mov bl, byte ptr [si]
  02F153  2653: 2aff             sub bh, bh
  02F155  2655: 8bc3             mov ax, bx
  02F157  2657: d1e3             shl bx, 1
  02F159  2659: 03d8             add bx, ax
  02F15B  265B: d1e3             shl bx, 1
  02F15D  265D: 03d8             add bx, ax
  02F15F  265F: d1e3             shl bx, 1
  02F161  2661: ffb73052         push word ptr [bx + 0x5230]
  02F165  2665: 6a00             push 0
  02F167  2667: 8bf2             mov si, dx
  02F169  2669: 9a38041f18       lcall 0x181f, 0x438
  02F16E  266E: 83c404           add sp, 4
  02F171  2671: 8a844531         mov al, byte ptr [si + 0x3145]
  02F175  2675: 2ae4             sub ah, ah
  02F177  2677: 50               push ax
  02F178  2678: 8a844431         mov al, byte ptr [si + 0x3144]
  02F17C  267C: 50               push ax
  02F17D  267D: 9a02031f18       lcall 0x181f, 0x302
  02F182  2682: 83c404           add sp, 4
  02F185  2685: 0bc0             or ax, ax
  02F187  2687: 7431             je 0x26ba
  02F189  2689: 8a844531         mov al, byte ptr [si + 0x3145]
  02F18D  268D: 2ae4             sub ah, ah
  02F18F  268F: 50               push ax
  02F190  2690: 8a844431         mov al, byte ptr [si + 0x3144]
  02F194  2694: 50               push ax
  02F195  2695: 9abe071f18       lcall 0x181f, 0x7be
  02F19A  269A: 83c404           add sp, 4
  02F19D  269D: 8946f6           mov word ptr [bp - 0xa], ax
  02F1A0  26A0: 0bc0             or ax, ax
  02F1A2  26A2: 7c29             jl 0x26cd
  02F1A4  26A4: 69c0ca00         imul ax, ax, 0xca
  02F1A8  26A8: 05485d           add ax, 0x5d48
  02F1AB  26AB: 1e               push ds
  02F1AC  26AC: 50               push ax
  02F1AD  26AD: 6a01             push 1
  02F1AF  26AF: 9a16041f18       lcall 0x181f, 0x416
  02F1B4  26B4: 83c406           add sp, 6
  02F1B7  26B7: eb14             jmp 0x26cd
  02F1B9  26B9: 90               nop 
  02F1BA  26BA: 8b5ef8           mov bx, word ptr [bp - 8]
  02F1BD  26BD: d1e3             shl bx, 1
  02F1BF  26BF: ffb78c83         push word ptr [bx - 0x7c74]
  02F1C3  26C3: 6a01             push 1
  02F1C5  26C5: 9a38041f18       lcall 0x181f, 0x438
  02F1CA  26CA: 83c404           add sp, 4
  02F1CD  26CD: b85400           mov ax, 0x54
  02F1D0  26D0: 9ac0041f18       lcall 0x181f, 0x4c0
  02F1D5  26D5: 6a00             push 0
  02F1D7  26D7: 68ef0e           push 0xeef
  02F1DA  26DA: 9a52061f18       lcall 0x181f, 0x652
  02F1DF  26DF: 83c404           add sp, 4
  02F1E2  26E2: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  02F1E6  26E6: 8a874531         mov al, byte ptr [bx + 0x3145]
  02F1EA  26EA: 2ae4             sub ah, ah
  02F1EC  26EC: 50               push ax
  02F1ED  26ED: 8a874431         mov al, byte ptr [bx + 0x3144]
  02F1F1  26F1: 50               push ax
  02F1F2  26F2: 9a02031f18       lcall 0x181f, 0x302
  02F1F7  26F7: 83c404           add sp, 4
  02F1FA  26FA: 0bc0             or ax, ax
  02F1FC  26FC: 7403             je 0x2701
  02F1FE  26FE: e995fe           jmp 0x2596
  02F201  2701: c7064c010100     mov word ptr [0x14c], 1
  02F207  2707: e98cfe           jmp 0x2596
  02F20A  270A: ff76f8           push word ptr [bp - 8]
  02F20D  270D: 9a9e0a1f19       lcall 0x191f, 0xa9e
  02F212  2712: 83c402           add sp, 2
  02F215  2715: ff76f8           push word ptr [bp - 8]
  02F218  2718: 9a900a1f19       lcall 0x191f, 0xa90
  02F21D  271D: 83c402           add sp, 2
  02F220  2720: 9a820a1f19       lcall 0x191f, 0xa82
  02F225  2725: 833e4c0100       cmp word ptr [0x14c], 0
  02F22A  272A: 740f             je 0x273b
  02F22C  272C: ff364e01         push word ptr [0x14e]
  02F230  2730: ff76f8           push word ptr [bp - 8]
  02F233  2733: 9afa051f18       lcall 0x181f, 0x5fa
  02F238  2738: 83c404           add sp, 4
  02F23B  273B: 8b1efc84         mov bx, word ptr [0x84fc]
  02F23F  273F: c7470e0000       mov word ptr [bx + 0xe], 0
  02F244  2744: a19e53           mov ax, word ptr [0x539e]
  02F247  2747: 48               dec ax
  02F248  2748: 8946f6           mov word ptr [bp - 0xa], ax
  02F24B  274B: eb1d             jmp 0x276a
  02F24D  274D: 90               nop 
  02F24E  274E: 8a46f8           mov al, byte ptr [bp - 8]
  02F251  2751: 695ef6ca00       imul bx, word ptr [bp - 0xa], 0xca
  02F256  2756: 3887605d         cmp byte ptr [bx + 0x5d60], al
  02F25A  275A: 750b             jne 0x2767
  02F25C  275C: ff76f6           push word ptr [bp - 0xa]
  02F25F  275F: 9a50091f19       lcall 0x191f, 0x950
  02F264  2764: 83c402           add sp, 2
  02F267  2767: ff4ef6           dec word ptr [bp - 0xa]
  02F26A  276A: 837ef600         cmp word ptr [bp - 0xa], 0
  02F26E  276E: 7dde             jge 0x274e
  02F270  2770: ff76f8           push word ptr [bp - 8]
  02F273  2773: 9a740a1f19       lcall 0x191f, 0xa74
  02F278  2778: 83c402           add sp, 2
  02F27B  277B: ff76f8           push word ptr [bp - 8]
  02F27E  277E: 9a660a1f19       lcall 0x191f, 0xa66
  02F283  2783: 83c402           add sp, 2
  02F286  2786: 803e9ba800       cmp byte ptr [0xa89b], 0
  02F28B  278B: 750a             jne 0x2797
  02F28D  278D: 803e9aa803       cmp byte ptr [0xa89a], 3
  02F292  2792: 7703             ja 0x2797
  02F294  2794: e90601           jmp 0x289d
  02F297  2797: 6b5ef813         imul bx, word ptr [bp - 8], 0x13
  02F29B  279B: 80bf5d9200       cmp byte ptr [bx - 0x6da3], 0
  02F2A0  27A0: 7403             je 0x27a5
  02F2A2  27A2: e9f800           jmp 0x289d
  02F2A5  27A5: f606825301       test byte ptr [0x5382], 1
  02F2AA  27AA: 7403             je 0x27af
  02F2AC  27AC: e9ee00           jmp 0x289d
  02F2AF  27AF: f6068e5307       test byte ptr [0x538e], 7
  02F2B4  27B4: 7403             je 0x27b9
  02F2B6  27B6: e9e400           jmp 0x289d
  02F2B9  27B9: 837ef804         cmp word ptr [bp - 8], 4
  02F2BD  27BD: 7d63             jge 0x2822
  02F2BF  27BF: 6b5ef834         imul bx, word ptr [bp - 8], 0x34
  02F2C3  27C3: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02F2C8  27C8: 7558             jne 0x2822
  02F2CA  27CA: 8bc3             mov ax, bx
  02F2CC  27CC: 8a1ea653         mov bl, byte ptr [0x53a6]
  02F2D0  27D0: 2aff             sub bh, bh
  02F2D2  27D2: d1e3             shl bx, 1
  02F2D4  27D4: ffb79483         push word ptr [bx - 0x7c6c]
  02F2D8  27D8: 6a00             push 0
  02F2DA  27DA: 8bf0             mov si, ax
  02F2DC  27DC: 9a38041f18       lcall 0x181f, 0x438
  02F2E1  27E1: 83c404           add sp, 4
  02F2E4  27E4: 81c60e54         add si, 0x540e
  02F2E8  27E8: 1e               push ds
  02F2E9  27E9: 56               push si
  02F2EA  27EA: 6a01             push 1
  02F2EC  27EC: 9a16041f18       lcall 0x181f, 0x416
  02F2F1  27F1: 83c406           add sp, 6
  02F2F4  27F4: ff76f8           push word ptr [bp - 8]
  02F2F7  27F7: 9aa4091f18       lcall 0x181f, 0x9a4
  02F2FC  27FC: 83c402           add sp, 2
  02F2FF  27FF: 50               push ax
  02F300  2800: 6a02             push 2
  02F302  2802: 9a38041f18       lcall 0x181f, 0x438
  02F307  2807: 83c404           add sp, 4
  02F30A  280A: 6a3e             push 0x3e
  02F30C  280C: 9a8e041f18       lcall 0x181f, 0x48e
  02F311  2811: 83c402           add sp, 2
  02F314  2814: 8d1ef50e         lea bx, [0xef5]
  02F318  2818: 9afe031f18       lcall 0x181f, 0x3fe
  02F31D  281D: 8946fe           mov word ptr [bp - 2], ax
  02F320  2820: eb05             jmp 0x2827
  02F322  2822: c746fe0100       mov word ptr [bp - 2], 1
  02F327  2827: 837efe01         cmp word ptr [bp - 2], 1
  02F32B  282B: 7570             jne 0x289d
  02F32D  282D: 8b46f8           mov ax, word ptr [bp - 8]
  02F330  2830: 2d1800           sub ax, 0x18
  02F333  2833: 50               push ax
  02F334  2834: 50               push ax
  02F335  2835: ff76f8           push word ptr [bp - 8]
  02F338  2838: 6a11             push 0x11
  02F33A  283A: 9a5c091f18       lcall 0x181f, 0x95c
  02F33F  283F: 83c408           add sp, 8
  02F342  2842: 8946fa           mov word ptr [bp - 6], ax
  02F345  2845: 0bc0             or ax, ax
  02F347  2847: 7c54             jl 0x289d
  02F349  2849: 6bd81c           imul bx, ax, 0x1c
  02F34C  284C: c6874c3100       mov byte ptr [bx + 0x314c], 0
  02F351  2851: 8b36fc84         mov si, word ptr [0x84fc]
  02F355  2855: 8a4432           mov al, byte ptr [si + 0x32]
  02F358  2858: 88874d31         mov byte ptr [bx + 0x314d], al
  02F35C  285C: 8a4c33           mov cl, byte ptr [si + 0x33]
  02F35F  285F: 888f4e31         mov byte ptr [bx + 0x314e], cl
  02F363  2863: 2aed             sub ch, ch
  02F365  2865: 51               push cx
  02F366  2866: 2ae4             sub ah, ah
  02F368  2868: 50               push ax
  02F369  2869: ff76fa           push word ptr [bp - 6]
  02F36C  286C: 8bf3             mov si, bx
  02F36E  286E: 9aee0a1f19       lcall 0x191f, 0xaee
  02F373  2873: 83c406           add sp, 6
  02F376  2876: 88845a31         mov byte ptr [si + 0x315a], al
  02F37A  287A: 808c483140       or byte ptr [si + 0x3148], 0x40
  02F37F  287F: 837ef804         cmp word ptr [bp - 8], 4
  02F383  2883: 7d18             jge 0x289d
  02F385  2885: 6b5ef834         imul bx, word ptr [bp - 8], 0x34
  02F389  2889: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02F38E  288E: 750d             jne 0x289d
  02F390  2890: 6a0a             push 0xa
  02F392  2892: 68010f           push 0xf01
  02F395  2895: 9ae00a1f19       lcall 0x191f, 0xae0
  02F39A  289A: 83c404           add sp, 4
  02F39D  289D: 5e               pop si
  02F39E  289E: 5f               pop di
  02F39F  289F: c9               leave 
  02F3A0  28A0: cb               retf 

; ---- func_02F3A2  size=1869  insns=627  prologue=ENTER 0x0078,0  terminal=page-end ----
  02F3A2  28A2: c8780000         enter 0x78, 0
  02F3A6  28A6: 57               push di
  02F3A7  28A7: 56               push si
  02F3A8  28A8: c746a20100       mov word ptr [bp - 0x5e], 1
  02F3AD  28AD: f606825301       test byte ptr [0x5382], 1
  02F3B2  28B2: 740c             je 0x28c0
  02F3B4  28B4: ff36d253         push word ptr [0x53d2]
  02F3B8  28B8: 9a740a1f19       lcall 0x191f, 0xa74
  02F3BD  28BD: 83c402           add sp, 2
  02F3C0  28C0: ff369853         push word ptr [0x5398]
  02F3C4  28C4: 9a740a1f19       lcall 0x191f, 0xa74
  02F3C9  28C9: 83c402           add sp, 2
  02F3CC  28CC: 8b1e9853         mov bx, word ptr [0x5398]
  02F3D0  28D0: c687989200       mov byte ptr [bx - 0x6d68], 0
  02F3D5  28D5: c7468c0000       mov word ptr [bp - 0x74], 0
  02F3DA  28DA: eb18             jmp 0x28f4
  02F3DC  28DC: 69d8ca00         imul bx, ax, 0xca
  02F3E0  28E0: a09853           mov al, byte ptr [0x5398]
  02F3E3  28E3: 3887605d         cmp byte ptr [bx + 0x5d60], al
  02F3E7  28E7: 7508             jne 0x28f1
  02F3E9  28E9: 8b1e9853         mov bx, word ptr [0x5398]
  02F3ED  28ED: fe879892         inc byte ptr [bx - 0x6d68]
  02F3F1  28F1: ff468c           inc word ptr [bp - 0x74]
  02F3F4  28F4: 8b468c           mov ax, word ptr [bp - 0x74]
  02F3F7  28F7: 39069e53         cmp word ptr [0x539e], ax
  02F3FB  28FB: 7fdf             jg 0x28dc
  02F3FD  28FD: 813e8a534006     cmp word ptr [0x538a], 0x640
  02F403  2903: 7c5f             jl 0x2964
  02F405  2905: 8b1e9853         mov bx, word ptr [0x5398]
  02F409  2909: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  02F40E  290E: 7554             jne 0x2964
  02F410  2910: f606825301       test byte ptr [0x5382], 1
  02F415  2915: 754d             jne 0x2964
  02F417  2917: 8a1ea653         mov bl, byte ptr [0x53a6]
  02F41B  291B: 2aff             sub bh, bh
  02F41D  291D: d1e3             shl bx, 1
  02F41F  291F: ffb79483         push word ptr [bx - 0x7c6c]
  02F423  2923: 6a00             push 0
  02F425  2925: 9a38041f18       lcall 0x181f, 0x438
  02F42A  292A: 83c404           add sp, 4
  02F42D  292D: 6b06985334       imul ax, word ptr [0x5398], 0x34
  02F432  2932: 050e54           add ax, 0x540e
  02F435  2935: 1e               push ds
  02F436  2936: 50               push ax
  02F437  2937: 6a01             push 1
  02F439  2939: 9a16041f18       lcall 0x181f, 0x416
  02F43E  293E: 83c406           add sp, 6
  02F441  2941: 68090f           push 0xf09
  02F444  2944: 9ad40a1f19       lcall 0x191f, 0xad4
  02F449  2949: 83c402           add sp, 2
  02F44C  294C: f606825310       test byte ptr [0x5382], 0x10
  02F451  2951: 7505             jne 0x2958
  02F453  2953: 9a74051f18       lcall 0x181f, 0x574
  02F458  2958: 2bc0             sub ax, ax
  02F45A  295A: a3c253           mov word ptr [0x53c2], ax
  02F45D  295D: 8946a2           mov word ptr [bp - 0x5e], ax
  02F460  2960: e94706           jmp 0x2faa
  02F463  2963: 90               nop 
  02F464  2964: f606825301       test byte ptr [0x5382], 1
  02F469  2969: 7503             jne 0x296e
  02F46B  296B: e9be02           jmp 0x2c2c
  02F46E  296E: f606825308       test byte ptr [0x5382], 8
  02F473  2973: 7403             je 0x2978
  02F475  2975: e9b402           jmp 0x2c2c
  02F478  2978: 8b1ed253         mov bx, word ptr [0x53d2]
  02F47C  297C: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  02F481  2981: 740a             je 0x298d
  02F483  2983: f606825320       test byte ptr [0x5382], 0x20
  02F488  2988: 7503             jne 0x298d
  02F48A  298A: e9db00           jmp 0x2a68
  02F48D  298D: 2bc0             sub ax, ax
  02F48F  298F: 8946a8           mov word ptr [bp - 0x58], ax
  02F492  2992: 894694           mov word ptr [bp - 0x6c], ax
  02F495  2995: eb33             jmp 0x29ca
  02F497  2997: 90               nop 
  02F498  2998: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  02F49C  299C: 8a874731         mov al, byte ptr [bx + 0x3147]
  02F4A0  29A0: 240f             and al, 0xf
  02F4A2  29A2: 3a06d253         cmp al, byte ptr [0x53d2]
  02F4A6  29A6: 751f             jne 0x29c7
  02F4A8  29A8: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  02F4AC  29AC: 8a874631         mov al, byte ptr [bx + 0x3146]
  02F4B0  29B0: 2ae4             sub ah, ah
  02F4B2  29B2: 8946a0           mov word ptr [bp - 0x60], ax
  02F4B5  29B5: 3d0600           cmp ax, 6
  02F4B8  29B8: 740a             je 0x29c4
  02F4BA  29BA: 3d0800           cmp ax, 8
  02F4BD  29BD: 7405             je 0x29c4
  02F4BF  29BF: 3d0b00           cmp ax, 0xb
  02F4C2  29C2: 7503             jne 0x29c7
  02F4C4  29C4: ff46a8           inc word ptr [bp - 0x58]
  02F4C7  29C7: ff4694           inc word ptr [bp - 0x6c]
  02F4CA  29CA: a19c53           mov ax, word ptr [0x539c]
  02F4CD  29CD: 394694           cmp word ptr [bp - 0x6c], ax
  02F4D0  29D0: 7cc6             jl 0x2998
  02F4D2  29D2: a08253           mov al, byte ptr [0x5382]
  02F4D5  29D5: 254000           and ax, 0x40
  02F4D8  29D8: 3d0100           cmp ax, 1
  02F4DB  29DB: 1bc0             sbb ax, ax
  02F4DD  29DD: 24f9             and al, 0xf9
  02F4DF  29DF: 050800           add ax, 8
  02F4E2  29E2: 3b46a8           cmp ax, word ptr [bp - 0x58]
  02F4E5  29E5: 7f07             jg 0x29ee
  02F4E7  29E7: f606825320       test byte ptr [0x5382], 0x20
  02F4EC  29EC: 747a             je 0x2a68
  02F4EE  29EE: 833ee05301       cmp word ptr [0x53e0], 1
  02F4F3  29F3: 1bc0             sbb ax, ax
  02F4F5  29F5: 40               inc ax
  02F4F6  29F6: 833edc5301       cmp word ptr [0x53dc], 1
  02F4FB  29FB: 1bc9             sbb cx, cx
  02F4FD  29FD: 41               inc cx
  02F4FE  29FE: 03c1             add ax, cx
  02F500  2A00: 0306da53         add ax, word ptr [0x53da]
  02F504  2A04: 3d0400           cmp ax, 4
  02F507  2A07: 7c07             jl 0x2a10
  02F509  2A09: f606825320       test byte ptr [0x5382], 0x20
  02F50E  2A0E: 7458             je 0x2a68
  02F510  2A10: 6b06985334       imul ax, word ptr [0x5398], 0x34
  02F515  2A15: 050e54           add ax, 0x540e
  02F518  2A18: 1e               push ds
  02F519  2A19: 50               push ax
  02F51A  2A1A: 6a00             push 0
  02F51C  2A1C: 9a16041f18       lcall 0x181f, 0x416
  02F521  2A21: 83c406           add sp, 6
  02F524  2A24: 6b06985334       imul ax, word ptr [0x5398], 0x34
  02F529  2A29: 052654           add ax, 0x5426
  02F52C  2A2C: 1e               push ds
  02F52D  2A2D: 50               push ax
  02F52E  2A2E: 6a01             push 1
  02F530  2A30: 9a16041f18       lcall 0x181f, 0x416
  02F535  2A35: 83c406           add sp, 6
  02F538  2A38: 6a03             push 3
  02F53A  2A3A: 9aac041f18       lcall 0x181f, 0x4ac
  02F53F  2A3F: 83c402           add sp, 2
  02F542  2A42: 8d1e180f         lea bx, [0xf18]
  02F546  2A46: 9afe031f18       lcall 0x181f, 0x3fe
  02F54B  2A4B: 68200f           push 0xf20
  02F54E  2A4E: 6a02             push 2
  02F550  2A50: 6a01             push 1
  02F552  2A52: 9aba0a1f19       lcall 0x191f, 0xaba
  02F557  2A57: 83c406           add sp, 6
  02F55A  2A5A: 800e825308       or byte ptr [0x5382], 8
  02F55F  2A5F: c70604010100     mov word ptr [0x104], 1
  02F565  2A65: e94205           jmp 0x2faa
  02F568  2A68: 2bc0             sub ax, ax
  02F56A  2A6A: 89469a           mov word ptr [bp - 0x66], ax
  02F56D  2A6D: 89468c           mov word ptr [bp - 0x74], ax
  02F570  2A70: eb21             jmp 0x2a93
  02F572  2A72: 50               push ax
  02F573  2A73: 9ae6091f18       lcall 0x181f, 0x9e6
  02F578  2A78: 83c402           add sp, 2
  02F57B  2A7B: a09853           mov al, byte ptr [0x5398]
  02F57E  2A7E: 8b1e4285         mov bx, word ptr [0x8542]
  02F582  2A82: 38471a           cmp byte ptr [bx + 0x1a], al
  02F585  2A85: 7509             jne 0x2a90
  02F587  2A87: f6471c40         test byte ptr [bx + 0x1c], 0x40
  02F58B  2A8B: 7403             je 0x2a90
  02F58D  2A8D: ff469a           inc word ptr [bp - 0x66]
  02F590  2A90: ff468c           inc word ptr [bp - 0x74]
  02F593  2A93: 8b468c           mov ax, word ptr [bp - 0x74]
  02F596  2A96: 39069e53         cmp word ptr [0x539e], ax
  02F59A  2A9A: 7fd6             jg 0x2a72
  02F59C  2A9C: 2bc0             sub ax, ax
  02F59E  2A9E: 8946a4           mov word ptr [bp - 0x5c], ax
  02F5A1  2AA1: 89469c           mov word ptr [bp - 0x64], ax
  02F5A4  2AA4: 837e9a03         cmp word ptr [bp - 0x66], 3
  02F5A8  2AA8: 7d05             jge 0x2aaf
  02F5AA  2AAA: c7469c0100       mov word ptr [bp - 0x64], 1
  02F5AF  2AAF: 39469a           cmp word ptr [bp - 0x66], ax
  02F5B2  2AB2: 7505             jne 0x2ab9
  02F5B4  2AB4: c746a40100       mov word ptr [bp - 0x5c], 1
  02F5B9  2AB9: 8b1ed253         mov bx, word ptr [0x53d2]
  02F5BD  2ABD: 80bf0c9400       cmp byte ptr [bx - 0x6bf4], 0
  02F5C2  2AC2: 7408             je 0x2acc
  02F5C4  2AC4: 8a870c94         mov al, byte ptr [bx - 0x6bf4]
  02F5C8  2AC8: 2ae4             sub ah, ah
  02F5CA  2ACA: eb09             jmp 0x2ad5
  02F5CC  2ACC: 8a870c94         mov al, byte ptr [bx - 0x6bf4]
  02F5D0  2AD0: 2ae4             sub ah, ah
  02F5D2  2AD2: f7d0             not ax
  02F5D4  2AD4: 40               inc ax
  02F5D5  2AD5: 40               inc ax
  02F5D6  2AD6: 89468e           mov word ptr [bp - 0x72], ax
  02F5D9  2AD9: 8b1e9853         mov bx, word ptr [0x5398]
  02F5DD  2ADD: 80bf0c9400       cmp byte ptr [bx - 0x6bf4], 0
  02F5E2  2AE2: 7408             je 0x2aec
  02F5E4  2AE4: 8a870c94         mov al, byte ptr [bx - 0x6bf4]
  02F5E8  2AE8: 2ae4             sub ah, ah
  02F5EA  2AEA: eb09             jmp 0x2af5
  02F5EC  2AEC: 8a870c94         mov al, byte ptr [bx - 0x6bf4]
  02F5F0  2AF0: 2ae4             sub ah, ah
  02F5F2  2AF2: f7d0             not ax
  02F5F4  2AF4: 40               inc ax
  02F5F5  2AF5: 40               inc ax
  02F5F6  2AF6: 894698           mov word ptr [bp - 0x68], ax
  02F5F9  2AF9: 8bc8             mov cx, ax
  02F5FB  2AFB: 034e8e           add cx, word ptr [bp - 0x72]
  02F5FE  2AFE: 6b468e64         imul ax, word ptr [bp - 0x72], 0x64
  02F602  2B02: 99               cdq 
  02F603  2B03: f7f9             idiv cx
  02F605  2B05: 8946fa           mov word ptr [bp - 6], ax
  02F608  2B08: 3d5000           cmp ax, 0x50
  02F60B  2B0B: 7c05             jl 0x2b12
  02F60D  2B0D: c7469c0300       mov word ptr [bp - 0x64], 3
  02F612  2B12: 3d5a00           cmp ax, 0x5a
  02F615  2B15: 7c05             jl 0x2b1c
  02F617  2B17: c746a40300       mov word ptr [bp - 0x5c], 3
  02F61C  2B1C: 80bf989203       cmp byte ptr [bx - 0x6d68], 3
  02F621  2B21: 7305             jae 0x2b28
  02F623  2B23: c7469c0200       mov word ptr [bp - 0x64], 2
  02F628  2B28: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  02F62D  2B2D: 7505             jne 0x2b34
  02F62F  2B2F: c746a40200       mov word ptr [bp - 0x5c], 2
  02F634  2B34: 837ea400         cmp word ptr [bp - 0x5c], 0
  02F638  2B38: 747e             je 0x2bb8
  02F63A  2B3A: 6bc334           imul ax, bx, 0x34
  02F63D  2B3D: 052654           add ax, 0x5426
  02F640  2B40: 1e               push ds
  02F641  2B41: 50               push ax
  02F642  2B42: 6a00             push 0
  02F644  2B44: 9a16041f18       lcall 0x181f, 0x416
  02F649  2B49: 83c406           add sp, 6
  02F64C  2B4C: 6b06985334       imul ax, word ptr [0x5398], 0x34
  02F651  2B51: 050e54           add ax, 0x540e
  02F654  2B54: 1e               push ds
  02F655  2B55: 50               push ax
  02F656  2B56: 6a01             push 1
  02F658  2B58: 9a16041f18       lcall 0x181f, 0x416
  02F65D  2B5D: 83c406           add sp, 6
  02F660  2B60: ff36d453         push word ptr [0x53d4]
  02F664  2B64: 6a00             push 0
  02F666  2B66: 6a02             push 2
  02F668  2B68: 9ac80a1f19       lcall 0x191f, 0xac8
  02F66D  2B6D: 83c406           add sp, 6
  02F670  2B70: 68290f           push 0xf29
  02F673  2B73: 8d46aa           lea ax, [bp - 0x56]
  02F676  2B76: 50               push ax
  02F677  2B77: 9ae4071d0d       lcall 0xd1d, 0x7e4
  02F67C  2B7C: 83c404           add sp, 4
  02F67F  2B7F: 8a46a4           mov al, byte ptr [bp - 0x5c]
  02F682  2B82: 0046b0           add byte ptr [bp - 0x50], al
  02F685  2B85: 8d5eaa           lea bx, [bp - 0x56]
  02F688  2B88: 9afe031f18       lcall 0x181f, 0x3fe
  02F68D  2B8D: 8b1e9853         mov bx, word ptr [0x5398]
  02F691  2B91: d1e3             shl bx, 1
  02F693  2B93: ffb7428d         push word ptr [bx - 0x72be]
  02F697  2B97: 6a00             push 0
  02F699  2B99: 9a38041f18       lcall 0x181f, 0x438
  02F69E  2B9E: 83c404           add sp, 4
  02F6A1  2BA1: 68310f           push 0xf31
  02F6A4  2BA4: 6a01             push 1
  02F6A6  2BA6: 6a02             push 2
  02F6A8  2BA8: 9aba0a1f19       lcall 0x191f, 0xaba
  02F6AD  2BAD: 83c406           add sp, 6
  02F6B0  2BB0: 9aac0a1f19       lcall 0x191f, 0xaac
  02F6B5  2BB5: e994fd           jmp 0x294c
  02F6B8  2BB8: 837e9c00         cmp word ptr [bp - 0x64], 0
  02F6BC  2BBC: 746e             je 0x2c2c
  02F6BE  2BBE: 68390f           push 0xf39
  02F6C1  2BC1: 8d46aa           lea ax, [bp - 0x56]
  02F6C4  2BC4: 50               push ax
  02F6C5  2BC5: 9ae4071d0d       lcall 0xd1d, 0x7e4
  02F6CA  2BCA: 83c404           add sp, 4
  02F6CD  2BCD: 8a469c           mov al, byte ptr [bp - 0x64]
  02F6D0  2BD0: 0046ae           add byte ptr [bp - 0x52], al
  02F6D3  2BD3: 6b06985334       imul ax, word ptr [0x5398], 0x34
  02F6D8  2BD8: 052654           add ax, 0x5426
  02F6DB  2BDB: 1e               push ds
  02F6DC  2BDC: 50               push ax
  02F6DD  2BDD: 6a00             push 0
  02F6DF  2BDF: 9a16041f18       lcall 0x181f, 0x416
  02F6E4  2BE4: 83c406           add sp, 6
  02F6E7  2BE7: 8b469a           mov ax, word ptr [bp - 0x66]
  02F6EA  2BEA: 99               cdq 
  02F6EB  2BEB: 52               push dx
  02F6EC  2BEC: 50               push ax
  02F6ED  2BED: 6a00             push 0
  02F6EF  2BEF: 9aae091f18       lcall 0x181f, 0x9ae
  02F6F4  2BF4: 83c406           add sp, 6
  02F6F7  2BF7: 8b1e9853         mov bx, word ptr [0x5398]
  02F6FB  2BFB: 8a879892         mov al, byte ptr [bx - 0x6d68]
  02F6FF  2BFF: 2ae4             sub ah, ah
  02F701  2C01: 6a00             push 0
  02F703  2C03: 50               push ax
  02F704  2C04: 6a01             push 1
  02F706  2C06: 9aae091f18       lcall 0x181f, 0x9ae
  02F70B  2C0B: 83c406           add sp, 6
  02F70E  2C0E: 8b46fa           mov ax, word ptr [bp - 6]
  02F711  2C11: 99               cdq 
  02F712  2C12: 52               push dx
  02F713  2C13: 50               push ax
  02F714  2C14: 6a02             push 2
  02F716  2C16: 9aae091f18       lcall 0x181f, 0x9ae
  02F71B  2C1B: 83c406           add sp, 6
  02F71E  2C1E: 6a01             push 1
  02F720  2C20: 8d46aa           lea ax, [bp - 0x56]
  02F723  2C23: 50               push ax
  02F724  2C24: 9a52061f18       lcall 0x181f, 0x652
  02F729  2C29: 83c404           add sp, 4
  02F72C  2C2C: f606825301       test byte ptr [0x5382], 1
  02F731  2C31: 7403             je 0x2c36
  02F733  2C33: e92c02           jmp 0x2e62
  02F736  2C36: c746920000       mov word ptr [bp - 0x6e], 0
  02F73B  2C3B: e94901           jmp 0x2d87
  02F73E  2C3E: ff46fe           inc word ptr [bp - 2]
  02F741  2C41: 837efe04         cmp word ptr [bp - 2], 4
  02F745  2C45: 7c03             jl 0x2c4a
  02F747  2C47: e93a01           jmp 0x2d84
  02F74A  2C4A: 8b46fe           mov ax, word ptr [bp - 2]
  02F74D  2C4D: 394692           cmp word ptr [bp - 0x6e], ax
  02F750  2C50: 74ec             je 0x2c3e
  02F752  2C52: 6a40             push 0x40
  02F754  2C54: 50               push ax
  02F755  2C55: ff7692           push word ptr [bp - 0x6e]
  02F758  2C58: 9a060a1f18       lcall 0x181f, 0xa06
  02F75D  2C5D: 83c406           add sp, 6
  02F760  2C60: 68bb00           push 0xbb
  02F763  2C63: ff76fe           push word ptr [bp - 2]
  02F766  2C66: ff7692           push word ptr [bp - 0x6e]
  02F769  2C69: 9a100a1f18       lcall 0x181f, 0xa10
  02F76E  2C6E: 83c406           add sp, 6
  02F771  2C71: ebcb             jmp 0x2c3e
  02F773  2C73: 90               nop 
  02F774  2C74: 8bc1             mov ax, cx
  02F776  2C76: 2d1400           sub ax, 0x14
  02F779  2C79: 3b469e           cmp ax, word ptr [bp - 0x62]
  02F77C  2C7C: 7e03             jle 0x2c81
  02F77E  2C7E: e98000           jmp 0x2d01
  02F781  2C81: 8b1efc84         mov bx, word ptr [0x84fc]
  02F785  2C85: 8a471a           mov al, byte ptr [bx + 0x1a]
  02F788  2C88: 2ae4             sub ah, ah
  02F78A  2C8A: 3b469e           cmp ax, word ptr [bp - 0x62]
  02F78D  2C8D: 7d72             jge 0x2d01
  02F78F  2C8F: ff7692           push word ptr [bp - 0x6e]
  02F792  2C92: 6a00             push 0
  02F794  2C94: 6a00             push 0
  02F796  2C96: 9ac80a1f19       lcall 0x191f, 0xac8
  02F79B  2C9B: 83c406           add sp, 6
  02F79E  2C9E: 8b469e           mov ax, word ptr [bp - 0x62]
  02F7A1  2CA1: 99               cdq 
  02F7A2  2CA2: 52               push dx
  02F7A3  2CA3: 50               push ax
  02F7A4  2CA4: 6a00             push 0
  02F7A6  2CA6: 9aae091f18       lcall 0x181f, 0x9ae
  02F7AB  2CAB: 83c406           add sp, 6
  02F7AE  2CAE: 8b5e92           mov bx, word ptr [bp - 0x6e]
  02F7B1  2CB1: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  02F7B5  2CB5: 2ae4             sub ah, ah
  02F7B7  2CB7: 6a00             push 0
  02F7B9  2CB9: 50               push ax
  02F7BA  2CBA: 6a01             push 1
  02F7BC  2CBC: 9aae091f18       lcall 0x181f, 0x9ae
  02F7C1  2CC1: 83c406           add sp, 6
  02F7C4  2CC4: 8b46fc           mov ax, word ptr [bp - 4]
  02F7C7  2CC7: 99               cdq 
  02F7C8  2CC8: 52               push dx
  02F7C9  2CC9: 50               push ax
  02F7CA  2CCA: 6a02             push 2
  02F7CC  2CCC: 9aae091f18       lcall 0x181f, 0x9ae
  02F7D1  2CD1: 83c406           add sp, 6
  02F7D4  2CD4: ff7692           push word ptr [bp - 0x6e]
  02F7D7  2CD7: 9aa4091f18       lcall 0x181f, 0x9a4
  02F7DC  2CDC: 83c402           add sp, 2
  02F7DF  2CDF: 50               push ax
  02F7E0  2CE0: 6a01             push 1
  02F7E2  2CE2: 9a38041f18       lcall 0x181f, 0x438
  02F7E7  2CE7: 83c404           add sp, 4
  02F7EA  2CEA: 6a02             push 2
  02F7EC  2CEC: 685e0f           push 0xf5e
  02F7EF  2CEF: 9a52061f18       lcall 0x181f, 0x652
  02F7F4  2CF4: 83c404           add sp, 4
  02F7F7  2CF7: 8a469e           mov al, byte ptr [bp - 0x62]
  02F7FA  2CFA: 8b1efc84         mov bx, word ptr [0x84fc]
  02F7FE  2CFE: 88471a           mov byte ptr [bx + 0x1a], al
  02F801  2D01: 8b1efc84         mov bx, word ptr [0x84fc]
  02F805  2D05: 8a471a           mov al, byte ptr [bx + 0x1a]
  02F808  2D08: 2ae4             sub ah, ah
  02F80A  2D0A: 2d0500           sub ax, 5
  02F80D  2D0D: 3b469e           cmp ax, word ptr [bp - 0x62]
  02F810  2D10: 7e72             jle 0x2d84
  02F812  2D12: ff7692           push word ptr [bp - 0x6e]
  02F815  2D15: 6a00             push 0
  02F817  2D17: 6a00             push 0
  02F819  2D19: 9ac80a1f19       lcall 0x191f, 0xac8
  02F81E  2D1E: 83c406           add sp, 6
  02F821  2D21: 8b469e           mov ax, word ptr [bp - 0x62]
  02F824  2D24: 99               cdq 
  02F825  2D25: 52               push dx
  02F826  2D26: 50               push ax
  02F827  2D27: 6a00             push 0
  02F829  2D29: 9aae091f18       lcall 0x181f, 0x9ae
  02F82E  2D2E: 83c406           add sp, 6
  02F831  2D31: 8b5e92           mov bx, word ptr [bp - 0x6e]
  02F834  2D34: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  02F838  2D38: 2ae4             sub ah, ah
  02F83A  2D3A: 6a00             push 0
  02F83C  2D3C: 50               push ax
  02F83D  2D3D: 6a01             push 1
  02F83F  2D3F: 9aae091f18       lcall 0x181f, 0x9ae
  02F844  2D44: 83c406           add sp, 6
  02F847  2D47: 8b46fc           mov ax, word ptr [bp - 4]
  02F84A  2D4A: 99               cdq 
  02F84B  2D4B: 52               push dx
  02F84C  2D4C: 50               push ax
  02F84D  2D4D: 6a02             push 2
  02F84F  2D4F: 9aae091f18       lcall 0x181f, 0x9ae
  02F854  2D54: 83c406           add sp, 6
  02F857  2D57: ff7692           push word ptr [bp - 0x6e]
  02F85A  2D5A: 9aa4091f18       lcall 0x181f, 0x9a4
  02F85F  2D5F: 83c402           add sp, 2
  02F862  2D62: 50               push ax
  02F863  2D63: 6a01             push 1
  02F865  2D65: 9a38041f18       lcall 0x181f, 0x438
  02F86A  2D6A: 83c404           add sp, 4
  02F86D  2D6D: 6a02             push 2
  02F86F  2D6F: 68690f           push 0xf69
  02F872  2D72: 9a52061f18       lcall 0x181f, 0x652
  02F877  2D77: 83c404           add sp, 4
  02F87A  2D7A: 8a469e           mov al, byte ptr [bp - 0x62]
  02F87D  2D7D: 8b1efc84         mov bx, word ptr [0x84fc]
  02F881  2D81: 88471a           mov byte ptr [bx + 0x1a], al
  02F884  2D84: ff4692           inc word ptr [bp - 0x6e]
  02F887  2D87: 837e9204         cmp word ptr [bp - 0x6e], 4
  02F88B  2D8B: 7c03             jl 0x2d90
  02F88D  2D8D: e9d200           jmp 0x2e62
  02F890  2D90: 7d0b             jge 0x2d9d
  02F892  2D92: 6b5e9234         imul bx, word ptr [bp - 0x6e], 0x34
  02F896  2D96: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  02F89B  2D9B: 74e7             je 0x2d84
  02F89D  2D9D: ff7692           push word ptr [bp - 0x6e]
  02F8A0  2DA0: 9a82051f18       lcall 0x181f, 0x582
  02F8A5  2DA5: 83c402           add sp, 2
  02F8A8  2DA8: 8b1efc84         mov bx, word ptr [0x84fc]
  02F8AC  2DAC: f60704           test byte ptr [bx], 4
  02F8AF  2DAF: 75d3             jne 0x2d84
  02F8B1  2DB1: 8a4719           mov al, byte ptr [bx + 0x19]
  02F8B4  2DB4: 8b5e92           mov bx, word ptr [bp - 0x6e]
  02F8B7  2DB7: f6a71094         mul byte ptr [bx - 0x6bf0]
  02F8BB  2DBB: b96400           mov cx, 0x64
  02F8BE  2DBE: 99               cdq 
  02F8BF  2DBF: f7f9             idiv cx
  02F8C1  2DC1: 3bc1             cmp ax, cx
  02F8C3  2DC3: 7e02             jle 0x2dc7
  02F8C5  2DC5: 8bc1             mov ax, cx
  02F8C7  2DC7: 89469e           mov word ptr [bp - 0x62], ax
  02F8CA  2DCA: 8a0ea653         mov cl, byte ptr [0x53a6]
  02F8CE  2DCE: 2aed             sub ch, ch
  02F8D0  2DD0: 83e908           sub cx, 8
  02F8D3  2DD3: f7d9             neg cx
  02F8D5  2DD5: 8bd1             mov dx, cx
  02F8D7  2DD7: c1e102           shl cx, 2
  02F8DA  2DDA: 03ca             add cx, dx
  02F8DC  2DDC: d1e1             shl cx, 1
  02F8DE  2DDE: 894efc           mov word ptr [bp - 4], cx
  02F8E1  2DE1: 3bc1             cmp ax, cx
  02F8E3  2DE3: 7d03             jge 0x2de8
  02F8E5  2DE5: e98cfe           jmp 0x2c74
  02F8E8  2DE8: 53               push bx
  02F8E9  2DE9: 6a00             push 0
  02F8EB  2DEB: 6a00             push 0
  02F8ED  2DED: 9ac80a1f19       lcall 0x191f, 0xac8
  02F8F2  2DF2: 83c406           add sp, 6
  02F8F5  2DF5: 6b469234         imul ax, word ptr [bp - 0x6e], 0x34
  02F8F9  2DF9: 8bc8             mov cx, ax
  02F8FB  2DFB: 052654           add ax, 0x5426
  02F8FE  2DFE: 1e               push ds
  02F8FF  2DFF: 50               push ax
  02F900  2E00: 6a01             push 1
  02F902  2E02: 8bf0             mov si, ax
  02F904  2E04: 8bf9             mov di, cx
  02F906  2E06: 9a16041f18       lcall 0x181f, 0x416
  02F90B  2E0B: 83c406           add sp, 6
  02F90E  2E0E: 81c70e54         add di, 0x540e
  02F912  2E12: 1e               push ds
  02F913  2E13: 57               push di
  02F914  2E14: 6a02             push 2
  02F916  2E16: 9a16041f18       lcall 0x181f, 0x416
  02F91B  2E1B: 83c406           add sp, 6
  02F91E  2E1E: ff7692           push word ptr [bp - 0x6e]
  02F921  2E21: 683f0f           push 0xf3f
  02F924  2E24: 684b0f           push 0xf4b
  02F927  2E27: 9a22041f18       lcall 0x181f, 0x422
  02F92C  2E2C: 83c406           add sp, 6
  02F92F  2E2F: 683c83           push 0x833c
  02F932  2E32: 56               push si
  02F933  2E33: 9ae4071d0d       lcall 0xd1d, 0x7e4
  02F938  2E38: 83c404           add sp, 4
  02F93B  2E3B: 1e               push ds
  02F93C  2E3C: 683c83           push 0x833c
  02F93F  2E3F: 6a03             push 3
  02F941  2E41: 9a16041f18       lcall 0x181f, 0x416
  02F946  2E46: 83c406           add sp, 6
  02F949  2E49: 8d1e510f         lea bx, [0xf51]
  02F94D  2E4D: 9afe031f18       lcall 0x181f, 0x3fe
  02F952  2E52: 8b1efc84         mov bx, word ptr [0x84fc]
  02F956  2E56: 800f04           or byte ptr [bx], 4
  02F959  2E59: c746fe0000       mov word ptr [bp - 2], 0
  02F95E  2E5E: e9e0fd           jmp 0x2c41
  02F961  2E61: 90               nop 
  02F962  2E62: f606825310       test byte ptr [0x5382], 0x10
  02F967  2E67: 7403             je 0x2e6c
  02F969  2E69: e93e01           jmp 0x2faa
  02F96C  2E6C: 833e8c5300       cmp word ptr [0x538c], 0
  02F971  2E71: 757a             jne 0x2eed
  02F973  2E73: 813e8a53fe06     cmp word ptr [0x538a], 0x6fe
  02F979  2E79: 7507             jne 0x2e82
  02F97B  2E7B: f606825301       test byte ptr [0x5382], 1
  02F980  2E80: 7408             je 0x2e8a
  02F982  2E82: 813e8a533007     cmp word ptr [0x538a], 0x730
  02F988  2E88: 7563             jne 0x2eed
  02F98A  2E8A: 8a1ea653         mov bl, byte ptr [0x53a6]
  02F98E  2E8E: 2aff             sub bh, bh
  02F990  2E90: d1e3             shl bx, 1
  02F992  2E92: ffb79483         push word ptr [bx - 0x7c6c]
  02F996  2E96: 6a00             push 0
  02F998  2E98: 9a38041f18       lcall 0x181f, 0x438
  02F99D  2E9D: 83c404           add sp, 4
  02F9A0  2EA0: 6b06985334       imul ax, word ptr [0x5398], 0x34
  02F9A5  2EA5: 050e54           add ax, 0x540e
  02F9A8  2EA8: 1e               push ds
  02F9A9  2EA9: 50               push ax
  02F9AA  2EAA: 6a01             push 1
  02F9AC  2EAC: 9a16041f18       lcall 0x181f, 0x416
  02F9B1  2EB1: 83c406           add sp, 6
  02F9B4  2EB4: 68730f           push 0xf73
  02F9B7  2EB7: 8d46aa           lea ax, [bp - 0x56]
  02F9BA  2EBA: 50               push ax
  02F9BB  2EBB: 9ae4071d0d       lcall 0xd1d, 0x7e4
  02F9C0  2EC0: 83c404           add sp, 4
  02F9C3  2EC3: 813e8a53fe06     cmp word ptr [0x538a], 0x6fe
  02F9C9  2EC9: 7505             jne 0x2ed0
  02F9CB  2ECB: 6a00             push 0
  02F9CD  2ECD: eb03             jmp 0x2ed2
  02F9CF  2ECF: 90               nop 
  02F9D0  2ED0: 6a01             push 1
  02F9D2  2ED2: 8d46aa           lea ax, [bp - 0x56]
  02F9D5  2ED5: 16               push ss
  02F9D6  2ED6: 50               push ax
  02F9D7  2ED7: 9a82011f18       lcall 0x181f, 0x182
  02F9DC  2EDC: 83c406           add sp, 6
  02F9DF  2EDF: 6a01             push 1
  02F9E1  2EE1: 8d46aa           lea ax, [bp - 0x56]
  02F9E4  2EE4: 50               push ax
  02F9E5  2EE5: 9a52061f18       lcall 0x181f, 0x652
  02F9EA  2EEA: 83c404           add sp, 4
  02F9ED  2EED: 813e8a530807     cmp word ptr [0x538a], 0x708
  02F9F3  2EF3: 7507             jne 0x2efc
  02F9F5  2EF5: f606825301       test byte ptr [0x5382], 1
  02F9FA  2EFA: 740b             je 0x2f07
  02F9FC  2EFC: 813e8a533a07     cmp word ptr [0x538a], 0x73a
  02FA02  2F02: 7403             je 0x2f07
  02FA04  2F04: e9a300           jmp 0x2faa
  02FA07  2F07: 2bc0             sub ax, ax
  02FA09  2F09: 894690           mov word ptr [bp - 0x70], ax
  02FA0C  2F0C: 894696           mov word ptr [bp - 0x6a], ax
  02FA0F  2F0F: 89468c           mov word ptr [bp - 0x74], ax
  02FA12  2F12: eb2d             jmp 0x2f41
  02FA14  2F14: 50               push ax
  02FA15  2F15: 9ae6091f18       lcall 0x181f, 0x9e6
  02FA1A  2F1A: 83c402           add sp, 2
  02FA1D  2F1D: a09853           mov al, byte ptr [0x5398]
  02FA20  2F20: 8b1e4285         mov bx, word ptr [0x8542]
  02FA24  2F24: 38471a           cmp byte ptr [bx + 0x1a], al
  02FA27  2F27: 7515             jne 0x2f3e
  02FA29  2F29: 8a4690           mov al, byte ptr [bp - 0x70]
  02FA2C  2F2C: 38471f           cmp byte ptr [bx + 0x1f], al
  02FA2F  2F2F: 7c0d             jl 0x2f3e
  02FA31  2F31: 8a471f           mov al, byte ptr [bx + 0x1f]
  02FA34  2F34: 98               cwde 
  02FA35  2F35: 894690           mov word ptr [bp - 0x70], ax
  02FA38  2F38: 8b468c           mov ax, word ptr [bp - 0x74]
  02FA3B  2F3B: 894696           mov word ptr [bp - 0x6a], ax
  02FA3E  2F3E: ff468c           inc word ptr [bp - 0x74]
  02FA41  2F41: 8b468c           mov ax, word ptr [bp - 0x74]
  02FA44  2F44: 39069e53         cmp word ptr [0x539e], ax
  02FA48  2F48: 7fca             jg 0x2f14
  02FA4A  2F4A: 8a1ea653         mov bl, byte ptr [0x53a6]
  02FA4E  2F4E: 2aff             sub bh, bh
  02FA50  2F50: d1e3             shl bx, 1
  02FA52  2F52: ffb79483         push word ptr [bx - 0x7c6c]
  02FA56  2F56: 6a00             push 0
  02FA58  2F58: 9a38041f18       lcall 0x181f, 0x438
  02FA5D  2F5D: 83c404           add sp, 4
  02FA60  2F60: 6b06985334       imul ax, word ptr [0x5398], 0x34
  02FA65  2F65: 050e54           add ax, 0x540e
  02FA68  2F68: 1e               push ds
  02FA69  2F69: 50               push ax
  02FA6A  2F6A: 6a01             push 1
  02FA6C  2F6C: 9a16041f18       lcall 0x181f, 0x416
  02FA71  2F71: 83c406           add sp, 6
  02FA74  2F74: 694696ca00       imul ax, word ptr [bp - 0x6a], 0xca
  02FA79  2F79: 05485d           add ax, 0x5d48
  02FA7C  2F7C: 1e               push ds
  02FA7D  2F7D: 50               push ax
  02FA7E  2F7E: 6a02             push 2
  02FA80  2F80: 9a16041f18       lcall 0x181f, 0x416
  02FA85  2F85: 83c406           add sp, 6
  02FA88  2F88: f606825301       test byte ptr [0x5382], 1
  02FA8D  2F8D: 7507             jne 0x2f96
  02FA8F  2F8F: 8d1e800f         lea bx, [0xf80]
  02FA93  2F93: eb05             jmp 0x2f9a
  02FA95  2F95: 90               nop 
  02FA96  2F96: 8d1e890f         lea bx, [0xf89]
  02FA9A  2F9A: 9afe031f18       lcall 0x181f, 0x3fe
  02FA9F  2F9F: 9a74051f18       lcall 0x181f, 0x574
  02FAA4  2FA4: c706c2530000     mov word ptr [0x53c2], 0
  02FAAA  2FAA: 833ec25300       cmp word ptr [0x53c2], 0
  02FAAF  2FAF: 7534             jne 0x2fe5
  02FAB1  2FB1: 837ea200         cmp word ptr [bp - 0x5e], 0
  02FAB5  2FB5: 7429             je 0x2fe0
  02FAB7  2FB7: f606825308       test byte ptr [0x5382], 8
  02FABC  2FBC: 7406             je 0x2fc4
  02FABE  2FBE: c706a2530100     mov word ptr [0x53a2], 1
  02FAC4  2FC4: 9a6a051f18       lcall 0x181f, 0x56a
  02FAC9  2FC9: 8d1e930f         lea bx, [0xf93]
  02FACD  2FCD: 9afe031f18       lcall 0x181f, 0x3fe
  02FAD2  2FD2: 8946a6           mov word ptr [bp - 0x5a], ax
  02FAD5  2FD5: 3d0200           cmp ax, 2
  02FAD8  2FD8: 7506             jne 0x2fe0
  02FADA  2FDA: c706c2530100     mov word ptr [0x53c2], 1
  02FAE0  2FE0: 800e825310       or byte ptr [0x5382], 0x10
  02FAE5  2FE5: 5e               pop si
  02FAE6  2FE6: 5f               pop di
  02FAE7  2FE7: c9               leave 
  02FAE8  2FE8: cb               retf 
  02FAE9  2FE9: 90               nop 
  02FAEA  2FEA: ea580a1f19       ljmp 0x191f:0xa58
