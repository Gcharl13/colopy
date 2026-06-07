; ============================================================
; VICEROY.EXE overlay page 0x08 (record 7) -- RE-SEGMENTED
; file_offset (disk image) = 0x0400F0
; code_offset (first insn) = 0x0404B0
; code_end (next reloc hdr)= 0x0428D0  [resident size 578 para -> nominal_end 0x042510; on-disk code spills past it]
; reloc_count = 228  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x0400F0)
; functions in page = 24
; ============================================================

; ---- func_0404B0  size=201  insns=74  prologue=ENTER 0x0066,0  terminal=RETF ----
  0404B0  03C0: c8660000         enter 0x66, 0
  0404B4  03C4: 683414           push 0x1434
  0404B7  03C7: ff7608           push word ptr [bp + 8]
  0404BA  03CA: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0404BF  03CF: 83c404           add sp, 4
  0404C2  03D2: 8b4606           mov ax, word ptr [bp + 6]
  0404C5  03D5: 0bc0             or ax, ax
  0404C7  03D7: 740b             je 0x3e4
  0404C9  03D9: 48               dec ax
  0404CA  03DA: 742e             je 0x40a
  0404CC  03DC: 48               dec ax
  0404CD  03DD: 7431             je 0x410
  0404CF  03DF: 48               dec ax
  0404D0  03E0: 7434             je 0x416
  0404D2  03E2: eb0f             jmp 0x3f3
  0404D4  03E4: 683614           push 0x1436
  0404D7  03E7: 8d469c           lea ax, [bp - 0x64]
  0404DA  03EA: 50               push ax
  0404DB  03EB: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0404E0  03F0: 83c404           add sp, 4
  0404E3  03F3: 8d469c           lea ax, [bp - 0x64]
  0404E6  03F6: 50               push ax
  0404E7  03F7: 685314           push 0x1453
  0404EA  03FA: 9a28091f19       lcall 0x191f, 0x928
  0404EF  03FF: 83c404           add sp, 4
  0404F2  0402: 0bc0             or ax, ax
  0404F4  0404: 7416             je 0x41c
  0404F6  0406: eb7a             jmp 0x482
  0404F8  0408: 90               nop 
  0404F9  0409: 90               nop 
  0404FA  040A: 683e14           push 0x143e
  0404FD  040D: ebd8             jmp 0x3e7
  0404FF  040F: 90               nop 
  040500  0410: 684514           push 0x1445
  040503  0413: ebd2             jmp 0x3e7
  040505  0415: 90               nop 
  040506  0416: 684d14           push 0x144d
  040509  0419: ebcc             jmp 0x3e7
  04050B  041B: 90               nop 
  04050C  041C: c7469a0000       mov word ptr [bp - 0x66], 0
  040511  0421: eb43             jmp 0x466
  040513  0423: 90               nop 
  040514  0424: 9a1c091f19       lcall 0x191f, 0x91c
  040519  0429: 9ac40f1f19       lcall 0x191f, 0xfc4
  04051E  042E: 50               push ax
  04051F  042F: 8d46b0           lea ax, [bp - 0x50]
  040522  0432: 50               push ax
  040523  0433: 9ae4071d0d       lcall 0xd1d, 0x7e4
  040528  0438: 83c404           add sp, 4
  04052B  043B: 807eb040         cmp byte ptr [bp - 0x50], 0x40
  04052F  043F: 7441             je 0x482
  040531  0441: 837e9a00         cmp word ptr [bp - 0x66], 0
  040535  0445: 740d             je 0x454
  040537  0447: 8b469a           mov ax, word ptr [bp - 0x66]
  04053A  044A: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  04053E  044E: 39874054         cmp word ptr [bx + 0x5440], ax
  040542  0452: 750f             jne 0x463
  040544  0454: 8d46b0           lea ax, [bp - 0x50]
  040547  0457: 50               push ax
  040548  0458: ff7608           push word ptr [bp + 8]
  04054B  045B: 9ae4071d0d       lcall 0xd1d, 0x7e4
  040550  0460: 83c404           add sp, 4
  040553  0463: ff469a           inc word ptr [bp - 0x66]
  040556  0466: 8b469a           mov ax, word ptr [bp - 0x66]
  040559  0469: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  04055D  046D: 39874054         cmp word ptr [bx + 0x5440], ax
  040561  0471: 7db1             jge 0x424
  040563  0473: 8b5e08           mov bx, word ptr [bp + 8]
  040566  0476: c6471700         mov byte ptr [bx + 0x17], 0
  04056A  047A: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  04056E  047E: ff874054         inc word ptr [bx + 0x5440]
  040572  0482: 9ab80f1f19       lcall 0x191f, 0xfb8
  040577  0487: c9               leave 
  040578  0488: cb               retf 

; ---- func_04057A  size=141  insns=53  prologue=ENTER 0x0004,0  terminal=RETF ----
  04057A  048A: c8040000         enter 4, 0
  04057E  048E: 57               push di
  04057F  048F: 56               push si
  040580  0490: c746fe0000       mov word ptr [bp - 2], 0
  040585  0495: 837e0804         cmp word ptr [bp + 8], 4
  040589  0499: 7d0b             jge 0x4a6
  04058B  049B: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04058F  049F: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  040594  04A4: 746a             je 0x510
  040596  04A6: ff760c           push word ptr [bp + 0xc]
  040599  04A9: ff760a           push word ptr [bp + 0xa]
  04059C  04AC: ff7608           push word ptr [bp + 8]
  04059F  04AF: ff7606           push word ptr [bp + 6]
  0405A2  04B2: 9a780d1f18       lcall 0x181f, 0xd78
  0405A7  04B7: 83c408           add sp, 8
  0405AA  04BA: 8946fc           mov word ptr [bp - 4], ax
  0405AD  04BD: ff7608           push word ptr [bp + 8]
  0405B0  04C0: 9a920a1f18       lcall 0x181f, 0xa92
  0405B5  04C5: 83c402           add sp, 2
  0405B8  04C8: 8bc8             mov cx, ax
  0405BA  04CA: 8b46fc           mov ax, word ptr [bp - 4]
  0405BD  04CD: 8bda             mov bx, dx
  0405BF  04CF: 99               cdq 
  0405C0  04D0: 2bc8             sub cx, ax
  0405C2  04D2: 1bda             sbb bx, dx
  0405C4  04D4: 8bf0             mov si, ax
  0405C6  04D6: d1f8             sar ax, 1
  0405C8  04D8: 8bfa             mov di, dx
  0405CA  04DA: 99               cdq 
  0405CB  04DB: 3bda             cmp bx, dx
  0405CD  04DD: 7c31             jl 0x510
  0405CF  04DF: 7f04             jg 0x4e5
  0405D1  04E1: 3bc8             cmp cx, ax
  0405D3  04E3: 722b             jb 0x510
  0405D5  04E5: 57               push di
  0405D6  04E6: 56               push si
  0405D7  04E7: ff7608           push word ptr [bp + 8]
  0405DA  04EA: 9af60a1f18       lcall 0x181f, 0xaf6
  0405DF  04EF: 83c406           add sp, 6
  0405E2  04F2: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0405E6  04F6: fe4705           inc byte ptr [bx + 5]
  0405E9  04F9: 6a01             push 1
  0405EB  04FB: 6a10             push 0x10
  0405ED  04FD: ff760c           push word ptr [bp + 0xc]
  0405F0  0500: ff760a           push word ptr [bp + 0xa]
  0405F3  0503: 9a8c061f18       lcall 0x181f, 0x68c
  0405F8  0508: 83c408           add sp, 8
  0405FB  050B: c746fe0100       mov word ptr [bp - 2], 1
  040600  0510: 8b46fe           mov ax, word ptr [bp - 2]
  040603  0513: 5e               pop si
  040604  0514: 5f               pop di
  040605  0515: c9               leave 
  040606  0516: cb               retf 

; ---- func_040608  size=78  insns=26  prologue=push bp;mov bp,sp  terminal=RETF ----
  040608  0518: 55               push bp
  040609  0519: 8bec             mov bp, sp
  04060B  051B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04060F  051F: 80af593114       sub byte ptr [bx + 0x3159], 0x14
  040614  0524: 80bf593114       cmp byte ptr [bx + 0x3159], 0x14
  040619  0529: 7339             jae 0x564
  04061B  052B: 2ac0             sub al, al
  04061D  052D: 88875931         mov byte ptr [bx + 0x3159], al
  040621  0531: 88874631         mov byte ptr [bx + 0x3146], al
  040625  0535: 80bf5b3118       cmp byte ptr [bx + 0x315b], 0x18
  04062A  053A: 7505             jne 0x541
  04062C  053C: c687463103       mov byte ptr [bx + 0x3146], 3
  040631  0541: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040635  0545: 8a874731         mov al, byte ptr [bx + 0x3147]
  040639  0549: 240f             and al, 0xf
  04063B  054B: 3c04             cmp al, 4
  04063D  054D: 7315             jae 0x564
  04063F  054F: 2ae4             sub ah, ah
  040641  0551: 6bd834           imul bx, ax, 0x34
  040644  0554: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  040648  0558: 750a             jne 0x564
  04064A  055A: 6a03             push 3
  04064C  055C: 685a14           push 0x145a
  04064F  055F: 9a52061f18       lcall 0x181f, 0x652
  040654  0564: c9               leave 
  040655  0565: cb               retf 

; ---- func_040656  size=896  insns=308  prologue=ENTER 0x002A,0  terminal=RETF ----
  040656  0566: c82a0000         enter 0x2a, 0
  04065A  056A: 56               push si
  04065B  056B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04065F  056F: 8a874431         mov al, byte ptr [bx + 0x3144]
  040663  0573: 2ae4             sub ah, ah
  040665  0575: 8946e8           mov word ptr [bp - 0x18], ax
  040668  0578: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  04066C  057C: 2aed             sub ch, ch
  04066E  057E: 894ee6           mov word ptr [bp - 0x1a], cx
  040671  0581: 51               push cx
  040672  0582: 50               push ax
  040673  0583: 8bf3             mov si, bx
  040675  0585: 9a22071f18       lcall 0x181f, 0x722
  04067A  058A: 83c404           add sp, 4
  04067D  058D: 8946f6           mov word ptr [bp - 0xa], ax
  040680  0590: ff76e6           push word ptr [bp - 0x1a]
  040683  0593: ff76e8           push word ptr [bp - 0x18]
  040686  0596: 9a0e071f18       lcall 0x181f, 0x70e
  04068B  059B: 83c404           add sp, 4
  04068E  059E: 8946dc           mov word ptr [bp - 0x24], ax
  040691  05A1: 8956de           mov word ptr [bp - 0x22], dx
  040694  05A4: ff76e6           push word ptr [bp - 0x1a]
  040697  05A7: ff76e8           push word ptr [bp - 0x18]
  04069A  05AA: 9a40071f18       lcall 0x181f, 0x740
  04069F  05AF: 83c404           add sp, 4
  0406A2  05B2: 8946fa           mov word ptr [bp - 6], ax
  0406A5  05B5: 8956fc           mov word ptr [bp - 4], dx
  0406A8  05B8: ff76e6           push word ptr [bp - 0x1a]
  0406AB  05BB: ff76e8           push word ptr [bp - 0x18]
  0406AE  05BE: 9a8c071f18       lcall 0x181f, 0x78c
  0406B3  05C3: 83c404           add sp, 4
  0406B6  05C6: 8946f2           mov word ptr [bp - 0xe], ax
  0406B9  05C9: 8a844731         mov al, byte ptr [si + 0x3147]
  0406BD  05CD: 250f00           and ax, 0xf
  0406C0  05D0: 8946e0           mov word ptr [bp - 0x20], ax
  0406C3  05D3: 837ef208         cmp word ptr [bp - 0xe], 8
  0406C7  05D7: 7c06             jl 0x5df
  0406C9  05D9: 837ef210         cmp word ptr [bp - 0xe], 0x10
  0406CD  05DD: 7c0c             jl 0x5eb
  0406CF  05DF: 837ef210         cmp word ptr [bp - 0xe], 0x10
  0406D3  05E3: 7c0d             jl 0x5f2
  0406D5  05E5: 837ef218         cmp word ptr [bp - 0xe], 0x18
  0406D9  05E9: 7d07             jge 0x5f2
  0406DB  05EB: c746f40000       mov word ptr [bp - 0xc], 0
  0406E0  05F0: eb2c             jmp 0x61e
  0406E2  05F2: ff76e6           push word ptr [bp - 0x1a]
  0406E5  05F5: ff76e8           push word ptr [bp - 0x18]
  0406E8  05F8: 9a54071f18       lcall 0x181f, 0x754
  0406ED  05FD: 83c404           add sp, 4
  0406F0  0600: a840             test al, 0x40
  0406F2  0602: 7403             je 0x607
  0406F4  0604: e9d302           jmp 0x8da
  0406F7  0607: 837ef219         cmp word ptr [bp - 0xe], 0x19
  0406FB  060B: 7503             jne 0x610
  0406FD  060D: e9ca02           jmp 0x8da
  040700  0610: 837ef21a         cmp word ptr [bp - 0xe], 0x1a
  040704  0614: 7503             jne 0x619
  040706  0616: e9c102           jmp 0x8da
  040709  0619: c746f40100       mov word ptr [bp - 0xc], 1
  04070E  061E: ff7606           push word ptr [bp + 6]
  040711  0621: 9a34091f18       lcall 0x181f, 0x934
  040716  0626: 83c402           add sp, 2
  040719  0629: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04071D  062D: fe875a31         inc byte ptr [bx + 0x315a]
  040721  0631: 8b76f2           mov si, word ptr [bp - 0xe]
  040724  0634: c1e604           shl si, 4
  040727  0637: 8a84782f         mov al, byte ptr [si + 0x2f78]
  04072B  063B: 2ae4             sub ah, ah
  04072D  063D: 40               inc ax
  04072E  063E: 40               inc ax
  04072F  063F: 8946d8           mov word ptr [bp - 0x28], ax
  040732  0642: 80bf5b3114       cmp byte ptr [bx + 0x315b], 0x14
  040737  0647: 7505             jne 0x64e
  040739  0649: b80100           mov ax, 1
  04073C  064C: eb02             jmp 0x650
  04073E  064E: 2bc0             sub ax, ax
  040740  0650: 8946ec           mov word ptr [bp - 0x14], ax
  040743  0653: 0bc0             or ax, ax
  040745  0655: 7408             je 0x65f
  040747  0657: 8b46d8           mov ax, word ptr [bp - 0x28]
  04074A  065A: d1f8             sar ax, 1
  04074C  065C: 8946d8           mov word ptr [bp - 0x28], ax
  04074F  065F: 8a46d8           mov al, byte ptr [bp - 0x28]
  040752  0662: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040756  0666: 38875a31         cmp byte ptr [bx + 0x315a], al
  04075A  066A: 7303             jae 0x66f
  04075C  066C: e97402           jmp 0x8e3
  04075F  066F: 2ac0             sub al, al
  040761  0671: 88875a31         mov byte ptr [bx + 0x315a], al
  040765  0675: 88874c31         mov byte ptr [bx + 0x314c], al
  040769  0679: 833e9e5300       cmp word ptr [0x539e], 0
  04076E  067E: 7503             jne 0x683
  040770  0680: e9de00           jmp 0x761
  040773  0683: 837ef400         cmp word ptr [bp - 0xc], 0
  040777  0687: 7403             je 0x68c
  040779  0689: e9d500           jmp 0x761
  04077C  068C: 6aff             push -1
  04077E  068E: 8a874731         mov al, byte ptr [bx + 0x3147]
  040782  0692: 250f00           and ax, 0xf
  040785  0695: 50               push ax
  040786  0696: ff76e6           push word ptr [bp - 0x1a]
  040789  0699: ff76e8           push word ptr [bp - 0x18]
  04078C  069C: 9a14061f18       lcall 0x181f, 0x614
  040791  06A1: 83c408           add sp, 8
  040794  06A4: 0bc0             or ax, ax
  040796  06A6: 7d03             jge 0x6ab
  040798  06A8: e9b600           jmp 0x761
  04079B  06AB: 833eb88d03       cmp word ptr [0x8db8], 3
  0407A0  06B0: 7e03             jle 0x6b5
  0407A2  06B2: e9ac00           jmp 0x761
  0407A5  06B5: 8b5ef2           mov bx, word ptr [bp - 0xe]
  0407A8  06B8: c1e304           shl bx, 4
  0407AB  06BB: 8a87802f         mov al, byte ptr [bx + 0x2f80]
  0407AF  06BF: 2ae4             sub ah, ah
  0407B1  06C1: 8946ee           mov word ptr [bp - 0x12], ax
  0407B4  06C4: 8b1e4285         mov bx, word ptr [0x8542]
  0407B8  06C8: 8a4701           mov al, byte ptr [bx + 1]
  0407BB  06CB: 50               push ax
  0407BC  06CC: 8a07             mov al, byte ptr [bx]
  0407BE  06CE: 50               push ax
  0407BF  06CF: 9a54071f18       lcall 0x181f, 0x754
  0407C4  06D4: 83c404           add sp, 4
  0407C7  06D7: a80a             test al, 0xa
  0407C9  06D9: 7403             je 0x6de
  0407CB  06DB: ff46ee           inc word ptr [bp - 0x12]
  0407CE  06DE: 6a24             push 0x24
  0407D0  06E0: 9afc091f18       lcall 0x181f, 0x9fc
  0407D5  06E5: 83c402           add sp, 2
  0407D8  06E8: 0bc0             or ax, ax
  0407DA  06EA: 7505             jne 0x6f1
  0407DC  06EC: c746ee0100       mov word ptr [bp - 0x12], 1
  0407E1  06F1: 9a3a0d1f18       lcall 0x181f, 0xd3a
  0407E6  06F6: 8b1e4285         mov bx, word ptr [0x8542]
  0407EA  06FA: 2b87a400         sub ax, word ptr [bx + 0xa4]
  0407EE  06FE: 8a4eec           mov cl, byte ptr [bp - 0x14]
  0407F1  0701: 6b56ee14         imul dx, word ptr [bp - 0x12], 0x14
  0407F5  0705: d3e2             shl dx, cl
  0407F7  0707: 3bc2             cmp ax, dx
  0407F9  0709: 7e02             jle 0x70d
  0407FB  070B: 8bc2             mov ax, dx
  0407FD  070D: 0bc0             or ax, ax
  0407FF  070F: 7d02             jge 0x713
  040801  0711: 2bc0             sub ax, ax
  040803  0713: 8946f0           mov word ptr [bp - 0x10], ax
  040806  0716: 0bc0             or ax, ax
  040808  0718: 743c             je 0x756
  04080A  071A: 837ee004         cmp word ptr [bp - 0x20], 4
  04080E  071E: 7d36             jge 0x756
  040810  0720: 6b5ee034         imul bx, word ptr [bp - 0x20], 0x34
  040814  0724: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  040819  0729: 752b             jne 0x756
  04081B  072B: 99               cdq 
  04081C  072C: 52               push dx
  04081D  072D: 50               push ax
  04081E  072E: 6a00             push 0
  040820  0730: 9aae091f18       lcall 0x181f, 0x9ae
  040825  0735: 83c406           add sp, 6
  040828  0738: a14285           mov ax, word ptr [0x8542]
  04082B  073B: 40               inc ax
  04082C  073C: 40               inc ax
  04082D  073D: 1e               push ds
  04082E  073E: 50               push ax
  04082F  073F: 6a00             push 0
  040831  0741: 9a16041f18       lcall 0x181f, 0x416
  040836  0746: 83c406           add sp, 6
  040839  0749: 6a05             push 5
  04083B  074B: 686614           push 0x1466
  04083E  074E: 9a52061f18       lcall 0x181f, 0x652
  040843  0753: 83c404           add sp, 4
  040846  0756: 8b46f0           mov ax, word ptr [bp - 0x10]
  040849  0759: 8b1e4285         mov bx, word ptr [0x8542]
  04084D  075D: 0187a400         add word ptr [bx + 0xa4], ax
  040851  0761: a19653           mov ax, word ptr [0x5396]
  040854  0764: 39069453         cmp word ptr [0x5394], ax
  040858  0768: 741d             je 0x787
  04085A  076A: 833ea25300       cmp word ptr [0x53a2], 0
  04085F  076F: 742c             je 0x79d
  040861  0771: 833e945304       cmp word ptr [0x5394], 4
  040866  0776: 7c06             jl 0x77e
  040868  0778: b80080           mov ax, 0x8000
  04086B  077B: eb04             jmp 0x781
  04086D  077D: 90               nop 
  04086E  077E: b80040           mov ax, 0x4000
  040871  0781: 85068253         test word ptr [0x5382], ax
  040875  0785: 7416             je 0x79d
  040877  0787: 6a01             push 1
  040879  0789: ff76e6           push word ptr [bp - 0x1a]
  04087C  078C: ff76e8           push word ptr [bp - 0x18]
  04087F  078F: ff76e6           push word ptr [bp - 0x1a]
  040882  0792: ff76e8           push word ptr [bp - 0x18]
  040885  0795: 9a52031f18       lcall 0x181f, 0x352
  04088A  079A: 83c40a           add sp, 0xa
  04088D  079D: 837ef400         cmp word ptr [bp - 0xc], 0
  040891  07A1: 7509             jne 0x7ac
  040893  07A3: c45edc           les bx, ptr [bp - 0x24]
  040896  07A6: 26802f08         sub byte ptr es:[bx], 8
  04089A  07AA: eb07             jmp 0x7b3
  04089C  07AC: c45efa           les bx, ptr [bp - 6]
  04089F  07AF: 26800f40         or byte ptr es:[bx], 0x40
  0408A3  07B3: ff7606           push word ptr [bp + 6]
  0408A6  07B6: 0e               push cs
  0408A7  07B7: e8780f           call 0x1732
  0408AA  07BA: 83c402           add sp, 2
  0408AD  07BD: a19653           mov ax, word ptr [0x5396]
  0408B0  07C0: 39069453         cmp word ptr [0x5394], ax
  0408B4  07C4: 741d             je 0x7e3
  0408B6  07C6: 833ea25300       cmp word ptr [0x53a2], 0
  0408BB  07CB: 742e             je 0x7fb
  0408BD  07CD: 833e945304       cmp word ptr [0x5394], 4
  0408C2  07D2: 7c06             jl 0x7da
  0408C4  07D4: b80080           mov ax, 0x8000
  0408C7  07D7: eb04             jmp 0x7dd
  0408C9  07D9: 90               nop 
  0408CA  07DA: b80040           mov ax, 0x4000
  0408CD  07DD: 85068253         test word ptr [0x5382], ax
  0408D1  07E1: 7418             je 0x7fb
  0408D3  07E3: 6a01             push 1
  0408D5  07E5: 6a03             push 3
  0408D7  07E7: 6a03             push 3
  0408D9  07E9: 8b46e6           mov ax, word ptr [bp - 0x1a]
  0408DC  07EC: 48               dec ax
  0408DD  07ED: 50               push ax
  0408DE  07EE: 8b46e8           mov ax, word ptr [bp - 0x18]
  0408E1  07F1: 48               dec ax
  0408E2  07F2: 50               push ax
  0408E3  07F3: 9aba091f18       lcall 0x181f, 0x9ba
  0408E8  07F8: 83c40a           add sp, 0xa
  0408EB  07FB: 837ef400         cmp word ptr [bp - 0xc], 0
  0408EF  07FF: 7403             je 0x804
  0408F1  0801: e9df00           jmp 0x8e3
  0408F4  0804: ff76f6           push word ptr [bp - 0xa]
  0408F7  0807: 6aff             push -1
  0408F9  0809: ff76e6           push word ptr [bp - 0x1a]
  0408FC  080C: ff76e8           push word ptr [bp - 0x18]
  0408FF  080F: 9a840d1f18       lcall 0x181f, 0xd84
  040904  0814: 83c408           add sp, 8
  040907  0817: 8946fe           mov word ptr [bp - 2], ax
  04090A  081A: 0bc0             or ax, ax
  04090C  081C: 7d03             jge 0x821
  04090E  081E: e9c200           jmp 0x8e3
  040911  0821: ff76e6           push word ptr [bp - 0x1a]
  040914  0824: ff76e8           push word ptr [bp - 0x18]
  040917  0827: 9a54071f18       lcall 0x181f, 0x754
  04091C  082C: 83c404           add sp, 4
  04091F  082F: a810             test al, 0x10
  040921  0831: 7403             je 0x836
  040923  0833: e9ad00           jmp 0x8e3
  040926  0836: ff76e6           push word ptr [bp - 0x1a]
  040929  0839: ff76e8           push word ptr [bp - 0x18]
  04092C  083C: 9a96061f18       lcall 0x181f, 0x696
  040931  0841: 83c404           add sp, 4
  040934  0844: 0bc0             or ax, ax
  040936  0846: 7c03             jl 0x84b
  040938  0848: e99800           jmp 0x8e3
  04093B  084B: ff36528d         push word ptr [0x8d52]
  04093F  084F: 9a560a1f18       lcall 0x181f, 0xa56
  040944  0854: 83c402           add sp, 2
  040947  0857: 3906b88d         cmp word ptr [0x8db8], ax
  04094B  085B: 7e03             jle 0x860
  04094D  085D: e98300           jmp 0x8e3
  040950  0860: 6a02             push 2
  040952  0862: ff76e0           push word ptr [bp - 0x20]
  040955  0865: 9ab4071f18       lcall 0x181f, 0x7b4
  04095A  086A: 83c404           add sp, 4
  04095D  086D: 0bc0             or ax, ax
  04095F  086F: 7572             jne 0x8e3
  040961  0871: ff76e6           push word ptr [bp - 0x1a]
  040964  0874: ff76e8           push word ptr [bp - 0x18]
  040967  0877: ff76e0           push word ptr [bp - 0x20]
  04096A  087A: ff76fe           push word ptr [bp - 2]
  04096D  087D: 0e               push cs
  04096E  087E: e8ac0e           call 0x172d
  040971  0881: 83c408           add sp, 8
  040974  0884: 0bc0             or ax, ax
  040976  0886: 755b             jne 0x8e3
  040978  0888: 833e945304       cmp word ptr [0x5394], 4
  04097D  088D: 7d11             jge 0x8a0
  04097F  088F: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  040984  0894: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  040989  0899: 7505             jne 0x8a0
  04098B  089B: a0a653           mov al, byte ptr [0x53a6]
  04098E  089E: 2ae4             sub ah, ah
  040990  08A0: 050500           add ax, 5
  040993  08A3: 8946e2           mov word ptr [bp - 0x1e], ax
  040996  08A6: 8946e4           mov word ptr [bp - 0x1c], ax
  040999  08A9: 833eb88d02       cmp word ptr [0x8db8], 2
  04099E  08AE: 7f05             jg 0x8b5
  0409A0  08B0: d1e0             shl ax, 1
  0409A2  08B2: 8946e4           mov word ptr [bp - 0x1c], ax
  0409A5  08B5: 833eb88d01       cmp word ptr [0x8db8], 1
  0409AA  08BA: 7f06             jg 0x8c2
  0409AC  08BC: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0409AF  08BF: 0146e4           add word ptr [bp - 0x1c], ax
  0409B2  08C2: 6a02             push 2
  0409B4  08C4: ff76e4           push word ptr [bp - 0x1c]
  0409B7  08C7: ff76e0           push word ptr [bp - 0x20]
  0409BA  08CA: ff36528d         push word ptr [0x8d52]
  0409BE  08CE: 9a6c0d1f18       lcall 0x181f, 0xd6c
  0409C3  08D3: 83c408           add sp, 8
  0409C6  08D6: 5e               pop si
  0409C7  08D7: c9               leave 
  0409C8  08D8: cb               retf 
  0409C9  08D9: 90               nop 
  0409CA  08DA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0409CE  08DE: c6874c3100       mov byte ptr [bx + 0x314c], 0
  0409D3  08E3: 5e               pop si
  0409D4  08E4: c9               leave 
  0409D5  08E5: cb               retf 

