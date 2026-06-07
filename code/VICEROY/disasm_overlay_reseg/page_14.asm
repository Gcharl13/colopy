; ============================================================
; VICEROY.EXE overlay page 0x14 (record 19) -- RE-SEGMENTED
; file_offset (disk image) = 0x0633E0
; code_offset (first insn) = 0x063880
; code_end (next reloc hdr)= 0x066680  [resident size 736 para -> nominal_end 0x0661E0; on-disk code spills past it]
; reloc_count = 285  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x0633E0)
; functions in page = 13
; ============================================================

; ---- func_063880  size=855  insns=294  prologue=ENTER 0x002E,0  terminal=RETF ----
  063880  04A0: c82e0000         enter 0x2e, 0
  063884  04A4: 56               push si
  063885  04A5: 2bc0             sub ax, ax
  063887  04A7: 8946f6           mov word ptr [bp - 0xa], ax
  06388A  04AA: a1c623           mov ax, word ptr [0x23c6]
  06388D  04AD: 8b16c823         mov dx, word ptr [0x23c8]
  063891  04B1: 8946dc           mov word ptr [bp - 0x24], ax
  063894  04B4: 8956de           mov word ptr [bp - 0x22], dx
  063897  04B7: 80c480           add ah, 0x80
  06389A  04BA: 8946d4           mov word ptr [bp - 0x2c], ax
  06389D  04BD: 8956d6           mov word ptr [bp - 0x2a], dx
  0638A0  04C0: ff36be85         push word ptr [0x85be]
  0638A4  04C4: ff36bc85         push word ptr [0x85bc]
  0638A8  04C8: ff36ba85         push word ptr [0x85ba]
  0638AC  04CC: ff36b885         push word ptr [0x85b8]
  0638B0  04D0: 2ac0             sub al, al
  0638B2  04D2: 9a84041f18       lcall 0x181f, 0x484
  0638B7  04D7: c746e40100       mov word ptr [bp - 0x1c], 1
  0638BC  04DC: e9a602           jmp 0x785
  0638BF  04DF: 90               nop 
  0638C0  04E0: c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  0638C5  04E5: eb55             jmp 0x53c
  0638C7  04E7: 90               nop 
  0638C8  04E8: ff46fe           inc word ptr [bp - 2]
  0638CB  04EB: 8b46fe           mov ax, word ptr [bp - 2]
  0638CE  04EE: 39063a85         cmp word ptr [0x853a], ax
  0638D2  04F2: 7c2a             jl 0x51e
  0638D4  04F4: a13a85           mov ax, word ptr [0x853a]
  0638D7  04F7: f76ef8           imul word ptr [bp - 8]
  0638DA  04FA: 8bd8             mov bx, ax
  0638DC  04FC: 035efe           add bx, word ptr [bp - 2]
  0638DF  04FF: d1e3             shl bx, 1
  0638E1  0501: 035ed4           add bx, word ptr [bp - 0x2c]
  0638E4  0504: 8e46d6           mov es, word ptr [bp - 0x2a]
  0638E7  0507: 895ee0           mov word ptr [bp - 0x20], bx
  0638EA  050A: 8c46e2           mov word ptr [bp - 0x1e], es
  0638ED  050D: 8b46f0           mov ax, word ptr [bp - 0x10]
  0638F0  0510: 263907           cmp word ptr es:[bx], ax
  0638F3  0513: 75d3             jne 0x4e8
  0638F5  0515: 8b46e8           mov ax, word ptr [bp - 0x18]
  0638F8  0518: 268907           mov word ptr es:[bx], ax
  0638FB  051B: ebcb             jmp 0x4e8
  0638FD  051D: 90               nop 
  0638FE  051E: ff46f8           inc word ptr [bp - 8]
  063901  0521: 8b46e6           mov ax, word ptr [bp - 0x1a]
  063904  0524: 3946f8           cmp word ptr [bp - 8], ax
  063907  0527: 7f07             jg 0x530
  063909  0529: c746fe0100       mov word ptr [bp - 2], 1
  06390E  052E: ebbb             jmp 0x4eb
  063910  0530: 8b46e8           mov ax, word ptr [bp - 0x18]
  063913  0533: 8946fc           mov word ptr [bp - 4], ax
  063916  0536: 8946f4           mov word ptr [bp - 0xc], ax
  063919  0539: ff46f2           inc word ptr [bp - 0xe]
  06391C  053C: 837ef201         cmp word ptr [bp - 0xe], 1
  063920  0540: 7f64             jg 0x5a6
  063922  0542: 8b46e6           mov ax, word ptr [bp - 0x1a]
  063925  0545: 48               dec ax
  063926  0546: f72e3a85         imul word ptr [0x853a]
  06392A  054A: 8bd8             mov bx, ax
  06392C  054C: 035eec           add bx, word ptr [bp - 0x14]
  06392F  054F: 035ef2           add bx, word ptr [bp - 0xe]
  063932  0552: d1e3             shl bx, 1
  063934  0554: c476d4           les si, ptr [bp - 0x2c]
  063937  0557: 268b00           mov ax, word ptr es:[bx + si]
  06393A  055A: 8946fc           mov word ptr [bp - 4], ax
  06393D  055D: 0bc0             or ax, ax
  06393F  055F: 74d8             je 0x539
  063941  0561: 8946e8           mov word ptr [bp - 0x18], ax
  063944  0564: 837ef400         cmp word ptr [bp - 0xc], 0
  063948  0568: 74c6             je 0x530
  06394A  056A: 3b46f4           cmp ax, word ptr [bp - 0xc]
  06394D  056D: 74c1             je 0x530
  06394F  056F: 7d03             jge 0x574
  063951  0571: 8b46f4           mov ax, word ptr [bp - 0xc]
  063954  0574: 8946f0           mov word ptr [bp - 0x10], ax
  063957  0577: 8bd8             mov bx, ax
  063959  0579: d1e3             shl bx, 1
  06395B  057B: c476dc           les si, ptr [bp - 0x24]
  06395E  057E: 268b00           mov ax, word ptr es:[bx + si]
  063961  0581: 8bcb             mov cx, bx
  063963  0583: 8b5efc           mov bx, word ptr [bp - 4]
  063966  0586: 3b5ef4           cmp bx, word ptr [bp - 0xc]
  063969  0589: 7e03             jle 0x58e
  06396B  058B: 8b5ef4           mov bx, word ptr [bp - 0xc]
  06396E  058E: 895ee8           mov word ptr [bp - 0x18], bx
  063971  0591: d1e3             shl bx, 1
  063973  0593: 260100           add word ptr es:[bx + si], ax
  063976  0596: 8bd9             mov bx, cx
  063978  0598: 26c7000000       mov word ptr es:[bx + si], 0
  06397D  059D: c746f80100       mov word ptr [bp - 8], 1
  063982  05A2: e97cff           jmp 0x521
  063985  05A5: 90               nop 
  063986  05A6: 837ef400         cmp word ptr [bp - 0xc], 0
  06398A  05AA: 7561             jne 0x60d
  06398C  05AC: 837efa00         cmp word ptr [bp - 6], 0
  063990  05B0: 7555             jne 0x607
  063992  05B2: c746d20000       mov word ptr [bp - 0x2e], 0
  063997  05B7: 837ee601         cmp word ptr [bp - 0x1a], 1
  06399B  05BB: 740b             je 0x5c8
  06399D  05BD: a13c85           mov ax, word ptr [0x853c]
  0639A0  05C0: 2b46e6           sub ax, word ptr [bp - 0x1a]
  0639A3  05C3: 3d0200           cmp ax, 2
  0639A6  05C6: 750b             jne 0x5d3
  0639A8  05C8: 837ee400         cmp word ptr [bp - 0x1c], 0
  0639AC  05CC: 7505             jne 0x5d3
  0639AE  05CE: c746d21000       mov word ptr [bp - 0x2e], 0x10
  0639B3  05D3: ff46d2           inc word ptr [bp - 0x2e]
  0639B6  05D6: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  0639B9  05D9: d1e3             shl bx, 1
  0639BB  05DB: c476dc           les si, ptr [bp - 0x24]
  0639BE  05DE: 26833800         cmp word ptr es:[bx + si], 0
  0639C2  05E2: 7407             je 0x5eb
  0639C4  05E4: 817ed20240       cmp word ptr [bp - 0x2e], 0x4002
  0639C9  05E9: 7ce8             jl 0x5d3
  0639CB  05EB: 817ed20040       cmp word ptr [bp - 0x2e], 0x4000
  0639D0  05F0: 7c15             jl 0x607
  0639D2  05F2: c746d2ff3f       mov word ptr [bp - 0x2e], 0x3fff
  0639D7  05F7: 68461e           push 0x1e46
  0639DA  05FA: 9a12071d0d       lcall 0xd1d, 0x712
  0639DF  05FF: 83c402           add sp, 2
  0639E2  0602: 9ae0031f18       lcall 0x181f, 0x3e0
  0639E7  0607: 8b46d2           mov ax, word ptr [bp - 0x2e]
  0639EA  060A: 8946f4           mov word ptr [bp - 0xc], ax
  0639ED  060D: a13a85           mov ax, word ptr [0x853a]
  0639F0  0610: f76ee6           imul word ptr [bp - 0x1a]
  0639F3  0613: 8bd8             mov bx, ax
  0639F5  0615: 035eec           add bx, word ptr [bp - 0x14]
  0639F8  0618: d1e3             shl bx, 1
  0639FA  061A: 035ed4           add bx, word ptr [bp - 0x2c]
  0639FD  061D: 8e46d6           mov es, word ptr [bp - 0x2a]
  063A00  0620: 895ee0           mov word ptr [bp - 0x20], bx
  063A03  0623: 8c46e2           mov word ptr [bp - 0x1e], es
  063A06  0626: 8b46f4           mov ax, word ptr [bp - 0xc]
  063A09  0629: 268907           mov word ptr es:[bx], ax
  063A0C  062C: 8bd8             mov bx, ax
  063A0E  062E: d1e3             shl bx, 1
  063A10  0630: c476dc           les si, ptr [bp - 0x24]
  063A13  0633: 26ff00           inc word ptr es:[bx + si]
  063A16  0636: c746fa0100       mov word ptr [bp - 6], 1
  063A1B  063B: ff4eec           dec word ptr [bp - 0x14]
  063A1E  063E: 837eec01         cmp word ptr [bp - 0x14], 1
  063A22  0642: 7c32             jl 0x676
  063A24  0644: ff76e6           push word ptr [bp - 0x1a]
  063A27  0647: ff76ec           push word ptr [bp - 0x14]
  063A2A  064A: 9a02031f18       lcall 0x181f, 0x302
  063A2F  064F: 83c404           add sp, 4
  063A32  0652: 0bc0             or ax, ax
  063A34  0654: 7416             je 0x66c
  063A36  0656: ff76e6           push word ptr [bp - 0x1a]
  063A39  0659: ff76ec           push word ptr [bp - 0x14]
  063A3C  065C: 9a68071f18       lcall 0x181f, 0x768
  063A41  0661: 83c404           add sp, 4
  063A44  0664: 3b46e4           cmp ax, word ptr [bp - 0x1c]
  063A47  0667: 7503             jne 0x66c
  063A49  0669: e974fe           jmp 0x4e0
  063A4C  066C: 2bc0             sub ax, ax
  063A4E  066E: 8946fa           mov word ptr [bp - 6], ax
  063A51  0671: 8946f4           mov word ptr [bp - 0xc], ax
  063A54  0674: ebc5             jmp 0x63b
  063A56  0676: 9aac031f18       lcall 0x181f, 0x3ac
  063A5B  067B: ff46e6           inc word ptr [bp - 0x1a]
  063A5E  067E: a13c85           mov ax, word ptr [0x853c]
  063A61  0681: 48               dec ax
  063A62  0682: 3b46e6           cmp ax, word ptr [bp - 0x1a]
  063A65  0685: 7e0b             jle 0x692
  063A67  0687: a13a85           mov ax, word ptr [0x853a]
  063A6A  068A: 48               dec ax
  063A6B  068B: 48               dec ax
  063A6C  068C: 8946ec           mov word ptr [bp - 0x14], ax
  063A6F  068F: ebad             jmp 0x63e
  063A71  0691: 90               nop 
  063A72  0692: 8b46d4           mov ax, word ptr [bp - 0x2c]
  063A75  0695: 8b56d6           mov dx, word ptr [bp - 0x2a]
  063A78  0698: 8946e0           mov word ptr [bp - 0x20], ax
  063A7B  069B: 8956e2           mov word ptr [bp - 0x1e], dx
  063A7E  069E: a16401           mov ax, word ptr [0x164]
  063A81  06A1: 8b166601         mov dx, word ptr [0x166]
  063A85  06A5: 8946d8           mov word ptr [bp - 0x28], ax
  063A88  06A8: 8956da           mov word ptr [bp - 0x26], dx
  063A8B  06AB: c746e60000       mov word ptr [bp - 0x1a], 0
  063A90  06B0: e9bf00           jmp 0x772
  063A93  06B3: 90               nop 
  063A94  06B4: c45ee0           les bx, ptr [bp - 0x20]
  063A97  06B7: 268b1f           mov bx, word ptr es:[bx]
  063A9A  06BA: d1e3             shl bx, 1
  063A9C  06BC: 8e46de           mov es, word ptr [bp - 0x22]
  063A9F  06BF: 268b00           mov ax, word ptr es:[bx + si]
  063AA2  06C2: f7d0             not ax
  063AA4  06C4: 40               inc ax
  063AA5  06C5: c45ee0           les bx, ptr [bp - 0x20]
  063AA8  06C8: 268907           mov word ptr es:[bx], ax
  063AAB  06CB: eb54             jmp 0x721
  063AAD  06CD: 90               nop 
  063AAE  06CE: c746d20000       mov word ptr [bp - 0x2e], 0
  063AB3  06D3: ff46d2           inc word ptr [bp - 0x2e]
  063AB6  06D6: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  063AB9  06D9: d1e3             shl bx, 1
  063ABB  06DB: 26833800         cmp word ptr es:[bx + si], 0
  063ABF  06DF: 75f2             jne 0x6d3
  063AC1  06E1: 837ed20f         cmp word ptr [bp - 0x2e], 0xf
  063AC5  06E5: 7f27             jg 0x70e
  063AC7  06E7: c45ee0           les bx, ptr [bp - 0x20]
  063ACA  06EA: 268b1f           mov bx, word ptr es:[bx]
  063ACD  06ED: d1e3             shl bx, 1
  063ACF  06EF: 8e46de           mov es, word ptr [bp - 0x22]
  063AD2  06F2: 268b00           mov ax, word ptr es:[bx + si]
  063AD5  06F5: 8bcb             mov cx, bx
  063AD7  06F7: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  063ADA  06FA: d1e3             shl bx, 1
  063ADC  06FC: 268900           mov word ptr es:[bx + si], ax
  063ADF  06FF: 8b46d2           mov ax, word ptr [bp - 0x2e]
  063AE2  0702: f7d8             neg ax
  063AE4  0704: 8bd9             mov bx, cx
  063AE6  0706: 268900           mov word ptr es:[bx + si], ax
  063AE9  0709: 8b46d2           mov ax, word ptr [bp - 0x2e]
  063AEC  070C: ebb7             jmp 0x6c5
  063AEE  070E: 8a4ee4           mov cl, byte ptr [bp - 0x1c]
  063AF1  0711: b80100           mov ax, 1
  063AF4  0714: d3e0             shl ax, cl
  063AF6  0716: 0946f6           or word ptr [bp - 0xa], ax
  063AF9  0719: c45ee0           les bx, ptr [bp - 0x20]
  063AFC  071C: 26c7070f00       mov word ptr es:[bx], 0xf
  063B01  0721: c45ee0           les bx, ptr [bp - 0x20]
  063B04  0724: 268a07           mov al, byte ptr es:[bx]
  063B07  0727: c45ed8           les bx, ptr [bp - 0x28]
  063B0A  072A: 268807           mov byte ptr es:[bx], al
  063B0D  072D: 8346e002         add word ptr [bp - 0x20], 2
  063B11  0731: ff46d8           inc word ptr [bp - 0x28]
  063B14  0734: ff46ec           inc word ptr [bp - 0x14]
  063B17  0737: a13a85           mov ax, word ptr [0x853a]
  063B1A  073A: 3946ec           cmp word ptr [bp - 0x14], ax
  063B1D  073D: 7d2b             jge 0x76a
  063B1F  073F: c45ee0           les bx, ptr [bp - 0x20]
  063B22  0742: 26833f00         cmp word ptr es:[bx], 0
  063B26  0746: 74e5             je 0x72d
  063B28  0748: 26833f0f         cmp word ptr es:[bx], 0xf
  063B2C  074C: 76d3             jbe 0x721
  063B2E  074E: 268b1f           mov bx, word ptr es:[bx]
  063B31  0751: d1e3             shl bx, 1
  063B33  0753: c476dc           les si, ptr [bp - 0x24]
  063B36  0756: 26833800         cmp word ptr es:[bx + si], 0
  063B3A  075A: 7e03             jle 0x75f
  063B3C  075C: e96fff           jmp 0x6ce
  063B3F  075F: 7f03             jg 0x764
  063B41  0761: e950ff           jmp 0x6b4
  063B44  0764: 268b00           mov ax, word ptr es:[bx + si]
  063B47  0767: e95bff           jmp 0x6c5
  063B4A  076A: 9aac031f18       lcall 0x181f, 0x3ac
  063B4F  076F: ff46e6           inc word ptr [bp - 0x1a]
  063B52  0772: 8b46e6           mov ax, word ptr [bp - 0x1a]
  063B55  0775: 39063c85         cmp word ptr [0x853c], ax
  063B59  0779: 7e07             jle 0x782
  063B5B  077B: c746ec0000       mov word ptr [bp - 0x14], 0
  063B60  0780: ebb5             jmp 0x737
  063B62  0782: ff4ee4           dec word ptr [bp - 0x1c]
  063B65  0785: 837ee400         cmp word ptr [bp - 0x1c], 0
  063B69  0789: 7c41             jl 0x7cc
  063B6B  078B: 680080           push 0x8000
  063B6E  078E: 6a00             push 0
  063B70  0790: ff76de           push word ptr [bp - 0x22]
  063B73  0793: ff76dc           push word ptr [bp - 0x24]
  063B76  0796: 9afa111d0d       lcall 0xd1d, 0x11fa
  063B7B  079B: 83c408           add sp, 8
  063B7E  079E: a13c85           mov ax, word ptr [0x853c]
  063B81  07A1: f72e3a85         imul word ptr [0x853a]
  063B85  07A5: d1e0             shl ax, 1
  063B87  07A7: 50               push ax
  063B88  07A8: 6a00             push 0
  063B8A  07AA: ff76d6           push word ptr [bp - 0x2a]
  063B8D  07AD: ff76d4           push word ptr [bp - 0x2c]
  063B90  07B0: 9afa111d0d       lcall 0xd1d, 0x11fa
  063B95  07B5: 83c408           add sp, 8
  063B98  07B8: 2bc0             sub ax, ax
  063B9A  07BA: 8946d2           mov word ptr [bp - 0x2e], ax
  063B9D  07BD: 8946f4           mov word ptr [bp - 0xc], ax
  063BA0  07C0: 8946fa           mov word ptr [bp - 6], ax
  063BA3  07C3: c746e60100       mov word ptr [bp - 0x1a], 1
  063BA8  07C8: e9b3fe           jmp 0x67e
  063BAB  07CB: 90               nop 
  063BAC  07CC: c746ea0000       mov word ptr [bp - 0x16], 0
  063BB1  07D1: 8e46de           mov es, word ptr [bp - 0x22]
  063BB4  07D4: 8b5eea           mov bx, word ptr [bp - 0x16]
  063BB7  07D7: d1e3             shl bx, 1
  063BB9  07D9: 8b76dc           mov si, word ptr [bp - 0x24]
  063BBC  07DC: 268b00           mov ax, word ptr es:[bx + si]
  063BBF  07DF: 8987c885         mov word ptr [bx - 0x7a38], ax
  063BC3  07E3: ff46ea           inc word ptr [bp - 0x16]
  063BC6  07E6: 837eea10         cmp word ptr [bp - 0x16], 0x10
  063BCA  07EA: 7ce8             jl 0x7d4
  063BCC  07EC: 9aac0a1f19       lcall 0x191f, 0xaac
  063BD1  07F1: 8b46f6           mov ax, word ptr [bp - 0xa]
  063BD4  07F4: 5e               pop si
  063BD5  07F5: c9               leave 
  063BD6  07F6: cb               retf 

; ---- func_063BD8  size=127  insns=53  prologue=ENTER 0x000A,0  terminal=RET imm16 ----
  063BD8  07F8: c80a0000         enter 0xa, 0
  063BDC  07FC: 53               push bx
  063BDD  07FD: 52               push dx
  063BDE  07FE: 50               push ax
  063BDF  07FF: 57               push di
  063BE0  0800: 56               push si
  063BE1  0801: c746fa0000       mov word ptr [bp - 6], 0
  063BE6  0806: c746f8ffff       mov word ptr [bp - 8], 0xffff
  063BEB  080B: 8bf8             mov di, ax
  063BED  080D: 8b46f0           mov ax, word ptr [bp - 0x10]
  063BF0  0810: 40               inc ax
  063BF1  0811: 3bc7             cmp ax, di
  063BF3  0813: 7c59             jl 0x86e
  063BF5  0815: 8b46f2           mov ax, word ptr [bp - 0xe]
  063BF8  0818: 837efa00         cmp word ptr [bp - 6], 0
  063BFC  081C: 7549             jne 0x867
  063BFE  081E: 8bf0             mov si, ax
  063C00  0820: 8b46f2           mov ax, word ptr [bp - 0xe]
  063C03  0823: 40               inc ax
  063C04  0824: 3bc6             cmp ax, si
  063C06  0826: 7c3f             jl 0x867
  063C08  0828: 56               push si
  063C09  0829: 57               push di
  063C0A  082A: 9a68071f18       lcall 0x181f, 0x768
  063C0F  082F: 83c404           add sp, 4
  063C12  0832: 3b4604           cmp ax, word ptr [bp + 4]
  063C15  0835: 7529             jne 0x860
  063C17  0837: 56               push si
  063C18  0838: 57               push di
  063C19  0839: 9ab4061f18       lcall 0x181f, 0x6b4
  063C1E  083E: 83c404           add sp, 4
  063C21  0841: 2ae4             sub ah, ah
  063C23  0843: 8946f8           mov word ptr [bp - 8], ax
  063C26  0846: 837e0400         cmp word ptr [bp + 4], 0
  063C2A  084A: 7405             je 0x851
  063C2C  084C: 3d0100           cmp ax, 1
  063C2F  084F: 750f             jne 0x860
  063C31  0851: 8b5ef4           mov bx, word ptr [bp - 0xc]
  063C34  0854: 893f             mov word ptr [bx], di
  063C36  0856: 8b5e06           mov bx, word ptr [bp + 6]
  063C39  0859: 8937             mov word ptr [bx], si
  063C3B  085B: c746fa0100       mov word ptr [bp - 6], 1
  063C40  0860: 46               inc si
  063C41  0861: 837efa00         cmp word ptr [bp - 6], 0
  063C45  0865: 74b9             je 0x820
  063C47  0867: 47               inc di
  063C48  0868: 837efa00         cmp word ptr [bp - 6], 0
  063C4C  086C: 749f             je 0x80d
  063C4E  086E: 8b46f8           mov ax, word ptr [bp - 8]
  063C51  0871: 5e               pop si
  063C52  0872: 5f               pop di
  063C53  0873: c9               leave 
  063C54  0874: c20400           ret 4