; ---- func_0409D6  size=584  insns=197  prologue=ENTER 0x001C,0  terminal=RETF ----
  0409D6  08E6: c81c0000         enter 0x1c, 0
  0409DA  08EA: 56               push si
  0409DB  08EB: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0409DF  08EF: 8a874431         mov al, byte ptr [bx + 0x3144]
  0409E3  08F3: 2ae4             sub ah, ah
  0409E5  08F5: 8946f4           mov word ptr [bp - 0xc], ax
  0409E8  08F8: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  0409EC  08FC: 2aed             sub ch, ch
  0409EE  08FE: 894ef2           mov word ptr [bp - 0xe], cx
  0409F1  0901: 51               push cx
  0409F2  0902: 50               push ax
  0409F3  0903: 8bf3             mov si, bx
  0409F5  0905: 9a22071f18       lcall 0x181f, 0x722
  0409FA  090A: 83c404           add sp, 4
  0409FD  090D: 8946fa           mov word ptr [bp - 6], ax
  040A00  0910: ff76f2           push word ptr [bp - 0xe]
  040A03  0913: ff76f4           push word ptr [bp - 0xc]
  040A06  0916: 9a40071f18       lcall 0x181f, 0x740
  040A0B  091B: 83c404           add sp, 4
  040A0E  091E: 8946ee           mov word ptr [bp - 0x12], ax
  040A11  0921: 8956f0           mov word ptr [bp - 0x10], dx
  040A14  0924: ff76f2           push word ptr [bp - 0xe]
  040A17  0927: ff76f4           push word ptr [bp - 0xc]
  040A1A  092A: 9a8c071f18       lcall 0x181f, 0x78c
  040A1F  092F: 83c404           add sp, 4
  040A22  0932: 8946f8           mov word ptr [bp - 8], ax
  040A25  0935: 8a844731         mov al, byte ptr [si + 0x3147]
  040A29  0939: 250f00           and ax, 0xf
  040A2C  093C: 8946e8           mov word ptr [bp - 0x18], ax
  040A2F  093F: c45eee           les bx, ptr [bp - 0x12]
  040A32  0942: 26f6070a         test byte ptr es:[bx], 0xa
  040A36  0946: 7403             je 0x94b
  040A38  0948: e9d701           jmp 0xb22
  040A3B  094B: ff7606           push word ptr [bp + 6]
  040A3E  094E: 9a34091f18       lcall 0x181f, 0x934
  040A43  0953: 83c402           add sp, 2
  040A46  0956: fe845a31         inc byte ptr [si + 0x315a]
  040A4A  095A: 8b5ef8           mov bx, word ptr [bp - 8]
  040A4D  095D: c1e304           shl bx, 4
  040A50  0960: 8a87782f         mov al, byte ptr [bx + 0x2f78]
  040A54  0964: 2ae4             sub ah, ah
  040A56  0966: 8946e6           mov word ptr [bp - 0x1a], ax
  040A59  0969: 80bc5b3114       cmp byte ptr [si + 0x315b], 0x14
  040A5E  096E: 7505             jne 0x975
  040A60  0970: d1f8             sar ax, 1
  040A62  0972: 8946e6           mov word ptr [bp - 0x1a], ax
  040A65  0975: 8a46e6           mov al, byte ptr [bp - 0x1a]
  040A68  0978: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040A6C  097C: 38875a31         cmp byte ptr [bx + 0x315a], al
  040A70  0980: 7303             jae 0x985
  040A72  0982: e9a601           jmp 0xb2b
  040A75  0985: 2ac0             sub al, al
  040A77  0987: 88875a31         mov byte ptr [bx + 0x315a], al
  040A7B  098B: 88874c31         mov byte ptr [bx + 0x314c], al
  040A7F  098F: 833e9e5300       cmp word ptr [0x539e], 0
  040A84  0994: 7428             je 0x9be
  040A86  0996: 6aff             push -1
  040A88  0998: 6aff             push -1
  040A8A  099A: ff76f2           push word ptr [bp - 0xe]
  040A8D  099D: ff76f4           push word ptr [bp - 0xc]
  040A90  09A0: 8bf3             mov si, bx
  040A92  09A2: 9a14061f18       lcall 0x181f, 0x614
  040A97  09A7: 83c408           add sp, 8
  040A9A  09AA: 8a844731         mov al, byte ptr [si + 0x3147]
  040A9E  09AE: 240f             and al, 0xf
  040AA0  09B0: 8b1e4285         mov bx, word ptr [0x8542]
  040AA4  09B4: 3a471a           cmp al, byte ptr [bx + 0x1a]
  040AA7  09B7: 7505             jne 0x9be
  040AA9  09B9: 838798000a       add word ptr [bx + 0x98], 0xa
  040AAE  09BE: a19653           mov ax, word ptr [0x5396]
  040AB1  09C1: 39069453         cmp word ptr [0x5394], ax
  040AB5  09C5: 741c             je 0x9e3
  040AB7  09C7: 833ea25300       cmp word ptr [0x53a2], 0
  040ABC  09CC: 742b             je 0x9f9
  040ABE  09CE: 833e945304       cmp word ptr [0x5394], 4
  040AC3  09D3: 7c05             jl 0x9da
  040AC5  09D5: b80080           mov ax, 0x8000
  040AC8  09D8: eb03             jmp 0x9dd
  040ACA  09DA: b80040           mov ax, 0x4000
  040ACD  09DD: 85068253         test word ptr [0x5382], ax
  040AD1  09E1: 7416             je 0x9f9
  040AD3  09E3: 6a01             push 1
  040AD5  09E5: ff76f2           push word ptr [bp - 0xe]
  040AD8  09E8: ff76f4           push word ptr [bp - 0xc]
  040ADB  09EB: ff76f2           push word ptr [bp - 0xe]
  040ADE  09EE: ff76f4           push word ptr [bp - 0xc]
  040AE1  09F1: 9a52031f18       lcall 0x181f, 0x352
  040AE6  09F6: 83c40a           add sp, 0xa
  040AE9  09F9: c45eee           les bx, ptr [bp - 0x12]
  040AEC  09FC: 26800f08         or byte ptr es:[bx], 8
  040AF0  0A00: ff7606           push word ptr [bp + 6]
  040AF3  0A03: 0e               push cs
  040AF4  0A04: e82b0d           call 0x1732
  040AF7  0A07: 83c402           add sp, 2
  040AFA  0A0A: a19653           mov ax, word ptr [0x5396]
  040AFD  0A0D: 39069453         cmp word ptr [0x5394], ax
  040B01  0A11: 741c             je 0xa2f
  040B03  0A13: 833ea25300       cmp word ptr [0x53a2], 0
  040B08  0A18: 742d             je 0xa47
  040B0A  0A1A: 833e945304       cmp word ptr [0x5394], 4
  040B0F  0A1F: 7c05             jl 0xa26
  040B11  0A21: b80080           mov ax, 0x8000
  040B14  0A24: eb03             jmp 0xa29
  040B16  0A26: b80040           mov ax, 0x4000
  040B19  0A29: 85068253         test word ptr [0x5382], ax
  040B1D  0A2D: 7418             je 0xa47
  040B1F  0A2F: 6a01             push 1
  040B21  0A31: 6a03             push 3
  040B23  0A33: 6a03             push 3
  040B25  0A35: 8b46f2           mov ax, word ptr [bp - 0xe]
  040B28  0A38: 48               dec ax
  040B29  0A39: 50               push ax
  040B2A  0A3A: 8b46f4           mov ax, word ptr [bp - 0xc]
  040B2D  0A3D: 48               dec ax
  040B2E  0A3E: 50               push ax
  040B2F  0A3F: 9aba091f18       lcall 0x181f, 0x9ba
  040B34  0A44: 83c40a           add sp, 0xa
  040B37  0A47: ff76fa           push word ptr [bp - 6]
  040B3A  0A4A: 6aff             push -1
  040B3C  0A4C: ff76f2           push word ptr [bp - 0xe]
  040B3F  0A4F: ff76f4           push word ptr [bp - 0xc]
  040B42  0A52: 9a840d1f18       lcall 0x181f, 0xd84
  040B47  0A57: 83c408           add sp, 8
  040B4A  0A5A: 8946fe           mov word ptr [bp - 2], ax
  040B4D  0A5D: 0bc0             or ax, ax
  040B4F  0A5F: 7d03             jge 0xa64
  040B51  0A61: e9c700           jmp 0xb2b
  040B54  0A64: ff76f2           push word ptr [bp - 0xe]
  040B57  0A67: ff76f4           push word ptr [bp - 0xc]
  040B5A  0A6A: 9a54071f18       lcall 0x181f, 0x754
  040B5F  0A6F: 83c404           add sp, 4
  040B62  0A72: a810             test al, 0x10
  040B64  0A74: 7403             je 0xa79
  040B66  0A76: e9b200           jmp 0xb2b
  040B69  0A79: ff76f2           push word ptr [bp - 0xe]
  040B6C  0A7C: ff76f4           push word ptr [bp - 0xc]
  040B6F  0A7F: 9a96061f18       lcall 0x181f, 0x696
  040B74  0A84: 83c404           add sp, 4
  040B77  0A87: 0bc0             or ax, ax
  040B79  0A89: 7c03             jl 0xa8e
  040B7B  0A8B: e99d00           jmp 0xb2b
  040B7E  0A8E: ff36528d         push word ptr [0x8d52]
  040B82  0A92: 9a560a1f18       lcall 0x181f, 0xa56
  040B87  0A97: 83c402           add sp, 2
  040B8A  0A9A: 8946f6           mov word ptr [bp - 0xa], ax
  040B8D  0A9D: a1b88d           mov ax, word ptr [0x8db8]
  040B90  0AA0: 3946f6           cmp word ptr [bp - 0xa], ax
  040B93  0AA3: 7d03             jge 0xaa8
  040B95  0AA5: e98300           jmp 0xb2b
  040B98  0AA8: ff76f2           push word ptr [bp - 0xe]
  040B9B  0AAB: ff76f4           push word ptr [bp - 0xc]
  040B9E  0AAE: ff76e8           push word ptr [bp - 0x18]
  040BA1  0AB1: ff76fe           push word ptr [bp - 2]
  040BA4  0AB4: 0e               push cs
  040BA5  0AB5: e8750c           call 0x172d
  040BA8  0AB8: 83c408           add sp, 8
  040BAB  0ABB: 0bc0             or ax, ax
  040BAD  0ABD: 756c             jne 0xb2b
  040BAF  0ABF: 6a02             push 2
  040BB1  0AC1: ff76e8           push word ptr [bp - 0x18]
  040BB4  0AC4: 9ab4071f18       lcall 0x181f, 0x7b4
  040BB9  0AC9: 83c404           add sp, 4
  040BBC  0ACC: 0bc0             or ax, ax
  040BBE  0ACE: 755b             jne 0xb2b
  040BC0  0AD0: 833e945304       cmp word ptr [0x5394], 4
  040BC5  0AD5: 7d11             jge 0xae8
  040BC7  0AD7: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  040BCC  0ADC: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  040BD1  0AE1: 7505             jne 0xae8
  040BD3  0AE3: a0a653           mov al, byte ptr [0x53a6]
  040BD6  0AE6: 2ae4             sub ah, ah
  040BD8  0AE8: 050300           add ax, 3
  040BDB  0AEB: 8946ea           mov word ptr [bp - 0x16], ax
  040BDE  0AEE: 8946ec           mov word ptr [bp - 0x14], ax
  040BE1  0AF1: 833eb88d02       cmp word ptr [0x8db8], 2
  040BE6  0AF6: 7f05             jg 0xafd
  040BE8  0AF8: d1e0             shl ax, 1
  040BEA  0AFA: 8946ec           mov word ptr [bp - 0x14], ax
  040BED  0AFD: 833eb88d01       cmp word ptr [0x8db8], 1
  040BF2  0B02: 7f06             jg 0xb0a
  040BF4  0B04: 8b46ea           mov ax, word ptr [bp - 0x16]
  040BF7  0B07: 0146ec           add word ptr [bp - 0x14], ax
  040BFA  0B0A: 6a01             push 1
  040BFC  0B0C: ff76ec           push word ptr [bp - 0x14]
  040BFF  0B0F: ff76e8           push word ptr [bp - 0x18]
  040C02  0B12: ff36528d         push word ptr [0x8d52]
  040C06  0B16: 9a6c0d1f18       lcall 0x181f, 0xd6c
  040C0B  0B1B: 83c408           add sp, 8
  040C0E  0B1E: 5e               pop si
  040C0F  0B1F: c9               leave 
  040C10  0B20: cb               retf 
  040C11  0B21: 90               nop 
  040C12  0B22: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040C16  0B26: c6874c3100       mov byte ptr [bx + 0x314c], 0
  040C1B  0B2B: 5e               pop si
  040C1C  0B2C: c9               leave 
  040C1D  0B2D: cb               retf 

; ---- func_040C1E  size=515  insns=163  prologue=ENTER 0x0066,0  terminal=RETF ----
  040C1E  0B2E: c8660000         enter 0x66, 0
  040C22  0B32: 56               push si
  040C23  0B33: 2bc0             sub ax, ax
  040C25  0B35: 8946a0           mov word ptr [bp - 0x60], ax
  040C28  0B38: 8946a8           mov word ptr [bp - 0x58], ax
  040C2B  0B3B: 8946aa           mov word ptr [bp - 0x56], ax
  040C2E  0B3E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040C32  0B42: 8a874431         mov al, byte ptr [bx + 0x3144]
  040C36  0B46: 2ae4             sub ah, ah
  040C38  0B48: 8946a4           mov word ptr [bp - 0x5c], ax
  040C3B  0B4B: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  040C3F  0B4F: 2aed             sub ch, ch
  040C41  0B51: 894ea2           mov word ptr [bp - 0x5e], cx
  040C44  0B54: 51               push cx
  040C45  0B55: 50               push ax
  040C46  0B56: 8bf3             mov si, bx
  040C48  0B58: 9a0e071f18       lcall 0x181f, 0x70e
  040C4D  0B5D: 83c404           add sp, 4
  040C50  0B60: 89469a           mov word ptr [bp - 0x66], ax
  040C53  0B63: 89569c           mov word ptr [bp - 0x64], dx
  040C56  0B66: ff76a2           push word ptr [bp - 0x5e]
  040C59  0B69: ff76a4           push word ptr [bp - 0x5c]
  040C5C  0B6C: 9a8c071f18       lcall 0x181f, 0x78c
  040C61  0B71: 83c404           add sp, 4
  040C64  0B74: 8946ac           mov word ptr [bp - 0x54], ax
  040C67  0B77: c7469e0100       mov word ptr [bp - 0x62], 1
  040C6C  0B7C: 2ac0             sub al, al
  040C6E  0B7E: 88845a31         mov byte ptr [si + 0x315a], al
  040C72  0B82: 88844c31         mov byte ptr [si + 0x314c], al
  040C76  0B86: a19653           mov ax, word ptr [0x5396]
  040C79  0B89: 39069453         cmp word ptr [0x5394], ax
  040C7D  0B8D: 741c             je 0xbab
  040C7F  0B8F: 833ea25300       cmp word ptr [0x53a2], 0
  040C84  0B94: 742b             je 0xbc1
  040C86  0B96: 833e945304       cmp word ptr [0x5394], 4
  040C8B  0B9B: 7c05             jl 0xba2
  040C8D  0B9D: b80080           mov ax, 0x8000
  040C90  0BA0: eb03             jmp 0xba5
  040C92  0BA2: b80040           mov ax, 0x4000
  040C95  0BA5: 85068253         test word ptr [0x5382], ax
  040C99  0BA9: 7416             je 0xbc1
  040C9B  0BAB: 6a01             push 1
  040C9D  0BAD: ff76a2           push word ptr [bp - 0x5e]
  040CA0  0BB0: ff76a4           push word ptr [bp - 0x5c]
  040CA3  0BB3: ff76a2           push word ptr [bp - 0x5e]
  040CA6  0BB6: ff76a4           push word ptr [bp - 0x5c]
  040CA9  0BB9: 9a52031f18       lcall 0x181f, 0x352
  040CAE  0BBE: 83c40a           add sp, 0xa
  040CB1  0BC1: 8d46ae           lea ax, [bp - 0x52]
  040CB4  0BC4: 50               push ax
  040CB5  0BC5: ff369453         push word ptr [0x5394]
  040CB9  0BC9: 0e               push cs
  040CBA  0BCA: e86a0b           call 0x1737
  040CBD  0BCD: 83c404           add sp, 4
  040CC0  0BD0: 833e945304       cmp word ptr [0x5394], 4
  040CC5  0BD5: 7d31             jge 0xc08
  040CC7  0BD7: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  040CCC  0BDC: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  040CD1  0BE1: 7525             jne 0xc08
  040CD3  0BE3: c7065e1f0500     mov word ptr [0x1f5e], 5
  040CD9  0BE9: 6a17             push 0x17
  040CDB  0BEB: 8d1e7c08         lea bx, [0x87c]
  040CDF  0BEF: 8d066f14         lea ax, [0x146f]
  040CE3  0BF3: 8d56ae           lea dx, [bp - 0x52]
  040CE6  0BF6: 9a20011f19       lcall 0x191f, 0x120
  040CEB  0BFB: 0bc0             or ax, ax
  040CED  0BFD: 7403             je 0xc02
  040CEF  0BFF: e92c01           jmp 0xd2e
  040CF2  0C02: c7065e1fffff     mov word ptr [0x1f5e], 0xffff
  040CF8  0C08: ff7606           push word ptr [bp + 6]
  040CFB  0C0B: 9a34091f18       lcall 0x181f, 0x934
  040D00  0C10: 83c402           add sp, 2
  040D03  0C13: a18e53           mov ax, word ptr [0x538e]
  040D06  0C16: 691e94533c01     imul bx, word ptr [0x5394], 0x13c
  040D0C  0C1C: 89874e88         mov word ptr [bx - 0x77b2], ax
  040D10  0C20: ff7606           push word ptr [bp + 6]
  040D13  0C23: ff76a2           push word ptr [bp - 0x5e]
  040D16  0C26: ff76a4           push word ptr [bp - 0x5c]
  040D19  0C29: ff369453         push word ptr [0x5394]
  040D1D  0C2D: 9ab2091f19       lcall 0x191f, 0x9b2
  040D22  0C32: 83c408           add sp, 8
  040D25  0C35: 8946fe           mov word ptr [bp - 2], ax
  040D28  0C38: 0bc0             or ax, ax
  040D2A  0C3A: 7d03             jge 0xc3f
  040D2C  0C3C: e9ef00           jmp 0xd2e
  040D2F  0C3F: 833e945304       cmp word ptr [0x5394], 4
  040D34  0C44: 7d0c             jge 0xc52
  040D36  0C46: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  040D3B  0C4B: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  040D40  0C50: 7412             je 0xc64
  040D42  0C52: 8d46ae           lea ax, [bp - 0x52]
  040D45  0C55: 50               push ax
  040D46  0C56: a14285           mov ax, word ptr [0x8542]
  040D49  0C59: 40               inc ax
  040D4A  0C5A: 40               inc ax
  040D4B  0C5B: 50               push ax
  040D4C  0C5C: 9ae4071d0d       lcall 0xd1d, 0x7e4
  040D51  0C61: 83c404           add sp, 4
  040D54  0C64: 6a01             push 1
  040D56  0C66: 6a20             push 0x20
  040D58  0C68: 9abe0b1f18       lcall 0x181f, 0xbbe
  040D5D  0C6D: 83c404           add sp, 4
  040D60  0C70: 6a01             push 1
  040D62  0C72: 6a18             push 0x18
  040D64  0C74: 9abe0b1f18       lcall 0x181f, 0xbbe
  040D69  0C79: 83c404           add sp, 4
  040D6C  0C7C: 6a01             push 1
  040D6E  0C7E: 6a15             push 0x15
  040D70  0C80: 9abe0b1f18       lcall 0x181f, 0xbbe
  040D75  0C85: 83c404           add sp, 4
  040D78  0C88: 6a01             push 1
  040D7A  0C8A: 6a1b             push 0x1b
  040D7C  0C8C: 9abe0b1f18       lcall 0x181f, 0xbbe
  040D81  0C91: 83c404           add sp, 4
  040D84  0C94: 6a01             push 1
  040D86  0C96: 6a27             push 0x27
  040D88  0C98: 9abe0b1f18       lcall 0x181f, 0xbbe
  040D8D  0C9D: 83c404           add sp, 4
  040D90  0CA0: 833e945304       cmp word ptr [0x5394], 4
  040D95  0CA5: 7d1d             jge 0xcc4
  040D97  0CA7: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  040D9C  0CAC: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  040DA1  0CB1: 7511             jne 0xcc4
  040DA3  0CB3: 682098           push 0x9820
  040DA6  0CB6: a14285           mov ax, word ptr [0x8542]
  040DA9  0CB9: 40               inc ax
  040DAA  0CBA: 40               inc ax
  040DAB  0CBB: 50               push ax
  040DAC  0CBC: 9ae4071d0d       lcall 0xd1d, 0x7e4
  040DB1  0CC1: 83c404           add sp, 4
  040DB4  0CC4: a19653           mov ax, word ptr [0x5396]
  040DB7  0CC7: 39069453         cmp word ptr [0x5394], ax
  040DBB  0CCB: 741c             je 0xce9
  040DBD  0CCD: 833ea25300       cmp word ptr [0x53a2], 0
  040DC2  0CD2: 741f             je 0xcf3
  040DC4  0CD4: 833e945304       cmp word ptr [0x5394], 4
  040DC9  0CD9: 7c05             jl 0xce0
  040DCB  0CDB: b80080           mov ax, 0x8000
  040DCE  0CDE: eb03             jmp 0xce3
  040DD0  0CE0: b80040           mov ax, 0x4000
  040DD3  0CE3: 85068253         test word ptr [0x5382], ax
  040DD7  0CE7: 740a             je 0xcf3
  040DD9  0CE9: 6a01             push 1
  040DDB  0CEB: 9a1c0e1f18       lcall 0x181f, 0xe1c
  040DE0  0CF0: 83c402           add sp, 2
  040DE3  0CF3: 833e945304       cmp word ptr [0x5394], 4
  040DE8  0CF8: 7d34             jge 0xd2e
  040DEA  0CFA: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  040DEF  0CFF: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  040DF4  0D04: 7528             jne 0xd2e
  040DF6  0D06: b85400           mov ax, 0x54
  040DF9  0D09: 9ac0041f18       lcall 0x181f, 0x4c0
  040DFE  0D0E: 6a02             push 2
  040E00  0D10: 9a24051f18       lcall 0x181f, 0x524
  040E05  0D15: 83c402           add sp, 2
  040E08  0D18: c606370300       mov byte ptr [0x337], 0
  040E0D  0D1D: c7064e030000     mov word ptr [0x34e], 0
  040E13  0D23: ff76fe           push word ptr [bp - 2]
  040E16  0D26: 9a08061f18       lcall 0x181f, 0x608
  040E1B  0D2B: 83c402           add sp, 2
  040E1E  0D2E: 5e               pop si
  040E1F  0D2F: c9               leave 
  040E20  0D30: cb               retf 