; ---- func_063C58  size=740  insns=283  prologue=ENTER 0x0022,0  terminal=RETF ----
  063C58  0878: c8220000         enter 0x22, 0
  063C5C  087C: 57               push di
  063C5D  087D: 56               push si
  063C5E  087E: c706d41d0100     mov word ptr [0x1dd4], 1
  063C64  0884: c746de0000       mov word ptr [bp - 0x22], 0
  063C69  0889: 837ede00         cmp word ptr [bp - 0x22], 0
  063C6D  088D: 7409             je 0x898
  063C6F  088F: bef686           mov si, 0x86f6
  063C72  0892: bf0100           mov di, 1
  063C75  0895: eb06             jmp 0x89d
  063C77  0897: 90               nop 
  063C78  0898: bee885           mov si, 0x85e8
  063C7B  089B: 2bff             sub di, di
  063C7D  089D: 680e01           push 0x10e
  063C80  08A0: 6a00             push 0
  063C82  08A2: 56               push si
  063C83  08A3: 9aae0d1d0d       lcall 0xd1d, 0xdae
  063C88  08A8: 83c406           add sp, 6
  063C8B  08AB: 2bc0             sub ax, ax
  063C8D  08AD: 8946f0           mov word ptr [bp - 0x10], ax
  063C90  08B0: 8946ea           mov word ptr [bp - 0x16], ax
  063C93  08B3: c746ee0100       mov word ptr [bp - 0x12], 1
  063C98  08B8: 897eec           mov word ptr [bp - 0x14], di
  063C9B  08BB: 8976e0           mov word ptr [bp - 0x20], si
  063C9E  08BE: c746fe0000       mov word ptr [bp - 2], 0
  063CA3  08C3: c746f40100       mov word ptr [bp - 0xc], 1
  063CA8  08C8: 8b46ee           mov ax, word ptr [bp - 0x12]
  063CAB  08CB: 8946f2           mov word ptr [bp - 0xe], ax
  063CAE  08CE: 8d46e6           lea ax, [bp - 0x1a]
  063CB1  08D1: 50               push ax
  063CB2  08D2: ff76ec           push word ptr [bp - 0x14]
  063CB5  08D5: 8b56f4           mov dx, word ptr [bp - 0xc]
  063CB8  08D8: 8956fa           mov word ptr [bp - 6], dx
  063CBB  08DB: 8b46ee           mov ax, word ptr [bp - 0x12]
  063CBE  08DE: 8d5ee8           lea bx, [bp - 0x18]
  063CC1  08E1: e814ff           call 0x7f8
  063CC4  08E4: 8946fc           mov word ptr [bp - 4], ax
  063CC7  08E7: 0bc0             or ax, ax
  063CC9  08E9: 7d03             jge 0x8ee
  063CCB  08EB: e9ca00           jmp 0x9b8
  063CCE  08EE: c746f80000       mov word ptr [bp - 8], 0
  063CD3  08F3: 8b5ef8           mov bx, word ptr [bp - 8]
  063CD6  08F6: 8a87be00         mov al, byte ptr [bx + 0xbe]
  063CDA  08FA: 98               cwde 
  063CDB  08FB: c1e002           shl ax, 2
  063CDE  08FE: 0346fa           add ax, word ptr [bp - 6]
  063CE1  0901: 8bf0             mov si, ax
  063CE3  0903: 50               push ax
  063CE4  0904: 8a87b400         mov al, byte ptr [bx + 0xb4]
  063CE8  0908: 98               cwde 
  063CE9  0909: 8bf8             mov di, ax
  063CEB  090B: c1e702           shl di, 2
  063CEE  090E: 037ef2           add di, word ptr [bp - 0xe]
  063CF1  0911: 57               push di
  063CF2  0912: 9a02031f18       lcall 0x181f, 0x302
  063CF7  0917: 83c404           add sp, 4
  063CFA  091A: 0bc0             or ax, ax
  063CFC  091C: 7503             jne 0x921
  063CFE  091E: e98b00           jmp 0x9ac
  063D01  0921: 8d46e2           lea ax, [bp - 0x1e]
  063D04  0924: 50               push ax
  063D05  0925: ff76ec           push word ptr [bp - 0x14]
  063D08  0928: 8bc7             mov ax, di
  063D0A  092A: 8bd6             mov dx, si
  063D0C  092C: 8d5ee4           lea bx, [bp - 0x1c]
  063D0F  092F: e8c6fe           call 0x7f8
  063D12  0932: 3b46fc           cmp ax, word ptr [bp - 4]
  063D15  0935: 7575             jne 0x9ac
  063D17  0937: ff76e2           push word ptr [bp - 0x1e]
  063D1A  093A: ff76ec           push word ptr [bp - 0x14]
  063D1D  093D: 6a09             push 9
  063D1F  093F: 8b46e8           mov ax, word ptr [bp - 0x18]
  063D22  0942: 8b56e6           mov dx, word ptr [bp - 0x1a]
  063D25  0945: 8b5ee4           mov bx, word ptr [bp - 0x1c]
  063D28  0948: 9a7e021f1a       lcall 0x1a1f, 0x27e
  063D2D  094D: 8bf0             mov si, ax
  063D2F  094F: 0bf6             or si, si
  063D31  0951: 7e59             jle 0x9ac
  063D33  0953: 83fe08           cmp si, 8
  063D36  0956: 7d54             jge 0x9ac
  063D38  0958: 8a4ef8           mov cl, byte ptr [bp - 8]
  063D3B  095B: b001             mov al, 1
  063D3D  095D: d2e0             shl al, cl
  063D3F  095F: 8b5efe           mov bx, word ptr [bp - 2]
  063D42  0962: 035ee0           add bx, word ptr [bp - 0x20]
  063D45  0965: 8b76ea           mov si, word ptr [bp - 0x16]
  063D48  0968: 0800             or byte ptr [bx + si], al
  063D4A  096A: 8b5ef8           mov bx, word ptr [bp - 8]
  063D4D  096D: 8a87b400         mov al, byte ptr [bx + 0xb4]
  063D51  0971: 98               cwde 
  063D52  0972: 8bf0             mov si, ax
  063D54  0974: 0376f0           add si, word ptr [bp - 0x10]
  063D57  0977: 8a87be00         mov al, byte ptr [bx + 0xbe]
  063D5B  097B: 98               cwde 
  063D5C  097C: 0346fe           add ax, word ptr [bp - 2]
  063D5F  097F: 8946f6           mov word ptr [bp - 0xa], ax
  063D62  0982: 0bf6             or si, si
  063D64  0984: 7c26             jl 0x9ac
  063D66  0986: 0bc0             or ax, ax
  063D68  0988: 7c22             jl 0x9ac
  063D6A  098A: 83fe0f           cmp si, 0xf
  063D6D  098D: 7d1d             jge 0x9ac
  063D6F  098F: 3d1200           cmp ax, 0x12
  063D72  0992: 7d18             jge 0x9ac
  063D74  0994: 8a4ef8           mov cl, byte ptr [bp - 8]
  063D77  0997: 80e9fc           sub cl, 0xfc
  063D7A  099A: 80e107           and cl, 7
  063D7D  099D: b001             mov al, 1
  063D7F  099F: d2e0             shl al, cl
  063D81  09A1: 6bde12           imul bx, si, 0x12
  063D84  09A4: 035ee0           add bx, word ptr [bp - 0x20]
  063D87  09A7: 8b76f6           mov si, word ptr [bp - 0xa]
  063D8A  09AA: 0800             or byte ptr [bx + si], al
  063D8C  09AC: ff46f8           inc word ptr [bp - 8]
  063D8F  09AF: 837ef804         cmp word ptr [bp - 8], 4
  063D93  09B3: 7d03             jge 0x9b8
  063D95  09B5: e93bff           jmp 0x8f3
  063D98  09B8: ff46fe           inc word ptr [bp - 2]
  063D9B  09BB: 8346f404         add word ptr [bp - 0xc], 4
  063D9F  09BF: 837ef449         cmp word ptr [bp - 0xc], 0x49
  063DA3  09C3: 7d03             jge 0x9c8
  063DA5  09C5: e906ff           jmp 0x8ce
  063DA8  09C8: 9aac031f18       lcall 0x181f, 0x3ac
  063DAD  09CD: 8346ea12         add word ptr [bp - 0x16], 0x12
  063DB1  09D1: ff46f0           inc word ptr [bp - 0x10]
  063DB4  09D4: 8346ee04         add word ptr [bp - 0x12], 4
  063DB8  09D8: 837eee3d         cmp word ptr [bp - 0x12], 0x3d
  063DBC  09DC: 7d03             jge 0x9e1
  063DBE  09DE: e9ddfe           jmp 0x8be
  063DC1  09E1: ff46de           inc word ptr [bp - 0x22]
  063DC4  09E4: 837ede02         cmp word ptr [bp - 0x22], 2
  063DC8  09E8: 7d03             jge 0x9ed
  063DCA  09EA: e99cfe           jmp 0x889
  063DCD  09ED: c706d41d0000     mov word ptr [0x1dd4], 0
  063DD3  09F3: 2bc0             sub ax, ax
  063DD5  09F5: bb5e94           mov bx, 0x945e
  063DD8  09F8: b91000           mov cx, 0x10
  063DDB  09FB: 8bfb             mov di, bx
  063DDD  09FD: 1e               push ds
  063DDE  09FE: 07               pop es
  063DDF  09FF: f3ab             rep stosw word ptr es:[di], ax
  063DE1  0A01: bbc885           mov bx, 0x85c8
  063DE4  0A04: b91000           mov cx, 0x10
  063DE7  0A07: 8bfb             mov di, bx
  063DE9  0A09: f3ab             rep stosw word ptr es:[di], ax
  063DEB  0A0B: 2bf6             sub si, si
  063DED  0A0D: 39063c85         cmp word ptr [0x853c], ax
  063DF1  0A11: 7c70             jl 0xa83
  063DF3  0A13: 8b3e3a85         mov di, word ptr [0x853a]
  063DF7  0A17: 4f               dec di
  063DF8  0A18: 785d             js 0xa77
  063DFA  0A1A: 8976fa           mov word ptr [bp - 6], si
  063DFD  0A1D: ff76fa           push word ptr [bp - 6]
  063E00  0A20: 57               push di
  063E01  0A21: 9a02031f18       lcall 0x181f, 0x302
  063E06  0A26: 83c404           add sp, 4
  063E09  0A29: 0bc0             or ax, ax
  063E0B  0A2B: 7444             je 0xa71
  063E0D  0A2D: ff76fa           push word ptr [bp - 6]
  063E10  0A30: 57               push di
  063E11  0A31: 9a8c071f18       lcall 0x181f, 0x78c
  063E16  0A36: 83c404           add sp, 4
  063E19  0A39: 8bf0             mov si, ax
  063E1B  0A3B: ff76fa           push word ptr [bp - 6]
  063E1E  0A3E: 57               push di
  063E1F  0A3F: 9a22071f18       lcall 0x181f, 0x722
  063E24  0A44: 83c404           add sp, 4
  063E27  0A47: 8946fe           mov word ptr [bp - 2], ax
  063E2A  0A4A: 0bc0             or ax, ax
  063E2C  0A4C: 7c23             jl 0xa71
  063E2E  0A4E: 83fe18           cmp si, 0x18
  063E31  0A51: 7d15             jge 0xa68
  063E33  0A53: 83e607           and si, 7
  063E36  0A56: 83fe02           cmp si, 2
  063E39  0A59: 7c0d             jl 0xa68
  063E3B  0A5B: 83fe05           cmp si, 5
  063E3E  0A5E: 7f08             jg 0xa68
  063E40  0A60: 8bd8             mov bx, ax
  063E42  0A62: d1e3             shl bx, 1
  063E44  0A64: ff875e94         inc word ptr [bx - 0x6ba2]
  063E48  0A68: 8b5efe           mov bx, word ptr [bp - 2]
  063E4B  0A6B: d1e3             shl bx, 1
  063E4D  0A6D: ff87c885         inc word ptr [bx - 0x7a38]
  063E51  0A71: 4f               dec di
  063E52  0A72: 79a9             jns 0xa1d
  063E54  0A74: 8b76fa           mov si, word ptr [bp - 6]
  063E57  0A77: 9aac031f18       lcall 0x181f, 0x3ac
  063E5C  0A7C: 46               inc si
  063E5D  0A7D: 39363c85         cmp word ptr [0x853c], si
  063E61  0A81: 7d90             jge 0xa13
  063E63  0A83: 5e               pop si
  063E64  0A84: 5f               pop di
  063E65  0A85: c9               leave 
  063E66  0A86: cb               retf 
  063E67  0A87: 90               nop 
  063E68  0A88: 57               push di
  063E69  0A89: 56               push si
  063E6A  0A8A: bf0100           mov di, 1
  063E6D  0A8D: 1e               push ds
  063E6E  0A8E: 685f1e           push 0x1e5f
  063E71  0A91: 8d1e5c1e         lea bx, [0x1e5c]
  063E75  0A95: 9a860e1f18       lcall 0x181f, 0xe86
  063E7A  0A9A: 8bf0             mov si, ax
  063E7C  0A9C: 0bf6             or si, si
  063E7E  0A9E: 7440             je 0xae0
  063E80  0AA0: 56               push si
  063E81  0AA1: 6a01             push 1
  063E83  0AA3: 680e01           push 0x10e
  063E86  0AA6: 68e885           push 0x85e8
  063E89  0AA9: 9a0c061d0d       lcall 0xd1d, 0x60c
  063E8E  0AAE: 83c408           add sp, 8
  063E91  0AB1: 0bc0             or ax, ax
  063E93  0AB3: 742b             je 0xae0
  063E95  0AB5: 56               push si
  063E96  0AB6: 6a01             push 1
  063E98  0AB8: 680e01           push 0x10e
  063E9B  0ABB: 68f686           push 0x86f6
  063E9E  0ABE: 9a0c061d0d       lcall 0xd1d, 0x60c
  063EA3  0AC3: 83c408           add sp, 8
  063EA6  0AC6: 0bc0             or ax, ax
  063EA8  0AC8: 7416             je 0xae0
  063EAA  0ACA: 56               push si
  063EAB  0ACB: 6a01             push 1
  063EAD  0ACD: 6a20             push 0x20
  063EAF  0ACF: 685e94           push 0x945e
  063EB2  0AD2: 9a0c061d0d       lcall 0xd1d, 0x60c
  063EB7  0AD7: 83c408           add sp, 8
  063EBA  0ADA: 0bc0             or ax, ax
  063EBC  0ADC: 7402             je 0xae0
  063EBE  0ADE: 2bff             sub di, di
  063EC0  0AE0: 0bf6             or si, si
  063EC2  0AE2: 7409             je 0xaed
  063EC4  0AE4: 56               push si
  063EC5  0AE5: 9af4031d0d       lcall 0xd1d, 0x3f4
  063ECA  0AEA: 83c402           add sp, 2
  063ECD  0AED: 8bc7             mov ax, di
  063ECF  0AEF: 5e               pop si
  063ED0  0AF0: 5f               pop di
  063ED1  0AF1: cb               retf 
  063ED2  0AF2: 57               push di
  063ED3  0AF3: 56               push si
  063ED4  0AF4: bf0100           mov di, 1
  063ED7  0AF7: 1e               push ds
  063ED8  0AF8: 68711e           push 0x1e71
  063EDB  0AFB: 8d1e6e1e         lea bx, [0x1e6e]
  063EDF  0AFF: 9a860e1f18       lcall 0x181f, 0xe86
  063EE4  0B04: 8bf0             mov si, ax
  063EE6  0B06: 0bf6             or si, si
  063EE8  0B08: 7440             je 0xb4a
  063EEA  0B0A: 56               push si
  063EEB  0B0B: 6a01             push 1
  063EED  0B0D: 680e01           push 0x10e
  063EF0  0B10: 68e885           push 0x85e8
  063EF3  0B13: 9a28051d0d       lcall 0xd1d, 0x528
  063EF8  0B18: 83c408           add sp, 8
  063EFB  0B1B: 0bc0             or ax, ax
  063EFD  0B1D: 742b             je 0xb4a
  063EFF  0B1F: 56               push si
  063F00  0B20: 6a01             push 1
  063F02  0B22: 680e01           push 0x10e
  063F05  0B25: 68f686           push 0x86f6
  063F08  0B28: 9a28051d0d       lcall 0xd1d, 0x528
  063F0D  0B2D: 83c408           add sp, 8
  063F10  0B30: 0bc0             or ax, ax
  063F12  0B32: 7416             je 0xb4a
  063F14  0B34: 56               push si
  063F15  0B35: 6a01             push 1
  063F17  0B37: 6a20             push 0x20
  063F19  0B39: 685e94           push 0x945e
  063F1C  0B3C: 9a28051d0d       lcall 0xd1d, 0x528
  063F21  0B41: 83c408           add sp, 8
  063F24  0B44: 0bc0             or ax, ax
  063F26  0B46: 7402             je 0xb4a
  063F28  0B48: 2bff             sub di, di
  063F2A  0B4A: 0bf6             or si, si
  063F2C  0B4C: 7409             je 0xb57
  063F2E  0B4E: 56               push si
  063F2F  0B4F: 9af4031d0d       lcall 0xd1d, 0x3f4
  063F34  0B54: 83c402           add sp, 2
  063F37  0B57: 8bc7             mov ax, di
  063F39  0B59: 5e               pop si
  063F3A  0B5A: 5f               pop di
  063F3B  0B5B: cb               retf 

; ---- func_063F3C  size=535  insns=199  prologue=ENTER 0x0014,0  terminal=RETF ----
  063F3C  0B5C: c8140000         enter 0x14, 0
  063F40  0B60: 57               push di
  063F41  0B61: 56               push si
  063F42  0B62: 2bf6             sub si, si
  063F44  0B64: 39363c85         cmp word ptr [0x853c], si
  063F48  0B68: 7f03             jg 0xb6d
  063F4A  0B6A: e90202           jmp 0xd6f
  063F4D  0B6D: 2bff             sub di, di
  063F4F  0B6F: 393e3a85         cmp word ptr [0x853a], di
  063F53  0B73: 7f03             jg 0xb78
  063F55  0B75: e9e801           jmp 0xd60
  063F58  0B78: 8976f4           mov word ptr [bp - 0xc], si
  063F5B  0B7B: c746f00000       mov word ptr [bp - 0x10], 0
  063F60  0B80: ff76f4           push word ptr [bp - 0xc]
  063F63  0B83: 57               push di
  063F64  0B84: 9a02031f18       lcall 0x181f, 0x302
  063F69  0B89: 83c404           add sp, 4
  063F6C  0B8C: 0bc0             or ax, ax
  063F6E  0B8E: 7503             jne 0xb93
  063F70  0B90: e93401           jmp 0xcc7
  063F73  0B93: ff76f4           push word ptr [bp - 0xc]
  063F76  0B96: 57               push di
  063F77  0B97: 9a68071f18       lcall 0x181f, 0x768
  063F7C  0B9C: 83c404           add sp, 4
  063F7F  0B9F: 0bc0             or ax, ax
  063F81  0BA1: 7403             je 0xba6
  063F83  0BA3: e92101           jmp 0xcc7
  063F86  0BA6: 897eec           mov word ptr [bp - 0x14], di
  063F89  0BA9: 8946f2           mov word ptr [bp - 0xe], ax
  063F8C  0BAC: 8b5ef2           mov bx, word ptr [bp - 0xe]
  063F8F  0BAF: 8a87de00         mov al, byte ptr [bx + 0xde]
  063F93  0BB3: 98               cwde 
  063F94  0BB4: 0346f4           add ax, word ptr [bp - 0xc]
  063F97  0BB7: 8946f8           mov word ptr [bp - 8], ax
  063F9A  0BBA: c746fc0000       mov word ptr [bp - 4], 0
  063F9F  0BBF: 50               push ax
  063FA0  0BC0: 8a87c800         mov al, byte ptr [bx + 0xc8]
  063FA4  0BC4: 98               cwde 
  063FA5  0BC5: 0346ec           add ax, word ptr [bp - 0x14]
  063FA8  0BC8: 8946f6           mov word ptr [bp - 0xa], ax
  063FAB  0BCB: 50               push ax
  063FAC  0BCC: 9a02031f18       lcall 0x181f, 0x302
  063FB1  0BD1: 83c404           add sp, 4
  063FB4  0BD4: 0bc0             or ax, ax
  063FB6  0BD6: 7503             jne 0xbdb
  063FB8  0BD8: e9dd00           jmp 0xcb8
  063FBB  0BDB: ff76f8           push word ptr [bp - 8]
  063FBE  0BDE: ff76f6           push word ptr [bp - 0xa]
  063FC1  0BE1: 9a8c071f18       lcall 0x181f, 0x78c
  063FC6  0BE6: 83c404           add sp, 4
  063FC9  0BE9: 8946ee           mov word ptr [bp - 0x12], ax
  063FCC  0BEC: ff76f8           push word ptr [bp - 8]
  063FCF  0BEF: ff76f6           push word ptr [bp - 0xa]
  063FD2  0BF2: 9a18071f18       lcall 0x181f, 0x718
  063FD7  0BF7: 83c404           add sp, 4
  063FDA  0BFA: 8946fa           mov word ptr [bp - 6], ax
  063FDD  0BFD: 40               inc ax
  063FDE  0BFE: 740e             je 0xc0e
  063FE0  0C00: 8b5efa           mov bx, word ptr [bp - 6]
  063FE3  0C03: 8a87b297         mov al, byte ptr [bx - 0x684e]
  063FE7  0C07: 2ae4             sub ah, ah
  063FE9  0C09: 8946fc           mov word ptr [bp - 4], ax
  063FEC  0C0C: eb4c             jmp 0xc5a
  063FEE  0C0E: 837eee19         cmp word ptr [bp - 0x12], 0x19
  063FF2  0C12: 753a             jne 0xc4e
  063FF4  0C14: ba0200           mov dx, 2
  063FF7  0C17: 2bf6             sub si, si
  063FF9  0C19: 8956fe           mov word ptr [bp - 2], dx
  063FFC  0C1C: 8bfa             mov di, dx
  063FFE  0C1E: 8a84be00         mov al, byte ptr [si + 0xbe]
  064002  0C22: 98               cwde 
  064003  0C23: 0346f8           add ax, word ptr [bp - 8]
  064006  0C26: 50               push ax
  064007  0C27: 8a84b400         mov al, byte ptr [si + 0xb4]
  06400B  0C2B: 98               cwde 
  06400C  0C2C: 0346f6           add ax, word ptr [bp - 0xa]
  06400F  0C2F: 50               push ax
  064010  0C30: 9a68071f18       lcall 0x181f, 0x768
  064015  0C35: 83c404           add sp, 4
  064018  0C38: 0bc0             or ax, ax
  06401A  0C3A: 7502             jne 0xc3e
  06401C  0C3C: 47               inc di
  06401D  0C3D: 47               inc di
  06401E  0C3E: 46               inc si
  06401F  0C3F: 83fe08           cmp si, 8
  064022  0C42: 7cda             jl 0xc1e
  064024  0C44: 897efe           mov word ptr [bp - 2], di
  064027  0C47: 8bd7             mov dx, di
  064029  0C49: c1ff02           sar di, 2
  06402C  0C4C: eb0e             jmp 0xc5c
  06402E  0C4E: 8b5eee           mov bx, word ptr [bp - 0x12]
  064031  0C51: c1e304           shl bx, 4
  064034  0C54: 8a87792f         mov al, byte ptr [bx + 0x2f79]
  064038  0C58: 2ae4             sub ah, ah
  06403A  0C5A: 8bf8             mov di, ax
  06403C  0C5C: ff76f8           push word ptr [bp - 8]
  06403F  0C5F: ff76f6           push word ptr [bp - 0xa]
  064042  0C62: 9a2c071f18       lcall 0x181f, 0x72c
  064047  0C67: 83c404           add sp, 4
  06404A  0C6A: a840             test al, 0x40
  06404C  0C6C: 7401             je 0xc6f
  06404E  0C6E: 47               inc di
  06404F  0C6F: ba0200           mov dx, 2
  064052  0C72: 837ef204         cmp word ptr [bp - 0xe], 4
  064056  0C76: 7d10             jge 0xc88
  064058  0C78: ba0500           mov dx, 5
  06405B  0C7B: 837eee19         cmp word ptr [bp - 0x12], 0x19
  06405F  0C7F: 7507             jne 0xc88
  064061  0C81: 8d4501           lea ax, [di + 1]
  064064  0C84: d1f8             sar ax, 1
  064066  0C86: 8bf8             mov di, ax
  064068  0C88: 837ef208         cmp word ptr [bp - 0xe], 8
  06406C  0C8C: 7d02             jge 0xc90
  06406E  0C8E: 42               inc dx
  06406F  0C8F: 42               inc dx
  064070  0C90: 837ef20c         cmp word ptr [bp - 0xe], 0xc
  064074  0C94: 7d01             jge 0xc97
  064076  0C96: 42               inc dx
  064077  0C97: 837ef214         cmp word ptr [bp - 0xe], 0x14
  06407B  0C9B: 7d01             jge 0xc9e
  06407D  0C9D: 42               inc dx
  06407E  0C9E: 8956fa           mov word ptr [bp - 6], dx
  064081  0CA1: 837ef214         cmp word ptr [bp - 0xe], 0x14
  064085  0CA5: 7505             jne 0xcac
  064087  0CA7: c746fa0400       mov word ptr [bp - 6], 4
  06408C  0CAC: 8b46fa           mov ax, word ptr [bp - 6]
  06408F  0CAF: f7ef             imul di
  064091  0CB1: d1f8             sar ax, 1
  064093  0CB3: 8bf8             mov di, ax
  064095  0CB5: 017ef0           add word ptr [bp - 0x10], di
  064098  0CB8: ff46f2           inc word ptr [bp - 0xe]
  06409B  0CBB: 837ef215         cmp word ptr [bp - 0xe], 0x15
  06409F  0CBF: 7d03             jge 0xcc4
  0640A1  0CC1: e9e8fe           jmp 0xbac
  0640A4  0CC4: 8b7eec           mov di, word ptr [bp - 0x14]
  0640A7  0CC7: ff76f4           push word ptr [bp - 0xc]
  0640AA  0CCA: 57               push di
  0640AB  0CCB: 9a120d1f18       lcall 0x181f, 0xd12
  0640B0  0CD0: 83c404           add sp, 4
  0640B3  0CD3: 8946fe           mov word ptr [bp - 2], ax
  0640B6  0CD6: 0bc0             or ax, ax
  0640B8  0CD8: 7419             je 0xcf3
  0640BA  0CDA: ff36bc8d         push word ptr [0x8dbc]
  0640BE  0CDE: ff36ba8d         push word ptr [0x8dba]
  0640C2  0CE2: 9ab4061f18       lcall 0x181f, 0x6b4
  0640C7  0CE7: 83c404           add sp, 4
  0640CA  0CEA: fec8             dec al
  0640CC  0CEC: 7405             je 0xcf3
  0640CE  0CEE: c746fe0000       mov word ptr [bp - 2], 0
  0640D3  0CF3: 837efe00         cmp word ptr [bp - 2], 0
  0640D7  0CF7: 7503             jne 0xcfc
  0640D9  0CF9: d17ef0           sar word ptr [bp - 0x10], 1
  0640DC  0CFC: 8b76f0           mov si, word ptr [bp - 0x10]
  0640DF  0CFF: ff76f4           push word ptr [bp - 0xc]
  0640E2  0D02: 57               push di
  0640E3  0D03: 9a8c071f18       lcall 0x181f, 0x78c
  0640E8  0D08: 83c404           add sp, 4
  0640EB  0D0B: 3d1b00           cmp ax, 0x1b
  0640EE  0D0E: 7502             jne 0xd12
  0640F0  0D10: 2bf6             sub si, si
  0640F2  0D12: ff76f4           push word ptr [bp - 0xc]
  0640F5  0D15: 57               push di
  0640F6  0D16: 9a8c071f18       lcall 0x181f, 0x78c
  0640FB  0D1B: 83c404           add sp, 4
  0640FE  0D1E: 3d1c00           cmp ax, 0x1c
  064101  0D21: 7502             jne 0xd25
  064103  0D23: d1fe             sar si, 1
  064105  0D25: 6a0f             push 0xf
  064107  0D27: 6a00             push 0
  064109  0D29: 8bc6             mov ax, si
  06410B  0D2B: b90a00           mov cx, 0xa
  06410E  0D2E: 99               cdq 
  06410F  0D2F: f7f9             idiv cx
  064111  0D31: 50               push ax
  064112  0D32: 9a5c031f18       lcall 0x181f, 0x35c
  064117  0D37: 83c406           add sp, 6
  06411A  0D3A: 8946fc           mov word ptr [bp - 4], ax
  06411D  0D3D: ff76f4           push word ptr [bp - 0xc]
  064120  0D40: 57               push di
  064121  0D41: 9a36071f18       lcall 0x181f, 0x736
  064126  0D46: 83c404           add sp, 4
  064129  0D49: 8ec2             mov es, dx
  06412B  0D4B: 8bd8             mov bx, ax
  06412D  0D4D: 8a46fc           mov al, byte ptr [bp - 4]
  064130  0D50: 268807           mov byte ptr es:[bx], al
  064133  0D53: 47               inc di
  064134  0D54: 393e3a85         cmp word ptr [0x853a], di
  064138  0D58: 7e03             jle 0xd5d
  06413A  0D5A: e91efe           jmp 0xb7b
  06413D  0D5D: 8b76f4           mov si, word ptr [bp - 0xc]
  064140  0D60: 9aac031f18       lcall 0x181f, 0x3ac
  064145  0D65: 46               inc si
  064146  0D66: 39363c85         cmp word ptr [0x853c], si
  06414A  0D6A: 7e03             jle 0xd6f
  06414C  0D6C: e9fefd           jmp 0xb6d
  06414F  0D6F: 5e               pop si
  064150  0D70: 5f               pop di
  064151  0D71: c9               leave 
  064152  0D72: cb               retf 

; ---- func_064154  size=151  insns=50  prologue=push bp;mov bp,sp  terminal=RET ----
  064154  0D74: 55               push bp
  064155  0D75: 8bec             mov bp, sp
  064157  0D77: 837e0400         cmp word ptr [bp + 4], 0
  06415B  0D7B: 7503             jne 0xd80
  06415D  0D7D: e98400           jmp 0xe04
  064160  0D80: 837e0600         cmp word ptr [bp + 6], 0
  064164  0D84: 747e             je 0xe04
  064166  0D86: a13a85           mov ax, word ptr [0x853a]
  064169  0D89: 394604           cmp word ptr [bp + 4], ax
  06416C  0D8C: 7d76             jge 0xe04
  06416E  0D8E: a13c85           mov ax, word ptr [0x853c]
  064171  0D91: 394606           cmp word ptr [bp + 6], ax
  064174  0D94: 7d6e             jge 0xe04
  064176  0D96: ff36c685         push word ptr [0x85c6]
  06417A  0D9A: ff36c485         push word ptr [0x85c4]
  06417E  0D9E: ff36c285         push word ptr [0x85c2]
  064182  0DA2: ff36c085         push word ptr [0x85c0]
  064186  0DA6: 8b4604           mov ax, word ptr [bp + 4]
  064189  0DA9: 8b5606           mov dx, word ptr [bp + 6]
  06418C  0DAC: bb0100           mov bx, 1
  06418F  0DAF: 9a72081f1a       lcall 0x1a1f, 0x872
  064194  0DB4: a13a85           mov ax, word ptr [0x853a]
  064197  0DB7: 48               dec ax
  064198  0DB8: 3b4604           cmp ax, word ptr [bp + 4]
  06419B  0DBB: 7e1f             jle 0xddc
  06419D  0DBD: ff36c685         push word ptr [0x85c6]
  0641A1  0DC1: ff36c485         push word ptr [0x85c4]
  0641A5  0DC5: ff36c285         push word ptr [0x85c2]
  0641A9  0DC9: ff36c085         push word ptr [0x85c0]
  0641AD  0DCD: 8b4604           mov ax, word ptr [bp + 4]
  0641B0  0DD0: 40               inc ax
  0641B1  0DD1: 8b5606           mov dx, word ptr [bp + 6]
  0641B4  0DD4: bb0100           mov bx, 1
  0641B7  0DD7: 9a72081f1a       lcall 0x1a1f, 0x872
  0641BC  0DDC: a13c85           mov ax, word ptr [0x853c]
  0641BF  0DDF: 48               dec ax
  0641C0  0DE0: 3b4606           cmp ax, word ptr [bp + 6]
  0641C3  0DE3: 7e1f             jle 0xe04
  0641C5  0DE5: ff36c685         push word ptr [0x85c6]
  0641C9  0DE9: ff36c485         push word ptr [0x85c4]
  0641CD  0DED: ff36c285         push word ptr [0x85c2]
  0641D1  0DF1: ff36c085         push word ptr [0x85c0]
  0641D5  0DF5: 8b5606           mov dx, word ptr [bp + 6]
  0641D8  0DF8: 42               inc dx
  0641D9  0DF9: 8b4604           mov ax, word ptr [bp + 4]
  0641DC  0DFC: bb0100           mov bx, 1
  0641DF  0DFF: 9a72081f1a       lcall 0x1a1f, 0x872
  0641E4  0E04: 9aac031f18       lcall 0x181f, 0x3ac
  0641E9  0E09: c9               leave 
  0641EA  0E0A: c3               ret 

; ---- func_0641EC  size=122  insns=50  prologue=ENTER 0x0006,0  terminal=RETF ----
  0641EC  0E0C: c8060000         enter 6, 0
  0641F0  0E10: 6a40             push 0x40
  0641F2  0E12: 6a01             push 1
  0641F4  0E14: 9ad4041f18       lcall 0x181f, 0x4d4
  0641F9  0E19: 83c404           add sp, 4
  0641FC  0E1C: 40               inc ax
  0641FD  0E1D: 40               inc ax
  0641FE  0E1E: 8946fe           mov word ptr [bp - 2], ax
  064201  0E21: eb52             jmp 0xe75
  064203  0E23: 90               nop 
  064204  0E24: a0202d           mov al, byte ptr [0x2d20]
  064207  0E27: 98               cwde 
  064208  0E28: 3b4606           cmp ax, word ptr [bp + 6]
  06420B  0E2B: 7d52             jge 0xe7f
  06420D  0E2D: a01e2d           mov al, byte ptr [0x2d1e]
  064210  0E30: 98               cwde 
  064211  0E31: 3b4606           cmp ax, word ptr [bp + 6]
  064214  0E34: 7e49             jle 0xe7f
  064216  0E36: a0212d           mov al, byte ptr [0x2d21]
  064219  0E39: 98               cwde 
  06421A  0E3A: 3b4608           cmp ax, word ptr [bp + 8]
  06421D  0E3D: 7d40             jge 0xe7f
  06421F  0E3F: a01f2d           mov al, byte ptr [0x2d1f]
  064222  0E42: 98               cwde 
  064223  0E43: 3b4608           cmp ax, word ptr [bp + 8]
  064226  0E46: 7e37             jle 0xe7f
  064228  0E48: ff7608           push word ptr [bp + 8]
  06422B  0E4B: ff7606           push word ptr [bp + 6]
  06422E  0E4E: e823ff           call 0xd74
  064231  0E51: 83c404           add sp, 4
  064234  0E54: 6a04             push 4
  064236  0E56: 6a01             push 1
  064238  0E58: 9ad4041f18       lcall 0x181f, 0x4d4
  06423D  0E5D: 83c404           add sp, 4
  064240  0E60: 8bd8             mov bx, ax
  064242  0E62: d1e3             shl bx, 1
  064244  0E64: 4b               dec bx
  064245  0E65: 8a87b400         mov al, byte ptr [bx + 0xb4]
  064249  0E69: 98               cwde 
  06424A  0E6A: 014606           add word ptr [bp + 6], ax
  06424D  0E6D: 8a87be00         mov al, byte ptr [bx + 0xbe]
  064251  0E71: 98               cwde 
  064252  0E72: 014608           add word ptr [bp + 8], ax
  064255  0E75: 8b46fe           mov ax, word ptr [bp - 2]
  064258  0E78: ff4efe           dec word ptr [bp - 2]
  06425B  0E7B: 0bc0             or ax, ax
  06425D  0E7D: 75a5             jne 0xe24
  06425F  0E7F: 9aac031f18       lcall 0x181f, 0x3ac
  064264  0E84: c9               leave 
  064265  0E85: cb               retf 

; ---- func_064266  size=261  insns=110  prologue=ENTER 0x0006,0  terminal=RETF ----
  064266  0E86: c8060000         enter 6, 0
  06426A  0E8A: 6a30             push 0x30
  06426C  0E8C: 6a01             push 1
  06426E  0E8E: 9ad4041f18       lcall 0x181f, 0x4d4
  064273  0E93: 83c404           add sp, 4
  064276  0E96: 40               inc ax
  064277  0E97: 40               inc ax
  064278  0E98: 8946fe           mov word ptr [bp - 2], ax
  06427B  0E9B: e9d900           jmp 0xf77
  06427E  0E9E: a0202d           mov al, byte ptr [0x2d20]
  064281  0EA1: 98               cwde 
  064282  0EA2: 3b4606           cmp ax, word ptr [bp + 6]
  064285  0EA5: 7c03             jl 0xeaa
  064287  0EA7: e9da00           jmp 0xf84
  06428A  0EAA: a01e2d           mov al, byte ptr [0x2d1e]
  06428D  0EAD: 98               cwde 
  06428E  0EAE: 3b4606           cmp ax, word ptr [bp + 6]
  064291  0EB1: 7f03             jg 0xeb6
  064293  0EB3: e9ce00           jmp 0xf84
  064296  0EB6: a0212d           mov al, byte ptr [0x2d21]
  064299  0EB9: 98               cwde 
  06429A  0EBA: 3b4608           cmp ax, word ptr [bp + 8]
  06429D  0EBD: 7c03             jl 0xec2
  06429F  0EBF: e9c200           jmp 0xf84
  0642A2  0EC2: a01f2d           mov al, byte ptr [0x2d1f]
  0642A5  0EC5: 98               cwde 
  0642A6  0EC6: 3b4608           cmp ax, word ptr [bp + 8]
  0642A9  0EC9: 7f03             jg 0xece
  0642AB  0ECB: e9b600           jmp 0xf84
  0642AE  0ECE: ff7608           push word ptr [bp + 8]
  0642B1  0ED1: ff7606           push word ptr [bp + 6]
  0642B4  0ED4: e89dfe           call 0xd74
  0642B7  0ED7: 83c404           add sp, 4
  0642BA  0EDA: 6a04             push 4
  0642BC  0EDC: 6a01             push 1
  0642BE  0EDE: 9ad4041f18       lcall 0x181f, 0x4d4
  0642C3  0EE3: 83c404           add sp, 4
  0642C6  0EE6: 48               dec ax
  0642C7  0EE7: 7510             jne 0xef9
  0642C9  0EE9: 8b4608           mov ax, word ptr [bp + 8]
  0642CC  0EEC: 40               inc ax
  0642CD  0EED: 50               push ax
  0642CE  0EEE: 8b4606           mov ax, word ptr [bp + 6]
  0642D1  0EF1: 40               inc ax
  0642D2  0EF2: 50               push ax
  0642D3  0EF3: e87efe           call 0xd74
  0642D6  0EF6: 83c404           add sp, 4
  0642D9  0EF9: 6a04             push 4
  0642DB  0EFB: 6a01             push 1
  0642DD  0EFD: 9ad4041f18       lcall 0x181f, 0x4d4
  0642E2  0F02: 83c404           add sp, 4
  0642E5  0F05: 48               dec ax
  0642E6  0F06: 7510             jne 0xf18
  0642E8  0F08: 8b4608           mov ax, word ptr [bp + 8]
  0642EB  0F0B: 40               inc ax
  0642EC  0F0C: 50               push ax
  0642ED  0F0D: 8b4606           mov ax, word ptr [bp + 6]
  0642F0  0F10: 48               dec ax
  0642F1  0F11: 50               push ax
  0642F2  0F12: e85ffe           call 0xd74
  0642F5  0F15: 83c404           add sp, 4
  0642F8  0F18: 6a04             push 4
  0642FA  0F1A: 6a01             push 1
  0642FC  0F1C: 9ad4041f18       lcall 0x181f, 0x4d4
  064301  0F21: 83c404           add sp, 4
  064304  0F24: 48               dec ax
  064305  0F25: 7510             jne 0xf37
  064307  0F27: 8b4608           mov ax, word ptr [bp + 8]
  06430A  0F2A: 48               dec ax
  06430B  0F2B: 50               push ax
  06430C  0F2C: 8b4606           mov ax, word ptr [bp + 6]
  06430F  0F2F: 40               inc ax
  064310  0F30: 50               push ax
  064311  0F31: e840fe           call 0xd74
  064314  0F34: 83c404           add sp, 4
  064317  0F37: 6a04             push 4
  064319  0F39: 6a01             push 1
  06431B  0F3B: 9ad4041f18       lcall 0x181f, 0x4d4
  064320  0F40: 83c404           add sp, 4
  064323  0F43: 48               dec ax
  064324  0F44: 7510             jne 0xf56
  064326  0F46: 8b4608           mov ax, word ptr [bp + 8]
  064329  0F49: 48               dec ax
  06432A  0F4A: 50               push ax
  06432B  0F4B: 8b4606           mov ax, word ptr [bp + 6]
  06432E  0F4E: 48               dec ax
  06432F  0F4F: 50               push ax
  064330  0F50: e821fe           call 0xd74
  064333  0F53: 83c404           add sp, 4
  064336  0F56: 6a04             push 4
  064338  0F58: 6a01             push 1
  06433A  0F5A: 9ad4041f18       lcall 0x181f, 0x4d4
  06433F  0F5F: 83c404           add sp, 4
  064342  0F62: 8bd8             mov bx, ax
  064344  0F64: d1e3             shl bx, 1
  064346  0F66: 4b               dec bx
  064347  0F67: 8a87b400         mov al, byte ptr [bx + 0xb4]
  06434B  0F6B: 98               cwde 
  06434C  0F6C: 014606           add word ptr [bp + 6], ax
  06434F  0F6F: 8a87be00         mov al, byte ptr [bx + 0xbe]
  064353  0F73: 98               cwde 
  064354  0F74: 014608           add word ptr [bp + 8], ax
  064357  0F77: 8b46fe           mov ax, word ptr [bp - 2]
  06435A  0F7A: ff4efe           dec word ptr [bp - 2]
  06435D  0F7D: 0bc0             or ax, ax
  06435F  0F7F: 7403             je 0xf84
  064361  0F81: e91aff           jmp 0xe9e
  064364  0F84: 9aac031f18       lcall 0x181f, 0x3ac
  064369  0F89: c9               leave 
  06436A  0F8A: cb               retf 

; ---- func_06436C  size=140  insns=54  prologue=ENTER 0x0006,0  terminal=RETF ----
  06436C  0F8C: c8060000         enter 6, 0
  064370  0F90: 6a10             push 0x10
  064372  0F92: 6a01             push 1
  064374  0F94: 9ad4041f18       lcall 0x181f, 0x4d4
  064379  0F99: 83c404           add sp, 4
  06437C  0F9C: 40               inc ax
  06437D  0F9D: 40               inc ax
  06437E  0F9E: 8946fe           mov word ptr [bp - 2], ax
  064381  0FA1: eb64             jmp 0x1007
  064383  0FA3: 90               nop 
  064384  0FA4: a0202d           mov al, byte ptr [0x2d20]
  064387  0FA7: 98               cwde 
  064388  0FA8: 3b4606           cmp ax, word ptr [bp + 6]
  06438B  0FAB: 7d64             jge 0x1011
  06438D  0FAD: a01e2d           mov al, byte ptr [0x2d1e]
  064390  0FB0: 98               cwde 
  064391  0FB1: 3b4606           cmp ax, word ptr [bp + 6]
  064394  0FB4: 7e5b             jle 0x1011
  064396  0FB6: a0212d           mov al, byte ptr [0x2d21]
  064399  0FB9: 98               cwde 
  06439A  0FBA: 3b4608           cmp ax, word ptr [bp + 8]
  06439D  0FBD: 7d52             jge 0x1011
  06439F  0FBF: a01f2d           mov al, byte ptr [0x2d1f]
  0643A2  0FC2: 98               cwde 
  0643A3  0FC3: 3b4608           cmp ax, word ptr [bp + 8]
  0643A6  0FC6: 7e49             jle 0x1011
  0643A8  0FC8: ff36c685         push word ptr [0x85c6]
  0643AC  0FCC: ff36c485         push word ptr [0x85c4]
  0643B0  0FD0: ff36c285         push word ptr [0x85c2]
  0643B4  0FD4: ff36c085         push word ptr [0x85c0]
  0643B8  0FD8: 8b4606           mov ax, word ptr [bp + 6]
  0643BB  0FDB: 8b5608           mov dx, word ptr [bp + 8]
  0643BE  0FDE: bb0100           mov bx, 1
  0643C1  0FE1: 9a72081f1a       lcall 0x1a1f, 0x872
  0643C6  0FE6: 6a04             push 4
  0643C8  0FE8: 6a01             push 1
  0643CA  0FEA: 9ad4041f18       lcall 0x181f, 0x4d4
  0643CF  0FEF: 83c404           add sp, 4
  0643D2  0FF2: 8bd8             mov bx, ax
  0643D4  0FF4: 4b               dec bx
  0643D5  0FF5: d1e3             shl bx, 1
  0643D7  0FF7: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0643DB  0FFB: 98               cwde 
  0643DC  0FFC: 014606           add word ptr [bp + 6], ax
  0643DF  0FFF: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0643E3  1003: 98               cwde 
  0643E4  1004: 014608           add word ptr [bp + 8], ax
  0643E7  1007: 8b46fe           mov ax, word ptr [bp - 2]
  0643EA  100A: ff4efe           dec word ptr [bp - 2]
  0643ED  100D: 0bc0             or ax, ax
  0643EF  100F: 7593             jne 0xfa4
  0643F1  1011: 9aac031f18       lcall 0x181f, 0x3ac
  0643F6  1016: c9               leave 
  0643F7  1017: cb               retf 

; ---- func_0643F8  size=315  insns=108  prologue=ENTER 0x0012,0  terminal=RETF ----
  0643F8  1018: c8120000         enter 0x12, 0
  0643FC  101C: ff36c685         push word ptr [0x85c6]
  064400  1020: ff36c485         push word ptr [0x85c4]
  064404  1024: ff36c285         push word ptr [0x85c2]
  064408  1028: ff36c085         push word ptr [0x85c0]
  06440C  102C: 2ac0             sub al, al
  06440E  102E: 9a84041f18       lcall 0x181f, 0x484
  064413  1033: a13a85           mov ax, word ptr [0x853a]
  064416  1036: 2d1000           sub ax, 0x10
  064419  1039: 50               push ax
  06441A  103A: 6a01             push 1
  06441C  103C: 9ad4041f18       lcall 0x181f, 0x4d4
  064421  1041: 83c404           add sp, 4
  064424  1044: 050700           add ax, 7
  064427  1047: 8946f4           mov word ptr [bp - 0xc], ax
  06442A  104A: a13c85           mov ax, word ptr [0x853c]
  06442D  104D: 2d0800           sub ax, 8
  064430  1050: 50               push ax
  064431  1051: 6a01             push 1
  064433  1053: 9ad4041f18       lcall 0x181f, 0x4d4
  064438  1058: 83c404           add sp, 4
  06443B  105B: 050300           add ax, 3
  06443E  105E: 8946f2           mov word ptr [bp - 0xe], ax
  064441  1061: 837e0600         cmp word ptr [bp + 6], 0
  064445  1065: 741f             je 0x1086
  064447  1067: ff36b685         push word ptr [0x85b6]
  06444B  106B: ff36b485         push word ptr [0x85b4]
  06444F  106F: ff36b285         push word ptr [0x85b2]
  064453  1073: ff36b085         push word ptr [0x85b0]
  064457  1077: 8b46f4           mov ax, word ptr [bp - 0xc]
  06445A  107A: 8b56f2           mov dx, word ptr [bp - 0xe]
  06445D  107D: 9a68081f1a       lcall 0x1a1f, 0x868
  064462  1082: 0ac0             or al, al
  064464  1084: 75ad             jne 0x1033
  064466  1086: 837e0600         cmp word ptr [bp + 6], 0
  06446A  108A: 7442             je 0x10ce
  06446C  108C: 6a0a             push 0xa
  06446E  108E: 6a01             push 1
  064470  1090: 9ad4041f18       lcall 0x181f, 0x4d4
  064475  1095: 83c404           add sp, 4
  064478  1098: 8946fe           mov word ptr [bp - 2], ax
  06447B  109B: ff76f2           push word ptr [bp - 0xe]
  06447E  109E: ff76f4           push word ptr [bp - 0xc]
  064481  10A1: 0e               push cs
  064482  10A2: e88818           call 0x292d
  064485  10A5: 83c404           add sp, 4
  064488  10A8: 837efe07         cmp word ptr [bp - 2], 7
  06448C  10AC: 7c0d             jl 0x10bb
  06448E  10AE: ff76f2           push word ptr [bp - 0xe]
  064491  10B1: ff76f4           push word ptr [bp - 0xc]
  064494  10B4: 0e               push cs
  064495  10B5: e87518           call 0x292d
  064498  10B8: 83c404           add sp, 4
  06449B  10BB: 837efe08         cmp word ptr [bp - 2], 8
  06449F  10BF: 7c2e             jl 0x10ef
  0644A1  10C1: ff76f2           push word ptr [bp - 0xe]
  0644A4  10C4: ff76f4           push word ptr [bp - 0xc]
  0644A7  10C7: 0e               push cs
  0644A8  10C8: e86218           call 0x292d
  0644AB  10CB: eb1f             jmp 0x10ec
  0644AD  10CD: 90               nop 
  0644AE  10CE: 833e801e02       cmp word ptr [0x1e80], 2
  0644B3  10D3: 7c0d             jl 0x10e2
  0644B5  10D5: ff76f2           push word ptr [bp - 0xe]
  0644B8  10D8: ff76f4           push word ptr [bp - 0xc]
  0644BB  10DB: 0e               push cs
  0644BC  10DC: e84918           call 0x2928
  0644BF  10DF: eb0b             jmp 0x10ec
  0644C1  10E1: 90               nop 
  0644C2  10E2: ff76f2           push word ptr [bp - 0xe]
  0644C5  10E5: ff76f4           push word ptr [bp - 0xc]
  0644C8  10E8: 0e               push cs
  0644C9  10E9: e85518           call 0x2941
  0644CC  10EC: 83c404           add sp, 4
  0644CF  10EF: a16801           mov ax, word ptr [0x168]
  0644D2  10F2: 8b166a01         mov dx, word ptr [0x16a]
  0644D6  10F6: 8946fa           mov word ptr [bp - 6], ax
  0644D9  10F9: 8956fc           mov word ptr [bp - 4], dx
  0644DC  10FC: a16001           mov ax, word ptr [0x160]
  0644DF  10FF: 8b166201         mov dx, word ptr [0x162]
  0644E3  1103: 8946f6           mov word ptr [bp - 0xa], ax
  0644E6  1106: 8956f8           mov word ptr [bp - 8], dx
  0644E9  1109: c746f20000       mov word ptr [bp - 0xe], 0
  0644EE  110E: eb2b             jmp 0x113b
  0644F0  1110: ff46f4           inc word ptr [bp - 0xc]
  0644F3  1113: 8b46f4           mov ax, word ptr [bp - 0xc]
  0644F6  1116: 39063a85         cmp word ptr [0x853a], ax
  0644FA  111A: 7e1c             jle 0x1138
  0644FC  111C: c45efa           les bx, ptr [bp - 6]
  0644FF  111F: ff46fa           inc word ptr [bp - 6]
  064502  1122: 26803f00         cmp byte ptr es:[bx], 0
  064506  1126: 740a             je 0x1132
  064508  1128: c45ef6           les bx, ptr [bp - 0xa]
  06450B  112B: 26fe07           inc byte ptr es:[bx]
  06450E  112E: ff06222d         inc word ptr [0x2d22]
  064512  1132: ff46f6           inc word ptr [bp - 0xa]
  064515  1135: ebd9             jmp 0x1110
  064517  1137: 90               nop 
  064518  1138: ff46f2           inc word ptr [bp - 0xe]
  06451B  113B: 8b46f2           mov ax, word ptr [bp - 0xe]
  06451E  113E: 39063c85         cmp word ptr [0x853c], ax
  064522  1142: 7e08             jle 0x114c
  064524  1144: c746f40000       mov word ptr [bp - 0xc], 0
  064529  1149: ebc8             jmp 0x1113
  06452B  114B: 90               nop 
  06452C  114C: 9aac031f18       lcall 0x181f, 0x3ac
  064531  1151: c9               leave 
  064532  1152: cb               retf 

; ---- func_064534  size=194  insns=67  prologue=push bp;mov bp,sp  terminal=RETF ----
  064534  1154: 55               push bp
  064535  1155: 8bec             mov bp, sp
  064537  1157: ff7608           push word ptr [bp + 8]
  06453A  115A: ff7606           push word ptr [bp + 6]
  06453D  115D: 9a02031f18       lcall 0x181f, 0x302
  064542  1162: 8be5             mov sp, bp
  064544  1164: 0bc0             or ax, ax
  064546  1166: 7504             jne 0x116c
  064548  1168: 2bc0             sub ax, ax
  06454A  116A: c9               leave 
  06454B  116B: cb               retf 
  06454C  116C: ff36ae85         push word ptr [0x85ae]
  064550  1170: ff36ac85         push word ptr [0x85ac]
  064554  1174: ff36aa85         push word ptr [0x85aa]
  064558  1178: ff36a885         push word ptr [0x85a8]
  06455C  117C: 8b4606           mov ax, word ptr [bp + 6]
  06455F  117F: 48               dec ax
  064560  1180: 8b5608           mov dx, word ptr [bp + 8]
  064563  1183: 4a               dec dx
  064564  1184: 9a68081f1a       lcall 0x1a1f, 0x868
  064569  1189: 3c19             cmp al, 0x19
  06456B  118B: 74db             je 0x1168
  06456D  118D: ff36ae85         push word ptr [0x85ae]
  064571  1191: ff36ac85         push word ptr [0x85ac]
  064575  1195: ff36aa85         push word ptr [0x85aa]
  064579  1199: ff36a885         push word ptr [0x85a8]
  06457D  119D: 8b4606           mov ax, word ptr [bp + 6]
  064580  11A0: 48               dec ax
  064581  11A1: 8b5608           mov dx, word ptr [bp + 8]
  064584  11A4: 42               inc dx
  064585  11A5: 9a68081f1a       lcall 0x1a1f, 0x868
  06458A  11AA: 3c19             cmp al, 0x19
  06458C  11AC: 74ba             je 0x1168
  06458E  11AE: ff36ae85         push word ptr [0x85ae]
  064592  11B2: ff36ac85         push word ptr [0x85ac]
  064596  11B6: ff36aa85         push word ptr [0x85aa]
  06459A  11BA: ff36a885         push word ptr [0x85a8]
  06459E  11BE: 8b4606           mov ax, word ptr [bp + 6]
  0645A1  11C1: 40               inc ax
  0645A2  11C2: 8b5608           mov dx, word ptr [bp + 8]
  0645A5  11C5: 4a               dec dx
  0645A6  11C6: 9a68081f1a       lcall 0x1a1f, 0x868
  0645AB  11CB: 3c19             cmp al, 0x19
  0645AD  11CD: 7499             je 0x1168
  0645AF  11CF: ff36ae85         push word ptr [0x85ae]
  0645B3  11D3: ff36ac85         push word ptr [0x85ac]
  0645B7  11D7: ff36aa85         push word ptr [0x85aa]
  0645BB  11DB: ff36a885         push word ptr [0x85a8]
  0645BF  11DF: 8b4606           mov ax, word ptr [bp + 6]
  0645C2  11E2: 40               inc ax
  0645C3  11E3: 8b5608           mov dx, word ptr [bp + 8]
  0645C6  11E6: 42               inc dx
  0645C7  11E7: 9a68081f1a       lcall 0x1a1f, 0x868
  0645CC  11EC: 3c19             cmp al, 0x19
  0645CE  11EE: 7503             jne 0x11f3
  0645D0  11F0: e975ff           jmp 0x1168
  0645D3  11F3: ff36ae85         push word ptr [0x85ae]
  0645D7  11F7: ff36ac85         push word ptr [0x85ac]
  0645DB  11FB: ff36aa85         push word ptr [0x85aa]
  0645DF  11FF: ff36a885         push word ptr [0x85a8]
  0645E3  1203: 8b4606           mov ax, word ptr [bp + 6]
  0645E6  1206: 8b5608           mov dx, word ptr [bp + 8]
  0645E9  1209: bb1900           mov bx, 0x19
  0645EC  120C: 9a72081f1a       lcall 0x1a1f, 0x872
  0645F1  1211: b80100           mov ax, 1
  0645F4  1214: c9               leave 
  0645F5  1215: cb               retf 

; ---- func_0645F6  size=1050  insns=343  prologue=ENTER 0x0026,0  terminal=RETF ----
  0645F6  1216: c8260000         enter 0x26, 0
  0645FA  121A: 2bc0             sub ax, ax
  0645FC  121C: 8946de           mov word ptr [bp - 0x22], ax
  0645FF  121F: 8946f0           mov word ptr [bp - 0x10], ax
  064602  1222: ff368001         push word ptr [0x180]
  064606  1226: ff365e01         push word ptr [0x15e]
  06460A  122A: ff365c01         push word ptr [0x15c]
  06460E  122E: ff366a01         push word ptr [0x16a]
  064612  1232: ff366801         push word ptr [0x168]
  064616  1236: 9ab20f1d0d       lcall 0xd1d, 0xfb2
  06461B  123B: 83c40a           add sp, 0xa
  06461E  123E: ff46f0           inc word ptr [bp - 0x10]
  064621  1241: c746dc0000       mov word ptr [bp - 0x24], 0
  064626  1246: a13a85           mov ax, word ptr [0x853a]
  064629  1249: 48               dec ax
  06462A  124A: 48               dec ax
  06462B  124B: 50               push ax
  06462C  124C: 6a01             push 1
  06462E  124E: 9ad4041f18       lcall 0x181f, 0x4d4
  064633  1253: 83c404           add sp, 4
  064636  1256: 8946ee           mov word ptr [bp - 0x12], ax
  064639  1259: a13c85           mov ax, word ptr [0x853c]
  06463C  125C: 48               dec ax
  06463D  125D: 48               dec ax
  06463E  125E: 50               push ax
  06463F  125F: 6a01             push 1
  064641  1261: 9ad4041f18       lcall 0x181f, 0x4d4
  064646  1266: 83c404           add sp, 4
  064649  1269: 8946e6           mov word ptr [bp - 0x1a], ax
  06464C  126C: ff36c685         push word ptr [0x85c6]
  064650  1270: ff36c485         push word ptr [0x85c4]
  064654  1274: ff36c285         push word ptr [0x85c2]
  064658  1278: ff36c085         push word ptr [0x85c0]
  06465C  127C: 8b46ee           mov ax, word ptr [bp - 0x12]
  06465F  127F: 8b56e6           mov dx, word ptr [bp - 0x1a]
  064662  1282: 9a68081f1a       lcall 0x1a1f, 0x868
  064667  1287: 2ae4             sub ah, ah
  064669  1289: 8946fc           mov word ptr [bp - 4], ax
  06466C  128C: f646fc20         test byte ptr [bp - 4], 0x20
  064670  1290: 75b4             jne 0x1246
  064672  1292: ff76e6           push word ptr [bp - 0x1a]
  064675  1295: ff76ee           push word ptr [bp - 0x12]
  064678  1298: 9a68071f18       lcall 0x181f, 0x768
  06467D  129D: 83c404           add sp, 4
  064680  12A0: 0bc0             or ax, ax
  064682  12A2: 75a2             jne 0x1246
  064684  12A4: 8b46ee           mov ax, word ptr [bp - 0x12]
  064687  12A7: 8946e4           mov word ptr [bp - 0x1c], ax
  06468A  12AA: 8b46e6           mov ax, word ptr [bp - 0x1a]
  06468D  12AD: 8946e0           mov word ptr [bp - 0x20], ax
  064690  12B0: 6a03             push 3
  064692  12B2: 6a00             push 0
  064694  12B4: 9ad4041f18       lcall 0x181f, 0x4d4
  064699  12B9: 83c404           add sp, 4
  06469C  12BC: d1e0             shl ax, 1
  06469E  12BE: 8946da           mov word ptr [bp - 0x26], ax
  0646A1  12C1: 6a01             push 1
  0646A3  12C3: 6a00             push 0
  0646A5  12C5: 9ad4041f18       lcall 0x181f, 0x4d4
  0646AA  12CA: 83c404           add sp, 4
  0646AD  12CD: 8946ec           mov word ptr [bp - 0x14], ax
  0646B0  12D0: ff36ae85         push word ptr [0x85ae]
  0646B4  12D4: ff36ac85         push word ptr [0x85ac]
  0646B8  12D8: ff36aa85         push word ptr [0x85aa]
  0646BC  12DC: ff36a885         push word ptr [0x85a8]
  0646C0  12E0: 804efc40         or byte ptr [bp - 4], 0x40
  0646C4  12E4: 8b5efc           mov bx, word ptr [bp - 4]
  0646C7  12E7: 8b46ee           mov ax, word ptr [bp - 0x12]
  0646CA  12EA: 8b56e6           mov dx, word ptr [bp - 0x1a]
  0646CD  12ED: 9a72081f1a       lcall 0x1a1f, 0x872
  0646D2  12F2: ff46dc           inc word ptr [bp - 0x24]
  0646D5  12F5: 2bc0             sub ax, ax
  0646D7  12F7: 8946f4           mov word ptr [bp - 0xc], ax
  0646DA  12FA: 8946f6           mov word ptr [bp - 0xa], ax
  0646DD  12FD: e9a500           jmp 0x13a5
  0646E0  1300: 837ef604         cmp word ptr [bp - 0xa], 4
  0646E4  1304: 7c03             jl 0x1309
  0646E6  1306: e9a500           jmp 0x13ae
  0646E9  1309: 8b5ef6           mov bx, word ptr [bp - 0xa]
  0646EC  130C: 8a87ae00         mov al, byte ptr [bx + 0xae]
  0646F0  1310: 98               cwde 
  0646F1  1311: 0346e6           add ax, word ptr [bp - 0x1a]
  0646F4  1314: 8946fa           mov word ptr [bp - 6], ax
  0646F7  1317: 50               push ax
  0646F8  1318: 8a87a800         mov al, byte ptr [bx + 0xa8]
  0646FC  131C: 98               cwde 
  0646FD  131D: 0346ee           add ax, word ptr [bp - 0x12]
  064700  1320: 8946fe           mov word ptr [bp - 2], ax
  064703  1323: 50               push ax
  064704  1324: 9a68071f18       lcall 0x181f, 0x768
  064709  1329: 83c404           add sp, 4
  06470C  132C: 0bc0             or ax, ax
  06470E  132E: 751f             jne 0x134f
  064710  1330: ff36c685         push word ptr [0x85c6]
  064714  1334: ff36c485         push word ptr [0x85c4]
  064718  1338: ff36c285         push word ptr [0x85c2]
  06471C  133C: ff36c085         push word ptr [0x85c0]
  064720  1340: 8b46fe           mov ax, word ptr [bp - 2]
  064723  1343: 8b56fa           mov dx, word ptr [bp - 6]
  064726  1346: 9a68081f1a       lcall 0x1a1f, 0x868
  06472B  134B: a840             test al, 0x40
  06472D  134D: 7453             je 0x13a2
  06472F  134F: c746f40100       mov word ptr [bp - 0xc], 1
  064734  1354: ff36ae85         push word ptr [0x85ae]
  064738  1358: ff36ac85         push word ptr [0x85ac]
  06473C  135C: ff36aa85         push word ptr [0x85aa]
  064740  1360: ff36a885         push word ptr [0x85a8]
  064744  1364: 8b46fe           mov ax, word ptr [bp - 2]
  064747  1367: 8b56fa           mov dx, word ptr [bp - 6]
  06474A  136A: 9a68081f1a       lcall 0x1a1f, 0x868
  06474F  136F: 2ae4             sub ah, ah
  064751  1371: 8946fc           mov word ptr [bp - 4], ax
  064754  1374: ff36ae85         push word ptr [0x85ae]
  064758  1378: ff36ac85         push word ptr [0x85ac]
  06475C  137C: ff36aa85         push word ptr [0x85aa]
  064760  1380: ff36a885         push word ptr [0x85a8]
  064764  1384: 804efc40         or byte ptr [bp - 4], 0x40
  064768  1388: 8b5efc           mov bx, word ptr [bp - 4]
  06476B  138B: 8b46fe           mov ax, word ptr [bp - 2]
  06476E  138E: 8b56fa           mov dx, word ptr [bp - 6]
  064771  1391: 9a72081f1a       lcall 0x1a1f, 0x872
  064776  1396: 8b46ee           mov ax, word ptr [bp - 0x12]
  064779  1399: 8946e8           mov word ptr [bp - 0x18], ax
  06477C  139C: 8b46e6           mov ax, word ptr [bp - 0x1a]
  06477F  139F: 8946e2           mov word ptr [bp - 0x1e], ax
  064782  13A2: ff46f6           inc word ptr [bp - 0xa]
  064785  13A5: 837ef400         cmp word ptr [bp - 0xc], 0
  064789  13A9: 7503             jne 0x13ae
  06478B  13AB: e952ff           jmp 0x1300
  06478E  13AE: 6a63             push 0x63
  064790  13B0: 6a00             push 0
  064792  13B2: 9ad4041f18       lcall 0x181f, 0x4d4
  064797  13B7: 83c404           add sp, 4
  06479A  13BA: 3d3c00           cmp ax, 0x3c
  06479D  13BD: 7d09             jge 0x13c8
  06479F  13BF: 8b46da           mov ax, word ptr [bp - 0x26]
  0647A2  13C2: 8946f2           mov word ptr [bp - 0xe], ax
  0647A5  13C5: eb39             jmp 0x1400
  0647A7  13C7: 90               nop 
  0647A8  13C8: 3d5f00           cmp ax, 0x5f
  0647AB  13CB: 7e0b             jle 0x13d8
  0647AD  13CD: 837eec01         cmp word ptr [bp - 0x14], 1
  0647B1  13D1: 1bc0             sbb ax, ax
  0647B3  13D3: f7d8             neg ax
  0647B5  13D5: 8946ec           mov word ptr [bp - 0x14], ax
  0647B8  13D8: 837eec00         cmp word ptr [bp - 0x14], 0
  0647BC  13DC: 7408             je 0x13e6
  0647BE  13DE: 8b46da           mov ax, word ptr [bp - 0x26]
  0647C1  13E1: 40               inc ax
  0647C2  13E2: 40               inc ax
  0647C3  13E3: eb07             jmp 0x13ec
  0647C5  13E5: 90               nop 
  0647C6  13E6: 8b46da           mov ax, word ptr [bp - 0x26]
  0647C9  13E9: 050600           add ax, 6
  0647CC  13EC: b90800           mov cx, 8
  0647CF  13EF: 99               cdq 
  0647D0  13F0: f7f9             idiv cx
  0647D2  13F2: 8956f2           mov word ptr [bp - 0xe], dx
  0647D5  13F5: 837eec01         cmp word ptr [bp - 0x14], 1
  0647D9  13F9: 1bc0             sbb ax, ax
  0647DB  13FB: f7d8             neg ax
  0647DD  13FD: 8946ec           mov word ptr [bp - 0x14], ax
  0647E0  1400: 8b46f2           mov ax, word ptr [bp - 0xe]
  0647E3  1403: 8946da           mov word ptr [bp - 0x26], ax
  0647E6  1406: ff36c685         push word ptr [0x85c6]
  0647EA  140A: ff36c485         push word ptr [0x85c4]
  0647EE  140E: ff36c285         push word ptr [0x85c2]
  0647F2  1412: ff36c085         push word ptr [0x85c0]
  0647F6  1416: 8bd8             mov bx, ax
  0647F8  1418: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0647FC  141C: 98               cwde 
  0647FD  141D: 0146e6           add word ptr [bp - 0x1a], ax
  064800  1420: 8b56e6           mov dx, word ptr [bp - 0x1a]
  064803  1423: 8a87b400         mov al, byte ptr [bx + 0xb4]
  064807  1427: 98               cwde 
  064808  1428: 0146ee           add word ptr [bp - 0x12], ax
  06480B  142B: 8b46ee           mov ax, word ptr [bp - 0x12]
  06480E  142E: 9a68081f1a       lcall 0x1a1f, 0x868
  064813  1433: 2ae4             sub ah, ah
  064815  1435: 8946fc           mov word ptr [bp - 4], ax
  064818  1438: 837ef400         cmp word ptr [bp - 0xc], 0
  06481C  143C: 7521             jne 0x145f
  06481E  143E: ff76e6           push word ptr [bp - 0x1a]
  064821  1441: ff76ee           push word ptr [bp - 0x12]
  064824  1444: 9a02031f18       lcall 0x181f, 0x302
  064829  1449: 83c404           add sp, 4
  06482C  144C: 0bc0             or ax, ax
  06482E  144E: 740f             je 0x145f
  064830  1450: f646fc40         test byte ptr [bp - 4], 0x40
  064834  1454: 7509             jne 0x145f
  064836  1456: f646fc20         test byte ptr [bp - 4], 0x20
  06483A  145A: 7503             jne 0x145f
  06483C  145C: e971fe           jmp 0x12d0
  06483F  145F: 837ef400         cmp word ptr [bp - 0xc], 0
  064843  1463: 7506             jne 0x146b
  064845  1465: f646fc40         test byte ptr [bp - 4], 0x40
  064849  1469: 7406             je 0x1471
  06484B  146B: 837edc03         cmp word ptr [bp - 0x24], 3
  06484F  146F: 7d1f             jge 0x1490
  064851  1471: ff368001         push word ptr [0x180]
  064855  1475: ff366a01         push word ptr [0x16a]
  064859  1479: ff366801         push word ptr [0x168]
  06485D  147D: ff365e01         push word ptr [0x15e]
  064861  1481: ff365c01         push word ptr [0x15c]
  064865  1485: 9ab20f1d0d       lcall 0xd1d, 0xfb2
  06486A  148A: 83c40a           add sp, 0xa
  06486D  148D: e97e01           jmp 0x160e
  064870  1490: ff46de           inc word ptr [bp - 0x22]
  064873  1493: 837ef400         cmp word ptr [bp - 0xc], 0
  064877  1497: 7503             jne 0x149c
  064879  1499: e9f200           jmp 0x158e
  06487C  149C: a1841e           mov ax, word ptr [0x1e84]
  06487F  149F: 050600           add ax, 6
  064882  14A2: d1e0             shl ax, 1
  064884  14A4: 50               push ax
  064885  14A5: 6a01             push 1
  064887  14A7: 9ad4041f18       lcall 0x181f, 0x4d4
  06488C  14AC: 83c404           add sp, 4
  06488F  14AF: 3d0600           cmp ax, 6
  064892  14B2: 7f03             jg 0x14b7
  064894  14B4: e9d700           jmp 0x158e
  064897  14B7: a1841e           mov ax, word ptr [0x1e84]
  06489A  14BA: d1e0             shl ax, 1
  06489C  14BC: 050300           add ax, 3
  06489F  14BF: 50               push ax
  0648A0  14C0: 6a01             push 1
  0648A2  14C2: 9ad4041f18       lcall 0x181f, 0x4d4
  0648A7  14C7: 83c404           add sp, 4
  0648AA  14CA: 8946ea           mov word ptr [bp - 0x16], ax
  0648AD  14CD: ff36ae85         push word ptr [0x85ae]
  0648B1  14D1: ff36ac85         push word ptr [0x85ac]
  0648B5  14D5: ff36aa85         push word ptr [0x85aa]
  0648B9  14D9: ff36a885         push word ptr [0x85a8]
  0648BD  14DD: 8b46e8           mov ax, word ptr [bp - 0x18]
  0648C0  14E0: 8b56e2           mov dx, word ptr [bp - 0x1e]
  0648C3  14E3: 9a68081f1a       lcall 0x1a1f, 0x868
  0648C8  14E8: 2ae4             sub ah, ah
  0648CA  14EA: 8946fc           mov word ptr [bp - 4], ax
  0648CD  14ED: ff36ae85         push word ptr [0x85ae]
  0648D1  14F1: ff36ac85         push word ptr [0x85ac]
  0648D5  14F5: ff36aa85         push word ptr [0x85aa]
  0648D9  14F9: ff36a885         push word ptr [0x85a8]
  0648DD  14FD: 804efc80         or byte ptr [bp - 4], 0x80
  0648E1  1501: 8b5efc           mov bx, word ptr [bp - 4]
  0648E4  1504: 8b46e8           mov ax, word ptr [bp - 0x18]
  0648E7  1507: 8b56e2           mov dx, word ptr [bp - 0x1e]
  0648EA  150A: 9a72081f1a       lcall 0x1a1f, 0x872
  0648EF  150F: c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  0648F4  1514: c746f60000       mov word ptr [bp - 0xa], 0
  0648F9  1519: eb04             jmp 0x151f
  0648FB  151B: 90               nop 
  0648FC  151C: ff46f6           inc word ptr [bp - 0xa]
  0648FF  151F: 837ef200         cmp word ptr [bp - 0xe], 0
  064903  1523: 7d57             jge 0x157c
  064905  1525: 837ef604         cmp word ptr [bp - 0xa], 4
  064909  1529: 7d51             jge 0x157c
  06490B  152B: 8b5ef6           mov bx, word ptr [bp - 0xa]
  06490E  152E: 8a87ae00         mov al, byte ptr [bx + 0xae]
  064912  1532: 98               cwde 
  064913  1533: 0346e2           add ax, word ptr [bp - 0x1e]
  064916  1536: 8946e6           mov word ptr [bp - 0x1a], ax
  064919  1539: ff36ae85         push word ptr [0x85ae]
  06491D  153D: ff36ac85         push word ptr [0x85ac]
  064921  1541: ff36aa85         push word ptr [0x85aa]
  064925  1545: ff36a885         push word ptr [0x85a8]
  064929  1549: 8bd0             mov dx, ax
  06492B  154B: 8a87a800         mov al, byte ptr [bx + 0xa8]
  06492F  154F: 98               cwde 
  064930  1550: 0346e8           add ax, word ptr [bp - 0x18]
  064933  1553: 8946ee           mov word ptr [bp - 0x12], ax
  064936  1556: 9a68081f1a       lcall 0x1a1f, 0x868
  06493B  155B: 2ae4             sub ah, ah
  06493D  155D: 8946fc           mov word ptr [bp - 4], ax
  064940  1560: a840             test al, 0x40
  064942  1562: 74b8             je 0x151c
  064944  1564: f646fc80         test byte ptr [bp - 4], 0x80
  064948  1568: 75b2             jne 0x151c
  06494A  156A: 8b46f6           mov ax, word ptr [bp - 0xa]
  06494D  156D: 8946f2           mov word ptr [bp - 0xe], ax
  064950  1570: 8b46ee           mov ax, word ptr [bp - 0x12]
  064953  1573: 8946e8           mov word ptr [bp - 0x18], ax
  064956  1576: 8b46e6           mov ax, word ptr [bp - 0x1a]
  064959  1579: 8946e2           mov word ptr [bp - 0x1e], ax
  06495C  157C: ff4eea           dec word ptr [bp - 0x16]
  06495F  157F: 837eea00         cmp word ptr [bp - 0x16], 0
  064963  1583: 7e09             jle 0x158e
  064965  1585: 837ef200         cmp word ptr [bp - 0xe], 0
  064969  1589: 7c03             jl 0x158e
  06496B  158B: e95fff           jmp 0x14ed
  06496E  158E: c746f60000       mov word ptr [bp - 0xa], 0
  064973  1593: 8b5ef6           mov bx, word ptr [bp - 0xa]
  064976  1596: 8a87de00         mov al, byte ptr [bx + 0xde]
  06497A  159A: 98               cwde 
  06497B  159B: 0346e0           add ax, word ptr [bp - 0x20]
  06497E  159E: 8946e6           mov word ptr [bp - 0x1a], ax
  064981  15A1: ff36ae85         push word ptr [0x85ae]
  064985  15A5: ff36ac85         push word ptr [0x85ac]
  064989  15A9: ff36aa85         push word ptr [0x85aa]
  06498D  15AD: ff36a885         push word ptr [0x85a8]
  064991  15B1: 8bd0             mov dx, ax
  064993  15B3: 8a87c800         mov al, byte ptr [bx + 0xc8]
  064997  15B7: 98               cwde 
  064998  15B8: 0346e4           add ax, word ptr [bp - 0x1c]
  06499B  15BB: 8946ee           mov word ptr [bp - 0x12], ax
  06499E  15BE: 9a68081f1a       lcall 0x1a1f, 0x868
  0649A3  15C3: 2ae4             sub ah, ah
  0649A5  15C5: 8946fc           mov word ptr [bp - 4], ax
  0649A8  15C8: 241f             and al, 0x1f
  0649AA  15CA: 3c10             cmp al, 0x10
  0649AC  15CC: 7337             jae 0x1605
  0649AE  15CE: 6a01             push 1
  0649B0  15D0: 6a00             push 0
  0649B2  15D2: 9ad4041f18       lcall 0x181f, 0x4d4
  0649B7  15D7: 83c404           add sp, 4
  0649BA  15DA: 0bc0             or ax, ax
  0649BC  15DC: 7427             je 0x1605
  0649BE  15DE: 8b46fc           mov ax, word ptr [bp - 4]
  0649C1  15E1: 050800           add ax, 8
  0649C4  15E4: 8946fc           mov word ptr [bp - 4], ax
  0649C7  15E7: ff36ae85         push word ptr [0x85ae]
  0649CB  15EB: ff36ac85         push word ptr [0x85ac]
  0649CF  15EF: ff36aa85         push word ptr [0x85aa]
  0649D3  15F3: ff36a885         push word ptr [0x85a8]
  0649D7  15F7: 8b46ee           mov ax, word ptr [bp - 0x12]
  0649DA  15FA: 8b56e6           mov dx, word ptr [bp - 0x1a]
  0649DD  15FD: 8b5efc           mov bx, word ptr [bp - 4]
  0649E0  1600: 9a72081f1a       lcall 0x1a1f, 0x872
  0649E5  1605: ff46f6           inc word ptr [bp - 0xa]
  0649E8  1608: 837ef614         cmp word ptr [bp - 0xa], 0x14
  0649EC  160C: 7c85             jl 0x1593
  0649EE  160E: 9aac031f18       lcall 0x181f, 0x3ac
  0649F3  1613: 817ef00002       cmp word ptr [bp - 0x10], 0x200
  0649F8  1618: 7d14             jge 0x162e
  0649FA  161A: a1841e           mov ax, word ptr [0x1e84]
  0649FD  161D: 03067e1e         add ax, word ptr [0x1e7e]
  064A01  1621: 40               inc ax
  064A02  1622: 40               inc ax
  064A03  1623: c1e003           shl ax, 3
  064A06  1626: 3b46de           cmp ax, word ptr [bp - 0x22]
  064A09  1629: 7e03             jle 0x162e
  064A0B  162B: e9f4fb           jmp 0x1222
  064A0E  162E: c9               leave 
  064A0F  162F: cb               retf 