; ---- func_040E22  size=436  insns=140  prologue=ENTER 0x0004,0  terminal=RETF ----
  040E22  0D32: c8040000         enter 4, 0
  040E26  0D36: 56               push si
  040E27  0D37: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040E2B  0D3B: 80bf4c310c       cmp byte ptr [bx + 0x314c], 0xc
  040E30  0D40: 7508             jne 0xd4a
  040E32  0D42: c706d61dffff     mov word ptr [0x1dd6], 0xffff
  040E38  0D48: eb0e             jmp 0xd58
  040E3A  0D4A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040E3E  0D4E: 8a874731         mov al, byte ptr [bx + 0x3147]
  040E42  0D52: 250f00           and ax, 0xf
  040E45  0D55: a3d61d           mov word ptr [0x1dd6], ax
  040E48  0D58: 8b4606           mov ax, word ptr [bp + 6]
  040E4B  0D5B: 9a10021f1a       lcall 0x1a1f, 0x210
  040E50  0D60: 0bc0             or ax, ax
  040E52  0D62: 7d03             jge 0xd67
  040E54  0D64: e95d01           jmp 0xec4
  040E57  0D67: 3d0800           cmp ax, 8
  040E5A  0D6A: 7c03             jl 0xd6f
  040E5C  0D6C: e95501           jmp 0xec4
  040E5F  0D6F: 8b0e9c53         mov cx, word ptr [0x539c]
  040E63  0D73: 894efe           mov word ptr [bp - 2], cx
  040E66  0D76: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040E6A  0D7A: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  040E6E  0D7E: 80e10f           and cl, 0xf
  040E71  0D81: 80f904           cmp cl, 4
  040E74  0D84: 732e             jae 0xdb4
  040E76  0D86: 2aed             sub ch, ch
  040E78  0D88: 6bf134           imul si, cx, 0x34
  040E7B  0D8B: 38ac3f54         cmp byte ptr [si + 0x543f], ch
  040E7F  0D8F: 7523             jne 0xdb4
  040E81  0D91: 8bf0             mov si, ax
  040E83  0D93: 8a84be00         mov al, byte ptr [si + 0xbe]
  040E87  0D97: 98               cwde 
  040E88  0D98: 50               push ax
  040E89  0D99: 8a84b400         mov al, byte ptr [si + 0xb4]
  040E8D  0D9D: 98               cwde 
  040E8E  0D9E: 50               push ax
  040E8F  0D9F: 8bf3             mov si, bx
  040E91  0DA1: 9a4e041f19       lcall 0x191f, 0x44e
  040E96  0DA6: 83c404           add sp, 4
  040E99  0DA9: 0bc0             or ax, ax
  040E9B  0DAB: 7432             je 0xddf
  040E9D  0DAD: c6844c3100       mov byte ptr [si + 0x314c], 0
  040EA2  0DB2: eb2b             jmp 0xddf
  040EA4  0DB4: 8bd8             mov bx, ax
  040EA6  0DB6: 8a87be00         mov al, byte ptr [bx + 0xbe]
  040EAA  0DBA: 98               cwde 
  040EAB  0DBB: 6b76061c         imul si, word ptr [bp + 6], 0x1c
  040EAF  0DBF: 8a8c4531         mov cl, byte ptr [si + 0x3145]
  040EB3  0DC3: 2aed             sub ch, ch
  040EB5  0DC5: 03c1             add ax, cx
  040EB7  0DC7: 50               push ax
  040EB8  0DC8: 8a87b400         mov al, byte ptr [bx + 0xb4]
  040EBC  0DCC: 98               cwde 
  040EBD  0DCD: 8a8c4431         mov cl, byte ptr [si + 0x3144]
  040EC1  0DD1: 03c8             add cx, ax
  040EC3  0DD3: 51               push cx
  040EC4  0DD4: ff7606           push word ptr [bp + 6]
  040EC7  0DD7: 9a42011f1a       lcall 0x1a1f, 0x142
  040ECC  0DDC: 83c406           add sp, 6
  040ECF  0DDF: a19c53           mov ax, word ptr [0x539c]
  040ED2  0DE2: 3946fe           cmp word ptr [bp - 2], ax
  040ED5  0DE5: 7403             je 0xdea
  040ED7  0DE7: e9f300           jmp 0xedd
  040EDA  0DEA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040EDE  0DEE: 8a874431         mov al, byte ptr [bx + 0x3144]
  040EE2  0DF2: 38874d31         cmp byte ptr [bx + 0x314d], al
  040EE6  0DF6: 7403             je 0xdfb
  040EE8  0DF8: e9e200           jmp 0xedd
  040EEB  0DFB: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  040EEF  0DFF: 388f4e31         cmp byte ptr [bx + 0x314e], cl
  040EF3  0E03: 7403             je 0xe08
  040EF5  0E05: e9d500           jmp 0xedd
  040EF8  0E08: 2aed             sub ch, ch
  040EFA  0E0A: 51               push cx
  040EFB  0E0B: 2ae4             sub ah, ah
  040EFD  0E0D: 50               push ax
  040EFE  0E0E: 8bf3             mov si, bx
  040F00  0E10: 9a8c071f18       lcall 0x181f, 0x78c
  040F05  0E15: 83c404           add sp, 4
  040F08  0E18: 3d1a00           cmp ax, 0x1a
  040F0B  0E1B: 7567             jne 0xe84
  040F0D  0E1D: 80bc4c310c       cmp byte ptr [si + 0x314c], 0xc
  040F12  0E22: 7460             je 0xe84
  040F14  0E24: 833e945304       cmp word ptr [0x5394], 4
  040F19  0E29: 7d0c             jge 0xe37
  040F1B  0E2B: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  040F20  0E30: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  040F25  0E35: 740b             je 0xe42
  040F27  0E37: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040F2B  0E3B: 80bf4b3145       cmp byte ptr [bx + 0x314b], 0x45
  040F30  0E40: 7542             jne 0xe84
  040F32  0E42: f606825301       test byte ptr [0x5382], 1
  040F37  0E47: 7414             je 0xe5d
  040F39  0E49: a1d253           mov ax, word ptr [0x53d2]
  040F3C  0E4C: 39069453         cmp word ptr [0x5394], ax
  040F40  0E50: 7532             jne 0xe84
  040F42  0E52: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040F46  0E56: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  040F4B  0E5B: 7527             jne 0xe84
  040F4D  0E5D: 8b4606           mov ax, word ptr [bp + 6]
  040F50  0E60: a39253           mov word ptr [0x5392], ax
  040F53  0E63: 9a08021f19       lcall 0x191f, 0x208
  040F58  0E68: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040F5C  0E6C: 8a874731         mov al, byte ptr [bx + 0x3147]
  040F60  0E70: 240f             and al, 0xf
  040F62  0E72: 3a069653         cmp al, byte ptr [0x5396]
  040F66  0E76: 750c             jne 0xe84
  040F68  0E78: ff369253         push word ptr [0x5392]
  040F6C  0E7C: 9af40d1f18       lcall 0x181f, 0xdf4
  040F71  0E81: 83c402           add sp, 2
  040F74  0E84: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040F78  0E88: 80bf463102       cmp byte ptr [bx + 0x3146], 2
  040F7D  0E8D: 750a             jne 0xe99
  040F7F  0E8F: c687553100       mov byte ptr [bx + 0x3155], 0
  040F84  0E94: c6875631ff       mov byte ptr [bx + 0x3156], 0xff
  040F89  0E99: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040F8D  0E9D: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  040F92  0EA2: 750b             jne 0xeaf
  040F94  0EA4: ff7606           push word ptr [bp + 6]
  040F97  0EA7: 9a34091f18       lcall 0x181f, 0x934
  040F9C  0EAC: 83c402           add sp, 2
  040F9F  0EAF: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040FA3  0EB3: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  040FA8  0EB8: 7423             je 0xedd
  040FAA  0EBA: 80bf4c310c       cmp byte ptr [bx + 0x314c], 0xc
  040FAF  0EBF: 741c             je 0xedd
  040FB1  0EC1: eb15             jmp 0xed8
  040FB3  0EC3: 90               nop 
  040FB4  0EC4: 3d0800           cmp ax, 8
  040FB7  0EC7: 750b             jne 0xed4
  040FB9  0EC9: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040FBD  0ECD: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  040FC2  0ED2: 7409             je 0xedd
  040FC4  0ED4: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  040FC8  0ED8: c6874c3100       mov byte ptr [bx + 0x314c], 0
  040FCD  0EDD: c706d61dffff     mov word ptr [0x1dd6], 0xffff
  040FD3  0EE3: 5e               pop si
  040FD4  0EE4: c9               leave 
  040FD5  0EE5: cb               retf 

; ---- func_040FD6  size=70  insns=24  prologue=ENTER 0x0004,0  terminal=RETF ----
  040FD6  0EE6: c8040000         enter 4, 0
  040FDA  0EEA: c746fe0000       mov word ptr [bp - 2], 0
  040FDF  0EEF: ff7608           push word ptr [bp + 8]
  040FE2  0EF2: ff7606           push word ptr [bp + 6]
  040FE5  0EF5: 9a8c071f18       lcall 0x181f, 0x78c
  040FEA  0EFA: 83c404           add sp, 4
  040FED  0EFD: 3d1900           cmp ax, 0x19
  040FF0  0F00: 7405             je 0xf07
  040FF2  0F02: 3d1a00           cmp ax, 0x1a
  040FF5  0F05: 7520             jne 0xf27
  040FF7  0F07: ff46fe           inc word ptr [bp - 2]
  040FFA  0F0A: 3d1a00           cmp ax, 0x1a
  040FFD  0F0D: 7418             je 0xf27
  040FFF  0F0F: ff46fe           inc word ptr [bp - 2]
  041002  0F12: ff7608           push word ptr [bp + 8]
  041005  0F15: ff7606           push word ptr [bp + 6]
  041008  0F18: 9a18071f18       lcall 0x181f, 0x718
  04100D  0F1D: 83c404           add sp, 4
  041010  0F20: 40               inc ax
  041011  0F21: 7404             je 0xf27
  041013  0F23: 8346fe03         add word ptr [bp - 2], 3
  041017  0F27: 8b46fe           mov ax, word ptr [bp - 2]
  04101A  0F2A: c9               leave 
  04101B  0F2B: cb               retf 

; ---- func_04101C  size=23  insns=7  prologue=ENTER 0x0012,0  terminal=RETF ----
  04101C  0F2C: c8120000         enter 0x12, 0
  041020  0F30: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041024  0F34: c6874c3106       mov byte ptr [bx + 0x314c], 6
  041029  0F39: ff7606           push word ptr [bp + 6]
  04102C  0F3C: 9a34091f18       lcall 0x181f, 0x934
  041031  0F41: c9               leave 
  041032  0F42: cb               retf 

; ---- func_041034  size=76  insns=25  prologue=ENTER 0x0002,0  terminal=RETF ----
  041034  0F44: c8020000         enter 2, 0
  041038  0F48: 56               push si
  041039  0F49: c746fe0000       mov word ptr [bp - 2], 0
  04103E  0F4E: 817e08e703       cmp word ptr [bp + 8], 0x3e7
  041043  0F53: 7513             jne 0xf68
  041045  0F55: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041049  0F59: 8a874731         mov al, byte ptr [bx + 0x3147]
  04104D  0F5D: 240f             and al, 0xf
  04104F  0F5F: 2a874431         sub al, byte ptr [bx + 0x3144]
  041053  0F63: 3c14             cmp al, 0x14
  041055  0F65: eb1c             jmp 0xf83
  041057  0F67: 90               nop 
  041058  0F68: 695e08ca00       imul bx, word ptr [bp + 8], 0xca
  04105D  0F6D: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  041061  0F71: 6b76061c         imul si, word ptr [bp + 6], 0x1c
  041065  0F75: 38844431         cmp byte ptr [si + 0x3144], al
  041069  0F79: 750f             jne 0xf8a
  04106B  0F7B: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  04106F  0F7F: 38844531         cmp byte ptr [si + 0x3145], al
  041073  0F83: 7505             jne 0xf8a
  041075  0F85: c746fe0100       mov word ptr [bp - 2], 1
  04107A  0F8A: 8b46fe           mov ax, word ptr [bp - 2]
  04107D  0F8D: 5e               pop si
  04107E  0F8E: c9               leave 
  04107F  0F8F: cb               retf 

; ---- func_041080  size=912  insns=314  prologue=ENTER 0x0042,0  terminal=RETF ----
  041080  0F90: c8420000         enter 0x42, 0
  041084  0F94: 56               push si
  041085  0F95: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041089  0F99: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  04108E  0F9E: 7408             je 0xfa8
  041090  0FA0: c6874c3100       mov byte ptr [bx + 0x314c], 0
  041095  0FA5: 5e               pop si
  041096  0FA6: c9               leave 
  041097  0FA7: cb               retf 
  041098  0FA8: ff7606           push word ptr [bp + 6]
  04109B  0FAB: 9a58081f18       lcall 0x181f, 0x858
  0410A0  0FB0: 83c402           add sp, 2
  0410A3  0FB3: 50               push ax
  0410A4  0FB4: 9ace021f19       lcall 0x191f, 0x2ce
  0410A9  0FB9: 83c402           add sp, 2
  0410AC  0FBC: ff7606           push word ptr [bp + 6]
  0410AF  0FBF: 9a76081f18       lcall 0x181f, 0x876
  0410B4  0FC4: 83c402           add sp, 2
  0410B7  0FC7: 8946fc           mov word ptr [bp - 4], ax
  0410BA  0FCA: 50               push ax
  0410BB  0FCB: 9a4a0a1f19       lcall 0x191f, 0xa4a
  0410C0  0FD0: 83c402           add sp, 2
  0410C3  0FD3: c41e189e         les bx, ptr [0x9e18]
  0410C7  0FD7: 268b07           mov ax, word ptr es:[bx]
  0410CA  0FDA: 8946e8           mov word ptr [bp - 0x18], ax
  0410CD  0FDD: 50               push ax
  0410CE  0FDE: ff7606           push word ptr [bp + 6]
  0410D1  0FE1: 0e               push cs
  0410D2  0FE2: e85707           call 0x173c
  0410D5  0FE5: 83c404           add sp, 4
  0410D8  0FE8: 0bc0             or ax, ax
  0410DA  0FEA: 7403             je 0xfef
  0410DC  0FEC: e9bb00           jmp 0x10aa
  0410DF  0FEF: 8b4608           mov ax, word ptr [bp + 8]
  0410E2  0FF2: 8946ea           mov word ptr [bp - 0x16], ax
  0410E5  0FF5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0410E9  0FF9: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  0410ED  0FFD: 2aed             sub ch, ch
  0410EF  0FFF: 51               push cx
  0410F0  1000: 8a8f4431         mov cl, byte ptr [bx + 0x3144]
  0410F4  1004: 51               push cx
  0410F5  1005: 8bf3             mov si, bx
  0410F7  1007: 9a02031f18       lcall 0x181f, 0x302
  0410FC  100C: 83c404           add sp, 4
  0410FF  100F: 0bc0             or ax, ax
  041101  1011: 7427             je 0x103a
  041103  1013: 8a844531         mov al, byte ptr [si + 0x3145]
  041107  1017: 2ae4             sub ah, ah
  041109  1019: 50               push ax
  04110A  101A: 8a844431         mov al, byte ptr [si + 0x3144]
  04110E  101E: 50               push ax
  04110F  101F: 9abe061f18       lcall 0x181f, 0x6be
  041114  1024: 83c404           add sp, 4
  041117  1027: 0bc0             or ax, ax
  041119  1029: 7c05             jl 0x1030
  04111B  102B: b80100           mov ax, 1
  04111E  102E: eb02             jmp 0x1032
  041120  1030: 2bc0             sub ax, ax
  041122  1032: 0b46ea           or ax, word ptr [bp - 0x16]
  041125  1035: 8946ea           mov word ptr [bp - 0x16], ax
  041128  1038: eb10             jmp 0x104a
  04112A  103A: 68e703           push 0x3e7
  04112D  103D: ff7606           push word ptr [bp + 6]
  041130  1040: 0e               push cs
  041131  1041: e8f806           call 0x173c
  041134  1044: 83c404           add sp, 4
  041137  1047: 0946ea           or word ptr [bp - 0x16], ax
  04113A  104A: 837eea00         cmp word ptr [bp - 0x16], 0
  04113E  104E: 7434             je 0x1084
  041140  1050: 817ee8e703       cmp word ptr [bp - 0x18], 0x3e7
  041145  1055: 750d             jne 0x1064
  041147  1057: ff7606           push word ptr [bp + 6]
  04114A  105A: 9aea021f19       lcall 0x191f, 0x2ea
  04114F  105F: 83c402           add sp, 2
  041152  1062: eb20             jmp 0x1084
  041154  1064: ff76e8           push word ptr [bp - 0x18]
  041157  1067: 9ae6091f18       lcall 0x181f, 0x9e6
  04115C  106C: 83c402           add sp, 2
  04115F  106F: 8b1e4285         mov bx, word ptr [0x8542]
  041163  1073: 8a07             mov al, byte ptr [bx]
  041165  1075: 6b76061c         imul si, word ptr [bp + 6], 0x1c
  041169  1079: 88844d31         mov byte ptr [si + 0x314d], al
  04116D  107D: 8a4701           mov al, byte ptr [bx + 1]
  041170  1080: 88844e31         mov byte ptr [si + 0x314e], al
  041174  1084: 68e703           push 0x3e7
  041177  1087: ff7606           push word ptr [bp + 6]
  04117A  108A: 0e               push cs
  04117B  108B: e8ae06           call 0x173c
  04117E  108E: 83c404           add sp, 4
  041181  1091: 0bc0             or ax, ax
  041183  1093: 740b             je 0x10a0
  041185  1095: ff7606           push word ptr [bp + 6]
  041188  1098: 9ac20e1f19       lcall 0x191f, 0xec2
  04118D  109D: e97a02           jmp 0x131a
  041190  10A0: ff7606           push word ptr [bp + 6]
  041193  10A3: 0e               push cs
  041194  10A4: e88106           call 0x1728
  041197  10A7: e97002           jmp 0x131a
  04119A  10AA: 817ee8e703       cmp word ptr [bp - 0x18], 0x3e7
  04119F  10AF: 751f             jne 0x10d0
  0411A1  10B1: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0411A5  10B5: 8a874731         mov al, byte ptr [bx + 0x3147]
  0411A9  10B9: 250f00           and ax, 0xf
  0411AC  10BC: 50               push ax
  0411AD  10BD: 9a82051f18       lcall 0x181f, 0x582
  0411B2  10C2: 83c402           add sp, 2
  0411B5  10C5: ff7606           push word ptr [bp + 6]
  0411B8  10C8: 9a34091f18       lcall 0x181f, 0x934
  0411BD  10CD: eb09             jmp 0x10d8
  0411BF  10CF: 90               nop 
  0411C0  10D0: ff76e8           push word ptr [bp - 0x18]
  0411C3  10D3: 9ae6091f18       lcall 0x181f, 0x9e6
  0411C8  10D8: 83c402           add sp, 2
  0411CB  10DB: 6a00             push 0
  0411CD  10DD: 9a2a021f1a       lcall 0x1a1f, 0x22a
  0411D2  10E2: 83c402           add sp, 2
  0411D5  10E5: 8946be           mov word ptr [bp - 0x42], ax
  0411D8  10E8: c746e20000       mov word ptr [bp - 0x1e], 0
  0411DD  10ED: eb1a             jmp 0x1109
  0411DF  10EF: 90               nop 
  0411E0  10F0: 6a00             push 0
  0411E2  10F2: ff76e0           push word ptr [bp - 0x20]
  0411E5  10F5: ff7606           push word ptr [bp + 6]
  0411E8  10F8: 9a94051f19       lcall 0x191f, 0x594
  0411ED  10FD: 83c406           add sp, 6
  0411F0  1100: 837ee600         cmp word ptr [bp - 0x1a], 0
  0411F4  1104: 7d26             jge 0x112c
  0411F6  1106: ff46e2           inc word ptr [bp - 0x1e]
  0411F9  1109: 8b46be           mov ax, word ptr [bp - 0x42]
  0411FC  110C: 3946e2           cmp word ptr [bp - 0x1e], ax
  0411FF  110F: 7d47             jge 0x1158
  041201  1111: ff76e2           push word ptr [bp - 0x1e]
  041204  1114: 9a1c021f1a       lcall 0x1a1f, 0x21c
  041209  1119: 83c402           add sp, 2
  04120C  111C: 8946e0           mov word ptr [bp - 0x20], ax
  04120F  111F: 50               push ax
  041210  1120: 9ad80c1f19       lcall 0x191f, 0xcd8
  041215  1125: 83c402           add sp, 2
  041218  1128: 0bc0             or ax, ax
  04121A  112A: 75da             jne 0x1106
  04121C  112C: ff76e0           push word ptr [bp - 0x20]
  04121F  112F: ff7606           push word ptr [bp + 6]
  041222  1132: 9a2c0c1f18       lcall 0x181f, 0xc2c
  041227  1137: 83c404           add sp, 4
  04122A  113A: 8946e6           mov word ptr [bp - 0x1a], ax
  04122D  113D: 0bc0             or ax, ax
  04122F  113F: 7cbf             jl 0x1100
  041231  1141: 817ee8e703       cmp word ptr [bp - 0x18], 0x3e7
  041236  1146: 75a8             jne 0x10f0
  041238  1148: 6a00             push 0
  04123A  114A: ff76e0           push word ptr [bp - 0x20]
  04123D  114D: ff7606           push word ptr [bp + 6]
  041240  1150: 9a020d1f19       lcall 0x191f, 0xd02
  041245  1155: eba6             jmp 0x10fd
  041247  1157: 90               nop 
  041248  1158: 817ee8e703       cmp word ptr [bp - 0x18], 0x3e7
  04124D  115D: 7547             jne 0x11a6
  04124F  115F: 6a01             push 1
  041251  1161: 9a2a021f1a       lcall 0x1a1f, 0x22a
  041256  1166: 83c402           add sp, 2
  041259  1169: 8946be           mov word ptr [bp - 0x42], ax
  04125C  116C: c746e20000       mov word ptr [bp - 0x1e], 0
  041261  1171: eb04             jmp 0x1177
  041263  1173: 90               nop 
  041264  1174: ff46e2           inc word ptr [bp - 0x1e]
  041267  1177: 8b46be           mov ax, word ptr [bp - 0x42]
  04126A  117A: 3946e2           cmp word ptr [bp - 0x1e], ax
  04126D  117D: 7c03             jl 0x1182
  04126F  117F: e91701           jmp 0x1299
  041272  1182: 6a00             push 0
  041274  1184: 6a01             push 1
  041276  1186: 8b46e2           mov ax, word ptr [bp - 0x1e]
  041279  1189: 050600           add ax, 6
  04127C  118C: 50               push ax
  04127D  118D: 9a1c021f1a       lcall 0x1a1f, 0x21c
  041282  1192: 83c402           add sp, 2
  041285  1195: 8946e0           mov word ptr [bp - 0x20], ax
  041288  1198: 50               push ax
  041289  1199: ff7606           push word ptr [bp + 6]
  04128C  119C: 9a420b1f19       lcall 0x191f, 0xb42
  041291  11A1: 83c408           add sp, 8
  041294  11A4: ebce             jmp 0x1174
  041296  11A6: c746e40100       mov word ptr [bp - 0x1c], 1
  04129B  11AB: e9c800           jmp 0x1276
  04129E  11AE: 837ee400         cmp word ptr [bp - 0x1c], 0
  0412A2  11B2: 7503             jne 0x11b7
  0412A4  11B4: e9e200           jmp 0x1299
  0412A7  11B7: 6a20             push 0x20
  0412A9  11B9: 6a00             push 0
  0412AB  11BB: 8d46c0           lea ax, [bp - 0x40]
  0412AE  11BE: 50               push ax
  0412AF  11BF: 9aae0d1d0d       lcall 0xd1d, 0xdae
  0412B4  11C4: 83c406           add sp, 6
  0412B7  11C7: c746e20000       mov word ptr [bp - 0x1e], 0
  0412BC  11CC: 8a46e2           mov al, byte ptr [bp - 0x1e]
  0412BF  11CF: 8b76e2           mov si, word ptr [bp - 0x1e]
  0412C2  11D2: 8842ec           mov byte ptr [bp + si - 0x14], al
  0412C5  11D5: ff46e2           inc word ptr [bp - 0x1e]
  0412C8  11D8: 837ee210         cmp word ptr [bp - 0x1e], 0x10
  0412CC  11DC: 7cee             jl 0x11cc
  0412CE  11DE: 6a01             push 1
  0412D0  11E0: 9a2a021f1a       lcall 0x1a1f, 0x22a
  0412D5  11E5: 83c402           add sp, 2
  0412D8  11E8: 8946be           mov word ptr [bp - 0x42], ax
  0412DB  11EB: c746e20000       mov word ptr [bp - 0x1e], 0
  0412E0  11F0: eb3d             jmp 0x122f
  0412E2  11F2: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0412E5  11F5: 050600           add ax, 6
  0412E8  11F8: 50               push ax
  0412E9  11F9: 9a1c021f1a       lcall 0x1a1f, 0x21c
  0412EE  11FE: 83c402           add sp, 2
  0412F1  1201: 8946e0           mov word ptr [bp - 0x20], ax
  0412F4  1204: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0412F8  1208: 8a874731         mov al, byte ptr [bx + 0x3147]
  0412FC  120C: 250f00           and ax, 0xf
  0412FF  120F: 8bf0             mov si, ax
  041301  1211: c1e604           shl si, 4
  041304  1214: 8b5ee0           mov bx, word ptr [bp - 0x20]
  041307  1217: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  04130B  121B: 2ae4             sub ah, ah
  04130D  121D: 8bf3             mov si, bx
  04130F  121F: d1e6             shl si, 1
  041311  1221: 8b1e4285         mov bx, word ptr [0x8542]
  041315  1225: f7a89a00         imul word ptr [bx + si + 0x9a]
  041319  1229: 8942c0           mov word ptr [bp + si - 0x40], ax
  04131C  122C: ff46e2           inc word ptr [bp - 0x1e]
  04131F  122F: 8b46be           mov ax, word ptr [bp - 0x42]
  041322  1232: 3946e2           cmp word ptr [bp - 0x1e], ax
  041325  1235: 7cbb             jl 0x11f2
  041327  1237: 8d46ec           lea ax, [bp - 0x14]
  04132A  123A: 16               push ss
  04132B  123B: 50               push ax
  04132C  123C: 8d46c0           lea ax, [bp - 0x40]
  04132F  123F: 16               push ss
  041330  1240: 50               push ax
  041331  1241: b81000           mov ax, 0x10
  041334  1244: 9ad00e1f19       lcall 0x191f, 0xed0
  041339  1249: c746e40000       mov word ptr [bp - 0x1c], 0
  04133E  124E: 837ede00         cmp word ptr [bp - 0x22], 0
  041342  1252: 7422             je 0x1276
  041344  1254: 6a00             push 0
  041346  1256: 6a01             push 1
  041348  1258: 8a46fb           mov al, byte ptr [bp - 5]
  04134B  125B: 2ae4             sub ah, ah
  04134D  125D: 8946e0           mov word ptr [bp - 0x20], ax
  041350  1260: 50               push ax
  041351  1261: ff7606           push word ptr [bp + 6]
  041354  1264: 9af8071f19       lcall 0x191f, 0x7f8
  041359  1269: 83c408           add sp, 8
  04135C  126C: 3d0100           cmp ax, 1
  04135F  126F: 1bc0             sbb ax, ax
  041361  1271: f7d8             neg ax
  041363  1273: 8946e4           mov word ptr [bp - 0x1c], ax
  041366  1276: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04136A  127A: 8a875031         mov al, byte ptr [bx + 0x3150]
  04136E  127E: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  041372  1282: 2aff             sub bh, bh
  041374  1284: 8bcb             mov cx, bx
  041376  1286: d1e3             shl bx, 1
  041378  1288: 03d9             add bx, cx
  04137A  128A: d1e3             shl bx, 1
  04137C  128C: 03d9             add bx, cx
  04137E  128E: d1e3             shl bx, 1
  041380  1290: 38873752         cmp byte ptr [bx + 0x5237], al
  041384  1294: 7403             je 0x1299
  041386  1296: e915ff           jmp 0x11ae
  041389  1299: 8b46fc           mov ax, word ptr [bp - 4]
  04138C  129C: 40               inc ax
  04138D  129D: c41e149e         les bx, ptr [0x9e14]
  041391  12A1: 268a4f21         mov cl, byte ptr es:[bx + 0x21]
  041395  12A5: 2aed             sub ch, ch
  041397  12A7: 99               cdq 
  041398  12A8: f7f9             idiv cx
  04139A  12AA: 8956fc           mov word ptr [bp - 4], dx
  04139D  12AD: 52               push dx
  04139E  12AE: ff7606           push word ptr [bp + 6]
  0413A1  12B1: 9ab2081f18       lcall 0x181f, 0x8b2
  0413A6  12B6: 83c404           add sp, 4
  0413A9  12B9: c746fe0000       mov word ptr [bp - 2], 0
  0413AE  12BE: c746e20100       mov word ptr [bp - 0x1e], 1
  0413B3  12C3: eb1f             jmp 0x12e4
  0413B5  12C5: 90               nop 
  0413B6  12C6: 268b4722         mov ax, word ptr es:[bx + 0x22]
  0413BA  12CA: 8b76e2           mov si, word ptr [bp - 0x1e]
  0413BD  12CD: 8bce             mov cx, si
  0413BF  12CF: c1e602           shl si, 2
  0413C2  12D2: 03f1             add si, cx
  0413C4  12D4: d1e6             shl si, 1
  0413C6  12D6: 26394022         cmp word ptr es:[bx + si + 0x22], ax
  0413CA  12DA: 7405             je 0x12e1
  0413CC  12DC: c746fe0100       mov word ptr [bp - 2], 1
  0413D1  12E1: ff46e2           inc word ptr [bp - 0x1e]
  0413D4  12E4: c41e149e         les bx, ptr [0x9e14]
  0413D8  12E8: 268a4721         mov al, byte ptr es:[bx + 0x21]
  0413DC  12EC: 2ae4             sub ah, ah
  0413DE  12EE: 3b46e2           cmp ax, word ptr [bp - 0x1e]
  0413E1  12F1: 7fd3             jg 0x12c6
  0413E3  12F3: 837efe00         cmp word ptr [bp - 2], 0
  0413E7  12F7: 7524             jne 0x131d
  0413E9  12F9: 06               push es
  0413EA  12FA: 53               push bx
  0413EB  12FB: 6a00             push 0
  0413ED  12FD: 9a16041f18       lcall 0x181f, 0x416
  0413F2  1302: 83c406           add sp, 6
  0413F5  1305: 6a00             push 0
  0413F7  1307: 687614           push 0x1476
  0413FA  130A: 9a52061f18       lcall 0x181f, 0x652
  0413FF  130F: 83c404           add sp, 4
  041402  1312: ff7606           push word ptr [bp + 6]
  041405  1315: 9a34091f18       lcall 0x181f, 0x934
  04140A  131A: 83c402           add sp, 2
  04140D  131D: 5e               pop si
  04140E  131E: c9               leave 
  04140F  131F: cb               retf 

; ---- func_041410  size=579  insns=202  prologue=ENTER 0x0022,0  terminal=RETF ----
  041410  1320: c8220000         enter 0x22, 0
  041414  1324: 56               push si
  041415  1325: c746f60100       mov word ptr [bp - 0xa], 1
  04141A  132A: c746ecffff       mov word ptr [bp - 0x14], 0xffff
  04141F  132F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041423  1333: 8a875031         mov al, byte ptr [bx + 0x3150]
  041427  1337: 2ae4             sub ah, ah
  041429  1339: 8946f2           mov word ptr [bp - 0xe], ax
  04142C  133C: 3d0100           cmp ax, 1
  04142F  133F: 7d13             jge 0x1354
  041431  1341: 6a03             push 3
  041433  1343: 6a16             push 0x16
  041435  1345: 9ae00d1f18       lcall 0x181f, 0xde0
  04143A  134A: 83c404           add sp, 4
  04143D  134D: 8b46f6           mov ax, word ptr [bp - 0xa]
  041440  1350: 5e               pop si
  041441  1351: c9               leave 
  041442  1352: cb               retf 
  041443  1353: 90               nop 
  041444  1354: c746ee0000       mov word ptr [bp - 0x12], 0
  041449  1359: eb72             jmp 0x13cd
  04144B  135B: 90               nop 
  04144C  135C: 8bf0             mov si, ax
  04144E  135E: 8842fa           mov byte ptr [bp + si - 6], al
  041451  1361: 56               push si
  041452  1362: ff7606           push word ptr [bp + 6]
  041455  1365: 9ae60b1f18       lcall 0x181f, 0xbe6
  04145A  136A: 83c404           add sp, 4
  04145D  136D: 8946ea           mov word ptr [bp - 0x16], ax
  041460  1370: 56               push si
  041461  1371: ff7606           push word ptr [bp + 6]
  041464  1374: 9a680c1f18       lcall 0x181f, 0xc68
  041469  1379: 83c404           add sp, 4
  04146C  137C: 8946f4           mov word ptr [bp - 0xc], ax
  04146F  137F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041473  1383: 8a874731         mov al, byte ptr [bx + 0x3147]
  041477  1387: 250f00           and ax, 0xf
  04147A  138A: 8bf0             mov si, ax
  04147C  138C: c1e604           shl si, 4
  04147F  138F: 8b5eea           mov bx, word ptr [bp - 0x16]
  041482  1392: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  041486  1396: 2ae4             sub ah, ah
  041488  1398: c1e004           shl ax, 4
  04148B  139B: 8946f0           mov word ptr [bp - 0x10], ax
  04148E  139E: 83fb0f           cmp bx, 0xf
  041491  13A1: 7505             jne 0x13a8
  041493  13A3: c746f00000       mov word ptr [bp - 0x10], 0
  041498  13A8: 83fb0e           cmp bx, 0xe
  04149B  13AB: 7505             jne 0x13b2
  04149D  13AD: c746f00000       mov word ptr [bp - 0x10], 0
  0414A2  13B2: 83fb08           cmp bx, 8
  0414A5  13B5: 7505             jne 0x13bc
  0414A7  13B7: c746f00100       mov word ptr [bp - 0x10], 1
  0414AC  13BC: 8b46f0           mov ax, word ptr [bp - 0x10]
  0414AF  13BF: f76ef4           imul word ptr [bp - 0xc]
  0414B2  13C2: 8b76ee           mov si, word ptr [bp - 0x12]
  0414B5  13C5: d1e6             shl si, 1
  0414B7  13C7: 8942de           mov word ptr [bp + si - 0x22], ax
  0414BA  13CA: ff46ee           inc word ptr [bp - 0x12]
  0414BD  13CD: 8b46ee           mov ax, word ptr [bp - 0x12]
  0414C0  13D0: 3946f2           cmp word ptr [bp - 0xe], ax
  0414C3  13D3: 7f87             jg 0x135c
  0414C5  13D5: 8d46fa           lea ax, [bp - 6]
  0414C8  13D8: 16               push ss
  0414C9  13D9: 50               push ax
  0414CA  13DA: 8d4ede           lea cx, [bp - 0x22]
  0414CD  13DD: 16               push ss
  0414CE  13DE: 51               push cx
  0414CF  13DF: 8b46f2           mov ax, word ptr [bp - 0xe]
  0414D2  13E2: 9ad00e1f19       lcall 0x191f, 0xed0
  0414D7  13E7: 8a46fa           mov al, byte ptr [bp - 6]
  0414DA  13EA: 2ae4             sub ah, ah
  0414DC  13EC: 8946ec           mov word ptr [bp - 0x14], ax
  0414DF  13EF: 0bc0             or ax, ax
  0414E1  13F1: 7d07             jge 0x13fa
  0414E3  13F3: 6a03             push 3
  0414E5  13F5: 6a14             push 0x14
  0414E7  13F7: e94bff           jmp 0x1345
  0414EA  13FA: 50               push ax
  0414EB  13FB: ff7606           push word ptr [bp + 6]
  0414EE  13FE: 9ae60b1f18       lcall 0x181f, 0xbe6
  0414F3  1403: 83c404           add sp, 4
  0414F6  1406: 8946ea           mov word ptr [bp - 0x16], ax
  0414F9  1409: ff76ec           push word ptr [bp - 0x14]
  0414FC  140C: ff7606           push word ptr [bp + 6]
  0414FF  140F: 9a680c1f18       lcall 0x181f, 0xc68
  041504  1414: 83c404           add sp, 4
  041507  1417: 8946f4           mov word ptr [bp - 0xc], ax
  04150A  141A: 837e0800         cmp word ptr [bp + 8], 0
  04150E  141E: 7403             je 0x1423
  041510  1420: e98a00           jmp 0x14ad
  041513  1423: 9a3a0d1f18       lcall 0x181f, 0xd3a
  041518  1428: 8946f8           mov word ptr [bp - 8], ax
  04151B  142B: 8b76ea           mov si, word ptr [bp - 0x16]
  04151E  142E: d1e6             shl si, 1
  041520  1430: 8b1e4285         mov bx, word ptr [0x8542]
  041524  1434: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  041528  1438: 0346f4           add ax, word ptr [bp - 0xc]
  04152B  143B: 3b46f8           cmp ax, word ptr [bp - 8]
  04152E  143E: 7e6d             jle 0x14ad
  041530  1440: 837eea00         cmp word ptr [bp - 0x16], 0
  041534  1444: 7467             je 0x14ad
  041536  1446: 8d4702           lea ax, [bx + 2]
  041539  1449: 1e               push ds
  04153A  144A: 50               push ax
  04153B  144B: 6a00             push 0
  04153D  144D: 9a16041f18       lcall 0x181f, 0x416
  041542  1452: 83c406           add sp, 6
  041545  1455: ffb4c097         push word ptr [si - 0x6840]
  041549  1459: 6a01             push 1
  04154B  145B: 9a38041f18       lcall 0x181f, 0x438
  041550  1460: 83c404           add sp, 4
  041553  1463: 8b1e4285         mov bx, word ptr [0x8542]
  041557  1467: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  04155B  146B: 99               cdq 
  04155C  146C: 52               push dx
  04155D  146D: 50               push ax
  04155E  146E: 6a00             push 0
  041560  1470: 9aae091f18       lcall 0x181f, 0x9ae
  041565  1475: 83c406           add sp, 6
  041568  1478: 8b46f8           mov ax, word ptr [bp - 8]
  04156B  147B: 99               cdq 
  04156C  147C: 52               push dx
  04156D  147D: 50               push ax
  04156E  147E: 6a01             push 1
  041570  1480: 9aae091f18       lcall 0x181f, 0x9ae
  041575  1485: 83c406           add sp, 6
  041578  1488: 8b46f4           mov ax, word ptr [bp - 0xc]
  04157B  148B: 99               cdq 
  04157C  148C: 52               push dx
  04157D  148D: 50               push ax
  04157E  148E: 6a02             push 2
  041580  1490: 9aae091f18       lcall 0x181f, 0x9ae
  041585  1495: 83c406           add sp, 6
  041588  1498: 6a05             push 5
  04158A  149A: 688014           push 0x1480
  04158D  149D: 9a52061f18       lcall 0x181f, 0x652
  041592  14A2: 83c404           add sp, 4
  041595  14A5: 3d0200           cmp ax, 2
  041598  14A8: 7403             je 0x14ad
  04159A  14AA: e9b000           jmp 0x155d
  04159D  14AD: 837e0800         cmp word ptr [bp + 8], 0
  0415A1  14B1: 7431             je 0x14e4
  0415A3  14B3: ff76ea           push word ptr [bp - 0x16]
  0415A6  14B6: 9ad80c1f19       lcall 0x191f, 0xcd8
  0415AB  14BB: 83c402           add sp, 2
  0415AE  14BE: 0bc0             or ax, ax
  0415B0  14C0: 7412             je 0x14d4
  0415B2  14C2: ff76ea           push word ptr [bp - 0x16]
  0415B5  14C5: 9a060c1f19       lcall 0x191f, 0xc06
  0415BA  14CA: 83c402           add sp, 2
  0415BD  14CD: 0bc0             or ax, ax
  0415BF  14CF: 7503             jne 0x14d4
  0415C1  14D1: e98900           jmp 0x155d
  0415C4  14D4: 6a00             push 0
  0415C6  14D6: ff76ea           push word ptr [bp - 0x16]
  0415C9  14D9: ff7606           push word ptr [bp + 6]
  0415CC  14DC: 9a020d1f19       lcall 0x191f, 0xd02
  0415D1  14E1: eb72             jmp 0x1555
  0415D3  14E3: 90               nop 
  0415D4  14E4: ff76ec           push word ptr [bp - 0x14]
  0415D7  14E7: ff7606           push word ptr [bp + 6]
  0415DA  14EA: 9aec0a1f18       lcall 0x181f, 0xaec
  0415DF  14EF: 83c404           add sp, 4
  0415E2  14F2: 8946ea           mov word ptr [bp - 0x16], ax
  0415E5  14F5: a1c48d           mov ax, word ptr [0x8dc4]
  0415E8  14F8: 8b76ea           mov si, word ptr [bp - 0x16]
  0415EB  14FB: d1e6             shl si, 1
  0415ED  14FD: 8b1e4285         mov bx, word ptr [0x8542]
  0415F1  1501: 01809a00         add word ptr [bx + si + 0x9a], ax
  0415F5  1505: 6a01             push 1
  0415F7  1507: 9a56001f18       lcall 0x181f, 0x56
  0415FC  150C: 83c402           add sp, 2
  0415FF  150F: 6a18             push 0x18
  041601  1511: 9ad60d1f18       lcall 0x181f, 0xdd6
  041606  1516: 83c402           add sp, 2
  041609  1519: ff36c48d         push word ptr [0x8dc4]
  04160D  151D: 9a7e001f18       lcall 0x181f, 0x7e
  041612  1522: 83c402           add sp, 2
  041615  1525: ffb4c097         push word ptr [si - 0x6840]
  041619  1529: 9a74001f18       lcall 0x181f, 0x74
  04161E  152E: 83c402           add sp, 2
  041621  1531: 6a1a             push 0x1a
  041623  1533: 9ad60d1f18       lcall 0x181f, 0xdd6
  041628  1538: 83c402           add sp, 2
  04162B  153B: a14285           mov ax, word ptr [0x8542]
  04162E  153E: 40               inc ax
  04162F  153F: 40               inc ax
  041630  1540: 1e               push ds
  041631  1541: 50               push ax
  041632  1542: 9a6a001f18       lcall 0x181f, 0x6a
  041637  1547: 83c404           add sp, 4
  04163A  154A: 6a00             push 0
  04163C  154C: 6a78             push 0x78
  04163E  154E: 6a01             push 1
  041640  1550: 9ac20d1f18       lcall 0x181f, 0xdc2
  041645  1555: 83c406           add sp, 6
  041648  1558: c746f60000       mov word ptr [bp - 0xa], 0
  04164D  155D: 8b46f6           mov ax, word ptr [bp - 0xa]
  041650  1560: 5e               pop si
  041651  1561: c9               leave 
  041652  1562: cb               retf 