; ---- func_064A10  size=4886  insns=1633  prologue=ENTER 0x003C,0  terminal=JMP-tail ----
  064A10  1630: c83c0000         enter 0x3c, 0
  064A14  1634: 57               push di
  064A15  1635: 56               push si
  064A16  1636: 68ff7f           push 0x7fff
  064A19  1639: 6a01             push 1
  064A1B  163B: 9ad4041f18       lcall 0x181f, 0x4d4
  064A20  1640: 83c404           add sp, 4
  064A23  1643: a39001           mov word ptr [0x190], ax
  064A26  1646: c70692010000     mov word ptr [0x192], 0
  064A2C  164C: 837e0600         cmp word ptr [bp + 6], 0
  064A30  1650: 7403             je 0x1655
  064A32  1652: e90c0f           jmp 0x2561
  064A35  1655: c706222d0000     mov word ptr [0x2d22], 0
  064A3B  165B: ff36ae85         push word ptr [0x85ae]
  064A3F  165F: ff36ac85         push word ptr [0x85ac]
  064A43  1663: ff36aa85         push word ptr [0x85aa]
  064A47  1667: ff36a885         push word ptr [0x85a8]
  064A4B  166B: b019             mov al, 0x19
  064A4D  166D: 9a84041f18       lcall 0x181f, 0x484
  064A52  1672: ff36b685         push word ptr [0x85b6]
  064A56  1676: ff36b485         push word ptr [0x85b4]
  064A5A  167A: ff36b285         push word ptr [0x85b2]
  064A5E  167E: ff36b085         push word ptr [0x85b0]
  064A62  1682: 2ac0             sub al, al
  064A64  1684: 9a84041f18       lcall 0x181f, 0x484
  064A69  1689: c606202d03       mov byte ptr [0x2d20], 3
  064A6E  168E: a03a85           mov al, byte ptr [0x853a]
  064A71  1691: 2c06             sub al, 6
  064A73  1693: a21e2d           mov byte ptr [0x2d1e], al
  064A76  1696: c606212d00       mov byte ptr [0x2d21], 0
  064A7B  169B: a03c85           mov al, byte ptr [0x853c]
  064A7E  169E: a21f2d           mov byte ptr [0x2d1f], al
  064A81  16A1: 6a01             push 1
  064A83  16A3: 6a00             push 0
  064A85  16A5: 9ad4041f18       lcall 0x181f, 0x4d4
  064A8A  16AA: 83c404           add sp, 4
  064A8D  16AD: 8946f2           mov word ptr [bp - 0xe], ax
  064A90  16B0: 0bc0             or ax, ax
  064A92  16B2: 7408             je 0x16bc
  064A94  16B4: c606212d05       mov byte ptr [0x2d21], 5
  064A99  16B9: eb09             jmp 0x16c4
  064A9B  16BB: 90               nop 
  064A9C  16BC: a03c85           mov al, byte ptr [0x853c]
  064A9F  16BF: 2c06             sub al, 6
  064AA1  16C1: a21f2d           mov byte ptr [0x2d1f], al
  064AA4  16C4: 6a00             push 0
  064AA6  16C6: 0e               push cs
  064AA7  16C7: e86812           call 0x2932
  064AAA  16CA: 83c402           add sp, 2
  064AAD  16CD: a1801e           mov ax, word ptr [0x1e80]
  064AB0  16D0: 03067e1e         add ax, word ptr [0x1e7e]
  064AB4  16D4: 40               inc ax
  064AB5  16D5: 69c04001         imul ax, ax, 0x140
  064AB9  16D9: 3b06222d         cmp ax, word ptr [0x2d22]
  064ABD  16DD: 7fe5             jg 0x16c4
  064ABF  16DF: 9adc071f1a       lcall 0x1a1f, 0x7dc
  064AC4  16E4: 2bc0             sub ax, ax
  064AC6  16E6: 8946e6           mov word ptr [bp - 0x1a], ax
  064AC9  16E9: 8946de           mov word ptr [bp - 0x22], ax
  064ACC  16EC: eb12             jmp 0x1700
  064ACE  16EE: 8b5ede           mov bx, word ptr [bp - 0x22]
  064AD1  16F1: d1e3             shl bx, 1
  064AD3  16F3: 83bfc88500       cmp word ptr [bx - 0x7a38], 0
  064AD8  16F8: 7403             je 0x16fd
  064ADA  16FA: ff46e6           inc word ptr [bp - 0x1a]
  064ADD  16FD: ff46de           inc word ptr [bp - 0x22]
  064AE0  1700: 837ede10         cmp word ptr [bp - 0x22], 0x10
  064AE4  1704: 7ce8             jl 0x16ee
  064AE6  1706: b80f00           mov ax, 0xf
  064AE9  1709: 2b46e6           sub ax, word ptr [bp - 0x1a]
  064AEC  170C: 8946d6           mov word ptr [bp - 0x2a], ax
  064AEF  170F: 0bc0             or ax, ax
  064AF1  1711: 7e35             jle 0x1748
  064AF3  1713: 833e801e00       cmp word ptr [0x1e80], 0
  064AF8  1718: 7e13             jle 0x172d
  064AFA  171A: 50               push ax
  064AFB  171B: 6a00             push 0
  064AFD  171D: 9ad4041f18       lcall 0x181f, 0x4d4
  064B02  1722: 83c404           add sp, 4
  064B05  1725: 2b46d6           sub ax, word ptr [bp - 0x2a]
  064B08  1728: f7d8             neg ax
  064B0A  172A: 8946d6           mov word ptr [bp - 0x2a], ax
  064B0D  172D: c746de0000       mov word ptr [bp - 0x22], 0
  064B12  1732: eb0c             jmp 0x1740
  064B14  1734: 6a01             push 1
  064B16  1736: 0e               push cs
  064B17  1737: e8f811           call 0x2932
  064B1A  173A: 83c402           add sp, 2
  064B1D  173D: ff46de           inc word ptr [bp - 0x22]
  064B20  1740: 8b46de           mov ax, word ptr [bp - 0x22]
  064B23  1743: 3946d6           cmp word ptr [bp - 0x2a], ax
  064B26  1746: 7fec             jg 0x1734
  064B28  1748: c746dc0100       mov word ptr [bp - 0x24], 1
  064B2D  174D: e92d01           jmp 0x187d
  064B30  1750: ff46e2           inc word ptr [bp - 0x1e]
  064B33  1753: a13a85           mov ax, word ptr [0x853a]
  064B36  1756: 48               dec ax
  064B37  1757: 3b46e2           cmp ax, word ptr [bp - 0x1e]
  064B3A  175A: 7f03             jg 0x175f
  064B3C  175C: e91b01           jmp 0x187a
  064B3F  175F: c746d20000       mov word ptr [bp - 0x2e], 0
  064B44  1764: ff36b685         push word ptr [0x85b6]
  064B48  1768: ff36b485         push word ptr [0x85b4]
  064B4C  176C: ff36b285         push word ptr [0x85b2]
  064B50  1770: ff36b085         push word ptr [0x85b0]
  064B54  1774: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064B57  1777: 8b56dc           mov dx, word ptr [bp - 0x24]
  064B5A  177A: 9a68081f1a       lcall 0x1a1f, 0x868
  064B5F  177F: 0ac0             or al, al
  064B61  1781: 7405             je 0x1788
  064B63  1783: c746d20100       mov word ptr [bp - 0x2e], 1
  064B68  1788: ff36b685         push word ptr [0x85b6]
  064B6C  178C: ff36b485         push word ptr [0x85b4]
  064B70  1790: ff36b285         push word ptr [0x85b2]
  064B74  1794: ff36b085         push word ptr [0x85b0]
  064B78  1798: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064B7B  179B: 40               inc ax
  064B7C  179C: 8b56dc           mov dx, word ptr [bp - 0x24]
  064B7F  179F: 9a68081f1a       lcall 0x1a1f, 0x868
  064B84  17A4: 0ac0             or al, al
  064B86  17A6: 7404             je 0x17ac
  064B88  17A8: 804ed202         or byte ptr [bp - 0x2e], 2
  064B8C  17AC: ff36b685         push word ptr [0x85b6]
  064B90  17B0: ff36b485         push word ptr [0x85b4]
  064B94  17B4: ff36b285         push word ptr [0x85b2]
  064B98  17B8: ff36b085         push word ptr [0x85b0]
  064B9C  17BC: 8b56dc           mov dx, word ptr [bp - 0x24]
  064B9F  17BF: 42               inc dx
  064BA0  17C0: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064BA3  17C3: 9a68081f1a       lcall 0x1a1f, 0x868
  064BA8  17C8: 0ac0             or al, al
  064BAA  17CA: 7404             je 0x17d0
  064BAC  17CC: 804ed204         or byte ptr [bp - 0x2e], 4
  064BB0  17D0: ff36b685         push word ptr [0x85b6]
  064BB4  17D4: ff36b485         push word ptr [0x85b4]
  064BB8  17D8: ff36b285         push word ptr [0x85b2]
  064BBC  17DC: ff36b085         push word ptr [0x85b0]
  064BC0  17E0: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064BC3  17E3: 40               inc ax
  064BC4  17E4: 8b56dc           mov dx, word ptr [bp - 0x24]
  064BC7  17E7: 42               inc dx
  064BC8  17E8: 9a68081f1a       lcall 0x1a1f, 0x868
  064BCD  17ED: 0ac0             or al, al
  064BCF  17EF: 7404             je 0x17f5
  064BD1  17F1: 804ed208         or byte ptr [bp - 0x2e], 8
  064BD5  17F5: 837ed206         cmp word ptr [bp - 0x2e], 6
  064BD9  17F9: 7409             je 0x1804
  064BDB  17FB: 837ed209         cmp word ptr [bp - 0x2e], 9
  064BDF  17FF: 7403             je 0x1804
  064BE1  1801: e94cff           jmp 0x1750
  064BE4  1804: ff36b685         push word ptr [0x85b6]
  064BE8  1808: ff36b485         push word ptr [0x85b4]
  064BEC  180C: ff36b285         push word ptr [0x85b2]
  064BF0  1810: ff36b085         push word ptr [0x85b0]
  064BF4  1814: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064BF7  1817: 40               inc ax
  064BF8  1818: 8b56dc           mov dx, word ptr [bp - 0x24]
  064BFB  181B: bb0100           mov bx, 1
  064BFE  181E: 8bf0             mov si, ax
  064C00  1820: 9a72081f1a       lcall 0x1a1f, 0x872
  064C05  1825: ff36b685         push word ptr [0x85b6]
  064C09  1829: ff36b485         push word ptr [0x85b4]
  064C0D  182D: ff36b285         push word ptr [0x85b2]
  064C11  1831: ff36b085         push word ptr [0x85b0]
  064C15  1835: 8b56dc           mov dx, word ptr [bp - 0x24]
  064C18  1838: 42               inc dx
  064C19  1839: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064C1C  183C: bb0100           mov bx, 1
  064C1F  183F: 8bfa             mov di, dx
  064C21  1841: 9a72081f1a       lcall 0x1a1f, 0x872
  064C26  1846: ff36b685         push word ptr [0x85b6]
  064C2A  184A: ff36b485         push word ptr [0x85b4]
  064C2E  184E: ff36b285         push word ptr [0x85b2]
  064C32  1852: ff36b085         push word ptr [0x85b0]
  064C36  1856: 8bc6             mov ax, si
  064C38  1858: 8bd7             mov dx, di
  064C3A  185A: bb0100           mov bx, 1
  064C3D  185D: 9a72081f1a       lcall 0x1a1f, 0x872
  064C42  1862: 837ee200         cmp word ptr [bp - 0x1e], 0
  064C46  1866: 7403             je 0x186b
  064C48  1868: ff4ee2           dec word ptr [bp - 0x1e]
  064C4B  186B: 837edc00         cmp word ptr [bp - 0x24], 0
  064C4F  186F: 7503             jne 0x1874
  064C51  1871: e9dcfe           jmp 0x1750
  064C54  1874: ff4edc           dec word ptr [bp - 0x24]
  064C57  1877: e9d6fe           jmp 0x1750
  064C5A  187A: ff46dc           inc word ptr [bp - 0x24]
  064C5D  187D: a13c85           mov ax, word ptr [0x853c]
  064C60  1880: 48               dec ax
  064C61  1881: 3b46dc           cmp ax, word ptr [bp - 0x24]
  064C64  1884: 7e08             jle 0x188e
  064C66  1886: c746e20100       mov word ptr [bp - 0x1e], 1
  064C6B  188B: e9c5fe           jmp 0x1753
  064C6E  188E: 9aac031f18       lcall 0x181f, 0x3ac
  064C73  1893: c746dc0000       mov word ptr [bp - 0x24], 0
  064C78  1898: e94101           jmp 0x19dc
  064C7B  189B: 90               nop 
  064C7C  189C: 6a10             push 0x10
  064C7E  189E: 6a01             push 1
  064C80  18A0: 9ad4041f18       lcall 0x181f, 0x4d4
  064C85  18A5: 83c404           add sp, 4
  064C88  18A8: 8bc8             mov cx, ax
  064C8A  18AA: a13c85           mov ax, word ptr [0x853c]
  064C8D  18AD: d1f8             sar ax, 1
  064C8F  18AF: 2bc1             sub ax, cx
  064C91  18B1: 2b46dc           sub ax, word ptr [bp - 0x24]
  064C94  18B4: 050800           add ax, 8
  064C97  18B7: f7d0             not ax
  064C99  18B9: 40               inc ax
  064C9A  18BA: 8946fa           mov word ptr [bp - 6], ax
  064C9D  18BD: b80100           mov ax, 1
  064CA0  18C0: 2b06821e         sub ax, word ptr [0x1e82]
  064CA4  18C4: d1e0             shl ax, 1
  064CA6  18C6: 0146fa           add word ptr [bp - 6], ax
  064CA9  18C9: 8b46fa           mov ax, word ptr [bp - 6]
  064CAC  18CC: 0bc0             or ax, ax
  064CAE  18CE: 7d02             jge 0x18d2
  064CB0  18D0: 2bc0             sub ax, ax
  064CB2  18D2: 8946fa           mov word ptr [bp - 6], ax
  064CB5  18D5: c17efa02         sar word ptr [bp - 6], 2
  064CB9  18D9: 8b46fa           mov ax, word ptr [bp - 6]
  064CBC  18DC: eb30             jmp 0x190e
  064CBE  18DE: c746d20500       mov word ptr [bp - 0x2e], 5
  064CC3  18E3: eb43             jmp 0x1928
  064CC5  18E5: 90               nop 
  064CC6  18E6: c746d20400       mov word ptr [bp - 0x2e], 4
  064CCB  18EB: eb3b             jmp 0x1928
  064CCD  18ED: 90               nop 
  064CCE  18EE: c746d20100       mov word ptr [bp - 0x2e], 1
  064CD3  18F3: eb33             jmp 0x1928
  064CD5  18F5: 90               nop 
  064CD6  18F6: c746d20300       mov word ptr [bp - 0x2e], 3
  064CDB  18FB: eb2b             jmp 0x1928
  064CDD  18FD: 90               nop 
  064CDE  18FE: c746d20200       mov word ptr [bp - 0x2e], 2
  064CE3  1903: eb23             jmp 0x1928
  064CE5  1905: 90               nop 
  064CE6  1906: c746d20000       mov word ptr [bp - 0x2e], 0
  064CEB  190B: eb1b             jmp 0x1928
  064CED  190D: 90               nop 
  064CEE  190E: 3d0500           cmp ax, 5
  064CF1  1911: 77f3             ja 0x1906
  064CF3  1913: d1e0             shl ax, 1
  064CF5  1915: 93               xchg bx, ax
  064CF6  1916: 2effa7ac0b       jmp word ptr cs:[bx + 0xbac]
  064CFB  191B: 90               nop 
  064CFC  191C: 6e               outsb dx, byte ptr [si]
  064CFD  191D: 0b760b           or si, word ptr [bp + 0xb]
  064D00  1920: 7e0b             jle 0x192d
  064D02  1922: 860b             xchg byte ptr [bp + di], cl
  064D04  1924: 8e0b             mov cs, word ptr [bp + di]
  064D06  1926: 8e0b             mov cs, word ptr [bp + di]
  064D08  1928: 837eea00         cmp word ptr [bp - 0x16], 0
  064D0C  192C: 7505             jne 0x1933
  064D0E  192E: c746d21900       mov word ptr [bp - 0x2e], 0x19
  064D13  1933: 837eea02         cmp word ptr [bp - 0x16], 2
  064D17  1937: 7c04             jl 0x193d
  064D19  1939: 804ed220         or byte ptr [bp - 0x2e], 0x20
  064D1D  193D: 837eea03         cmp word ptr [bp - 0x16], 3
  064D21  1941: 7c04             jl 0x1947
  064D23  1943: 804ed280         or byte ptr [bp - 0x2e], 0x80
  064D27  1947: ff36ae85         push word ptr [0x85ae]
  064D2B  194B: ff36ac85         push word ptr [0x85ac]
  064D2F  194F: ff36aa85         push word ptr [0x85aa]
  064D33  1953: ff36a885         push word ptr [0x85a8]
  064D37  1957: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064D3A  195A: 8b56dc           mov dx, word ptr [bp - 0x24]
  064D3D  195D: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  064D40  1960: 9a72081f1a       lcall 0x1a1f, 0x872
  064D45  1965: ff46e2           inc word ptr [bp - 0x1e]
  064D48  1968: a13a85           mov ax, word ptr [0x853a]
  064D4B  196B: 3946e2           cmp word ptr [bp - 0x1e], ax
  064D4E  196E: 7d64             jge 0x19d4
  064D50  1970: ff36b685         push word ptr [0x85b6]
  064D54  1974: ff36b485         push word ptr [0x85b4]
  064D58  1978: ff36b285         push word ptr [0x85b2]
  064D5C  197C: ff36b085         push word ptr [0x85b0]
  064D60  1980: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064D63  1983: 8b56dc           mov dx, word ptr [bp - 0x24]
  064D66  1986: 9a68081f1a       lcall 0x1a1f, 0x868
  064D6B  198B: 2ae4             sub ah, ah
  064D6D  198D: 8946ea           mov word ptr [bp - 0x16], ax
  064D70  1990: c746d21900       mov word ptr [bp - 0x2e], 0x19
  064D75  1995: 6a10             push 0x10
  064D77  1997: 6a01             push 1
  064D79  1999: 9ad4041f18       lcall 0x181f, 0x4d4
  064D7E  199E: 83c404           add sp, 4
  064D81  19A1: 8b0e3c85         mov cx, word ptr [0x853c]
  064D85  19A5: d1f9             sar cx, 1
  064D87  19A7: 2bc8             sub cx, ax
  064D89  19A9: 2b4edc           sub cx, word ptr [bp - 0x24]
  064D8C  19AC: 83c108           add cx, 8
  064D8F  19AF: 0bc9             or cx, cx
  064D91  19B1: 7f03             jg 0x19b6
  064D93  19B3: e9e6fe           jmp 0x189c
  064D96  19B6: 6a10             push 0x10
  064D98  19B8: 6a01             push 1
  064D9A  19BA: 9ad4041f18       lcall 0x181f, 0x4d4
  064D9F  19BF: 83c404           add sp, 4
  064DA2  19C2: 8bc8             mov cx, ax
  064DA4  19C4: a13c85           mov ax, word ptr [0x853c]
  064DA7  19C7: d1f8             sar ax, 1
  064DA9  19C9: 2bc1             sub ax, cx
  064DAB  19CB: 2b46dc           sub ax, word ptr [bp - 0x24]
  064DAE  19CE: 050800           add ax, 8
  064DB1  19D1: e9e6fe           jmp 0x18ba
  064DB4  19D4: 9aac031f18       lcall 0x181f, 0x3ac
  064DB9  19D9: ff46dc           inc word ptr [bp - 0x24]
  064DBC  19DC: a13c85           mov ax, word ptr [0x853c]
  064DBF  19DF: 3946dc           cmp word ptr [bp - 0x24], ax
  064DC2  19E2: 7d08             jge 0x19ec
  064DC4  19E4: c746e20000       mov word ptr [bp - 0x1e], 0
  064DC9  19E9: e97cff           jmp 0x1968
  064DCC  19EC: c746dc0000       mov word ptr [bp - 0x24], 0
  064DD1  19F1: e92603           jmp 0x1d1a
  064DD4  19F4: a13c85           mov ax, word ptr [0x853c]
  064DD7  19F7: d1f8             sar ax, 1
  064DD9  19F9: 2b46dc           sub ax, word ptr [bp - 0x24]
  064DDC  19FC: f7d0             not ax
  064DDE  19FE: 40               inc ax
  064DDF  19FF: 8946fa           mov word ptr [bp - 6], ax
  064DE2  1A02: a13c85           mov ax, word ptr [0x853c]
  064DE5  1A05: c1f802           sar ax, 2
  064DE8  1A08: 2b46fa           sub ax, word ptr [bp - 6]
  064DEB  1A0B: 8946cc           mov word ptr [bp - 0x34], ax
  064DEE  1A0E: 0bc0             or ax, ax
  064DF0  1A10: 7f0c             jg 0x1a1e
  064DF2  1A12: a13c85           mov ax, word ptr [0x853c]
  064DF5  1A15: c1f802           sar ax, 2
  064DF8  1A18: 2b46fa           sub ax, word ptr [bp - 6]
  064DFB  1A1B: f7d0             not ax
  064DFD  1A1D: 40               inc ax
  064DFE  1A1E: 8b0e841e         mov cx, word ptr [0x1e84]
  064E02  1A22: c1e102           shl cx, 2
  064E05  1A25: 03c1             add ax, cx
  064E07  1A27: 50               push ax
  064E08  1A28: 6a00             push 0
  064E0A  1A2A: 9ad4041f18       lcall 0x181f, 0x4d4
  064E0F  1A2F: 83c404           add sp, 4
  064E12  1A32: 8946f0           mov word ptr [bp - 0x10], ax
  064E15  1A35: c746e20000       mov word ptr [bp - 0x1e], 0
  064E1A  1A3A: e96701           jmp 0x1ba4
  064E1D  1A3D: 90               nop 
  064E1E  1A3E: a13c85           mov ax, word ptr [0x853c]
  064E21  1A41: c1f802           sar ax, 2
  064E24  1A44: 2b46fa           sub ax, word ptr [bp - 6]
  064E27  1A47: f7d0             not ax
  064E29  1A49: 40               inc ax
  064E2A  1A4A: 8b0e841e         mov cx, word ptr [0x1e84]
  064E2E  1A4E: c1e102           shl cx, 2
  064E31  1A51: 03c1             add ax, cx
  064E33  1A53: 3b46f0           cmp ax, word ptr [bp - 0x10]
  064E36  1A56: 7f03             jg 0x1a5b
  064E38  1A58: e91e01           jmp 0x1b79
  064E3B  1A5B: e91801           jmp 0x1b76
  064E3E  1A5E: f646ea80         test byte ptr [bp - 0x16], 0x80
  064E42  1A62: 7408             je 0x1a6c
  064E44  1A64: 836ef003         sub word ptr [bp - 0x10], 3
  064E48  1A68: e9b900           jmp 0x1b24
  064E4B  1A6B: 90               nop 
  064E4C  1A6C: f646ea20         test byte ptr [bp - 0x16], 0x20
  064E50  1A70: 7408             je 0x1a7a
  064E52  1A72: 8066ea5f         and byte ptr [bp - 0x16], 0x5f
  064E56  1A76: e9ab00           jmp 0x1b24
  064E59  1A79: 90               nop 
  064E5A  1A7A: 837ef000         cmp word ptr [bp - 0x10], 0
  064E5E  1A7E: 7d74             jge 0x1af4
  064E60  1A80: 0bc0             or ax, ax
  064E62  1A82: 7450             je 0x1ad4
  064E64  1A84: 48               dec ax
  064E65  1A85: 48               dec ax
  064E66  1A86: 7444             je 0x1acc
  064E68  1A88: 48               dec ax
  064E69  1A89: 740f             je 0x1a9a
  064E6B  1A8B: 48               dec ax
  064E6C  1A8C: 7403             je 0x1a91
  064E6E  1A8E: e99300           jmp 0x1b24
  064E71  1A91: c746ee0300       mov word ptr [bp - 0x12], 3
  064E76  1A96: e98b00           jmp 0x1b24
  064E79  1A99: 90               nop 
  064E7A  1A9A: 837ef000         cmp word ptr [bp - 0x10], 0
  064E7E  1A9E: 7e06             jle 0x1aa6
  064E80  1AA0: 8b46f0           mov ax, word ptr [bp - 0x10]
  064E83  1AA3: eb07             jmp 0x1aac
  064E85  1AA5: 90               nop 
  064E86  1AA6: 8b46f0           mov ax, word ptr [bp - 0x10]
  064E89  1AA9: f7d0             not ax
  064E8B  1AAB: 40               inc ax
  064E8C  1AAC: 50               push ax
  064E8D  1AAD: 6a00             push 0
  064E8F  1AAF: 9ad4041f18       lcall 0x181f, 0x4d4
  064E94  1AB4: 83c404           add sp, 4
  064E97  1AB7: 0bc0             or ax, ax
  064E99  1AB9: 7407             je 0x1ac2
  064E9B  1ABB: c746ee0100       mov word ptr [bp - 0x12], 1
  064EA0  1AC0: eb62             jmp 0x1b24
  064EA2  1AC2: c746ee0200       mov word ptr [bp - 0x12], 2
  064EA7  1AC7: ff4ef0           dec word ptr [bp - 0x10]
  064EAA  1ACA: eb58             jmp 0x1b24
  064EAC  1ACC: c746ee0000       mov word ptr [bp - 0x12], 0
  064EB1  1AD1: eb51             jmp 0x1b24
  064EB3  1AD3: 90               nop 
  064EB4  1AD4: ff36b685         push word ptr [0x85b6]
  064EB8  1AD8: ff36b485         push word ptr [0x85b4]
  064EBC  1ADC: ff36b285         push word ptr [0x85b2]
  064EC0  1AE0: ff36b085         push word ptr [0x85b0]
  064EC4  1AE4: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064EC7  1AE7: 8b56dc           mov dx, word ptr [bp - 0x24]
  064ECA  1AEA: bb0200           mov bx, 2
  064ECD  1AED: 9a72081f1a       lcall 0x1a1f, 0x872
  064ED2  1AF2: eb30             jmp 0x1b24
  064ED4  1AF4: 837ef000         cmp word ptr [bp - 0x10], 0
  064ED8  1AF8: 7e2a             jle 0x1b24
  064EDA  1AFA: 0bc0             or ax, ax
  064EDC  1AFC: 746a             je 0x1b68
  064EDE  1AFE: 48               dec ax
  064EDF  1AFF: 48               dec ax
  064EE0  1B00: 748f             je 0x1a91
  064EE2  1B02: 48               dec ax
  064EE3  1B03: 745b             je 0x1b60
  064EE5  1B05: 48               dec ax
  064EE6  1B06: 743c             je 0x1b44
  064EE8  1B08: 48               dec ax
  064EE9  1B09: 7519             jne 0x1b24
  064EEB  1B0B: 836ef002         sub word ptr [bp - 0x10], 2
  064EEF  1B0F: 6a03             push 3
  064EF1  1B11: 6a00             push 0
  064EF3  1B13: 9ad4041f18       lcall 0x181f, 0x4d4
  064EF8  1B18: 83c404           add sp, 4
  064EFB  1B1B: 0bc0             or ax, ax
  064EFD  1B1D: 7505             jne 0x1b24
  064EFF  1B1F: c746ee0700       mov word ptr [bp - 0x12], 7
  064F04  1B24: 837ef000         cmp word ptr [bp - 0x10], 0
  064F08  1B28: 7e46             jle 0x1b70
  064F0A  1B2A: a1841e           mov ax, word ptr [0x1e84]
  064F0D  1B2D: d1e0             shl ax, 1
  064F0F  1B2F: 2d0700           sub ax, 7
  064F12  1B32: f7d8             neg ax
  064F14  1B34: 50               push ax
  064F15  1B35: 6a01             push 1
  064F17  1B37: 9ad4041f18       lcall 0x181f, 0x4d4
  064F1C  1B3C: 83c404           add sp, 4
  064F1F  1B3F: 2946f0           sub word ptr [bp - 0x10], ax
  064F22  1B42: eb35             jmp 0x1b79
  064F24  1B44: 836ef002         sub word ptr [bp - 0x10], 2
  064F28  1B48: 6a03             push 3
  064F2A  1B4A: 6a00             push 0
  064F2C  1B4C: 9ad4041f18       lcall 0x181f, 0x4d4
  064F31  1B51: 83c404           add sp, 4
  064F34  1B54: 0bc0             or ax, ax
  064F36  1B56: 75cc             jne 0x1b24
  064F38  1B58: c746ee0600       mov word ptr [bp - 0x12], 6
  064F3D  1B5D: ebc5             jmp 0x1b24
  064F3F  1B5F: 90               nop 
  064F40  1B60: c746ee0400       mov word ptr [bp - 0x12], 4
  064F45  1B65: ebbd             jmp 0x1b24
  064F47  1B67: 90               nop 
  064F48  1B68: c746ee0200       mov word ptr [bp - 0x12], 2
  064F4D  1B6D: ebb5             jmp 0x1b24
  064F4F  1B6F: 90               nop 
  064F50  1B70: 837ef000         cmp word ptr [bp - 0x10], 0
  064F54  1B74: 7d03             jge 0x1b79
  064F56  1B76: ff46f0           inc word ptr [bp - 0x10]
  064F59  1B79: ff36ae85         push word ptr [0x85ae]
  064F5D  1B7D: ff36ac85         push word ptr [0x85ac]
  064F61  1B81: ff36aa85         push word ptr [0x85aa]
  064F65  1B85: ff36a885         push word ptr [0x85a8]
  064F69  1B89: 8a5eea           mov bl, byte ptr [bp - 0x16]
  064F6C  1B8C: 81e3e000         and bx, 0xe0
  064F70  1B90: 0b5eee           or bx, word ptr [bp - 0x12]
  064F73  1B93: 895eea           mov word ptr [bp - 0x16], bx
  064F76  1B96: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064F79  1B99: 8b56dc           mov dx, word ptr [bp - 0x24]
  064F7C  1B9C: 9a72081f1a       lcall 0x1a1f, 0x872
  064F81  1BA1: ff46e2           inc word ptr [bp - 0x1e]
  064F84  1BA4: a13a85           mov ax, word ptr [0x853a]
  064F87  1BA7: 3946e2           cmp word ptr [bp - 0x1e], ax
  064F8A  1BAA: 7d46             jge 0x1bf2
  064F8C  1BAC: ff36ae85         push word ptr [0x85ae]
  064F90  1BB0: ff36ac85         push word ptr [0x85ac]
  064F94  1BB4: ff36aa85         push word ptr [0x85aa]
  064F98  1BB8: ff36a885         push word ptr [0x85a8]
  064F9C  1BBC: 8b46e2           mov ax, word ptr [bp - 0x1e]
  064F9F  1BBF: 8b56dc           mov dx, word ptr [bp - 0x24]
  064FA2  1BC2: 9a68081f1a       lcall 0x1a1f, 0x868
  064FA7  1BC7: 2ae4             sub ah, ah
  064FA9  1BC9: 8946ea           mov word ptr [bp - 0x16], ax
  064FAC  1BCC: 251f00           and ax, 0x1f
  064FAF  1BCF: 8946ee           mov word ptr [bp - 0x12], ax
  064FB2  1BD2: 837eea19         cmp word ptr [bp - 0x16], 0x19
  064FB6  1BD6: 7403             je 0x1bdb
  064FB8  1BD8: e983fe           jmp 0x1a5e
  064FBB  1BDB: a13c85           mov ax, word ptr [0x853c]
  064FBE  1BDE: c1f802           sar ax, 2
  064FC1  1BE1: 2b46fa           sub ax, word ptr [bp - 6]
  064FC4  1BE4: 8946ce           mov word ptr [bp - 0x32], ax
  064FC7  1BE7: 0bc0             or ax, ax
  064FC9  1BE9: 7f03             jg 0x1bee
  064FCB  1BEB: e950fe           jmp 0x1a3e
  064FCE  1BEE: e959fe           jmp 0x1a4a
  064FD1  1BF1: 90               nop 
  064FD2  1BF2: c746f00000       mov word ptr [bp - 0x10], 0
  064FD7  1BF7: 48               dec ax
  064FD8  1BF8: 8946e2           mov word ptr [bp - 0x1e], ax
  064FDB  1BFB: e9d000           jmp 0x1cce
  064FDE  1BFE: f646ea80         test byte ptr [bp - 0x16], 0x80
  064FE2  1C02: 7406             je 0x1c0a
  064FE4  1C04: 836ef003         sub word ptr [bp - 0x10], 3
  064FE8  1C08: eb70             jmp 0x1c7a
  064FEA  1C0A: f646ea20         test byte ptr [bp - 0x16], 0x20
  064FEE  1C0E: 7406             je 0x1c16
  064FF0  1C10: 8066ea5f         and byte ptr [bp - 0x16], 0x5f
  064FF4  1C14: eb64             jmp 0x1c7a
  064FF6  1C16: 837ef000         cmp word ptr [bp - 0x10], 0
  064FFA  1C1A: 7c5e             jl 0x1c7a
  064FFC  1C1C: 7e5c             jle 0x1c7a
  064FFE  1C1E: eb40             jmp 0x1c60
  065000  1C20: 836ef002         sub word ptr [bp - 0x10], 2
  065004  1C24: c746ee0700       mov word ptr [bp - 0x12], 7
  065009  1C29: eb4f             jmp 0x1c7a
  06500B  1C2B: 90               nop 
  06500C  1C2C: 836ef002         sub word ptr [bp - 0x10], 2
  065010  1C30: 6a01             push 1
  065012  1C32: 6a00             push 0
  065014  1C34: 9ad4041f18       lcall 0x181f, 0x4d4
  065019  1C39: 83c404           add sp, 4
  06501C  1C3C: 0bc0             or ax, ax
  06501E  1C3E: 753a             jne 0x1c7a
  065020  1C40: c746ee0600       mov word ptr [bp - 0x12], 6
  065025  1C45: eb33             jmp 0x1c7a
  065027  1C47: 90               nop 
  065028  1C48: c746ee0400       mov word ptr [bp - 0x12], 4
  06502D  1C4D: eb2b             jmp 0x1c7a
  06502F  1C4F: 90               nop 
  065030  1C50: c746ee0300       mov word ptr [bp - 0x12], 3
  065035  1C55: eb23             jmp 0x1c7a
  065037  1C57: 90               nop 
  065038  1C58: c746ee0200       mov word ptr [bp - 0x12], 2
  06503D  1C5D: eb1b             jmp 0x1c7a
  06503F  1C5F: 90               nop 
  065040  1C60: 3d0500           cmp ax, 5
  065043  1C63: 7715             ja 0x1c7a
  065045  1C65: d1e0             shl ax, 1
  065047  1C67: 93               xchg bx, ax
  065048  1C68: 2effa7fe0e       jmp word ptr cs:[bx + 0xefe]
  06504D  1C6D: 90               nop 
  06504E  1C6E: e80ee0           call 0xfffffc7f
  065051  1C71: 0e               push cs
  065052  1C72: e00e             loopne 0x1c82
  065054  1C74: d80ebc0e         fmul dword ptr [0xebc]
  065058  1C78: b00e             mov al, 0xe
  06505A  1C7A: 837ef000         cmp word ptr [bp - 0x10], 0
  06505E  1C7E: 7e1a             jle 0x1c9a
  065060  1C80: a1841e           mov ax, word ptr [0x1e84]
  065063  1C83: d1e0             shl ax, 1
  065065  1C85: 2d0700           sub ax, 7
  065068  1C88: f7d8             neg ax
  06506A  1C8A: 50               push ax
  06506B  1C8B: 6a01             push 1
  06506D  1C8D: 9ad4041f18       lcall 0x181f, 0x4d4
  065072  1C92: 83c404           add sp, 4
  065075  1C95: 2946f0           sub word ptr [bp - 0x10], ax
  065078  1C98: eb09             jmp 0x1ca3
  06507A  1C9A: 837ef000         cmp word ptr [bp - 0x10], 0
  06507E  1C9E: 7d03             jge 0x1ca3
  065080  1CA0: ff46f0           inc word ptr [bp - 0x10]
  065083  1CA3: ff36ae85         push word ptr [0x85ae]
  065087  1CA7: ff36ac85         push word ptr [0x85ac]
  06508B  1CAB: ff36aa85         push word ptr [0x85aa]
  06508F  1CAF: ff36a885         push word ptr [0x85a8]
  065093  1CB3: 8a5eea           mov bl, byte ptr [bp - 0x16]
  065096  1CB6: 81e3e000         and bx, 0xe0
  06509A  1CBA: 0b5eee           or bx, word ptr [bp - 0x12]
  06509D  1CBD: 895eea           mov word ptr [bp - 0x16], bx
  0650A0  1CC0: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0650A3  1CC3: 8b56dc           mov dx, word ptr [bp - 0x24]
  0650A6  1CC6: 9a72081f1a       lcall 0x1a1f, 0x872
  0650AB  1CCB: ff4ee2           dec word ptr [bp - 0x1e]
  0650AE  1CCE: 837ee200         cmp word ptr [bp - 0x1e], 0
  0650B2  1CD2: 7c3e             jl 0x1d12
  0650B4  1CD4: ff36ae85         push word ptr [0x85ae]
  0650B8  1CD8: ff36ac85         push word ptr [0x85ac]
  0650BC  1CDC: ff36aa85         push word ptr [0x85aa]
  0650C0  1CE0: ff36a885         push word ptr [0x85a8]
  0650C4  1CE4: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0650C7  1CE7: 8b56dc           mov dx, word ptr [bp - 0x24]
  0650CA  1CEA: 9a68081f1a       lcall 0x1a1f, 0x868
  0650CF  1CEF: 2ae4             sub ah, ah
  0650D1  1CF1: 8946ea           mov word ptr [bp - 0x16], ax
  0650D4  1CF4: 251f00           and ax, 0x1f
  0650D7  1CF7: 8946ee           mov word ptr [bp - 0x12], ax
  0650DA  1CFA: 3d1900           cmp ax, 0x19
  0650DD  1CFD: 7403             je 0x1d02
  0650DF  1CFF: e9fcfe           jmp 0x1bfe
  0650E2  1D02: 8b46fa           mov ax, word ptr [bp - 6]
  0650E5  1D05: d1f8             sar ax, 1
  0650E7  1D07: 0306841e         add ax, word ptr [0x1e84]
  0650EB  1D0B: 3b46f0           cmp ax, word ptr [bp - 0x10]
  0650EE  1D0E: 7e93             jle 0x1ca3
  0650F0  1D10: eb8e             jmp 0x1ca0
  0650F2  1D12: 9aac031f18       lcall 0x181f, 0x3ac
  0650F7  1D17: ff46dc           inc word ptr [bp - 0x24]
  0650FA  1D1A: a13c85           mov ax, word ptr [0x853c]
  0650FD  1D1D: 3946dc           cmp word ptr [bp - 0x24], ax
  065100  1D20: 7d12             jge 0x1d34
  065102  1D22: d1f8             sar ax, 1
  065104  1D24: 2b46dc           sub ax, word ptr [bp - 0x24]
  065107  1D27: 8946ce           mov word ptr [bp - 0x32], ax
  06510A  1D2A: 0bc0             or ax, ax
  06510C  1D2C: 7f03             jg 0x1d31
  06510E  1D2E: e9c3fc           jmp 0x19f4
  065111  1D31: e9cbfc           jmp 0x19ff
  065114  1D34: c746de0000       mov word ptr [bp - 0x22], 0
  065119  1D39: e97102           jmp 0x1fad
  06511C  1D3C: a13a85           mov ax, word ptr [0x853a]
  06511F  1D3F: 48               dec ax
  065120  1D40: 48               dec ax
  065121  1D41: 50               push ax
  065122  1D42: 6a01             push 1
  065124  1D44: 9ad4041f18       lcall 0x181f, 0x4d4
  065129  1D49: 83c404           add sp, 4
  06512C  1D4C: 8946e2           mov word ptr [bp - 0x1e], ax
  06512F  1D4F: a13c85           mov ax, word ptr [0x853c]
  065132  1D52: 48               dec ax
  065133  1D53: 48               dec ax
  065134  1D54: 50               push ax
  065135  1D55: 6a01             push 1
  065137  1D57: 9ad4041f18       lcall 0x181f, 0x4d4
  06513C  1D5C: 83c404           add sp, 4
  06513F  1D5F: 8946dc           mov word ptr [bp - 0x24], ax
  065142  1D62: ff36ae85         push word ptr [0x85ae]
  065146  1D66: ff36ac85         push word ptr [0x85ac]
  06514A  1D6A: ff36aa85         push word ptr [0x85aa]
  06514E  1D6E: ff36a885         push word ptr [0x85a8]
  065152  1D72: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065155  1D75: 8b56dc           mov dx, word ptr [bp - 0x24]
  065158  1D78: 9a68081f1a       lcall 0x1a1f, 0x868
  06515D  1D7D: 2ae4             sub ah, ah
  06515F  1D7F: 8946ea           mov word ptr [bp - 0x16], ax
  065162  1D82: 251f00           and ax, 0x1f
  065165  1D85: 8946ee           mov word ptr [bp - 0x12], ax
  065168  1D88: f646ea80         test byte ptr [bp - 0x16], 0x80
  06516C  1D8C: 7420             je 0x1dae
  06516E  1D8E: ff76dc           push word ptr [bp - 0x24]
  065171  1D91: ff76e2           push word ptr [bp - 0x1e]
  065174  1D94: 0e               push cs
  065175  1D95: e89f0b           call 0x2937
  065178  1D98: 83c404           add sp, 4
  06517B  1D9B: 0bc0             or ax, ax
  06517D  1D9D: 7503             jne 0x1da2
  06517F  1D9F: e9ac01           jmp 0x1f4e
  065182  1DA2: 8b46ea           mov ax, word ptr [bp - 0x16]
  065185  1DA5: 245f             and al, 0x5f
  065187  1DA7: 8946ea           mov word ptr [bp - 0x16], ax
  06518A  1DAA: e9a101           jmp 0x1f4e
  06518D  1DAD: 90               nop 
  06518E  1DAE: f646ea20         test byte ptr [bp - 0x16], 0x20
  065192  1DB2: 7426             je 0x1dda
  065194  1DB4: 804eea80         or byte ptr [bp - 0x16], 0x80
  065198  1DB8: ff36b685         push word ptr [0x85b6]
  06519C  1DBC: ff36b485         push word ptr [0x85b4]
  0651A0  1DC0: ff36b285         push word ptr [0x85b2]
  0651A4  1DC4: ff36b085         push word ptr [0x85b0]
  0651A8  1DC8: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0651AB  1DCB: 8b56dc           mov dx, word ptr [bp - 0x24]
  0651AE  1DCE: bb0100           mov bx, 1
  0651B1  1DD1: 9a72081f1a       lcall 0x1a1f, 0x872
  0651B6  1DD6: e97501           jmp 0x1f4e
  0651B9  1DD9: 90               nop 
  0651BA  1DDA: 2bc0             sub ax, ax
  0651BC  1DDC: 8946e0           mov word ptr [bp - 0x20], ax
  0651BF  1DDF: 8946da           mov word ptr [bp - 0x26], ax
  0651C2  1DE2: 8b46ee           mov ax, word ptr [bp - 0x12]
  0651C5  1DE5: e94801           jmp 0x1f30
  0651C8  1DE8: b80100           mov ax, 1
  0651CB  1DEB: 8946e0           mov word ptr [bp - 0x20], ax
  0651CE  1DEE: 50               push ax
  0651CF  1DEF: 2bc0             sub ax, ax
  0651D1  1DF1: 8946da           mov word ptr [bp - 0x26], ax
  0651D4  1DF4: 50               push ax
  0651D5  1DF5: 9ad4041f18       lcall 0x181f, 0x4d4
  0651DA  1DFA: 83c404           add sp, 4
  0651DD  1DFD: 0bc0             or ax, ax
  0651DF  1DFF: 7403             je 0x1e04
  0651E1  1E01: e94a01           jmp 0x1f4e
  0651E4  1E04: c746ee0200       mov word ptr [bp - 0x12], 2
  0651E9  1E09: e94201           jmp 0x1f4e
  0651EC  1E0C: b80100           mov ax, 1
  0651EF  1E0F: 8946e0           mov word ptr [bp - 0x20], ax
  0651F2  1E12: 8946da           mov word ptr [bp - 0x26], ax
  0651F5  1E15: 50               push ax
  0651F6  1E16: 6a00             push 0
  0651F8  1E18: 9ad4041f18       lcall 0x181f, 0x4d4
  0651FD  1E1D: 83c404           add sp, 4
  065200  1E20: 0bc0             or ax, ax
  065202  1E22: 7403             je 0x1e27
  065204  1E24: e92701           jmp 0x1f4e
  065207  1E27: c746ee0300       mov word ptr [bp - 0x12], 3
  06520C  1E2C: e91f01           jmp 0x1f4e
  06520F  1E2F: 90               nop 
  065210  1E30: 837eee03         cmp word ptr [bp - 0x12], 3
  065214  1E34: 7515             jne 0x1e4b
  065216  1E36: 6a02             push 2
  065218  1E38: 6a00             push 0
  06521A  1E3A: 9ad4041f18       lcall 0x181f, 0x4d4
  06521F  1E3F: 83c404           add sp, 4
  065222  1E42: 0bc0             or ax, ax
  065224  1E44: 7505             jne 0x1e4b
  065226  1E46: c746ee0200       mov word ptr [bp - 0x12], 2
  06522B  1E4B: b80200           mov ax, 2
  06522E  1E4E: 8946da           mov word ptr [bp - 0x26], ax
  065231  1E51: 8946e0           mov word ptr [bp - 0x20], ax
  065234  1E54: 6a01             push 1
  065236  1E56: 6a00             push 0
  065238  1E58: 9ad4041f18       lcall 0x181f, 0x4d4
  06523D  1E5D: 83c404           add sp, 4
  065240  1E60: 0bc0             or ax, ax
  065242  1E62: 7403             je 0x1e67
  065244  1E64: e9e700           jmp 0x1f4e
  065247  1E67: ff36b685         push word ptr [0x85b6]
  06524B  1E6B: ff36b485         push word ptr [0x85b4]
  06524F  1E6F: ff36b285         push word ptr [0x85b2]
  065253  1E73: ff36b085         push word ptr [0x85b0]
  065257  1E77: 8b46e2           mov ax, word ptr [bp - 0x1e]
  06525A  1E7A: 8b56dc           mov dx, word ptr [bp - 0x24]
  06525D  1E7D: bb0200           mov bx, 2
  065260  1E80: e94eff           jmp 0x1dd1
  065263  1E83: 90               nop 
  065264  1E84: c746e00300       mov word ptr [bp - 0x20], 3
  065269  1E89: b80100           mov ax, 1
  06526C  1E8C: 8946da           mov word ptr [bp - 0x26], ax
  06526F  1E8F: 50               push ax
  065270  1E90: 6a00             push 0
  065272  1E92: 9ad4041f18       lcall 0x181f, 0x4d4
  065277  1E97: 83c404           add sp, 4
  06527A  1E9A: 0bc0             or ax, ax
  06527C  1E9C: 7527             jne 0x1ec5
  06527E  1E9E: c746ee0600       mov word ptr [bp - 0x12], 6
  065283  1EA3: eb20             jmp 0x1ec5
  065285  1EA5: 90               nop 
  065286  1EA6: c746e00300       mov word ptr [bp - 0x20], 3
  06528B  1EAB: c746da0200       mov word ptr [bp - 0x26], 2
  065290  1EB0: 6a01             push 1
  065292  1EB2: 6a00             push 0
  065294  1EB4: 9ad4041f18       lcall 0x181f, 0x4d4
  065299  1EB9: 83c404           add sp, 4
  06529C  1EBC: 0bc0             or ax, ax
  06529E  1EBE: 7505             jne 0x1ec5
  0652A0  1EC0: c746ee0700       mov word ptr [bp - 0x12], 7
  0652A5  1EC5: 6a01             push 1
  0652A7  1EC7: 6a00             push 0
  0652A9  1EC9: 9ad4041f18       lcall 0x181f, 0x4d4
  0652AE  1ECE: 83c404           add sp, 4
  0652B1  1ED1: 0bc0             or ax, ax
  0652B3  1ED3: 7579             jne 0x1f4e
  0652B5  1ED5: e9e0fe           jmp 0x1db8
  0652B8  1ED8: c746e00500       mov word ptr [bp - 0x20], 5
  0652BD  1EDD: c746da0300       mov word ptr [bp - 0x26], 3
  0652C2  1EE2: 6a01             push 1
  0652C4  1EE4: 6a00             push 0
  0652C6  1EE6: 9ad4041f18       lcall 0x181f, 0x4d4
  0652CB  1EEB: 83c404           add sp, 4
  0652CE  1EEE: 0bc0             or ax, ax
  0652D0  1EF0: 7403             je 0x1ef5
  0652D2  1EF2: e95fff           jmp 0x1e54
  0652D5  1EF5: c746ee0400       mov word ptr [bp - 0x12], 4
  0652DA  1EFA: e957ff           jmp 0x1e54
  0652DD  1EFD: 90               nop 
  0652DE  1EFE: c746e00500       mov word ptr [bp - 0x20], 5
  0652E3  1F03: c746da0300       mov word ptr [bp - 0x26], 3
  0652E8  1F08: 6a01             push 1
  0652EA  1F0A: 6a00             push 0
  0652EC  1F0C: 9ad4041f18       lcall 0x181f, 0x4d4
  0652F1  1F11: 83c404           add sp, 4
  0652F4  1F14: 0bc0             or ax, ax
  0652F6  1F16: 7405             je 0x1f1d
  0652F8  1F18: c746ee0500       mov word ptr [bp - 0x12], 5
  0652FD  1F1D: 6a01             push 1
  0652FF  1F1F: 6a00             push 0
  065301  1F21: 9ad4041f18       lcall 0x181f, 0x4d4
  065306  1F26: 83c404           add sp, 4
  065309  1F29: 0bc0             or ax, ax
  06530B  1F2B: 7421             je 0x1f4e
  06530D  1F2D: e937ff           jmp 0x1e67
  065310  1F30: 3d0700           cmp ax, 7
  065313  1F33: 7719             ja 0x1f4e
  065315  1F35: d1e0             shl ax, 1
  065317  1F37: 93               xchg bx, ax
  065318  1F38: 2effa7ce11       jmp word ptr cs:[bx + 0x11ce]
  06531D  1F3D: 90               nop 
  06531E  1F3E: 7810             js 0x1f50
  065320  1F40: 9c               pushf 
  065321  1F41: 10c0             adc al, al
  065323  1F43: 10c0             adc al, al
  065325  1F45: 1014             adc byte ptr [si], dl
  065327  1F47: 11361168         adc word ptr [0x6811], si
  06532B  1F4B: 118e1183         adc word ptr [bp - 0x7cef], cx
  06532F  1F4F: 7ee0             jle 0x1f31
  065331  1F51: 00742e           add byte ptr [si + 0x2e], dh
  065334  1F54: ff76e0           push word ptr [bp - 0x20]
  065337  1F57: 6a00             push 0
  065339  1F59: 9ad4041f18       lcall 0x181f, 0x4d4
  06533E  1F5E: 83c404           add sp, 4
  065341  1F61: 0bc0             or ax, ax
  065343  1F63: 751d             jne 0x1f82
  065345  1F65: 804eea20         or byte ptr [bp - 0x16], 0x20
  065349  1F69: 3946da           cmp word ptr [bp - 0x26], ax
  06534C  1F6C: 7414             je 0x1f82
  06534E  1F6E: ff76da           push word ptr [bp - 0x26]
  065351  1F71: 50               push ax
  065352  1F72: 9ad4041f18       lcall 0x181f, 0x4d4
  065357  1F77: 83c404           add sp, 4
  06535A  1F7A: 0bc0             or ax, ax
  06535C  1F7C: 7504             jne 0x1f82
  06535E  1F7E: 804eea80         or byte ptr [bp - 0x16], 0x80
  065362  1F82: ff36ae85         push word ptr [0x85ae]
  065366  1F86: ff36ac85         push word ptr [0x85ac]
  06536A  1F8A: ff36aa85         push word ptr [0x85aa]
  06536E  1F8E: ff36a885         push word ptr [0x85a8]
  065372  1F92: 8a5eea           mov bl, byte ptr [bp - 0x16]
  065375  1F95: 81e3e000         and bx, 0xe0
  065379  1F99: 0b5eee           or bx, word ptr [bp - 0x12]
  06537C  1F9C: 895eea           mov word ptr [bp - 0x16], bx
  06537F  1F9F: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065382  1FA2: 8b56dc           mov dx, word ptr [bp - 0x24]
  065385  1FA5: 9a72081f1a       lcall 0x1a1f, 0x872
  06538A  1FAA: ff46de           inc word ptr [bp - 0x22]
  06538D  1FAD: a1861e           mov ax, word ptr [0x1e86]
  065390  1FB0: 40               inc ax
  065391  1FB1: 69c02003         imul ax, ax, 0x320
  065395  1FB5: 3b46de           cmp ax, word ptr [bp - 0x22]
  065398  1FB8: 7e2e             jle 0x1fe8
  06539A  1FBA: f646de01         test byte ptr [bp - 0x22], 1
  06539E  1FBE: 7503             jne 0x1fc3
  0653A0  1FC0: e979fd           jmp 0x1d3c
  0653A3  1FC3: 6a08             push 8
  0653A5  1FC5: 6a00             push 0
  0653A7  1FC7: 9ad4041f18       lcall 0x181f, 0x4d4
  0653AC  1FCC: 83c404           add sp, 4
  0653AF  1FCF: 8bd8             mov bx, ax
  0653B1  1FD1: 895ed4           mov word ptr [bp - 0x2c], bx
  0653B4  1FD4: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0653B8  1FD8: 98               cwde 
  0653B9  1FD9: 0146e2           add word ptr [bp - 0x1e], ax
  0653BC  1FDC: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0653C0  1FE0: 98               cwde 
  0653C1  1FE1: 0146dc           add word ptr [bp - 0x24], ax
  0653C4  1FE4: e97bfd           jmp 0x1d62
  0653C7  1FE7: 90               nop 
  0653C8  1FE8: 9aac031f18       lcall 0x181f, 0x3ac
  0653CD  1FED: c746dc0000       mov word ptr [bp - 0x24], 0
  0653D2  1FF2: e9d000           jmp 0x20c5
  0653D5  1FF5: 90               nop 
  0653D6  1FF6: ff76dc           push word ptr [bp - 0x24]
  0653D9  1FF9: ff76e2           push word ptr [bp - 0x1e]
  0653DC  1FFC: 9a120d1f18       lcall 0x181f, 0xd12
  0653E1  2001: 83c404           add sp, 4
  0653E4  2004: 0bc0             or ax, ax
  0653E6  2006: 742a             je 0x2032
  0653E8  2008: 6a01             push 1
  0653EA  200A: 6a00             push 0
  0653EC  200C: 9ad4041f18       lcall 0x181f, 0x4d4
  0653F1  2011: 83c404           add sp, 4
  0653F4  2014: 0bc0             or ax, ax
  0653F6  2016: 7506             jne 0x201e
  0653F8  2018: 8346ea08         add word ptr [bp - 0x16], 8
  0653FC  201C: eb14             jmp 0x2032
  0653FE  201E: 6a04             push 4
  065400  2020: 6a00             push 0
  065402  2022: 9ad4041f18       lcall 0x181f, 0x4d4
  065407  2027: 83c404           add sp, 4
  06540A  202A: 0bc0             or ax, ax
  06540C  202C: 7404             je 0x2032
  06540E  202E: 8346ea10         add word ptr [bp - 0x16], 0x10
  065412  2032: ff36ae85         push word ptr [0x85ae]
  065416  2036: ff36ac85         push word ptr [0x85ac]
  06541A  203A: ff36aa85         push word ptr [0x85aa]
  06541E  203E: ff36a885         push word ptr [0x85a8]
  065422  2042: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065425  2045: 8b56dc           mov dx, word ptr [bp - 0x24]
  065428  2048: 8b5eea           mov bx, word ptr [bp - 0x16]
  06542B  204B: 9a72081f1a       lcall 0x1a1f, 0x872
  065430  2050: ff46e2           inc word ptr [bp - 0x1e]
  065433  2053: a13a85           mov ax, word ptr [0x853a]
  065436  2056: 3946e2           cmp word ptr [bp - 0x1e], ax
  065439  2059: 7d67             jge 0x20c2
  06543B  205B: ff36ae85         push word ptr [0x85ae]
  06543F  205F: ff36ac85         push word ptr [0x85ac]
  065443  2063: ff36aa85         push word ptr [0x85aa]
  065447  2067: ff36a885         push word ptr [0x85a8]
  06544B  206B: 8b46e2           mov ax, word ptr [bp - 0x1e]
  06544E  206E: 8b56dc           mov dx, word ptr [bp - 0x24]
  065451  2071: 9a68081f1a       lcall 0x1a1f, 0x868
  065456  2076: 2ae4             sub ah, ah
  065458  2078: 8946ea           mov word ptr [bp - 0x16], ax
  06545B  207B: 3d1900           cmp ax, 0x19
  06545E  207E: 74d0             je 0x2050
  065460  2080: ff36b685         push word ptr [0x85b6]
  065464  2084: ff36b485         push word ptr [0x85b4]
  065468  2088: ff36b285         push word ptr [0x85b2]
  06546C  208C: ff36b085         push word ptr [0x85b0]
  065470  2090: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065473  2093: 8b56dc           mov dx, word ptr [bp - 0x24]
  065476  2096: 9a68081f1a       lcall 0x1a1f, 0x868
  06547B  209B: fec8             dec al
  06547D  209D: 7403             je 0x20a2
  06547F  209F: e954ff           jmp 0x1ff6
  065482  20A2: 6a08             push 8
  065484  20A4: 6a00             push 0
  065486  20A6: 9ad4041f18       lcall 0x181f, 0x4d4
  06548B  20AB: 83c404           add sp, 4
  06548E  20AE: 0bc0             or ax, ax
  065490  20B0: 7403             je 0x20b5
  065492  20B2: e979ff           jmp 0x202e
  065495  20B5: 8b46ea           mov ax, word ptr [bp - 0x16]
  065498  20B8: 050800           add ax, 8
  06549B  20BB: 8946ea           mov word ptr [bp - 0x16], ax
  06549E  20BE: e971ff           jmp 0x2032
  0654A1  20C1: 90               nop 
  0654A2  20C2: ff46dc           inc word ptr [bp - 0x24]
  0654A5  20C5: a13c85           mov ax, word ptr [0x853c]
  0654A8  20C8: 3946dc           cmp word ptr [bp - 0x24], ax
  0654AB  20CB: 7d0d             jge 0x20da
  0654AD  20CD: 9aac031f18       lcall 0x181f, 0x3ac
  0654B2  20D2: c746e20000       mov word ptr [bp - 0x1e], 0
  0654B7  20D7: e979ff           jmp 0x2053
  0654BA  20DA: 0e               push cs
  0654BB  20DB: e85e08           call 0x293c
  0654BE  20DE: 837ef200         cmp word ptr [bp - 0xe], 0
  0654C2  20E2: 741a             je 0x20fe
  0654C4  20E4: ff36ae85         push word ptr [0x85ae]
  0654C8  20E8: ff36ac85         push word ptr [0x85ac]
  0654CC  20EC: ff36aa85         push word ptr [0x85aa]
  0654D0  20F0: ff36a885         push word ptr [0x85a8]
  0654D4  20F4: 6a04             push 4
  0654D6  20F6: 6a19             push 0x19
  0654D8  20F8: 2bc0             sub ax, ax
  0654DA  20FA: 99               cdq 
  0654DB  20FB: eb1e             jmp 0x211b
  0654DD  20FD: 90               nop 
  0654DE  20FE: ff36ae85         push word ptr [0x85ae]
  0654E2  2102: ff36ac85         push word ptr [0x85ac]
  0654E6  2106: ff36aa85         push word ptr [0x85aa]
  0654EA  210A: ff36a885         push word ptr [0x85a8]
  0654EE  210E: 6a04             push 4
  0654F0  2110: 6a19             push 0x19
  0654F2  2112: 8b163c85         mov dx, word ptr [0x853c]
  0654F6  2116: 83ea04           sub dx, 4
  0654F9  2119: 2bc0             sub ax, ax
  0654FB  211B: 8b1e3a85         mov bx, word ptr [0x853a]
  0654FF  211F: 9aba001f18       lcall 0x181f, 0xba
  065504  2124: ff36ae85         push word ptr [0x85ae]
  065508  2128: ff36ac85         push word ptr [0x85ac]
  06550C  212C: ff36aa85         push word ptr [0x85aa]
  065510  2130: ff36a885         push word ptr [0x85a8]
  065514  2134: a13c85           mov ax, word ptr [0x853c]
  065517  2137: 48               dec ax
  065518  2138: 50               push ax
  065519  2139: 6a19             push 0x19
  06551B  213B: 8b1e3a85         mov bx, word ptr [0x853a]
  06551F  213F: 83eb03           sub bx, 3
  065522  2142: b80200           mov ax, 2
  065525  2145: 99               cdq 
  065526  2146: 9ace001f18       lcall 0x181f, 0xce
  06552B  214B: c746de0000       mov word ptr [bp - 0x22], 0
  065530  2150: ff36ae85         push word ptr [0x85ae]
  065534  2154: ff36ac85         push word ptr [0x85ac]
  065538  2158: ff36aa85         push word ptr [0x85aa]
  06553C  215C: ff36a885         push word ptr [0x85a8]
  065540  2160: ff363a85         push word ptr [0x853a]
  065544  2164: 6a01             push 1
  065546  2166: 9ad4041f18       lcall 0x181f, 0x4d4
  06554B  216B: 83c404           add sp, 4
  06554E  216E: 48               dec ax
  06554F  216F: ba0100           mov dx, 1
  065552  2172: bb1800           mov bx, 0x18
  065555  2175: 9a72081f1a       lcall 0x1a1f, 0x872
  06555A  217A: ff36ae85         push word ptr [0x85ae]
  06555E  217E: ff36ac85         push word ptr [0x85ac]
  065562  2182: ff36aa85         push word ptr [0x85aa]
  065566  2186: ff36a885         push word ptr [0x85a8]
  06556A  218A: ff363a85         push word ptr [0x853a]
  06556E  218E: 6a01             push 1
  065570  2190: 9ad4041f18       lcall 0x181f, 0x4d4
  065575  2195: 83c404           add sp, 4
  065578  2198: 48               dec ax
  065579  2199: 8b163c85         mov dx, word ptr [0x853c]
  06557D  219D: 4a               dec dx
  06557E  219E: 4a               dec dx
  06557F  219F: bb1800           mov bx, 0x18
  065582  21A2: 9a72081f1a       lcall 0x1a1f, 0x872
  065587  21A7: ff46de           inc word ptr [bp - 0x22]
  06558A  21AA: 837ede28         cmp word ptr [bp - 0x22], 0x28
  06558E  21AE: 7ca0             jl 0x2150
  065590  21B0: c746dc0100       mov word ptr [bp - 0x24], 1
  065595  21B5: eb7b             jmp 0x2232
  065597  21B7: 90               nop 
  065598  21B8: c746fe0000       mov word ptr [bp - 2], 0
  06559D  21BD: ff4ee2           dec word ptr [bp - 0x1e]
  0655A0  21C0: 837efe00         cmp word ptr [bp - 2], 0
  0655A4  21C4: 7464             je 0x222a
  0655A6  21C6: a13a85           mov ax, word ptr [0x853a]
  0655A9  21C9: d1f8             sar ax, 1
  0655AB  21CB: 3b46e2           cmp ax, word ptr [bp - 0x1e]
  0655AE  21CE: 7f5a             jg 0x222a
  0655B0  21D0: ff76dc           push word ptr [bp - 0x24]
  0655B3  21D3: ff76e2           push word ptr [bp - 0x1e]
  0655B6  21D6: 9a68071f18       lcall 0x181f, 0x768
  0655BB  21DB: 83c404           add sp, 4
  0655BE  21DE: 0bc0             or ax, ax
  0655C0  21E0: 74d6             je 0x21b8
  0655C2  21E2: ff36ae85         push word ptr [0x85ae]
  0655C6  21E6: ff36ac85         push word ptr [0x85ac]
  0655CA  21EA: ff36aa85         push word ptr [0x85aa]
  0655CE  21EE: ff36a885         push word ptr [0x85a8]
  0655D2  21F2: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0655D5  21F5: 8b56dc           mov dx, word ptr [bp - 0x24]
  0655D8  21F8: 9a68081f1a       lcall 0x1a1f, 0x868
  0655DD  21FD: 2ae4             sub ah, ah
  0655DF  21FF: 8946ea           mov word ptr [bp - 0x16], ax
  0655E2  2202: ff36ae85         push word ptr [0x85ae]
  0655E6  2206: ff36ac85         push word ptr [0x85ac]
  0655EA  220A: ff36aa85         push word ptr [0x85aa]
  0655EE  220E: ff36a885         push word ptr [0x85a8]
  0655F2  2212: 8a5eea           mov bl, byte ptr [bp - 0x16]
  0655F5  2215: 81e3e000         and bx, 0xe0
  0655F9  2219: 83c31a           add bx, 0x1a
  0655FC  221C: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0655FF  221F: 8b56dc           mov dx, word ptr [bp - 0x24]
  065602  2222: 9a72081f1a       lcall 0x1a1f, 0x872
  065607  2227: eb94             jmp 0x21bd
  065609  2229: 90               nop 
  06560A  222A: 9aac031f18       lcall 0x181f, 0x3ac
  06560F  222F: ff46dc           inc word ptr [bp - 0x24]
  065612  2232: a13c85           mov ax, word ptr [0x853c]
  065615  2235: 48               dec ax
  065616  2236: 3b46dc           cmp ax, word ptr [bp - 0x24]
  065619  2239: 7e0f             jle 0x224a
  06561B  223B: c746fe0100       mov word ptr [bp - 2], 1
  065620  2240: a13a85           mov ax, word ptr [0x853a]
  065623  2243: 48               dec ax
  065624  2244: 8946e2           mov word ptr [bp - 0x1e], ax
  065627  2247: e976ff           jmp 0x21c0
  06562A  224A: c746dc0100       mov word ptr [bp - 0x24], 1
  06562F  224F: e9f200           jmp 0x2344
  065632  2252: 837ee201         cmp word ptr [bp - 0x1e], 1
  065636  2256: 7c21             jl 0x2279
  065638  2258: ff76dc           push word ptr [bp - 0x24]
  06563B  225B: ff76e2           push word ptr [bp - 0x1e]
  06563E  225E: 9a68071f18       lcall 0x181f, 0x768
  065643  2263: 83c404           add sp, 4
  065646  2266: 0bc0             or ax, ax
  065648  2268: 7506             jne 0x2270
  06564A  226A: 8b46e2           mov ax, word ptr [bp - 0x1e]
  06564D  226D: 8946fe           mov word ptr [bp - 2], ax
  065650  2270: ff4ee2           dec word ptr [bp - 0x1e]
  065653  2273: 837efe00         cmp word ptr [bp - 2], 0
  065657  2277: 7cd9             jl 0x2252
  065659  2279: 837efe00         cmp word ptr [bp - 2], 0
  06565D  227D: 7d03             jge 0x2282
  06565F  227F: e9ba00           jmp 0x233c
  065662  2282: 8b46fe           mov ax, word ptr [bp - 2]
  065665  2285: 050300           add ax, 3
  065668  2288: 8b0e3a85         mov cx, word ptr [0x853a]
  06566C  228C: 49               dec cx
  06566D  228D: 49               dec cx
  06566E  228E: 3bc1             cmp ax, cx
  065670  2290: 7e02             jle 0x2294
  065672  2292: 8bc1             mov ax, cx
  065674  2294: 8946e2           mov word ptr [bp - 0x1e], ax
  065677  2297: 8b46dc           mov ax, word ptr [bp - 0x24]
  06567A  229A: 2d0300           sub ax, 3
  06567D  229D: 8946f8           mov word ptr [bp - 8], ax
  065680  22A0: eb79             jmp 0x231b
  065682  22A2: a13a85           mov ax, word ptr [0x853a]
  065685  22A5: 48               dec ax
  065686  22A6: 48               dec ax
  065687  22A7: 3b46e2           cmp ax, word ptr [bp - 0x1e]
  06568A  22AA: 7e15             jle 0x22c1
  06568C  22AC: ff46e2           inc word ptr [bp - 0x1e]
  06568F  22AF: ff76f8           push word ptr [bp - 8]
  065692  22B2: ff76e2           push word ptr [bp - 0x1e]
  065695  22B5: 9a68071f18       lcall 0x181f, 0x768
  06569A  22BA: 83c404           add sp, 4
  06569D  22BD: 0bc0             or ax, ax
  06569F  22BF: 74e1             je 0x22a2
  0656A1  22C1: ff76f8           push word ptr [bp - 8]
  0656A4  22C4: ff76e2           push word ptr [bp - 0x1e]
  0656A7  22C7: 9a68071f18       lcall 0x181f, 0x768
  0656AC  22CC: 83c404           add sp, 4
  0656AF  22CF: 0bc0             or ax, ax
  0656B1  22D1: 7445             je 0x2318
  0656B3  22D3: ff36ae85         push word ptr [0x85ae]
  0656B7  22D7: ff36ac85         push word ptr [0x85ac]
  0656BB  22DB: ff36aa85         push word ptr [0x85aa]
  0656BF  22DF: ff36a885         push word ptr [0x85a8]
  0656C3  22E3: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0656C6  22E6: 8b56f8           mov dx, word ptr [bp - 8]
  0656C9  22E9: 9a68081f1a       lcall 0x1a1f, 0x868
  0656CE  22EE: 2ae4             sub ah, ah
  0656D0  22F0: 8946ea           mov word ptr [bp - 0x16], ax
  0656D3  22F3: ff36ae85         push word ptr [0x85ae]
  0656D7  22F7: ff36ac85         push word ptr [0x85ac]
  0656DB  22FB: ff36aa85         push word ptr [0x85aa]
  0656DF  22FF: ff36a885         push word ptr [0x85a8]
  0656E3  2303: 8a5eea           mov bl, byte ptr [bp - 0x16]
  0656E6  2306: 81e3e000         and bx, 0xe0
  0656EA  230A: 80cb19           or bl, 0x19
  0656ED  230D: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0656F0  2310: 8b56f8           mov dx, word ptr [bp - 8]
  0656F3  2313: 9a72081f1a       lcall 0x1a1f, 0x872
  0656F8  2318: ff46f8           inc word ptr [bp - 8]
  0656FB  231B: 8b46dc           mov ax, word ptr [bp - 0x24]
  0656FE  231E: 050300           add ax, 3
  065701  2321: 3b46f8           cmp ax, word ptr [bp - 8]
  065704  2324: 7c16             jl 0x233c
  065706  2326: ff76f8           push word ptr [bp - 8]
  065709  2329: ff76e2           push word ptr [bp - 0x1e]
  06570C  232C: 9a02031f18       lcall 0x181f, 0x302
  065711  2331: 83c404           add sp, 4
  065714  2334: 0bc0             or ax, ax
  065716  2336: 74e0             je 0x2318
  065718  2338: e974ff           jmp 0x22af
  06571B  233B: 90               nop 
  06571C  233C: 9aac031f18       lcall 0x181f, 0x3ac
  065721  2341: ff46dc           inc word ptr [bp - 0x24]
  065724  2344: a13c85           mov ax, word ptr [0x853c]
  065727  2347: 48               dec ax
  065728  2348: 3b46dc           cmp ax, word ptr [bp - 0x24]
  06572B  234B: 7e0f             jle 0x235c
  06572D  234D: c746feffff       mov word ptr [bp - 2], 0xffff
  065732  2352: a13a85           mov ax, word ptr [0x853a]
  065735  2355: 48               dec ax
  065736  2356: 8946e2           mov word ptr [bp - 0x1e], ax
  065739  2359: e917ff           jmp 0x2273
  06573C  235C: c746dc0100       mov word ptr [bp - 0x24], 1
  065741  2361: e99800           jmp 0x23fc
  065744  2364: 90               nop 
  065745  2365: 90               nop 
  065746  2366: ff76dc           push word ptr [bp - 0x24]
  065749  2369: ff76e2           push word ptr [bp - 0x1e]
  06574C  236C: 9a68071f18       lcall 0x181f, 0x768
  065751  2371: 83c404           add sp, 4
  065754  2374: 0bc0             or ax, ax
  065756  2376: 7445             je 0x23bd
  065758  2378: ff36ae85         push word ptr [0x85ae]
  06575C  237C: ff36ac85         push word ptr [0x85ac]
  065760  2380: ff36aa85         push word ptr [0x85aa]
  065764  2384: ff36a885         push word ptr [0x85a8]
  065768  2388: 8b46e2           mov ax, word ptr [bp - 0x1e]
  06576B  238B: 8b56dc           mov dx, word ptr [bp - 0x24]
  06576E  238E: 9a68081f1a       lcall 0x1a1f, 0x868
  065773  2393: 2ae4             sub ah, ah
  065775  2395: 8946ea           mov word ptr [bp - 0x16], ax
  065778  2398: ff36ae85         push word ptr [0x85ae]
  06577C  239C: ff36ac85         push word ptr [0x85ac]
  065780  23A0: ff36aa85         push word ptr [0x85aa]
  065784  23A4: ff36a885         push word ptr [0x85a8]
  065788  23A8: 8a5eea           mov bl, byte ptr [bp - 0x16]
  06578B  23AB: 81e3e000         and bx, 0xe0
  06578F  23AF: 80cb19           or bl, 0x19
  065792  23B2: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065795  23B5: 8b56dc           mov dx, word ptr [bp - 0x24]
  065798  23B8: 9a72081f1a       lcall 0x1a1f, 0x872
  06579D  23BD: ff4ee2           dec word ptr [bp - 0x1e]
  0657A0  23C0: 837ee201         cmp word ptr [bp - 0x1e], 1
  0657A4  23C4: 7c2e             jl 0x23f4
  0657A6  23C6: 837efe00         cmp word ptr [bp - 2], 0
  0657AA  23CA: 749a             je 0x2366
  0657AC  23CC: ff36ae85         push word ptr [0x85ae]
  0657B0  23D0: ff36ac85         push word ptr [0x85ac]
  0657B4  23D4: ff36aa85         push word ptr [0x85aa]
  0657B8  23D8: ff36a885         push word ptr [0x85a8]
  0657BC  23DC: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0657BF  23DF: 8b56dc           mov dx, word ptr [bp - 0x24]
  0657C2  23E2: 9a68081f1a       lcall 0x1a1f, 0x868
  0657C7  23E7: 241f             and al, 0x1f
  0657C9  23E9: 3c1a             cmp al, 0x1a
  0657CB  23EB: 74d0             je 0x23bd
  0657CD  23ED: c746fe0000       mov word ptr [bp - 2], 0
  0657D2  23F2: ebc9             jmp 0x23bd
  0657D4  23F4: 9aac031f18       lcall 0x181f, 0x3ac
  0657D9  23F9: ff46dc           inc word ptr [bp - 0x24]
  0657DC  23FC: a13c85           mov ax, word ptr [0x853c]
  0657DF  23FF: 48               dec ax
  0657E0  2400: 3b46dc           cmp ax, word ptr [bp - 0x24]
  0657E3  2403: 7e0f             jle 0x2414
  0657E5  2405: c746fe0100       mov word ptr [bp - 2], 1
  0657EA  240A: a13a85           mov ax, word ptr [0x853a]
  0657ED  240D: 48               dec ax
  0657EE  240E: 8946e2           mov word ptr [bp - 0x1e], ax
  0657F1  2411: ebad             jmp 0x23c0
  0657F3  2413: 90               nop 
  0657F4  2414: c746de0000       mov word ptr [bp - 0x22], 0
  0657F9  2419: e93301           jmp 0x254f
  0657FC  241C: a13c85           mov ax, word ptr [0x853c]
  0657FF  241F: 48               dec ax
  065800  2420: 48               dec ax
  065801  2421: 8946dc           mov word ptr [bp - 0x24], ax
  065804  2424: 50               push ax
  065805  2425: ff76e2           push word ptr [bp - 0x1e]
  065808  2428: 9a68071f18       lcall 0x181f, 0x768
  06580D  242D: 83c404           add sp, 4
  065810  2430: 0bc0             or ax, ax
  065812  2432: 751e             jne 0x2452
  065814  2434: ff36ae85         push word ptr [0x85ae]
  065818  2438: ff36ac85         push word ptr [0x85ac]
  06581C  243C: ff36aa85         push word ptr [0x85aa]
  065820  2440: ff36a885         push word ptr [0x85a8]
  065824  2444: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065827  2447: 8b56dc           mov dx, word ptr [bp - 0x24]
  06582A  244A: bb1800           mov bx, 0x18
  06582D  244D: 9a72081f1a       lcall 0x1a1f, 0x872
  065832  2452: 837ede00         cmp word ptr [bp - 0x22], 0
  065836  2456: 7406             je 0x245e
  065838  2458: b80200           mov ax, 2
  06583B  245B: eb07             jmp 0x2464
  06583D  245D: 90               nop 
  06583E  245E: a13c85           mov ax, word ptr [0x853c]
  065841  2461: 2d0300           sub ax, 3
  065844  2464: 8946dc           mov word ptr [bp - 0x24], ax
  065847  2467: 50               push ax
  065848  2468: ff76e2           push word ptr [bp - 0x1e]
  06584B  246B: 9a68071f18       lcall 0x181f, 0x768
  065850  2470: 83c404           add sp, 4
  065853  2473: 0bc0             or ax, ax
  065855  2475: 7550             jne 0x24c7
  065857  2477: ff76dc           push word ptr [bp - 0x24]
  06585A  247A: ff76e2           push word ptr [bp - 0x1e]
  06585D  247D: 9a8c071f18       lcall 0x181f, 0x78c
  065862  2482: 83c404           add sp, 4
  065865  2485: 8946ea           mov word ptr [bp - 0x16], ax
  065868  2488: 6a01             push 1
  06586A  248A: 6a00             push 0
  06586C  248C: 9ad4041f18       lcall 0x181f, 0x4d4
  065871  2491: 83c404           add sp, 4
  065874  2494: 3d0100           cmp ax, 1
  065877  2497: f5               cmc 
  065878  2498: 1bc0             sbb ax, ax
  06587A  249A: 251800           and ax, 0x18
  06587D  249D: 8a4eea           mov cl, byte ptr [bp - 0x16]
  065880  24A0: 81e1e000         and cx, 0xe0
  065884  24A4: 0bc1             or ax, cx
  065886  24A6: 8946ea           mov word ptr [bp - 0x16], ax
  065889  24A9: ff36ae85         push word ptr [0x85ae]
  06588D  24AD: ff36ac85         push word ptr [0x85ac]
  065891  24B1: ff36aa85         push word ptr [0x85aa]
  065895  24B5: ff36a885         push word ptr [0x85a8]
  065899  24B9: 8b46e2           mov ax, word ptr [bp - 0x1e]
  06589C  24BC: 8b56dc           mov dx, word ptr [bp - 0x24]
  06589F  24BF: 8b5eea           mov bx, word ptr [bp - 0x16]
  0658A2  24C2: 9a72081f1a       lcall 0x1a1f, 0x872
  0658A7  24C7: 837ede00         cmp word ptr [bp - 0x22], 0
  0658AB  24CB: 7405             je 0x24d2
  0658AD  24CD: b80300           mov ax, 3
  0658B0  24D0: eb06             jmp 0x24d8
  0658B2  24D2: a13c85           mov ax, word ptr [0x853c]
  0658B5  24D5: 2d0400           sub ax, 4
  0658B8  24D8: 8946dc           mov word ptr [bp - 0x24], ax
  0658BB  24DB: 6a01             push 1
  0658BD  24DD: 6a00             push 0
  0658BF  24DF: 9ad4041f18       lcall 0x181f, 0x4d4
  0658C4  24E4: 83c404           add sp, 4
  0658C7  24E7: 0bc0             or ax, ax
  0658C9  24E9: 7446             je 0x2531
  0658CB  24EB: ff76dc           push word ptr [bp - 0x24]
  0658CE  24EE: ff76e2           push word ptr [bp - 0x1e]
  0658D1  24F1: 9a68071f18       lcall 0x181f, 0x768
  0658D6  24F6: 83c404           add sp, 4
  0658D9  24F9: 0bc0             or ax, ax
  0658DB  24FB: 7534             jne 0x2531
  0658DD  24FD: ff76dc           push word ptr [bp - 0x24]
  0658E0  2500: ff76e2           push word ptr [bp - 0x1e]
  0658E3  2503: 9a8c071f18       lcall 0x181f, 0x78c
  0658E8  2508: 83c404           add sp, 4
  0658EB  250B: 8946ea           mov word ptr [bp - 0x16], ax
  0658EE  250E: ff36ae85         push word ptr [0x85ae]
  0658F2  2512: ff36ac85         push word ptr [0x85ac]
  0658F6  2516: ff36aa85         push word ptr [0x85aa]
  0658FA  251A: ff36a885         push word ptr [0x85a8]
  0658FE  251E: 8166eae000       and word ptr [bp - 0x16], 0xe0
  065903  2523: 8b5eea           mov bx, word ptr [bp - 0x16]
  065906  2526: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065909  2529: 8b56dc           mov dx, word ptr [bp - 0x24]
  06590C  252C: 9a72081f1a       lcall 0x1a1f, 0x872
  065911  2531: ff46e2           inc word ptr [bp - 0x1e]
  065914  2534: a13a85           mov ax, word ptr [0x853a]
  065917  2537: 3946e2           cmp word ptr [bp - 0x1e], ax
  06591A  253A: 7d10             jge 0x254c
  06591C  253C: 837ede00         cmp word ptr [bp - 0x22], 0
  065920  2540: 7503             jne 0x2545
  065922  2542: e9d7fe           jmp 0x241c
  065925  2545: b80100           mov ax, 1
  065928  2548: e9d6fe           jmp 0x2421
  06592B  254B: 90               nop 
  06592C  254C: ff46de           inc word ptr [bp - 0x22]
  06592F  254F: 837ede02         cmp word ptr [bp - 0x22], 2
  065933  2553: 7d07             jge 0x255c
  065935  2555: c746e20000       mov word ptr [bp - 0x1e], 0
  06593A  255A: ebd8             jmp 0x2534
  06593C  255C: 9aac031f18       lcall 0x181f, 0x3ac
  065941  2561: ff36ae85         push word ptr [0x85ae]
  065945  2565: ff36ac85         push word ptr [0x85ac]
  065949  2569: ff36aa85         push word ptr [0x85aa]
  06594D  256D: ff36a885         push word ptr [0x85a8]
  065951  2571: a13c85           mov ax, word ptr [0x853c]
  065954  2574: 48               dec ax
  065955  2575: 50               push ax
  065956  2576: 6a1a             push 0x1a
  065958  2578: 8b1e3a85         mov bx, word ptr [0x853a]
  06595C  257C: 4b               dec bx
  06595D  257D: 2bc0             sub ax, ax
  06595F  257F: 99               cdq 
  065960  2580: 9ace001f18       lcall 0x181f, 0xce
  065965  2585: ff36ae85         push word ptr [0x85ae]
  065969  2589: ff36ac85         push word ptr [0x85ac]
  06596D  258D: ff36aa85         push word ptr [0x85aa]
  065971  2591: ff36a885         push word ptr [0x85a8]
  065975  2595: a13c85           mov ax, word ptr [0x853c]
  065978  2598: 48               dec ax
  065979  2599: 50               push ax
  06597A  259A: 6a1a             push 0x1a
  06597C  259C: 8b1e3a85         mov bx, word ptr [0x853a]
  065980  25A0: 4b               dec bx
  065981  25A1: 4b               dec bx
  065982  25A2: b80100           mov ax, 1
  065985  25A5: 99               cdq 
  065986  25A6: 9ace001f18       lcall 0x181f, 0xce
  06598B  25AB: ff36ae85         push word ptr [0x85ae]
  06598F  25AF: ff36ac85         push word ptr [0x85ac]
  065993  25B3: ff36aa85         push word ptr [0x85aa]
  065997  25B7: ff36a885         push word ptr [0x85a8]
  06599B  25BB: 6a01             push 1
  06599D  25BD: 6a18             push 0x18
  06599F  25BF: 2bc0             sub ax, ax
  0659A1  25C1: 99               cdq 
  0659A2  25C2: 8b1e3a85         mov bx, word ptr [0x853a]
  0659A6  25C6: 9aba001f18       lcall 0x181f, 0xba
  0659AB  25CB: ff36ae85         push word ptr [0x85ae]
  0659AF  25CF: ff36ac85         push word ptr [0x85ac]
  0659B3  25D3: ff36aa85         push word ptr [0x85aa]
  0659B7  25D7: ff36a885         push word ptr [0x85a8]
  0659BB  25DB: 6a01             push 1
  0659BD  25DD: 6a18             push 0x18
  0659BF  25DF: 8b163c85         mov dx, word ptr [0x853c]
  0659C3  25E3: 4a               dec dx
  0659C4  25E4: 2bc0             sub ax, ax
  0659C6  25E6: 8b1e3a85         mov bx, word ptr [0x853a]
  0659CA  25EA: 9aba001f18       lcall 0x181f, 0xba
  0659CF  25EF: c746e20000       mov word ptr [bp - 0x1e], 0
  0659D4  25F4: e9b900           jmp 0x26b0
  0659D7  25F7: 90               nop 
  0659D8  25F8: 3d1000           cmp ax, 0x10
  0659DB  25FB: 7c05             jl 0x2602
  0659DD  25FD: 3d1800           cmp ax, 0x18
  0659E0  2600: 7c6c             jl 0x266e
  0659E2  2602: ff46dc           inc word ptr [bp - 0x24]
  0659E5  2605: a13c85           mov ax, word ptr [0x853c]
  0659E8  2608: 3946dc           cmp word ptr [bp - 0x24], ax
  0659EB  260B: 7c03             jl 0x2610
  0659ED  260D: e99800           jmp 0x26a8
  0659F0  2610: ff36ae85         push word ptr [0x85ae]
  0659F4  2614: ff36ac85         push word ptr [0x85ac]
  0659F8  2618: ff36aa85         push word ptr [0x85aa]
  0659FC  261C: ff36a885         push word ptr [0x85a8]
  065A00  2620: 8b56dc           mov dx, word ptr [bp - 0x24]
  065A03  2623: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065A06  2626: 9a68081f1a       lcall 0x1a1f, 0x868
  065A0B  262B: 2ae4             sub ah, ah
  065A0D  262D: 8946e4           mov word ptr [bp - 0x1c], ax
  065A10  2630: 241f             and al, 0x1f
  065A12  2632: 8946ea           mov word ptr [bp - 0x16], ax
  065A15  2635: 3d1800           cmp ax, 0x18
  065A18  2638: 7dc8             jge 0x2602
  065A1A  263A: f646e420         test byte ptr [bp - 0x1c], 0x20
  065A1E  263E: 74b8             je 0x25f8
  065A20  2640: ff36ae85         push word ptr [0x85ae]
  065A24  2644: ff36ac85         push word ptr [0x85ac]
  065A28  2648: ff36aa85         push word ptr [0x85aa]
  065A2C  264C: ff36a885         push word ptr [0x85a8]
  065A30  2650: 8166e4e000       and word ptr [bp - 0x1c], 0xe0
  065A35  2655: 8b5ee4           mov bx, word ptr [bp - 0x1c]
  065A38  2658: 8366ea07         and word ptr [bp - 0x16], 7
  065A3C  265C: 0b5eea           or bx, word ptr [bp - 0x16]
  065A3F  265F: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065A42  2662: 8b56dc           mov dx, word ptr [bp - 0x24]
  065A45  2665: 9a72081f1a       lcall 0x1a1f, 0x872
  065A4A  266A: eb96             jmp 0x2602
  065A4C  266C: 90               nop 
  065A4D  266D: 90               nop 
  065A4E  266E: ff36ae85         push word ptr [0x85ae]
  065A52  2672: ff36ac85         push word ptr [0x85ac]
  065A56  2676: ff36aa85         push word ptr [0x85aa]
  065A5A  267A: ff36a885         push word ptr [0x85a8]
  065A5E  267E: 8b46e2           mov ax, word ptr [bp - 0x1e]
  065A61  2681: 8b56dc           mov dx, word ptr [bp - 0x24]
  065A64  2684: 9a68081f1a       lcall 0x1a1f, 0x868
  065A69  2689: 2ae4             sub ah, ah
  065A6B  268B: 8946ea           mov word ptr [bp - 0x16], ax
  065A6E  268E: ff36ae85         push word ptr [0x85ae]
  065A72  2692: ff36ac85         push word ptr [0x85ac]
  065A76  2696: ff36aa85         push word ptr [0x85aa]
  065A7A  269A: ff36a885         push word ptr [0x85a8]
  065A7E  269E: 8346eaf8         add word ptr [bp - 0x16], -8
  065A82  26A2: 8b5eea           mov bx, word ptr [bp - 0x16]
  065A85  26A5: ebb8             jmp 0x265f
  065A87  26A7: 90               nop 
  065A88  26A8: 9aac031f18       lcall 0x181f, 0x3ac
  065A8D  26AD: ff46e2           inc word ptr [bp - 0x1e]
  065A90  26B0: a13a85           mov ax, word ptr [0x853a]
  065A93  26B3: 3946e2           cmp word ptr [bp - 0x1e], ax
  065A96  26B6: 7d08             jge 0x26c0
  065A98  26B8: c746dc0000       mov word ptr [bp - 0x24], 0
  065A9D  26BD: e945ff           jmp 0x2605
  065AA0  26C0: 9adc071f1a       lcall 0x1a1f, 0x7dc
  065AA5  26C5: ff36b685         push word ptr [0x85b6]
  065AA9  26C9: ff36b485         push word ptr [0x85b4]
  065AAD  26CD: ff36b285         push word ptr [0x85b2]
  065AB1  26D1: ff36b085         push word ptr [0x85b0]
  065AB5  26D5: 2ac0             sub al, al
  065AB7  26D7: 9a84041f18       lcall 0x181f, 0x484
  065ABC  26DC: ff36c685         push word ptr [0x85c6]
  065AC0  26E0: ff36c485         push word ptr [0x85c4]
  065AC4  26E4: ff36c285         push word ptr [0x85c2]
  065AC8  26E8: ff36c085         push word ptr [0x85c0]
  065ACC  26EC: 2ac0             sub al, al
  065ACE  26EE: 9a84041f18       lcall 0x181f, 0x484
  065AD3  26F3: c746dc0100       mov word ptr [bp - 0x24], 1
  065AD8  26F8: eb24             jmp 0x271e
  065ADA  26FA: a13a85           mov ax, word ptr [0x853a]
  065ADD  26FD: d1f8             sar ax, 1
  065ADF  26FF: 3b46e2           cmp ax, word ptr [bp - 0x1e]
  065AE2  2702: 7e12             jle 0x2716
  065AE4  2704: ff76dc           push word ptr [bp - 0x24]
  065AE7  2707: ff76e2           push word ptr [bp - 0x1e]
  065AEA  270A: 9a68071f18       lcall 0x181f, 0x768
  065AEF  270F: 83c404           add sp, 4
  065AF2  2712: 0bc0             or ax, ax
  065AF4  2714: 7518             jne 0x272e
  065AF6  2716: 9aac031f18       lcall 0x181f, 0x3ac
  065AFB  271B: ff46dc           inc word ptr [bp - 0x24]
  065AFE  271E: a13c85           mov ax, word ptr [0x853c]
  065B01  2721: 48               dec ax
  065B02  2722: 3b46dc           cmp ax, word ptr [bp - 0x24]
  065B05  2725: 7e2b             jle 0x2752
  065B07  2727: c746e20100       mov word ptr [bp - 0x1e], 1
  065B0C  272C: eb15             jmp 0x2743
  065B0E  272E: 6a01             push 1
  065B10  2730: 6a20             push 0x20
  065B12  2732: ff76dc           push word ptr [bp - 0x24]
  065B15  2735: ff76e2           push word ptr [bp - 0x1e]
  065B18  2738: 9a8c061f18       lcall 0x181f, 0x68c
  065B1D  273D: 83c408           add sp, 8
  065B20  2740: ff46e2           inc word ptr [bp - 0x1e]
  065B23  2743: 837e0600         cmp word ptr [bp + 6], 0
  065B27  2747: 74b1             je 0x26fa
  065B29  2749: a13a85           mov ax, word ptr [0x853a]
  065B2C  274C: 2d1000           sub ax, 0x10
  065B2F  274F: ebae             jmp 0x26ff
  065B31  2751: 90               nop 
  065B32  2752: c746dc0000       mov word ptr [bp - 0x24], 0
  065B37  2757: e9a600           jmp 0x2800
  065B3A  275A: 837ee814         cmp word ptr [bp - 0x18], 0x14
  065B3E  275E: 7d47             jge 0x27a7
  065B40  2760: 8b5ee8           mov bx, word ptr [bp - 0x18]
  065B43  2763: 8a87de00         mov al, byte ptr [bx + 0xde]
  065B47  2767: 98               cwde 
  065B48  2768: 0346dc           add ax, word ptr [bp - 0x24]
  065B4B  276B: 8946f8           mov word ptr [bp - 8], ax
  065B4E  276E: 50               push ax
  065B4F  276F: 8a87c800         mov al, byte ptr [bx + 0xc8]
  065B53  2773: 98               cwde 
  065B54  2774: 0346e2           add ax, word ptr [bp - 0x1e]
  065B57  2777: 8946fc           mov word ptr [bp - 4], ax
  065B5A  277A: 50               push ax
  065B5B  277B: 9a02031f18       lcall 0x181f, 0x302
  065B60  2780: 83c404           add sp, 4
  065B63  2783: 0bc0             or ax, ax
  065B65  2785: 7417             je 0x279e
  065B67  2787: ff76f8           push word ptr [bp - 8]
  065B6A  278A: ff76fc           push word ptr [bp - 4]
  065B6D  278D: 9a68071f18       lcall 0x181f, 0x768
  065B72  2792: 83c404           add sp, 4
  065B75  2795: 0bc0             or ax, ax
  065B77  2797: 7505             jne 0x279e
  065B79  2799: c746fe0100       mov word ptr [bp - 2], 1
  065B7E  279E: ff46e8           inc word ptr [bp - 0x18]
  065B81  27A1: 837efe00         cmp word ptr [bp - 2], 0
  065B85  27A5: 74b3             je 0x275a
  065B87  27A7: 837efe00         cmp word ptr [bp - 2], 0
  065B8B  27AB: 7512             jne 0x27bf
  065B8D  27AD: 6a01             push 1
  065B8F  27AF: 6a04             push 4
  065B91  27B1: ff76dc           push word ptr [bp - 0x24]
  065B94  27B4: ff76e2           push word ptr [bp - 0x1e]
  065B97  27B7: 9a8c061f18       lcall 0x181f, 0x68c
  065B9C  27BC: 83c408           add sp, 8
  065B9F  27BF: ff46e2           inc word ptr [bp - 0x1e]
  065BA2  27C2: a13a85           mov ax, word ptr [0x853a]
  065BA5  27C5: 3946e2           cmp word ptr [bp - 0x1e], ax
  065BA8  27C8: 7d2e             jge 0x27f8
  065BAA  27CA: ff76dc           push word ptr [bp - 0x24]
  065BAD  27CD: ff76e2           push word ptr [bp - 0x1e]
  065BB0  27D0: 9a68071f18       lcall 0x181f, 0x768
  065BB5  27D5: 83c404           add sp, 4
  065BB8  27D8: 0bc0             or ax, ax
  065BBA  27DA: 74e3             je 0x27bf
  065BBC  27DC: ff76dc           push word ptr [bp - 0x24]
  065BBF  27DF: ff76e2           push word ptr [bp - 0x1e]
  065BC2  27E2: 9a18071f18       lcall 0x181f, 0x718
  065BC7  27E7: 83c404           add sp, 4
  065BCA  27EA: 40               inc ax
  065BCB  27EB: 74d2             je 0x27bf
  065BCD  27ED: 2bc0             sub ax, ax
  065BCF  27EF: 8946fe           mov word ptr [bp - 2], ax
  065BD2  27F2: 8946e8           mov word ptr [bp - 0x18], ax
  065BD5  27F5: ebaa             jmp 0x27a1
  065BD7  27F7: 90               nop 
  065BD8  27F8: 9aac031f18       lcall 0x181f, 0x3ac
  065BDD  27FD: ff46dc           inc word ptr [bp - 0x24]
  065BE0  2800: a13c85           mov ax, word ptr [0x853c]
  065BE3  2803: 3946dc           cmp word ptr [bp - 0x24], ax
  065BE6  2806: 7d08             jge 0x2810
  065BE8  2808: c746e20000       mov word ptr [bp - 0x1e], 0
  065BED  280D: ebb3             jmp 0x27c2
  065BEF  280F: 90               nop 
  065BF0  2810: 837e0600         cmp word ptr [bp + 6], 0
  065BF4  2814: 742f             je 0x2845
  065BF6  2816: 833e742100       cmp word ptr [0x2174], 0
  065BFB  281B: 7528             jne 0x2845
  065BFD  281D: 6a01             push 1
  065BFF  281F: 6a15             push 0x15
  065C01  2821: 9a0e071f18       lcall 0x181f, 0x70e
  065C06  2826: 83c404           add sp, 4
  065C09  2829: 8ec2             mov es, dx
  065C0B  282B: 8bd8             mov bx, ax
  065C0D  282D: 26800fa0         or byte ptr es:[bx], 0xa0
  065C11  2831: 6a44             push 0x44
  065C13  2833: 6a2b             push 0x2b
  065C15  2835: 9a0e071f18       lcall 0x181f, 0x70e
  065C1A  283A: 83c404           add sp, 4
  065C1D  283D: 8ec2             mov es, dx
  065C1F  283F: 8bd8             mov bx, ax
  065C21  2841: 26800fa0         or byte ptr es:[bx], 0xa0
  065C25  2845: 6a04             push 4
  065C27  2847: 6aff             push -1
  065C29  2849: 8d46f4           lea ax, [bp - 0xc]
  065C2C  284C: 50               push ax
  065C2D  284D: 9aae0d1d0d       lcall 0xd1d, 0xdae
  065C32  2852: 83c406           add sp, 6
  065C35  2855: c746de0000       mov word ptr [bp - 0x22], 0
  065C3A  285A: eb33             jmp 0x288f
  065C3C  285C: 6a02             push 2
  065C3E  285E: 6a01             push 1
  065C40  2860: 9ad4041f18       lcall 0x181f, 0x4d4
  065C45  2865: 83c404           add sp, 4
  065C48  2868: 8946ec           mov word ptr [bp - 0x14], ax
  065C4B  286B: 8bf0             mov si, ax
  065C4D  286D: 807af400         cmp byte ptr [bp + si - 0xc], 0
  065C51  2871: 7d05             jge 0x2878
  065C53  2873: b80100           mov ax, 1
  065C56  2876: eb02             jmp 0x287a
  065C58  2878: 2bc0             sub ax, ax
  065C5A  287A: 8946fe           mov word ptr [bp - 2], ax
  065C5D  287D: 0bc0             or ax, ax
  065C5F  287F: 7429             je 0x28aa
  065C61  2881: 8a46d8           mov al, byte ptr [bp - 0x28]
  065C64  2884: 8842f4           mov byte ptr [bp + si - 0xc], al
  065C67  2887: 9aac031f18       lcall 0x181f, 0x3ac
  065C6C  288C: ff46de           inc word ptr [bp - 0x22]
  065C6F  288F: 837ede04         cmp word ptr [bp - 0x22], 4
  065C73  2893: 7d27             jge 0x28bc
  065C75  2895: 8b46de           mov ax, word ptr [bp - 0x22]
  065C78  2898: 03069853         add ax, word ptr [0x5398]
  065C7C  289C: b90400           mov cx, 4
  065C7F  289F: 99               cdq 
  065C80  28A0: f7f9             idiv cx
  065C82  28A2: 8956d8           mov word ptr [bp - 0x28], dx
  065C85  28A5: c746fe0000       mov word ptr [bp - 2], 0
  065C8A  28AA: 837ede00         cmp word ptr [bp - 0x22], 0
  065C8E  28AE: 7506             jne 0x28b6
  065C90  28B0: 837e0600         cmp word ptr [bp + 6], 0
  065C94  28B4: 74a6             je 0x285c
  065C96  28B6: 6a03             push 3
  065C98  28B8: 6a00             push 0
  065C9A  28BA: eba4             jmp 0x2860
  065C9C  28BC: c746de0000       mov word ptr [bp - 0x22], 0
  065CA1  28C1: eb36             jmp 0x28f9
  065CA3  28C3: 90               nop 
  065CA4  28C4: ff76dc           push word ptr [bp - 0x24]
  065CA7  28C7: ff76e2           push word ptr [bp - 0x1e]
  065CAA  28CA: 9a8c071f18       lcall 0x181f, 0x78c
  065CAF  28CF: 83c404           add sp, 4
  065CB2  28D2: 3d1a00           cmp ax, 0x1a
  065CB5  28D5: 7509             jne 0x28e0
  065CB7  28D7: ff4ee2           dec word ptr [bp - 0x1e]
  065CBA  28DA: 837ee202         cmp word ptr [bp - 0x1e], 2
  065CBE  28DE: 7fe4             jg 0x28c4
  065CC0  28E0: ff46e2           inc word ptr [bp - 0x1e]
  065CC3  28E3: 8a46e2           mov al, byte ptr [bp - 0x1e]
  065CC6  28E6: 695ed83c01       imul bx, word ptr [bp - 0x28], 0x13c
  065CCB  28EB: 88873a88         mov byte ptr [bx - 0x77c6], al
  065CCF  28EF: 8a46dc           mov al, byte ptr [bp - 0x24]
  065CD2  28F2: 88873b88         mov byte ptr [bx - 0x77c5], al
  065CD6  28F6: ff46de           inc word ptr [bp - 0x22]
  065CD9  28F9: 837ede04         cmp word ptr [bp - 0x22], 4
  065CDD  28FD: 7d25             jge 0x2924
  065CDF  28FF: 8b76de           mov si, word ptr [bp - 0x22]
  065CE2  2902: 8a42f4           mov al, byte ptr [bp + si - 0xc]
  065CE5  2905: 98               cwde 
  065CE6  2906: 8946d8           mov word ptr [bp - 0x28], ax
  065CE9  2909: a13c85           mov ax, word ptr [0x853c]
  065CEC  290C: b90500           mov cx, 5
  065CEF  290F: 99               cdq 
  065CF0  2910: f7f9             idiv cx
  065CF2  2912: 8d4c01           lea cx, [si + 1]
  065CF5  2915: f7e9             imul cx
  065CF7  2917: 8946dc           mov word ptr [bp - 0x24], ax
  065CFA  291A: a13a85           mov ax, word ptr [0x853a]
  065CFD  291D: 48               dec ax
  065CFE  291E: 48               dec ax
  065CFF  291F: 8946e2           mov word ptr [bp - 0x1e], ax
  065D02  2922: ebb6             jmp 0x28da
  065D04  2924: 5e               pop si
  065D05  2925: 5f               pop di
  065D06  2926: c9               leave 
  065D07  2927: cb               retf 
  065D08  2928: ea06081f1a       ljmp 0x1a1f:0x806
  065D0D  292D: ea14081f1a       ljmp 0x1a1f:0x814
  065D12  2932: ea22081f1a       ljmp 0x1a1f:0x822
  065D17  2937: ea30081f1a       ljmp 0x1a1f:0x830
  065D1C  293C: ea4c081f1a       ljmp 0x1a1f:0x84c
  065D21  2941: ea5a081f1a       ljmp 0x1a1f:0x85a