; ---- func_041654  size=598  insns=200  prologue=ENTER 0x003E,0  terminal=RETF ----
  041654  1564: c83e0000         enter 0x3e, 0
  041658  1568: 56               push si
  041659  1569: c746ee0100       mov word ptr [bp - 0x12], 1
  04165E  156E: c746e6ffff       mov word ptr [bp - 0x1a], 0xffff
  041663  1573: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041667  1577: 8bc3             mov ax, bx
  041669  1579: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04166D  157D: 8bf0             mov si, ax
  04166F  157F: 8a845031         mov al, byte ptr [si + 0x3150]
  041673  1583: 2ae4             sub ah, ah
  041675  1585: 2aff             sub bh, bh
  041677  1587: 8bcb             mov cx, bx
  041679  1589: d1e3             shl bx, 1
  04167B  158B: 03d9             add bx, cx
  04167D  158D: d1e3             shl bx, 1
  04167F  158F: 03d9             add bx, cx
  041681  1591: d1e3             shl bx, 1
  041683  1593: 8a8f3752         mov cl, byte ptr [bx + 0x5237]
  041687  1597: 2aed             sub ch, ch
  041689  1599: 2bc8             sub cx, ax
  04168B  159B: 894ec2           mov word ptr [bp - 0x3e], cx
  04168E  159E: 83f901           cmp cx, 1
  041691  15A1: 7d13             jge 0x15b6
  041693  15A3: 6a03             push 3
  041695  15A5: 6a15             push 0x15
  041697  15A7: 9ae00d1f18       lcall 0x181f, 0xde0
  04169C  15AC: 83c404           add sp, 4
  04169F  15AF: 8b46ee           mov ax, word ptr [bp - 0x12]
  0416A2  15B2: 5e               pop si
  0416A3  15B3: c9               leave 
  0416A4  15B4: cb               retf 
  0416A5  15B5: 90               nop 
  0416A6  15B6: c746e80000       mov word ptr [bp - 0x18], 0
  0416AB  15BB: 8a46e8           mov al, byte ptr [bp - 0x18]
  0416AE  15BE: 8b76e8           mov si, word ptr [bp - 0x18]
  0416B1  15C1: 8842f0           mov byte ptr [bp + si - 0x10], al
  0416B4  15C4: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0416B8  15C8: 8a9f4731         mov bl, byte ptr [bx + 0x3147]
  0416BC  15CC: 83e30f           and bx, 0xf
  0416BF  15CF: c1e304           shl bx, 4
  0416C2  15D2: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  0416C6  15D6: 2ae4             sub ah, ah
  0416C8  15D8: c1e004           shl ax, 4
  0416CB  15DB: 8946ea           mov word ptr [bp - 0x16], ax
  0416CE  15DE: 83fe0f           cmp si, 0xf
  0416D1  15E1: 7505             jne 0x15e8
  0416D3  15E3: c746ea0100       mov word ptr [bp - 0x16], 1
  0416D8  15E8: 837ee80e         cmp word ptr [bp - 0x18], 0xe
  0416DC  15EC: 7505             jne 0x15f3
  0416DE  15EE: c746ea0100       mov word ptr [bp - 0x16], 1
  0416E3  15F3: 837ee808         cmp word ptr [bp - 0x18], 8
  0416E7  15F7: 7515             jne 0x160e
  0416E9  15F9: 8b76e8           mov si, word ptr [bp - 0x18]
  0416EC  15FC: d1e6             shl si, 1
  0416EE  15FE: 8b1e4285         mov bx, word ptr [0x8542]
  0416F2  1602: 83b89a0066       cmp word ptr [bx + si + 0x9a], 0x66
  0416F7  1607: 7d05             jge 0x160e
  0416F9  1609: c746ea0000       mov word ptr [bp - 0x16], 0
  0416FE  160E: 8b76e8           mov si, word ptr [bp - 0x18]
  041701  1611: d1e6             shl si, 1
  041703  1613: 8b1e4285         mov bx, word ptr [0x8542]
  041707  1617: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  04170B  161B: 3d6400           cmp ax, 0x64
  04170E  161E: 7e03             jle 0x1623
  041710  1620: b86400           mov ax, 0x64
  041713  1623: f76eea           imul word ptr [bp - 0x16]
  041716  1626: 8942c4           mov word ptr [bp + si - 0x3c], ax
  041719  1629: ff46e8           inc word ptr [bp - 0x18]
  04171C  162C: 837ee810         cmp word ptr [bp - 0x18], 0x10
  041720  1630: 7c89             jl 0x15bb
  041722  1632: 8d46f0           lea ax, [bp - 0x10]
  041725  1635: 16               push ss
  041726  1636: 50               push ax
  041727  1637: 8d46c4           lea ax, [bp - 0x3c]
  04172A  163A: 16               push ss
  04172B  163B: 50               push ax
  04172C  163C: b81000           mov ax, 0x10
  04172F  163F: 9ad00e1f19       lcall 0x191f, 0xed0
  041734  1644: c746e80f00       mov word ptr [bp - 0x18], 0xf
  041739  1649: eb2a             jmp 0x1675
  04173B  164B: 90               nop 
  04173C  164C: 837ee800         cmp word ptr [bp - 0x18], 0
  041740  1650: 7c29             jl 0x167b
  041742  1652: 8b76e8           mov si, word ptr [bp - 0x18]
  041745  1655: 8a42f0           mov al, byte ptr [bp + si - 0x10]
  041748  1658: 2ae4             sub ah, ah
  04174A  165A: 8bf0             mov si, ax
  04174C  165C: 8976e4           mov word ptr [bp - 0x1c], si
  04174F  165F: d1e6             shl si, 1
  041751  1661: 8b1e4285         mov bx, word ptr [0x8542]
  041755  1665: 83b89a0000       cmp word ptr [bx + si + 0x9a], 0
  04175A  166A: 7e06             jle 0x1672
  04175C  166C: 8b46e4           mov ax, word ptr [bp - 0x1c]
  04175F  166F: 8946e6           mov word ptr [bp - 0x1a], ax
  041762  1672: ff4ee8           dec word ptr [bp - 0x18]
  041765  1675: 837ee600         cmp word ptr [bp - 0x1a], 0
  041769  1679: 7cd1             jl 0x164c
  04176B  167B: 837ee600         cmp word ptr [bp - 0x1a], 0
  04176F  167F: 7d07             jge 0x1688
  041771  1681: 6a03             push 3
  041773  1683: 6a14             push 0x14
  041775  1685: e91fff           jmp 0x15a7
  041778  1688: 8b76e6           mov si, word ptr [bp - 0x1a]
  04177B  168B: 8976e4           mov word ptr [bp - 0x1c], si
  04177E  168E: d1e6             shl si, 1
  041780  1690: 8b1e4285         mov bx, word ptr [0x8542]
  041784  1694: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  041788  1698: 3d6400           cmp ax, 0x64
  04178B  169B: 7e03             jle 0x16a0
  04178D  169D: b86400           mov ax, 0x64
  041790  16A0: 8946ec           mov word ptr [bp - 0x14], ax
  041793  16A3: 29809a00         sub word ptr [bx + si + 0x9a], ax
  041797  16A7: ff76ec           push word ptr [bp - 0x14]
  04179A  16AA: ff76e4           push word ptr [bp - 0x1c]
  04179D  16AD: ff7606           push word ptr [bp + 6]
  0417A0  16B0: 9a580d1f18       lcall 0x181f, 0xd58
  0417A5  16B5: 83c406           add sp, 6
  0417A8  16B8: 6a01             push 1
  0417AA  16BA: 9a56001f18       lcall 0x181f, 0x56
  0417AF  16BF: 83c402           add sp, 2
  0417B2  16C2: 6a17             push 0x17
  0417B4  16C4: 9ad60d1f18       lcall 0x181f, 0xdd6
  0417B9  16C9: 83c402           add sp, 2
  0417BC  16CC: ff76ec           push word ptr [bp - 0x14]
  0417BF  16CF: 9a7e001f18       lcall 0x181f, 0x7e
  0417C4  16D4: 83c402           add sp, 2
  0417C7  16D7: ffb4c097         push word ptr [si - 0x6840]
  0417CB  16DB: 9a74001f18       lcall 0x181f, 0x74
  0417D0  16E0: 83c402           add sp, 2
  0417D3  16E3: 6a19             push 0x19
  0417D5  16E5: 9ad60d1f18       lcall 0x181f, 0xdd6
  0417DA  16EA: 83c402           add sp, 2
  0417DD  16ED: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0417E1  16F1: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0417E5  16F5: 2aff             sub bh, bh
  0417E7  16F7: 8bc3             mov ax, bx
  0417E9  16F9: d1e3             shl bx, 1
  0417EB  16FB: 03d8             add bx, ax
  0417ED  16FD: d1e3             shl bx, 1
  0417EF  16FF: 03d8             add bx, ax
  0417F1  1701: d1e3             shl bx, 1
  0417F3  1703: ffb73052         push word ptr [bx + 0x5230]
  0417F7  1707: 9a74001f18       lcall 0x181f, 0x74
  0417FC  170C: 83c402           add sp, 2
  0417FF  170F: 6a00             push 0
  041801  1711: 6a78             push 0x78
  041803  1713: 6a01             push 1
  041805  1715: 9ac20d1f18       lcall 0x181f, 0xdc2
  04180A  171A: 83c406           add sp, 6
  04180D  171D: c746ee0000       mov word ptr [bp - 0x12], 0
  041812  1722: 8b46ee           mov ax, word ptr [bp - 0x12]
  041815  1725: 5e               pop si
  041816  1726: c9               leave 
  041817  1727: cb               retf 
  041818  1728: eaba041f19       ljmp 0x191f:0x4ba
  04181D  172D: ead8011f1a       ljmp 0x1a1f:0x1d8
  041822  1732: eae6011f1a       ljmp 0x1a1f:0x1e6
  041827  1737: eaf4011f1a       ljmp 0x1a1f:0x1f4
  04182C  173C: ea02021f1a       ljmp 0x1a1f:0x202
  041831  1741: 00c8             add al, cl
  041833  1743: 0800             or byte ptr [bx + si], al
  041835  1745: 00ff             add bh, bh
  041837  1747: 36a6             cmpsb byte ptr ss:[si], byte ptr es:[di]
  041839  1749: 839aca041f       sbb word ptr [bp + si + 0x4ca], 0x1f
  04183E  174E: 1883c402         sbb byte ptr [bp + di + 0x2c4], al
  041842  1752: 6a64             push 0x64
  041844  1754: 6a01             push 1
  041846  1756: 9ad4041f18       lcall 0x181f, 0x4d4
  04184B  175B: 83c404           add sp, 4
  04184E  175E: 8946fe           mov word ptr [bp - 2], ax
  041851  1761: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041855  1765: 8a874731         mov al, byte ptr [bx + 0x3147]
  041859  1769: 250f00           and ax, 0xf
  04185C  176C: 8946fa           mov word ptr [bp - 6], ax
  04185F  176F: 837efe5a         cmp word ptr [bp - 2], 0x5a
  041863  1773: 7c18             jl 0x178d
  041865  1775: 8bd8             mov bx, ax
  041867  1777: 80bf189403       cmp byte ptr [bx - 0x6be8], 3
  04186C  177C: 720f             jb 0x178d
  04186E  177E: 6a05             push 5
  041870  1780: 50               push ax
  041871  1781: 9ab4071f18       lcall 0x181f, 0x7b4
  041876  1786: 83c404           add sp, 4
  041879  1789: 0bc0             or ax, ax
  04187B  178B: 7407             je 0x1794
  04187D  178D: c746fc0100       mov word ptr [bp - 4], 1
  041882  1792: eb05             jmp 0x1799
  041884  1794: c746fc0200       mov word ptr [bp - 4], 2
  041889  1799: 837e0802         cmp word ptr [bp + 8], 2
  04188D  179D: 7f16             jg 0x17b5
  04188F  179F: 6a01             push 1
  041891  17A1: 6a00             push 0
  041893  17A3: 9ad4041f18       lcall 0x181f, 0x4d4
  041898  17A8: 83c404           add sp, 4
  04189B  17AB: 6a05             push 5
  04189D  17AD: ff76fa           push word ptr [bp - 6]
  0418A0  17B0: 9ab4071f18       lcall 0x181f, 0x7b4
  0418A5  17B5: 8b46fc           mov ax, word ptr [bp - 4]
  0418A8  17B8: c9               leave 
  0418A9  17B9: cb               retf 

; ---- func_0418AA  size=227  insns=70  prologue=ENTER 0x0008,0  terminal=RETF ----
  0418AA  17BA: c8080000         enter 8, 0
  0418AE  17BE: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  0418B3  17C3: 8a874431         mov al, byte ptr [bx + 0x3144]
  0418B7  17C7: 2ae4             sub ah, ah
  0418B9  17C9: 8946fe           mov word ptr [bp - 2], ax
  0418BC  17CC: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  0418C0  17D0: 2aed             sub ch, ch
  0418C2  17D2: 894efa           mov word ptr [bp - 6], cx
  0418C5  17D5: 8a974731         mov dl, byte ptr [bx + 0x3147]
  0418C9  17D9: 83e20f           and dx, 0xf
  0418CC  17DC: 69da3c01         imul bx, dx, 0x13c
  0418D0  17E0: 88873a88         mov byte ptr [bx - 0x77c6], al
  0418D4  17E4: 888f3b88         mov byte ptr [bx - 0x77c5], cl
  0418D8  17E8: ff369253         push word ptr [0x5392]
  0418DC  17EC: 9a16091f18       lcall 0x181f, 0x916
  0418E1  17F1: 83c402           add sp, 2
  0418E4  17F4: ff76fa           push word ptr [bp - 6]
  0418E7  17F7: ff76fe           push word ptr [bp - 2]
  0418EA  17FA: ff369253         push word ptr [0x5392]
  0418EE  17FE: 0e               push cs
  0418EF  17FF: e81a08           call 0x201c
  0418F2  1802: 83c406           add sp, 6
  0418F5  1805: 8946fc           mov word ptr [bp - 4], ax
  0418F8  1808: a19253           mov ax, word ptr [0x5392]
  0418FB  180B: 9aee021f18       lcall 0x181f, 0x2ee
  041900  1810: eb2a             jmp 0x183c
  041902  1812: 6b5ef81c         imul bx, word ptr [bp - 8], 0x1c
  041906  1816: c6874c3101       mov byte ptr [bx + 0x314c], 1
  04190B  181B: 8a46fe           mov al, byte ptr [bp - 2]
  04190E  181E: 6b5ef81c         imul bx, word ptr [bp - 8], 0x1c
  041912  1822: 88874d31         mov byte ptr [bx + 0x314d], al
  041916  1826: 8a46fa           mov al, byte ptr [bp - 6]
  041919  1829: 88874e31         mov byte ptr [bx + 0x314e], al
  04191D  182D: 8a46fc           mov al, byte ptr [bp - 4]
  041920  1830: 88875a31         mov byte ptr [bx + 0x315a], al
  041924  1834: 8b46f8           mov ax, word ptr [bp - 8]
  041927  1837: 9ae4021f18       lcall 0x181f, 0x2e4
  04192C  183C: 8946f8           mov word ptr [bp - 8], ax
  04192F  183F: 0bc0             or ax, ax
  041931  1841: 7c1b             jl 0x185e
  041933  1843: a19253           mov ax, word ptr [0x5392]
  041936  1846: 3946f8           cmp word ptr [bp - 8], ax
  041939  1849: 75c7             jne 0x1812
  04193B  184B: 6b5ef81c         imul bx, word ptr [bp - 8], 0x1c
  04193F  184F: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  041944  1854: 74c5             je 0x181b
  041946  1856: c6874c3100       mov byte ptr [bx + 0x314c], 0
  04194B  185B: ebbe             jmp 0x181b
  04194D  185D: 90               nop 
  04194E  185E: ff369253         push word ptr [0x5392]
  041952  1862: 9ada081f18       lcall 0x181f, 0x8da
  041957  1867: 83c402           add sp, 2
  04195A  186A: a19453           mov ax, word ptr [0x5394]
  04195D  186D: 2d0c00           sub ax, 0xc
  041960  1870: 50               push ax
  041961  1871: 50               push ax
  041962  1872: ff369253         push word ptr [0x5392]
  041966  1876: 9a48091f18       lcall 0x181f, 0x948
  04196B  187B: 83c406           add sp, 6
  04196E  187E: ff369253         push word ptr [0x5392]
  041972  1882: 9a4e081f18       lcall 0x181f, 0x84e
  041977  1887: 83c402           add sp, 2
  04197A  188A: 6a01             push 1
  04197C  188C: 6a01             push 1
  04197E  188E: 6a01             push 1
  041980  1890: ff76fa           push word ptr [bp - 6]
  041983  1893: ff76fe           push word ptr [bp - 2]
  041986  1896: 9aba091f18       lcall 0x181f, 0x9ba
  04198B  189B: c9               leave 
  04198C  189C: cb               retf 

; ---- func_04198E  size=487  insns=162  prologue=ENTER 0x0014,0  terminal=RETF ----
  04198E  189E: c8140000         enter 0x14, 0
  041992  18A2: 56               push si
  041993  18A3: c746ee0000       mov word ptr [bp - 0x12], 0
  041998  18A8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04199C  18AC: 8a874431         mov al, byte ptr [bx + 0x3144]
  0419A0  18B0: 2ae4             sub ah, ah
  0419A2  18B2: 8946fc           mov word ptr [bp - 4], ax
  0419A5  18B5: 8a874531         mov al, byte ptr [bx + 0x3145]
  0419A9  18B9: 8946fa           mov word ptr [bp - 6], ax
  0419AC  18BC: 8a874731         mov al, byte ptr [bx + 0x3147]
  0419B0  18C0: 250f00           and ax, 0xf
  0419B3  18C3: 8946ec           mov word ptr [bp - 0x14], ax
  0419B6  18C6: c746fe0100       mov word ptr [bp - 2], 1
  0419BB  18CB: e94001           jmp 0x1a0e
  0419BE  18CE: 8b46fe           mov ax, word ptr [bp - 2]
  0419C1  18D1: d1e0             shl ax, 1
  0419C3  18D3: 0146f0           add word ptr [bp - 0x10], ax
  0419C6  18D6: 837eee00         cmp word ptr [bp - 0x12], 0
  0419CA  18DA: 7548             jne 0x1924
  0419CC  18DC: 8b46fe           mov ax, word ptr [bp - 2]
  0419CF  18DF: 0346fa           add ax, word ptr [bp - 6]
  0419D2  18E2: 3b46f0           cmp ax, word ptr [bp - 0x10]
  0419D5  18E5: 7c3d             jl 0x1924
  0419D7  18E7: ff76f0           push word ptr [bp - 0x10]
  0419DA  18EA: ff76f2           push word ptr [bp - 0xe]
  0419DD  18ED: 9a8c071f18       lcall 0x181f, 0x78c
  0419E2  18F2: 83c404           add sp, 4
  0419E5  18F5: 3d1a00           cmp ax, 0x1a
  0419E8  18F8: 75d4             jne 0x18ce
  0419EA  18FA: ff76f0           push word ptr [bp - 0x10]
  0419ED  18FD: ff76f2           push word ptr [bp - 0xe]
  0419F0  1900: 9a82061f18       lcall 0x181f, 0x682
  0419F5  1905: 83c404           add sp, 4
  0419F8  1908: 0bc0             or ax, ax
  0419FA  190A: 7c05             jl 0x1911
  0419FC  190C: 3b46ec           cmp ax, word ptr [bp - 0x14]
  0419FF  190F: 75bd             jne 0x18ce
  041A01  1911: c746ee0100       mov word ptr [bp - 0x12], 1
  041A06  1916: 8b46f2           mov ax, word ptr [bp - 0xe]
  041A09  1919: 8946f8           mov word ptr [bp - 8], ax
  041A0C  191C: 8b46f0           mov ax, word ptr [bp - 0x10]
  041A0F  191F: 8946f6           mov word ptr [bp - 0xa], ax
  041A12  1922: ebaa             jmp 0x18ce
  041A14  1924: ff46f2           inc word ptr [bp - 0xe]
  041A17  1927: 837eee00         cmp word ptr [bp - 0x12], 0
  041A1B  192B: 7517             jne 0x1944
  041A1D  192D: 8b46fe           mov ax, word ptr [bp - 2]
  041A20  1930: 0346fc           add ax, word ptr [bp - 4]
  041A23  1933: 3b46f2           cmp ax, word ptr [bp - 0xe]
  041A26  1936: 7e0c             jle 0x1944
  041A28  1938: 8b46fa           mov ax, word ptr [bp - 6]
  041A2B  193B: 2b46fe           sub ax, word ptr [bp - 2]
  041A2E  193E: 8946f0           mov word ptr [bp - 0x10], ax
  041A31  1941: eb93             jmp 0x18d6
  041A33  1943: 90               nop 
  041A34  1944: 8b46fe           mov ax, word ptr [bp - 2]
  041A37  1947: 0346fc           add ax, word ptr [bp - 4]
  041A3A  194A: 8946f2           mov word ptr [bp - 0xe], ax
  041A3D  194D: 8b46fa           mov ax, word ptr [bp - 6]
  041A40  1950: 2b46fe           sub ax, word ptr [bp - 2]
  041A43  1953: 8946f0           mov word ptr [bp - 0x10], ax
  041A46  1956: eb49             jmp 0x19a1
  041A48  1958: 8b46fe           mov ax, word ptr [bp - 2]
  041A4B  195B: 0346fa           add ax, word ptr [bp - 6]
  041A4E  195E: 3b46f0           cmp ax, word ptr [bp - 0x10]
  041A51  1961: 7c44             jl 0x19a7
  041A53  1963: ff76f0           push word ptr [bp - 0x10]
  041A56  1966: ff76f2           push word ptr [bp - 0xe]
  041A59  1969: 9a8c071f18       lcall 0x181f, 0x78c
  041A5E  196E: 83c404           add sp, 4
  041A61  1971: 3d1a00           cmp ax, 0x1a
  041A64  1974: 7528             jne 0x199e
  041A66  1976: ff76f0           push word ptr [bp - 0x10]
  041A69  1979: ff76f2           push word ptr [bp - 0xe]
  041A6C  197C: 9a82061f18       lcall 0x181f, 0x682
  041A71  1981: 83c404           add sp, 4
  041A74  1984: 0bc0             or ax, ax
  041A76  1986: 7c05             jl 0x198d
  041A78  1988: 3b46ec           cmp ax, word ptr [bp - 0x14]
  041A7B  198B: 7511             jne 0x199e
  041A7D  198D: c746ee0100       mov word ptr [bp - 0x12], 1
  041A82  1992: 8b46f2           mov ax, word ptr [bp - 0xe]
  041A85  1995: 8946f8           mov word ptr [bp - 8], ax
  041A88  1998: 8b46f0           mov ax, word ptr [bp - 0x10]
  041A8B  199B: 8946f6           mov word ptr [bp - 0xa], ax
  041A8E  199E: ff46f0           inc word ptr [bp - 0x10]
  041A91  19A1: 837eee00         cmp word ptr [bp - 0x12], 0
  041A95  19A5: 74b1             je 0x1958
  041A97  19A7: 8b46fc           mov ax, word ptr [bp - 4]
  041A9A  19AA: 2b46fe           sub ax, word ptr [bp - 2]
  041A9D  19AD: 8946f2           mov word ptr [bp - 0xe], ax
  041AA0  19B0: 8b46fa           mov ax, word ptr [bp - 6]
  041AA3  19B3: 2b46fe           sub ax, word ptr [bp - 2]
  041AA6  19B6: 8946f0           mov word ptr [bp - 0x10], ax
  041AA9  19B9: eb4a             jmp 0x1a05
  041AAB  19BB: 90               nop 
  041AAC  19BC: 8b46fe           mov ax, word ptr [bp - 2]
  041AAF  19BF: 0346fa           add ax, word ptr [bp - 6]
  041AB2  19C2: 3b46f0           cmp ax, word ptr [bp - 0x10]
  041AB5  19C5: 7c44             jl 0x1a0b
  041AB7  19C7: ff76f0           push word ptr [bp - 0x10]
  041ABA  19CA: ff76f2           push word ptr [bp - 0xe]
  041ABD  19CD: 9a8c071f18       lcall 0x181f, 0x78c
  041AC2  19D2: 83c404           add sp, 4
  041AC5  19D5: 3d1a00           cmp ax, 0x1a
  041AC8  19D8: 7528             jne 0x1a02
  041ACA  19DA: ff76f0           push word ptr [bp - 0x10]
  041ACD  19DD: ff76f2           push word ptr [bp - 0xe]
  041AD0  19E0: 9a82061f18       lcall 0x181f, 0x682
  041AD5  19E5: 83c404           add sp, 4
  041AD8  19E8: 0bc0             or ax, ax
  041ADA  19EA: 7c05             jl 0x19f1
  041ADC  19EC: 3b46ec           cmp ax, word ptr [bp - 0x14]
  041ADF  19EF: 7511             jne 0x1a02
  041AE1  19F1: c746ee0100       mov word ptr [bp - 0x12], 1
  041AE6  19F6: 8b46f2           mov ax, word ptr [bp - 0xe]
  041AE9  19F9: 8946f8           mov word ptr [bp - 8], ax
  041AEC  19FC: 8b46f0           mov ax, word ptr [bp - 0x10]
  041AEF  19FF: 8946f6           mov word ptr [bp - 0xa], ax
  041AF2  1A02: ff46f0           inc word ptr [bp - 0x10]
  041AF5  1A05: 837eee00         cmp word ptr [bp - 0x12], 0
  041AF9  1A09: 74b1             je 0x19bc
  041AFB  1A0B: ff46fe           inc word ptr [bp - 2]
  041AFE  1A0E: 837eee00         cmp word ptr [bp - 0x12], 0
  041B02  1A12: 7514             jne 0x1a28
  041B04  1A14: 8b46fe           mov ax, word ptr [bp - 2]
  041B07  1A17: 39063a85         cmp word ptr [0x853a], ax
  041B0B  1A1B: 7e0b             jle 0x1a28
  041B0D  1A1D: 2b46fc           sub ax, word ptr [bp - 4]
  041B10  1A20: f7d8             neg ax
  041B12  1A22: 8946f2           mov word ptr [bp - 0xe], ax
  041B15  1A25: e9fffe           jmp 0x1927
  041B18  1A28: 837eee00         cmp word ptr [bp - 0x12], 0
  041B1C  1A2C: 7454             je 0x1a82
  041B1E  1A2E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041B22  1A32: 8bc3             mov ax, bx
  041B24  1A34: 8a9f4731         mov bl, byte ptr [bx + 0x3147]
  041B28  1A38: 80e30f           and bl, 0xf
  041B2B  1A3B: 8bcb             mov cx, bx
  041B2D  1A3D: 2aff             sub bh, bh
  041B2F  1A3F: fe875694         inc byte ptr [bx - 0x6baa]
  041B33  1A43: 8bf0             mov si, ax
  041B35  1A45: 80bc4c3102       cmp byte ptr [si + 0x314c], 2
  041B3A  1A4A: 741f             je 0x1a6b
  041B3C  1A4C: 80f904           cmp cl, 4
  041B3F  1A4F: 7311             jae 0x1a62
  041B41  1A51: 6bdb34           imul bx, bx, 0x34
  041B44  1A54: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  041B49  1A59: 7507             jne 0x1a62
  041B4B  1A5B: c6844c3103       mov byte ptr [si + 0x314c], 3
  041B50  1A60: eb09             jmp 0x1a6b
  041B52  1A62: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041B56  1A66: c6874c310b       mov byte ptr [bx + 0x314c], 0xb
  041B5B  1A6B: 8a46f8           mov al, byte ptr [bp - 8]
  041B5E  1A6E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041B62  1A72: 88874d31         mov byte ptr [bx + 0x314d], al
  041B66  1A76: 8a46f6           mov al, byte ptr [bp - 0xa]
  041B69  1A79: 88874e31         mov byte ptr [bx + 0x314e], al
  041B6D  1A7D: c6874b3145       mov byte ptr [bx + 0x314b], 0x45
  041B72  1A82: 5e               pop si
  041B73  1A83: c9               leave 
  041B74  1A84: cb               retf 

; ---- func_041B76  size=137  insns=45  prologue=ENTER 0x0004,0  terminal=RETF ----
  041B76  1A86: c8040000         enter 4, 0
  041B7A  1A8A: ff7606           push word ptr [bp + 6]
  041B7D  1A8D: 9a20091f18       lcall 0x181f, 0x920
  041B82  1A92: 83c402           add sp, 2
  041B85  1A95: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041B89  1A99: 8a874e31         mov al, byte ptr [bx + 0x314e]
  041B8D  1A9D: 2ae4             sub ah, ah
  041B8F  1A9F: 50               push ax
  041B90  1AA0: 8a874d31         mov al, byte ptr [bx + 0x314d]
  041B94  1AA4: 50               push ax
  041B95  1AA5: ff7606           push word ptr [bp + 6]
  041B98  1AA8: 0e               push cs
  041B99  1AA9: e87005           call 0x201c
  041B9C  1AAC: 83c406           add sp, 6
  041B9F  1AAF: 8946fc           mov word ptr [bp - 4], ax
  041BA2  1AB2: 8b4606           mov ax, word ptr [bp + 6]
  041BA5  1AB5: 9aee021f18       lcall 0x181f, 0x2ee
  041BAA  1ABA: eb32             jmp 0x1aee
  041BAC  1ABC: 6bd81c           imul bx, ax, 0x1c
  041BAF  1ABF: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  041BB4  1AC4: 7207             jb 0x1acd
  041BB6  1AC6: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  041BBB  1ACB: 760e             jbe 0x1adb
  041BBD  1ACD: 6bd81c           imul bx, ax, 0x1c
  041BC0  1AD0: 8a9f4731         mov bl, byte ptr [bx + 0x3147]
  041BC4  1AD4: 83e30f           and bx, 0xf
  041BC7  1AD7: fe8f5a94         dec byte ptr [bx - 0x6ba6]
  041BCB  1ADB: 8a46fc           mov al, byte ptr [bp - 4]
  041BCE  1ADE: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  041BD2  1AE2: 88875a31         mov byte ptr [bx + 0x315a], al
  041BD6  1AE6: 8b46fe           mov ax, word ptr [bp - 2]
  041BD9  1AE9: 9ae4021f18       lcall 0x181f, 0x2e4
  041BDE  1AEE: 8946fe           mov word ptr [bp - 2], ax
  041BE1  1AF1: 0bc0             or ax, ax
  041BE3  1AF3: 7dc7             jge 0x1abc
  041BE5  1AF5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041BE9  1AF9: 8a874731         mov al, byte ptr [bx + 0x3147]
  041BED  1AFD: 250f00           and ax, 0xf
  041BF0  1B00: 2d1800           sub ax, 0x18
  041BF3  1B03: 50               push ax
  041BF4  1B04: 50               push ax
  041BF5  1B05: ff7606           push word ptr [bp + 6]
  041BF8  1B08: 9a48091f18       lcall 0x181f, 0x948
  041BFD  1B0D: c9               leave 
  041BFE  1B0E: cb               retf 

; ---- func_041C00  size=100  insns=32  prologue=ENTER 0x0004,0  terminal=RETF ----
  041C00  1B10: c8040000         enter 4, 0
  041C04  1B14: 8b4606           mov ax, word ptr [bp + 6]
  041C07  1B17: 03069453         add ax, word ptr [0x5394]
  041C0B  1B1B: 8bd0             mov dx, ax
  041C0D  1B1D: 9ae0071f18       lcall 0x181f, 0x7e0
  041C12  1B22: eb47             jmp 0x1b6b
  041C14  1B24: 8b46fc           mov ax, word ptr [bp - 4]
  041C17  1B27: 9ae4021f18       lcall 0x181f, 0x2e4
  041C1C  1B2C: 8946fe           mov word ptr [bp - 2], ax
  041C1F  1B2F: 6b5efc1c         imul bx, word ptr [bp - 4], 0x1c
  041C23  1B33: 80bf5a3100       cmp byte ptr [bx + 0x315a], 0
  041C28  1B38: 7404             je 0x1b3e
  041C2A  1B3A: fe8f5a31         dec byte ptr [bx + 0x315a]
  041C2E  1B3E: 6b5efc1c         imul bx, word ptr [bp - 4], 0x1c
  041C32  1B42: 80bf5a3100       cmp byte ptr [bx + 0x315a], 0
  041C37  1B47: 751f             jne 0x1b68
  041C39  1B49: 8b4608           mov ax, word ptr [bp + 8]
  041C3C  1B4C: 03069453         add ax, word ptr [0x5394]
  041C40  1B50: 50               push ax
  041C41  1B51: 50               push ax
  041C42  1B52: ff76fc           push word ptr [bp - 4]
  041C45  1B55: 9a80081f18       lcall 0x181f, 0x880
  041C4A  1B5A: 83c406           add sp, 6
  041C4D  1B5D: ff76fc           push word ptr [bp - 4]
  041C50  1B60: 9ac6081f18       lcall 0x181f, 0x8c6
  041C55  1B65: 83c402           add sp, 2
  041C58  1B68: 8b46fe           mov ax, word ptr [bp - 2]
  041C5B  1B6B: 8946fc           mov word ptr [bp - 4], ax
  041C5E  1B6E: 0bc0             or ax, ax
  041C60  1B70: 7db2             jge 0x1b24
  041C62  1B72: c9               leave 
  041C63  1B73: cb               retf 

; ---- func_041C64  size=89  insns=29  prologue=ENTER 0x0004,0  terminal=RETF ----
  041C64  1B74: c8040000         enter 4, 0
  041C68  1B78: c746fc0000       mov word ptr [bp - 4], 0
  041C6D  1B7D: ff760a           push word ptr [bp + 0xa]
  041C70  1B80: ff7608           push word ptr [bp + 8]
  041C73  1B83: 9a02031f18       lcall 0x181f, 0x302
  041C78  1B88: 83c404           add sp, 4
  041C7B  1B8B: 0bc0             or ax, ax
  041C7D  1B8D: 7439             je 0x1bc8
  041C7F  1B8F: ff760a           push word ptr [bp + 0xa]
  041C82  1B92: ff7608           push word ptr [bp + 8]
  041C85  1B95: 9a8c071f18       lcall 0x181f, 0x78c
  041C8A  1B9A: 83c404           add sp, 4
  041C8D  1B9D: 3d1a00           cmp ax, 0x1a
  041C90  1BA0: 7526             jne 0x1bc8
  041C92  1BA2: ff760a           push word ptr [bp + 0xa]
  041C95  1BA5: ff7608           push word ptr [bp + 8]
  041C98  1BA8: 9a82061f18       lcall 0x181f, 0x682
  041C9D  1BAD: 83c404           add sp, 4
  041CA0  1BB0: 0bc0             or ax, ax
  041CA2  1BB2: 7c0f             jl 0x1bc3
  041CA4  1BB4: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041CA8  1BB8: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  041CAC  1BBC: 83e10f           and cx, 0xf
  041CAF  1BBF: 3bc8             cmp cx, ax
  041CB1  1BC1: 7505             jne 0x1bc8
  041CB3  1BC3: c746fc0100       mov word ptr [bp - 4], 1
  041CB8  1BC8: 8b46fc           mov ax, word ptr [bp - 4]
  041CBB  1BCB: c9               leave 
  041CBC  1BCC: cb               retf 

; ---- func_041CBE  size=448  insns=158  prologue=ENTER 0x001A,0  terminal=RETF ----
  041CBE  1BCE: c81a0000         enter 0x1a, 0
  041CC2  1BD2: 2bc0             sub ax, ax
  041CC4  1BD4: 8946ec           mov word ptr [bp - 0x14], ax
  041CC7  1BD7: 8946f4           mov word ptr [bp - 0xc], ax
  041CCA  1BDA: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041CCE  1BDE: 8a874d31         mov al, byte ptr [bx + 0x314d]
  041CD2  1BE2: 2ae4             sub ah, ah
  041CD4  1BE4: 8946f8           mov word ptr [bp - 8], ax
  041CD7  1BE7: 8946ea           mov word ptr [bp - 0x16], ax
  041CDA  1BEA: 8a874e31         mov al, byte ptr [bx + 0x314e]
  041CDE  1BEE: 8946f6           mov word ptr [bp - 0xa], ax
  041CE1  1BF1: 8946e8           mov word ptr [bp - 0x18], ax
  041CE4  1BF4: 8b46f8           mov ax, word ptr [bp - 8]
  041CE7  1BF7: 2b46f4           sub ax, word ptr [bp - 0xc]
  041CEA  1BFA: 8946fe           mov word ptr [bp - 2], ax
  041CED  1BFD: eb4e             jmp 0x1c4d
  041CEF  1BFF: 90               nop 
  041CF0  1C00: 8b46f4           mov ax, word ptr [bp - 0xc]
  041CF3  1C03: f7d0             not ax
  041CF5  1C05: 40               inc ax
  041CF6  1C06: eb02             jmp 0x1c0a
  041CF8  1C08: 2bc0             sub ax, ax
  041CFA  1C0A: 0346f6           add ax, word ptr [bp - 0xa]
  041CFD  1C0D: 8946fc           mov word ptr [bp - 4], ax
  041D00  1C10: 50               push ax
  041D01  1C11: ff76fe           push word ptr [bp - 2]
  041D04  1C14: ff7606           push word ptr [bp + 6]
  041D07  1C17: 0e               push cs
  041D08  1C18: e81004           call 0x202b
  041D0B  1C1B: 83c406           add sp, 6
  041D0E  1C1E: 0bc0             or ax, ax
  041D10  1C20: 7411             je 0x1c33
  041D12  1C22: c746ec0100       mov word ptr [bp - 0x14], 1
  041D17  1C27: 8b46fe           mov ax, word ptr [bp - 2]
  041D1A  1C2A: 8946ea           mov word ptr [bp - 0x16], ax
  041D1D  1C2D: 8b46fc           mov ax, word ptr [bp - 4]
  041D20  1C30: 8946e8           mov word ptr [bp - 0x18], ax
  041D23  1C33: 8346f002         add word ptr [bp - 0x10], 2
  041D27  1C37: 837ef001         cmp word ptr [bp - 0x10], 1
  041D2B  1C3B: 7f0d             jg 0x1c4a
  041D2D  1C3D: 837ef000         cmp word ptr [bp - 0x10], 0
  041D31  1C41: 74c5             je 0x1c08
  041D33  1C43: 7cbb             jl 0x1c00
  041D35  1C45: 8b46f4           mov ax, word ptr [bp - 0xc]
  041D38  1C48: ebc0             jmp 0x1c0a
  041D3A  1C4A: ff46fe           inc word ptr [bp - 2]
  041D3D  1C4D: 837eec00         cmp word ptr [bp - 0x14], 0
  041D41  1C51: 7513             jne 0x1c66
  041D43  1C53: 8b46f4           mov ax, word ptr [bp - 0xc]
  041D46  1C56: 0346f8           add ax, word ptr [bp - 8]
  041D49  1C59: 3b46fe           cmp ax, word ptr [bp - 2]
  041D4C  1C5C: 7c08             jl 0x1c66
  041D4E  1C5E: c746f0ffff       mov word ptr [bp - 0x10], 0xffff
  041D53  1C63: ebd2             jmp 0x1c37
  041D55  1C65: 90               nop 
  041D56  1C66: 8b46f6           mov ax, word ptr [bp - 0xa]
  041D59  1C69: 2b46f4           sub ax, word ptr [bp - 0xc]
  041D5C  1C6C: 8946fc           mov word ptr [bp - 4], ax
  041D5F  1C6F: eb4e             jmp 0x1cbf
  041D61  1C71: 90               nop 
  041D62  1C72: 8b46f4           mov ax, word ptr [bp - 0xc]
  041D65  1C75: f7d0             not ax
  041D67  1C77: 40               inc ax
  041D68  1C78: eb02             jmp 0x1c7c
  041D6A  1C7A: 2bc0             sub ax, ax
  041D6C  1C7C: 0346f8           add ax, word ptr [bp - 8]
  041D6F  1C7F: 8946fe           mov word ptr [bp - 2], ax
  041D72  1C82: ff76fc           push word ptr [bp - 4]
  041D75  1C85: 50               push ax
  041D76  1C86: ff7606           push word ptr [bp + 6]
  041D79  1C89: 0e               push cs
  041D7A  1C8A: e89e03           call 0x202b
  041D7D  1C8D: 83c406           add sp, 6
  041D80  1C90: 0bc0             or ax, ax
  041D82  1C92: 7411             je 0x1ca5
  041D84  1C94: c746ec0100       mov word ptr [bp - 0x14], 1
  041D89  1C99: 8b46fe           mov ax, word ptr [bp - 2]
  041D8C  1C9C: 8946ea           mov word ptr [bp - 0x16], ax
  041D8F  1C9F: 8b46fc           mov ax, word ptr [bp - 4]
  041D92  1CA2: 8946e8           mov word ptr [bp - 0x18], ax
  041D95  1CA5: 8346fa02         add word ptr [bp - 6], 2
  041D99  1CA9: 837efa01         cmp word ptr [bp - 6], 1
  041D9D  1CAD: 7f0d             jg 0x1cbc
  041D9F  1CAF: 837efa00         cmp word ptr [bp - 6], 0
  041DA3  1CB3: 74c5             je 0x1c7a
  041DA5  1CB5: 7cbb             jl 0x1c72
  041DA7  1CB7: 8b46f4           mov ax, word ptr [bp - 0xc]
  041DAA  1CBA: ebc0             jmp 0x1c7c
  041DAC  1CBC: ff46fc           inc word ptr [bp - 4]
  041DAF  1CBF: 837eec00         cmp word ptr [bp - 0x14], 0
  041DB3  1CC3: 7513             jne 0x1cd8
  041DB5  1CC5: 8b46f4           mov ax, word ptr [bp - 0xc]
  041DB8  1CC8: 0346f6           add ax, word ptr [bp - 0xa]
  041DBB  1CCB: 3b46fc           cmp ax, word ptr [bp - 4]
  041DBE  1CCE: 7c08             jl 0x1cd8
  041DC0  1CD0: c746faffff       mov word ptr [bp - 6], 0xffff
  041DC5  1CD5: ebd2             jmp 0x1ca9
  041DC7  1CD7: 90               nop 
  041DC8  1CD8: ff46f4           inc word ptr [bp - 0xc]
  041DCB  1CDB: 837eec00         cmp word ptr [bp - 0x14], 0
  041DCF  1CDF: 7514             jne 0x1cf5
  041DD1  1CE1: a13c85           mov ax, word ptr [0x853c]
  041DD4  1CE4: 3b063a85         cmp ax, word ptr [0x853a]
  041DD8  1CE8: 7d03             jge 0x1ced
  041DDA  1CEA: a13a85           mov ax, word ptr [0x853a]
  041DDD  1CED: 3b46f4           cmp ax, word ptr [bp - 0xc]
  041DE0  1CF0: 7e03             jle 0x1cf5
  041DE2  1CF2: e9fffe           jmp 0x1bf4
  041DE5  1CF5: 837eec00         cmp word ptr [bp - 0x14], 0
  041DE9  1CF9: 7514             jne 0x1d0f
  041DEB  1CFB: 8b46ea           mov ax, word ptr [bp - 0x16]
  041DEE  1CFE: 8b56e8           mov dx, word ptr [bp - 0x18]
  041DF1  1D01: 9ae0071f18       lcall 0x181f, 0x7e0
  041DF6  1D06: 50               push ax
  041DF7  1D07: 9a3a081f18       lcall 0x181f, 0x83a
  041DFC  1D0C: 83c402           add sp, 2
  041DFF  1D0F: ff7606           push word ptr [bp + 6]
  041E02  1D12: 9ada081f18       lcall 0x181f, 0x8da
  041E07  1D17: 83c402           add sp, 2
  041E0A  1D1A: ff76e8           push word ptr [bp - 0x18]
  041E0D  1D1D: ff76ea           push word ptr [bp - 0x16]
  041E10  1D20: ff7606           push word ptr [bp + 6]
  041E13  1D23: 9a48091f18       lcall 0x181f, 0x948
  041E18  1D28: 83c406           add sp, 6
  041E1B  1D2B: ff7606           push word ptr [bp + 6]
  041E1E  1D2E: 9a4e081f18       lcall 0x181f, 0x84e
  041E23  1D33: 83c402           add sp, 2
  041E26  1D36: 8b4606           mov ax, word ptr [bp + 6]
  041E29  1D39: 9aa0071f18       lcall 0x181f, 0x7a0
  041E2E  1D3E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  041E32  1D42: 8a874731         mov al, byte ptr [bx + 0x3147]
  041E36  1D46: 240f             and al, 0xf
  041E38  1D48: 3a069653         cmp al, byte ptr [0x5396]
  041E3C  1D4C: 753e             jne 0x1d8c
  041E3E  1D4E: 6a00             push 0
  041E40  1D50: ff76e8           push word ptr [bp - 0x18]
  041E43  1D53: ff76ea           push word ptr [bp - 0x16]
  041E46  1D56: ff76e8           push word ptr [bp - 0x18]
  041E49  1D59: ff76ea           push word ptr [bp - 0x16]
  041E4C  1D5C: 9a52031f18       lcall 0x181f, 0x352
  041E51  1D61: 83c40a           add sp, 0xa
  041E54  1D64: 0bc0             or ax, ax
  041E56  1D66: 751c             jne 0x1d84
  041E58  1D68: 6a01             push 1
  041E5A  1D6A: 6a07             push 7
  041E5C  1D6C: 6a07             push 7
  041E5E  1D6E: 8b46e8           mov ax, word ptr [bp - 0x18]
  041E61  1D71: 2d0300           sub ax, 3
  041E64  1D74: 50               push ax
  041E65  1D75: 8b46ea           mov ax, word ptr [bp - 0x16]
  041E68  1D78: 2d0300           sub ax, 3
  041E6B  1D7B: 50               push ax
  041E6C  1D7C: 9aba091f18       lcall 0x181f, 0x9ba
  041E71  1D81: 83c40a           add sp, 0xa
  041E74  1D84: ff7606           push word ptr [bp + 6]
  041E77  1D87: 9a120e1f18       lcall 0x181f, 0xe12
  041E7C  1D8C: c9               leave 
  041E7D  1D8D: cb               retf 

; ---- func_041E7E  size=108  insns=34  prologue=ENTER 0x0004,0  terminal=RETF ----
  041E7E  1D8E: c8040000         enter 4, 0
  041E82  1D92: c746fe0100       mov word ptr [bp - 2], 1
  041E87  1D97: 837efe00         cmp word ptr [bp - 2], 0
  041E8B  1D9B: 7410             je 0x1dad
  041E8D  1D9D: a19453           mov ax, word ptr [0x5394]
  041E90  1DA0: 2d2000           sub ax, 0x20
  041E93  1DA3: 8bd0             mov dx, ax
  041E95  1DA5: 9ae0071f18       lcall 0x181f, 0x7e0
  041E9A  1DAA: 8946fc           mov word ptr [bp - 4], ax
  041E9D  1DAD: 837efc00         cmp word ptr [bp - 4], 0
  041EA1  1DB1: 7c3f             jl 0x1df2
  041EA3  1DB3: 6b5efc1c         imul bx, word ptr [bp - 4], 0x1c
  041EA7  1DB7: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  041EAC  1DBC: 7224             jb 0x1de2
  041EAE  1DBE: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  041EB3  1DC3: 771d             ja 0x1de2
  041EB5  1DC5: ff76fc           push word ptr [bp - 4]
  041EB8  1DC8: 9a20091f18       lcall 0x181f, 0x920
  041EBD  1DCD: 83c402           add sp, 2
  041EC0  1DD0: ff76fc           push word ptr [bp - 4]
  041EC3  1DD3: 0e               push cs
  041EC4  1DD4: e85902           call 0x2030
  041EC7  1DD7: 83c402           add sp, 2
  041ECA  1DDA: c746fe0100       mov word ptr [bp - 2], 1
  041ECF  1DDF: eb11             jmp 0x1df2
  041ED1  1DE1: 90               nop 
  041ED2  1DE2: 8b46fc           mov ax, word ptr [bp - 4]
  041ED5  1DE5: 9ae4021f18       lcall 0x181f, 0x2e4
  041EDA  1DEA: 8946fc           mov word ptr [bp - 4], ax
  041EDD  1DED: c746fe0000       mov word ptr [bp - 2], 0
  041EE2  1DF2: 837efc00         cmp word ptr [bp - 4], 0
  041EE6  1DF6: 7d9f             jge 0x1d97
  041EE8  1DF8: c9               leave 
  041EE9  1DF9: cb               retf 