; ---- func_065D26  size=2387  insns=742  prologue=ENTER 0x00DA,0  terminal=RETF ----
  065D26  2946: c8da0000         enter 0xda, 0
  065D2A  294A: 56               push si
  065D2B  294B: ff36a683         push word ptr [0x83a6]
  065D2F  294F: 9aca041f18       lcall 0x181f, 0x4ca
  065D34  2954: 83c402           add sp, 2
  065D37  2957: 68881e           push 0x1e88
  065D3A  295A: 688f1e           push 0x1e8f
  065D3D  295D: 9a28091f19       lcall 0x191f, 0x928
  065D42  2962: 83c404           add sp, 4
  065D45  2965: c7863aff0e01     mov word ptr [bp - 0xc6], 0x10e
  065D4B  296B: 680e01           push 0x10e
  065D4E  296E: 6a00             push 0
  065D50  2970: 68aa9f           push 0x9faa
  065D53  2973: 9aae0d1d0d       lcall 0xd1d, 0xdae
  065D58  2978: 83c406           add sp, 6
  065D5B  297B: 2bc0             sub ax, ax
  065D5D  297D: 898656ff         mov word ptr [bp - 0xaa], ax
  065D61  2981: 89864cff         mov word ptr [bp - 0xb4], ax
  065D65  2985: eb0e             jmp 0x2995
  065D67  2987: 90               nop 
  065D68  2988: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  065D6C  298C: c6872a9600       mov byte ptr [bx - 0x69d6], 0
  065D71  2991: ff864cff         inc word ptr [bp - 0xb4]
  065D75  2995: 83be4cff08       cmp word ptr [bp - 0xb4], 8
  065D7A  299A: 7cec             jl 0x2988
  065D7C  299C: c7864cff0000     mov word ptr [bp - 0xb4], 0
  065D82  29A2: e99800           jmp 0x2a3d
  065D85  29A5: 90               nop 
  065D86  29A6: c78626ff0000     mov word ptr [bp - 0xda], 0
  065D8C  29AC: 6a0e             push 0xe
  065D8E  29AE: 6a00             push 0
  065D90  29B0: 9ad4041f18       lcall 0x181f, 0x4d4
  065D95  29B5: 83c404           add sp, 4
  065D98  29B8: 038626ff         add ax, word ptr [bp - 0xda]
  065D9C  29BC: 8bb636ff         mov si, word ptr [bp - 0xca]
  065DA0  29C0: d1e6             shl si, 1
  065DA2  29C2: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  065DA6  29C6: 894046           mov word ptr [bx + si + 0x46], ax
  065DA9  29C9: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  065DAD  29CD: 8bb636ff         mov si, word ptr [bp - 0xca]
  065DB1  29D1: c6403600         mov byte ptr [bx + si + 0x36], 0
  065DB5  29D5: ff8636ff         inc word ptr [bp - 0xca]
  065DB9  29D9: 83be36ff04       cmp word ptr [bp - 0xca], 4
  065DBE  29DE: 7d1c             jge 0x29fc
  065DC0  29E0: 7dc4             jge 0x29a6
  065DC2  29E2: 6b9e36ff34       imul bx, word ptr [bp - 0xca], 0x34
  065DC7  29E7: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  065DCC  29EC: 75b8             jne 0x29a6
  065DCE  29EE: a0a653           mov al, byte ptr [0x53a6]
  065DD1  29F1: 2ae4             sub ah, ah
  065DD3  29F3: d1e0             shl ax, 1
  065DD5  29F5: 898626ff         mov word ptr [bp - 0xda], ax
  065DD9  29F9: ebb1             jmp 0x29ac
  065DDB  29FB: 90               nop 
  065DDC  29FC: c78636ff0000     mov word ptr [bp - 0xca], 0
  065DE2  2A02: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  065DE6  2A06: 8bb636ff         mov si, word ptr [bp - 0xca]
  065DEA  2A0A: c6403a00         mov byte ptr [bx + si + 0x3a], 0
  065DEE  2A0E: ff8636ff         inc word ptr [bp - 0xca]
  065DF2  2A12: 83be36ff0c       cmp word ptr [bp - 0xca], 0xc
  065DF7  2A17: 7ce9             jl 0x2a02
  065DF9  2A19: c78636ff0000     mov word ptr [bp - 0xca], 0
  065DFF  2A1F: 8bb636ff         mov si, word ptr [bp - 0xca]
  065E03  2A23: d1e6             shl si, 1
  065E05  2A25: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  065E09  2A29: c7400e0000       mov word ptr [bx + si + 0xe], 0
  065E0E  2A2E: ff8636ff         inc word ptr [bp - 0xca]
  065E12  2A32: 83be36ff10       cmp word ptr [bp - 0xca], 0x10
  065E17  2A37: 7ce6             jl 0x2a1f
  065E19  2A39: ff864cff         inc word ptr [bp - 0xb4]
  065E1D  2A3D: 83be4cff08       cmp word ptr [bp - 0xb4], 8
  065E22  2A42: 7d58             jge 0x2a9c
  065E24  2A44: ffb64cff         push word ptr [bp - 0xb4]
  065E28  2A48: 9a420a1f18       lcall 0x181f, 0xa42
  065E2D  2A4D: 83c402           add sp, 2
  065E30  2A50: 9a1c091f19       lcall 0x191f, 0x91c
  065E35  2A55: 9a8a081f1a       lcall 0x1a1f, 0x88a
  065E3A  2A5A: 9a8a081f1a       lcall 0x1a1f, 0x88a
  065E3F  2A5F: 9a8a081f1a       lcall 0x1a1f, 0x88a
  065E44  2A64: 9a8a081f1a       lcall 0x1a1f, 0x88a
  065E49  2A69: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  065E4D  2A6D: 884702           mov byte ptr [bx + 2], al
  065E50  2A70: b001             mov al, 1
  065E52  2A72: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  065E56  2A76: 884701           mov byte ptr [bx + 1], al
  065E59  2A79: 8807             mov byte ptr [bx], al
  065E5B  2A7B: 2ac0             sub al, al
  065E5D  2A7D: 884704           mov byte ptr [bx + 4], al
  065E60  2A80: 884705           mov byte ptr [bx + 5], al
  065E63  2A83: 884706           mov byte ptr [bx + 6], al
  065E66  2A86: 884707           mov byte ptr [bx + 7], al
  065E69  2A89: 884708           mov byte ptr [bx + 8], al
  065E6C  2A8C: 2bc0             sub ax, ax
  065E6E  2A8E: 89470a           mov word ptr [bx + 0xa], ax
  065E71  2A91: 89470c           mov word ptr [bx + 0xc], ax
  065E74  2A94: 898636ff         mov word ptr [bp - 0xca], ax
  065E78  2A98: e93eff           jmp 0x29d9
  065E7B  2A9B: 90               nop 
  065E7C  2A9C: 9aac031f18       lcall 0x181f, 0x3ac
  065E81  2AA1: c7863cff0000     mov word ptr [bp - 0xc4], 0
  065E87  2AA7: 833e885300       cmp word ptr [0x5388], 0
  065E8C  2AAC: 744e             je 0x2afc
  065E8E  2AAE: c7863cff0100     mov word ptr [bp - 0xc4], 1
  065E94  2AB4: 68951e           push 0x1e95
  065E97  2AB7: 8d8658ff         lea ax, [bp - 0xa8]
  065E9B  2ABB: 50               push ax
  065E9C  2ABC: 9ae4071d0d       lcall 0xd1d, 0x7e4
  065EA1  2AC1: 83c404           add sp, 4
  065EA4  2AC4: 833e742100       cmp word ptr [0x2174], 0
  065EA9  2AC9: 7420             je 0x2aeb
  065EAB  2ACB: 686621           push 0x2166
  065EAE  2ACE: 8d8658ff         lea ax, [bp - 0xa8]
  065EB2  2AD2: 50               push ax
  065EB3  2AD3: 9ae4071d0d       lcall 0xd1d, 0x7e4
  065EB8  2AD8: 83c404           add sp, 4
  065EBB  2ADB: 689f1e           push 0x1e9f
  065EBE  2ADE: 8d8658ff         lea ax, [bp - 0xa8]
  065EC2  2AE2: 50               push ax
  065EC3  2AE3: 9aa4071d0d       lcall 0xd1d, 0x7a4
  065EC8  2AE8: 83c404           add sp, 4
  065ECB  2AEB: 8d9e58ff         lea bx, [bp - 0xa8]
  065ECF  2AEF: 9a900e1f18       lcall 0x181f, 0xe90
  065ED4  2AF4: 0bc0             or ax, ax
  065ED6  2AF6: 7504             jne 0x2afc
  065ED8  2AF8: 89863cff         mov word ptr [bp - 0xc4], ax
  065EDC  2AFC: c7864cff0000     mov word ptr [bp - 0xb4], 0
  065EE2  2B02: eb50             jmp 0x2b54
  065EE4  2B04: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  065EE8  2B08: 8bc3             mov ax, bx
  065EEA  2B0A: d1e3             shl bx, 1
  065EEC  2B0C: 03d8             add bx, ax
  065EEE  2B0E: d1e3             shl bx, 1
  065EF0  2B10: ffb7148d         push word ptr [bx - 0x72ec]
  065EF4  2B14: 9a22001f18       lcall 0x181f, 0x22
  065EF9  2B19: 83c402           add sp, 2
  065EFC  2B1C: 52               push dx
  065EFD  2B1D: 50               push ax
  065EFE  2B1E: 8d46aa           lea ax, [bp - 0x56]
  065F01  2B21: 16               push ss
  065F02  2B22: 50               push ax
  065F03  2B23: 9a7e111d0d       lcall 0xd1d, 0x117e
  065F08  2B28: 83c408           add sp, 8
  065F0B  2B2B: 8d46aa           lea ax, [bp - 0x56]
  065F0E  2B2E: 16               push ss
  065F0F  2B2F: 50               push ax
  065F10  2B30: 9a18111d0d       lcall 0xd1d, 0x1118
  065F15  2B35: 83c404           add sp, 4
  065F18  2B38: 8d46aa           lea ax, [bp - 0x56]
  065F1B  2B3B: 50               push ax
  065F1C  2B3C: 8d8658ff         lea ax, [bp - 0xa8]
  065F20  2B40: 50               push ax
  065F21  2B41: 9a28091f19       lcall 0x191f, 0x928
  065F26  2B46: 83c404           add sp, 4
  065F29  2B49: 0bc0             or ax, ax
  065F2B  2B4B: 7503             jne 0x2b50
  065F2D  2B4D: e99401           jmp 0x2ce4
  065F30  2B50: ff864cff         inc word ptr [bp - 0xb4]
  065F34  2B54: 83be4cff08       cmp word ptr [bp - 0xb4], 8
  065F39  2B59: 7c03             jl 0x2b5e
  065F3B  2B5B: e90c03           jmp 0x2e6a
  065F3E  2B5E: c78640ff0000     mov word ptr [bp - 0xc0], 0
  065F44  2B64: 9aac031f18       lcall 0x181f, 0x3ac
  065F49  2B69: 83be3cff00       cmp word ptr [bp - 0xc4], 0
  065F4E  2B6E: 7594             jne 0x2b04
  065F50  2B70: 2bc0             sub ax, ax
  065F52  2B72: 8946fa           mov word ptr [bp - 6], ax
  065F55  2B75: 898640ff         mov word ptr [bp - 0xc0], ax
  065F59  2B79: ff8640ff         inc word ptr [bp - 0xc0]
  065F5D  2B7D: a13a85           mov ax, word ptr [0x853a]
  065F60  2B80: 2d0800           sub ax, 8
  065F63  2B83: 50               push ax
  065F64  2B84: 6a08             push 8
  065F66  2B86: 9ad4041f18       lcall 0x181f, 0x4d4
  065F6B  2B8B: 83c404           add sp, 4
  065F6E  2B8E: 89863eff         mov word ptr [bp - 0xc2], ax
  065F72  2B92: a13c85           mov ax, word ptr [0x853c]
  065F75  2B95: 2d0c00           sub ax, 0xc
  065F78  2B98: 50               push ax
  065F79  2B99: 6a0c             push 0xc
  065F7B  2B9B: 9ad4041f18       lcall 0x181f, 0x4d4
  065F80  2BA0: 83c404           add sp, 4
  065F83  2BA3: 898638ff         mov word ptr [bp - 0xc8], ax
  065F87  2BA7: 50               push ax
  065F88  2BA8: ffb63eff         push word ptr [bp - 0xc2]
  065F8C  2BAC: 9a68071f18       lcall 0x181f, 0x768
  065F91  2BB1: 83c404           add sp, 4
  065F94  2BB4: 0bc0             or ax, ax
  065F96  2BB6: 7403             je 0x2bbb
  065F98  2BB8: e9a200           jmp 0x2c5d
  065F9B  2BBB: ffb638ff         push word ptr [bp - 0xc8]
  065F9F  2BBF: ffb63eff         push word ptr [bp - 0xc2]
  065FA3  2BC3: 9a2c071f18       lcall 0x181f, 0x72c
  065FA8  2BC8: 83c404           add sp, 4
  065FAB  2BCB: a820             test al, 0x20
  065FAD  2BCD: 7403             je 0x2bd2
  065FAF  2BCF: e98b00           jmp 0x2c5d
  065FB2  2BD2: 6aff             push -1
  065FB4  2BD4: 6aff             push -1
  065FB6  2BD6: ffb638ff         push word ptr [bp - 0xc8]
  065FBA  2BDA: ffb63eff         push word ptr [bp - 0xc2]
  065FBE  2BDE: 9a840d1f18       lcall 0x181f, 0xd84
  065FC3  2BE3: 83c408           add sp, 8
  065FC6  2BE6: 89862cff         mov word ptr [bp - 0xd4], ax
  065FCA  2BEA: a1b88d           mov ax, word ptr [0x8db8]
  065FCD  2BED: 898654ff         mov word ptr [bp - 0xac], ax
  065FD1  2BF1: 0bc0             or ax, ax
  065FD3  2BF3: 7468             je 0x2c5d
  065FD5  2BF5: 8b8640ff         mov ax, word ptr [bp - 0xc0]
  065FD9  2BF9: c1f802           sar ax, 2
  065FDC  2BFC: 2d5a00           sub ax, 0x5a
  065FDF  2BFF: f7d8             neg ax
  065FE1  2C01: 3b8654ff         cmp ax, word ptr [bp - 0xac]
  065FE5  2C05: 7f56             jg 0x2c5d
  065FE7  2C07: 83be54ff08       cmp word ptr [bp - 0xac], 8
  065FEC  2C0C: 7d11             jge 0x2c1f
  065FEE  2C0E: b80800           mov ax, 8
  065FF1  2C11: 2b8654ff         sub ax, word ptr [bp - 0xac]
  065FF5  2C15: 69c0e803         imul ax, ax, 0x3e8
  065FF9  2C19: 3b8640ff         cmp ax, word ptr [bp - 0xc0]
  065FFD  2C1D: 7f3e             jg 0x2c5d
  065FFF  2C1F: 83be4cff02       cmp word ptr [bp - 0xb4], 2
  066004  2C24: 7d0d             jge 0x2c33
  066006  2C26: 8b863eff         mov ax, word ptr [bp - 0xc2]
  06600A  2C2A: c1e003           shl ax, 3
  06600D  2C2D: 3b8640ff         cmp ax, word ptr [bp - 0xc0]
  066011  2C31: 7f2a             jg 0x2c5d
  066013  2C33: 8b8638ff         mov ax, word ptr [bp - 0xc8]
  066017  2C37: b90500           mov cx, 5
  06601A  2C3A: 99               cdq 
  06601B  2C3B: f7f9             idiv cx
  06601D  2C3D: 8bd8             mov bx, ax
  06601F  2C3F: 8b863eff         mov ax, word ptr [bp - 0xc2]
  066023  2C43: 99               cdq 
  066024  2C44: f7f9             idiv cx
  066026  2C46: 6bf012           imul si, ax, 0x12
  066029  2C49: 80b8aa9f00       cmp byte ptr [bx + si - 0x6056], 0
  06602E  2C4E: 7408             je 0x2c58
  066030  2C50: 81be40ff1027     cmp word ptr [bp - 0xc0], 0x2710
  066036  2C56: 7c05             jl 0x2c5d
  066038  2C58: c746fa0100       mov word ptr [bp - 6], 1
  06603D  2C5D: 837efa00         cmp word ptr [bp - 6], 0
  066041  2C61: 750b             jne 0x2c6e
  066043  2C63: 81be40ffe02e     cmp word ptr [bp - 0xc0], 0x2ee0
  066049  2C69: 7d03             jge 0x2c6e
  06604B  2C6B: e90bff           jmp 0x2b79
  06604E  2C6E: 837efa00         cmp word ptr [bp - 6], 0
  066052  2C72: 7503             jne 0x2c77
  066054  2C74: e9d9fe           jmp 0x2b50
  066057  2C77: 8a863eff         mov al, byte ptr [bp - 0xc2]
  06605B  2C7B: 6b9e4cff4e       imul bx, word ptr [bp - 0xb4], 0x4e
  066060  2C80: 8887d65a         mov byte ptr [bx + 0x5ad6], al
  066064  2C84: 8a8638ff         mov al, byte ptr [bp - 0xc8]
  066068  2C88: 8887d75a         mov byte ptr [bx + 0x5ad7], al
  06606C  2C8C: ffb638ff         push word ptr [bp - 0xc8]
  066070  2C90: ffb63eff         push word ptr [bp - 0xc2]
  066074  2C94: 8b864cff         mov ax, word ptr [bp - 0xb4]
  066078  2C98: 050400           add ax, 4
  06607B  2C9B: 50               push ax
  06607C  2C9C: 9a40041f1a       lcall 0x1a1f, 0x440
  066081  2CA1: 83c406           add sp, 6
  066084  2CA4: 898632ff         mov word ptr [bp - 0xce], ax
  066088  2CA8: 50               push ax
  066089  2CA9: 9a4c0a1f18       lcall 0x181f, 0xa4c
  06608E  2CAE: 83c402           add sp, 2
  066091  2CB1: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  066095  2CB5: 804f0304         or byte ptr [bx + 3], 4
  066099  2CB9: 8b9e4cff         mov bx, word ptr [bp - 0xb4]
  06609D  2CBD: fe872a96         inc byte ptr [bx - 0x69d6]
  0660A1  2CC1: 8b8638ff         mov ax, word ptr [bp - 0xc8]
  0660A5  2CC5: b90500           mov cx, 5
  0660A8  2CC8: 99               cdq 
  0660A9  2CC9: f7f9             idiv cx
  0660AB  2CCB: 8bd8             mov bx, ax
  0660AD  2CCD: 8b863eff         mov ax, word ptr [bp - 0xc2]
  0660B1  2CD1: 99               cdq 
  0660B2  2CD2: f7f9             idiv cx
  0660B4  2CD4: 6bf012           imul si, ax, 0x12
  0660B7  2CD7: c680aa9f01       mov byte ptr [bx + si - 0x6056], 1
  0660BC  2CDC: ff8656ff         inc word ptr [bp - 0xaa]
  0660C0  2CE0: e96dfe           jmp 0x2b50
  0660C3  2CE3: 90               nop 
  0660C4  2CE4: b80100           mov ax, 1
  0660C7  2CE7: 898630ff         mov word ptr [bp - 0xd0], ax
  0660CB  2CEB: 898652ff         mov word ptr [bp - 0xae], ax
  0660CF  2CEF: 9a1c091f19       lcall 0x191f, 0x91c
  0660D4  2CF4: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0660D9  2CF9: 89863eff         mov word ptr [bp - 0xc2], ax
  0660DD  2CFD: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0660E2  2D02: 898638ff         mov word ptr [bp - 0xc8], ax
  0660E6  2D06: 83be3eff00       cmp word ptr [bp - 0xc2], 0
  0660EB  2D0B: 7f03             jg 0x2d10
  0660ED  2D0D: e94601           jmp 0x2e56
  0660F0  2D10: c78640ff0000     mov word ptr [bp - 0xc0], 0
  0660F6  2D16: ff8640ff         inc word ptr [bp - 0xc0]
  0660FA  2D1A: 6a01             push 1
  0660FC  2D1C: 6aff             push -1
  0660FE  2D1E: 9ad4041f18       lcall 0x181f, 0x4d4
  066103  2D23: 83c404           add sp, 4
  066106  2D26: 6a01             push 1
  066108  2D28: 6aff             push -1
  06610A  2D2A: 8bf0             mov si, ax
  06610C  2D2C: 9ad4041f18       lcall 0x181f, 0x4d4
  066111  2D31: 83c404           add sp, 4
  066114  2D34: 03f0             add si, ax
  066116  2D36: 89b648ff         mov word ptr [bp - 0xb8], si
  06611A  2D3A: 8bc6             mov ax, si
  06611C  2D3C: 03863eff         add ax, word ptr [bp - 0xc2]
  066120  2D40: 8946fc           mov word ptr [bp - 4], ax
  066123  2D43: 6a01             push 1
  066125  2D45: 6aff             push -1
  066127  2D47: 9ad4041f18       lcall 0x181f, 0x4d4
  06612C  2D4C: 83c404           add sp, 4
  06612F  2D4F: 6a01             push 1
  066131  2D51: 6aff             push -1
  066133  2D53: 8bf0             mov si, ax
  066135  2D55: 9ad4041f18       lcall 0x181f, 0x4d4
  06613A  2D5A: 83c404           add sp, 4
  06613D  2D5D: 03f0             add si, ax
  06613F  2D5F: 89b644ff         mov word ptr [bp - 0xbc], si
  066143  2D63: 03b638ff         add si, word ptr [bp - 0xc8]
  066147  2D67: 8976a8           mov word ptr [bp - 0x58], si
  06614A  2D6A: c746fa0000       mov word ptr [bp - 6], 0
  06614F  2D6F: 56               push si
  066150  2D70: ff76fc           push word ptr [bp - 4]
  066153  2D73: 9a02031f18       lcall 0x181f, 0x302
  066158  2D78: 83c404           add sp, 4
  06615B  2D7B: 0bc0             or ax, ax
  06615D  2D7D: 7503             jne 0x2d82
  06615F  2D7F: e98900           jmp 0x2e0b
  066162  2D82: ff76a8           push word ptr [bp - 0x58]
  066165  2D85: ff76fc           push word ptr [bp - 4]
  066168  2D88: 9a54071f18       lcall 0x181f, 0x754
  06616D  2D8D: 83c404           add sp, 4
  066170  2D90: a803             test al, 3
  066172  2D92: 7577             jne 0x2e0b
  066174  2D94: ff76a8           push word ptr [bp - 0x58]
  066177  2D97: ff76fc           push word ptr [bp - 4]
  06617A  2D9A: 9a8c071f18       lcall 0x181f, 0x78c
  06617F  2D9F: 83c404           add sp, 4
  066182  2DA2: 898634ff         mov word ptr [bp - 0xcc], ax
  066186  2DA6: 3d1800           cmp ax, 0x18
  066189  2DA9: 7d60             jge 0x2e0b
  06618B  2DAB: 83a634ff07       and word ptr [bp - 0xcc], 7
  066190  2DB0: 83be34ff02       cmp word ptr [bp - 0xcc], 2
  066195  2DB5: 7c07             jl 0x2dbe
  066197  2DB7: 83be34ff06       cmp word ptr [bp - 0xcc], 6
  06619C  2DBC: 7e07             jle 0x2dc5
  06619E  2DBE: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  0661A3  2DC3: 7546             jne 0x2e0b
  0661A5  2DC5: 6aff             push -1
  0661A7  2DC7: 6aff             push -1
  0661A9  2DC9: ff76a8           push word ptr [bp - 0x58]
  0661AC  2DCC: ff76fc           push word ptr [bp - 4]
  0661AF  2DCF: 9a840d1f18       lcall 0x181f, 0xd84
  0661B4  2DD4: 83c408           add sp, 8
  0661B7  2DD7: 89864aff         mov word ptr [bp - 0xb6], ax
  0661BB  2DDB: 83be40ff21       cmp word ptr [bp - 0xc0], 0x21
  0661C0  2DE0: 7d08             jge 0x2dea
  0661C2  2DE2: c746fe0300       mov word ptr [bp - 2], 3
  0661C7  2DE7: eb14             jmp 0x2dfd
  0661C9  2DE9: 90               nop 
  0661CA  2DEA: 83be40ff42       cmp word ptr [bp - 0xc0], 0x42
  0661CF  2DEF: 7d07             jge 0x2df8
  0661D1  2DF1: c746fe0200       mov word ptr [bp - 2], 2
  0661D6  2DF6: eb05             jmp 0x2dfd
  0661D8  2DF8: c746fe0100       mov word ptr [bp - 2], 1
  0661DD  2DFD: 8b46fe           mov ax, word ptr [bp - 2]
  0661E0  2E00: 3906b88d         cmp word ptr [0x8db8], ax
  0661E4  2E04: 7e05             jle 0x2e0b
  0661E6  2E06: c746fa0100       mov word ptr [bp - 6], 1
  0661EB  2E0B: 837efa00         cmp word ptr [bp - 6], 0
  0661EF  2E0F: 750a             jne 0x2e1b
  0661F1  2E11: 83be40ff64       cmp word ptr [bp - 0xc0], 0x64
  0661F6  2E16: 7d03             jge 0x2e1b
  0661F8  2E18: e9fbfe           jmp 0x2d16
  0661FB  2E1B: 837efa00         cmp word ptr [bp - 6], 0
  0661FF  2E1F: 743b             je 0x2e5c
  066201  2E21: ff76a8           push word ptr [bp - 0x58]
  066204  2E24: ff76fc           push word ptr [bp - 4]
  066207  2E27: 8b864cff         mov ax, word ptr [bp - 0xb4]
  06620B  2E2B: 050400           add ax, 4
  06620E  2E2E: 50               push ax
  06620F  2E2F: 9a40041f1a       lcall 0x1a1f, 0x440
  066214  2E34: 83c406           add sp, 6
  066217  2E37: 898632ff         mov word ptr [bp - 0xce], ax
  06621B  2E3B: 83be30ff00       cmp word ptr [bp - 0xd0], 0
  066220  2E40: 740e             je 0x2e50
  066222  2E42: 6bd812           imul bx, ax, 0x12
  066225  2E45: 808fef5404       or byte ptr [bx + 0x54ef], 4
  06622A  2E4A: c78630ff0000     mov word ptr [bp - 0xd0], 0
  066230  2E50: ff8642ff         inc word ptr [bp - 0xbe]
  066234  2E54: eb06             jmp 0x2e5c
  066236  2E56: c78652ff0000     mov word ptr [bp - 0xae], 0
  06623C  2E5C: 83be52ff00       cmp word ptr [bp - 0xae], 0
  066241  2E61: 7403             je 0x2e66
  066243  2E63: e989fe           jmp 0x2cef
  066246  2E66: e9e7fc           jmp 0x2b50
  066249  2E69: 90               nop 
  06624A  2E6A: 83be3cff00       cmp word ptr [bp - 0xc4], 0
  06624F  2E6F: 7403             je 0x2e74
  066251  2E71: e95e02           jmp 0x30d2
  066254  2E74: c78640ff0000     mov word ptr [bp - 0xc0], 0
  06625A  2E7A: e94802           jmp 0x30c5
  06625D  2E7D: 90               nop 
  06625E  2E7E: 8b863aff         mov ax, word ptr [bp - 0xc6]
  066262  2E82: c1e003           shl ax, 3
  066265  2E85: 3b8640ff         cmp ax, word ptr [bp - 0xc0]
  066269  2E89: 7f03             jg 0x2e8e
  06626B  2E8B: e94402           jmp 0x30d2
  06626E  2E8E: 833e9a5354       cmp word ptr [0x539a], 0x54
  066273  2E93: 7c03             jl 0x2e98
  066275  2E95: e93a02           jmp 0x30d2
  066278  2E98: 6a07             push 7
  06627A  2E9A: 6a00             push 0
  06627C  2E9C: 9ad4041f18       lcall 0x181f, 0x4d4
  066281  2EA1: 83c404           add sp, 4
  066284  2EA4: 89864cff         mov word ptr [bp - 0xb4], ax
  066288  2EA8: 8bd8             mov bx, ax
  06628A  2EAA: 80bf2a9600       cmp byte ptr [bx - 0x69d6], 0
  06628F  2EAF: 74e7             je 0x2e98
  066291  2EB1: 6bd84e           imul bx, ax, 0x4e
  066294  2EB4: 8a87d65a         mov al, byte ptr [bx + 0x5ad6]
  066298  2EB8: b105             mov cl, 5
  06629A  2EBA: 2ae4             sub ah, ah
  06629C  2EBC: f6f1             div cl
  06629E  2EBE: 2ae4             sub ah, ah
  0662A0  2EC0: 89863eff         mov word ptr [bp - 0xc2], ax
  0662A4  2EC4: 8a87d75a         mov al, byte ptr [bx + 0x5ad7]
  0662A8  2EC8: f6f1             div cl
  0662AA  2ECA: 2ae4             sub ah, ah
  0662AC  2ECC: 898638ff         mov word ptr [bp - 0xc8], ax
  0662B0  2ED0: c746fa0000       mov word ptr [bp - 6], 0
  0662B5  2ED5: ff8640ff         inc word ptr [bp - 0xc0]
  0662B9  2ED9: 6a07             push 7
  0662BB  2EDB: 6a00             push 0
  0662BD  2EDD: 9ad4041f18       lcall 0x181f, 0x4d4
  0662C2  2EE2: 83c404           add sp, 4
  0662C5  2EE5: 8bd8             mov bx, ax
  0662C7  2EE7: 899e28ff         mov word ptr [bp - 0xd8], bx
  0662CB  2EEB: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0662CF  2EEF: 98               cwde 
  0662D0  2EF0: 01863eff         add word ptr [bp - 0xc2], ax
  0662D4  2EF4: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0662D8  2EF8: 98               cwde 
  0662D9  2EF9: 018638ff         add word ptr [bp - 0xc8], ax
  0662DD  2EFD: 83be3eff00       cmp word ptr [bp - 0xc2], 0
  0662E2  2F02: 7c30             jl 0x2f34
  0662E4  2F04: 83be3eff0f       cmp word ptr [bp - 0xc2], 0xf
  0662E9  2F09: 7d29             jge 0x2f34
  0662EB  2F0B: 83be38ff00       cmp word ptr [bp - 0xc8], 0
  0662F0  2F10: 7c22             jl 0x2f34
  0662F2  2F12: 83be38ff12       cmp word ptr [bp - 0xc8], 0x12
  0662F7  2F17: 7d1b             jge 0x2f34
  0662F9  2F19: 6bb63eff12       imul si, word ptr [bp - 0xc2], 0x12
  0662FE  2F1E: 8b9e38ff         mov bx, word ptr [bp - 0xc8]
  066302  2F22: 80b8aa9f00       cmp byte ptr [bx + si - 0x6056], 0
  066307  2F27: 7505             jne 0x2f2e
  066309  2F29: c746fa0100       mov word ptr [bp - 6], 1
  06630E  2F2E: 837efa00         cmp word ptr [bp - 6], 0
  066312  2F32: 74a5             je 0x2ed9
  066314  2F34: 837efa00         cmp word ptr [bp - 6], 0
  066318  2F38: 7503             jne 0x2f3d
  06631A  2F3A: e98801           jmp 0x30c5
  06631D  2F3D: c7862aff0000     mov word ptr [bp - 0xd6], 0
  066323  2F43: b80500           mov ax, 5
  066326  2F46: f7ae3eff         imul word ptr [bp - 0xc2]
  06632A  2F4A: 89863eff         mov word ptr [bp - 0xc2], ax
  06632E  2F4E: b80500           mov ax, 5
  066331  2F51: f7ae38ff         imul word ptr [bp - 0xc8]
  066335  2F55: 898638ff         mov word ptr [bp - 0xc8], ax
  066339  2F59: 40               inc ax
  06633A  2F5A: 8946a8           mov word ptr [bp - 0x58], ax
  06633D  2F5D: e9d700           jmp 0x3037
  066340  2F60: 83be50ff09       cmp word ptr [bp - 0xb0], 9
  066345  2F65: 7d3b             jge 0x2fa2
  066347  2F67: 8b9e50ff         mov bx, word ptr [bp - 0xb0]
  06634B  2F6B: 8a87be00         mov al, byte ptr [bx + 0xbe]
  06634F  2F6F: 98               cwde 
  066350  2F70: 0346a8           add ax, word ptr [bp - 0x58]
  066353  2F73: 898646ff         mov word ptr [bp - 0xba], ax
  066357  2F77: 50               push ax
  066358  2F78: 8a87b400         mov al, byte ptr [bx + 0xb4]
  06635C  2F7C: 98               cwde 
  06635D  2F7D: 0346fc           add ax, word ptr [bp - 4]
  066360  2F80: 89864eff         mov word ptr [bp - 0xb2], ax
  066364  2F84: 50               push ax
  066365  2F85: 9a54071f18       lcall 0x181f, 0x754
  06636A  2F8A: 83c404           add sp, 4
  06636D  2F8D: a803             test al, 3
  06636F  2F8F: 7406             je 0x2f97
  066371  2F91: c7864aff0100     mov word ptr [bp - 0xb6], 1
  066377  2F97: ff8650ff         inc word ptr [bp - 0xb0]
  06637B  2F9B: 83be4aff00       cmp word ptr [bp - 0xb6], 0
  066380  2FA0: 74be             je 0x2f60
  066382  2FA2: 83be4aff00       cmp word ptr [bp - 0xb6], 0
  066387  2FA7: 7471             je 0x301a
  066389  2FA9: ff46fc           inc word ptr [bp - 4]
  06638C  2FAC: 8b863eff         mov ax, word ptr [bp - 0xc2]
  066390  2FB0: 050400           add ax, 4
  066393  2FB3: 3b46fc           cmp ax, word ptr [bp - 4]
  066396  2FB6: 7e7c             jle 0x3034
  066398  2FB8: ff76a8           push word ptr [bp - 0x58]
  06639B  2FBB: ff76fc           push word ptr [bp - 4]
  06639E  2FBE: 9a02031f18       lcall 0x181f, 0x302
  0663A3  2FC3: 83c404           add sp, 4
  0663A6  2FC6: 0bc0             or ax, ax
  0663A8  2FC8: 74df             je 0x2fa9
  0663AA  2FCA: ff76a8           push word ptr [bp - 0x58]
  0663AD  2FCD: ff76fc           push word ptr [bp - 4]
  0663B0  2FD0: 9a54071f18       lcall 0x181f, 0x754
  0663B5  2FD5: 83c404           add sp, 4
  0663B8  2FD8: a803             test al, 3
  0663BA  2FDA: 75cd             jne 0x2fa9
  0663BC  2FDC: ff76a8           push word ptr [bp - 0x58]
  0663BF  2FDF: ff76fc           push word ptr [bp - 4]
  0663C2  2FE2: 9a8c071f18       lcall 0x181f, 0x78c
  0663C7  2FE7: 83c404           add sp, 4
  0663CA  2FEA: 898634ff         mov word ptr [bp - 0xcc], ax
  0663CE  2FEE: 3d1800           cmp ax, 0x18
  0663D1  2FF1: 7db6             jge 0x2fa9
  0663D3  2FF3: 83a634ff07       and word ptr [bp - 0xcc], 7
  0663D8  2FF8: 83be34ff02       cmp word ptr [bp - 0xcc], 2
  0663DD  2FFD: 7c07             jl 0x3006
  0663DF  2FFF: 83be34ff06       cmp word ptr [bp - 0xcc], 6
  0663E4  3004: 7e07             jle 0x300d
  0663E6  3006: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  0663EB  300B: 759c             jne 0x2fa9
  0663ED  300D: 2bc0             sub ax, ax
  0663EF  300F: 89864aff         mov word ptr [bp - 0xb6], ax
  0663F3  3013: 898650ff         mov word ptr [bp - 0xb0], ax
  0663F7  3017: eb82             jmp 0x2f9b
  0663F9  3019: 90               nop 
  0663FA  301A: 8a46fc           mov al, byte ptr [bp - 4]
  0663FD  301D: 8b9e2aff         mov bx, word ptr [bp - 0xd6]
  066401  3021: 888772a3         mov byte ptr [bx - 0x5c8e], al
  066405  3025: 8a46a8           mov al, byte ptr [bp - 0x58]
  066408  3028: 888772a4         mov byte ptr [bx - 0x5b8e], al
  06640C  302C: ff862aff         inc word ptr [bp - 0xd6]
  066410  3030: e976ff           jmp 0x2fa9
  066413  3033: 90               nop 
  066414  3034: ff46a8           inc word ptr [bp - 0x58]
  066417  3037: 8b8638ff         mov ax, word ptr [bp - 0xc8]
  06641B  303B: 050400           add ax, 4
  06641E  303E: 3b46a8           cmp ax, word ptr [bp - 0x58]
  066421  3041: 7e0b             jle 0x304e
  066423  3043: 8b863eff         mov ax, word ptr [bp - 0xc2]
  066427  3047: 40               inc ax
  066428  3048: 8946fc           mov word ptr [bp - 4], ax
  06642B  304B: e95eff           jmp 0x2fac
  06642E  304E: 83be2aff00       cmp word ptr [bp - 0xd6], 0
  066433  3053: 744c             je 0x30a1
  066435  3055: 8b862aff         mov ax, word ptr [bp - 0xd6]
  066439  3059: 48               dec ax
  06643A  305A: 50               push ax
  06643B  305B: 6a00             push 0
  06643D  305D: 9ad4041f18       lcall 0x181f, 0x4d4
  066442  3062: 83c404           add sp, 4
  066445  3065: 8bd8             mov bx, ax
  066447  3067: 899e32ff         mov word ptr [bp - 0xce], bx
  06644B  306B: 8a8772a3         mov al, byte ptr [bx - 0x5c8e]
  06644F  306F: 2ae4             sub ah, ah
  066451  3071: 8946fc           mov word ptr [bp - 4], ax
  066454  3074: 8a8f72a4         mov cl, byte ptr [bx - 0x5b8e]
  066458  3078: 2aed             sub ch, ch
  06645A  307A: 894ea8           mov word ptr [bp - 0x58], cx
  06645D  307D: 6aff             push -1
  06645F  307F: 6aff             push -1
  066461  3081: 51               push cx
  066462  3082: 50               push ax
  066463  3083: 9a840d1f18       lcall 0x181f, 0xd84
  066468  3088: 83c408           add sp, 8
  06646B  308B: ff76a8           push word ptr [bp - 0x58]
  06646E  308E: ff76fc           push word ptr [bp - 4]
  066471  3091: ff36508d         push word ptr [0x8d50]
  066475  3095: 9a40041f1a       lcall 0x1a1f, 0x440
  06647A  309A: 83c406           add sp, 6
  06647D  309D: 898632ff         mov word ptr [bp - 0xce], ax
  066481  30A1: 8b8638ff         mov ax, word ptr [bp - 0xc8]
  066485  30A5: b90500           mov cx, 5
  066488  30A8: 99               cdq 
  066489  30A9: f7f9             idiv cx
  06648B  30AB: 8bd8             mov bx, ax
  06648D  30AD: 8b863eff         mov ax, word ptr [bp - 0xc2]
  066491  30B1: 99               cdq 
  066492  30B2: f7f9             idiv cx
  066494  30B4: 6bf012           imul si, ax, 0x12
  066497  30B7: c680aa9f01       mov byte ptr [bx + si - 0x6056], 1
  06649C  30BC: ff8656ff         inc word ptr [bp - 0xaa]
  0664A0  30C0: 9aac031f18       lcall 0x181f, 0x3ac
  0664A5  30C5: 8b8656ff         mov ax, word ptr [bp - 0xaa]
  0664A9  30C9: 39863aff         cmp word ptr [bp - 0xc6], ax
  0664AD  30CD: 7e03             jle 0x30d2
  0664AF  30CF: e9acfd           jmp 0x2e7e
  0664B2  30D2: c78636ff0000     mov word ptr [bp - 0xca], 0
  0664B8  30D8: e91001           jmp 0x31eb
  0664BB  30DB: 90               nop 
  0664BC  30DC: c78640ff0000     mov word ptr [bp - 0xc0], 0
  0664C2  30E2: 6bd812           imul bx, ax, 0x12
  0664C5  30E5: 8a87ed54         mov al, byte ptr [bx + 0x54ed]
  0664C9  30E9: 2ae4             sub ah, ah
  0664CB  30EB: 50               push ax
  0664CC  30EC: 8a87ec54         mov al, byte ptr [bx + 0x54ec]
  0664D0  30F0: 50               push ax
  0664D1  30F1: 9ab4061f18       lcall 0x181f, 0x6b4
  0664D6  30F6: 83c404           add sp, 4
  0664D9  30F9: 2ae4             sub ah, ah
  0664DB  30FB: 89862eff         mov word ptr [bp - 0xd2], ax
  0664DF  30FF: 6a02             push 2
  0664E1  3101: 6afe             push -2
  0664E3  3103: 9ad4041f18       lcall 0x181f, 0x4d4
  0664E8  3108: 83c404           add sp, 4
  0664EB  310B: 6b9e36ff12       imul bx, word ptr [bp - 0xca], 0x12
  0664F0  3110: 8a8fec54         mov cl, byte ptr [bx + 0x54ec]
  0664F4  3114: 2aed             sub ch, ch
  0664F6  3116: 03c8             add cx, ax
  0664F8  3118: 898e3eff         mov word ptr [bp - 0xc2], cx
  0664FC  311C: 6a02             push 2
  0664FE  311E: 6afe             push -2
  066500  3120: 8bf3             mov si, bx
  066502  3122: 9ad4041f18       lcall 0x181f, 0x4d4
  066507  3127: 83c404           add sp, 4
  06650A  312A: 8a8ced54         mov cl, byte ptr [si + 0x54ed]
  06650E  312E: 2aed             sub ch, ch
  066510  3130: 03c1             add ax, cx
  066512  3132: 898638ff         mov word ptr [bp - 0xc8], ax
  066516  3136: 50               push ax
  066517  3137: ffb63eff         push word ptr [bp - 0xc2]
  06651B  313B: 9a02031f18       lcall 0x181f, 0x302
  066520  3140: 83c404           add sp, 4
  066523  3143: 8946fa           mov word ptr [bp - 6], ax
  066526  3146: 0bc0             or ax, ax
  066528  3148: 744d             je 0x3197
  06652A  314A: ffb638ff         push word ptr [bp - 0xc8]
  06652E  314E: ffb63eff         push word ptr [bp - 0xc2]
  066532  3152: 9ab4061f18       lcall 0x181f, 0x6b4
  066537  3157: 83c404           add sp, 4
  06653A  315A: 3a862eff         cmp al, byte ptr [bp - 0xd2]
  06653E  315E: 7405             je 0x3165
  066540  3160: c746fa0000       mov word ptr [bp - 6], 0
  066545  3165: ffb638ff         push word ptr [bp - 0xc8]
  066549  3169: ffb63eff         push word ptr [bp - 0xc2]
  06654D  316D: 9a68071f18       lcall 0x181f, 0x768
  066552  3172: 83c404           add sp, 4
  066555  3175: 0bc0             or ax, ax
  066557  3177: 7405             je 0x317e
  066559  3179: c746fa0000       mov word ptr [bp - 6], 0
  06655E  317E: ffb638ff         push word ptr [bp - 0xc8]
  066562  3182: ffb63eff         push word ptr [bp - 0xc2]
  066566  3186: 9a54071f18       lcall 0x181f, 0x754
  06656B  318B: 83c404           add sp, 4
  06656E  318E: a803             test al, 3
  066570  3190: 7405             je 0x3197
  066572  3192: c746fa0000       mov word ptr [bp - 6], 0
  066577  3197: ff8640ff         inc word ptr [bp - 0xc0]
  06657B  319B: 837efa00         cmp word ptr [bp - 6], 0
  06657F  319F: 750a             jne 0x31ab
  066581  31A1: 83be40ff64       cmp word ptr [bp - 0xc0], 0x64
  066586  31A6: 7d03             jge 0x31ab
  066588  31A8: e954ff           jmp 0x30ff
  06658B  31AB: 837efa00         cmp word ptr [bp - 6], 0
  06658F  31AF: 7431             je 0x31e2
  066591  31B1: ffb638ff         push word ptr [bp - 0xc8]
  066595  31B5: ffb63eff         push word ptr [bp - 0xc2]
  066599  31B9: 6b9e36ff12       imul bx, word ptr [bp - 0xca], 0x12
  06659E  31BE: 8a87ee54         mov al, byte ptr [bx + 0x54ee]
  0665A2  31C2: 2ae4             sub ah, ah
  0665A4  31C4: 50               push ax
  0665A5  31C5: 6a13             push 0x13
  0665A7  31C7: 9a5c091f18       lcall 0x181f, 0x95c
  0665AC  31CC: 83c408           add sp, 8
  0665AF  31CF: 898632ff         mov word ptr [bp - 0xce], ax
  0665B3  31D3: 0bc0             or ax, ax
  0665B5  31D5: 7c0b             jl 0x31e2
  0665B7  31D7: 6bd81c           imul bx, ax, 0x1c
  0665BA  31DA: 8a8636ff         mov al, byte ptr [bp - 0xca]
  0665BE  31DE: 88874a31         mov byte ptr [bx + 0x314a], al
  0665C2  31E2: 9aac031f18       lcall 0x181f, 0x3ac
  0665C7  31E7: ff8636ff         inc word ptr [bp - 0xca]
  0665CB  31EB: 8b8636ff         mov ax, word ptr [bp - 0xca]
  0665CF  31EF: 39069a53         cmp word ptr [0x539a], ax
  0665D3  31F3: 7e03             jle 0x31f8
  0665D5  31F5: e9e4fe           jmp 0x30dc
  0665D8  31F8: c78636ff0000     mov word ptr [bp - 0xca], 0
  0665DE  31FE: eb72             jmp 0x3272
  0665E0  3200: ff863eff         inc word ptr [bp - 0xc2]
  0665E4  3204: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0665E8  3208: 8a07             mov al, byte ptr [bx]
  0665EA  320A: 2ae4             sub ah, ah
  0665EC  320C: 40               inc ax
  0665ED  320D: 40               inc ax
  0665EE  320E: 3b863eff         cmp ax, word ptr [bp - 0xc2]
  0665F2  3212: 7c3c             jl 0x3250
  0665F4  3214: ffb638ff         push word ptr [bp - 0xc8]
  0665F8  3218: ffb63eff         push word ptr [bp - 0xc2]
  0665FC  321C: 9a02031f18       lcall 0x181f, 0x302
  066601  3221: 83c404           add sp, 4
  066604  3224: 0bc0             or ax, ax
  066606  3226: 74d8             je 0x3200
  066608  3228: ffb638ff         push word ptr [bp - 0xc8]
  06660C  322C: ffb63eff         push word ptr [bp - 0xc2]
  066610  3230: 9a8c071f18       lcall 0x181f, 0x78c
  066615  3235: 83c404           add sp, 4
  066618  3238: 898634ff         mov word ptr [bp - 0xcc], ax
  06661C  323C: 3d1b00           cmp ax, 0x1b
  06661F  323F: 75bf             jne 0x3200
  066621  3241: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  066625  3245: 8a4702           mov al, byte ptr [bx + 2]
  066628  3248: 2ae4             sub ah, ah
  06662A  324A: 01470c           add word ptr [bx + 0xc], ax
  06662D  324D: ebb1             jmp 0x3200
  06662F  324F: 90               nop 
  066630  3250: ff8638ff         inc word ptr [bp - 0xc8]
  066634  3254: 8a4701           mov al, byte ptr [bx + 1]
  066637  3257: 2ae4             sub ah, ah
  066639  3259: 40               inc ax
  06663A  325A: 40               inc ax
  06663B  325B: 3b8638ff         cmp ax, word ptr [bp - 0xc8]
  06663F  325F: 7c0d             jl 0x326e
  066641  3261: 8a07             mov al, byte ptr [bx]
  066643  3263: 2ae4             sub ah, ah
  066645  3265: 48               dec ax
  066646  3266: 48               dec ax
  066647  3267: 89863eff         mov word ptr [bp - 0xc2], ax
  06664B  326B: eb97             jmp 0x3204
  06664D  326D: 90               nop 
  06664E  326E: ff8636ff         inc word ptr [bp - 0xca]
  066652  3272: 8b8636ff         mov ax, word ptr [bp - 0xca]
  066656  3276: 39069a53         cmp word ptr [0x539a], ax
  06665A  327A: 7e1a             jle 0x3296
  06665C  327C: 50               push ax
  06665D  327D: 9a4c0a1f18       lcall 0x181f, 0xa4c
  066662  3282: 83c402           add sp, 2
  066665  3285: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  066669  3289: 8a4701           mov al, byte ptr [bx + 1]
  06666C  328C: 2ae4             sub ah, ah
  06666E  328E: 48               dec ax
  06666F  328F: 48               dec ax
  066670  3290: 898638ff         mov word ptr [bp - 0xc8], ax
  066674  3294: ebbe             jmp 0x3254
  066676  3296: 5e               pop si
  066677  3297: c9               leave 
  066678  3298: cb               retf 