; ---- func_041EEA  size=589  insns=201  prologue=ENTER 0x0018,0  terminal=RET ----
  041EEA  1DFA: c8180000         enter 0x18, 0
  041EEE  1DFE: 57               push di
  041EEF  1DFF: 56               push si
  041EF0  1E00: c746feffff       mov word ptr [bp - 2], 0xffff
  041EF5  1E05: c746f80000       mov word ptr [bp - 8], 0
  041EFA  1E0A: 6ae0             push -0x20
  041EFC  1E0C: 6ae4             push -0x1c
  041EFE  1E0E: 0e               push cs
  041EFF  1E0F: e81402           call 0x2026
  041F02  1E12: 83c404           add sp, 4
  041F05  1E15: 6ae4             push -0x1c
  041F07  1E17: 6ae8             push -0x18
  041F09  1E19: 0e               push cs
  041F0A  1E1A: e80902           call 0x2026
  041F0D  1E1D: 83c404           add sp, 4
  041F10  1E20: a19453           mov ax, word ptr [0x5394]
  041F13  1E23: 2d1000           sub ax, 0x10
  041F16  1E26: 8bd0             mov dx, ax
  041F18  1E28: 9ae0071f18       lcall 0x181f, 0x7e0
  041F1D  1E2D: eb4f             jmp 0x1e7e
  041F1F  1E2F: 90               nop 
  041F20  1E30: 6bd81c           imul bx, ax, 0x1c
  041F23  1E33: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  041F28  1E38: 723c             jb 0x1e76
  041F2A  1E3A: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  041F2F  1E3F: 7735             ja 0x1e76
  041F31  1E41: 837efe00         cmp word ptr [bp - 2], 0
  041F35  1E45: 7d2f             jge 0x1e76
  041F37  1E47: a19653           mov ax, word ptr [0x5396]
  041F3A  1E4A: 39069453         cmp word ptr [0x5394], ax
  041F3E  1E4E: 7526             jne 0x1e76
  041F40  1E50: ff76f4           push word ptr [bp - 0xc]
  041F43  1E53: 8bf3             mov si, bx
  041F45  1E55: 9afe0d1f18       lcall 0x181f, 0xdfe
  041F4A  1E5A: 83c402           add sp, 2
  041F4D  1E5D: 80bc4c3102       cmp byte ptr [si + 0x314c], 2
  041F52  1E62: 7412             je 0x1e76
  041F54  1E64: 8b46f4           mov ax, word ptr [bp - 0xc]
  041F57  1E67: 8946fe           mov word ptr [bp - 2], ax
  041F5A  1E6A: 80bc503100       cmp byte ptr [si + 0x3150], 0
  041F5F  1E6F: 7405             je 0x1e76
  041F61  1E71: c746f80100       mov word ptr [bp - 8], 1
  041F66  1E76: 8b46f4           mov ax, word ptr [bp - 0xc]
  041F69  1E79: 9ae4021f18       lcall 0x181f, 0x2e4
  041F6E  1E7E: 8946f4           mov word ptr [bp - 0xc], ax
  041F71  1E81: 0bc0             or ax, ax
  041F73  1E83: 7dab             jge 0x1e30
  041F75  1E85: 6aec             push -0x14
  041F77  1E87: 6af0             push -0x10
  041F79  1E89: 0e               push cs
  041F7A  1E8A: e89901           call 0x2026
  041F7D  1E8D: 83c404           add sp, 4
  041F80  1E90: 6af0             push -0x10
  041F82  1E92: 6af4             push -0xc
  041F84  1E94: 0e               push cs
  041F85  1E95: e88e01           call 0x2026
  041F88  1E98: 83c404           add sp, 4
  041F8B  1E9B: a19453           mov ax, word ptr [0x5394]
  041F8E  1E9E: 2d1400           sub ax, 0x14
  041F91  1EA1: 8bd0             mov dx, ax
  041F93  1EA3: 9ae0071f18       lcall 0x181f, 0x7e0
  041F98  1EA8: e92901           jmp 0x1fd4
  041F9B  1EAB: 90               nop 
  041F9C  1EAC: 9ae4021f18       lcall 0x181f, 0x2e4
  041FA1  1EB1: 8946f0           mov word ptr [bp - 0x10], ax
  041FA4  1EB4: 6b5ef41c         imul bx, word ptr [bp - 0xc], 0x1c
  041FA8  1EB8: 80bf46310a       cmp byte ptr [bx + 0x3146], 0xa
  041FAD  1EBD: 7403             je 0x1ec2
  041FAF  1EBF: e90f01           jmp 0x1fd1
  041FB2  1EC2: b064             mov al, 0x64
  041FB4  1EC4: f6a75b31         mul byte ptr [bx + 0x315b]
  041FB8  1EC8: 8946f2           mov word ptr [bp - 0xe], ax
  041FBB  1ECB: 6a00             push 0
  041FBD  1ECD: 50               push ax
  041FBE  1ECE: 6a00             push 0
  041FC0  1ED0: 8bf3             mov si, bx
  041FC2  1ED2: 9aae091f18       lcall 0x181f, 0x9ae
  041FC7  1ED7: 83c406           add sp, 6
  041FCA  1EDA: 6a00             push 0
  041FCC  1EDC: 6a64             push 0x64
  041FCE  1EDE: 6a00             push 0
  041FD0  1EE0: ff76f2           push word ptr [bp - 0xe]
  041FD3  1EE3: 691e94533c01     imul bx, word ptr [0x5394], 0x13c
  041FD9  1EE9: 8a870988         mov al, byte ptr [bx - 0x77f7]
  041FDD  1EED: 3c32             cmp al, 0x32
  041FDF  1EEF: 7e02             jle 0x1ef3
  041FE1  1EF1: b032             mov al, 0x32
  041FE3  1EF3: 98               cwde 
  041FE4  1EF4: 99               cdq 
  041FE5  1EF5: 52               push dx
  041FE6  1EF6: 50               push ax
  041FE7  1EF7: 8bf8             mov di, ax
  041FE9  1EF9: 897eec           mov word ptr [bp - 0x14], di
  041FEC  1EFC: 8956ee           mov word ptr [bp - 0x12], dx
  041FEF  1EFF: 9a600f1d0d       lcall 0xd1d, 0xf60
  041FF4  1F04: 52               push dx
  041FF5  1F05: 50               push ax
  041FF6  1F06: 9ac60e1d0d       lcall 0xd1d, 0xec6
  041FFB  1F0B: 8946fa           mov word ptr [bp - 6], ax
  041FFE  1F0E: 8956fc           mov word ptr [bp - 4], dx
  042001  1F11: ff76ee           push word ptr [bp - 0x12]
  042004  1F14: ff76ec           push word ptr [bp - 0x14]
  042007  1F17: 6a01             push 1
  042009  1F19: 9aae091f18       lcall 0x181f, 0x9ae
  04200E  1F1E: 83c406           add sp, 6
  042011  1F21: 8b46fa           mov ax, word ptr [bp - 6]
  042014  1F24: 2946f2           sub word ptr [bp - 0xe], ax
  042017  1F27: 8b46f2           mov ax, word ptr [bp - 0xe]
  04201A  1F2A: 2bd2             sub dx, dx
  04201C  1F2C: 52               push dx
  04201D  1F2D: 50               push ax
  04201E  1F2E: 6a02             push 2
  042020  1F30: 8bf8             mov di, ax
  042022  1F32: 897ee8           mov word ptr [bp - 0x18], di
  042025  1F35: 8956ea           mov word ptr [bp - 0x16], dx
  042028  1F38: 9aae091f18       lcall 0x181f, 0x9ae
  04202D  1F3D: 83c406           add sp, 6
  042030  1F40: 8a844731         mov al, byte ptr [si + 0x3147]
  042034  1F44: 250f00           and ax, 0xf
  042037  1F47: 50               push ax
  042038  1F48: 9aa4091f18       lcall 0x181f, 0x9a4
  04203D  1F4D: 83c402           add sp, 2
  042040  1F50: 50               push ax
  042041  1F51: 6a00             push 0
  042043  1F53: 9a38041f18       lcall 0x181f, 0x438
  042048  1F58: 83c404           add sp, 4
  04204B  1F5B: 8a9c4731         mov bl, byte ptr [si + 0x3147]
  04204F  1F5F: 83e30f           and bx, 0xf
  042052  1F62: d1e3             shl bx, 1
  042054  1F64: ffb78c83         push word ptr [bx - 0x7c74]
  042058  1F68: 6a01             push 1
  04205A  1F6A: 9a38041f18       lcall 0x181f, 0x438
  04205F  1F6F: 83c404           add sp, 4
  042062  1F72: 8b46e8           mov ax, word ptr [bp - 0x18]
  042065  1F75: 8b56ea           mov dx, word ptr [bp - 0x16]
  042068  1F78: 691e94533c01     imul bx, word ptr [0x5394], 0x13c
  04206E  1F7E: 01873288         add word ptr [bx - 0x77ce], ax
  042072  1F82: 11973488         adc word ptr [bx - 0x77cc], dx
  042076  1F86: 01872e88         add word ptr [bx - 0x77d2], ax
  04207A  1F8A: 11973088         adc word ptr [bx - 0x77d0], dx
  04207E  1F8E: 8b46fa           mov ax, word ptr [bp - 6]
  042081  1F91: 8b56fc           mov dx, word ptr [bp - 4]
  042084  1F94: 01872a88         add word ptr [bx - 0x77d6], ax
  042088  1F98: 11972c88         adc word ptr [bx - 0x77d4], dx
  04208C  1F9C: 6a24             push 0x24
  04208E  1F9E: 9a8e041f18       lcall 0x181f, 0x48e
  042093  1FA3: 83c402           add sp, 2
  042096  1FA6: 6a02             push 2
  042098  1FA8: 688e14           push 0x148e
  04209B  1FAB: 9a52061f18       lcall 0x181f, 0x652
  0420A0  1FB0: 83c404           add sp, 4
  0420A3  1FB3: ff76f4           push word ptr [bp - 0xc]
  0420A6  1FB6: 9a08081f18       lcall 0x181f, 0x808
  0420AB  1FBB: 83c402           add sp, 2
  0420AE  1FBE: 8b46f4           mov ax, word ptr [bp - 0xc]
  0420B1  1FC1: 3946f0           cmp word ptr [bp - 0x10], ax
  0420B4  1FC4: 7e03             jle 0x1fc9
  0420B6  1FC6: ff4ef0           dec word ptr [bp - 0x10]
  0420B9  1FC9: 3946fe           cmp word ptr [bp - 2], ax
  0420BC  1FCC: 7e03             jle 0x1fd1
  0420BE  1FCE: ff4efe           dec word ptr [bp - 2]
  0420C1  1FD1: 8b46f0           mov ax, word ptr [bp - 0x10]
  0420C4  1FD4: 8946f4           mov word ptr [bp - 0xc], ax
  0420C7  1FD7: 0bc0             or ax, ax
  0420C9  1FD9: 7c03             jl 0x1fde
  0420CB  1FDB: e9cefe           jmp 0x1eac
  0420CE  1FDE: 837efe00         cmp word ptr [bp - 2], 0
  0420D2  1FE2: 7c2f             jl 0x2013
  0420D4  1FE4: 833e945304       cmp word ptr [0x5394], 4
  0420D9  1FE9: 7d28             jge 0x2013
  0420DB  1FEB: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  0420E0  1FF0: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  0420E5  1FF5: 751c             jne 0x2013
  0420E7  1FF7: 837ef800         cmp word ptr [bp - 8], 0
  0420EB  1FFB: 740a             je 0x2007
  0420ED  1FFD: 6a09             push 9
  0420EF  1FFF: 9a24051f18       lcall 0x181f, 0x524
  0420F4  2004: 83c402           add sp, 2
  0420F7  2007: c7064c010100     mov word ptr [0x14c], 1
  0420FD  200D: 8b46fe           mov ax, word ptr [bp - 2]
  042100  2010: a34e01           mov word ptr [0x14e], ax
  042103  2013: 0e               push cs
  042104  2014: e80a00           call 0x2021
  042107  2017: 5e               pop si
  042108  2018: 5f               pop di
  042109  2019: c9               leave 
  04210A  201A: cb               retf 
  04210B  201B: 90               nop 
  04210C  201C: eaee0a1f19       ljmp 0x191f:0xaee
  042111  2021: ea38021f1a       ljmp 0x1a1f:0x238
  042116  2026: ea46021f1a       ljmp 0x1a1f:0x246
  04211B  202B: ea54021f1a       ljmp 0x1a1f:0x254
  042120  2030: ea62021f1a       ljmp 0x1a1f:0x262
  042125  2035: 008a0f2a         add byte ptr [bp + si + 0x2a0f], cl
  042129  2039: ed               in ax, dx
  04212A  203A: 03c1             add ax, cx
  04212C  203C: 3dff00           cmp ax, 0xff
  04212F  203F: 7e03             jle 0x2044
  042131  2041: b8ff00           mov ax, 0xff
  042134  2044: 8807             mov byte ptr [bx], al
  042136  2046: c3               ret 

; ---- func_042138  size=1518  insns=507  prologue=ENTER 0x0018,0  terminal=RETF ----
  042138  2048: c8180000         enter 0x18, 0
  04213C  204C: 56               push si
  04213D  204D: 8b5e06           mov bx, word ptr [bp + 6]
  042140  2050: d1e3             shl bx, 1
  042142  2052: c7871c940000     mov word ptr [bx - 0x6be4], 0
  042148  2058: 2ac0             sub al, al
  04214A  205A: 8b5e06           mov bx, word ptr [bp + 6]
  04214D  205D: 8887fc8c         mov byte ptr [bx - 0x7304], al
  042151  2061: 88879892         mov byte ptr [bx - 0x6d68], al
  042155  2065: 88870894         mov byte ptr [bx - 0x6bf8], al
  042159  2069: 88870c94         mov byte ptr [bx - 0x6bf4], al
  04215D  206D: 88871094         mov byte ptr [bx - 0x6bf0], al
  042161  2071: 88878091         mov byte ptr [bx - 0x6e80], al
  042165  2075: 88871494         mov byte ptr [bx - 0x6bec], al
  042169  2079: 88871894         mov byte ptr [bx - 0x6be8], al
  04216D  207D: 88872494         mov byte ptr [bx - 0x6bdc], al
  042171  2081: 88872c94         mov byte ptr [bx - 0x6bd4], al
  042175  2085: c746ee0000       mov word ptr [bp - 0x12], 0
  04217A  208A: 6b760613         imul si, word ptr [bp + 6], 0x13
  04217E  208E: 8b5eee           mov bx, word ptr [bp - 0x12]
  042181  2091: c6804c9200       mov byte ptr [bx + si - 0x6db4], 0
  042186  2096: ff46ee           inc word ptr [bp - 0x12]
  042189  2099: 837eee13         cmp word ptr [bp - 0x12], 0x13
  04218D  209D: 7ceb             jl 0x208a
  04218F  209F: 2ac0             sub al, al
  042191  20A1: 8b5e06           mov bx, word ptr [bp + 6]
  042194  20A4: 88875694         mov byte ptr [bx - 0x6baa], al
  042198  20A8: 88875a94         mov byte ptr [bx - 0x6ba6], al
  04219C  20AC: 2bc0             sub ax, ax
  04219E  20AE: d1e3             shl bx, 1
  0421A0  20B0: 89874e94         mov word ptr [bx - 0x6bb2], ax
  0421A4  20B4: 8946ee           mov word ptr [bp - 0x12], ax
  0421A7  20B7: eb2d             jmp 0x20e6
  0421A9  20B9: 90               nop 
  0421AA  20BA: 2ac0             sub al, al
  0421AC  20BC: 8b5eee           mov bx, word ptr [bp - 0x12]
  0421AF  20BF: 8887f295         mov byte ptr [bx - 0x6a0e], al
  0421B3  20C3: 8b4e06           mov cx, word ptr [bp + 6]
  0421B6  20C6: c1e104           shl cx, 4
  0421B9  20C9: 03d9             add bx, cx
  0421BB  20CB: 8887a694         mov byte ptr [bx - 0x6b5a], al
  0421BF  20CF: 8887e694         mov byte ptr [bx - 0x6b1a], al
  0421C3  20D3: 88872695         mov byte ptr [bx - 0x6ada], al
  0421C7  20D7: 88878c91         mov byte ptr [bx - 0x6e74], al
  0421CB  20DB: 88877295         mov byte ptr [bx - 0x6a8e], al
  0421CF  20DF: 8887b295         mov byte ptr [bx - 0x6a4e], al
  0421D3  20E3: ff46ee           inc word ptr [bp - 0x12]
  0421D6  20E6: 837eee10         cmp word ptr [bp - 0x12], 0x10
  0421DA  20EA: 7cce             jl 0x20ba
  0421DC  20EC: c746e80000       mov word ptr [bp - 0x18], 0
  0421E1  20F1: e9f101           jmp 0x22e5
  0421E4  20F4: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  0421E8  20F8: 8a874431         mov al, byte ptr [bx + 0x3144]
  0421EC  20FC: 2a4606           sub al, byte ptr [bp + 6]
  0421EF  20FF: 3cec             cmp al, 0xec
  0421F1  2101: 7507             jne 0x210a
  0421F3  2103: 8b5e06           mov bx, word ptr [bp + 6]
  0421F6  2106: fe875a94         inc byte ptr [bx - 0x6ba6]
  0421FA  210A: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  0421FE  210E: 8bc3             mov ax, bx
  042200  2110: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  042204  2114: 2aff             sub bh, bh
  042206  2116: 8bcb             mov cx, bx
  042208  2118: d1e3             shl bx, 1
  04220A  211A: 03d9             add bx, cx
  04220C  211C: d1e3             shl bx, 1
  04220E  211E: 03d9             add bx, cx
  042210  2120: d1e3             shl bx, 1
  042212  2122: 80bf355201       cmp byte ptr [bx + 0x5235], 1
  042217  2127: 763a             jbe 0x2163
  042219  2129: 8bd8             mov bx, ax
  04221B  212B: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  042220  2130: 7407             je 0x2139
  042222  2132: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  042227  2137: 752a             jne 0x2163
  042229  2139: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  04222D  213D: 8a874531         mov al, byte ptr [bx + 0x3145]
  042231  2141: 2ae4             sub ah, ah
  042233  2143: 50               push ax
  042234  2144: 8a874431         mov al, byte ptr [bx + 0x3144]
  042238  2148: 50               push ax
  042239  2149: 9a96061f18       lcall 0x181f, 0x696
  04223E  214E: 83c404           add sp, 4
  042241  2151: 0bc0             or ax, ax
  042243  2153: 7d0e             jge 0x2163
  042245  2155: 837efa00         cmp word ptr [bp - 6], 0
  042249  2159: 7c08             jl 0x2163
  04224B  215B: 8b5efa           mov bx, word ptr [bp - 6]
  04224E  215E: 808ff29508       or byte ptr [bx - 0x6a0e], 8
  042253  2163: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  042257  2167: 80bf4a3100       cmp byte ptr [bx + 0x314a], 0
  04225C  216C: 7d1a             jge 0x2188
  04225E  216E: 8a874531         mov al, byte ptr [bx + 0x3145]
  042262  2172: 2ae4             sub ah, ah
  042264  2174: 50               push ax
  042265  2175: 8a874431         mov al, byte ptr [bx + 0x3144]
  042269  2179: 50               push ax
  04226A  217A: 8bf3             mov si, bx
  04226C  217C: 9abe071f18       lcall 0x181f, 0x7be
  042271  2181: 83c404           add sp, 4
  042274  2184: 88844a31         mov byte ptr [si + 0x314a], al
  042278  2188: 8b5e06           mov bx, word ptr [bp + 6]
  04227B  218B: fe87fc8c         inc byte ptr [bx - 0x7304]
  04227F  218F: 837efa00         cmp word ptr [bp - 6], 0
  042283  2193: 7c0c             jl 0x21a1
  042285  2195: 8bf3             mov si, bx
  042287  2197: c1e604           shl si, 4
  04228A  219A: 8b5efa           mov bx, word ptr [bp - 6]
  04228D  219D: fe80a694         inc byte ptr [bx + si - 0x6b5a]
  042291  21A1: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  042295  21A5: 80bf463100       cmp byte ptr [bx + 0x3146], 0
  04229A  21AA: 7507             jne 0x21b3
  04229C  21AC: 8b5e06           mov bx, word ptr [bp + 6]
  04229F  21AF: fe870894         inc byte ptr [bx - 0x6bf8]
  0422A3  21B3: ff76e8           push word ptr [bp - 0x18]
  0422A6  21B6: 9a780b1f18       lcall 0x181f, 0xb78
  0422AB  21BB: 83c402           add sp, 2
  0422AE  21BE: 0bc0             or ax, ax
  0422B0  21C0: 7c26             jl 0x21e8
  0422B2  21C2: 8b5e06           mov bx, word ptr [bp + 6]
  0422B5  21C5: 81c31094         add bx, 0x9410
  0422B9  21C9: b80100           mov ax, 1
  0422BC  21CC: e867fe           call 0x2036
  0422BF  21CF: 837efa00         cmp word ptr [bp - 6], 0
  0422C3  21D3: 7c13             jl 0x21e8
  0422C5  21D5: 8b5e06           mov bx, word ptr [bp + 6]
  0422C8  21D8: c1e304           shl bx, 4
  0422CB  21DB: 035efa           add bx, word ptr [bp - 6]
  0422CE  21DE: 81c32695         add bx, 0x9526
  0422D2  21E2: b80100           mov ax, 1
  0422D5  21E5: e84efe           call 0x2036
  0422D8  21E8: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  0422DC  21EC: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  0422E1  21F1: 720a             jb 0x21fd
  0422E3  21F3: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  0422E8  21F8: 7703             ja 0x21fd
  0422EA  21FA: e9e500           jmp 0x22e2
  0422ED  21FD: 6a00             push 0
  0422EF  21FF: ff76e8           push word ptr [bp - 0x18]
  0422F2  2202: 9ac8091f18       lcall 0x181f, 0x9c8
  0422F7  2207: 83c404           add sp, 4
  0422FA  220A: 8946f6           mov word ptr [bp - 0xa], ax
  0422FD  220D: 8b5e06           mov bx, word ptr [bp + 6]
  042300  2210: 81c38091         add bx, 0x9180
  042304  2214: e81ffe           call 0x2036
  042307  2217: 837efa00         cmp word ptr [bp - 6], 0
  04230B  221B: 7c13             jl 0x2230
  04230D  221D: 8b5e06           mov bx, word ptr [bp + 6]
  042310  2220: c1e304           shl bx, 4
  042313  2223: 035efa           add bx, word ptr [bp - 6]
  042316  2226: 81c38c91         add bx, 0x918c
  04231A  222A: 8b46f6           mov ax, word ptr [bp - 0xa]
  04231D  222D: e806fe           call 0x2036
  042320  2230: 6a01             push 1
  042322  2232: ff76e8           push word ptr [bp - 0x18]
  042325  2235: 9ac8091f18       lcall 0x181f, 0x9c8
  04232A  223A: 83c404           add sp, 4
  04232D  223D: 8946f6           mov word ptr [bp - 0xa], ax
  042330  2240: 8b5e06           mov bx, word ptr [bp + 6]
  042333  2243: d1e3             shl bx, 1
  042335  2245: 01871c94         add word ptr [bx - 0x6be4], ax
  042339  2249: 837efa00         cmp word ptr [bp - 6], 0
  04233D  224D: 7c10             jl 0x225f
  04233F  224F: 8b5e06           mov bx, word ptr [bp + 6]
  042342  2252: c1e304           shl bx, 4
  042345  2255: 035efa           add bx, word ptr [bp - 6]
  042348  2258: 81c37295         add bx, 0x9572
  04234C  225C: e8d7fd           call 0x2036
  04234F  225F: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  042353  2263: 8a874531         mov al, byte ptr [bx + 0x3145]
  042357  2267: 2ae4             sub ah, ah
  042359  2269: 50               push ax
  04235A  226A: 8a874431         mov al, byte ptr [bx + 0x3144]
  04235E  226E: 50               push ax
  04235F  226F: 9abe061f18       lcall 0x181f, 0x6be
  042364  2274: 83c404           add sp, 4
  042367  2277: 0bc0             or ax, ax
  042369  2279: 7c23             jl 0x229e
  04236B  227B: 837e0604         cmp word ptr [bp + 6], 4
  04236F  227F: 7d0b             jge 0x228c
  042371  2281: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  042375  2285: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04237A  228A: 7456             je 0x22e2
  04237C  228C: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  042380  2290: 80bf4b3141       cmp byte ptr [bx + 0x314b], 0x41
  042385  2295: 744b             je 0x22e2
  042387  2297: 80bf4b3147       cmp byte ptr [bx + 0x314b], 0x47
  04238C  229C: 7444             je 0x22e2
  04238E  229E: 8b5e06           mov bx, word ptr [bp + 6]
  042391  22A1: 81c32c94         add bx, 0x942c
  042395  22A5: 8b46f6           mov ax, word ptr [bp - 0xa]
  042398  22A8: e88bfd           call 0x2036
  04239B  22AB: 837efa00         cmp word ptr [bp - 6], 0
  04239F  22AF: 7c31             jl 0x22e2
  0423A1  22B1: 8b5e06           mov bx, word ptr [bp + 6]
  0423A4  22B4: c1e304           shl bx, 4
  0423A7  22B7: 035efa           add bx, word ptr [bp - 6]
  0423AA  22BA: 81c3b295         add bx, 0x95b2
  0423AE  22BE: 8b46f6           mov ax, word ptr [bp - 0xa]
  0423B1  22C1: e872fd           call 0x2036
  0423B4  22C4: eb1c             jmp 0x22e2
  0423B6  22C6: 837efa00         cmp word ptr [bp - 6], 0
  0423BA  22CA: 7c16             jl 0x22e2
  0423BC  22CC: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  0423C0  22D0: 8a874731         mov al, byte ptr [bx + 0x3147]
  0423C4  22D4: 240f             and al, 0xf
  0423C6  22D6: 3c04             cmp al, 4
  0423C8  22D8: 7308             jae 0x22e2
  0423CA  22DA: 8b5efa           mov bx, word ptr [bp - 6]
  0423CD  22DD: 808ff29502       or byte ptr [bx - 0x6a0e], 2
  0423D2  22E2: ff46e8           inc word ptr [bp - 0x18]
  0423D5  22E5: 8b46e8           mov ax, word ptr [bp - 0x18]
  0423D8  22E8: 39069c53         cmp word ptr [0x539c], ax
  0423DC  22EC: 7f03             jg 0x22f1
  0423DE  22EE: e9df00           jmp 0x23d0
  0423E1  22F1: 6bd81c           imul bx, ax, 0x1c
  0423E4  22F4: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  0423E8  22F8: 83e10f           and cx, 0xf
  0423EB  22FB: 894eea           mov word ptr [bp - 0x16], cx
  0423EE  22FE: 50               push ax
  0423EF  22FF: 8bf3             mov si, bx
  0423F1  2301: 9a1c081f18       lcall 0x181f, 0x81c
  0423F6  2306: 83c402           add sp, 2
  0423F9  2309: 8946fa           mov word ptr [bp - 6], ax
  0423FC  230C: 8b4606           mov ax, word ptr [bp + 6]
  0423FF  230F: 3946ea           cmp word ptr [bp - 0x16], ax
  042402  2312: 75b2             jne 0x22c6
  042404  2314: 80bc463113       cmp byte ptr [si + 0x3146], 0x13
  042409  2319: 7315             jae 0x2330
  04240B  231B: 6bc013           imul ax, ax, 0x13
  04240E  231E: 8a9c4631         mov bl, byte ptr [si + 0x3146]
  042412  2322: 2aff             sub bh, bh
  042414  2324: 03d8             add bx, ax
  042416  2326: 81c34c92         add bx, 0x924c
  04241A  232A: b80100           mov ax, 1
  04241D  232D: e806fd           call 0x2036
  042420  2330: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  042424  2334: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  042429  2339: 7303             jae 0x233e
  04242B  233B: e9b6fd           jmp 0x20f4
  04242E  233E: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  042433  2343: 7603             jbe 0x2348
  042435  2345: e9acfd           jmp 0x20f4
  042438  2348: 8a874431         mov al, byte ptr [bx + 0x3144]
  04243C  234C: 2a4606           sub al, byte ptr [bp + 6]
  04243F  234F: 3cf4             cmp al, 0xf4
  042441  2351: 7507             jne 0x235a
  042443  2353: 8b5e06           mov bx, word ptr [bp + 6]
  042446  2356: fe875694         inc byte ptr [bx - 0x6baa]
  04244A  235A: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  04244E  235E: 8a874431         mov al, byte ptr [bx + 0x3144]
  042452  2362: 2a4606           sub al, byte ptr [bp + 6]
  042455  2365: 3cf0             cmp al, 0xf0
  042457  2367: 7507             jne 0x2370
  042459  2369: 8b5e06           mov bx, word ptr [bp + 6]
  04245C  236C: fe875694         inc byte ptr [bx - 0x6baa]
  042460  2370: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  042464  2374: 8d874631         lea ax, [bx + 0x3146]
  042468  2378: 8bd8             mov bx, ax
  04246A  237A: 8a1f             mov bl, byte ptr [bx]
  04246C  237C: 2aff             sub bh, bh
  04246E  237E: 8bcb             mov cx, bx
  042470  2380: d1e3             shl bx, 1
  042472  2382: 03d9             add bx, cx
  042474  2384: d1e3             shl bx, 1
  042476  2386: 03d9             add bx, cx
  042478  2388: d1e3             shl bx, 1
  04247A  238A: 8bc8             mov cx, ax
  04247C  238C: 8a873752         mov al, byte ptr [bx + 0x5237]
  042480  2390: 2ae4             sub ah, ah
  042482  2392: 8b5e06           mov bx, word ptr [bp + 6]
  042485  2395: 81c31494         add bx, 0x9414
  042489  2399: 8bf1             mov si, cx
  04248B  239B: e898fc           call 0x2036
  04248E  239E: 8b5e06           mov bx, word ptr [bp + 6]
  042491  23A1: 81c31894         add bx, 0x9418
  042495  23A5: b80100           mov ax, 1
  042498  23A8: e88bfc           call 0x2036
  04249B  23AB: 8a1c             mov bl, byte ptr [si]
  04249D  23AD: 2aff             sub bh, bh
  04249F  23AF: 8bc3             mov ax, bx
  0424A1  23B1: d1e3             shl bx, 1
  0424A3  23B3: 03d8             add bx, ax
  0424A5  23B5: d1e3             shl bx, 1
  0424A7  23B7: 03d8             add bx, ax
  0424A9  23B9: d1e3             shl bx, 1
  0424AB  23BB: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  0424B0  23C0: 7503             jne 0x23c5
  0424B2  23C2: e99efd           jmp 0x2163
  0424B5  23C5: 8b5e06           mov bx, word ptr [bp + 6]
  0424B8  23C8: fe872494         inc byte ptr [bx - 0x6bdc]
  0424BC  23CC: e994fd           jmp 0x2163
  0424BF  23CF: 90               nop 
  0424C0  23D0: 2ac0             sub al, al
  0424C2  23D2: a29aa8           mov byte ptr [0xa89a], al
  0424C5  23D5: a29ba8           mov byte ptr [0xa89b], al
  0424C8  23D8: 2bc0             sub ax, ax
  0424CA  23DA: a3549e           mov word ptr [0x9e54], ax
  0424CD  23DD: a3529e           mov word ptr [0x9e52], ax
  0424D0  23E0: 8946ee           mov word ptr [bp - 0x12], ax
  0424D3  23E3: e92501           jmp 0x250b
  0424D6  23E6: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  0424DA  23EA: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0424DE  23EE: 2aff             sub bh, bh
  0424E0  23F0: 8bc3             mov ax, bx
  0424E2  23F2: d1e3             shl bx, 1
  0424E4  23F4: 03d8             add bx, ax
  0424E6  23F6: d1e3             shl bx, 1
  0424E8  23F8: 03d8             add bx, ax
  0424EA  23FA: d1e3             shl bx, 1
  0424EC  23FC: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  0424F1  2401: 7525             jne 0x2428
  0424F3  2403: 8b46e8           mov ax, word ptr [bp - 0x18]
  0424F6  2406: 9ae4021f18       lcall 0x181f, 0x2e4
  0424FB  240B: 8946e8           mov word ptr [bp - 0x18], ax
  0424FE  240E: 837ee800         cmp word ptr [bp - 0x18], 0
  042502  2412: 7c56             jl 0x246a
  042504  2414: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  042508  2418: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04250D  241D: 72e4             jb 0x2403
  04250F  241F: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  042514  2424: 76c0             jbe 0x23e6
  042516  2426: ebdb             jmp 0x2403
  042518  2428: 8b1e4285         mov bx, word ptr [0x8542]
  04251C  242C: 8a4701           mov al, byte ptr [bx + 1]
  04251F  242F: 2ae4             sub ah, ah
  042521  2431: 50               push ax
  042522  2432: 6a01             push 1
  042524  2434: 6a08             push 8
  042526  2436: 8a1f             mov bl, byte ptr [bx]
  042528  2438: 2aff             sub bh, bh
  04252A  243A: 8b46f2           mov ax, word ptr [bp - 0xe]
  04252D  243D: 8b56f0           mov dx, word ptr [bp - 0x10]
  042530  2440: 9a7e021f1a       lcall 0x1a1f, 0x27e
  042535  2445: 0bc0             or ax, ax
  042537  2447: 7cba             jl 0x2403
  042539  2449: 3d0500           cmp ax, 5
  04253C  244C: 7fb5             jg 0x2403
  04253E  244E: 6b5ee81c         imul bx, word ptr [bp - 0x18], 0x1c
  042542  2452: 80bf463111       cmp byte ptr [bx + 0x3146], 0x11
  042547  2457: 7505             jne 0x245e
  042549  2459: b002             mov al, 2
  04254B  245B: eb03             jmp 0x2460
  04254D  245D: 90               nop 
  04254E  245E: b001             mov al, 1
  042550  2460: 8b1e4285         mov bx, word ptr [0x8542]
  042554  2464: 08471b           or byte ptr [bx + 0x1b], al
  042557  2467: eb9a             jmp 0x2403
  042559  2469: 90               nop 
  04255A  246A: ff46fe           inc word ptr [bp - 2]
  04255D  246D: 837efe05         cmp word ptr [bp - 2], 5
  042561  2471: 7f4d             jg 0x24c0
  042563  2473: 8b1e4285         mov bx, word ptr [0x8542]
  042567  2477: 8a4701           mov al, byte ptr [bx + 1]
  04256A  247A: 2ae4             sub ah, ah
  04256C  247C: 0346fc           add ax, word ptr [bp - 4]
  04256F  247F: 8946f0           mov word ptr [bp - 0x10], ax
  042572  2482: 50               push ax
  042573  2483: 8a07             mov al, byte ptr [bx]
  042575  2485: 2ae4             sub ah, ah
  042577  2487: 0346fe           add ax, word ptr [bp - 2]
  04257A  248A: 8946f2           mov word ptr [bp - 0xe], ax
  04257D  248D: 50               push ax
  04257E  248E: 9a02031f18       lcall 0x181f, 0x302
  042583  2493: 83c404           add sp, 4
  042586  2496: 0bc0             or ax, ax
  042588  2498: 74d0             je 0x246a
  04258A  249A: 8b46f2           mov ax, word ptr [bp - 0xe]
  04258D  249D: 8b56f0           mov dx, word ptr [bp - 0x10]
  042590  24A0: 9ae0071f18       lcall 0x181f, 0x7e0
  042595  24A5: 8946e8           mov word ptr [bp - 0x18], ax
  042598  24A8: 0bc0             or ax, ax
  04259A  24AA: 7cbe             jl 0x246a
  04259C  24AC: 6bd81c           imul bx, ax, 0x1c
  04259F  24AF: 8a874731         mov al, byte ptr [bx + 0x3147]
  0425A3  24B3: 240f             and al, 0xf
  0425A5  24B5: 3a4606           cmp al, byte ptr [bp + 6]
  0425A8  24B8: 7403             je 0x24bd
  0425AA  24BA: e951ff           jmp 0x240e
  0425AD  24BD: ebab             jmp 0x246a
  0425AF  24BF: 90               nop 
  0425B0  24C0: ff46fc           inc word ptr [bp - 4]
  0425B3  24C3: 837efc05         cmp word ptr [bp - 4], 5
  0425B7  24C7: 7f07             jg 0x24d0
  0425B9  24C9: c746fefbff       mov word ptr [bp - 2], 0xfffb
  0425BE  24CE: eb9d             jmp 0x246d
  0425C0  24D0: 8b1e4285         mov bx, word ptr [0x8542]
  0425C4  24D4: f6471b02         test byte ptr [bx + 0x1b], 2
  0425C8  24D8: 740c             je 0x24e6
  0425CA  24DA: fe069ba8         inc byte ptr [0xa89b]
  0425CE  24DE: 8a471f           mov al, byte ptr [bx + 0x1f]
  0425D1  24E1: 98               cwde 
  0425D2  24E2: 0106529e         add word ptr [0x9e52], ax
  0425D6  24E6: f6471b01         test byte ptr [bx + 0x1b], 1
  0425DA  24EA: 741c             je 0x2508
  0425DC  24EC: fe069aa8         inc byte ptr [0xa89a]
  0425E0  24F0: 8a471f           mov al, byte ptr [bx + 0x1f]
  0425E3  24F3: 98               cwde 
  0425E4  24F4: 0106549e         add word ptr [0x9e54], ax
  0425E8  24F8: eb0e             jmp 0x2508
  0425EA  24FA: 837efa00         cmp word ptr [bp - 6], 0
  0425EE  24FE: 7c08             jl 0x2508
  0425F0  2500: 8b5efa           mov bx, word ptr [bp - 6]
  0425F3  2503: 808ff29504       or byte ptr [bx - 0x6a0e], 4
  0425F8  2508: ff46ee           inc word ptr [bp - 0x12]
  0425FB  250B: 8b46ee           mov ax, word ptr [bp - 0x12]
  0425FE  250E: 39069e53         cmp word ptr [0x539e], ax
  042602  2512: 7f03             jg 0x2517
  042604  2514: e99100           jmp 0x25a8
  042607  2517: 50               push ax
  042608  2518: 9ae6091f18       lcall 0x181f, 0x9e6
  04260D  251D: 83c402           add sp, 2
  042610  2520: 8b1e4285         mov bx, word ptr [0x8542]
  042614  2524: 8a471a           mov al, byte ptr [bx + 0x1a]
  042617  2527: 2ae4             sub ah, ah
  042619  2529: 8946ea           mov word ptr [bp - 0x16], ax
  04261C  252C: 8a4701           mov al, byte ptr [bx + 1]
  04261F  252F: 50               push ax
  042620  2530: 8a07             mov al, byte ptr [bx]
  042622  2532: 50               push ax
  042623  2533: 9a22071f18       lcall 0x181f, 0x722
  042628  2538: 83c404           add sp, 4
  04262B  253B: 8946fa           mov word ptr [bp - 6], ax
  04262E  253E: 8b4606           mov ax, word ptr [bp + 6]
  042631  2541: 3946ea           cmp word ptr [bp - 0x16], ax
  042634  2544: 75b4             jne 0x24fa
  042636  2546: 8bd8             mov bx, ax
  042638  2548: fe879892         inc byte ptr [bx - 0x6d68]
  04263C  254C: 8b364285         mov si, word ptr [0x8542]
  042640  2550: 8a441f           mov al, byte ptr [si + 0x1f]
  042643  2553: 98               cwde 
  042644  2554: d1e3             shl bx, 1
  042646  2556: 01874e94         add word ptr [bx - 0x6bb2], ax
  04264A  255A: 8b5e06           mov bx, word ptr [bp + 6]
  04264D  255D: 81c31094         add bx, 0x9410
  042651  2561: e8d2fa           call 0x2036
  042654  2564: 8b1e4285         mov bx, word ptr [0x8542]
  042658  2568: 8a471f           mov al, byte ptr [bx + 0x1f]
  04265B  256B: 98               cwde 
  04265C  256C: 8b5e06           mov bx, word ptr [bp + 6]
  04265F  256F: 81c30c94         add bx, 0x940c
  042663  2573: e8c0fa           call 0x2036
  042666  2576: 837efa00         cmp word ptr [bp - 6], 0
  04266A  257A: 7c1c             jl 0x2598
  04266C  257C: 8b5e06           mov bx, word ptr [bp + 6]
  04266F  257F: c1e304           shl bx, 4
  042672  2582: 035efa           add bx, word ptr [bp - 6]
  042675  2585: fe87e694         inc byte ptr [bx - 0x6b1a]
  042679  2589: 8b364285         mov si, word ptr [0x8542]
  04267D  258D: 8a441f           mov al, byte ptr [si + 0x1f]
  042680  2590: 98               cwde 
  042681  2591: 81c32695         add bx, 0x9526
  042685  2595: e89efa           call 0x2036
  042688  2598: 8b1e4285         mov bx, word ptr [0x8542]
  04268C  259C: 80671bfc         and byte ptr [bx + 0x1b], 0xfc
  042690  25A0: c746fcfbff       mov word ptr [bp - 4], 0xfffb
  042695  25A5: e91bff           jmp 0x24c3
  042698  25A8: c746ee0000       mov word ptr [bp - 0x12], 0
  04269D  25AD: eb30             jmp 0x25df
  04269F  25AF: 90               nop 
  0426A0  25B0: 50               push ax
  0426A1  25B1: 9a4c0a1f18       lcall 0x181f, 0xa4c
  0426A6  25B6: 83c402           add sp, 2
  0426A9  25B9: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0426AD  25BD: 8a4701           mov al, byte ptr [bx + 1]
  0426B0  25C0: 2ae4             sub ah, ah
  0426B2  25C2: 50               push ax
  0426B3  25C3: 8a07             mov al, byte ptr [bx]
  0426B5  25C5: 50               push ax
  0426B6  25C6: 9a22071f18       lcall 0x181f, 0x722
  0426BB  25CB: 83c404           add sp, 4
  0426BE  25CE: 8946fa           mov word ptr [bp - 6], ax
  0426C1  25D1: 0bc0             or ax, ax
  0426C3  25D3: 7c07             jl 0x25dc
  0426C5  25D5: 8bd8             mov bx, ax
  0426C7  25D7: 808ff29501       or byte ptr [bx - 0x6a0e], 1
  0426CC  25DC: ff46ee           inc word ptr [bp - 0x12]
  0426CF  25DF: 8b46ee           mov ax, word ptr [bp - 0x12]
  0426D2  25E2: 39069a53         cmp word ptr [0x539a], ax
  0426D6  25E6: 7fc8             jg 0x25b0
  0426D8  25E8: c746ee0000       mov word ptr [bp - 0x12], 0
  0426DD  25ED: 8b5eee           mov bx, word ptr [bp - 0x12]
  0426E0  25F0: d1e3             shl bx, 1
  0426E2  25F2: 83bf5e9408       cmp word ptr [bx - 0x6ba2], 8
  0426E7  25F7: 7c14             jl 0x260d
  0426E9  25F9: 8b7606           mov si, word ptr [bp + 6]
  0426EC  25FC: c1e604           shl si, 4
  0426EF  25FF: 8b5eee           mov bx, word ptr [bp - 0x12]
  0426F2  2602: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  0426F7  2607: 7504             jne 0x260d
  0426F9  2609: ff065096         inc word ptr [0x9650]
  0426FD  260D: ff46ee           inc word ptr [bp - 0x12]
  042700  2610: 837eee10         cmp word ptr [bp - 0x12], 0x10
  042704  2614: 7cd7             jl 0x25ed
  042706  2616: 8b5e06           mov bx, word ptr [bp + 6]
  042709  2619: 80bf989200       cmp byte ptr [bx - 0x6d68], 0
  04270E  261E: 7413             je 0x2633
  042710  2620: 8a8f9892         mov cl, byte ptr [bx - 0x6d68]
  042714  2624: 2aed             sub ch, ch
  042716  2626: d1e3             shl bx, 1
  042718  2628: 8b874e94         mov ax, word ptr [bx - 0x6bb2]
  04271C  262C: 99               cdq 
  04271D  262D: f7f9             idiv cx
  04271F  262F: 89874e94         mov word ptr [bx - 0x6bb2], ax
  042723  2633: 5e               pop si
  042724  2634: c9               leave 
  042725  2635: cb               retf 

; ---- func_042726  size=176  insns=60  prologue=ENTER 0x000A,0  terminal=RETF ----
  042726  2636: c80a0000         enter 0xa, 0
  04272A  263A: c746fc0000       mov word ptr [bp - 4], 0
  04272F  263F: 8b5efc           mov bx, word ptr [bp - 4]
  042732  2642: c687309400       mov byte ptr [bx - 0x6bd0], 0
  042737  2647: ff46fc           inc word ptr [bp - 4]
  04273A  264A: 837efc1d         cmp word ptr [bp - 4], 0x1d
  04273E  264E: 7cef             jl 0x263f
  042740  2650: c746f80000       mov word ptr [bp - 8], 0
  042745  2655: eb30             jmp 0x2687
  042747  2657: 90               nop 
  042748  2658: 6bd81c           imul bx, ax, 0x1c
  04274B  265B: 8a874731         mov al, byte ptr [bx + 0x3147]
  04274F  265F: 240f             and al, 0xf
  042751  2661: 3a4606           cmp al, byte ptr [bp + 6]
  042754  2664: 751e             jne 0x2684
  042756  2666: ff76f8           push word ptr [bp - 8]
  042759  2669: 9a780b1f18       lcall 0x181f, 0xb78
  04275E  266E: 83c402           add sp, 2
  042761  2671: 0bc0             or ax, ax
  042763  2673: 7c0f             jl 0x2684
  042765  2675: 6b5ef81c         imul bx, word ptr [bp - 8], 0x1c
  042769  2679: 8a875b31         mov al, byte ptr [bx + 0x315b]
  04276D  267D: 98               cwde 
  04276E  267E: 8bd8             mov bx, ax
  042770  2680: fe873094         inc byte ptr [bx - 0x6bd0]
  042774  2684: ff46f8           inc word ptr [bp - 8]
  042777  2687: 8b46f8           mov ax, word ptr [bp - 8]
  04277A  268A: 39069c53         cmp word ptr [0x539c], ax
  04277E  268E: 7fc8             jg 0x2658
  042780  2690: c746f60000       mov word ptr [bp - 0xa], 0
  042785  2695: eb28             jmp 0x26bf
  042787  2697: 90               nop 
  042788  2698: ff46fe           inc word ptr [bp - 2]
  04278B  269B: 8b1e4285         mov bx, word ptr [0x8542]
  04278F  269F: 8a471f           mov al, byte ptr [bx + 0x1f]
  042792  26A2: 98               cwde 
  042793  26A3: 3b46fe           cmp ax, word ptr [bp - 2]
  042796  26A6: 7e14             jle 0x26bc
  042798  26A8: ff76fe           push word ptr [bp - 2]
  04279B  26AB: 9a540c1f18       lcall 0x181f, 0xc54
  0427A0  26B0: 83c402           add sp, 2
  0427A3  26B3: 8bd8             mov bx, ax
  0427A5  26B5: fe873094         inc byte ptr [bx - 0x6bd0]
  0427A9  26B9: ebdd             jmp 0x2698
  0427AB  26BB: 90               nop 
  0427AC  26BC: ff46f6           inc word ptr [bp - 0xa]
  0427AF  26BF: 8b46f6           mov ax, word ptr [bp - 0xa]
  0427B2  26C2: 39069e53         cmp word ptr [0x539e], ax
  0427B6  26C6: 7e1c             jle 0x26e4
  0427B8  26C8: 50               push ax
  0427B9  26C9: 9ae6091f18       lcall 0x181f, 0x9e6
  0427BE  26CE: 83c402           add sp, 2
  0427C1  26D1: 8a4606           mov al, byte ptr [bp + 6]
  0427C4  26D4: 8b1e4285         mov bx, word ptr [0x8542]
  0427C8  26D8: 38471a           cmp byte ptr [bx + 0x1a], al
  0427CB  26DB: 75df             jne 0x26bc
  0427CD  26DD: c746fe0000       mov word ptr [bp - 2], 0
  0427D2  26E2: ebb7             jmp 0x269b
  0427D4  26E4: c9               leave 
  0427D5  26E5: cb               retf 

; ---- func_0427D6  size=239  insns=82  prologue=ENTER 0x0008,0  terminal=RETF ----
  0427D6  26E6: c8080000         enter 8, 0
  0427DA  26EA: 56               push si
  0427DB  26EB: 8b4606           mov ax, word ptr [bp + 6]
  0427DE  26EE: 050400           add ax, 4
  0427E1  26F1: 8946f8           mov word ptr [bp - 8], ax
  0427E4  26F4: 2ac0             sub al, al
  0427E6  26F6: 8b5e06           mov bx, word ptr [bp + 6]
  0427E9  26F9: 88878491         mov byte ptr [bx - 0x6e7c], al
  0427ED  26FD: 88872296         mov byte ptr [bx - 0x69de], al
  0427F1  2701: 88872a96         mov byte ptr [bx - 0x69d6], al
  0427F5  2705: c746fa0000       mov word ptr [bp - 6], 0
  0427FA  270A: 2ac0             sub al, al
  0427FC  270C: 8b7606           mov si, word ptr [bp + 6]
  0427FF  270F: c1e604           shl si, 4
  042802  2712: 8b5efa           mov bx, word ptr [bp - 6]
  042805  2715: 8880cc91         mov byte ptr [bx + si - 0x6e34], al
  042809  2719: 88877e94         mov byte ptr [bx - 0x6b82], al
  04280D  271D: ff46fa           inc word ptr [bp - 6]
  042810  2720: 837efa10         cmp word ptr [bp - 6], 0x10
  042814  2724: 7ce4             jl 0x270a
  042816  2726: c746fa0000       mov word ptr [bp - 6], 0
  04281B  272B: eb3e             jmp 0x276b
  04281D  272D: 90               nop 
  04281E  272E: 50               push ax
  04281F  272F: 9a4c0a1f18       lcall 0x181f, 0xa4c
  042824  2734: 83c402           add sp, 2
  042827  2737: 8a46f8           mov al, byte ptr [bp - 8]
  04282A  273A: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04282E  273E: 384702           cmp byte ptr [bx + 2], al
  042831  2741: 7525             jne 0x2768
  042833  2743: 8b7606           mov si, word ptr [bp + 6]
  042836  2746: fe842a96         inc byte ptr [si - 0x69d6]
  04283A  274A: 8a4704           mov al, byte ptr [bx + 4]
  04283D  274D: 00842296         add byte ptr [si - 0x69de], al
  042841  2751: 8a4701           mov al, byte ptr [bx + 1]
  042844  2754: 2ae4             sub ah, ah
  042846  2756: 50               push ax
  042847  2757: 8a07             mov al, byte ptr [bx]
  042849  2759: 50               push ax
  04284A  275A: 9a22071f18       lcall 0x181f, 0x722
  04284F  275F: 83c404           add sp, 4
  042852  2762: 8bd8             mov bx, ax
  042854  2764: fe877e94         inc byte ptr [bx - 0x6b82]
  042858  2768: ff46fa           inc word ptr [bp - 6]
  04285B  276B: 8b46fa           mov ax, word ptr [bp - 6]
  04285E  276E: 39069a53         cmp word ptr [0x539a], ax
  042862  2772: 7fba             jg 0x272e
  042864  2774: c746fa0000       mov word ptr [bp - 6], 0
  042869  2779: eb4e             jmp 0x27c9
  04286B  277B: 90               nop 
  04286C  277C: 6bd81c           imul bx, ax, 0x1c
  04286F  277F: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  042873  2783: 80e10f           and cl, 0xf
  042876  2786: 3a4ef8           cmp cl, byte ptr [bp - 8]
  042879  2789: 753b             jne 0x27c6
  04287B  278B: 6a01             push 1
  04287D  278D: 50               push ax
  04287E  278E: 9ac8091f18       lcall 0x181f, 0x9c8
  042883  2793: 83c404           add sp, 4
  042886  2796: 8946fc           mov word ptr [bp - 4], ax
  042889  2799: 8b5e06           mov bx, word ptr [bp + 6]
  04288C  279C: 81c38491         add bx, 0x9184
  042890  27A0: e893f8           call 0x2036
  042893  27A3: ff76fa           push word ptr [bp - 6]
  042896  27A6: 9a1c081f18       lcall 0x181f, 0x81c
  04289B  27AB: 83c402           add sp, 2
  04289E  27AE: 0bc0             or ax, ax
  0428A0  27B0: 7c14             jl 0x27c6
  0428A2  27B2: 8bd8             mov bx, ax
  0428A4  27B4: 8b4606           mov ax, word ptr [bp + 6]
  0428A7  27B7: c1e004           shl ax, 4
  0428AA  27BA: 03d8             add bx, ax
  0428AC  27BC: 81c3cc91         add bx, 0x91cc
  0428B0  27C0: 8b46fc           mov ax, word ptr [bp - 4]
  0428B3  27C3: e870f8           call 0x2036
  0428B6  27C6: ff46fa           inc word ptr [bp - 6]
  0428B9  27C9: 8b46fa           mov ax, word ptr [bp - 6]
  0428BC  27CC: 39069c53         cmp word ptr [0x539c], ax
  0428C0  27D0: 7faa             jg 0x277c
  0428C2  27D2: 5e               pop si
  0428C3  27D3: c9               leave 
  0428C4  27D4: cb               retf 
