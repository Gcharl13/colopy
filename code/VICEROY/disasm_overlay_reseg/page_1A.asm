; ============================================================
; VICEROY.EXE overlay page 0x1A (record 25) -- RE-SEGMENTED
; file_offset (disk image) = 0x071490
; code_offset (first insn) = 0x072090
; code_end (next reloc hdr)= 0x0763D0  [resident size 1076 para -> nominal_end 0x0757D0; on-disk code spills past it]
; reloc_count = 757  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x071490)
; functions in page = 21
; ============================================================

; ---- func_072090  size=2826  insns=945  prologue=ENTER 0x0004,0  terminal=RETF ----
  072090  0C00: c8040000         enter 4, 0
  072094  0C04: 57               push di
  072095  0C05: 56               push si
  072096  0C06: be0100           mov si, 1
  072099  0C09: ff36a008         push word ptr [0x8a0]
  07209D  0C0D: ff369e08         push word ptr [0x89e]
  0720A1  0C11: 68a00f           push 0xfa0
  0720A4  0C14: 9ad2021f1a       lcall 0x1a1f, 0x2d2
  0720A9  0C19: 83c406           add sp, 6
  0720AC  0C1C: a39608           mov word ptr [0x896], ax
  0720AF  0C1F: 89169808         mov word ptr [0x898], dx
  0720B3  0C23: 8bc2             mov ax, dx
  0720B5  0C25: 0b069608         or ax, word ptr [0x896]
  0720B9  0C29: 7503             jne 0xc2e
  0720BB  0C2B: e9d10a           jmp 0x16ff
  0720BE  0C2E: 689820           push 0x2098
  0720C1  0C31: 689d20           push 0x209d
  0720C4  0C34: 9a28091f19       lcall 0x191f, 0x928
  0720C9  0C39: 83c404           add sp, 4
  0720CC  0C3C: 0bc0             or ax, ax
  0720CE  0C3E: 7403             je 0xc43
  0720D0  0C40: e9bc0a           jmp 0x16ff
  0720D3  0C43: 50               push ax
  0720D4  0C44: 56               push si
  0720D5  0C45: 9a1c091f19       lcall 0x191f, 0x91c
  0720DA  0C4A: 1e               push ds
  0720DB  0C4B: 50               push ax
  0720DC  0C4C: ff369808         push word ptr [0x898]
  0720E0  0C50: ff369608         push word ptr [0x896]
  0720E4  0C54: 9a1a031f1a       lcall 0x1a1f, 0x31a
  0720E9  0C59: 83c40c           add sp, 0xc
  0720EC  0C5C: 56               push si
  0720ED  0C5D: 9a1c091f19       lcall 0x191f, 0x91c
  0720F2  0C62: 1e               push ds
  0720F3  0C63: 50               push ax
  0720F4  0C64: 56               push si
  0720F5  0C65: ff369808         push word ptr [0x898]
  0720F9  0C69: ff369608         push word ptr [0x896]
  0720FD  0C6D: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072102  0C72: 83c40c           add sp, 0xc
  072105  0C75: 6a02             push 2
  072107  0C77: 9a1c091f19       lcall 0x191f, 0x91c
  07210C  0C7C: 1e               push ds
  07210D  0C7D: 50               push ax
  07210E  0C7E: 56               push si
  07210F  0C7F: ff369808         push word ptr [0x898]
  072113  0C83: ff369608         push word ptr [0x896]
  072117  0C87: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07211C  0C8C: 83c40c           add sp, 0xc
  07211F  0C8F: 6a00             push 0
  072121  0C91: 1e               push ds
  072122  0C92: 68a220           push 0x20a2
  072125  0C95: 56               push si
  072126  0C96: ff369808         push word ptr [0x898]
  07212A  0C9A: ff369608         push word ptr [0x896]
  07212E  0C9E: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072133  0CA3: 83c40c           add sp, 0xc
  072136  0CA6: 6a03             push 3
  072138  0CA8: 9a1c091f19       lcall 0x191f, 0x91c
  07213D  0CAD: 1e               push ds
  07213E  0CAE: 50               push ax
  07213F  0CAF: 56               push si
  072140  0CB0: ff369808         push word ptr [0x898]
  072144  0CB4: ff369608         push word ptr [0x896]
  072148  0CB8: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07214D  0CBD: 83c40c           add sp, 0xc
  072150  0CC0: 6a04             push 4
  072152  0CC2: 9a1c091f19       lcall 0x191f, 0x91c
  072157  0CC7: 1e               push ds
  072158  0CC8: 50               push ax
  072159  0CC9: 56               push si
  07215A  0CCA: ff369808         push word ptr [0x898]
  07215E  0CCE: ff369608         push word ptr [0x896]
  072162  0CD2: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072167  0CD7: 83c40c           add sp, 0xc
  07216A  0CDA: 6a00             push 0
  07216C  0CDC: 1e               push ds
  07216D  0CDD: 68a320           push 0x20a3
  072170  0CE0: 56               push si
  072171  0CE1: ff369808         push word ptr [0x898]
  072175  0CE5: ff369608         push word ptr [0x896]
  072179  0CE9: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07217E  0CEE: 83c40c           add sp, 0xc
  072181  0CF1: 6a1a             push 0x1a
  072183  0CF3: 9a1c091f19       lcall 0x191f, 0x91c
  072188  0CF8: 1e               push ds
  072189  0CF9: 50               push ax
  07218A  0CFA: 56               push si
  07218B  0CFB: ff369808         push word ptr [0x898]
  07218F  0CFF: ff369608         push word ptr [0x896]
  072193  0D03: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072198  0D08: 83c40c           add sp, 0xc
  07219B  0D0B: 6a1b             push 0x1b
  07219D  0D0D: 9a1c091f19       lcall 0x191f, 0x91c
  0721A2  0D12: 1e               push ds
  0721A3  0D13: 50               push ax
  0721A4  0D14: 56               push si
  0721A5  0D15: ff369808         push word ptr [0x898]
  0721A9  0D19: ff369608         push word ptr [0x896]
  0721AD  0D1D: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0721B2  0D22: 83c40c           add sp, 0xc
  0721B5  0D25: 6a00             push 0
  0721B7  0D27: 1e               push ds
  0721B8  0D28: 68a420           push 0x20a4
  0721BB  0D2B: 56               push si
  0721BC  0D2C: ff369808         push word ptr [0x898]
  0721C0  0D30: ff369608         push word ptr [0x896]
  0721C4  0D34: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0721C9  0D39: 83c40c           add sp, 0xc
  0721CC  0D3C: 6a1c             push 0x1c
  0721CE  0D3E: 9a1c091f19       lcall 0x191f, 0x91c
  0721D3  0D43: 1e               push ds
  0721D4  0D44: 50               push ax
  0721D5  0D45: 56               push si
  0721D6  0D46: ff369808         push word ptr [0x898]
  0721DA  0D4A: ff369608         push word ptr [0x896]
  0721DE  0D4E: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0721E3  0D53: 83c40c           add sp, 0xc
  0721E6  0D56: 6a00             push 0
  0721E8  0D58: 1e               push ds
  0721E9  0D59: 68a520           push 0x20a5
  0721EC  0D5C: 56               push si
  0721ED  0D5D: ff369808         push word ptr [0x898]
  0721F1  0D61: ff369608         push word ptr [0x896]
  0721F5  0D65: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0721FA  0D6A: 83c40c           add sp, 0xc
  0721FD  0D6D: 6a1e             push 0x1e
  0721FF  0D6F: 9a1c091f19       lcall 0x191f, 0x91c
  072204  0D74: 1e               push ds
  072205  0D75: 50               push ax
  072206  0D76: 56               push si
  072207  0D77: ff369808         push word ptr [0x898]
  07220B  0D7B: ff369608         push word ptr [0x896]
  07220F  0D7F: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072214  0D84: 83c40c           add sp, 0xc
  072217  0D87: 6a1f             push 0x1f
  072219  0D89: 9a1c091f19       lcall 0x191f, 0x91c
  07221E  0D8E: 1e               push ds
  07221F  0D8F: 50               push ax
  072220  0D90: 56               push si
  072221  0D91: ff369808         push word ptr [0x898]
  072225  0D95: ff369608         push word ptr [0x896]
  072229  0D99: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07222E  0D9E: 83c40c           add sp, 0xc
  072231  0DA1: 68a620           push 0x20a6
  072234  0DA4: 6a00             push 0
  072236  0DA6: 9a28091f19       lcall 0x191f, 0x928
  07223B  0DAB: 83c404           add sp, 4
  07223E  0DAE: 0bc0             or ax, ax
  072240  0DB0: 7403             je 0xdb5
  072242  0DB2: e94a09           jmp 0x16ff
  072245  0DB5: 50               push ax
  072246  0DB6: 6a02             push 2
  072248  0DB8: 9a1c091f19       lcall 0x191f, 0x91c
  07224D  0DBD: 1e               push ds
  07224E  0DBE: 50               push ax
  07224F  0DBF: ff369808         push word ptr [0x898]
  072253  0DC3: ff369608         push word ptr [0x896]
  072257  0DC7: 9a1a031f1a       lcall 0x1a1f, 0x31a
  07225C  0DCC: 83c40c           add sp, 0xc
  07225F  0DCF: 6a20             push 0x20
  072261  0DD1: 9a1c091f19       lcall 0x191f, 0x91c
  072266  0DD6: 1e               push ds
  072267  0DD7: 50               push ax
  072268  0DD8: 6a02             push 2
  07226A  0DDA: ff369808         push word ptr [0x898]
  07226E  0DDE: ff369608         push word ptr [0x896]
  072272  0DE2: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072277  0DE7: 83c40c           add sp, 0xc
  07227A  0DEA: 6a21             push 0x21
  07227C  0DEC: 9a1c091f19       lcall 0x191f, 0x91c
  072281  0DF1: 1e               push ds
  072282  0DF2: 50               push ax
  072283  0DF3: 6a02             push 2
  072285  0DF5: ff369808         push word ptr [0x898]
  072289  0DF9: ff369608         push word ptr [0x896]
  07228D  0DFD: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072292  0E02: 83c40c           add sp, 0xc
  072295  0E05: 6a22             push 0x22
  072297  0E07: 9a1c091f19       lcall 0x191f, 0x91c
  07229C  0E0C: 1e               push ds
  07229D  0E0D: 50               push ax
  07229E  0E0E: 6a02             push 2
  0722A0  0E10: ff369808         push word ptr [0x898]
  0722A4  0E14: ff369608         push word ptr [0x896]
  0722A8  0E18: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0722AD  0E1D: 83c40c           add sp, 0xc
  0722B0  0E20: 6a00             push 0
  0722B2  0E22: 1e               push ds
  0722B3  0E23: 68ab20           push 0x20ab
  0722B6  0E26: 6a02             push 2
  0722B8  0E28: ff369808         push word ptr [0x898]
  0722BC  0E2C: ff369608         push word ptr [0x896]
  0722C0  0E30: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0722C5  0E35: 83c40c           add sp, 0xc
  0722C8  0E38: 6a23             push 0x23
  0722CA  0E3A: 9a1c091f19       lcall 0x191f, 0x91c
  0722CF  0E3F: 1e               push ds
  0722D0  0E40: 50               push ax
  0722D1  0E41: 6a02             push 2
  0722D3  0E43: ff369808         push word ptr [0x898]
  0722D7  0E47: ff369608         push word ptr [0x896]
  0722DB  0E4B: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0722E0  0E50: 83c40c           add sp, 0xc
  0722E3  0E53: 6a00             push 0
  0722E5  0E55: 1e               push ds
  0722E6  0E56: 68ac20           push 0x20ac
  0722E9  0E59: 6a02             push 2
  0722EB  0E5B: ff369808         push word ptr [0x898]
  0722EF  0E5F: ff369608         push word ptr [0x896]
  0722F3  0E63: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0722F8  0E68: 83c40c           add sp, 0xc
  0722FB  0E6B: 6a24             push 0x24
  0722FD  0E6D: 9a1c091f19       lcall 0x191f, 0x91c
  072302  0E72: 1e               push ds
  072303  0E73: 50               push ax
  072304  0E74: 6a02             push 2
  072306  0E76: ff369808         push word ptr [0x898]
  07230A  0E7A: ff369608         push word ptr [0x896]
  07230E  0E7E: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072313  0E83: 83c40c           add sp, 0xc
  072316  0E86: 6a25             push 0x25
  072318  0E88: 9a1c091f19       lcall 0x191f, 0x91c
  07231D  0E8D: 1e               push ds
  07231E  0E8E: 50               push ax
  07231F  0E8F: 6a02             push 2
  072321  0E91: ff369808         push word ptr [0x898]
  072325  0E95: ff369608         push word ptr [0x896]
  072329  0E99: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07232E  0E9E: 83c40c           add sp, 0xc
  072331  0EA1: 6a00             push 0
  072333  0EA3: 1e               push ds
  072334  0EA4: 68ad20           push 0x20ad
  072337  0EA7: 6a02             push 2
  072339  0EA9: ff369808         push word ptr [0x898]
  07233D  0EAD: ff369608         push word ptr [0x896]
  072341  0EB1: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072346  0EB6: 83c40c           add sp, 0xc
  072349  0EB9: 6a26             push 0x26
  07234B  0EBB: 9a1c091f19       lcall 0x191f, 0x91c
  072350  0EC0: 1e               push ds
  072351  0EC1: 50               push ax
  072352  0EC2: 6a02             push 2
  072354  0EC4: ff369808         push word ptr [0x898]
  072358  0EC8: ff369608         push word ptr [0x896]
  07235C  0ECC: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072361  0ED1: 83c40c           add sp, 0xc
  072364  0ED4: 6a27             push 0x27
  072366  0ED6: 9a1c091f19       lcall 0x191f, 0x91c
  07236B  0EDB: 1e               push ds
  07236C  0EDC: 50               push ax
  07236D  0EDD: 6a02             push 2
  07236F  0EDF: ff369808         push word ptr [0x898]
  072373  0EE3: ff369608         push word ptr [0x896]
  072377  0EE7: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07237C  0EEC: 83c40c           add sp, 0xc
  07237F  0EEF: 6a28             push 0x28
  072381  0EF1: 9a1c091f19       lcall 0x191f, 0x91c
  072386  0EF6: 1e               push ds
  072387  0EF7: 50               push ax
  072388  0EF8: 6a02             push 2
  07238A  0EFA: ff369808         push word ptr [0x898]
  07238E  0EFE: ff369608         push word ptr [0x896]
  072392  0F02: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072397  0F07: 83c40c           add sp, 0xc
  07239A  0F0A: 6a29             push 0x29
  07239C  0F0C: 9a1c091f19       lcall 0x191f, 0x91c
  0723A1  0F11: 1e               push ds
  0723A2  0F12: 50               push ax
  0723A3  0F13: 6a02             push 2
  0723A5  0F15: ff369808         push word ptr [0x898]
  0723A9  0F19: ff369608         push word ptr [0x896]
  0723AD  0F1D: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0723B2  0F22: 83c40c           add sp, 0xc
  0723B5  0F25: 6a00             push 0
  0723B7  0F27: 1e               push ds
  0723B8  0F28: 68ae20           push 0x20ae
  0723BB  0F2B: 6a02             push 2
  0723BD  0F2D: ff369808         push word ptr [0x898]
  0723C1  0F31: ff369608         push word ptr [0x896]
  0723C5  0F35: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0723CA  0F3A: 83c40c           add sp, 0xc
  0723CD  0F3D: 6a2a             push 0x2a
  0723CF  0F3F: 9a1c091f19       lcall 0x191f, 0x91c
  0723D4  0F44: 1e               push ds
  0723D5  0F45: 50               push ax
  0723D6  0F46: 6a02             push 2
  0723D8  0F48: ff369808         push word ptr [0x898]
  0723DC  0F4C: ff369608         push word ptr [0x896]
  0723E0  0F50: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0723E5  0F55: 83c40c           add sp, 0xc
  0723E8  0F58: 6a2b             push 0x2b
  0723EA  0F5A: 9a1c091f19       lcall 0x191f, 0x91c
  0723EF  0F5F: 1e               push ds
  0723F0  0F60: 50               push ax
  0723F1  0F61: 6a02             push 2
  0723F3  0F63: ff369808         push word ptr [0x898]
  0723F7  0F67: ff369608         push word ptr [0x896]
  0723FB  0F6B: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072400  0F70: 83c40c           add sp, 0xc
  072403  0F73: 68af20           push 0x20af
  072406  0F76: 6a00             push 0
  072408  0F78: 9a28091f19       lcall 0x191f, 0x928
  07240D  0F7D: 83c404           add sp, 4
  072410  0F80: 0bc0             or ax, ax
  072412  0F82: 7403             je 0xf87
  072414  0F84: e97807           jmp 0x16ff
  072417  0F87: 50               push ax
  072418  0F88: 6a03             push 3
  07241A  0F8A: 9a1c091f19       lcall 0x191f, 0x91c
  07241F  0F8F: 1e               push ds
  072420  0F90: 50               push ax
  072421  0F91: ff369808         push word ptr [0x898]
  072425  0F95: ff369608         push word ptr [0x896]
  072429  0F99: 9a1a031f1a       lcall 0x1a1f, 0x31a
  07242E  0F9E: 83c40c           add sp, 0xc
  072431  0FA1: 680003           push 0x300
  072434  0FA4: 9a1c091f19       lcall 0x191f, 0x91c
  072439  0FA9: 1e               push ds
  07243A  0FAA: 50               push ax
  07243B  0FAB: 6a03             push 3
  07243D  0FAD: ff369808         push word ptr [0x898]
  072441  0FB1: ff369608         push word ptr [0x896]
  072445  0FB5: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07244A  0FBA: 83c40c           add sp, 0xc
  07244D  0FBD: 680103           push 0x301
  072450  0FC0: 9a1c091f19       lcall 0x191f, 0x91c
  072455  0FC5: 1e               push ds
  072456  0FC6: 50               push ax
  072457  0FC7: 6a03             push 3
  072459  0FC9: ff369808         push word ptr [0x898]
  07245D  0FCD: ff369608         push word ptr [0x896]
  072461  0FD1: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072466  0FD6: 83c40c           add sp, 0xc
  072469  0FD9: 680203           push 0x302
  07246C  0FDC: 9a1c091f19       lcall 0x191f, 0x91c
  072471  0FE1: 1e               push ds
  072472  0FE2: 50               push ax
  072473  0FE3: 6a03             push 3
  072475  0FE5: ff369808         push word ptr [0x898]
  072479  0FE9: ff369608         push word ptr [0x896]
  07247D  0FED: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072482  0FF2: 83c40c           add sp, 0xc
  072485  0FF5: 680303           push 0x303
  072488  0FF8: 9a1c091f19       lcall 0x191f, 0x91c
  07248D  0FFD: 1e               push ds
  07248E  0FFE: 50               push ax
  07248F  0FFF: 6a03             push 3
  072491  1001: ff369808         push word ptr [0x898]
  072495  1005: ff369608         push word ptr [0x896]
  072499  1009: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07249E  100E: 83c40c           add sp, 0xc
  0724A1  1011: 680403           push 0x304
  0724A4  1014: 9a1c091f19       lcall 0x191f, 0x91c
  0724A9  1019: 1e               push ds
  0724AA  101A: 50               push ax
  0724AB  101B: 6a03             push 3
  0724AD  101D: ff369808         push word ptr [0x898]
  0724B1  1021: ff369608         push word ptr [0x896]
  0724B5  1025: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0724BA  102A: 83c40c           add sp, 0xc
  0724BD  102D: 6a00             push 0
  0724BF  102F: 1e               push ds
  0724C0  1030: 68b620           push 0x20b6
  0724C3  1033: 6a03             push 3
  0724C5  1035: ff369808         push word ptr [0x898]
  0724C9  1039: ff369608         push word ptr [0x896]
  0724CD  103D: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0724D2  1042: 83c40c           add sp, 0xc
  0724D5  1045: 681003           push 0x310
  0724D8  1048: 9a1c091f19       lcall 0x191f, 0x91c
  0724DD  104D: 1e               push ds
  0724DE  104E: 50               push ax
  0724DF  104F: 6a03             push 3
  0724E1  1051: ff369808         push word ptr [0x898]
  0724E5  1055: ff369608         push word ptr [0x896]
  0724E9  1059: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0724EE  105E: 83c40c           add sp, 0xc
  0724F1  1061: 681103           push 0x311
  0724F4  1064: 9a1c091f19       lcall 0x191f, 0x91c
  0724F9  1069: 1e               push ds
  0724FA  106A: 50               push ax
  0724FB  106B: 6a03             push 3
  0724FD  106D: ff369808         push word ptr [0x898]
  072501  1071: ff369608         push word ptr [0x896]
  072505  1075: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07250A  107A: 83c40c           add sp, 0xc
  07250D  107D: 681203           push 0x312
  072510  1080: 9a1c091f19       lcall 0x191f, 0x91c
  072515  1085: 1e               push ds
  072516  1086: 50               push ax
  072517  1087: 6a03             push 3
  072519  1089: ff369808         push word ptr [0x898]
  07251D  108D: ff369608         push word ptr [0x896]
  072521  1091: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072526  1096: 83c40c           add sp, 0xc
  072529  1099: 681303           push 0x313
  07252C  109C: 9a1c091f19       lcall 0x191f, 0x91c
  072531  10A1: 1e               push ds
  072532  10A2: 50               push ax
  072533  10A3: 6a03             push 3
  072535  10A5: ff369808         push word ptr [0x898]
  072539  10A9: ff369608         push word ptr [0x896]
  07253D  10AD: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072542  10B2: 83c40c           add sp, 0xc
  072545  10B5: 681403           push 0x314
  072548  10B8: 9a1c091f19       lcall 0x191f, 0x91c
  07254D  10BD: 1e               push ds
  07254E  10BE: 50               push ax
  07254F  10BF: 6a03             push 3
  072551  10C1: ff369808         push word ptr [0x898]
  072555  10C5: ff369608         push word ptr [0x896]
  072559  10C9: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07255E  10CE: 83c40c           add sp, 0xc
  072561  10D1: 681503           push 0x315
  072564  10D4: 9a1c091f19       lcall 0x191f, 0x91c
  072569  10D9: 1e               push ds
  07256A  10DA: 50               push ax
  07256B  10DB: 6a03             push 3
  07256D  10DD: ff369808         push word ptr [0x898]
  072571  10E1: ff369608         push word ptr [0x896]
  072575  10E5: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07257A  10EA: 83c40c           add sp, 0xc
  07257D  10ED: 681603           push 0x316
  072580  10F0: 9a1c091f19       lcall 0x191f, 0x91c
  072585  10F5: 1e               push ds
  072586  10F6: 50               push ax
  072587  10F7: 6a03             push 3
  072589  10F9: ff369808         push word ptr [0x898]
  07258D  10FD: ff369608         push word ptr [0x896]
  072591  1101: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072596  1106: 83c40c           add sp, 0xc
  072599  1109: 681703           push 0x317
  07259C  110C: 9a1c091f19       lcall 0x191f, 0x91c
  0725A1  1111: 1e               push ds
  0725A2  1112: 50               push ax
  0725A3  1113: 6a03             push 3
  0725A5  1115: ff369808         push word ptr [0x898]
  0725A9  1119: ff369608         push word ptr [0x896]
  0725AD  111D: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0725B2  1122: 83c40c           add sp, 0xc
  0725B5  1125: 68ff00           push 0xff
  0725B8  1128: 1e               push ds
  0725B9  1129: 68b720           push 0x20b7
  0725BC  112C: 6a03             push 3
  0725BE  112E: ff369808         push word ptr [0x898]
  0725C2  1132: ff369608         push word ptr [0x896]
  0725C6  1136: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0725CB  113B: 83c40c           add sp, 0xc
  0725CE  113E: 682003           push 0x320
  0725D1  1141: 9a1c091f19       lcall 0x191f, 0x91c
  0725D6  1146: 1e               push ds
  0725D7  1147: 50               push ax
  0725D8  1148: 6a03             push 3
  0725DA  114A: ff369808         push word ptr [0x898]
  0725DE  114E: ff369608         push word ptr [0x896]
  0725E2  1152: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0725E7  1157: 83c40c           add sp, 0xc
  0725EA  115A: 682103           push 0x321
  0725ED  115D: 9a1c091f19       lcall 0x191f, 0x91c
  0725F2  1162: 1e               push ds
  0725F3  1163: 50               push ax
  0725F4  1164: 6a03             push 3
  0725F6  1166: ff369808         push word ptr [0x898]
  0725FA  116A: ff369608         push word ptr [0x896]
  0725FE  116E: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072603  1173: 83c40c           add sp, 0xc
  072606  1176: 682203           push 0x322
  072609  1179: 9a1c091f19       lcall 0x191f, 0x91c
  07260E  117E: 1e               push ds
  07260F  117F: 50               push ax
  072610  1180: 6a03             push 3
  072612  1182: ff369808         push word ptr [0x898]
  072616  1186: ff369608         push word ptr [0x896]
  07261A  118A: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07261F  118F: 83c40c           add sp, 0xc
  072622  1192: 682303           push 0x323
  072625  1195: 9a1c091f19       lcall 0x191f, 0x91c
  07262A  119A: 1e               push ds
  07262B  119B: 50               push ax
  07262C  119C: 6a03             push 3
  07262E  119E: ff369808         push word ptr [0x898]
  072632  11A2: ff369608         push word ptr [0x896]
  072636  11A6: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07263B  11AB: 83c40c           add sp, 0xc
  07263E  11AE: 680001           push 0x100
  072641  11B1: 1e               push ds
  072642  11B2: 68b820           push 0x20b8
  072645  11B5: 6a03             push 3
  072647  11B7: ff369808         push word ptr [0x898]
  07264B  11BB: ff369608         push word ptr [0x896]
  07264F  11BF: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072654  11C4: 83c40c           add sp, 0xc
  072657  11C7: 683003           push 0x330
  07265A  11CA: 9a1c091f19       lcall 0x191f, 0x91c
  07265F  11CF: 1e               push ds
  072660  11D0: 50               push ax
  072661  11D1: 6a03             push 3
  072663  11D3: ff369808         push word ptr [0x898]
  072667  11D7: ff369608         push word ptr [0x896]
  07266B  11DB: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072670  11E0: 83c40c           add sp, 0xc
  072673  11E3: 6a00             push 0
  072675  11E5: 1e               push ds
  072676  11E6: 68b920           push 0x20b9
  072679  11E9: 6a03             push 3
  07267B  11EB: ff369808         push word ptr [0x898]
  07267F  11EF: ff369608         push word ptr [0x896]
  072683  11F3: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072688  11F8: 83c40c           add sp, 0xc
  07268B  11FB: 683103           push 0x331
  07268E  11FE: 9a1c091f19       lcall 0x191f, 0x91c
  072693  1203: 1e               push ds
  072694  1204: 50               push ax
  072695  1205: 6a03             push 3
  072697  1207: ff369808         push word ptr [0x898]
  07269B  120B: ff369608         push word ptr [0x896]
  07269F  120F: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0726A4  1214: 83c40c           add sp, 0xc
  0726A7  1217: 683203           push 0x332
  0726AA  121A: 9a1c091f19       lcall 0x191f, 0x91c
  0726AF  121F: 1e               push ds
  0726B0  1220: 50               push ax
  0726B1  1221: 6a03             push 3
  0726B3  1223: ff369808         push word ptr [0x898]
  0726B7  1227: ff369608         push word ptr [0x896]
  0726BB  122B: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0726C0  1230: 83c40c           add sp, 0xc
  0726C3  1233: 68ba20           push 0x20ba
  0726C6  1236: 6a00             push 0
  0726C8  1238: 9a28091f19       lcall 0x191f, 0x928
  0726CD  123D: 83c404           add sp, 4
  0726D0  1240: 0bc0             or ax, ax
  0726D2  1242: 7403             je 0x1247
  0726D4  1244: e9b804           jmp 0x16ff
  0726D7  1247: 50               push ax
  0726D8  1248: 6a04             push 4
  0726DA  124A: 9a1c091f19       lcall 0x191f, 0x91c
  0726DF  124F: 1e               push ds
  0726E0  1250: 50               push ax
  0726E1  1251: ff369808         push word ptr [0x898]
  0726E5  1255: ff369608         push word ptr [0x896]
  0726E9  1259: 9a1a031f1a       lcall 0x1a1f, 0x31a
  0726EE  125E: 83c40c           add sp, 0xc
  0726F1  1261: 6a40             push 0x40
  0726F3  1263: 9a1c091f19       lcall 0x191f, 0x91c
  0726F8  1268: 1e               push ds
  0726F9  1269: 50               push ax
  0726FA  126A: 6a04             push 4
  0726FC  126C: ff369808         push word ptr [0x898]
  072700  1270: ff369608         push word ptr [0x896]
  072704  1274: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072709  1279: 83c40c           add sp, 0xc
  07270C  127C: 6a00             push 0
  07270E  127E: 1e               push ds
  07270F  127F: 68c220           push 0x20c2
  072712  1282: 6a04             push 4
  072714  1284: ff369808         push word ptr [0x898]
  072718  1288: ff369608         push word ptr [0x896]
  07271C  128C: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072721  1291: 83c40c           add sp, 0xc
  072724  1294: 6a41             push 0x41
  072726  1296: 9a1c091f19       lcall 0x191f, 0x91c
  07272B  129B: 1e               push ds
  07272C  129C: 50               push ax
  07272D  129D: 6a04             push 4
  07272F  129F: ff369808         push word ptr [0x898]
  072733  12A3: ff369608         push word ptr [0x896]
  072737  12A7: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07273C  12AC: 83c40c           add sp, 0xc
  07273F  12AF: 6a42             push 0x42
  072741  12B1: 9a1c091f19       lcall 0x191f, 0x91c
  072746  12B6: 1e               push ds
  072747  12B7: 50               push ax
  072748  12B8: 6a04             push 4
  07274A  12BA: ff369808         push word ptr [0x898]
  07274E  12BE: ff369608         push word ptr [0x896]
  072752  12C2: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072757  12C7: 83c40c           add sp, 0xc
  07275A  12CA: 6a43             push 0x43
  07275C  12CC: 9a1c091f19       lcall 0x191f, 0x91c
  072761  12D1: 1e               push ds
  072762  12D2: 50               push ax
  072763  12D3: 6a04             push 4
  072765  12D5: ff369808         push word ptr [0x898]
  072769  12D9: ff369608         push word ptr [0x896]
  07276D  12DD: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072772  12E2: 83c40c           add sp, 0xc
  072775  12E5: 6a44             push 0x44
  072777  12E7: 9a1c091f19       lcall 0x191f, 0x91c
  07277C  12EC: 1e               push ds
  07277D  12ED: 50               push ax
  07277E  12EE: 6a04             push 4
  072780  12F0: ff369808         push word ptr [0x898]
  072784  12F4: ff369608         push word ptr [0x896]
  072788  12F8: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07278D  12FD: 83c40c           add sp, 0xc
  072790  1300: 6a00             push 0
  072792  1302: 1e               push ds
  072793  1303: 68c320           push 0x20c3
  072796  1306: 6a04             push 4
  072798  1308: ff369808         push word ptr [0x898]
  07279C  130C: ff369608         push word ptr [0x896]
  0727A0  1310: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0727A5  1315: 83c40c           add sp, 0xc
  0727A8  1318: 6a45             push 0x45
  0727AA  131A: 9a1c091f19       lcall 0x191f, 0x91c
  0727AF  131F: 1e               push ds
  0727B0  1320: 50               push ax
  0727B1  1321: 6a04             push 4
  0727B3  1323: ff369808         push word ptr [0x898]
  0727B7  1327: ff369608         push word ptr [0x896]
  0727BB  132B: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0727C0  1330: 83c40c           add sp, 0xc
  0727C3  1333: 6a46             push 0x46
  0727C5  1335: 9a1c091f19       lcall 0x191f, 0x91c
  0727CA  133A: 1e               push ds
  0727CB  133B: 50               push ax
  0727CC  133C: 6a04             push 4
  0727CE  133E: ff369808         push word ptr [0x898]
  0727D2  1342: ff369608         push word ptr [0x896]
  0727D6  1346: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0727DB  134B: 83c40c           add sp, 0xc
  0727DE  134E: 6a47             push 0x47
  0727E0  1350: 9a1c091f19       lcall 0x191f, 0x91c
  0727E5  1355: 1e               push ds
  0727E6  1356: 50               push ax
  0727E7  1357: 6a04             push 4
  0727E9  1359: ff369808         push word ptr [0x898]
  0727ED  135D: ff369608         push word ptr [0x896]
  0727F1  1361: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0727F6  1366: 83c40c           add sp, 0xc
  0727F9  1369: 6a48             push 0x48
  0727FB  136B: 9a1c091f19       lcall 0x191f, 0x91c
  072800  1370: 1e               push ds
  072801  1371: 50               push ax
  072802  1372: 6a04             push 4
  072804  1374: ff369808         push word ptr [0x898]
  072808  1378: ff369608         push word ptr [0x896]
  07280C  137C: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072811  1381: 83c40c           add sp, 0xc
  072814  1384: 6a00             push 0
  072816  1386: 1e               push ds
  072817  1387: 68c420           push 0x20c4
  07281A  138A: 6a04             push 4
  07281C  138C: ff369808         push word ptr [0x898]
  072820  1390: ff369608         push word ptr [0x896]
  072824  1394: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072829  1399: 83c40c           add sp, 0xc
  07282C  139C: 6a49             push 0x49
  07282E  139E: 9a1c091f19       lcall 0x191f, 0x91c
  072833  13A3: 1e               push ds
  072834  13A4: 50               push ax
  072835  13A5: 6a04             push 4
  072837  13A7: ff369808         push word ptr [0x898]
  07283B  13AB: ff369608         push word ptr [0x896]
  07283F  13AF: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072844  13B4: 83c40c           add sp, 0xc
  072847  13B7: 68c520           push 0x20c5
  07284A  13BA: 6a00             push 0
  07284C  13BC: 9a28091f19       lcall 0x191f, 0x928
  072851  13C1: 83c404           add sp, 4
  072854  13C4: 0bc0             or ax, ax
  072856  13C6: 7403             je 0x13cb
  072858  13C8: e93403           jmp 0x16ff
  07285B  13CB: 50               push ax
  07285C  13CC: 6a05             push 5
  07285E  13CE: 9a1c091f19       lcall 0x191f, 0x91c
  072863  13D3: 1e               push ds
  072864  13D4: 50               push ax
  072865  13D5: ff369808         push word ptr [0x898]
  072869  13D9: ff369608         push word ptr [0x896]
  07286D  13DD: 9a1a031f1a       lcall 0x1a1f, 0x31a
  072872  13E2: 83c40c           add sp, 0xc
  072875  13E5: 6a50             push 0x50
  072877  13E7: 9a1c091f19       lcall 0x191f, 0x91c
  07287C  13EC: 1e               push ds
  07287D  13ED: 50               push ax
  07287E  13EE: 6a05             push 5
  072880  13F0: ff369808         push word ptr [0x898]
  072884  13F4: ff369608         push word ptr [0x896]
  072888  13F8: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07288D  13FD: 83c40c           add sp, 0xc
  072890  1400: 6a51             push 0x51
  072892  1402: 9a1c091f19       lcall 0x191f, 0x91c
  072897  1407: 1e               push ds
  072898  1408: 50               push ax
  072899  1409: 6a05             push 5
  07289B  140B: ff369808         push word ptr [0x898]
  07289F  140F: ff369608         push word ptr [0x896]
  0728A3  1413: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0728A8  1418: 83c40c           add sp, 0xc
  0728AB  141B: 6a52             push 0x52
  0728AD  141D: 9a1c091f19       lcall 0x191f, 0x91c
  0728B2  1422: 1e               push ds
  0728B3  1423: 50               push ax
  0728B4  1424: 6a05             push 5
  0728B6  1426: ff369808         push word ptr [0x898]
  0728BA  142A: ff369608         push word ptr [0x896]
  0728BE  142E: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0728C3  1433: 83c40c           add sp, 0xc
  0728C6  1436: 68cb20           push 0x20cb
  0728C9  1439: 6a00             push 0
  0728CB  143B: 9a28091f19       lcall 0x191f, 0x928
  0728D0  1440: 83c404           add sp, 4
  0728D3  1443: 0bc0             or ax, ax
  0728D5  1445: 7403             je 0x144a
  0728D7  1447: e9b502           jmp 0x16ff
  0728DA  144A: 50               push ax
  0728DB  144B: 6a06             push 6
  0728DD  144D: 9a1c091f19       lcall 0x191f, 0x91c
  0728E2  1452: 1e               push ds
  0728E3  1453: 50               push ax
  0728E4  1454: ff369808         push word ptr [0x898]
  0728E8  1458: ff369608         push word ptr [0x896]
  0728EC  145C: 9a1a031f1a       lcall 0x1a1f, 0x31a
  0728F1  1461: 83c40c           add sp, 0xc
  0728F4  1464: 6a62             push 0x62
  0728F6  1466: 9a1c091f19       lcall 0x191f, 0x91c
  0728FB  146B: 1e               push ds
  0728FC  146C: 50               push ax
  0728FD  146D: 6a06             push 6
  0728FF  146F: ff369808         push word ptr [0x898]
  072903  1473: ff369608         push word ptr [0x896]
  072907  1477: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07290C  147C: 83c40c           add sp, 0xc
  07290F  147F: 6a63             push 0x63
  072911  1481: 9a1c091f19       lcall 0x191f, 0x91c
  072916  1486: 1e               push ds
  072917  1487: 50               push ax
  072918  1488: 6a06             push 6
  07291A  148A: ff369808         push word ptr [0x898]
  07291E  148E: ff369608         push word ptr [0x896]
  072922  1492: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072927  1497: 83c40c           add sp, 0xc
  07292A  149A: 6a00             push 0
  07292C  149C: 1e               push ds
  07292D  149D: 68cf20           push 0x20cf
  072930  14A0: 6a06             push 6
  072932  14A2: ff369808         push word ptr [0x898]
  072936  14A6: ff369608         push word ptr [0x896]
  07293A  14AA: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07293F  14AF: 83c40c           add sp, 0xc
  072942  14B2: 6a65             push 0x65
  072944  14B4: 9a1c091f19       lcall 0x191f, 0x91c
  072949  14B9: 1e               push ds
  07294A  14BA: 50               push ax
  07294B  14BB: 6a06             push 6
  07294D  14BD: ff369808         push word ptr [0x898]
  072951  14C1: ff369608         push word ptr [0x896]
  072955  14C5: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07295A  14CA: 83c40c           add sp, 0xc
  07295D  14CD: 6a66             push 0x66
  07295F  14CF: 9a1c091f19       lcall 0x191f, 0x91c
  072964  14D4: 1e               push ds
  072965  14D5: 50               push ax
  072966  14D6: 6a06             push 6
  072968  14D8: ff369808         push word ptr [0x898]
  07296C  14DC: ff369608         push word ptr [0x896]
  072970  14E0: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072975  14E5: 83c40c           add sp, 0xc
  072978  14E8: 6a00             push 0
  07297A  14EA: 1e               push ds
  07297B  14EB: 68d020           push 0x20d0
  07297E  14EE: 6a06             push 6
  072980  14F0: ff369808         push word ptr [0x898]
  072984  14F4: ff369608         push word ptr [0x896]
  072988  14F8: 9a3e031f1a       lcall 0x1a1f, 0x33e
  07298D  14FD: 83c40c           add sp, 0xc
  072990  1500: 6a67             push 0x67
  072992  1502: 9a1c091f19       lcall 0x191f, 0x91c
  072997  1507: 1e               push ds
  072998  1508: 50               push ax
  072999  1509: 6a06             push 6
  07299B  150B: ff369808         push word ptr [0x898]
  07299F  150F: ff369608         push word ptr [0x896]
  0729A3  1513: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0729A8  1518: 83c40c           add sp, 0xc
  0729AB  151B: 6a68             push 0x68
  0729AD  151D: 9a1c091f19       lcall 0x191f, 0x91c
  0729B2  1522: 1e               push ds
  0729B3  1523: 50               push ax
  0729B4  1524: 6a06             push 6
  0729B6  1526: ff369808         push word ptr [0x898]
  0729BA  152A: ff369608         push word ptr [0x896]
  0729BE  152E: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0729C3  1533: 83c40c           add sp, 0xc
  0729C6  1536: 6a00             push 0
  0729C8  1538: 1e               push ds
  0729C9  1539: 68d120           push 0x20d1
  0729CC  153C: 6a06             push 6
  0729CE  153E: ff369808         push word ptr [0x898]
  0729D2  1542: ff369608         push word ptr [0x896]
  0729D6  1546: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0729DB  154B: 83c40c           add sp, 0xc
  0729DE  154E: 6a69             push 0x69
  0729E0  1550: 9a1c091f19       lcall 0x191f, 0x91c
  0729E5  1555: 1e               push ds
  0729E6  1556: 50               push ax
  0729E7  1557: 6a06             push 6
  0729E9  1559: ff369808         push word ptr [0x898]
  0729ED  155D: ff369608         push word ptr [0x896]
  0729F1  1561: 9a3e031f1a       lcall 0x1a1f, 0x33e
  0729F6  1566: 83c40c           add sp, 0xc
  0729F9  1569: 8bf8             mov di, ax
  0729FB  156B: 8956fe           mov word ptr [bp - 2], dx
  0729FE  156E: 6a6a             push 0x6a
  072A00  1570: 9a1c091f19       lcall 0x191f, 0x91c
  072A05  1575: 1e               push ds
  072A06  1576: 50               push ax
  072A07  1577: 6a06             push 6
  072A09  1579: ff369808         push word ptr [0x898]
  072A0D  157D: ff369608         push word ptr [0x896]
  072A11  1581: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072A16  1586: 83c40c           add sp, 0xc
  072A19  1589: 6a00             push 0
  072A1B  158B: 1e               push ds
  072A1C  158C: 68d220           push 0x20d2
  072A1F  158F: 6a06             push 6
  072A21  1591: ff369808         push word ptr [0x898]
  072A25  1595: ff369608         push word ptr [0x896]
  072A29  1599: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072A2E  159E: 83c40c           add sp, 0xc
  072A31  15A1: 6a6b             push 0x6b
  072A33  15A3: 9a1c091f19       lcall 0x191f, 0x91c
  072A38  15A8: 1e               push ds
  072A39  15A9: 50               push ax
  072A3A  15AA: 6a06             push 6
  072A3C  15AC: ff369808         push word ptr [0x898]
  072A40  15B0: ff369608         push word ptr [0x896]
  072A44  15B4: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072A49  15B9: 83c40c           add sp, 0xc
  072A4C  15BC: 6a6c             push 0x6c
  072A4E  15BE: 9a1c091f19       lcall 0x191f, 0x91c
  072A53  15C3: 1e               push ds
  072A54  15C4: 50               push ax
  072A55  15C5: 6a06             push 6
  072A57  15C7: ff369808         push word ptr [0x898]
  072A5B  15CB: ff369608         push word ptr [0x896]
  072A5F  15CF: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072A64  15D4: 83c40c           add sp, 0xc
  072A67  15D7: 6a6f             push 0x6f
  072A69  15D9: 9a1c091f19       lcall 0x191f, 0x91c
  072A6E  15DE: 1e               push ds
  072A6F  15DF: 50               push ax
  072A70  15E0: 6a06             push 6
  072A72  15E2: ff369808         push word ptr [0x898]
  072A76  15E6: ff369608         push word ptr [0x896]
  072A7A  15EA: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072A7F  15EF: 83c40c           add sp, 0xc
  072A82  15F2: 8e46fe           mov es, word ptr [bp - 2]
  072A85  15F5: 26c745021300     mov word ptr es:[di + 2], 0x13
  072A8B  15FB: f606835320       test byte ptr [0x5383], 0x20
  072A90  1600: 7513             jne 0x1615
  072A92  1602: 56               push si
  072A93  1603: 6a06             push 6
  072A95  1605: ff369808         push word ptr [0x898]
  072A99  1609: ff369608         push word ptr [0x896]
  072A9D  160D: 9a5c041f19       lcall 0x191f, 0x45c
  072AA2  1612: 83c408           add sp, 8
  072AA5  1615: 68d320           push 0x20d3
  072AA8  1618: 6a00             push 0
  072AAA  161A: 9a28091f19       lcall 0x191f, 0x928
  072AAF  161F: 83c404           add sp, 4
  072AB2  1622: 0bc0             or ax, ax
  072AB4  1624: 7403             je 0x1629
  072AB6  1626: e9d600           jmp 0x16ff
  072AB9  1629: 56               push si
  072ABA  162A: 6a07             push 7
  072ABC  162C: 9a1c091f19       lcall 0x191f, 0x91c
  072AC1  1631: 1e               push ds
  072AC2  1632: 50               push ax
  072AC3  1633: ff369808         push word ptr [0x898]
  072AC7  1637: ff369608         push word ptr [0x896]
  072ACB  163B: 9a1a031f1a       lcall 0x1a1f, 0x31a
  072AD0  1640: 83c40c           add sp, 0xc
  072AD3  1643: 6a70             push 0x70
  072AD5  1645: 9a1c091f19       lcall 0x191f, 0x91c
  072ADA  164A: 1e               push ds
  072ADB  164B: 50               push ax
  072ADC  164C: 6a07             push 7
  072ADE  164E: ff369808         push word ptr [0x898]
  072AE2  1652: ff369608         push word ptr [0x896]
  072AE6  1656: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072AEB  165B: 83c40c           add sp, 0xc
  072AEE  165E: 6a71             push 0x71
  072AF0  1660: 9a1c091f19       lcall 0x191f, 0x91c
  072AF5  1665: 1e               push ds
  072AF6  1666: 50               push ax
  072AF7  1667: 6a07             push 7
  072AF9  1669: ff369808         push word ptr [0x898]
  072AFD  166D: ff369608         push word ptr [0x896]
  072B01  1671: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072B06  1676: 83c40c           add sp, 0xc
  072B09  1679: 6a72             push 0x72
  072B0B  167B: 9a1c091f19       lcall 0x191f, 0x91c
  072B10  1680: 1e               push ds
  072B11  1681: 50               push ax
  072B12  1682: 6a07             push 7
  072B14  1684: ff369808         push word ptr [0x898]
  072B18  1688: ff369608         push word ptr [0x896]
  072B1C  168C: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072B21  1691: 83c40c           add sp, 0xc
  072B24  1694: 6a00             push 0
  072B26  1696: 1e               push ds
  072B27  1697: 68d920           push 0x20d9
  072B2A  169A: 6a07             push 7
  072B2C  169C: ff369808         push word ptr [0x898]
  072B30  16A0: ff369608         push word ptr [0x896]
  072B34  16A4: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072B39  16A9: 83c40c           add sp, 0xc
  072B3C  16AC: 6a73             push 0x73
  072B3E  16AE: 9a1c091f19       lcall 0x191f, 0x91c
  072B43  16B3: 1e               push ds
  072B44  16B4: 50               push ax
  072B45  16B5: 6a07             push 7
  072B47  16B7: ff369808         push word ptr [0x898]
  072B4B  16BB: ff369608         push word ptr [0x896]
  072B4F  16BF: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072B54  16C4: 83c40c           add sp, 0xc
  072B57  16C7: 6a74             push 0x74
  072B59  16C9: 9a1c091f19       lcall 0x191f, 0x91c
  072B5E  16CE: 1e               push ds
  072B5F  16CF: 50               push ax
  072B60  16D0: 6a07             push 7
  072B62  16D2: ff369808         push word ptr [0x898]
  072B66  16D6: ff369608         push word ptr [0x896]
  072B6A  16DA: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072B6F  16DF: 83c40c           add sp, 0xc
  072B72  16E2: 6a75             push 0x75
  072B74  16E4: 9a1c091f19       lcall 0x191f, 0x91c
  072B79  16E9: 1e               push ds
  072B7A  16EA: 50               push ax
  072B7B  16EB: 6a07             push 7
  072B7D  16ED: ff369808         push word ptr [0x898]
  072B81  16F1: ff369608         push word ptr [0x896]
  072B85  16F5: 9a3e031f1a       lcall 0x1a1f, 0x33e
  072B8A  16FA: 83c40c           add sp, 0xc
  072B8D  16FD: 2bf6             sub si, si
  072B8F  16FF: 9ab80f1f19       lcall 0x191f, 0xfb8
  072B94  1704: 8bc6             mov ax, si
  072B96  1706: 5e               pop si
  072B97  1707: 5f               pop di
  072B98  1708: c9               leave 
  072B99  1709: cb               retf 

; ---- func_072B9A  size=266  insns=99  prologue=ENTER 0x0024,0  terminal=RETF ----
  072B9A  170A: c8240000         enter 0x24, 0
  072B9E  170E: 57               push di
  072B9F  170F: 56               push si
  072BA0  1710: 2bc0             sub ax, ax
  072BA2  1712: 8946ee           mov word ptr [bp - 0x12], ax
  072BA5  1715: 8946ec           mov word ptr [bp - 0x14], ax
  072BA8  1718: b80c00           mov ax, 0xc
  072BAB  171B: 8946fa           mov word ptr [bp - 6], ax
  072BAE  171E: 50               push ax
  072BAF  171F: 9a7c021f18       lcall 0x181f, 0x27c
  072BB4  1724: 83c402           add sp, 2
  072BB7  1727: 8bf0             mov si, ax
  072BB9  1729: 8956e6           mov word ptr [bp - 0x1a], dx
  072BBC  172C: 0bd0             or dx, ax
  072BBE  172E: 750a             jne 0x173a
  072BC0  1730: c70622082103     mov word ptr [0x822], 0x321
  072BC6  1736: eb7c             jmp 0x17b4
  072BC8  1738: 90               nop 
  072BC9  1739: 90               nop 
  072BCA  173A: 8b5e06           mov bx, word ptr [bp + 6]
  072BCD  173D: b80040           mov ax, 0x4000
  072BD0  1740: 9a72031f1a       lcall 0x1a1f, 0x372
  072BD5  1745: 8946e8           mov word ptr [bp - 0x18], ax
  072BD8  1748: 8956ea           mov word ptr [bp - 0x16], dx
  072BDB  174B: 0bd0             or dx, ax
  072BDD  174D: 7509             jne 0x1758
  072BDF  174F: c70622082203     mov word ptr [0x822], 0x322
  072BE5  1755: eb5d             jmp 0x17b4
  072BE7  1757: 90               nop 
  072BE8  1758: 8976e4           mov word ptr [bp - 0x1c], si
  072BEB  175B: b81000           mov ax, 0x10
  072BEE  175E: 8946de           mov word ptr [bp - 0x22], ax
  072BF1  1761: 8946dc           mov word ptr [bp - 0x24], ax
  072BF4  1764: 2bf6             sub si, si
  072BF6  1766: 8b4ee4           mov cx, word ptr [bp - 0x1c]
  072BF9  1769: 8b46e6           mov ax, word ptr [bp - 0x1a]
  072BFC  176C: 8bf9             mov di, cx
  072BFE  176E: 8946f6           mov word ptr [bp - 0xa], ax
  072C01  1771: 8b46f6           mov ax, word ptr [bp - 0xa]
  072C04  1774: 897ee0           mov word ptr [bp - 0x20], di
  072C07  1777: 8946e2           mov word ptr [bp - 0x1e], ax
  072C0A  177A: ff76ea           push word ptr [bp - 0x16]
  072C0D  177D: ff76e8           push word ptr [bp - 0x18]
  072C10  1780: 6a00             push 0
  072C12  1782: 8d4401           lea ax, [si + 1]
  072C15  1785: 8d5edc           lea bx, [bp - 0x24]
  072C18  1788: 2bd2             sub dx, dx
  072C1A  178A: 9a54021f18       lcall 0x181f, 0x254
  072C1F  178F: 81c70001         add di, 0x100
  072C23  1793: 8d4401           lea ax, [si + 1]
  072C26  1796: 8bf0             mov si, ax
  072C28  1798: 83fe0c           cmp si, 0xc
  072C2B  179B: 7cd4             jl 0x1771
  072C2D  179D: ff76ea           push word ptr [bp - 0x16]
  072C30  17A0: ff76e8           push word ptr [bp - 0x18]
  072C33  17A3: 9aa8011f19       lcall 0x191f, 0x1a8
  072C38  17A8: 8b46e4           mov ax, word ptr [bp - 0x1c]
  072C3B  17AB: 8b56e6           mov dx, word ptr [bp - 0x1a]
  072C3E  17AE: 8946ec           mov word ptr [bp - 0x14], ax
  072C41  17B1: 8956ee           mov word ptr [bp - 0x12], dx
  072C44  17B4: 8b46ec           mov ax, word ptr [bp - 0x14]
  072C47  17B7: 8b56ee           mov dx, word ptr [bp - 0x12]
  072C4A  17BA: 5e               pop si
  072C4B  17BB: 5f               pop di
  072C4C  17BC: c9               leave 
  072C4D  17BD: cb               retf 
  072C4E  17BE: 56               push si
  072C4F  17BF: be0100           mov si, 1
  072C52  17C2: 68da20           push 0x20da
  072C55  17C5: 0e               push cs
  072C56  17C6: e81900           call 0x17e2
  072C59  17C9: 83c402           add sp, 2
  072C5C  17CC: a36c01           mov word ptr [0x16c], ax
  072C5F  17CF: 89166e01         mov word ptr [0x16e], dx
  072C63  17D3: 8bc2             mov ax, dx
  072C65  17D5: 0b066c01         or ax, word ptr [0x16c]
  072C69  17D9: 7402             je 0x17dd
  072C6B  17DB: 2bf6             sub si, si
  072C6D  17DD: 8bc6             mov ax, si
  072C6F  17DF: 5e               pop si
  072C70  17E0: cb               retf 
  072C71  17E1: 90               nop 
  072C72  17E2: eacc0c1f1a       ljmp 0x1a1f:0xccc
  072C77  17E7: 00558b           add byte ptr [di - 0x75], dl
  072C7A  17EA: ec               in al, dx
  072C7B  17EB: 68e220           push 0x20e2
  072C7E  17EE: ff7606           push word ptr [bp + 6]
  072C81  17F1: 9ae4071d0d       lcall 0xd1d, 0x7e4
  072C86  17F6: 8be5             mov sp, bp
  072C88  17F8: 1e               push ds
  072C89  17F9: ff7606           push word ptr [bp + 6]
  072C8C  17FC: 8b4608           mov ax, word ptr [bp + 8]
  072C8F  17FF: ba0200           mov dx, 2
  072C92  1802: 9a9a0e1f18       lcall 0x181f, 0xe9a
  072C97  1807: 68e920           push 0x20e9
  072C9A  180A: ff7606           push word ptr [bp + 6]
  072C9D  180D: 9aa4071d0d       lcall 0xd1d, 0x7a4
  072CA2  1812: c9               leave 
  072CA3  1813: cb               retf 

; ---- func_072CA4  size=29  insns=12  prologue=ENTER 0x0050,0  terminal=RETF ----
  072CA4  1814: c8500000         enter 0x50, 0
  072CA8  1818: ff7606           push word ptr [bp + 6]
  072CAB  181B: 8d46b0           lea ax, [bp - 0x50]
  072CAE  181E: 50               push ax
  072CAF  181F: 0e               push cs
  072CB0  1820: e8b305           call 0x1dd6
  072CB3  1823: 83c404           add sp, 4
  072CB6  1826: 8d46b0           lea ax, [bp - 0x50]
  072CB9  1829: 50               push ax
  072CBA  182A: 9af60c1f1a       lcall 0x1a1f, 0xcf6
  072CBF  182F: c9               leave 
  072CC0  1830: cb               retf 

; ---- func_072CC2  size=696  insns=213  prologue=ENTER 0x0276,0  terminal=RETF ----
  072CC2  1832: c8760200         enter 0x276, 0
  072CC6  1836: 56               push si
  072CC7  1837: c786e2fe0000     mov word ptr [bp - 0x11e], 0
  072CCD  183D: 2bc0             sub ax, ax
  072CCF  183F: 8986ecfe         mov word ptr [bp - 0x114], ax
  072CD3  1843: 8986eafe         mov word ptr [bp - 0x116], ax
  072CD7  1847: ff36a21f         push word ptr [0x1fa2]
  072CDB  184B: ff36a008         push word ptr [0x8a0]
  072CDF  184F: ff369e08         push word ptr [0x89e]
  072CE3  1853: 9ac4071f1a       lcall 0x1a1f, 0x7c4
  072CE8  1858: 83c406           add sp, 6
  072CEB  185B: 2bd2             sub dx, dx
  072CED  185D: 8996e0fe         mov word ptr [bp - 0x120], dx
  072CF1  1861: 8d1e7c08         lea bx, [0x87c]
  072CF5  1865: 8b4606           mov ax, word ptr [bp + 6]
  072CF8  1868: 9a82011f19       lcall 0x191f, 0x182
  072CFD  186D: 8986eafe         mov word ptr [bp - 0x116], ax
  072D01  1871: 8996ecfe         mov word ptr [bp - 0x114], dx
  072D05  1875: 0bd0             or dx, ax
  072D07  1877: 7503             jne 0x187c
  072D09  1879: e94f02           jmp 0x1acb
  072D0C  187C: c49eeafe         les bx, ptr [bp - 0x116]
  072D10  1880: 26804f0a01       or byte ptr es:[bx + 0xa], 1
  072D15  1885: c786e4fe0000     mov word ptr [bp - 0x11c], 0
  072D1B  188B: e9b001           jmp 0x1a3e
  072D1E  188E: 8b9ee4fe         mov bx, word ptr [bp - 0x11c]
  072D22  1892: c6870ca601       mov byte ptr [bx - 0x59f4], 1
  072D27  1897: c786e6feffff     mov word ptr [bp - 0x11a], 0xffff
  072D2D  189D: c786e8fe0000     mov word ptr [bp - 0x118], 0
  072D33  18A3: eb20             jmp 0x18c5
  072D35  18A5: 90               nop 
  072D36  18A6: 83bee8fe04       cmp word ptr [bp - 0x118], 4
  072D3B  18AB: 7d1f             jge 0x18cc
  072D3D  18AD: 6bb6e8fe34       imul si, word ptr [bp - 0x118], 0x34
  072D42  18B2: 80babdfd00       cmp byte ptr [bp + si - 0x243], 0
  072D47  18B7: 7508             jne 0x18c1
  072D49  18B9: 8b86e8fe         mov ax, word ptr [bp - 0x118]
  072D4D  18BD: 8986e6fe         mov word ptr [bp - 0x11a], ax
  072D51  18C1: ff86e8fe         inc word ptr [bp - 0x118]
  072D55  18C5: 83bee6fe00       cmp word ptr [bp - 0x11a], 0
  072D5A  18CA: 7cda             jl 0x18a6
  072D5C  18CC: 83bee6fe00       cmp word ptr [bp - 0x11a], 0
  072D61  18D1: 7d06             jge 0x18d9
  072D63  18D3: c786e6fe0000     mov word ptr [bp - 0x11a], 0
  072D69  18D9: c686eefe00       mov byte ptr [bp - 0x112], 0
  072D6E  18DE: 8a5e98           mov bl, byte ptr [bp - 0x68]
  072D71  18E1: 2aff             sub bh, bh
  072D73  18E3: d1e3             shl bx, 1
  072D75  18E5: ffb79483         push word ptr [bx - 0x7c6c]
  072D79  18E9: 8d86eefe         lea ax, [bp - 0x112]
  072D7D  18ED: 50               push ax
  072D7E  18EE: 9a6e011f18       lcall 0x181f, 0x16e
  072D83  18F3: 83c404           add sp, 4
  072D86  18F6: 8d86eefe         lea ax, [bp - 0x112]
  072D8A  18FA: 50               push ax
  072D8B  18FB: 9a78011f18       lcall 0x181f, 0x178
  072D90  1900: 83c402           add sp, 2
  072D93  1903: 6bb6e6fe34       imul si, word ptr [bp - 0x11a], 0x34
  072D98  1908: 8d828cfd         lea ax, [bp + si - 0x274]
  072D9C  190C: 50               push ax
  072D9D  190D: 8d865cfe         lea ax, [bp - 0x1a4]
  072DA1  1911: 50               push ax
  072DA2  1912: 9ae4071d0d       lcall 0xd1d, 0x7e4
  072DA7  1917: 83c404           add sp, 4
  072DAA  191A: eb2e             jmp 0x194a
  072DAC  191C: ff36a008         push word ptr [0x8a0]
  072DB0  1920: ff369e08         push word ptr [0x89e]
  072DB4  1924: 8d865cfe         lea ax, [bp - 0x1a4]
  072DB8  1928: 16               push ss
  072DB9  1929: 50               push ax
  072DBA  192A: 2bc0             sub ax, ax
  072DBC  192C: 9a04021f18       lcall 0x181f, 0x204
  072DC1  1931: 3d6400           cmp ax, 0x64
  072DC4  1934: 7e25             jle 0x195b
  072DC6  1936: 8d865cfe         lea ax, [bp - 0x1a4]
  072DCA  193A: 50               push ax
  072DCB  193B: 9a42081d0d       lcall 0xd1d, 0x842
  072DD0  1940: 83c402           add sp, 2
  072DD3  1943: 8bf0             mov si, ax
  072DD5  1945: c6825bfe00       mov byte ptr [bp + si - 0x1a5], 0
  072DDA  194A: 8d865cfe         lea ax, [bp - 0x1a4]
  072DDE  194E: 50               push ax
  072DDF  194F: 9a42081d0d       lcall 0xd1d, 0x842
  072DE4  1954: 83c402           add sp, 2
  072DE7  1957: 0bc0             or ax, ax
  072DE9  1959: 75c1             jne 0x191c
  072DEB  195B: 8d865cfe         lea ax, [bp - 0x1a4]
  072DEF  195F: 50               push ax
  072DF0  1960: 8d86eefe         lea ax, [bp - 0x112]
  072DF4  1964: 50               push ax
  072DF5  1965: 9aa4071d0d       lcall 0xd1d, 0x7a4
  072DFA  196A: 83c404           add sp, 4
  072DFD  196D: 8d86eefe         lea ax, [bp - 0x112]
  072E01  1971: 50               push ax
  072E02  1972: 9a78011f18       lcall 0x181f, 0x178
  072E07  1977: 83c402           add sp, 2
  072E0A  197A: ff36e02d         push word ptr [0x2de0]
  072E0E  197E: 8d86eefe         lea ax, [bp - 0x112]
  072E12  1982: 50               push ax
  072E13  1983: 9a6e011f18       lcall 0x181f, 0x16e
  072E18  1988: 83c404           add sp, 4
  072E1B  198B: 8d86eefe         lea ax, [bp - 0x112]
  072E1F  198F: 50               push ax
  072E20  1990: 9a78011f18       lcall 0x181f, 0x178
  072E25  1995: 83c402           add sp, 2
  072E28  1998: 8b9ee6fe         mov bx, word ptr [bp - 0x11a]
  072E2C  199C: d1e3             shl bx, 1
  072E2E  199E: ffb70a8d         push word ptr [bx - 0x72f6]
  072E32  19A2: 8d86eefe         lea ax, [bp - 0x112]
  072E36  19A6: 50               push ax
  072E37  19A7: 9a6e011f18       lcall 0x181f, 0x16e
  072E3C  19AC: 83c404           add sp, 4
  072E3F  19AF: 8d86eefe         lea ax, [bp - 0x112]
  072E43  19B3: 50               push ax
  072E44  19B4: 9ab4011f18       lcall 0x181f, 0x1b4
  072E49  19B9: 83c402           add sp, 2
  072E4C  19BC: 8b9e7eff         mov bx, word ptr [bp - 0x82]
  072E50  19C0: d1e3             shl bx, 1
  072E52  19C2: ffb70098         push word ptr [bx - 0x6800]
  072E56  19C6: 9a22001f18       lcall 0x181f, 0x22
  072E5B  19CB: 83c402           add sp, 2
  072E5E  19CE: 52               push dx
  072E5F  19CF: 50               push ax
  072E60  19D0: 8d86eefe         lea ax, [bp - 0x112]
  072E64  19D4: 16               push ss
  072E65  19D5: 50               push ax
  072E66  19D6: 9ab4111d0d       lcall 0xd1d, 0x11b4
  072E6B  19DB: 83c408           add sp, 8
  072E6E  19DE: 8d86eefe         lea ax, [bp - 0x112]
  072E72  19E2: 50               push ax
  072E73  19E3: 9a78011f18       lcall 0x181f, 0x178
  072E78  19E8: 83c402           add sp, 2
  072E7B  19EB: ffb67cff         push word ptr [bp - 0x84]
  072E7F  19EF: 8d86eefe         lea ax, [bp - 0x112]
  072E83  19F3: 16               push ss
  072E84  19F4: 50               push ax
  072E85  19F5: 9a82011f18       lcall 0x181f, 0x182
  072E8A  19FA: 83c406           add sp, 6
  072E8D  19FD: 8b86e4fe         mov ax, word ptr [bp - 0x11c]
  072E91  1A01: 40               inc ax
  072E92  1A02: 50               push ax
  072E93  1A03: 8d86eefe         lea ax, [bp - 0x112]
  072E97  1A07: 16               push ss
  072E98  1A08: 50               push ax
  072E99  1A09: ffb6ecfe         push word ptr [bp - 0x114]
  072E9D  1A0D: ffb6eafe         push word ptr [bp - 0x116]
  072EA1  1A11: 9a76011f19       lcall 0x191f, 0x176
  072EA6  1A16: 83c40a           add sp, 0xa
  072EA9  1A19: ff36a01f         push word ptr [0x1fa0]
  072EAD  1A1D: ff369e1f         push word ptr [0x1f9e]
  072EB1  1A21: 8d86eefe         lea ax, [bp - 0x112]
  072EB5  1A25: 16               push ss
  072EB6  1A26: 50               push ax
  072EB7  1A27: b80100           mov ax, 1
  072EBA  1A2A: 9a04021f18       lcall 0x181f, 0x204
  072EBF  1A2F: 3d3001           cmp ax, 0x130
  072EC2  1A32: 7e06             jle 0x1a3a
  072EC4  1A34: c786e0fe0100     mov word ptr [bp - 0x120], 1
  072ECA  1A3A: ff86e4fe         inc word ptr [bp - 0x11c]
  072ECE  1A3E: 83bee0fe00       cmp word ptr [bp - 0x120], 0
  072ED3  1A43: 7553             jne 0x1a98
  072ED5  1A45: 8b4608           mov ax, word ptr [bp + 8]
  072ED8  1A48: 3986e4fe         cmp word ptr [bp - 0x11c], ax
  072EDC  1A4C: 7d4a             jge 0x1a98
  072EDE  1A4E: ffb6e4fe         push word ptr [bp - 0x11c]
  072EE2  1A52: 8d865cfe         lea ax, [bp - 0x1a4]
  072EE6  1A56: 50               push ax
  072EE7  1A57: 0e               push cs
  072EE8  1A58: e87b03           call 0x1dd6
  072EEB  1A5B: 83c404           add sp, 4
  072EEE  1A5E: 8d868cfd         lea ax, [bp - 0x274]
  072EF2  1A62: 50               push ax
  072EF3  1A63: 8d8672ff         lea ax, [bp - 0x8e]
  072EF7  1A67: 50               push ax
  072EF8  1A68: 8d865cfe         lea ax, [bp - 0x1a4]
  072EFC  1A6C: 50               push ax
  072EFD  1A6D: 9a040d1f1a       lcall 0x1a1f, 0xd04
  072F02  1A72: 83c406           add sp, 6
  072F05  1A75: 0bc0             or ax, ax
  072F07  1A77: 7503             jne 0x1a7c
  072F09  1A79: e912fe           jmp 0x188e
  072F0C  1A7C: 68ee20           push 0x20ee
  072F0F  1A7F: 8d86eefe         lea ax, [bp - 0x112]
  072F13  1A83: 50               push ax
  072F14  1A84: 9ae4071d0d       lcall 0xd1d, 0x7e4
  072F19  1A89: 83c404           add sp, 4
  072F1C  1A8C: 8b9ee4fe         mov bx, word ptr [bp - 0x11c]
  072F20  1A90: c6870ca600       mov byte ptr [bx - 0x59f4], 0
  072F25  1A95: e965ff           jmp 0x19fd
  072F28  1A98: 83bee0fe00       cmp word ptr [bp - 0x120], 0
  072F2D  1A9D: 7417             je 0x1ab6
  072F2F  1A9F: ffb6ecfe         push word ptr [bp - 0x114]
  072F33  1AA3: ffb6eafe         push word ptr [bp - 0x116]
  072F37  1AA7: 9aa8011f19       lcall 0x191f, 0x1a8
  072F3C  1AAC: 2bc0             sub ax, ax
  072F3E  1AAE: 8986ecfe         mov word ptr [bp - 0x114], ax
  072F42  1AB2: 8986eafe         mov word ptr [bp - 0x116], ax
  072F46  1AB6: ff86e2fe         inc word ptr [bp - 0x11e]
  072F4A  1ABA: 83bee0fe00       cmp word ptr [bp - 0x120], 0
  072F4F  1ABF: 740a             je 0x1acb
  072F51  1AC1: 83bee2fe01       cmp word ptr [bp - 0x11e], 1
  072F56  1AC6: 7f03             jg 0x1acb
  072F58  1AC8: e990fd           jmp 0x185b
  072F5B  1ACB: ff36a21f         push word ptr [0x1fa2]
  072F5F  1ACF: ff368c26         push word ptr [0x268c]
  072F63  1AD3: ff368a26         push word ptr [0x268a]
  072F67  1AD7: 9ac4071f1a       lcall 0x1a1f, 0x7c4
  072F6C  1ADC: 83c406           add sp, 6
  072F6F  1ADF: 8b86eafe         mov ax, word ptr [bp - 0x116]
  072F73  1AE3: 8b96ecfe         mov dx, word ptr [bp - 0x114]
  072F77  1AE7: 5e               pop si
  072F78  1AE8: c9               leave 
  072F79  1AE9: cb               retf 

; ---- func_072F7A  size=478  insns=166  prologue=ENTER 0x005C,0  terminal=RETF ----
  072F7A  1AEA: c85c0000         enter 0x5c, 0
  072F7E  1AEE: 6a08             push 8
  072F80  1AF0: 68f620           push 0x20f6
  072F83  1AF3: 0e               push cs
  072F84  1AF4: e8e402           call 0x1ddb
  072F87  1AF7: 83c404           add sp, 4
  072F8A  1AFA: 8946aa           mov word ptr [bp - 0x56], ax
  072F8D  1AFD: 8956ac           mov word ptr [bp - 0x54], dx
  072F90  1B00: 0bd0             or dx, ax
  072F92  1B02: 7503             jne 0x1b07
  072F94  1B04: e9ac01           jmp 0x1cb3
  072F97  1B07: ff76ac           push word ptr [bp - 0x54]
  072F9A  1B0A: 50               push ax
  072F9B  1B0B: 9a6a011f19       lcall 0x191f, 0x16a
  072FA0  1B10: 48               dec ax
  072FA1  1B11: 8946ae           mov word ptr [bp - 0x52], ax
  072FA4  1B14: 0bc0             or ax, ax
  072FA6  1B16: 7d03             jge 0x1b1b
  072FA8  1B18: e99801           jmp 0x1cb3
  072FAB  1B1B: ff76ac           push word ptr [bp - 0x54]
  072FAE  1B1E: ff76aa           push word ptr [bp - 0x56]
  072FB1  1B21: 9aa8011f19       lcall 0x191f, 0x1a8
  072FB6  1B26: 2bc0             sub ax, ax
  072FB8  1B28: 8946ac           mov word ptr [bp - 0x54], ax
  072FBB  1B2B: 8946aa           mov word ptr [bp - 0x56], ax
  072FBE  1B2E: ff76ae           push word ptr [bp - 0x52]
  072FC1  1B31: 8d46b0           lea ax, [bp - 0x50]
  072FC4  1B34: 50               push ax
  072FC5  1B35: 0e               push cs
  072FC6  1B36: e89d02           call 0x1dd6
  072FC9  1B39: 83c404           add sp, 4
  072FCC  1B3C: 8d46b0           lea ax, [bp - 0x50]
  072FCF  1B3F: 50               push ax
  072FD0  1B40: 9af60c1f1a       lcall 0x1a1f, 0xcf6
  072FD5  1B45: 83c402           add sp, 2
  072FD8  1B48: 8946a6           mov word ptr [bp - 0x5a], ax
  072FDB  1B4B: 8d46b0           lea ax, [bp - 0x50]
  072FDE  1B4E: 16               push ss
  072FDF  1B4F: 50               push ax
  072FE0  1B50: 1e               push ds
  072FE1  1B51: 68d29c           push 0x9cd2
  072FE4  1B54: 9a7e111d0d       lcall 0xd1d, 0x117e
  072FE9  1B59: 83c408           add sp, 8
  072FEC  1B5C: 837ea600         cmp word ptr [bp - 0x5a], 0
  072FF0  1B60: 7403             je 0x1b65
  072FF2  1B62: e92f01           jmp 0x1c94
  072FF5  1B65: c746a4ffff       mov word ptr [bp - 0x5c], 0xffff
  072FFA  1B6A: c746a80000       mov word ptr [bp - 0x58], 0
  072FFF  1B6F: eb1b             jmp 0x1b8c
  073001  1B71: 90               nop 
  073002  1B72: 837ea804         cmp word ptr [bp - 0x58], 4
  073006  1B76: 7d1a             jge 0x1b92
  073008  1B78: 6b5ea834         imul bx, word ptr [bp - 0x58], 0x34
  07300C  1B7C: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  073011  1B81: 7506             jne 0x1b89
  073013  1B83: 8b46a8           mov ax, word ptr [bp - 0x58]
  073016  1B86: 8946a4           mov word ptr [bp - 0x5c], ax
  073019  1B89: ff46a8           inc word ptr [bp - 0x58]
  07301C  1B8C: 837ea400         cmp word ptr [bp - 0x5c], 0
  073020  1B90: 7ce0             jl 0x1b72
  073022  1B92: 837ea400         cmp word ptr [bp - 0x5c], 0
  073026  1B96: 7d05             jge 0x1b9d
  073028  1B98: c746a40000       mov word ptr [bp - 0x5c], 0
  07302D  1B9D: c646b000         mov byte ptr [bp - 0x50], 0
  073031  1BA1: 8a1ea653         mov bl, byte ptr [0x53a6]
  073035  1BA5: 2aff             sub bh, bh
  073037  1BA7: d1e3             shl bx, 1
  073039  1BA9: ffb79483         push word ptr [bx - 0x7c6c]
  07303D  1BAD: 8d46b0           lea ax, [bp - 0x50]
  073040  1BB0: 50               push ax
  073041  1BB1: 9a6e011f18       lcall 0x181f, 0x16e
  073046  1BB6: 83c404           add sp, 4
  073049  1BB9: 8d46b0           lea ax, [bp - 0x50]
  07304C  1BBC: 50               push ax
  07304D  1BBD: 9a78011f18       lcall 0x181f, 0x178
  073052  1BC2: 83c402           add sp, 2
  073055  1BC5: 6b46a434         imul ax, word ptr [bp - 0x5c], 0x34
  073059  1BC9: 050e54           add ax, 0x540e
  07305C  1BCC: 1e               push ds
  07305D  1BCD: 50               push ax
  07305E  1BCE: 8d46b0           lea ax, [bp - 0x50]
  073061  1BD1: 16               push ss
  073062  1BD2: 50               push ax
  073063  1BD3: 9ab4111d0d       lcall 0xd1d, 0x11b4
  073068  1BD8: 83c408           add sp, 8
  07306B  1BDB: 8d46b0           lea ax, [bp - 0x50]
  07306E  1BDE: 50               push ax
  07306F  1BDF: 9a78011f18       lcall 0x181f, 0x178
  073074  1BE4: 83c402           add sp, 2
  073077  1BE7: ff36e02d         push word ptr [0x2de0]
  07307B  1BEB: 8d46b0           lea ax, [bp - 0x50]
  07307E  1BEE: 50               push ax
  07307F  1BEF: 9a6e011f18       lcall 0x181f, 0x16e
  073084  1BF4: 83c404           add sp, 4
  073087  1BF7: 8d46b0           lea ax, [bp - 0x50]
  07308A  1BFA: 50               push ax
  07308B  1BFB: 9a78011f18       lcall 0x181f, 0x178
  073090  1C00: 83c402           add sp, 2
  073093  1C03: 8b5ea4           mov bx, word ptr [bp - 0x5c]
  073096  1C06: d1e3             shl bx, 1
  073098  1C08: ffb70a8d         push word ptr [bx - 0x72f6]
  07309C  1C0C: 8d46b0           lea ax, [bp - 0x50]
  07309F  1C0F: 50               push ax
  0730A0  1C10: 9a6e011f18       lcall 0x181f, 0x16e
  0730A5  1C15: 83c404           add sp, 4
  0730A8  1C18: 8d46b0           lea ax, [bp - 0x50]
  0730AB  1C1B: 50               push ax
  0730AC  1C1C: 9a78011f18       lcall 0x181f, 0x178
  0730B1  1C21: 83c402           add sp, 2
  0730B4  1C24: 8d46b0           lea ax, [bp - 0x50]
  0730B7  1C27: 50               push ax
  0730B8  1C28: 9a1e011f18       lcall 0x181f, 0x11e
  0730BD  1C2D: 83c402           add sp, 2
  0730C0  1C30: 8b1e8c53         mov bx, word ptr [0x538c]
  0730C4  1C34: d1e3             shl bx, 1
  0730C6  1C36: ffb70098         push word ptr [bx - 0x6800]
  0730CA  1C3A: 9a22001f18       lcall 0x181f, 0x22
  0730CF  1C3F: 83c402           add sp, 2
  0730D2  1C42: 52               push dx
  0730D3  1C43: 50               push ax
  0730D4  1C44: 8d46b0           lea ax, [bp - 0x50]
  0730D7  1C47: 16               push ss
  0730D8  1C48: 50               push ax
  0730D9  1C49: 9ab4111d0d       lcall 0xd1d, 0x11b4
  0730DE  1C4E: 83c408           add sp, 8
  0730E1  1C51: 8d46b0           lea ax, [bp - 0x50]
  0730E4  1C54: 50               push ax
  0730E5  1C55: 9a78011f18       lcall 0x181f, 0x178
  0730EA  1C5A: 83c402           add sp, 2
  0730ED  1C5D: ff368a53         push word ptr [0x538a]
  0730F1  1C61: 8d46b0           lea ax, [bp - 0x50]
  0730F4  1C64: 16               push ss
  0730F5  1C65: 50               push ax
  0730F6  1C66: 9a82011f18       lcall 0x181f, 0x182
  0730FB  1C6B: 83c406           add sp, 6
  0730FE  1C6E: 8d46b0           lea ax, [bp - 0x50]
  073101  1C71: 50               push ax
  073102  1C72: 9a28011f18       lcall 0x181f, 0x128
  073107  1C77: 83c402           add sp, 2
  07310A  1C7A: 8d46b0           lea ax, [bp - 0x50]
  07310D  1C7D: 16               push ss
  07310E  1C7E: 50               push ax
  07310F  1C7F: 6a01             push 1
  073111  1C81: 9a16041f18       lcall 0x181f, 0x416
  073116  1C86: 83c406           add sp, 6
  073119  1C89: 8d1e7c08         lea bx, [0x87c]
  07311D  1C8D: 8d06ff20         lea ax, [0x20ff]
  073121  1C91: eb19             jmp 0x1cac
  073123  1C93: 90               nop 
  073124  1C94: 837ea602         cmp word ptr [bp - 0x5a], 2
  073128  1C98: 750a             jne 0x1ca4
  07312A  1C9A: 8d1e7c08         lea bx, [0x87c]
  07312E  1C9E: 8d060821         lea ax, [0x2108]
  073132  1CA2: eb08             jmp 0x1cac
  073134  1CA4: 8d1e7c08         lea bx, [0x87c]
  073138  1CA8: 8d061021         lea ax, [0x2110]
  07313C  1CAC: 2bd2             sub dx, dx
  07313E  1CAE: 9a98091f18       lcall 0x181f, 0x998
  073143  1CB3: 8b46ac           mov ax, word ptr [bp - 0x54]
  073146  1CB6: 0b46aa           or ax, word ptr [bp - 0x56]
  073149  1CB9: 740b             je 0x1cc6
  07314B  1CBB: ff76ac           push word ptr [bp - 0x54]
  07314E  1CBE: ff76aa           push word ptr [bp - 0x56]
  073151  1CC1: 9aa8011f19       lcall 0x191f, 0x1a8
  073156  1CC6: c9               leave 
  073157  1CC7: cb               retf 

; ---- func_073158  size=280  insns=99  prologue=ENTER 0x005A,0  terminal=JMP-tail ----
  073158  1CC8: c85a0000         enter 0x5a, 0
  07315C  1CCC: c746ac0100       mov word ptr [bp - 0x54], 1
  073161  1CD1: 6a0a             push 0xa
  073163  1CD3: 681a21           push 0x211a
  073166  1CD6: 0e               push cs
  073167  1CD7: e80101           call 0x1ddb
  07316A  1CDA: 83c404           add sp, 4
  07316D  1CDD: 8946a8           mov word ptr [bp - 0x58], ax
  073170  1CE0: 8956aa           mov word ptr [bp - 0x56], dx
  073173  1CE3: 0bd0             or dx, ax
  073175  1CE5: 7503             jne 0x1cea
  073177  1CE7: e9d400           jmp 0x1dbe
  07317A  1CEA: ff76aa           push word ptr [bp - 0x56]
  07317D  1CED: 50               push ax
  07317E  1CEE: 9a6a011f19       lcall 0x191f, 0x16a
  073183  1CF3: 48               dec ax
  073184  1CF4: 8946ae           mov word ptr [bp - 0x52], ax
  073187  1CF7: 0bc0             or ax, ax
  073189  1CF9: 7d03             jge 0x1cfe
  07318B  1CFB: e9c000           jmp 0x1dbe
  07318E  1CFE: 8bd8             mov bx, ax
  073190  1D00: 80bf0ca600       cmp byte ptr [bx - 0x59f4], 0
  073195  1D05: 7503             jne 0x1d0a
  073197  1D07: e9b400           jmp 0x1dbe
  07319A  1D0A: ff76aa           push word ptr [bp - 0x56]
  07319D  1D0D: ff76a8           push word ptr [bp - 0x58]
  0731A0  1D10: 9aa8011f19       lcall 0x191f, 0x1a8
  0731A5  1D15: 2bc0             sub ax, ax
  0731A7  1D17: 8946aa           mov word ptr [bp - 0x56], ax
  0731AA  1D1A: 8946a8           mov word ptr [bp - 0x58], ax
  0731AD  1D1D: ff76ae           push word ptr [bp - 0x52]
  0731B0  1D20: 8d46b0           lea ax, [bp - 0x50]
  0731B3  1D23: 50               push ax
  0731B4  1D24: 0e               push cs
  0731B5  1D25: e8ae00           call 0x1dd6
  0731B8  1D28: 83c404           add sp, 4
  0731BB  1D2B: 8d46b0           lea ax, [bp - 0x50]
  0731BE  1D2E: 50               push ax
  0731BF  1D2F: 9a120d1f1a       lcall 0x1a1f, 0xd12
  0731C4  1D34: 83c402           add sp, 2
  0731C7  1D37: 8946a6           mov word ptr [bp - 0x5a], ax
  0731CA  1D3A: 8d46b0           lea ax, [bp - 0x50]
  0731CD  1D3D: 16               push ss
  0731CE  1D3E: 50               push ax
  0731CF  1D3F: 1e               push ds
  0731D0  1D40: 68d29c           push 0x9cd2
  0731D3  1D43: 9a7e111d0d       lcall 0xd1d, 0x117e
  0731D8  1D48: 83c408           add sp, 8
  0731DB  1D4B: 837ea600         cmp word ptr [bp - 0x5a], 0
  0731DF  1D4F: 7517             jne 0x1d68
  0731E1  1D51: 8d1e7c08         lea bx, [0x87c]
  0731E5  1D55: 8d062321         lea ax, [0x2123]
  0731E9  1D59: 2bd2             sub dx, dx
  0731EB  1D5B: 9a98091f18       lcall 0x181f, 0x998
  0731F0  1D60: c746ac0000       mov word ptr [bp - 0x54], 0
  0731F5  1D65: eb57             jmp 0x1dbe
  0731F7  1D67: 90               nop 
  0731F8  1D68: 8b46a6           mov ax, word ptr [bp - 0x5a]
  0731FB  1D6B: 48               dec ax
  0731FC  1D6C: 48               dec ax
  0731FD  1D6D: 740b             je 0x1d7a
  0731FF  1D6F: 48               dec ax
  073200  1D70: 741a             je 0x1d8c
  073202  1D72: 48               dec ax
  073203  1D73: 7421             je 0x1d96
  073205  1D75: 48               dec ax
  073206  1D76: 7428             je 0x1da0
  073208  1D78: eb30             jmp 0x1daa
  07320A  1D7A: 8d1e7c08         lea bx, [0x87c]
  07320E  1D7E: 8d062c21         lea ax, [0x212c]
  073212  1D82: 2bd2             sub dx, dx
  073214  1D84: 9a98091f18       lcall 0x181f, 0x998
  073219  1D89: eb33             jmp 0x1dbe
  07321B  1D8B: 90               nop 
  07321C  1D8C: 8d1e7c08         lea bx, [0x87c]
  073220  1D90: 8d063421         lea ax, [0x2134]
  073224  1D94: ebec             jmp 0x1d82
  073226  1D96: 8d1e7c08         lea bx, [0x87c]
  07322A  1D9A: 8d063c21         lea ax, [0x213c]
  07322E  1D9E: ebe2             jmp 0x1d82
  073230  1DA0: 8d1e7c08         lea bx, [0x87c]
  073234  1DA4: 8d064521         lea ax, [0x2145]
  073238  1DA8: ebd8             jmp 0x1d82
  07323A  1DAA: 8d1e7c08         lea bx, [0x87c]
  07323E  1DAE: 8d064d21         lea ax, [0x214d]
  073242  1DB2: 2bd2             sub dx, dx
  073244  1DB4: 9a98091f18       lcall 0x181f, 0x998
  073249  1DB9: c746ac0200       mov word ptr [bp - 0x54], 2
  07324E  1DBE: 8b46aa           mov ax, word ptr [bp - 0x56]
  073251  1DC1: 0b46a8           or ax, word ptr [bp - 0x58]
  073254  1DC4: 740b             je 0x1dd1
  073256  1DC6: ff76aa           push word ptr [bp - 0x56]
  073259  1DC9: ff76a8           push word ptr [bp - 0x58]
  07325C  1DCC: 9aa8011f19       lcall 0x191f, 0x1a8
  073261  1DD1: 8b46ac           mov ax, word ptr [bp - 0x54]
  073264  1DD4: c9               leave 
  073265  1DD5: cb               retf 
  073266  1DD6: eada0c1f1a       ljmp 0x1a1f:0xcda
  07326B  1DDB: eae80c1f1a       ljmp 0x1a1f:0xce8

; ---- func_073270  size=648  insns=239  prologue=ENTER 0x00C4,0  terminal=RETF ----
  073270  1DE0: c8c40000         enter 0xc4, 0
  073274  1DE4: 57               push di
  073275  1DE5: 56               push si
  073276  1DE6: c746f0ffff       mov word ptr [bp - 0x10], 0xffff
  07327B  1DEB: 2bc0             sub ax, ax
  07327D  1DED: 8946ec           mov word ptr [bp - 0x14], ax
  073280  1DF0: 8946ea           mov word ptr [bp - 0x16], ax
  073283  1DF3: 8946f6           mov word ptr [bp - 0xa], ax
  073286  1DF6: 8946fe           mov word ptr [bp - 2], ax
  073289  1DF9: 8d46be           lea ax, [bp - 0x42]
  07328C  1DFC: 50               push ax
  07328D  1DFD: 6a00             push 0
  07328F  1DFF: ff760a           push word ptr [bp + 0xa]
  073292  1E02: 9a630e1d0d       lcall 0xd1d, 0xe63
  073297  1E07: 83c406           add sp, 6
  07329A  1E0A: 0bc0             or ax, ax
  07329C  1E0C: 7403             je 0x1e11
  07329E  1E0E: e9af00           jmp 0x1ec0
  0732A1  1E11: 8b76fe           mov si, word ptr [bp - 2]
  0732A4  1E14: 46               inc si
  0732A5  1E15: 8d46be           lea ax, [bp - 0x42]
  0732A8  1E18: 50               push ax
  0732A9  1E19: 9a580e1d0d       lcall 0xd1d, 0xe58
  0732AE  1E1E: 83c402           add sp, 2
  0732B1  1E21: 0bc0             or ax, ax
  0732B3  1E23: 74ef             je 0x1e14
  0732B5  1E25: 0bf6             or si, si
  0732B7  1E27: 7503             jne 0x1e2c
  0732B9  1E29: e9b900           jmp 0x1ee5
  0732BC  1E2C: 8d4409           lea ax, [si + 9]
  0732BF  1E2F: b90a00           mov cx, 0xa
  0732C2  1E32: 99               cdq 
  0732C3  1E33: f7f9             idiv cx
  0732C5  1E35: 8946ee           mov word ptr [bp - 0x12], ax
  0732C8  1E38: c746feffff       mov word ptr [bp - 2], 0xffff
  0732CD  1E3D: c746fa0000       mov word ptr [bp - 6], 0
  0732D2  1E42: 8b76f6           mov si, word ptr [bp - 0xa]
  0732D5  1E45: 8bc6             mov ax, si
  0732D7  1E47: c1e602           shl si, 2
  0732DA  1E4A: 03f0             add si, ax
  0732DC  1E4C: d1e6             shl si, 1
  0732DE  1E4E: 8d4409           lea ax, [si + 9]
  0732E1  1E51: 8946fc           mov word ptr [bp - 4], ax
  0732E4  1E54: 8d46be           lea ax, [bp - 0x42]
  0732E7  1E57: 50               push ax
  0732E8  1E58: 6a00             push 0
  0732EA  1E5A: ff760a           push word ptr [bp + 0xa]
  0732ED  1E5D: 9a630e1d0d       lcall 0xd1d, 0xe63
  0732F2  1E62: 83c406           add sp, 6
  0732F5  1E65: 0bc0             or ax, ax
  0732F7  1E67: 755d             jne 0x1ec6
  0732F9  1E69: 8976f8           mov word ptr [bp - 8], si
  0732FC  1E6C: 8b76fa           mov si, word ptr [bp - 6]
  0732FF  1E6F: 8b7efe           mov di, word ptr [bp - 2]
  073302  1E72: 47               inc di
  073303  1E73: 397ef8           cmp word ptr [bp - 8], di
  073306  1E76: 7f26             jg 0x1e9e
  073308  1E78: 397efc           cmp word ptr [bp - 4], di
  07330B  1E7B: 7c21             jl 0x1e9e
  07330D  1E7D: 8d46dc           lea ax, [bp - 0x24]
  073310  1E80: 50               push ax
  073311  1E81: 8bc6             mov ax, si
  073313  1E83: 46               inc si
  073314  1E84: 8bc8             mov cx, ax
  073316  1E86: d1e0             shl ax, 1
  073318  1E88: 03c1             add ax, cx
  07331A  1E8A: c1e002           shl ax, 2
  07331D  1E8D: 03c1             add ax, cx
  07331F  1E8F: 8d8e3cff         lea cx, [bp - 0xc4]
  073323  1E93: 03c1             add ax, cx
  073325  1E95: 50               push ax
  073326  1E96: 9ae4071d0d       lcall 0xd1d, 0x7e4
  07332B  1E9B: 83c404           add sp, 4
  07332E  1E9E: 8d46be           lea ax, [bp - 0x42]
  073331  1EA1: 50               push ax
  073332  1EA2: 9a580e1d0d       lcall 0xd1d, 0xe58
  073337  1EA7: 83c402           add sp, 2
  07333A  1EAA: 0bc0             or ax, ax
  07333C  1EAC: 7505             jne 0x1eb3
  07333E  1EAE: 83fe0a           cmp si, 0xa
  073341  1EB1: 7cbf             jl 0x1e72
  073343  1EB3: 0bf6             or si, si
  073345  1EB5: 7515             jne 0x1ecc
  073347  1EB7: 8976fe           mov word ptr [bp - 2], si
  07334A  1EBA: 8b7eea           mov di, word ptr [bp - 0x16]
  07334D  1EBD: e9d900           jmp 0x1f99
  073350  1EC0: 8b76fe           mov si, word ptr [bp - 2]
  073353  1EC3: e95fff           jmp 0x1e25
  073356  1EC6: 8b76fa           mov si, word ptr [bp - 6]
  073359  1EC9: ebe8             jmp 0x1eb3
  07335B  1ECB: 90               nop 
  07335C  1ECC: 8b5e06           mov bx, word ptr [bp + 6]
  07335F  1ECF: 8b4608           mov ax, word ptr [bp + 8]
  073362  1ED2: 2bd2             sub dx, dx
  073364  1ED4: 9a82011f19       lcall 0x191f, 0x182
  073369  1ED9: 8bf8             mov di, ax
  07336B  1EDB: 8956ec           mov word ptr [bp - 0x14], dx
  07336E  1EDE: 0bd0             or dx, ax
  073370  1EE0: 750a             jne 0x1eec
  073372  1EE2: 897eea           mov word ptr [bp - 0x16], di
  073375  1EE5: 8b76ea           mov si, word ptr [bp - 0x16]
  073378  1EE8: e9e000           jmp 0x1fcb
  07337B  1EEB: 90               nop 
  07337C  1EEC: 837ef600         cmp word ptr [bp - 0xa], 0
  073380  1EF0: 7412             je 0x1f04
  073382  1EF2: 6a62             push 0x62
  073384  1EF4: 1e               push ds
  073385  1EF5: 685821           push 0x2158
  073388  1EF8: ff76ec           push word ptr [bp - 0x14]
  07338B  1EFB: 57               push di
  07338C  1EFC: 9a76011f19       lcall 0x191f, 0x176
  073391  1F01: 83c40a           add sp, 0xa
  073394  1F04: 2bd2             sub dx, dx
  073396  1F06: 0bf6             or si, si
  073398  1F08: 7e38             jle 0x1f42
  07339A  1F0A: 8976fa           mov word ptr [bp - 6], si
  07339D  1F0D: 897eea           mov word ptr [bp - 0x16], di
  0733A0  1F10: 8d8e3cff         lea cx, [bp - 0xc4]
  0733A4  1F14: 894efe           mov word ptr [bp - 2], cx
  0733A7  1F17: 8956fc           mov word ptr [bp - 4], dx
  0733AA  1F1A: 8bfa             mov di, dx
  0733AC  1F1C: 8bf1             mov si, cx
  0733AE  1F1E: 8d4501           lea ax, [di + 1]
  0733B1  1F21: 50               push ax
  0733B2  1F22: 16               push ss
  0733B3  1F23: 56               push si
  0733B4  1F24: ff76ec           push word ptr [bp - 0x14]
  0733B7  1F27: ff76ea           push word ptr [bp - 0x16]
  0733BA  1F2A: 9a76011f19       lcall 0x191f, 0x176
  0733BF  1F2F: 83c40a           add sp, 0xa
  0733C2  1F32: 83c60d           add si, 0xd
  0733C5  1F35: 8d4501           lea ax, [di + 1]
  0733C8  1F38: 8bf8             mov di, ax
  0733CA  1F3A: 3b7efa           cmp di, word ptr [bp - 6]
  0733CD  1F3D: 7cdf             jl 0x1f1e
  0733CF  1F3F: 8b7eea           mov di, word ptr [bp - 0x16]
  0733D2  1F42: 8b46ee           mov ax, word ptr [bp - 0x12]
  0733D5  1F45: 48               dec ax
  0733D6  1F46: 3b46f6           cmp ax, word ptr [bp - 0xa]
  0733D9  1F49: 7e12             jle 0x1f5d
  0733DB  1F4B: 6a63             push 0x63
  0733DD  1F4D: 1e               push ds
  0733DE  1F4E: 685f21           push 0x215f
  0733E1  1F51: ff76ec           push word ptr [bp - 0x14]
  0733E4  1F54: 57               push di
  0733E5  1F55: 9a76011f19       lcall 0x191f, 0x176
  0733EA  1F5A: 83c40a           add sp, 0xa
  0733ED  1F5D: c746fe0000       mov word ptr [bp - 2], 0
  0733F2  1F62: ff76ec           push word ptr [bp - 0x14]
  0733F5  1F65: 57               push di
  0733F6  1F66: 9a6a011f19       lcall 0x191f, 0x16a
  0733FB  1F6B: 48               dec ax
  0733FC  1F6C: 8946f0           mov word ptr [bp - 0x10], ax
  0733FF  1F6F: 3d6100           cmp ax, 0x61
  073402  1F72: 750a             jne 0x1f7e
  073404  1F74: ff4ef6           dec word ptr [bp - 0xa]
  073407  1F77: c746fe0100       mov word ptr [bp - 2], 1
  07340C  1F7C: eb0a             jmp 0x1f88
  07340E  1F7E: 3d6200           cmp ax, 0x62
  073411  1F81: 7505             jne 0x1f88
  073413  1F83: ff46f6           inc word ptr [bp - 0xa]
  073416  1F86: ebef             jmp 0x1f77
  073418  1F88: ff76ec           push word ptr [bp - 0x14]
  07341B  1F8B: 57               push di
  07341C  1F8C: 9aa8011f19       lcall 0x191f, 0x1a8
  073421  1F91: 2bc0             sub ax, ax
  073423  1F93: 99               cdq 
  073424  1F94: 8bf8             mov di, ax
  073426  1F96: 8956ec           mov word ptr [bp - 0x14], dx
  073429  1F99: 897eea           mov word ptr [bp - 0x16], di
  07342C  1F9C: 837efe00         cmp word ptr [bp - 2], 0
  073430  1FA0: 7403             je 0x1fa5
  073432  1FA2: e993fe           jmp 0x1e38
  073435  1FA5: 8bf7             mov si, di
  073437  1FA7: 837ef000         cmp word ptr [bp - 0x10], 0
  07343B  1FAB: 7c1e             jl 0x1fcb
  07343D  1FAD: 8b7ef0           mov di, word ptr [bp - 0x10]
  073440  1FB0: 8bc7             mov ax, di
  073442  1FB2: d1e7             shl di, 1
  073444  1FB4: 03f8             add di, ax
  073446  1FB6: c1e702           shl di, 2
  073449  1FB9: 03f8             add di, ax
  07344B  1FBB: 8d833cff         lea ax, [bp + di - 0xc4]
  07344F  1FBF: 50               push ax
  073450  1FC0: ff760c           push word ptr [bp + 0xc]
  073453  1FC3: 9ae4071d0d       lcall 0xd1d, 0x7e4
  073458  1FC8: 83c404           add sp, 4
  07345B  1FCB: 8b46ec           mov ax, word ptr [bp - 0x14]
  07345E  1FCE: 0bc6             or ax, si
  073460  1FD0: 740a             je 0x1fdc
  073462  1FD2: 8b46ec           mov ax, word ptr [bp - 0x14]
  073465  1FD5: 50               push ax
  073466  1FD6: 56               push si
  073467  1FD7: 9aa8011f19       lcall 0x191f, 0x1a8
  07346C  1FDC: 8b46f0           mov ax, word ptr [bp - 0x10]
  07346F  1FDF: 5e               pop si
  073470  1FE0: 5f               pop di
  073471  1FE1: c9               leave 
  073472  1FE2: cb               retf 
  073473  1FE3: 90               nop 
  073474  1FE4: a03308           mov al, byte ptr [0x833]
  073477  1FE7: 2ae4             sub ah, ah
  073479  1FE9: a3501f           mov word ptr [0x1f50], ax
  07347C  1FEC: a03408           mov al, byte ptr [0x834]
  07347F  1FEF: a3521f           mov word ptr [0x1f52], ax
  073482  1FF2: a03008           mov al, byte ptr [0x830]
  073485  1FF5: a34a1f           mov word ptr [0x1f4a], ax
  073488  1FF8: a03108           mov al, byte ptr [0x831]
  07348B  1FFB: a34e1f           mov word ptr [0x1f4e], ax
  07348E  1FFE: a03208           mov al, byte ptr [0x832]
  073491  2001: a34c1f           mov word ptr [0x1f4c], ax
  073494  2004: a03508           mov al, byte ptr [0x835]
  073497  2007: a3421f           mov word ptr [0x1f42], ax
  07349A  200A: a3401f           mov word ptr [0x1f40], ax
  07349D  200D: a03708           mov al, byte ptr [0x837]
  0734A0  2010: a3441f           mov word ptr [0x1f44], ax
  0734A3  2013: a03808           mov al, byte ptr [0x838]
  0734A6  2016: a3461f           mov word ptr [0x1f46], ax
  0734A9  2019: a03908           mov al, byte ptr [0x839]
  0734AC  201C: a3481f           mov word ptr [0x1f48], ax
  0734AF  201F: c7066c1ff093     mov word ptr [0x1f6c], 0x93f0
  0734B5  2025: c706641f0100     mov word ptr [0x1f64], 1
  0734BB  202B: cb               retf 
  0734BC  202C: c7064a1ffe00     mov word ptr [0x1f4a], 0xfe
  0734C2  2032: c7064e1ffc00     mov word ptr [0x1f4e], 0xfc
  0734C8  2038: c7064c1f0800     mov word ptr [0x1f4c], 8
  0734CE  203E: c706441f2e00     mov word ptr [0x1f44], 0x2e
  0734D4  2044: b8fd00           mov ax, 0xfd
  0734D7  2047: a3501f           mov word ptr [0x1f50], ax
  0734DA  204A: a3461f           mov word ptr [0x1f46], ax
  0734DD  204D: b83700           mov ax, 0x37
  0734E0  2050: a3421f           mov word ptr [0x1f42], ax
  0734E3  2053: a3401f           mov word ptr [0x1f40], ax
  0734E6  2056: a3481f           mov word ptr [0x1f48], ax
  0734E9  2059: c7066c1f0094     mov word ptr [0x1f6c], 0x9400
  0734EF  205F: 2bc0             sub ax, ax
  0734F1  2061: a3521f           mov word ptr [0x1f52], ax
  0734F4  2064: a3641f           mov word ptr [0x1f64], ax
  0734F7  2067: cb               retf 

; ---- func_0734F8  size=1464  insns=564  prologue=ENTER 0x0006,0  terminal=RETF ----
  0734F8  2068: c8060000         enter 6, 0
  0734FC  206C: 57               push di
  0734FD  206D: 56               push si
  0734FE  206E: bf0100           mov di, 1
  073501  2071: 833e5a0100       cmp word ptr [0x15a], 0
  073506  2076: 7403             je 0x207b
  073508  2078: bf0200           mov di, 2
  07350B  207B: 687621           push 0x2176
  07350E  207E: ff7606           push word ptr [bp + 6]
  073511  2081: 9ada041d0d       lcall 0xd1d, 0x4da
  073516  2086: 83c404           add sp, 4
  073519  2089: 8bf0             mov si, ax
  07351B  208B: 0bf6             or si, si
  07351D  208D: 7503             jne 0x2092
  07351F  208F: e96c05           jmp 0x25fe
  073522  2092: 8d1e7a21         lea bx, [0x217a]
  073526  2096: 8bc6             mov ax, si
  073528  2098: 9ae40d1f1a       lcall 0x1a1f, 0xde4
  07352D  209D: a11a08           mov ax, word ptr [0x81a]
  073530  20A0: 8946fe           mov word ptr [bp - 2], ax
  073533  20A3: 56               push si
  073534  20A4: 6a01             push 1
  073536  20A6: 6a02             push 2
  073538  20A8: 8d46fe           lea ax, [bp - 2]
  07353B  20AB: 50               push ax
  07353C  20AC: 9a0c061d0d       lcall 0xd1d, 0x60c
  073541  20B1: 83c408           add sp, 8
  073544  20B4: 0bc0             or ax, ax
  073546  20B6: 7503             jne 0x20bb
  073548  20B8: e94305           jmp 0x25fe
  07354B  20BB: 56               push si
  07354C  20BC: 6a01             push 1
  07354E  20BE: 6a04             push 4
  073550  20C0: 683a85           push 0x853a
  073553  20C3: 9a0c061d0d       lcall 0xd1d, 0x60c
  073558  20C8: 83c408           add sp, 8
  07355B  20CB: 0bc0             or ax, ax
  07355D  20CD: 7503             jne 0x20d2
  07355F  20CF: e92c05           jmp 0x25fe
  073562  20D2: 56               push si
  073563  20D3: 6a01             push 1
  073565  20D5: 688e00           push 0x8e
  073568  20D8: 688053           push 0x5380
  07356B  20DB: 9a0c061d0d       lcall 0xd1d, 0x60c
  073570  20E0: 83c408           add sp, 8
  073573  20E3: 0bc0             or ax, ax
  073575  20E5: 7503             jne 0x20ea
  073577  20E7: e91405           jmp 0x25fe
  07357A  20EA: 56               push si
  07357B  20EB: 6a01             push 1
  07357D  20ED: 68d000           push 0xd0
  073580  20F0: 680e54           push 0x540e
  073583  20F3: 9a0c061d0d       lcall 0xd1d, 0x60c
  073588  20F8: 83c408           add sp, 8
  07358B  20FB: 0bc0             or ax, ax
  07358D  20FD: 7503             jne 0x2102
  07358F  20FF: e9fc04           jmp 0x25fe
  073592  2102: 56               push si
  073593  2103: 6a01             push 1
  073595  2105: 6a18             push 0x18
  073597  2107: 688e94           push 0x948e
  07359A  210A: 9a0c061d0d       lcall 0xd1d, 0x60c
  07359F  210F: 83c408           add sp, 8
  0735A2  2112: 0bc0             or ax, ax
  0735A4  2114: 7503             jne 0x2119
  0735A6  2116: e9e504           jmp 0x25fe
  0735A9  2119: 833e9e5300       cmp word ptr [0x539e], 0
  0735AE  211E: 741c             je 0x213c
  0735B0  2120: 56               push si
  0735B1  2121: 6a01             push 1
  0735B3  2123: 69069e53ca00     imul ax, word ptr [0x539e], 0xca
  0735B9  2129: 50               push ax
  0735BA  212A: 68465d           push 0x5d46
  0735BD  212D: 9a0c061d0d       lcall 0xd1d, 0x60c
  0735C2  2132: 83c408           add sp, 8
  0735C5  2135: 0bc0             or ax, ax
  0735C7  2137: 7503             jne 0x213c
  0735C9  2139: e9c204           jmp 0x25fe
  0735CC  213C: 833e9c5300       cmp word ptr [0x539c], 0
  0735D1  2141: 741b             je 0x215e
  0735D3  2143: 56               push si
  0735D4  2144: 6a01             push 1
  0735D6  2146: 6b069c531c       imul ax, word ptr [0x539c], 0x1c
  0735DB  214B: 50               push ax
  0735DC  214C: 684431           push 0x3144
  0735DF  214F: 9a0c061d0d       lcall 0xd1d, 0x60c
  0735E4  2154: 83c408           add sp, 8
  0735E7  2157: 0bc0             or ax, ax
  0735E9  2159: 7503             jne 0x215e
  0735EB  215B: e9a004           jmp 0x25fe
  0735EE  215E: 56               push si
  0735EF  215F: 6a01             push 1
  0735F1  2161: 68f004           push 0x4f0
  0735F4  2164: 680888           push 0x8808
  0735F7  2167: 9a0c061d0d       lcall 0xd1d, 0x60c
  0735FC  216C: 83c408           add sp, 8
  0735FF  216F: 0bc0             or ax, ax
  073601  2171: 7503             jne 0x2176
  073603  2173: e98804           jmp 0x25fe
  073606  2176: 833e9a5300       cmp word ptr [0x539a], 0
  07360B  217B: 741b             je 0x2198
  07360D  217D: 56               push si
  07360E  217E: 6a01             push 1
  073610  2180: 6b069a5312       imul ax, word ptr [0x539a], 0x12
  073615  2185: 50               push ax
  073616  2186: 68ec54           push 0x54ec
  073619  2189: 9a0c061d0d       lcall 0xd1d, 0x60c
  07361E  218E: 83c408           add sp, 8
  073621  2191: 0bc0             or ax, ax
  073623  2193: 7503             jne 0x2198
  073625  2195: e96604           jmp 0x25fe
  073628  2198: 56               push si
  073629  2199: 6a01             push 1
  07362B  219B: 687002           push 0x270
  07362E  219E: 68d65a           push 0x5ad6
  073631  21A1: 9a0c061d0d       lcall 0xd1d, 0x60c
  073636  21A6: 83c408           add sp, 8
  073639  21A9: 0bc0             or ax, ax
  07363B  21AB: 7503             jne 0x21b0
  07363D  21AD: e94e04           jmp 0x25fe
  073640  21B0: 56               push si
  073641  21B1: 6a01             push 1
  073643  21B3: 6a0c             push 0xc
  073645  21B5: 686695           push 0x9566
  073648  21B8: 9a0c061d0d       lcall 0xd1d, 0x60c
  07364D  21BD: 83c408           add sp, 8
  073650  21C0: 0bc0             or ax, ax
  073652  21C2: 7503             jne 0x21c7
  073654  21C4: e93704           jmp 0x25fe
  073657  21C7: 56               push si
  073658  21C8: 6a01             push 1
  07365A  21CA: 6a04             push 4
  07365C  21CC: 68fc8c           push 0x8cfc
  07365F  21CF: 9a0c061d0d       lcall 0xd1d, 0x60c
  073664  21D4: 83c408           add sp, 8
  073667  21D7: 0bc0             or ax, ax
  073669  21D9: 7503             jne 0x21de
  07366B  21DB: e92004           jmp 0x25fe
  07366E  21DE: 56               push si
  07366F  21DF: 6a01             push 1
  073671  21E1: 6a04             push 4
  073673  21E3: 689892           push 0x9298
  073676  21E6: 9a0c061d0d       lcall 0xd1d, 0x60c
  07367B  21EB: 83c408           add sp, 8
  07367E  21EE: 0bc0             or ax, ax
  073680  21F0: 7503             jne 0x21f5
  073682  21F2: e90904           jmp 0x25fe
  073685  21F5: 56               push si
  073686  21F6: 6a01             push 1
  073688  21F8: 6a04             push 4
  07368A  21FA: 680894           push 0x9408
  07368D  21FD: 9a0c061d0d       lcall 0xd1d, 0x60c
  073692  2202: 83c408           add sp, 8
  073695  2205: 0bc0             or ax, ax
  073697  2207: 7503             jne 0x220c
  073699  2209: e9f203           jmp 0x25fe
  07369C  220C: 56               push si
  07369D  220D: 6a01             push 1
  07369F  220F: 6a04             push 4
  0736A1  2211: 680c94           push 0x940c
  0736A4  2214: 9a0c061d0d       lcall 0xd1d, 0x60c
  0736A9  2219: 83c408           add sp, 8
  0736AC  221C: 0bc0             or ax, ax
  0736AE  221E: 7503             jne 0x2223
  0736B0  2220: e9db03           jmp 0x25fe
  0736B3  2223: 56               push si
  0736B4  2224: 6a01             push 1
  0736B6  2226: 6a04             push 4
  0736B8  2228: 681094           push 0x9410
  0736BB  222B: 9a0c061d0d       lcall 0xd1d, 0x60c
  0736C0  2230: 83c408           add sp, 8
  0736C3  2233: 0bc0             or ax, ax
  0736C5  2235: 7503             jne 0x223a
  0736C7  2237: e9c403           jmp 0x25fe
  0736CA  223A: 56               push si
  0736CB  223B: 6a01             push 1
  0736CD  223D: 6a04             push 4
  0736CF  223F: 688091           push 0x9180
  0736D2  2242: 9a0c061d0d       lcall 0xd1d, 0x60c
  0736D7  2247: 83c408           add sp, 8
  0736DA  224A: 0bc0             or ax, ax
  0736DC  224C: 7503             jne 0x2251
  0736DE  224E: e9ad03           jmp 0x25fe
  0736E1  2251: 56               push si
  0736E2  2252: 6a01             push 1
  0736E4  2254: 6a04             push 4
  0736E6  2256: 681494           push 0x9414
  0736E9  2259: 9a0c061d0d       lcall 0xd1d, 0x60c
  0736EE  225E: 83c408           add sp, 8
  0736F1  2261: 0bc0             or ax, ax
  0736F3  2263: 7503             jne 0x2268
  0736F5  2265: e99603           jmp 0x25fe
  0736F8  2268: 56               push si
  0736F9  2269: 6a01             push 1
  0736FB  226B: 6a04             push 4
  0736FD  226D: 681894           push 0x9418
  073700  2270: 9a0c061d0d       lcall 0xd1d, 0x60c
  073705  2275: 83c408           add sp, 8
  073708  2278: 0bc0             or ax, ax
  07370A  227A: 7503             jne 0x227f
  07370C  227C: e97f03           jmp 0x25fe
  07370F  227F: 56               push si
  073710  2280: 6a01             push 1
  073712  2282: 6a08             push 8
  073714  2284: 681c94           push 0x941c
  073717  2287: 9a0c061d0d       lcall 0xd1d, 0x60c
  07371C  228C: 83c408           add sp, 8
  07371F  228F: 0bc0             or ax, ax
  073721  2291: 7503             jne 0x2296
  073723  2293: e96803           jmp 0x25fe
  073726  2296: 56               push si
  073727  2297: 6a01             push 1
  073729  2299: 6a04             push 4
  07372B  229B: 682494           push 0x9424
  07372E  229E: 9a0c061d0d       lcall 0xd1d, 0x60c
  073733  22A3: 83c408           add sp, 8
  073736  22A6: 0bc0             or ax, ax
  073738  22A8: 7503             jne 0x22ad
  07373A  22AA: e95103           jmp 0x25fe
  07373D  22AD: 56               push si
  07373E  22AE: 6a01             push 1
  073740  22B0: 6a04             push 4
  073742  22B2: 682894           push 0x9428
  073745  22B5: 9a0c061d0d       lcall 0xd1d, 0x60c
  07374A  22BA: 83c408           add sp, 8
  07374D  22BD: 0bc0             or ax, ax
  07374F  22BF: 7503             jne 0x22c4
  073751  22C1: e93a03           jmp 0x25fe
  073754  22C4: 56               push si
  073755  22C5: 6a01             push 1
  073757  22C7: 6a04             push 4
  073759  22C9: 682c94           push 0x942c
  07375C  22CC: 9a0c061d0d       lcall 0xd1d, 0x60c
  073761  22D1: 83c408           add sp, 8
  073764  22D4: 0bc0             or ax, ax
  073766  22D6: 7503             jne 0x22db
  073768  22D8: e92303           jmp 0x25fe
  07376B  22DB: 56               push si
  07376C  22DC: 6a01             push 1
  07376E  22DE: 6a4c             push 0x4c
  073770  22E0: 684c92           push 0x924c
  073773  22E3: 9a0c061d0d       lcall 0xd1d, 0x60c
  073778  22E8: 83c408           add sp, 8
  07377B  22EB: 0bc0             or ax, ax
  07377D  22ED: 7503             jne 0x22f2
  07377F  22EF: e90c03           jmp 0x25fe
  073782  22F2: 56               push si
  073783  22F3: 6a01             push 1
  073785  22F5: 6a10             push 0x10
  073787  22F7: 687e94           push 0x947e
  07378A  22FA: 9a0c061d0d       lcall 0xd1d, 0x60c
  07378F  22FF: 83c408           add sp, 8
  073792  2302: 0bc0             or ax, ax
  073794  2304: 7503             jne 0x2309
  073796  2306: e9f502           jmp 0x25fe
  073799  2309: 56               push si
  07379A  230A: 6a01             push 1
  07379C  230C: 6a10             push 0x10
  07379E  230E: 68f295           push 0x95f2
  0737A1  2311: 9a0c061d0d       lcall 0xd1d, 0x60c
  0737A6  2316: 83c408           add sp, 8
  0737A9  2319: 0bc0             or ax, ax
  0737AB  231B: 7503             jne 0x2320
  0737AD  231D: e9de02           jmp 0x25fe
  0737B0  2320: 56               push si
  0737B1  2321: 6a01             push 1
  0737B3  2323: 6a40             push 0x40
  0737B5  2325: 68a694           push 0x94a6
  0737B8  2328: 9a0c061d0d       lcall 0xd1d, 0x60c
  0737BD  232D: 83c408           add sp, 8
  0737C0  2330: 0bc0             or ax, ax
  0737C2  2332: 7503             jne 0x2337
  0737C4  2334: e9c702           jmp 0x25fe
  0737C7  2337: 56               push si
  0737C8  2338: 6a01             push 1
  0737CA  233A: 6a40             push 0x40
  0737CC  233C: 68e694           push 0x94e6
  0737CF  233F: 9a0c061d0d       lcall 0xd1d, 0x60c
  0737D4  2344: 83c408           add sp, 8
  0737D7  2347: 0bc0             or ax, ax
  0737D9  2349: 7503             jne 0x234e
  0737DB  234B: e9b002           jmp 0x25fe
  0737DE  234E: 56               push si
  0737DF  234F: 6a01             push 1
  0737E1  2351: 6a40             push 0x40
  0737E3  2353: 68b295           push 0x95b2
  0737E6  2356: 9a0c061d0d       lcall 0xd1d, 0x60c
  0737EB  235B: 83c408           add sp, 8
  0737EE  235E: 0bc0             or ax, ax
  0737F0  2360: 7503             jne 0x2365
  0737F2  2362: e99902           jmp 0x25fe
  0737F5  2365: 56               push si
  0737F6  2366: 6a01             push 1
  0737F8  2368: 6a40             push 0x40
  0737FA  236A: 682695           push 0x9526
  0737FD  236D: 9a0c061d0d       lcall 0xd1d, 0x60c
  073802  2372: 83c408           add sp, 8
  073805  2375: 0bc0             or ax, ax
  073807  2377: 7503             jne 0x237c
  073809  2379: e98202           jmp 0x25fe
  07380C  237C: 56               push si
  07380D  237D: 6a01             push 1
  07380F  237F: 6a40             push 0x40
  073811  2381: 688c91           push 0x918c
  073814  2384: 9a0c061d0d       lcall 0xd1d, 0x60c
  073819  2389: 83c408           add sp, 8
  07381C  238C: 0bc0             or ax, ax
  07381E  238E: 7503             jne 0x2393
  073820  2390: e96b02           jmp 0x25fe
  073823  2393: 56               push si
  073824  2394: 6a01             push 1
  073826  2396: 6a40             push 0x40
  073828  2398: 687295           push 0x9572
  07382B  239B: 9a0c061d0d       lcall 0xd1d, 0x60c
  073830  23A0: 83c408           add sp, 8
  073833  23A3: 0bc0             or ax, ax
  073835  23A5: 7503             jne 0x23aa
  073837  23A7: e95402           jmp 0x25fe
  07383A  23AA: 56               push si
  07383B  23AB: 6a01             push 1
  07383D  23AD: 6a08             push 8
  07383F  23AF: 684e94           push 0x944e
  073842  23B2: 9a0c061d0d       lcall 0xd1d, 0x60c
  073847  23B7: 83c408           add sp, 8
  07384A  23BA: 0bc0             or ax, ax
  07384C  23BC: 7503             jne 0x23c1
  07384E  23BE: e93d02           jmp 0x25fe
  073851  23C1: 56               push si
  073852  23C2: 6a01             push 1
  073854  23C4: 6a01             push 1
  073856  23C6: 683603           push 0x336
  073859  23C9: 9a0c061d0d       lcall 0xd1d, 0x60c
  07385E  23CE: 83c408           add sp, 8
  073861  23D1: 0bc0             or ax, ax
  073863  23D3: 7503             jne 0x23d8
  073865  23D5: e92602           jmp 0x25fe
  073868  23D8: 56               push si
  073869  23D9: 6a01             push 1
  07386B  23DB: 6a08             push 8
  07386D  23DD: 688491           push 0x9184
  073870  23E0: 9a0c061d0d       lcall 0xd1d, 0x60c
  073875  23E5: 83c408           add sp, 8
  073878  23E8: 0bc0             or ax, ax
  07387A  23EA: 7503             jne 0x23ef
  07387C  23EC: e90f02           jmp 0x25fe
  07387F  23EF: 56               push si
  073880  23F0: 6a01             push 1
  073882  23F2: 6a08             push 8
  073884  23F4: 682296           push 0x9622
  073887  23F7: 9a0c061d0d       lcall 0xd1d, 0x60c
  07388C  23FC: 83c408           add sp, 8
  07388F  23FF: 0bc0             or ax, ax
  073891  2401: 7503             jne 0x2406
  073893  2403: e9f801           jmp 0x25fe
  073896  2406: 56               push si
  073897  2407: 6a01             push 1
  073899  2409: 6a08             push 8
  07389B  240B: 682a96           push 0x962a
  07389E  240E: 9a0c061d0d       lcall 0xd1d, 0x60c
  0738A3  2413: 83c408           add sp, 8
  0738A6  2416: 0bc0             or ax, ax
  0738A8  2418: 7503             jne 0x241d
  0738AA  241A: e9e101           jmp 0x25fe
  0738AD  241D: 56               push si
  0738AE  241E: 6a01             push 1
  0738B0  2420: 688000           push 0x80
  0738B3  2423: 68cc91           push 0x91cc
  0738B6  2426: 9a0c061d0d       lcall 0xd1d, 0x60c
  0738BB  242B: 83c408           add sp, 8
  0738BE  242E: 0bc0             or ax, ax
  0738C0  2430: 7503             jne 0x2435
  0738C2  2432: e9c901           jmp 0x25fe
  0738C5  2435: 56               push si
  0738C6  2436: 6a01             push 1
  0738C8  2438: 6a02             push 2
  0738CA  243A: 684085           push 0x8540
  0738CD  243D: 9a0c061d0d       lcall 0xd1d, 0x60c
  0738D2  2442: 83c408           add sp, 8
  0738D5  2445: 0bc0             or ax, ax
  0738D7  2447: 7503             jne 0x244c
  0738D9  2449: e9b201           jmp 0x25fe
  0738DC  244C: 56               push si
  0738DD  244D: 6a01             push 1
  0738DF  244F: 6a02             push 2
  0738E1  2451: 683e85           push 0x853e
  0738E4  2454: 9a0c061d0d       lcall 0xd1d, 0x60c
  0738E9  2459: 83c408           add sp, 8
  0738EC  245C: 0bc0             or ax, ax
  0738EE  245E: 7503             jne 0x2463
  0738F0  2460: e99b01           jmp 0x25fe
  0738F3  2463: 56               push si
  0738F4  2464: 6a01             push 1
  0738F6  2466: 6a02             push 2
  0738F8  2468: 688401           push 0x184
  0738FB  246B: 9a0c061d0d       lcall 0xd1d, 0x60c
  073900  2470: 83c408           add sp, 8
  073903  2473: 0bc0             or ax, ax
  073905  2475: 7503             jne 0x247a
  073907  2477: e98401           jmp 0x25fe
  07390A  247A: 56               push si
  07390B  247B: 6a01             push 1
  07390D  247D: 6a02             push 2
  07390F  247F: 687c01           push 0x17c
  073912  2482: 9a0c061d0d       lcall 0xd1d, 0x60c
  073917  2487: 83c408           add sp, 8
  07391A  248A: 0bc0             or ax, ax
  07391C  248C: 7503             jne 0x2491
  07391E  248E: e96d01           jmp 0x25fe
  073921  2491: 56               push si
  073922  2492: 6a01             push 1
  073924  2494: 6a02             push 2
  073926  2496: 687e01           push 0x17e
  073929  2499: 9a0c061d0d       lcall 0xd1d, 0x60c
  07392E  249E: 83c408           add sp, 8
  073931  24A1: 0bc0             or ax, ax
  073933  24A3: 7503             jne 0x24a8
  073935  24A5: e95601           jmp 0x25fe
  073938  24A8: ff365e01         push word ptr [0x15e]
  07393C  24AC: ff365c01         push word ptr [0x15c]
  073940  24B0: 6a00             push 0
  073942  24B2: 6a01             push 1
  073944  24B4: a18001           mov ax, word ptr [0x180]
  073947  24B7: 8b168201         mov dx, word ptr [0x182]
  07394B  24BB: 8bde             mov bx, si
  07394D  24BD: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  073952  24C2: 0bd0             or dx, ax
  073954  24C4: 7503             jne 0x24c9
  073956  24C6: e93501           jmp 0x25fe
  073959  24C9: ff366201         push word ptr [0x162]
  07395D  24CD: ff366001         push word ptr [0x160]
  073961  24D1: 6a00             push 0
  073963  24D3: 6a01             push 1
  073965  24D5: a18001           mov ax, word ptr [0x180]
  073968  24D8: 8b168201         mov dx, word ptr [0x182]
  07396C  24DC: 8bde             mov bx, si
  07396E  24DE: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  073973  24E3: 0bd0             or dx, ax
  073975  24E5: 7503             jne 0x24ea
  073977  24E7: e91401           jmp 0x25fe
  07397A  24EA: ff366601         push word ptr [0x166]
  07397E  24EE: ff366401         push word ptr [0x164]
  073982  24F2: 6a00             push 0
  073984  24F4: 6a01             push 1
  073986  24F6: a18001           mov ax, word ptr [0x180]
  073989  24F9: 8b168201         mov dx, word ptr [0x182]
  07398D  24FD: 8bde             mov bx, si
  07398F  24FF: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  073994  2504: 0bd0             or dx, ax
  073996  2506: 7503             jne 0x250b
  073998  2508: e9f300           jmp 0x25fe
  07399B  250B: ff366a01         push word ptr [0x16a]
  07399F  250F: ff366801         push word ptr [0x168]
  0739A3  2513: 6a00             push 0
  0739A5  2515: 6a01             push 1
  0739A7  2517: a18001           mov ax, word ptr [0x180]
  0739AA  251A: 8b168201         mov dx, word ptr [0x182]
  0739AE  251E: 8bde             mov bx, si
  0739B0  2520: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  0739B5  2525: 0bd0             or dx, ax
  0739B7  2527: 7503             jne 0x252c
  0739B9  2529: e9d200           jmp 0x25fe
  0739BC  252C: 1e               push ds
  0739BD  252D: 68f686           push 0x86f6
  0739C0  2530: 6a00             push 0
  0739C2  2532: 6a01             push 1
  0739C4  2534: b80e01           mov ax, 0x10e
  0739C7  2537: 99               cdq 
  0739C8  2538: 8bde             mov bx, si
  0739CA  253A: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  0739CF  253F: 0bd0             or dx, ax
  0739D1  2541: 7503             jne 0x2546
  0739D3  2543: e9b800           jmp 0x25fe
  0739D6  2546: 1e               push ds
  0739D7  2547: 68e885           push 0x85e8
  0739DA  254A: 6a00             push 0
  0739DC  254C: 6a01             push 1
  0739DE  254E: b80e01           mov ax, 0x10e
  0739E1  2551: 99               cdq 
  0739E2  2552: 8bde             mov bx, si
  0739E4  2554: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  0739E9  2559: 0bd0             or dx, ax
  0739EB  255B: 7503             jne 0x2560
  0739ED  255D: e99e00           jmp 0x25fe
  0739F0  2560: 1e               push ds
  0739F1  2561: 685e94           push 0x945e
  0739F4  2564: 6a00             push 0
  0739F6  2566: 6a01             push 1
  0739F8  2568: b82000           mov ax, 0x20
  0739FB  256B: 99               cdq 
  0739FC  256C: 8bde             mov bx, si
  0739FE  256E: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  073A03  2573: 0bd0             or dx, ax
  073A05  2575: 7503             jne 0x257a
  073A07  2577: e98400           jmp 0x25fe
  073A0A  257A: 1e               push ds
  073A0B  257B: 68c885           push 0x85c8
  073A0E  257E: 6a00             push 0
  073A10  2580: 6a01             push 1
  073A12  2582: b82000           mov ax, 0x20
  073A15  2585: 99               cdq 
  073A16  2586: 8bde             mov bx, si
  073A18  2588: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  073A1D  258D: 0bd0             or dx, ax
  073A1F  258F: 746d             je 0x25fe
  073A21  2591: ff36a683         push word ptr [0x83a6]
  073A25  2595: 9aca041f18       lcall 0x181f, 0x4ca
  073A2A  259A: 83c402           add sp, 2
  073A2D  259D: 8d46fa           lea ax, [bp - 6]
  073A30  25A0: 16               push ss
  073A31  25A1: 50               push ax
  073A32  25A2: 6a00             push 0
  073A34  25A4: 6a01             push 1
  073A36  25A6: b80400           mov ax, 4
  073A39  25A9: 99               cdq 
  073A3A  25AA: 8bde             mov bx, si
  073A3C  25AC: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  073A41  25B1: 0bd0             or dx, ax
  073A43  25B3: 7449             je 0x25fe
  073A45  25B5: 1e               push ds
  073A46  25B6: 68808d           push 0x8d80
  073A49  25B9: 6a00             push 0
  073A4B  25BB: 6a01             push 1
  073A4D  25BD: b80400           mov ax, 4
  073A50  25C0: 99               cdq 
  073A51  25C1: 8bde             mov bx, si
  073A53  25C3: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  073A58  25C8: 0bd0             or dx, ax
  073A5A  25CA: 7432             je 0x25fe
  073A5C  25CC: 1e               push ds
  073A5D  25CD: 689001           push 0x190
  073A60  25D0: 6a00             push 0
  073A62  25D2: 6a01             push 1
  073A64  25D4: b80200           mov ax, 2
  073A67  25D7: 99               cdq 
  073A68  25D8: 8bde             mov bx, si
  073A6A  25DA: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  073A6F  25DF: 0bd0             or dx, ax
  073A71  25E1: 741b             je 0x25fe
  073A73  25E3: 68221b           push 0x1b22
  073A76  25E6: 680000           push 0
  073A79  25E9: 6a00             push 0
  073A7B  25EB: 6a01             push 1
  073A7D  25ED: b87803           mov ax, 0x378
  073A80  25F0: 99               cdq 
  073A81  25F1: 8bde             mov bx, si
  073A83  25F3: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  073A88  25F8: 0bd0             or dx, ax
  073A8A  25FA: 7402             je 0x25fe
  073A8C  25FC: 2bff             sub di, di
  073A8E  25FE: 0bf6             or si, si
  073A90  2600: 7418             je 0x261a
  073A92  2602: 56               push si
  073A93  2603: 9af4031d0d       lcall 0xd1d, 0x3f4
  073A98  2608: 83c402           add sp, 2
  073A9B  260B: 0bff             or di, di
  073A9D  260D: 740b             je 0x261a
  073A9F  260F: ff7606           push word ptr [bp + 6]
  073AA2  2612: 9a4a0e1d0d       lcall 0xd1d, 0xe4a
  073AA7  2617: 83c402           add sp, 2
  073AAA  261A: 8bc7             mov ax, di
  073AAC  261C: 5e               pop si
  073AAD  261D: 5f               pop di
  073AAE  261E: c9               leave 
  073AAF  261F: cb               retf 

; ---- func_073AB0  size=256  insns=101  prologue=ENTER 0x005A,0  terminal=RETF ----
  073AB0  2620: c85a0000         enter 0x5a, 0
  073AB4  2624: 57               push di
  073AB5  2625: 56               push si
  073AB6  2626: be0100           mov si, 1
  073AB9  2629: 833e5a0100       cmp word ptr [0x15a], 0
  073ABE  262E: 7403             je 0x2633
  073AC0  2630: be0500           mov si, 5
  073AC3  2633: 688321           push 0x2183
  073AC6  2636: ff7606           push word ptr [bp + 6]
  073AC9  2639: 9ada041d0d       lcall 0xd1d, 0x4da
  073ACE  263E: 83c404           add sp, 4
  073AD1  2641: 8bf8             mov di, ax
  073AD3  2643: 0bff             or di, di
  073AD5  2645: 7503             jne 0x264a
  073AD7  2647: e9c300           jmp 0x270d
  073ADA  264A: 8d5ea6           lea bx, [bp - 0x5a]
  073ADD  264D: 8bc7             mov ax, di
  073ADF  264F: 9aee0d1f1a       lcall 0x1a1f, 0xdee
  073AE4  2654: 0bc0             or ax, ax
  073AE6  2656: 7503             jne 0x265b
  073AE8  2658: e9b200           jmp 0x270d
  073AEB  265B: 8d46a6           lea ax, [bp - 0x5a]
  073AEE  265E: 50               push ax
  073AEF  265F: 687a21           push 0x217a
  073AF2  2662: 9a16081d0d       lcall 0xd1d, 0x816
  073AF7  2667: 83c404           add sp, 4
  073AFA  266A: 0bc0             or ax, ax
  073AFC  266C: 7406             je 0x2674
  073AFE  266E: be0200           mov si, 2
  073B01  2671: e99900           jmp 0x270d
  073B04  2674: 57               push di
  073B05  2675: 6a01             push 1
  073B07  2677: 6a02             push 2
  073B09  2679: 8d46fa           lea ax, [bp - 6]
  073B0C  267C: 50               push ax
  073B0D  267D: 9a28051d0d       lcall 0xd1d, 0x528
  073B12  2682: 83c408           add sp, 8
  073B15  2685: 0bc0             or ax, ax
  073B17  2687: 7503             jne 0x268c
  073B19  2689: e98100           jmp 0x270d
  073B1C  268C: 8b161a08         mov dx, word ptr [0x81a]
  073B20  2690: 3956fa           cmp word ptr [bp - 6], dx
  073B23  2693: 7fd9             jg 0x266e
  073B25  2695: 7d07             jge 0x269e
  073B27  2697: be0300           mov si, 3
  073B2A  269A: eb71             jmp 0x270d
  073B2C  269C: 90               nop 
  073B2D  269D: 90               nop 
  073B2E  269E: 57               push di
  073B2F  269F: 6a01             push 1
  073B31  26A1: 6a04             push 4
  073B33  26A3: 8d46f6           lea ax, [bp - 0xa]
  073B36  26A6: 50               push ax
  073B37  26A7: 9a28051d0d       lcall 0xd1d, 0x528
  073B3C  26AC: 83c408           add sp, 8
  073B3F  26AF: 0bc0             or ax, ax
  073B41  26B1: 745a             je 0x270d
  073B43  26B3: 8b46f8           mov ax, word ptr [bp - 8]
  073B46  26B6: f76ef6           imul word ptr [bp - 0xa]
  073B49  26B9: 8946fc           mov word ptr [bp - 4], ax
  073B4C  26BC: 8956fe           mov word ptr [bp - 2], dx
  073B4F  26BF: a18201           mov ax, word ptr [0x182]
  073B52  26C2: 0b068001         or ax, word ptr [0x180]
  073B56  26C6: 7414             je 0x26dc
  073B58  26C8: 8b46fc           mov ax, word ptr [bp - 4]
  073B5B  26CB: 39068001         cmp word ptr [0x180], ax
  073B5F  26CF: 7506             jne 0x26d7
  073B61  26D1: 39168201         cmp word ptr [0x182], dx
  073B65  26D5: 7405             je 0x26dc
  073B67  26D7: be0400           mov si, 4
  073B6A  26DA: eb31             jmp 0x270d
  073B6C  26DC: 57               push di
  073B6D  26DD: 6a01             push 1
  073B6F  26DF: 688e00           push 0x8e
  073B72  26E2: ff7608           push word ptr [bp + 8]
  073B75  26E5: 9a28051d0d       lcall 0xd1d, 0x528
  073B7A  26EA: 83c408           add sp, 8
  073B7D  26ED: 0bc0             or ax, ax
  073B7F  26EF: 741c             je 0x270d
  073B81  26F1: 8b4e0a           mov cx, word ptr [bp + 0xa]
  073B84  26F4: 0bc9             or cx, cx
  073B86  26F6: 7413             je 0x270b
  073B88  26F8: 57               push di
  073B89  26F9: 6a01             push 1
  073B8B  26FB: 68d000           push 0xd0
  073B8E  26FE: 51               push cx
  073B8F  26FF: 9a28051d0d       lcall 0xd1d, 0x528
  073B94  2704: 83c408           add sp, 8
  073B97  2707: 0bc0             or ax, ax
  073B99  2709: 7402             je 0x270d
  073B9B  270B: 2bf6             sub si, si
  073B9D  270D: 0bff             or di, di
  073B9F  270F: 7409             je 0x271a
  073BA1  2711: 57               push di
  073BA2  2712: 9af4031d0d       lcall 0xd1d, 0x3f4
  073BA7  2717: 83c402           add sp, 2
  073BAA  271A: 8bc6             mov ax, si
  073BAC  271C: 5e               pop si
  073BAD  271D: 5f               pop di
  073BAE  271E: c9               leave 
  073BAF  271F: cb               retf 

; ---- func_073BB0  size=1901  insns=664  prologue=ENTER 0x0064,0  terminal=RETF ----
  073BB0  2720: c8640000         enter 0x64, 0
  073BB4  2724: c746aa0100       mov word ptr [bp - 0x56], 1
  073BB9  2729: c7469c0000       mov word ptr [bp - 0x64], 0
  073BBE  272E: c746a40000       mov word ptr [bp - 0x5c], 0
  073BC3  2733: 833e5a0100       cmp word ptr [0x15a], 0
  073BC8  2738: 7405             je 0x273f
  073BCA  273A: c746aa0500       mov word ptr [bp - 0x56], 5
  073BCF  273F: 688621           push 0x2186
  073BD2  2742: ff7606           push word ptr [bp + 6]
  073BD5  2745: 9ada041d0d       lcall 0xd1d, 0x4da
  073BDA  274A: 83c404           add sp, 4
  073BDD  274D: 89469c           mov word ptr [bp - 0x64], ax
  073BE0  2750: 0bc0             or ax, ax
  073BE2  2752: 7503             jne 0x2757
  073BE4  2754: e9e506           jmp 0x2e3c
  073BE7  2757: 8d5eb0           lea bx, [bp - 0x50]
  073BEA  275A: 8b469c           mov ax, word ptr [bp - 0x64]
  073BED  275D: 9aee0d1f1a       lcall 0x1a1f, 0xdee
  073BF2  2762: 0bc0             or ax, ax
  073BF4  2764: 7503             jne 0x2769
  073BF6  2766: e9d306           jmp 0x2e3c
  073BF9  2769: 8d46b0           lea ax, [bp - 0x50]
  073BFC  276C: 50               push ax
  073BFD  276D: 687a21           push 0x217a
  073C00  2770: 9a16081d0d       lcall 0xd1d, 0x816
  073C05  2775: 83c404           add sp, 4
  073C08  2778: 0bc0             or ax, ax
  073C0A  277A: 7408             je 0x2784
  073C0C  277C: c746aa0200       mov word ptr [bp - 0x56], 2
  073C11  2781: e9b806           jmp 0x2e3c
  073C14  2784: ff769c           push word ptr [bp - 0x64]
  073C17  2787: 6a01             push 1
  073C19  2789: 6a02             push 2
  073C1B  278B: 8d46a2           lea ax, [bp - 0x5e]
  073C1E  278E: 50               push ax
  073C1F  278F: 9a28051d0d       lcall 0xd1d, 0x528
  073C24  2794: 83c408           add sp, 8
  073C27  2797: 0bc0             or ax, ax
  073C29  2799: 7503             jne 0x279e
  073C2B  279B: e99e06           jmp 0x2e3c
  073C2E  279E: a11a08           mov ax, word ptr [0x81a]
  073C31  27A1: 3946a2           cmp word ptr [bp - 0x5e], ax
  073C34  27A4: 7fd6             jg 0x277c
  073C36  27A6: 7d08             jge 0x27b0
  073C38  27A8: c746aa0300       mov word ptr [bp - 0x56], 3
  073C3D  27AD: e98c06           jmp 0x2e3c
  073C40  27B0: ff769c           push word ptr [bp - 0x64]
  073C43  27B3: 6a01             push 1
  073C45  27B5: 6a04             push 4
  073C47  27B7: 8d46a6           lea ax, [bp - 0x5a]
  073C4A  27BA: 50               push ax
  073C4B  27BB: 9a28051d0d       lcall 0xd1d, 0x528
  073C50  27C0: 83c408           add sp, 8
  073C53  27C3: 0bc0             or ax, ax
  073C55  27C5: 7503             jne 0x27ca
  073C57  27C7: e97206           jmp 0x2e3c
  073C5A  27CA: 8b46a8           mov ax, word ptr [bp - 0x58]
  073C5D  27CD: f76ea6           imul word ptr [bp - 0x5a]
  073C60  27D0: 8946ac           mov word ptr [bp - 0x54], ax
  073C63  27D3: 8956ae           mov word ptr [bp - 0x52], dx
  073C66  27D6: 8b0e8201         mov cx, word ptr [0x182]
  073C6A  27DA: 0b0e8001         or cx, word ptr [0x180]
  073C6E  27DE: 7414             je 0x27f4
  073C70  27E0: 3b068001         cmp ax, word ptr [0x180]
  073C74  27E4: 7506             jne 0x27ec
  073C76  27E6: 3b168201         cmp dx, word ptr [0x182]
  073C7A  27EA: 7431             je 0x281d
  073C7C  27EC: c746aa0400       mov word ptr [bp - 0x56], 4
  073C81  27F1: e94806           jmp 0x2e3c
  073C84  27F4: 6a04             push 4
  073C86  27F6: 8d46a6           lea ax, [bp - 0x5a]
  073C89  27F9: 50               push ax
  073C8A  27FA: 683a85           push 0x853a
  073C8D  27FD: 9a820d1d0d       lcall 0xd1d, 0xd82
  073C92  2802: 83c406           add sp, 6
  073C95  2805: 2bc0             sub ax, ax
  073C97  2807: 9a720c1f1a       lcall 0x1a1f, 0xc72
  073C9C  280C: 0bc0             or ax, ax
  073C9E  280E: 7408             je 0x2818
  073CA0  2810: c746aa0100       mov word ptr [bp - 0x56], 1
  073CA5  2815: e92406           jmp 0x2e3c
  073CA8  2818: c746a40100       mov word ptr [bp - 0x5c], 1
  073CAD  281D: 6a04             push 4
  073CAF  281F: 8d46a6           lea ax, [bp - 0x5a]
  073CB2  2822: 50               push ax
  073CB3  2823: 683a85           push 0x853a
  073CB6  2826: 9a820d1d0d       lcall 0xd1d, 0xd82
  073CBB  282B: 83c406           add sp, 6
  073CBE  282E: ff769c           push word ptr [bp - 0x64]
  073CC1  2831: 6a01             push 1
  073CC3  2833: 688e00           push 0x8e
  073CC6  2836: 688053           push 0x5380
  073CC9  2839: 9a28051d0d       lcall 0xd1d, 0x528
  073CCE  283E: 83c408           add sp, 8
  073CD1  2841: 0bc0             or ax, ax
  073CD3  2843: 7503             jne 0x2848
  073CD5  2845: e9f405           jmp 0x2e3c
  073CD8  2848: ff769c           push word ptr [bp - 0x64]
  073CDB  284B: 6a01             push 1
  073CDD  284D: 68d000           push 0xd0
  073CE0  2850: 680e54           push 0x540e
  073CE3  2853: 9a28051d0d       lcall 0xd1d, 0x528
  073CE8  2858: 83c408           add sp, 8
  073CEB  285B: 0bc0             or ax, ax
  073CED  285D: 7503             jne 0x2862
  073CEF  285F: e9da05           jmp 0x2e3c
  073CF2  2862: ff769c           push word ptr [bp - 0x64]
  073CF5  2865: 6a01             push 1
  073CF7  2867: 6a18             push 0x18
  073CF9  2869: 688e94           push 0x948e
  073CFC  286C: 9a28051d0d       lcall 0xd1d, 0x528
  073D01  2871: 83c408           add sp, 8
  073D04  2874: 0bc0             or ax, ax
  073D06  2876: 7503             jne 0x287b
  073D08  2878: e9c105           jmp 0x2e3c
  073D0B  287B: 833e9e5300       cmp word ptr [0x539e], 0
  073D10  2880: 741e             je 0x28a0
  073D12  2882: ff769c           push word ptr [bp - 0x64]
  073D15  2885: 6a01             push 1
  073D17  2887: 69069e53ca00     imul ax, word ptr [0x539e], 0xca
  073D1D  288D: 50               push ax
  073D1E  288E: 68465d           push 0x5d46
  073D21  2891: 9a28051d0d       lcall 0xd1d, 0x528
  073D26  2896: 83c408           add sp, 8
  073D29  2899: 0bc0             or ax, ax
  073D2B  289B: 7503             jne 0x28a0
  073D2D  289D: e99c05           jmp 0x2e3c
  073D30  28A0: 833e9c5300       cmp word ptr [0x539c], 0
  073D35  28A5: 741d             je 0x28c4
  073D37  28A7: ff769c           push word ptr [bp - 0x64]
  073D3A  28AA: 6a01             push 1
  073D3C  28AC: 6b069c531c       imul ax, word ptr [0x539c], 0x1c
  073D41  28B1: 50               push ax
  073D42  28B2: 684431           push 0x3144
  073D45  28B5: 9a28051d0d       lcall 0xd1d, 0x528
  073D4A  28BA: 83c408           add sp, 8
  073D4D  28BD: 0bc0             or ax, ax
  073D4F  28BF: 7503             jne 0x28c4
  073D51  28C1: e97805           jmp 0x2e3c
  073D54  28C4: ff769c           push word ptr [bp - 0x64]
  073D57  28C7: 6a01             push 1
  073D59  28C9: 68f004           push 0x4f0
  073D5C  28CC: 680888           push 0x8808
  073D5F  28CF: 9a28051d0d       lcall 0xd1d, 0x528
  073D64  28D4: 83c408           add sp, 8
  073D67  28D7: 0bc0             or ax, ax
  073D69  28D9: 7503             jne 0x28de
  073D6B  28DB: e95e05           jmp 0x2e3c
  073D6E  28DE: 833e9a5300       cmp word ptr [0x539a], 0
  073D73  28E3: 741d             je 0x2902
  073D75  28E5: ff769c           push word ptr [bp - 0x64]
  073D78  28E8: 6a01             push 1
  073D7A  28EA: 6b069a5312       imul ax, word ptr [0x539a], 0x12
  073D7F  28EF: 50               push ax
  073D80  28F0: 68ec54           push 0x54ec
  073D83  28F3: 9a28051d0d       lcall 0xd1d, 0x528
  073D88  28F8: 83c408           add sp, 8
  073D8B  28FB: 0bc0             or ax, ax
  073D8D  28FD: 7503             jne 0x2902
  073D8F  28FF: e93a05           jmp 0x2e3c
  073D92  2902: ff769c           push word ptr [bp - 0x64]
  073D95  2905: 6a01             push 1
  073D97  2907: 687002           push 0x270
  073D9A  290A: 68d65a           push 0x5ad6
  073D9D  290D: 9a28051d0d       lcall 0xd1d, 0x528
  073DA2  2912: 83c408           add sp, 8
  073DA5  2915: 0bc0             or ax, ax
  073DA7  2917: 7503             jne 0x291c
  073DA9  2919: e92005           jmp 0x2e3c
  073DAC  291C: ff769c           push word ptr [bp - 0x64]
  073DAF  291F: 6a01             push 1
  073DB1  2921: 6a0c             push 0xc
  073DB3  2923: 686695           push 0x9566
  073DB6  2926: 9a28051d0d       lcall 0xd1d, 0x528
  073DBB  292B: 83c408           add sp, 8
  073DBE  292E: 0bc0             or ax, ax
  073DC0  2930: 7503             jne 0x2935
  073DC2  2932: e90705           jmp 0x2e3c
  073DC5  2935: ff769c           push word ptr [bp - 0x64]
  073DC8  2938: 6a01             push 1
  073DCA  293A: 6a04             push 4
  073DCC  293C: 68fc8c           push 0x8cfc
  073DCF  293F: 9a28051d0d       lcall 0xd1d, 0x528
  073DD4  2944: 83c408           add sp, 8
  073DD7  2947: 0bc0             or ax, ax
  073DD9  2949: 7503             jne 0x294e
  073DDB  294B: e9ee04           jmp 0x2e3c
  073DDE  294E: ff769c           push word ptr [bp - 0x64]
  073DE1  2951: 6a01             push 1
  073DE3  2953: 6a04             push 4
  073DE5  2955: 689892           push 0x9298
  073DE8  2958: 9a28051d0d       lcall 0xd1d, 0x528
  073DED  295D: 83c408           add sp, 8
  073DF0  2960: 0bc0             or ax, ax
  073DF2  2962: 7503             jne 0x2967
  073DF4  2964: e9d504           jmp 0x2e3c
  073DF7  2967: ff769c           push word ptr [bp - 0x64]
  073DFA  296A: 6a01             push 1
  073DFC  296C: 6a04             push 4
  073DFE  296E: 680894           push 0x9408
  073E01  2971: 9a28051d0d       lcall 0xd1d, 0x528
  073E06  2976: 83c408           add sp, 8
  073E09  2979: 0bc0             or ax, ax
  073E0B  297B: 7503             jne 0x2980
  073E0D  297D: e9bc04           jmp 0x2e3c
  073E10  2980: ff769c           push word ptr [bp - 0x64]
  073E13  2983: 6a01             push 1
  073E15  2985: 6a04             push 4
  073E17  2987: 680c94           push 0x940c
  073E1A  298A: 9a28051d0d       lcall 0xd1d, 0x528
  073E1F  298F: 83c408           add sp, 8
  073E22  2992: 0bc0             or ax, ax
  073E24  2994: 7503             jne 0x2999
  073E26  2996: e9a304           jmp 0x2e3c
  073E29  2999: ff769c           push word ptr [bp - 0x64]
  073E2C  299C: 6a01             push 1
  073E2E  299E: 6a04             push 4
  073E30  29A0: 681094           push 0x9410
  073E33  29A3: 9a28051d0d       lcall 0xd1d, 0x528
  073E38  29A8: 83c408           add sp, 8
  073E3B  29AB: 0bc0             or ax, ax
  073E3D  29AD: 7503             jne 0x29b2
  073E3F  29AF: e98a04           jmp 0x2e3c
  073E42  29B2: ff769c           push word ptr [bp - 0x64]
  073E45  29B5: 6a01             push 1
  073E47  29B7: 6a04             push 4
  073E49  29B9: 688091           push 0x9180
  073E4C  29BC: 9a28051d0d       lcall 0xd1d, 0x528
  073E51  29C1: 83c408           add sp, 8
  073E54  29C4: 0bc0             or ax, ax
  073E56  29C6: 7503             jne 0x29cb
  073E58  29C8: e97104           jmp 0x2e3c
  073E5B  29CB: ff769c           push word ptr [bp - 0x64]
  073E5E  29CE: 6a01             push 1
  073E60  29D0: 6a04             push 4
  073E62  29D2: 681494           push 0x9414
  073E65  29D5: 9a28051d0d       lcall 0xd1d, 0x528
  073E6A  29DA: 83c408           add sp, 8
  073E6D  29DD: 0bc0             or ax, ax
  073E6F  29DF: 7503             jne 0x29e4
  073E71  29E1: e95804           jmp 0x2e3c
  073E74  29E4: ff769c           push word ptr [bp - 0x64]
  073E77  29E7: 6a01             push 1
  073E79  29E9: 6a04             push 4
  073E7B  29EB: 681894           push 0x9418
  073E7E  29EE: 9a28051d0d       lcall 0xd1d, 0x528
  073E83  29F3: 83c408           add sp, 8
  073E86  29F6: 0bc0             or ax, ax
  073E88  29F8: 7503             jne 0x29fd
  073E8A  29FA: e93f04           jmp 0x2e3c
  073E8D  29FD: ff769c           push word ptr [bp - 0x64]
  073E90  2A00: 6a01             push 1
  073E92  2A02: 6a08             push 8
  073E94  2A04: 681c94           push 0x941c
  073E97  2A07: 9a28051d0d       lcall 0xd1d, 0x528
  073E9C  2A0C: 83c408           add sp, 8
  073E9F  2A0F: 0bc0             or ax, ax
  073EA1  2A11: 7503             jne 0x2a16
  073EA3  2A13: e92604           jmp 0x2e3c
  073EA6  2A16: ff769c           push word ptr [bp - 0x64]
  073EA9  2A19: 6a01             push 1
  073EAB  2A1B: 6a04             push 4
  073EAD  2A1D: 682494           push 0x9424
  073EB0  2A20: 9a28051d0d       lcall 0xd1d, 0x528
  073EB5  2A25: 83c408           add sp, 8
  073EB8  2A28: 0bc0             or ax, ax
  073EBA  2A2A: 7503             jne 0x2a2f
  073EBC  2A2C: e90d04           jmp 0x2e3c
  073EBF  2A2F: ff769c           push word ptr [bp - 0x64]
  073EC2  2A32: 6a01             push 1
  073EC4  2A34: 6a04             push 4
  073EC6  2A36: 682894           push 0x9428
  073EC9  2A39: 9a28051d0d       lcall 0xd1d, 0x528
  073ECE  2A3E: 83c408           add sp, 8
  073ED1  2A41: 0bc0             or ax, ax
  073ED3  2A43: 7503             jne 0x2a48
  073ED5  2A45: e9f403           jmp 0x2e3c
  073ED8  2A48: ff769c           push word ptr [bp - 0x64]
  073EDB  2A4B: 6a01             push 1
  073EDD  2A4D: 6a04             push 4
  073EDF  2A4F: 682c94           push 0x942c
  073EE2  2A52: 9a28051d0d       lcall 0xd1d, 0x528
  073EE7  2A57: 83c408           add sp, 8
  073EEA  2A5A: 0bc0             or ax, ax
  073EEC  2A5C: 7503             jne 0x2a61
  073EEE  2A5E: e9db03           jmp 0x2e3c
  073EF1  2A61: ff769c           push word ptr [bp - 0x64]
  073EF4  2A64: 6a01             push 1
  073EF6  2A66: 6a4c             push 0x4c
  073EF8  2A68: 684c92           push 0x924c
  073EFB  2A6B: 9a28051d0d       lcall 0xd1d, 0x528
  073F00  2A70: 83c408           add sp, 8
  073F03  2A73: 0bc0             or ax, ax
  073F05  2A75: 7503             jne 0x2a7a
  073F07  2A77: e9c203           jmp 0x2e3c
  073F0A  2A7A: ff769c           push word ptr [bp - 0x64]
  073F0D  2A7D: 6a01             push 1
  073F0F  2A7F: 6a10             push 0x10
  073F11  2A81: 687e94           push 0x947e
  073F14  2A84: 9a28051d0d       lcall 0xd1d, 0x528
  073F19  2A89: 83c408           add sp, 8
  073F1C  2A8C: 0bc0             or ax, ax
  073F1E  2A8E: 7503             jne 0x2a93
  073F20  2A90: e9a903           jmp 0x2e3c
  073F23  2A93: ff769c           push word ptr [bp - 0x64]
  073F26  2A96: 6a01             push 1
  073F28  2A98: 6a10             push 0x10
  073F2A  2A9A: 68f295           push 0x95f2
  073F2D  2A9D: 9a28051d0d       lcall 0xd1d, 0x528
  073F32  2AA2: 83c408           add sp, 8
  073F35  2AA5: 0bc0             or ax, ax
  073F37  2AA7: 7503             jne 0x2aac
  073F39  2AA9: e99003           jmp 0x2e3c
  073F3C  2AAC: ff769c           push word ptr [bp - 0x64]
  073F3F  2AAF: 6a01             push 1
  073F41  2AB1: 6a40             push 0x40
  073F43  2AB3: 68a694           push 0x94a6
  073F46  2AB6: 9a28051d0d       lcall 0xd1d, 0x528
  073F4B  2ABB: 83c408           add sp, 8
  073F4E  2ABE: 0bc0             or ax, ax
  073F50  2AC0: 7503             jne 0x2ac5
  073F52  2AC2: e97703           jmp 0x2e3c
  073F55  2AC5: ff769c           push word ptr [bp - 0x64]
  073F58  2AC8: 6a01             push 1
  073F5A  2ACA: 6a40             push 0x40
  073F5C  2ACC: 68e694           push 0x94e6
  073F5F  2ACF: 9a28051d0d       lcall 0xd1d, 0x528
  073F64  2AD4: 83c408           add sp, 8
  073F67  2AD7: 0bc0             or ax, ax
  073F69  2AD9: 7503             jne 0x2ade
  073F6B  2ADB: e95e03           jmp 0x2e3c
  073F6E  2ADE: ff769c           push word ptr [bp - 0x64]
  073F71  2AE1: 6a01             push 1
  073F73  2AE3: 6a40             push 0x40
  073F75  2AE5: 68b295           push 0x95b2
  073F78  2AE8: 9a28051d0d       lcall 0xd1d, 0x528
  073F7D  2AED: 83c408           add sp, 8
  073F80  2AF0: 0bc0             or ax, ax
  073F82  2AF2: 7503             jne 0x2af7
  073F84  2AF4: e94503           jmp 0x2e3c
  073F87  2AF7: ff769c           push word ptr [bp - 0x64]
  073F8A  2AFA: 6a01             push 1
  073F8C  2AFC: 6a40             push 0x40
  073F8E  2AFE: 682695           push 0x9526
  073F91  2B01: 9a28051d0d       lcall 0xd1d, 0x528
  073F96  2B06: 83c408           add sp, 8
  073F99  2B09: 0bc0             or ax, ax
  073F9B  2B0B: 7503             jne 0x2b10
  073F9D  2B0D: e92c03           jmp 0x2e3c
  073FA0  2B10: ff769c           push word ptr [bp - 0x64]
  073FA3  2B13: 6a01             push 1
  073FA5  2B15: 6a40             push 0x40
  073FA7  2B17: 688c91           push 0x918c
  073FAA  2B1A: 9a28051d0d       lcall 0xd1d, 0x528
  073FAF  2B1F: 83c408           add sp, 8
  073FB2  2B22: 0bc0             or ax, ax
  073FB4  2B24: 7503             jne 0x2b29
  073FB6  2B26: e91303           jmp 0x2e3c
  073FB9  2B29: ff769c           push word ptr [bp - 0x64]
  073FBC  2B2C: 6a01             push 1
  073FBE  2B2E: 6a40             push 0x40
  073FC0  2B30: 687295           push 0x9572
  073FC3  2B33: 9a28051d0d       lcall 0xd1d, 0x528
  073FC8  2B38: 83c408           add sp, 8
  073FCB  2B3B: 0bc0             or ax, ax
  073FCD  2B3D: 7503             jne 0x2b42
  073FCF  2B3F: e9fa02           jmp 0x2e3c
  073FD2  2B42: ff769c           push word ptr [bp - 0x64]
  073FD5  2B45: 6a01             push 1
  073FD7  2B47: 6a08             push 8
  073FD9  2B49: 684e94           push 0x944e
  073FDC  2B4C: 9a28051d0d       lcall 0xd1d, 0x528
  073FE1  2B51: 83c408           add sp, 8
  073FE4  2B54: 0bc0             or ax, ax
  073FE6  2B56: 7503             jne 0x2b5b
  073FE8  2B58: e9e102           jmp 0x2e3c
  073FEB  2B5B: ff769c           push word ptr [bp - 0x64]
  073FEE  2B5E: 6a01             push 1
  073FF0  2B60: 6a01             push 1
  073FF2  2B62: 683603           push 0x336
  073FF5  2B65: 9a28051d0d       lcall 0xd1d, 0x528
  073FFA  2B6A: 83c408           add sp, 8
  073FFD  2B6D: 0bc0             or ax, ax
  073FFF  2B6F: 7503             jne 0x2b74
  074001  2B71: e9c802           jmp 0x2e3c
  074004  2B74: ff769c           push word ptr [bp - 0x64]
  074007  2B77: 6a01             push 1
  074009  2B79: 6a08             push 8
  07400B  2B7B: 688491           push 0x9184
  07400E  2B7E: 9a28051d0d       lcall 0xd1d, 0x528
  074013  2B83: 83c408           add sp, 8
  074016  2B86: 0bc0             or ax, ax
  074018  2B88: 7503             jne 0x2b8d
  07401A  2B8A: e9af02           jmp 0x2e3c
  07401D  2B8D: ff769c           push word ptr [bp - 0x64]
  074020  2B90: 6a01             push 1
  074022  2B92: 6a08             push 8
  074024  2B94: 682296           push 0x9622
  074027  2B97: 9a28051d0d       lcall 0xd1d, 0x528
  07402C  2B9C: 83c408           add sp, 8
  07402F  2B9F: 0bc0             or ax, ax
  074031  2BA1: 7503             jne 0x2ba6
  074033  2BA3: e99602           jmp 0x2e3c
  074036  2BA6: ff769c           push word ptr [bp - 0x64]
  074039  2BA9: 6a01             push 1
  07403B  2BAB: 6a08             push 8
  07403D  2BAD: 682a96           push 0x962a
  074040  2BB0: 9a28051d0d       lcall 0xd1d, 0x528
  074045  2BB5: 83c408           add sp, 8
  074048  2BB8: 0bc0             or ax, ax
  07404A  2BBA: 7503             jne 0x2bbf
  07404C  2BBC: e97d02           jmp 0x2e3c
  07404F  2BBF: ff769c           push word ptr [bp - 0x64]
  074052  2BC2: 6a01             push 1
  074054  2BC4: 688000           push 0x80
  074057  2BC7: 68cc91           push 0x91cc
  07405A  2BCA: 9a28051d0d       lcall 0xd1d, 0x528
  07405F  2BCF: 83c408           add sp, 8
  074062  2BD2: 0bc0             or ax, ax
  074064  2BD4: 7503             jne 0x2bd9
  074066  2BD6: e96302           jmp 0x2e3c
  074069  2BD9: ff769c           push word ptr [bp - 0x64]
  07406C  2BDC: 6a01             push 1
  07406E  2BDE: 6a02             push 2
  074070  2BE0: 684085           push 0x8540
  074073  2BE3: 9a28051d0d       lcall 0xd1d, 0x528
  074078  2BE8: 83c408           add sp, 8
  07407B  2BEB: 0bc0             or ax, ax
  07407D  2BED: 7503             jne 0x2bf2
  07407F  2BEF: e94a02           jmp 0x2e3c
  074082  2BF2: ff769c           push word ptr [bp - 0x64]
  074085  2BF5: 6a01             push 1
  074087  2BF7: 6a02             push 2
  074089  2BF9: 683e85           push 0x853e
  07408C  2BFC: 9a28051d0d       lcall 0xd1d, 0x528
  074091  2C01: 83c408           add sp, 8
  074094  2C04: 0bc0             or ax, ax
  074096  2C06: 7503             jne 0x2c0b
  074098  2C08: e93102           jmp 0x2e3c
  07409B  2C0B: ff769c           push word ptr [bp - 0x64]
  07409E  2C0E: 6a01             push 1
  0740A0  2C10: 6a02             push 2
  0740A2  2C12: 688401           push 0x184
  0740A5  2C15: 9a28051d0d       lcall 0xd1d, 0x528
  0740AA  2C1A: 83c408           add sp, 8
  0740AD  2C1D: 0bc0             or ax, ax
  0740AF  2C1F: 7503             jne 0x2c24
  0740B1  2C21: e91802           jmp 0x2e3c
  0740B4  2C24: ff769c           push word ptr [bp - 0x64]
  0740B7  2C27: 6a01             push 1
  0740B9  2C29: 6a02             push 2
  0740BB  2C2B: 687c01           push 0x17c
  0740BE  2C2E: 9a28051d0d       lcall 0xd1d, 0x528
  0740C3  2C33: 83c408           add sp, 8
  0740C6  2C36: 0bc0             or ax, ax
  0740C8  2C38: 7503             jne 0x2c3d
  0740CA  2C3A: e9ff01           jmp 0x2e3c
  0740CD  2C3D: ff769c           push word ptr [bp - 0x64]
  0740D0  2C40: 6a01             push 1
  0740D2  2C42: 6a02             push 2
  0740D4  2C44: 687e01           push 0x17e
  0740D7  2C47: 9a28051d0d       lcall 0xd1d, 0x528
  0740DC  2C4C: 83c408           add sp, 8
  0740DF  2C4F: 0bc0             or ax, ax
  0740E1  2C51: 7503             jne 0x2c56
  0740E3  2C53: e9e601           jmp 0x2e3c
  0740E6  2C56: ff365e01         push word ptr [0x15e]
  0740EA  2C5A: ff365c01         push word ptr [0x15c]
  0740EE  2C5E: 6a00             push 0
  0740F0  2C60: 6a01             push 1
  0740F2  2C62: a18001           mov ax, word ptr [0x180]
  0740F5  2C65: 8b168201         mov dx, word ptr [0x182]
  0740F9  2C69: 8b5e9c           mov bx, word ptr [bp - 0x64]
  0740FC  2C6C: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  074101  2C71: 0bd0             or dx, ax
  074103  2C73: 7503             jne 0x2c78
  074105  2C75: e9c401           jmp 0x2e3c
  074108  2C78: ff366201         push word ptr [0x162]
  07410C  2C7C: ff366001         push word ptr [0x160]
  074110  2C80: 6a00             push 0
  074112  2C82: 6a01             push 1
  074114  2C84: a18001           mov ax, word ptr [0x180]
  074117  2C87: 8b168201         mov dx, word ptr [0x182]
  07411B  2C8B: 8b5e9c           mov bx, word ptr [bp - 0x64]
  07411E  2C8E: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  074123  2C93: 0bd0             or dx, ax
  074125  2C95: 7503             jne 0x2c9a
  074127  2C97: e9a201           jmp 0x2e3c
  07412A  2C9A: ff366601         push word ptr [0x166]
  07412E  2C9E: ff366401         push word ptr [0x164]
  074132  2CA2: 6a00             push 0
  074134  2CA4: 6a01             push 1
  074136  2CA6: a18001           mov ax, word ptr [0x180]
  074139  2CA9: 8b168201         mov dx, word ptr [0x182]
  07413D  2CAD: 8b5e9c           mov bx, word ptr [bp - 0x64]
  074140  2CB0: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  074145  2CB5: 0bd0             or dx, ax
  074147  2CB7: 7503             jne 0x2cbc
  074149  2CB9: e98001           jmp 0x2e3c
  07414C  2CBC: ff366a01         push word ptr [0x16a]
  074150  2CC0: ff366801         push word ptr [0x168]
  074154  2CC4: 6a00             push 0
  074156  2CC6: 6a01             push 1
  074158  2CC8: a18001           mov ax, word ptr [0x180]
  07415B  2CCB: 8b168201         mov dx, word ptr [0x182]
  07415F  2CCF: 8b5e9c           mov bx, word ptr [bp - 0x64]
  074162  2CD2: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  074167  2CD7: 0bd0             or dx, ax
  074169  2CD9: 7503             jne 0x2cde
  07416B  2CDB: e95e01           jmp 0x2e3c
  07416E  2CDE: 1e               push ds
  07416F  2CDF: 68f686           push 0x86f6
  074172  2CE2: 6a00             push 0
  074174  2CE4: 6a01             push 1
  074176  2CE6: b80e01           mov ax, 0x10e
  074179  2CE9: 99               cdq 
  07417A  2CEA: 8b5e9c           mov bx, word ptr [bp - 0x64]
  07417D  2CED: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  074182  2CF2: 0bd0             or dx, ax
  074184  2CF4: 7503             jne 0x2cf9
  074186  2CF6: e94301           jmp 0x2e3c
  074189  2CF9: 1e               push ds
  07418A  2CFA: 68e885           push 0x85e8
  07418D  2CFD: 6a00             push 0
  07418F  2CFF: 6a01             push 1
  074191  2D01: b80e01           mov ax, 0x10e
  074194  2D04: 99               cdq 
  074195  2D05: 8b5e9c           mov bx, word ptr [bp - 0x64]
  074198  2D08: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  07419D  2D0D: 0bd0             or dx, ax
  07419F  2D0F: 7503             jne 0x2d14
  0741A1  2D11: e92801           jmp 0x2e3c
  0741A4  2D14: 1e               push ds
  0741A5  2D15: 685e94           push 0x945e
  0741A8  2D18: 6a00             push 0
  0741AA  2D1A: 6a01             push 1
  0741AC  2D1C: b82000           mov ax, 0x20
  0741AF  2D1F: 99               cdq 
  0741B0  2D20: 8b5e9c           mov bx, word ptr [bp - 0x64]
  0741B3  2D23: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  0741B8  2D28: 0bd0             or dx, ax
  0741BA  2D2A: 7503             jne 0x2d2f
  0741BC  2D2C: e90d01           jmp 0x2e3c
  0741BF  2D2F: 1e               push ds
  0741C0  2D30: 68c885           push 0x85c8
  0741C3  2D33: 6a00             push 0
  0741C5  2D35: 6a01             push 1
  0741C7  2D37: b82000           mov ax, 0x20
  0741CA  2D3A: 99               cdq 
  0741CB  2D3B: 8b5e9c           mov bx, word ptr [bp - 0x64]
  0741CE  2D3E: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  0741D3  2D43: 0bd0             or dx, ax
  0741D5  2D45: 7503             jne 0x2d4a
  0741D7  2D47: e9f200           jmp 0x2e3c
  0741DA  2D4A: 8d469e           lea ax, [bp - 0x62]
  0741DD  2D4D: 16               push ss
  0741DE  2D4E: 50               push ax
  0741DF  2D4F: 6a00             push 0
  0741E1  2D51: 6a01             push 1
  0741E3  2D53: b80400           mov ax, 4
  0741E6  2D56: 99               cdq 
  0741E7  2D57: 8b5e9c           mov bx, word ptr [bp - 0x64]
  0741EA  2D5A: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  0741EF  2D5F: 0bd0             or dx, ax
  0741F1  2D61: 7503             jne 0x2d66
  0741F3  2D63: e9d600           jmp 0x2e3c
  0741F6  2D66: 1e               push ds
  0741F7  2D67: 68808d           push 0x8d80
  0741FA  2D6A: 6a00             push 0
  0741FC  2D6C: 6a01             push 1
  0741FE  2D6E: b80400           mov ax, 4
  074201  2D71: 99               cdq 
  074202  2D72: 8b5e9c           mov bx, word ptr [bp - 0x64]
  074205  2D75: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  07420A  2D7A: 0bd0             or dx, ax
  07420C  2D7C: 7503             jne 0x2d81
  07420E  2D7E: e9bb00           jmp 0x2e3c
  074211  2D81: 1e               push ds
  074212  2D82: 689001           push 0x190
  074215  2D85: 6a00             push 0
  074217  2D87: 6a01             push 1
  074219  2D89: b80200           mov ax, 2
  07421C  2D8C: 99               cdq 
  07421D  2D8D: 8b5e9c           mov bx, word ptr [bp - 0x64]
  074220  2D90: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  074225  2D95: 0bd0             or dx, ax
  074227  2D97: 7503             jne 0x2d9c
  074229  2D99: e9a000           jmp 0x2e3c
  07422C  2D9C: 68221b           push 0x1b22
  07422F  2D9F: 680000           push 0
  074232  2DA2: 6a00             push 0
  074234  2DA4: 6a01             push 1
  074236  2DA6: b87803           mov ax, 0x378
  074239  2DA9: 99               cdq 
  07423A  2DAA: 8b5e9c           mov bx, word ptr [bp - 0x64]
  07423D  2DAD: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  074242  2DB2: 0bd0             or dx, ax
  074244  2DB4: 7503             jne 0x2db9
  074246  2DB6: e98300           jmp 0x2e3c
  074249  2DB9: a08653           mov al, byte ptr [0x5386]
  07424C  2DBC: 250200           and ax, 2
  07424F  2DBF: a3a200           mov word ptr [0xa2], ax
  074252  2DC2: 8a0e8653         mov cl, byte ptr [0x5386]
  074256  2DC6: 83e104           and cx, 4
  074259  2DC9: 890ea000         mov word ptr [0xa0], cx
  07425D  2DCD: 8a168653         mov dl, byte ptr [0x5386]
  074261  2DD1: 83e208           and dx, 8
  074264  2DD4: 8916a400         mov word ptr [0xa4], dx
  074268  2DD8: 0bc9             or cx, cx
  07426A  2DDA: 7408             je 0x2de4
  07426C  2DDC: 0bc0             or ax, ax
  07426E  2DDE: 7404             je 0x2de4
  074270  2DE0: 0bd2             or dx, dx
  074272  2DE2: 750a             jne 0x2dee
  074274  2DE4: 6a01             push 1
  074276  2DE6: 9ade041f18       lcall 0x181f, 0x4de
  07427B  2DEB: 83c402           add sp, 2
  07427E  2DEE: ff36a683         push word ptr [0x83a6]
  074282  2DF2: 9aca041f18       lcall 0x181f, 0x4ca
  074287  2DF7: 83c402           add sp, 2
  07428A  2DFA: f606825301       test byte ptr [0x5382], 1
  07428F  2DFF: 7407             je 0x2e08
  074291  2E01: 9ad2001f1a       lcall 0x1a1f, 0xd2
  074296  2E06: eb05             jmp 0x2e0d
  074298  2E08: 9ae0001f1a       lcall 0x1a1f, 0xe0
  07429D  2E0D: a19808           mov ax, word ptr [0x898]
  0742A0  2E10: 0b069608         or ax, word ptr [0x896]
  0742A4  2E14: 7421             je 0x2e37
  0742A6  2E16: 8a268353         mov ah, byte ptr [0x5383]
  0742AA  2E1A: 250020           and ax, 0x2000
  0742AD  2E1D: 3d0100           cmp ax, 1
  0742B0  2E20: 1bc0             sbb ax, ax
  0742B2  2E22: f7d8             neg ax
  0742B4  2E24: 50               push ax
  0742B5  2E25: 6a06             push 6
  0742B7  2E27: ff369808         push word ptr [0x898]
  0742BB  2E2B: ff369608         push word ptr [0x896]
  0742BF  2E2F: 9a5c041f19       lcall 0x191f, 0x45c
  0742C4  2E34: 83c408           add sp, 8
  0742C7  2E37: c746aa0000       mov word ptr [bp - 0x56], 0
  0742CC  2E3C: 837e9c00         cmp word ptr [bp - 0x64], 0
  0742D0  2E40: 740b             je 0x2e4d
  0742D2  2E42: ff769c           push word ptr [bp - 0x64]
  0742D5  2E45: 9af4031d0d       lcall 0xd1d, 0x3f4
  0742DA  2E4A: 83c402           add sp, 2
  0742DD  2E4D: 837ea400         cmp word ptr [bp - 0x5c], 0
  0742E1  2E51: 7435             je 0x2e88
  0742E3  2E53: 837eaa00         cmp word ptr [bp - 0x56], 0
  0742E7  2E57: 742f             je 0x2e88
  0742E9  2E59: ff365e01         push word ptr [0x15e]
  0742ED  2E5D: ff365c01         push word ptr [0x15c]
  0742F1  2E61: 9aa8011f19       lcall 0x191f, 0x1a8
  0742F6  2E66: ff366201         push word ptr [0x162]
  0742FA  2E6A: ff366001         push word ptr [0x160]
  0742FE  2E6E: 9aa8011f19       lcall 0x191f, 0x1a8
  074303  2E73: ff366601         push word ptr [0x166]
  074307  2E77: ff366401         push word ptr [0x164]
  07430B  2E7B: 9aa8011f19       lcall 0x191f, 0x1a8
  074310  2E80: 2bc0             sub ax, ax
  074312  2E82: a38201           mov word ptr [0x182], ax
  074315  2E85: a38001           mov word ptr [0x180], ax
  074318  2E88: 8b46aa           mov ax, word ptr [bp - 0x56]
  07431B  2E8B: c9               leave 
  07431C  2E8C: cb               retf 

; ---- func_07431E  size=722  insns=237  prologue=ENTER 0x0060,0  terminal=RETF ----
  07431E  2E8E: c8600000         enter 0x60, 0
  074322  2E92: 57               push di
  074323  2E93: 56               push si
  074324  2E94: c746f40100       mov word ptr [bp - 0xc], 1
  074329  2E99: 803e280800       cmp byte ptr [0x828], 0
  07432E  2E9E: 750c             jne 0x2eac
  074330  2EA0: 9a660b1f1a       lcall 0x1a1f, 0xb66
  074335  2EA5: 0bc0             or ax, ax
  074337  2EA7: 7408             je 0x2eb1
  074339  2EA9: e9ad02           jmp 0x3159
  07433C  2EAC: c606a65302       mov byte ptr [0x53a6], 2
  074341  2EB1: 803ea65300       cmp byte ptr [0x53a6], 0
  074346  2EB6: 7505             jne 0x2ebd
  074348  2EB8: 800e825380       or byte ptr [0x5382], 0x80
  07434D  2EBD: 803e280800       cmp byte ptr [0x828], 0
  074352  2EC2: 750c             jne 0x2ed0
  074354  2EC4: 9a740b1f1a       lcall 0x1a1f, 0xb74
  074359  2EC9: 0bc0             or ax, ax
  07435B  2ECB: 7412             je 0x2edf
  07435D  2ECD: e98902           jmp 0x3159
  074360  2ED0: 6a03             push 3
  074362  2ED2: 6a00             push 0
  074364  2ED4: 9ad4041f18       lcall 0x181f, 0x4d4
  074369  2ED9: 83c404           add sp, 4
  07436C  2EDC: a39853           mov word ptr [0x5398], ax
  07436F  2EDF: a19853           mov ax, word ptr [0x5398]
  074372  2EE2: 8946f6           mov word ptr [bp - 0xa], ax
  074375  2EE5: 3d0300           cmp ax, 3
  074378  2EE8: 7e06             jle 0x2ef0
  07437A  2EEA: c70698530000     mov word ptr [0x5398], 0
  074380  2EF0: 803e280800       cmp byte ptr [0x828], 0
  074385  2EF5: 7403             je 0x2efa
  074387  2EF7: e97401           jmp 0x306e
  07438A  2EFA: 6a00             push 0
  07438C  2EFC: ff36a483         push word ptr [0x83a4]
  074390  2F00: ff36a283         push word ptr [0x83a2]
  074394  2F04: ff36a083         push word ptr [0x83a0]
  074398  2F08: ff369e83         push word ptr [0x839e]
  07439C  2F0C: 688921           push 0x2189
  07439F  2F0F: 9a7a081f19       lcall 0x191f, 0x87a
  0743A4  2F14: 83c40c           add sp, 0xc
  0743A7  2F17: 3d0100           cmp ax, 1
  0743AA  2F1A: 1bc0             sbb ax, ax
  0743AC  2F1C: f7d8             neg ax
  0743AE  2F1E: 8946fe           mov word ptr [bp - 2], ax
  0743B1  2F21: 0bc0             or ax, ax
  0743B3  2F23: 7445             je 0x2f6a
  0743B5  2F25: 9a0a041f18       lcall 0x181f, 0x40a
  0743BA  2F2A: ff36a483         push word ptr [0x83a4]
  0743BE  2F2E: ff36a283         push word ptr [0x83a2]
  0743C2  2F32: ff36a083         push word ptr [0x83a0]
  0743C6  2F36: ff369e83         push word ptr [0x839e]
  0743CA  2F3A: ff36ae2d         push word ptr [0x2dae]
  0743CE  2F3E: ff36ac2d         push word ptr [0x2dac]
  0743D2  2F42: ff36aa2d         push word ptr [0x2daa]
  0743D6  2F46: ff36a82d         push word ptr [0x2da8]
  0743DA  2F4A: 68c800           push 0xc8
  0743DD  2F4D: 2bc0             sub ax, ax
  0743DF  2F4F: 99               cdq 
  0743E0  2F50: bb4001           mov bx, 0x140
  0743E3  2F53: 9a44041f18       lcall 0x181f, 0x444
  0743E8  2F58: 6a00             push 0
  0743EA  2F5A: 684001           push 0x140
  0743ED  2F5D: 68c800           push 0xc8
  0743F0  2F60: 2bc0             sub ax, ax
  0743F2  2F62: 99               cdq 
  0743F3  2F63: 2bdb             sub bx, bx
  0743F5  2F65: 9ae2001f18       lcall 0x181f, 0xe2
  0743FA  2F6A: 6a17             push 0x17
  0743FC  2F6C: 6b16985334       imul dx, word ptr [0x5398], 0x34
  074401  2F71: 81c20e54         add dx, 0x540e
  074405  2F75: 8d1e7c08         lea bx, [0x87c]
  074409  2F79: 8d069221         lea ax, [0x2192]
  07440D  2F7D: 9a20011f19       lcall 0x191f, 0x120
  074412  2F82: 0bc0             or ax, ax
  074414  2F84: 7403             je 0x2f89
  074416  2F86: e9d001           jmp 0x3159
  074419  2F89: 682098           push 0x9820
  07441C  2F8C: 8d46a0           lea ax, [bp - 0x60]
  07441F  2F8F: 50               push ax
  074420  2F90: 9ae4071d0d       lcall 0xd1d, 0x7e4
  074425  2F95: 83c404           add sp, 4
  074428  2F98: 8d46a0           lea ax, [bp - 0x60]
  07442B  2F9B: 16               push ss
  07442C  2F9C: 50               push ax
  07442D  2F9D: 6b0e985334       imul cx, word ptr [0x5398], 0x34
  074432  2FA2: 81c10e54         add cx, 0x540e
  074436  2FA6: 1e               push ds
  074437  2FA7: 51               push cx
  074438  2FA8: 9a7e111d0d       lcall 0xd1d, 0x117e
  07443D  2FAD: 83c408           add sp, 8
  074440  2FB0: 689d21           push 0x219d
  074443  2FB3: 8d46a0           lea ax, [bp - 0x60]
  074446  2FB6: 50               push ax
  074447  2FB7: 9ae4071d0d       lcall 0xd1d, 0x7e4
  07444C  2FBC: 83c404           add sp, 4
  07444F  2FBF: a09853           mov al, byte ptr [0x5398]
  074452  2FC2: 0046a6           add byte ptr [bp - 0x5a], al
  074455  2FC5: 837efe00         cmp word ptr [bp - 2], 0
  074459  2FC9: 7445             je 0x3010
  07445B  2FCB: 9a0a041f18       lcall 0x181f, 0x40a
  074460  2FD0: ff36a483         push word ptr [0x83a4]
  074464  2FD4: ff36a283         push word ptr [0x83a2]
  074468  2FD8: ff36a083         push word ptr [0x83a0]
  07446C  2FDC: ff369e83         push word ptr [0x839e]
  074470  2FE0: ff36ae2d         push word ptr [0x2dae]
  074474  2FE4: ff36ac2d         push word ptr [0x2dac]
  074478  2FE8: ff36aa2d         push word ptr [0x2daa]
  07447C  2FEC: ff36a82d         push word ptr [0x2da8]
  074480  2FF0: 68c800           push 0xc8
  074483  2FF3: 2bc0             sub ax, ax
  074485  2FF5: 99               cdq 
  074486  2FF6: bb4001           mov bx, 0x140
  074489  2FF9: 9a44041f18       lcall 0x181f, 0x444
  07448E  2FFE: 6a00             push 0
  074490  3000: 684001           push 0x140
  074493  3003: 68c800           push 0xc8
  074496  3006: 2bc0             sub ax, ax
  074498  3008: 99               cdq 
  074499  3009: 2bdb             sub bx, bx
  07449B  300B: 9ae2001f18       lcall 0x181f, 0xe2
  0744A0  3010: 8d5ea0           lea bx, [bp - 0x60]
  0744A3  3013: 9afe031f18       lcall 0x181f, 0x3fe
  0744A8  3018: fe46a7           inc byte ptr [bp - 0x59]
  0744AB  301B: 837efe00         cmp word ptr [bp - 2], 0
  0744AF  301F: 7445             je 0x3066
  0744B1  3021: 9a0a041f18       lcall 0x181f, 0x40a
  0744B6  3026: ff36a483         push word ptr [0x83a4]
  0744BA  302A: ff36a283         push word ptr [0x83a2]
  0744BE  302E: ff36a083         push word ptr [0x83a0]
  0744C2  3032: ff369e83         push word ptr [0x839e]
  0744C6  3036: ff36ae2d         push word ptr [0x2dae]
  0744CA  303A: ff36ac2d         push word ptr [0x2dac]
  0744CE  303E: ff36aa2d         push word ptr [0x2daa]
  0744D2  3042: ff36a82d         push word ptr [0x2da8]
  0744D6  3046: 68c800           push 0xc8
  0744D9  3049: 2bc0             sub ax, ax
  0744DB  304B: 99               cdq 
  0744DC  304C: bb4001           mov bx, 0x140
  0744DF  304F: 9a44041f18       lcall 0x181f, 0x444
  0744E4  3054: 6a00             push 0
  0744E6  3056: 684001           push 0x140
  0744E9  3059: 68c800           push 0xc8
  0744EC  305C: 2bc0             sub ax, ax
  0744EE  305E: 99               cdq 
  0744EF  305F: 2bdb             sub bx, bx
  0744F1  3061: 9ae2001f18       lcall 0x181f, 0xe2
  0744F6  3066: 8d5ea0           lea bx, [bp - 0x60]
  0744F9  3069: 9afe031f18       lcall 0x181f, 0x3fe
  0744FE  306E: be3f54           mov si, 0x543f
  074501  3071: bf3288           mov di, 0x8832
  074504  3074: c60401           mov byte ptr [si], 1
  074507  3077: 81c73c01         add di, 0x13c
  07450B  307B: 2bc0             sub ax, ax
  07450D  307D: 8985c6fe         mov word ptr [di - 0x13a], ax
  074511  3081: 8985c4fe         mov word ptr [di - 0x13c], ax
  074515  3085: c644ff00         mov byte ptr [si - 1], 0
  074519  3089: 83c634           add si, 0x34
  07451C  308C: 81ff228d         cmp di, 0x8d22
  074520  3090: 72e2             jb 0x3074
  074522  3092: 8b5ef6           mov bx, word ptr [bp - 0xa]
  074525  3095: 83fb04           cmp bx, 4
  074528  3098: 7403             je 0x309d
  07452A  309A: e9af00           jmp 0x314c
  07452D  309D: 8d1e7c08         lea bx, [0x87c]
  074531  30A1: 8d06a621         lea ax, [0x21a6]
  074535  30A5: 2bd2             sub dx, dx
  074537  30A7: 9a82011f19       lcall 0x191f, 0x182
  07453C  30AC: 8bf8             mov di, ax
  07453E  30AE: 8956f2           mov word ptr [bp - 0xe], dx
  074541  30B1: 0bd0             or dx, ax
  074543  30B3: 7503             jne 0x30b8
  074545  30B5: e9a100           jmp 0x3159
  074548  30B8: 2bf6             sub si, si
  07454A  30BA: 897ef0           mov word ptr [bp - 0x10], di
  07454D  30BD: 6a01             push 1
  07454F  30BF: 8d4401           lea ax, [si + 1]
  074552  30C2: 50               push ax
  074553  30C3: 56               push si
  074554  30C4: 9a240a1f18       lcall 0x181f, 0xa24
  074559  30C9: 83c402           add sp, 2
  07455C  30CC: 50               push ax
  07455D  30CD: 9a22001f18       lcall 0x181f, 0x22
  074562  30D2: 83c402           add sp, 2
  074565  30D5: 52               push dx
  074566  30D6: 50               push ax
  074567  30D7: ff76f2           push word ptr [bp - 0xe]
  07456A  30DA: 57               push di
  07456B  30DB: 9afe0a1f1a       lcall 0x1a1f, 0xafe
  074570  30E0: 83c40c           add sp, 0xc
  074573  30E3: 8d4401           lea ax, [si + 1]
  074576  30E6: 8bf0             mov si, ax
  074578  30E8: 83fe04           cmp si, 4
  07457B  30EB: 7cd0             jl 0x30bd
  07457D  30ED: 8b46f2           mov ax, word ptr [bp - 0xe]
  074580  30F0: 50               push ax
  074581  30F1: 57               push di
  074582  30F2: 8bf0             mov si, ax
  074584  30F4: 9a6a011f19       lcall 0x191f, 0x16a
  074589  30F9: 56               push si
  07458A  30FA: 57               push di
  07458B  30FB: 9aa8011f19       lcall 0x191f, 0x1a8
  074590  3100: 2bf6             sub si, si
  074592  3102: 8976fe           mov word ptr [bp - 2], si
  074595  3105: c746fc3f54       mov word ptr [bp - 4], 0x543f
  07459A  310A: 8bd6             mov dx, si
  07459C  310C: 8b5efc           mov bx, word ptr [bp - 4]
  07459F  310F: 8976f6           mov word ptr [bp - 0xa], si
  0745A2  3112: 8bfe             mov di, si
  0745A4  3114: 8bca             mov cx, dx
  0745A6  3116: b80100           mov ax, 1
  0745A9  3119: d3e0             shl ax, cl
  0745AB  311B: 8506541f         test word ptr [0x1f54], ax
  0745AF  311F: 7408             je 0x3129
  0745B1  3121: 47               inc di
  0745B2  3122: 89169853         mov word ptr [0x5398], dx
  0745B6  3126: c60700           mov byte ptr [bx], 0
  0745B9  3129: 42               inc dx
  0745BA  312A: 83c334           add bx, 0x34
  0745BD  312D: 81fb0f55         cmp bx, 0x550f
  0745C1  3131: 72e1             jb 0x3114
  0745C3  3133: 0bff             or di, di
  0745C5  3135: 7509             jne 0x3140
  0745C7  3137: 893e9853         mov word ptr [0x5398], di
  0745CB  313B: c6063f5400       mov byte ptr [0x543f], 0
  0745D0  3140: 83ff01           cmp di, 1
  0745D3  3143: 7e0f             jle 0x3154
  0745D5  3145: 800e815380       or byte ptr [0x5381], 0x80
  0745DA  314A: eb08             jmp 0x3154
  0745DC  314C: 6bdb34           imul bx, bx, 0x34
  0745DF  314F: c6873f5400       mov byte ptr [bx + 0x543f], 0
  0745E4  3154: c746f40000       mov word ptr [bp - 0xc], 0
  0745E9  3159: 8b46f4           mov ax, word ptr [bp - 0xc]
  0745EC  315C: 5e               pop si
  0745ED  315D: 5f               pop di
  0745EE  315E: c9               leave 
  0745EF  315F: cb               retf 

; ---- func_0745F0  size=91  insns=31  prologue=push bp;mov bp,sp  terminal=RETF ----
  0745F0  3160: 55               push bp
  0745F1  3161: 8bec             mov bp, sp
  0745F3  3163: 57               push di
  0745F4  3164: 56               push si
  0745F5  3165: 8b7e06           mov di, word ptr [bp + 6]
  0745F8  3168: 9a1c091f19       lcall 0x191f, 0x91c
  0745FD  316D: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074602  3172: 8bdf             mov bx, di
  074604  3174: c1e304           shl bx, 4
  074607  3177: 8987742f         mov word ptr [bx + 0x2f74], ax
  07460B  317B: 8bf3             mov si, bx
  07460D  317D: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074612  3182: 8884762f         mov byte ptr [si + 0x2f76], al
  074616  3186: 9a8a081f1a       lcall 0x1a1f, 0x88a
  07461B  318B: 8884772f         mov byte ptr [si + 0x2f77], al
  07461F  318F: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074624  3194: 8884782f         mov byte ptr [si + 0x2f78], al
  074628  3198: 9a8a081f1a       lcall 0x1a1f, 0x88a
  07462D  319D: 8884792f         mov byte ptr [si + 0x2f79], al
  074631  31A1: 2bf6             sub si, si
  074633  31A3: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074638  31A8: 8bdf             mov bx, di
  07463A  31AA: c1e304           shl bx, 4
  07463D  31AD: 88807b2f         mov byte ptr [bx + si + 0x2f7b], al
  074641  31B1: 46               inc si
  074642  31B2: 83fe09           cmp si, 9
  074645  31B5: 7cec             jl 0x31a3
  074647  31B7: 5e               pop si
  074648  31B8: 5f               pop di
  074649  31B9: c9               leave 
  07464A  31BA: cb               retf 

; ---- func_07464C  size=60  insns=24  prologue=push bp;mov bp,sp  terminal=RETF imm16 ----
  07464C  31BC: 55               push bp
  07464D  31BD: 8bec             mov bp, sp
  07464F  31BF: 53               push bx
  074650  31C0: 56               push si
  074651  31C1: 8b4e06           mov cx, word ptr [bp + 6]
  074654  31C4: 8bf0             mov si, ax
  074656  31C6: 8bc2             mov ax, dx
  074658  31C8: 8bd6             mov dx, si
  07465A  31CA: d1e6             shl si, 1
  07465C  31CC: 03f2             add si, dx
  07465E  31CE: c1e602           shl si, 2
  074661  31D1: 8884858f         mov byte ptr [si - 0x707b], al
  074665  31D5: 8a46fe           mov al, byte ptr [bp - 2]
  074668  31D8: 8884848f         mov byte ptr [si - 0x707c], al
  07466C  31DC: 8a4608           mov al, byte ptr [bp + 8]
  07466F  31DF: 8884868f         mov byte ptr [si - 0x707a], al
  074673  31E3: 8bc1             mov ax, cx
  074675  31E5: 888c888f         mov byte ptr [si - 0x7078], cl
  074679  31E9: 8bd9             mov bx, cx
  07467B  31EB: 8a84878f         mov al, byte ptr [si - 0x7079]
  07467F  31EF: 8887628d         mov byte ptr [bx - 0x729e], al
  074683  31F3: 5e               pop si
  074684  31F4: c9               leave 
  074685  31F5: ca0400           retf 4

; ---- func_074688  size=856  insns=364  prologue=push bp;mov bp,sp  terminal=RETF ----
  074688  31F8: 55               push bp
  074689  31F9: 8bec             mov bp, sp
  07468B  31FB: 53               push bx
  07468C  31FC: 56               push si
  07468D  31FD: 8bca             mov cx, dx
  07468F  31FF: 8b7606           mov si, word ptr [bp + 6]
  074692  3202: 8bd6             mov dx, si
  074694  3204: d1e6             shl si, 1
  074696  3206: 03f2             add si, dx
  074698  3208: d1e6             shl si, 1
  07469A  320A: 88848c97         mov byte ptr [si - 0x6874], al
  07469E  320E: 888c8d97         mov byte ptr [si - 0x6873], cl
  0746A2  3212: 8a460a           mov al, byte ptr [bp + 0xa]
  0746A5  3215: 88848e97         mov byte ptr [si - 0x6872], al
  0746A9  3219: 8b46fe           mov ax, word ptr [bp - 2]
  0746AC  321C: 89849097         mov word ptr [si - 0x6870], ax
  0746B0  3220: 8a4608           mov al, byte ptr [bp + 8]
  0746B3  3223: 88848f97         mov byte ptr [si - 0x6871], al
  0746B7  3227: 5e               pop si
  0746B8  3228: c9               leave 
  0746B9  3229: ca0600           retf 6
  0746BC  322C: 6a01             push 1
  0746BE  322E: 6a00             push 0
  0746C0  3230: 2bc0             sub ax, ax
  0746C2  3232: baffff           mov dx, 0xffff
  0746C5  3235: 8bda             mov bx, dx
  0746C7  3237: 0e               push cs
  0746C8  3238: e8b91c           call 0x4ef4
  0746CB  323B: 6a02             push 2
  0746CD  323D: 6a00             push 0
  0746CF  323F: b80100           mov ax, 1
  0746D2  3242: 99               cdq 
  0746D3  3243: bbffff           mov bx, 0xffff
  0746D6  3246: 0e               push cs
  0746D7  3247: e8aa1c           call 0x4ef4
  0746DA  324A: 6aff             push -1
  0746DC  324C: 6a00             push 0
  0746DE  324E: b80200           mov ax, 2
  0746E1  3251: ba0100           mov dx, 1
  0746E4  3254: bbffff           mov bx, 0xffff
  0746E7  3257: 0e               push cs
  0746E8  3258: e8991c           call 0x4ef4
  0746EB  325B: 6a04             push 4
  0746ED  325D: 6a01             push 1
  0746EF  325F: b80300           mov ax, 3
  0746F2  3262: baffff           mov dx, 0xffff
  0746F5  3265: 8bda             mov bx, dx
  0746F7  3267: 0e               push cs
  0746F8  3268: e8891c           call 0x4ef4
  0746FB  326B: 6a05             push 5
  0746FD  326D: 6a01             push 1
  0746FF  326F: b80400           mov ax, 4
  074702  3272: ba0300           mov dx, 3
  074705  3275: bbffff           mov bx, 0xffff
  074708  3278: 0e               push cs
  074709  3279: e8781c           call 0x4ef4
  07470C  327C: 6aff             push -1
  07470E  327E: 6a01             push 1
  074710  3280: b80500           mov ax, 5
  074713  3283: ba0400           mov dx, 4
  074716  3286: bbffff           mov bx, 0xffff
  074719  3289: 0e               push cs
  07471A  328A: e8671c           call 0x4ef4
  07471D  328D: 6a07             push 7
  07471F  328F: 6a02             push 2
  074721  3291: b80600           mov ax, 6
  074724  3294: baffff           mov dx, 0xffff
  074727  3297: 8bda             mov bx, dx
  074729  3299: 0e               push cs
  07472A  329A: e8571c           call 0x4ef4
  07472D  329D: 6a08             push 8
  07472F  329F: 6a02             push 2
  074731  32A1: b80700           mov ax, 7
  074734  32A4: ba0600           mov dx, 6
  074737  32A7: bbffff           mov bx, 0xffff
  07473A  32AA: 0e               push cs
  07473B  32AB: e8461c           call 0x4ef4
  07473E  32AE: 6aff             push -1
  074740  32B0: 6a02             push 2
  074742  32B2: b80800           mov ax, 8
  074745  32B5: ba0700           mov dx, 7
  074748  32B8: bbffff           mov bx, 0xffff
  07474B  32BB: 0e               push cs
  07474C  32BC: e8351c           call 0x4ef4
  07474F  32BF: 6aff             push -1
  074751  32C1: 6a03             push 3
  074753  32C3: b80900           mov ax, 9
  074756  32C6: baffff           mov dx, 0xffff
  074759  32C9: 8bda             mov bx, dx
  07475B  32CB: 0e               push cs
  07475C  32CC: e8251c           call 0x4ef4
  07475F  32CF: 6a0b             push 0xb
  074761  32D1: 6a03             push 3
  074763  32D3: b80a00           mov ax, 0xa
  074766  32D6: ba0900           mov dx, 9
  074769  32D9: bbffff           mov bx, 0xffff
  07476C  32DC: 0e               push cs
  07476D  32DD: e8141c           call 0x4ef4
  074770  32E0: 6aff             push -1
  074772  32E2: 6a03             push 3
  074774  32E4: b80b00           mov ax, 0xb
  074777  32E7: ba0a00           mov dx, 0xa
  07477A  32EA: bbffff           mov bx, 0xffff
  07477D  32ED: 0e               push cs
  07477E  32EE: e8031c           call 0x4ef4
  074781  32F1: 6a1f             push 0x1f
  074783  32F3: 6a03             push 3
  074785  32F5: b81e00           mov ax, 0x1e
  074788  32F8: ba0b00           mov dx, 0xb
  07478B  32FB: bbffff           mov bx, 0xffff
  07478E  32FE: 0e               push cs
  07478F  32FF: e8f21b           call 0x4ef4
  074792  3302: 6aff             push -1
  074794  3304: 6a03             push 3
  074796  3306: b81f00           mov ax, 0x1f
  074799  3309: ba1e00           mov dx, 0x1e
  07479C  330C: bbffff           mov bx, 0xffff
  07479F  330F: 0e               push cs
  0747A0  3310: e8e11b           call 0x4ef4
  0747A3  3313: 6a0d             push 0xd
  0747A5  3315: 6a04             push 4
  0747A7  3317: b80c00           mov ax, 0xc
  0747AA  331A: baffff           mov dx, 0xffff
  0747AD  331D: 8bda             mov bx, dx
  0747AF  331F: 0e               push cs
  0747B0  3320: e8d11b           call 0x4ef4
  0747B3  3323: 6a0e             push 0xe
  0747B5  3325: 6a04             push 4
  0747B7  3327: b80d00           mov ax, 0xd
  0747BA  332A: ba0c00           mov dx, 0xc
  0747BD  332D: bbffff           mov bx, 0xffff
  0747C0  3330: 0e               push cs
  0747C1  3331: e8c01b           call 0x4ef4
  0747C4  3334: 6aff             push -1
  0747C6  3336: 6a04             push 4
  0747C8  3338: b80e00           mov ax, 0xe
  0747CB  333B: ba0d00           mov dx, 0xd
  0747CE  333E: bbffff           mov bx, 0xffff
  0747D1  3341: 0e               push cs
  0747D2  3342: e8af1b           call 0x4ef4
  0747D5  3345: 6a10             push 0x10
  0747D7  3347: 6a05             push 5
  0747D9  3349: b80f00           mov ax, 0xf
  0747DC  334C: baffff           mov dx, 0xffff
  0747DF  334F: 8bda             mov bx, dx
  0747E1  3351: 0e               push cs
  0747E2  3352: e89f1b           call 0x4ef4
  0747E5  3355: 6aff             push -1
  0747E7  3357: 6a05             push 5
  0747E9  3359: b81000           mov ax, 0x10
  0747EC  335C: ba0f00           mov dx, 0xf
  0747EF  335F: bbffff           mov bx, 0xffff
  0747F2  3362: 0e               push cs
  0747F3  3363: e88e1b           call 0x4ef4
  0747F6  3366: 6aff             push -1
  0747F8  3368: 6a05             push 5
  0747FA  336A: b81100           mov ax, 0x11
  0747FD  336D: baffff           mov dx, 0xffff
  074800  3370: 8bda             mov bx, dx
  074802  3372: 0e               push cs
  074803  3373: e87e1b           call 0x4ef4
  074806  3376: 6aff             push -1
  074808  3378: 6a06             push 6
  07480A  337A: b81200           mov ax, 0x12
  07480D  337D: baffff           mov dx, 0xffff
  074810  3380: 8bda             mov bx, dx
  074812  3382: 0e               push cs
  074813  3383: e86e1b           call 0x4ef4
  074816  3386: 6a14             push 0x14
  074818  3388: 6a07             push 7
  07481A  338A: b81300           mov ax, 0x13
  07481D  338D: baffff           mov dx, 0xffff
  074820  3390: 8bda             mov bx, dx
  074822  3392: 0e               push cs
  074823  3393: e85e1b           call 0x4ef4
  074826  3396: 6aff             push -1
  074828  3398: 6a07             push 7
  07482A  339A: b81400           mov ax, 0x14
  07482D  339D: ba1300           mov dx, 0x13
  074830  33A0: bbffff           mov bx, 0xffff
  074833  33A3: 0e               push cs
  074834  33A4: e84d1b           call 0x4ef4
  074837  33A7: 6a16             push 0x16
  074839  33A9: 6a08             push 8
  07483B  33AB: b81500           mov ax, 0x15
  07483E  33AE: baffff           mov dx, 0xffff
  074841  33B1: 8bda             mov bx, dx
  074843  33B3: 0e               push cs
  074844  33B4: e83d1b           call 0x4ef4
  074847  33B7: 6a17             push 0x17
  074849  33B9: 6a08             push 8
  07484B  33BB: b81600           mov ax, 0x16
  07484E  33BE: ba1500           mov dx, 0x15
  074851  33C1: bbffff           mov bx, 0xffff
  074854  33C4: 0e               push cs
  074855  33C5: e82c1b           call 0x4ef4
  074858  33C8: 6aff             push -1
  07485A  33CA: 6a08             push 8
  07485C  33CC: b81700           mov ax, 0x17
  07485F  33CF: ba1600           mov dx, 0x16
  074862  33D2: bbffff           mov bx, 0xffff
  074865  33D5: 0e               push cs
  074866  33D6: e81b1b           call 0x4ef4
  074869  33D9: 6a19             push 0x19
  07486B  33DB: 6a09             push 9
  07486D  33DD: b81800           mov ax, 0x18
  074870  33E0: baffff           mov dx, 0xffff
  074873  33E3: 8bda             mov bx, dx
  074875  33E5: 0e               push cs
  074876  33E6: e80b1b           call 0x4ef4
  074879  33E9: 6a1a             push 0x1a
  07487B  33EB: 6a09             push 9
  07487D  33ED: b81900           mov ax, 0x19
  074880  33F0: ba1800           mov dx, 0x18
  074883  33F3: bbffff           mov bx, 0xffff
  074886  33F6: 0e               push cs
  074887  33F7: e8fa1a           call 0x4ef4
  07488A  33FA: 6aff             push -1
  07488C  33FC: 6a09             push 9
  07488E  33FE: b81a00           mov ax, 0x1a
  074891  3401: ba1900           mov dx, 0x19
  074894  3404: bbffff           mov bx, 0xffff
  074897  3407: 0e               push cs
  074898  3408: e8e91a           call 0x4ef4
  07489B  340B: 6a1c             push 0x1c
  07489D  340D: 6a0a             push 0xa
  07489F  340F: b81b00           mov ax, 0x1b
  0748A2  3412: baffff           mov dx, 0xffff
  0748A5  3415: 8bda             mov bx, dx
  0748A7  3417: 0e               push cs
  0748A8  3418: e8d91a           call 0x4ef4
  0748AB  341B: 6a1d             push 0x1d
  0748AD  341D: 6a0a             push 0xa
  0748AF  341F: b81c00           mov ax, 0x1c
  0748B2  3422: ba1b00           mov dx, 0x1b
  0748B5  3425: bbffff           mov bx, 0xffff
  0748B8  3428: 0e               push cs
  0748B9  3429: e8c81a           call 0x4ef4
  0748BC  342C: 6aff             push -1
  0748BE  342E: 6a0a             push 0xa
  0748C0  3430: b81d00           mov ax, 0x1d
  0748C3  3433: ba1c00           mov dx, 0x1c
  0748C6  3436: bbffff           mov bx, 0xffff
  0748C9  3439: 0e               push cs
  0748CA  343A: e8b71a           call 0x4ef4
  0748CD  343D: 6a21             push 0x21
  0748CF  343F: 6a0b             push 0xb
  0748D1  3441: b82000           mov ax, 0x20
  0748D4  3444: baffff           mov dx, 0xffff
  0748D7  3447: 8bda             mov bx, dx
  0748D9  3449: 0e               push cs
  0748DA  344A: e8a71a           call 0x4ef4
  0748DD  344D: 6a22             push 0x22
  0748DF  344F: 6a0b             push 0xb
  0748E1  3451: b82100           mov ax, 0x21
  0748E4  3454: ba2000           mov dx, 0x20
  0748E7  3457: bbffff           mov bx, 0xffff
  0748EA  345A: 0e               push cs
  0748EB  345B: e8961a           call 0x4ef4
  0748EE  345E: 6aff             push -1
  0748F0  3460: 6a0b             push 0xb
  0748F2  3462: b82200           mov ax, 0x22
  0748F5  3465: ba2100           mov dx, 0x21
  0748F8  3468: bbffff           mov bx, 0xffff
  0748FB  346B: 0e               push cs
  0748FC  346C: e8851a           call 0x4ef4
  0748FF  346F: 6a24             push 0x24
  074901  3471: 6a0c             push 0xc
  074903  3473: b82300           mov ax, 0x23
  074906  3476: baffff           mov dx, 0xffff
  074909  3479: 8bda             mov bx, dx
  07490B  347B: 0e               push cs
  07490C  347C: e8751a           call 0x4ef4
  07490F  347F: 6aff             push -1
  074911  3481: 6a0c             push 0xc
  074913  3483: b82400           mov ax, 0x24
  074916  3486: ba2300           mov dx, 0x23
  074919  3489: bbffff           mov bx, 0xffff
  07491C  348C: 0e               push cs
  07491D  348D: e8641a           call 0x4ef4
  074920  3490: 6a26             push 0x26
  074922  3492: 6a0d             push 0xd
  074924  3494: b82500           mov ax, 0x25
  074927  3497: baffff           mov dx, 0xffff
  07492A  349A: 8bda             mov bx, dx
  07492C  349C: 0e               push cs
  07492D  349D: e8541a           call 0x4ef4
  074930  34A0: 6aff             push -1
  074932  34A2: 6a0d             push 0xd
  074934  34A4: b82600           mov ax, 0x26
  074937  34A7: ba2500           mov dx, 0x25
  07493A  34AA: bbffff           mov bx, 0xffff
  07493D  34AD: 0e               push cs
  07493E  34AE: e8431a           call 0x4ef4
  074941  34B1: 6a28             push 0x28
  074943  34B3: 6a0e             push 0xe
  074945  34B5: b82700           mov ax, 0x27
  074948  34B8: baffff           mov dx, 0xffff
  07494B  34BB: 8bda             mov bx, dx
  07494D  34BD: 0e               push cs
  07494E  34BE: e8331a           call 0x4ef4
  074951  34C1: 6a29             push 0x29
  074953  34C3: 6a0e             push 0xe
  074955  34C5: b82800           mov ax, 0x28
  074958  34C8: ba2700           mov dx, 0x27
  07495B  34CB: bbffff           mov bx, 0xffff
  07495E  34CE: 0e               push cs
  07495F  34CF: e8221a           call 0x4ef4
  074962  34D2: 6aff             push -1
  074964  34D4: 6a0e             push 0xe
  074966  34D6: b82900           mov ax, 0x29
  074969  34D9: ba2800           mov dx, 0x28
  07496C  34DC: bbffff           mov bx, 0xffff
  07496F  34DF: 0e               push cs
  074970  34E0: e8111a           call 0x4ef4
  074973  34E3: 6a02             push 2
  074975  34E5: 6aff             push -1
  074977  34E7: 6a00             push 0
  074979  34E9: 2bc0             sub ax, ax
  07497B  34EB: ba0b00           mov dx, 0xb
  07497E  34EE: bbf401           mov bx, 0x1f4
  074981  34F1: 0e               push cs
  074982  34F2: e8091a           call 0x4efe
  074985  34F5: 6a02             push 2
  074987  34F7: 6aff             push -1
  074989  34F9: 6a01             push 1
  07498B  34FB: 2bc0             sub ax, ax
  07498D  34FD: ba0d00           mov dx, 0xd
  074990  3500: bbe803           mov bx, 0x3e8
  074993  3503: 0e               push cs
  074994  3504: e8f719           call 0x4efe
  074997  3507: 6a04             push 4
  074999  3509: 6aff             push -1
  07499B  350B: 6a02             push 2
  07499D  350D: 2bc0             sub ax, ax
  07499F  350F: ba0e00           mov dx, 0xe
  0749A2  3512: bbd007           mov bx, 0x7d0
  0749A5  3515: 0e               push cs
  0749A6  3516: e8e519           call 0x4efe
  0749A9  3519: 6a06             push 6
  0749AB  351B: 6aff             push -1
  0749AD  351D: 6a03             push 3
  0749AF  351F: 2bc0             sub ax, ax
  0749B1  3521: ba0f00           mov dx, 0xf
  0749B4  3524: bbb80b           mov bx, 0xbb8
  0749B7  3527: 0e               push cs
  0749B8  3528: e8d319           call 0x4efe
  0749BB  352B: 6a03             push 3
  0749BD  352D: 6aff             push -1
  0749BF  352F: 6a04             push 4
  0749C1  3531: 2bc0             sub ax, ax
  0749C3  3533: ba1000           mov dx, 0x10
  0749C6  3536: bbd007           mov bx, 0x7d0
  0749C9  3539: 0e               push cs
  0749CA  353A: e8c119           call 0x4efe
  0749CD  353D: 6a08             push 8
  0749CF  353F: 6aff             push -1
  0749D1  3541: 6a05             push 5
  0749D3  3543: 2bc0             sub ax, ax
  0749D5  3545: ba1100           mov dx, 0x11
  0749D8  3548: bb8813           mov bx, 0x1388
  0749DB  354B: 0e               push cs
  0749DC  354C: e8af19           call 0x4efe
  0749DF  354F: cb               retf 

; ---- func_0749E0  size=2417  insns=703  prologue=ENTER 0x000E,0  terminal=RETF ----
  0749E0  3550: c80e0000         enter 0xe, 0
  0749E4  3554: 57               push di
  0749E5  3555: 56               push si
  0749E6  3556: 6a00             push 0
  0749E8  3558: 682c1a           push 0x1a2c
  0749EB  355B: 9a0e001f18       lcall 0x181f, 0xe
  0749F0  3560: 83c404           add sp, 4
  0749F3  3563: 68ac21           push 0x21ac
  0749F6  3566: 688208           push 0x882
  0749F9  3569: 9a28091f19       lcall 0x191f, 0x928
  0749FE  356E: 83c404           add sp, 4
  074A01  3571: c746f80000       mov word ptr [bp - 8], 0
  074A06  3576: 9a1c091f19       lcall 0x191f, 0x91c
  074A0B  357B: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074A10  3580: 8b5ef8           mov bx, word ptr [bp - 8]
  074A13  3583: d1e3             shl bx, 1
  074A15  3585: 89870098         mov word ptr [bx - 0x6800], ax
  074A19  3589: ff46f8           inc word ptr [bp - 8]
  074A1C  358C: 837ef802         cmp word ptr [bp - 8], 2
  074A20  3590: 7ce4             jl 0x3576
  074A22  3592: 68b421           push 0x21b4
  074A25  3595: 6a00             push 0
  074A27  3597: 9a28091f19       lcall 0x191f, 0x928
  074A2C  359C: 83c404           add sp, 4
  074A2F  359F: c746f80000       mov word ptr [bp - 8], 0
  074A34  35A4: ff76f8           push word ptr [bp - 8]
  074A37  35A7: 0e               push cs
  074A38  35A8: e84419           call 0x4eef
  074A3B  35AB: 83c402           add sp, 2
  074A3E  35AE: ff46f8           inc word ptr [bp - 8]
  074A41  35B1: 837ef808         cmp word ptr [bp - 8], 8
  074A45  35B5: 7ced             jl 0x35a4
  074A47  35B7: 68bf21           push 0x21bf
  074A4A  35BA: 6a00             push 0
  074A4C  35BC: 9a28091f19       lcall 0x191f, 0x928
  074A51  35C1: 83c404           add sp, 4
  074A54  35C4: c746f80000       mov word ptr [bp - 8], 0
  074A59  35C9: 8b46f8           mov ax, word ptr [bp - 8]
  074A5C  35CC: 050800           add ax, 8
  074A5F  35CF: 50               push ax
  074A60  35D0: 0e               push cs
  074A61  35D1: e81b19           call 0x4eef
  074A64  35D4: 83c402           add sp, 2
  074A67  35D7: 8b5ef8           mov bx, word ptr [bp - 8]
  074A6A  35DA: c1e304           shl bx, 4
  074A6D  35DD: 8dbf7430         lea di, [bx + 0x3074]
  074A71  35E1: 8db7f42f         lea si, [bx + 0x2ff4]
  074A75  35E5: 8cd8             mov ax, ds
  074A77  35E7: 8ec0             mov es, ax
  074A79  35E9: b90800           mov cx, 8
  074A7C  35EC: f3a5             rep movsw word ptr es:[di], word ptr [si]
  074A7E  35EE: ff46f8           inc word ptr [bp - 8]
  074A81  35F1: 837ef808         cmp word ptr [bp - 8], 8
  074A85  35F5: 7cd2             jl 0x35c9
  074A87  35F7: 68c821           push 0x21c8
  074A8A  35FA: 6a00             push 0
  074A8C  35FC: 9a28091f19       lcall 0x191f, 0x928
  074A91  3601: 83c404           add sp, 4
  074A94  3604: c746f80000       mov word ptr [bp - 8], 0
  074A99  3609: 8b46f8           mov ax, word ptr [bp - 8]
  074A9C  360C: 051800           add ax, 0x18
  074A9F  360F: 50               push ax
  074AA0  3610: 0e               push cs
  074AA1  3611: e8db18           call 0x4eef
  074AA4  3614: 83c402           add sp, 2
  074AA7  3617: ff46f8           inc word ptr [bp - 8]
  074AAA  361A: 837ef805         cmp word ptr [bp - 8], 5
  074AAE  361E: 7ce9             jl 0x3609
  074AB0  3620: 68ce21           push 0x21ce
  074AB3  3623: 6a00             push 0
  074AB5  3625: 9a28091f19       lcall 0x191f, 0x928
  074ABA  362A: 83c404           add sp, 4
  074ABD  362D: c746f80000       mov word ptr [bp - 8], 0
  074AC2  3632: 9a1c091f19       lcall 0x191f, 0x91c
  074AC7  3637: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074ACC  363C: 8b5ef8           mov bx, word ptr [bp - 8]
  074ACF  363F: d1e3             shl bx, 1
  074AD1  3641: 8987b02d         mov word ptr [bx + 0x2db0], ax
  074AD5  3645: ff46f8           inc word ptr [bp - 8]
  074AD8  3648: 837ef805         cmp word ptr [bp - 8], 5
  074ADC  364C: 7ce4             jl 0x3632
  074ADE  364E: 68da21           push 0x21da
  074AE1  3651: 6a00             push 0
  074AE3  3653: 9a28091f19       lcall 0x191f, 0x928
  074AE8  3658: 83c404           add sp, 4
  074AEB  365B: c746f80000       mov word ptr [bp - 8], 0
  074AF0  3660: 9a1c091f19       lcall 0x191f, 0x91c
  074AF5  3665: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074AFA  366A: 8b5ef8           mov bx, word ptr [bp - 8]
  074AFD  366D: d1e3             shl bx, 1
  074AFF  366F: 89870c93         mov word ptr [bx - 0x6cf4], ax
  074B03  3673: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074B08  3678: 8b5ef8           mov bx, word ptr [bp - 8]
  074B0B  367B: 8887b297         mov byte ptr [bx - 0x684e], al
  074B0F  367F: ff46f8           inc word ptr [bp - 8]
  074B12  3682: 837ef80e         cmp word ptr [bp - 8], 0xe
  074B16  3686: 7cd8             jl 0x3660
  074B18  3688: 68e321           push 0x21e3
  074B1B  368B: 6a00             push 0
  074B1D  368D: 9a28091f19       lcall 0x191f, 0x928
  074B22  3692: 83c404           add sp, 4
  074B25  3695: c746f80000       mov word ptr [bp - 8], 0
  074B2A  369A: 9a1c091f19       lcall 0x191f, 0x91c
  074B2F  369F: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074B34  36A4: 8b5ef8           mov bx, word ptr [bp - 8]
  074B37  36A7: d1e3             shl bx, 1
  074B39  36A9: 8987428d         mov word ptr [bx - 0x72be], ax
  074B3D  36AD: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074B42  36B2: 8b5ef8           mov bx, word ptr [bp - 8]
  074B45  36B5: 88874808         mov byte ptr [bx + 0x848], al
  074B49  36B9: ff46f8           inc word ptr [bp - 8]
  074B4C  36BC: 837ef804         cmp word ptr [bp - 8], 4
  074B50  36C0: 7cd8             jl 0x369a
  074B52  36C2: 68eb21           push 0x21eb
  074B55  36C5: 6a00             push 0
  074B57  36C7: 9a28091f19       lcall 0x191f, 0x928
  074B5C  36CC: 83c404           add sp, 4
  074B5F  36CF: c746f80000       mov word ptr [bp - 8], 0
  074B64  36D4: 9a160b1f1a       lcall 0x1a1f, 0xb16
  074B69  36D9: 8b5ef8           mov bx, word ptr [bp - 8]
  074B6C  36DC: d1e3             shl bx, 1
  074B6E  36DE: 89870a8d         mov word ptr [bx - 0x72f6], ax
  074B72  36E2: ff46f8           inc word ptr [bp - 8]
  074B75  36E5: 837ef804         cmp word ptr [bp - 8], 4
  074B79  36E9: 7ce9             jl 0x36d4
  074B7B  36EB: 68f721           push 0x21f7
  074B7E  36EE: 6a00             push 0
  074B80  36F0: 9a28091f19       lcall 0x191f, 0x928
  074B85  36F5: 83c404           add sp, 4
  074B88  36F8: c746f80000       mov word ptr [bp - 8], 0
  074B8D  36FD: 9a160b1f1a       lcall 0x1a1f, 0xb16
  074B92  3702: 8b5ef8           mov bx, word ptr [bp - 8]
  074B95  3705: d1e3             shl bx, 1
  074B97  3707: 8987f097         mov word ptr [bx - 0x6810], ax
  074B9B  370B: ff46f8           inc word ptr [bp - 8]
  074B9E  370E: 837ef804         cmp word ptr [bp - 8], 4
  074BA2  3712: 7ce9             jl 0x36fd
  074BA4  3714: 680422           push 0x2204
  074BA7  3717: 6a00             push 0
  074BA9  3719: 9a28091f19       lcall 0x191f, 0x928
  074BAE  371E: 83c404           add sp, 4
  074BB1  3721: c746f80000       mov word ptr [bp - 8], 0
  074BB6  3726: 9a160b1f1a       lcall 0x1a1f, 0xb16
  074BBB  372B: 8b5ef8           mov bx, word ptr [bp - 8]
  074BBE  372E: d1e3             shl bx, 1
  074BC0  3730: 89878c83         mov word ptr [bx - 0x7c74], ax
  074BC4  3734: ff46f8           inc word ptr [bp - 8]
  074BC7  3737: 837ef804         cmp word ptr [bp - 8], 4
  074BCB  373B: 7ce9             jl 0x3726
  074BCD  373D: 680d22           push 0x220d
  074BD0  3740: 6a00             push 0
  074BD2  3742: 9a28091f19       lcall 0x191f, 0x928
  074BD7  3747: 83c404           add sp, 4
  074BDA  374A: c746f80000       mov word ptr [bp - 8], 0
  074BDF  374F: 9a1c091f19       lcall 0x191f, 0x91c
  074BE4  3754: 1e               push ds
  074BE5  3755: 50               push ax
  074BE6  3756: 6b46f834         imul ax, word ptr [bp - 8], 0x34
  074BEA  375A: 052654           add ax, 0x5426
  074BED  375D: 1e               push ds
  074BEE  375E: 50               push ax
  074BEF  375F: 9a7e111d0d       lcall 0xd1d, 0x117e
  074BF4  3764: 83c408           add sp, 8
  074BF7  3767: ff46f8           inc word ptr [bp - 8]
  074BFA  376A: 837ef804         cmp word ptr [bp - 8], 4
  074BFE  376E: 7cdf             jl 0x374f
  074C00  3770: 681822           push 0x2218
  074C03  3773: 6a00             push 0
  074C05  3775: 9a28091f19       lcall 0x191f, 0x928
  074C0A  377A: 83c404           add sp, 4
  074C0D  377D: c746f80000       mov word ptr [bp - 8], 0
  074C12  3782: 9a1c091f19       lcall 0x191f, 0x91c
  074C17  3787: 9ac40f1f19       lcall 0x191f, 0xfc4
  074C1C  378C: 1e               push ds
  074C1D  378D: 50               push ax
  074C1E  378E: 6b46f834         imul ax, word ptr [bp - 8], 0x34
  074C22  3792: 050e54           add ax, 0x540e
  074C25  3795: 1e               push ds
  074C26  3796: 50               push ax
  074C27  3797: 9a7e111d0d       lcall 0xd1d, 0x117e
  074C2C  379C: 83c408           add sp, 8
  074C2F  379F: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074C34  37A4: 8b5ef8           mov bx, word ptr [bp - 8]
  074C37  37A7: 8bcb             mov cx, bx
  074C39  37A9: d1e3             shl bx, 1
  074C3B  37AB: 03d9             add bx, cx
  074C3D  37AD: 88876695         mov byte ptr [bx - 0x6a9a], al
  074C41  37B1: 8bf3             mov si, bx
  074C43  37B3: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074C48  37B8: 88846795         mov byte ptr [si - 0x6a99], al
  074C4C  37BC: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074C51  37C1: 88846895         mov byte ptr [si - 0x6a98], al
  074C55  37C5: ff46f8           inc word ptr [bp - 8]
  074C58  37C8: 837ef804         cmp word ptr [bp - 8], 4
  074C5C  37CC: 7cb4             jl 0x3782
  074C5E  37CE: 682322           push 0x2223
  074C61  37D1: 6a00             push 0
  074C63  37D3: 9a28091f19       lcall 0x191f, 0x928
  074C68  37D8: 83c404           add sp, 4
  074C6B  37DB: c746f80000       mov word ptr [bp - 8], 0
  074C70  37E0: 9a160b1f1a       lcall 0x1a1f, 0xb16
  074C75  37E5: 8b5ef8           mov bx, word ptr [bp - 8]
  074C78  37E8: d1e3             shl bx, 1
  074C7A  37EA: 8987f897         mov word ptr [bx - 0x6808], ax
  074C7E  37EE: ff46f8           inc word ptr [bp - 8]
  074C81  37F1: 837ef804         cmp word ptr [bp - 8], 4
  074C85  37F5: 7ce9             jl 0x37e0
  074C87  37F7: 682b22           push 0x222b
  074C8A  37FA: 6a00             push 0
  074C8C  37FC: 9a28091f19       lcall 0x191f, 0x928
  074C91  3801: 83c404           add sp, 4
  074C94  3804: c746f80000       mov word ptr [bp - 8], 0
  074C99  3809: 9a160b1f1a       lcall 0x1a1f, 0xb16
  074C9E  380E: 8b5ef8           mov bx, word ptr [bp - 8]
  074CA1  3811: d1e3             shl bx, 1
  074CA3  3813: 89879483         mov word ptr [bx - 0x7c6c], ax
  074CA7  3817: ff46f8           inc word ptr [bp - 8]
  074CAA  381A: 837ef805         cmp word ptr [bp - 8], 5
  074CAE  381E: 7ce9             jl 0x3809
  074CB0  3820: 683622           push 0x2236
  074CB3  3823: 6a00             push 0
  074CB5  3825: 9a28091f19       lcall 0x191f, 0x928
  074CBA  382A: 83c404           add sp, 4
  074CBD  382D: c746f80000       mov word ptr [bp - 8], 0
  074CC2  3832: 9a1c091f19       lcall 0x191f, 0x91c
  074CC7  3837: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074CCC  383C: 8b5ef8           mov bx, word ptr [bp - 8]
  074CCF  383F: c1e302           shl bx, 2
  074CD2  3842: 89870296         mov word ptr [bx - 0x69fe], ax
  074CD6  3846: 8bf3             mov si, bx
  074CD8  3848: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074CDD  384D: 89840496         mov word ptr [si - 0x69fc], ax
  074CE1  3851: ff46f8           inc word ptr [bp - 8]
  074CE4  3854: 837ef808         cmp word ptr [bp - 8], 8
  074CE8  3858: 7cd8             jl 0x3832
  074CEA  385A: 683c22           push 0x223c
  074CED  385D: 6a00             push 0
  074CEF  385F: 9a28091f19       lcall 0x191f, 0x928
  074CF4  3864: 83c404           add sp, 4
  074CF7  3867: c746f80000       mov word ptr [bp - 8], 0
  074CFC  386C: 9a1c091f19       lcall 0x191f, 0x91c
  074D01  3871: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074D06  3876: 8b5ef8           mov bx, word ptr [bp - 8]
  074D09  3879: 8bcb             mov cx, bx
  074D0B  387B: d1e3             shl bx, 1
  074D0D  387D: 03d9             add bx, cx
  074D0F  387F: c1e302           shl bx, 2
  074D12  3882: 8987828f         mov word ptr [bx - 0x707e], ax
  074D16  3886: 8bf3             mov si, bx
  074D18  3888: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074D1D  388D: 89848c8f         mov word ptr [si - 0x7074], ax
  074D21  3891: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074D26  3896: 8884898f         mov byte ptr [si - 0x7077], al
  074D2A  389A: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074D2F  389F: 8884878f         mov byte ptr [si - 0x7079], al
  074D33  38A3: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074D38  38A8: 88848a8f         mov byte ptr [si - 0x7076], al
  074D3C  38AC: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074D41  38B1: 88848b8f         mov byte ptr [si - 0x7075], al
  074D45  38B5: ff46f8           inc word ptr [bp - 8]
  074D48  38B8: 837ef82a         cmp word ptr [bp - 8], 0x2a
  074D4C  38BC: 7cae             jl 0x386c
  074D4E  38BE: 684522           push 0x2245
  074D51  38C1: 6a00             push 0
  074D53  38C3: 9a28091f19       lcall 0x191f, 0x928
  074D58  38C8: 83c404           add sp, 4
  074D5B  38CB: 9a1c091f19       lcall 0x191f, 0x91c
  074D60  38D0: 9ac40f1f19       lcall 0x191f, 0xfc4
  074D65  38D5: c746fa0000       mov word ptr [bp - 6], 0
  074D6A  38DA: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074D6F  38DF: 695efa3c01       imul bx, word ptr [bp - 6], 0x13c
  074D74  38E4: 88873a88         mov byte ptr [bx - 0x77c6], al
  074D78  38E8: 8bf3             mov si, bx
  074D7A  38EA: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074D7F  38EF: 88843b88         mov byte ptr [si - 0x77c5], al
  074D83  38F3: ff46fa           inc word ptr [bp - 6]
  074D86  38F6: 837efa04         cmp word ptr [bp - 6], 4
  074D8A  38FA: 7cde             jl 0x38da
  074D8C  38FC: 684e22           push 0x224e
  074D8F  38FF: 6a00             push 0
  074D91  3901: 9a28091f19       lcall 0x191f, 0x928
  074D96  3906: 83c404           add sp, 4
  074D99  3909: c746f80000       mov word ptr [bp - 8], 0
  074D9E  390E: 9a1c091f19       lcall 0x191f, 0x91c
  074DA3  3913: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074DA8  3918: 8b5ef8           mov bx, word ptr [bp - 8]
  074DAB  391B: c1e303           shl bx, 3
  074DAE  391E: 8987a28e         mov word ptr [bx - 0x715e], ax
  074DB2  3922: 8bf3             mov si, bx
  074DB4  3924: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074DB9  3929: 8984a48e         mov word ptr [si - 0x715c], ax
  074DBD  392D: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074DC2  3932: 2ae4             sub ah, ah
  074DC4  3934: 8984a68e         mov word ptr [si - 0x715a], ax
  074DC8  3938: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074DCD  393D: 8984a88e         mov word ptr [si - 0x7158], ax
  074DD1  3941: ff46f8           inc word ptr [bp - 8]
  074DD4  3944: 837ef81c         cmp word ptr [bp - 8], 0x1c
  074DD8  3948: 7cc4             jl 0x390e
  074DDA  394A: 685222           push 0x2252
  074DDD  394D: 6a00             push 0
  074DDF  394F: 9a28091f19       lcall 0x191f, 0x928
  074DE4  3954: 83c404           add sp, 4
  074DE7  3957: c746f80000       mov word ptr [bp - 8], 0
  074DEC  395C: 9a1c091f19       lcall 0x191f, 0x91c
  074DF1  3961: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074DF6  3966: 8b5ef8           mov bx, word ptr [bp - 8]
  074DF9  3969: d1e3             shl bx, 1
  074DFB  396B: 8987c097         mov word ptr [bx - 0x6840], ax
  074DFF  396F: 837ef810         cmp word ptr [bp - 8], 0x10
  074E03  3973: 7d5d             jge 0x39d2
  074E05  3975: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074E0A  397A: 8b5ef8           mov bx, word ptr [bp - 8]
  074E0D  397D: 8bcb             mov cx, bx
  074E0F  397F: c1e303           shl bx, 3
  074E12  3982: 03d9             add bx, cx
  074E14  3984: 8887fc96         mov byte ptr [bx - 0x6904], al
  074E18  3988: 8bf3             mov si, bx
  074E1A  398A: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074E1F  398F: 8884fd96         mov byte ptr [si - 0x6903], al
  074E23  3993: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074E28  3998: 8884fe96         mov byte ptr [si - 0x6902], al
  074E2C  399C: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074E31  39A1: 8884ff96         mov byte ptr [si - 0x6901], al
  074E35  39A5: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074E3A  39AA: 88840097         mov byte ptr [si - 0x6900], al
  074E3E  39AE: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074E43  39B3: 88840197         mov byte ptr [si - 0x68ff], al
  074E47  39B7: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074E4C  39BC: 88840297         mov byte ptr [si - 0x68fe], al
  074E50  39C0: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074E55  39C5: 88840397         mov byte ptr [si - 0x68fd], al
  074E59  39C9: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074E5E  39CE: 88840497         mov byte ptr [si - 0x68fc], al
  074E62  39D2: ff46f8           inc word ptr [bp - 8]
  074E65  39D5: 837ef814         cmp word ptr [bp - 8], 0x14
  074E69  39D9: 7c81             jl 0x395c
  074E6B  39DB: c746f80000       mov word ptr [bp - 8], 0
  074E70  39E0: c746f60000       mov word ptr [bp - 0xa], 0
  074E75  39E5: c746fc0100       mov word ptr [bp - 4], 1
  074E7A  39EA: 8b5efc           mov bx, word ptr [bp - 4]
  074E7D  39ED: 8bc3             mov ax, bx
  074E7F  39EF: c1e303           shl bx, 3
  074E82  39F2: 03d8             add bx, ax
  074E84  39F4: 8a87fd96         mov al, byte ptr [bx - 0x6903]
  074E88  39F8: 98               cwde 
  074E89  39F9: 8bc8             mov cx, ax
  074E8B  39FB: 8b76f8           mov si, word ptr [bp - 8]
  074E8E  39FE: c1e604           shl si, 4
  074E91  3A01: 8b5efc           mov bx, word ptr [bp - 4]
  074E94  3A04: 8a807b2f         mov al, byte ptr [bx + si + 0x2f7b]
  074E98  3A08: 2ae4             sub ah, ah
  074E9A  3A0A: f7e9             imul cx
  074E9C  3A0C: 3b46f6           cmp ax, word ptr [bp - 0xa]
  074E9F  3A0F: 7e03             jle 0x3a14
  074EA1  3A11: 8946f6           mov word ptr [bp - 0xa], ax
  074EA4  3A14: ff46fc           inc word ptr [bp - 4]
  074EA7  3A17: 837efc09         cmp word ptr [bp - 4], 9
  074EAB  3A1B: 7ccd             jl 0x39ea
  074EAD  3A1D: 8a46f6           mov al, byte ptr [bp - 0xa]
  074EB0  3A20: 8b5ef8           mov bx, word ptr [bp - 8]
  074EB3  3A23: c1e304           shl bx, 4
  074EB6  3A26: 88877a2f         mov byte ptr [bx + 0x2f7a], al
  074EBA  3A2A: ff46f8           inc word ptr [bp - 8]
  074EBD  3A2D: 837ef81d         cmp word ptr [bp - 8], 0x1d
  074EC1  3A31: 7cad             jl 0x39e0
  074EC3  3A33: 685822           push 0x2258
  074EC6  3A36: 6a00             push 0
  074EC8  3A38: 9a28091f19       lcall 0x191f, 0x928
  074ECD  3A3D: 83c404           add sp, 4
  074ED0  3A40: c746f80000       mov word ptr [bp - 8], 0
  074ED5  3A45: 9a1c091f19       lcall 0x191f, 0x91c
  074EDA  3A4A: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074EDF  3A4F: 8b5ef8           mov bx, word ptr [bp - 8]
  074EE2  3A52: 8bcb             mov cx, bx
  074EE4  3A54: d1e3             shl bx, 1
  074EE6  3A56: 03d9             add bx, cx
  074EE8  3A58: d1e3             shl bx, 1
  074EEA  3A5A: 03d9             add bx, cx
  074EEC  3A5C: d1e3             shl bx, 1
  074EEE  3A5E: 89873052         mov word ptr [bx + 0x5230], ax
  074EF2  3A62: 8bf3             mov si, bx
  074EF4  3A64: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074EF9  3A69: 88843252         mov byte ptr [si + 0x5232], al
  074EFD  3A6D: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074F02  3A72: 8bc8             mov cx, ax
  074F04  3A74: d0e0             shl al, 1
  074F06  3A76: 02c1             add al, cl
  074F08  3A78: 88843452         mov byte ptr [si + 0x5234], al
  074F0C  3A7C: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074F11  3A81: 88843652         mov byte ptr [si + 0x5236], al
  074F15  3A85: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074F1A  3A8A: 88843552         mov byte ptr [si + 0x5235], al
  074F1E  3A8E: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074F23  3A93: 88843752         mov byte ptr [si + 0x5237], al
  074F27  3A97: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074F2C  3A9C: 88843852         mov byte ptr [si + 0x5238], al
  074F30  3AA0: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074F35  3AA5: 88843952         mov byte ptr [si + 0x5239], al
  074F39  3AA9: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074F3E  3AAE: 88843a52         mov byte ptr [si + 0x523a], al
  074F42  3AB2: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074F47  3AB7: 88843b52         mov byte ptr [si + 0x523b], al
  074F4B  3ABB: 9a8a081f1a       lcall 0x1a1f, 0x88a
  074F50  3AC0: 88843c52         mov byte ptr [si + 0x523c], al
  074F54  3AC4: 9a2e0b1f1a       lcall 0x1a1f, 0xb2e
  074F59  3AC9: 88843d52         mov byte ptr [si + 0x523d], al
  074F5D  3ACD: ff46f8           inc word ptr [bp - 8]
  074F60  3AD0: 837ef817         cmp word ptr [bp - 8], 0x17
  074F64  3AD4: 7d03             jge 0x3ad9
  074F66  3AD6: e96cff           jmp 0x3a45
  074F69  3AD9: 685d22           push 0x225d
  074F6C  3ADC: 688208           push 0x882
  074F6F  3ADF: 9a28091f19       lcall 0x191f, 0x928
  074F74  3AE4: 83c404           add sp, 4
  074F77  3AE7: c746f80000       mov word ptr [bp - 8], 0
  074F7C  3AEC: eb1f             jmp 0x3b0d
  074F7E  3AEE: 26803f20         cmp byte ptr es:[bx], 0x20
  074F82  3AF2: 750c             jne 0x3b00
  074F84  3AF4: ff46f2           inc word ptr [bp - 0xe]
  074F87  3AF7: c45ef2           les bx, ptr [bp - 0xe]
  074F8A  3AFA: 26803f00         cmp byte ptr es:[bx], 0
  074F8E  3AFE: 75ee             jne 0x3aee
  074F90  3B00: 268a07           mov al, byte ptr es:[bx]
  074F93  3B03: 8b5ef8           mov bx, word ptr [bp - 8]
  074F96  3B06: 8887de54         mov byte ptr [bx + 0x54de], al
  074F9A  3B0A: ff46f8           inc word ptr [bp - 8]
  074F9D  3B0D: 837ef80d         cmp word ptr [bp - 8], 0xd
  074FA1  3B11: 7d21             jge 0x3b34
  074FA3  3B13: 9a1c091f19       lcall 0x191f, 0x91c
  074FA8  3B18: 9a220b1f1a       lcall 0x1a1f, 0xb22
  074FAD  3B1D: 8b5ef8           mov bx, word ptr [bp - 8]
  074FB0  3B20: d1e3             shl bx, 1
  074FB2  3B22: 89870498         mov word ptr [bx - 0x67fc], ax
  074FB6  3B26: 9ac40f1f19       lcall 0x191f, 0xfc4
  074FBB  3B2B: 8946f2           mov word ptr [bp - 0xe], ax
  074FBE  3B2E: 8c5ef4           mov word ptr [bp - 0xc], ds
  074FC1  3B31: ebc4             jmp 0x3af7
  074FC3  3B33: 90               nop 
  074FC4  3B34: 686422           push 0x2264
  074FC7  3B37: 6a00             push 0
  074FC9  3B39: 9a28091f19       lcall 0x191f, 0x928
  074FCE  3B3E: 83c404           add sp, 4
  074FD1  3B41: c746f80000       mov word ptr [bp - 8], 0
  074FD6  3B46: 9a160b1f1a       lcall 0x1a1f, 0xb16
  074FDB  3B4B: 8b5ef8           mov bx, word ptr [bp - 8]
  074FDE  3B4E: d1e3             shl bx, 1
  074FE0  3B50: 89872a93         mov word ptr [bx - 0x6cd6], ax
  074FE4  3B54: ff46f8           inc word ptr [bp - 8]
  074FE7  3B57: 837ef80a         cmp word ptr [bp - 8], 0xa
  074FEB  3B5B: 7ce9             jl 0x3b46
  074FED  3B5D: 686c22           push 0x226c
  074FF0  3B60: 6a00             push 0
  074FF2  3B62: 9a28091f19       lcall 0x191f, 0x928
  074FF7  3B67: 83c404           add sp, 4
  074FFA  3B6A: c746f80000       mov word ptr [bp - 8], 0
  074FFF  3B6F: 9a160b1f1a       lcall 0x1a1f, 0xb16
  075004  3B74: 8b5ef8           mov bx, word ptr [bp - 8]
  075007  3B77: d1e3             shl bx, 1
  075009  3B79: 89874093         mov word ptr [bx - 0x6cc0], ax
  07500D  3B7D: ff46f8           inc word ptr [bp - 8]
  075010  3B80: 837ef804         cmp word ptr [bp - 8], 4
  075014  3B84: 7ce9             jl 0x3b6f
  075016  3B86: 687322           push 0x2273
  075019  3B89: 6a00             push 0
  07501B  3B8B: 9a28091f19       lcall 0x191f, 0x928
  075020  3B90: 83c404           add sp, 4
  075023  3B93: c746f80000       mov word ptr [bp - 8], 0
  075028  3B98: 9a160b1f1a       lcall 0x1a1f, 0xb16
  07502D  3B9D: 8b5ef8           mov bx, word ptr [bp - 8]
  075030  3BA0: d1e3             shl bx, 1
  075032  3BA2: 89874893         mov word ptr [bx - 0x6cb8], ax
  075036  3BA6: ff46f8           inc word ptr [bp - 8]
  075039  3BA9: 837ef805         cmp word ptr [bp - 8], 5
  07503D  3BAD: 7ce9             jl 0x3b98
  07503F  3BAF: 687c22           push 0x227c
  075042  3BB2: 6a00             push 0
  075044  3BB4: 9a28091f19       lcall 0x191f, 0x928
  075049  3BB9: 83c404           add sp, 4
  07504C  3BBC: c746f80000       mov word ptr [bp - 8], 0
  075051  3BC1: 9a160b1f1a       lcall 0x1a1f, 0xb16
  075056  3BC6: 8b5ef8           mov bx, word ptr [bp - 8]
  075059  3BC9: d1e3             shl bx, 1
  07505B  3BCB: 89875293         mov word ptr [bx - 0x6cae], ax
  07505F  3BCF: ff46f8           inc word ptr [bp - 8]
  075062  3BD2: 837ef805         cmp word ptr [bp - 8], 5
  075066  3BD6: 7ce9             jl 0x3bc1
  075068  3BD8: 688822           push 0x2288
  07506B  3BDB: 6a00             push 0
  07506D  3BDD: 9a28091f19       lcall 0x191f, 0x928
  075072  3BE2: 83c404           add sp, 4
  075075  3BE5: c746f80000       mov word ptr [bp - 8], 0
  07507A  3BEA: 9a1c091f19       lcall 0x191f, 0x91c
  07507F  3BEF: 9a220b1f1a       lcall 0x1a1f, 0xb22
  075084  3BF4: 8b5ef8           mov bx, word ptr [bp - 8]
  075087  3BF7: 8bcb             mov cx, bx
  075089  3BF9: d1e3             shl bx, 1
  07508B  3BFB: 03d9             add bx, cx
  07508D  3BFD: d1e3             shl bx, 1
  07508F  3BFF: 89873296         mov word ptr [bx - 0x69ce], ax
  075093  3C03: 8bf3             mov si, bx
  075095  3C05: 9a220b1f1a       lcall 0x1a1f, 0xb22
  07509A  3C0A: 89843496         mov word ptr [si - 0x69cc], ax
  07509E  3C0E: 9a220b1f1a       lcall 0x1a1f, 0xb22
  0750A3  3C13: 89843696         mov word ptr [si - 0x69ca], ax
  0750A7  3C17: ff46f8           inc word ptr [bp - 8]
  0750AA  3C1A: 837ef805         cmp word ptr [bp - 8], 5
  0750AE  3C1E: 7cca             jl 0x3bea
  0750B0  3C20: 688f22           push 0x228f
  0750B3  3C23: 6a00             push 0
  0750B5  3C25: 9a28091f19       lcall 0x191f, 0x928
  0750BA  3C2A: 83c404           add sp, 4
  0750BD  3C2D: c746f80000       mov word ptr [bp - 8], 0
  0750C2  3C32: 9a1c091f19       lcall 0x191f, 0x91c
  0750C7  3C37: 9a220b1f1a       lcall 0x1a1f, 0xb22
  0750CC  3C3C: 8b5ef8           mov bx, word ptr [bp - 8]
  0750CF  3C3F: 8bcb             mov cx, bx
  0750D1  3C41: d1e3             shl bx, 1
  0750D3  3C43: 03d9             add bx, cx
  0750D5  3C45: d1e3             shl bx, 1
  0750D7  3C47: 8987128d         mov word ptr [bx - 0x72ee], ax
  0750DB  3C4B: 8bf3             mov si, bx
  0750DD  3C4D: 9a220b1f1a       lcall 0x1a1f, 0xb22
  0750E2  3C52: 8984148d         mov word ptr [si - 0x72ec], ax
  0750E6  3C56: 9a220b1f1a       lcall 0x1a1f, 0xb22
  0750EB  3C5B: 8984168d         mov word ptr [si - 0x72ea], ax
  0750EF  3C5F: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0750F4  3C64: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0750F9  3C69: 8b5ef8           mov bx, word ptr [bp - 8]
  0750FC  3C6C: 88874c08         mov byte ptr [bx + 0x84c], al
  075100  3C70: ff46f8           inc word ptr [bp - 8]
  075103  3C73: 837ef808         cmp word ptr [bp - 8], 8
  075107  3C77: 7cb9             jl 0x3c32
  075109  3C79: 689622           push 0x2296
  07510C  3C7C: 6a00             push 0
  07510E  3C7E: 9a28091f19       lcall 0x191f, 0x928
  075113  3C83: 83c404           add sp, 4
  075116  3C86: c746f80000       mov word ptr [bp - 8], 0
  07511B  3C8B: 9a160b1f1a       lcall 0x1a1f, 0xb16
  075120  3C90: 8b5ef8           mov bx, word ptr [bp - 8]
  075123  3C93: d1e3             shl bx, 1
  075125  3C95: 8987e896         mov word ptr [bx - 0x6918], ax
  075129  3C99: ff46f8           inc word ptr [bp - 8]
  07512C  3C9C: 837ef806         cmp word ptr [bp - 8], 6
  075130  3CA0: 7ce9             jl 0x3c8b
  075132  3CA2: 689f22           push 0x229f
  075135  3CA5: 6a00             push 0
  075137  3CA7: 9a28091f19       lcall 0x191f, 0x928
  07513C  3CAC: 83c404           add sp, 4
  07513F  3CAF: c746f80000       mov word ptr [bp - 8], 0
  075144  3CB4: 9a1c091f19       lcall 0x191f, 0x91c
  075149  3CB9: 9a220b1f1a       lcall 0x1a1f, 0xb22
  07514E  3CBE: 8b5ef8           mov bx, word ptr [bp - 8]
  075151  3CC1: 8bcb             mov cx, bx
  075153  3CC3: d1e3             shl bx, 1
  075155  3CC5: 03d9             add bx, cx
  075157  3CC7: d1e3             shl bx, 1
  075159  3CC9: 89875296         mov word ptr [bx - 0x69ae], ax
  07515D  3CCD: 8bf3             mov si, bx
  07515F  3CCF: 9a8a081f1a       lcall 0x1a1f, 0x88a
  075164  3CD4: 88845496         mov byte ptr [si - 0x69ac], al
  075168  3CD8: 9a8a081f1a       lcall 0x1a1f, 0x88a
  07516D  3CDD: 88845596         mov byte ptr [si - 0x69ab], al
  075171  3CE1: 9a8a081f1a       lcall 0x1a1f, 0x88a
  075176  3CE6: 88845696         mov byte ptr [si - 0x69aa], al
  07517A  3CEA: 9a8a081f1a       lcall 0x1a1f, 0x88a
  07517F  3CEF: 88845796         mov byte ptr [si - 0x69a9], al
  075183  3CF3: ff46f8           inc word ptr [bp - 8]
  075186  3CF6: 837ef819         cmp word ptr [bp - 8], 0x19
  07518A  3CFA: 7cb8             jl 0x3cb4
  07518C  3CFC: 68a722           push 0x22a7
  07518F  3CFF: 6a00             push 0
  075191  3D01: 9a28091f19       lcall 0x191f, 0x928
  075196  3D06: 83c404           add sp, 4
  075199  3D09: 0bc0             or ax, ax
  07519B  3D0B: 754d             jne 0x3d5a
  07519D  3D0D: 9a1c091f19       lcall 0x191f, 0x91c
  0751A2  3D12: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0751A7  3D17: a23008           mov byte ptr [0x830], al
  0751AA  3D1A: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0751AF  3D1F: a23108           mov byte ptr [0x831], al
  0751B2  3D22: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0751B7  3D27: a23208           mov byte ptr [0x832], al
  0751BA  3D2A: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0751BF  3D2F: a23308           mov byte ptr [0x833], al
  0751C2  3D32: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0751C7  3D37: a23408           mov byte ptr [0x834], al
  0751CA  3D3A: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0751CF  3D3F: a23508           mov byte ptr [0x835], al
  0751D2  3D42: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0751D7  3D47: a23708           mov byte ptr [0x837], al
  0751DA  3D4A: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0751DF  3D4F: a23808           mov byte ptr [0x838], al
  0751E2  3D52: 9a8a081f1a       lcall 0x1a1f, 0x88a
  0751E7  3D57: a23908           mov byte ptr [0x839], al
  0751EA  3D5A: 68ae22           push 0x22ae
  0751ED  3D5D: 688808           push 0x888
  0751F0  3D60: 9a28091f19       lcall 0x191f, 0x928
  0751F5  3D65: 83c404           add sp, 4
  0751F8  3D68: c746f80000       mov word ptr [bp - 8], 0
  0751FD  3D6D: 9a160b1f1a       lcall 0x1a1f, 0xb16
  075202  3D72: 8b5ef8           mov bx, word ptr [bp - 8]
  075205  3D75: d1e3             shl bx, 1
  075207  3D77: 8987f496         mov word ptr [bx - 0x690c], ax
  07520B  3D7B: ff46f8           inc word ptr [bp - 8]
  07520E  3D7E: 837ef804         cmp word ptr [bp - 8], 4
  075212  3D82: 7ce9             jl 0x3d6d
  075214  3D84: 68b322           push 0x22b3
  075217  3D87: 6a00             push 0
  075219  3D89: 9a28091f19       lcall 0x191f, 0x928
  07521E  3D8E: 83c404           add sp, 4
  075221  3D91: c746f80000       mov word ptr [bp - 8], 0
  075226  3D96: 9a160b1f1a       lcall 0x1a1f, 0xb16
  07522B  3D9B: 8b5ef8           mov bx, word ptr [bp - 8]
  07522E  3D9E: d1e3             shl bx, 1
  075230  3DA0: 8987ba2d         mov word ptr [bx + 0x2dba], ax
  075234  3DA4: ff46f8           inc word ptr [bp - 8]
  075237  3DA7: 817ef8dd00       cmp word ptr [bp - 8], 0xdd
  07523C  3DAC: 7ce8             jl 0x3d96
  07523E  3DAE: 68b822           push 0x22b8
  075241  3DB1: 6a00             push 0
  075243  3DB3: 9a28091f19       lcall 0x191f, 0x928
  075248  3DB8: 83c404           add sp, 4
  07524B  3DBB: c746f80000       mov word ptr [bp - 8], 0
  075250  3DC0: 9a160b1f1a       lcall 0x1a1f, 0xb16
  075255  3DC5: 8b5ef8           mov bx, word ptr [bp - 8]
  075258  3DC8: d1e3             shl bx, 1
  07525A  3DCA: 8987de93         mov word ptr [bx - 0x6c22], ax
  07525E  3DCE: ff46f8           inc word ptr [bp - 8]
  075261  3DD1: 837ef809         cmp word ptr [bp - 8], 9
  075265  3DD5: 7ce9             jl 0x3dc0
  075267  3DD7: 68be22           push 0x22be
  07526A  3DDA: 6a00             push 0
  07526C  3DDC: 9a28091f19       lcall 0x191f, 0x928
  075271  3DE1: 83c404           add sp, 4
  075274  3DE4: c746f80000       mov word ptr [bp - 8], 0
  075279  3DE9: 9a160b1f1a       lcall 0x1a1f, 0xb16
  07527E  3DEE: 8b5ef8           mov bx, word ptr [bp - 8]
  075281  3DF1: d1e3             shl bx, 1
  075283  3DF3: 89879893         mov word ptr [bx - 0x6c68], ax
  075287  3DF7: ff46f8           inc word ptr [bp - 8]
  07528A  3DFA: 837ef803         cmp word ptr [bp - 8], 3
  07528E  3DFE: 7ce9             jl 0x3de9
  075290  3E00: 68c422           push 0x22c4
  075293  3E03: 6a00             push 0
  075295  3E05: 9a28091f19       lcall 0x191f, 0x928
  07529A  3E0A: 83c404           add sp, 4
  07529D  3E0D: c746f80000       mov word ptr [bp - 8], 0
  0752A2  3E12: 9a160b1f1a       lcall 0x1a1f, 0xb16
  0752A7  3E17: 8b5ef8           mov bx, word ptr [bp - 8]
  0752AA  3E1A: d1e3             shl bx, 1
  0752AC  3E1C: 89879e93         mov word ptr [bx - 0x6c62], ax
  0752B0  3E20: ff46f8           inc word ptr [bp - 8]
  0752B3  3E23: 837ef80a         cmp word ptr [bp - 8], 0xa
  0752B7  3E27: 7ce9             jl 0x3e12
  0752B9  3E29: 68cb22           push 0x22cb
  0752BC  3E2C: 6a00             push 0
  0752BE  3E2E: 9a28091f19       lcall 0x191f, 0x928
  0752C3  3E33: 83c404           add sp, 4
  0752C6  3E36: c746f80000       mov word ptr [bp - 8], 0
  0752CB  3E3B: 9a160b1f1a       lcall 0x1a1f, 0xb16
  0752D0  3E40: 8b5ef8           mov bx, word ptr [bp - 8]
  0752D3  3E43: d1e3             shl bx, 1
  0752D5  3E45: 8987b293         mov word ptr [bx - 0x6c4e], ax
  0752D9  3E49: ff46f8           inc word ptr [bp - 8]
  0752DC  3E4C: 837ef813         cmp word ptr [bp - 8], 0x13
  0752E0  3E50: 7ce9             jl 0x3e3b
  0752E2  3E52: 68d422           push 0x22d4
  0752E5  3E55: 6a00             push 0
  0752E7  3E57: 9a28091f19       lcall 0x191f, 0x928
  0752EC  3E5C: 83c404           add sp, 4
  0752EF  3E5F: c746f80000       mov word ptr [bp - 8], 0
  0752F4  3E64: 9a160b1f1a       lcall 0x1a1f, 0xb16
  0752F9  3E69: 8b5ef8           mov bx, word ptr [bp - 8]
  0752FC  3E6C: d1e3             shl bx, 1
  0752FE  3E6E: 8987d893         mov word ptr [bx - 0x6c28], ax
  075302  3E72: ff46f8           inc word ptr [bp - 8]
  075305  3E75: 837ef803         cmp word ptr [bp - 8], 3
  075309  3E79: 7ce9             jl 0x3e64
  07530B  3E7B: 68de22           push 0x22de
  07530E  3E7E: 68ec22           push 0x22ec
  075311  3E81: 9a28091f19       lcall 0x191f, 0x928
  075316  3E86: 83c404           add sp, 4
  075319  3E89: 9a1c091f19       lcall 0x191f, 0x91c
  07531E  3E8E: 683c83           push 0x833c
  075321  3E91: 9af6081d0d       lcall 0xd1d, 0x8f6
  075326  3E96: 83c402           add sp, 2
  075329  3E99: a34608           mov word ptr [0x846], ax
  07532C  3E9C: c746f80000       mov word ptr [bp - 8], 0
  075331  3EA1: eb12             jmp 0x3eb5
  075333  3EA3: 90               nop 
  075334  3EA4: 9a160b1f1a       lcall 0x1a1f, 0xb16
  075339  3EA9: 8b5ef8           mov bx, word ptr [bp - 8]
  07533C  3EAC: d1e3             shl bx, 1
  07533E  3EAE: 89875c93         mov word ptr [bx - 0x6ca4], ax
  075342  3EB2: ff46f8           inc word ptr [bp - 8]
  075345  3EB5: a14608           mov ax, word ptr [0x846]
  075348  3EB8: 3946f8           cmp word ptr [bp - 8], ax
  07534B  3EBB: 7ce7             jl 0x3ea4
  07534D  3EBD: 5e               pop si
  07534E  3EBE: 5f               pop di
  07534F  3EBF: c9               leave 
  075350  3EC0: cb               retf 

; ---- func_075352  size=578  insns=197  prologue=ENTER 0x0320,0  terminal=RETF ----
  075352  3EC2: c8200300         enter 0x320, 0
  075356  3EC6: 57               push di
  075357  3EC7: 56               push si
  075358  3EC8: 2bc0             sub ax, ax
  07535A  3ECA: 8946f6           mov word ptr [bp - 0xa], ax
  07535D  3ECD: 8946f4           mov word ptr [bp - 0xc], ax
  075360  3ED0: a17203           mov ax, word ptr [0x372]
  075363  3ED3: 8946f8           mov word ptr [bp - 8], ax
  075366  3ED6: 2bc0             sub ax, ax
  075368  3ED8: a37203           mov word ptr [0x372], ax
  07536B  3EDB: a3641f           mov word ptr [0x1f64], ax
  07536E  3EDE: 68f222           push 0x22f2
  075371  3EE1: 8d46e0           lea ax, [bp - 0x20]
  075374  3EE4: 50               push ax
  075375  3EE5: 9ae4071d0d       lcall 0xd1d, 0x7e4
  07537A  3EEA: 83c404           add sp, 4
  07537D  3EED: ff7606           push word ptr [bp + 6]
  075380  3EF0: 8d46e0           lea ax, [bp - 0x20]
  075383  3EF3: 16               push ss
  075384  3EF4: 50               push ax
  075385  3EF5: 9a82011f18       lcall 0x181f, 0x182
  07538A  3EFA: 83c406           add sp, 6
  07538D  3EFD: 8d86e0fc         lea ax, [bp - 0x320]
  075391  3F01: 16               push ss
  075392  3F02: 50               push ax
  075393  3F03: 6a00             push 0
  075395  3F05: ff36a483         push word ptr [0x83a4]
  075399  3F09: ff36a283         push word ptr [0x83a2]
  07539D  3F0D: ff36a083         push word ptr [0x83a0]
  0753A1  3F11: ff369e83         push word ptr [0x839e]
  0753A5  3F15: 8d46e0           lea ax, [bp - 0x20]
  0753A8  3F18: 50               push ax
  0753A9  3F19: 9a4e041f18       lcall 0x181f, 0x44e
  0753AE  3F1E: 83c410           add sp, 0x10
  0753B1  3F21: 0bc0             or ax, ax
  0753B3  3F23: 7403             je 0x3f28
  0753B5  3F25: e9ab01           jmp 0x40d3
  0753B8  3F28: a19853           mov ax, word ptr [0x5398]
  0753BB  3F2B: 0bc0             or ax, ax
  0753BD  3F2D: 740b             je 0x3f3a
  0753BF  3F2F: 48               dec ax
  0753C0  3F30: 740e             je 0x3f40
  0753C2  3F32: 48               dec ax
  0753C3  3F33: 7411             je 0x3f46
  0753C5  3F35: 48               dec ax
  0753C6  3F36: 7414             je 0x3f4c
  0753C8  3F38: eb21             jmp 0x3f5b
  0753CA  3F3A: 68fa22           push 0x22fa
  0753CD  3F3D: eb10             jmp 0x3f4f
  0753CF  3F3F: 90               nop 
  0753D0  3F40: 680123           push 0x2301
  0753D3  3F43: eb0a             jmp 0x3f4f
  0753D5  3F45: 90               nop 
  0753D6  3F46: 680823           push 0x2308
  0753D9  3F49: eb04             jmp 0x3f4f
  0753DB  3F4B: 90               nop 
  0753DC  3F4C: 680e23           push 0x230e
  0753DF  3F4F: 8d46e0           lea ax, [bp - 0x20]
  0753E2  3F52: 50               push ax
  0753E3  3F53: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0753E8  3F58: 83c404           add sp, 4
  0753EB  3F5B: ff7606           push word ptr [bp + 6]
  0753EE  3F5E: 8d46e0           lea ax, [bp - 0x20]
  0753F1  3F61: 16               push ss
  0753F2  3F62: 50               push ax
  0753F3  3F63: 9a82011f18       lcall 0x181f, 0x182
  0753F8  3F68: 83c406           add sp, 6
  0753FB  3F6B: 9ade0f1f19       lcall 0x191f, 0xfde
  075400  3F70: 8d5ee0           lea bx, [bp - 0x20]
  075403  3F73: 2bc0             sub ax, ax
  075405  3F75: 9ad00f1f19       lcall 0x191f, 0xfd0
  07540A  3F7A: 8bf0             mov si, ax
  07540C  3F7C: 8956fe           mov word ptr [bp - 2], dx
  07540F  3F7F: 0bd0             or dx, ax
  075411  3F81: 741d             je 0x3fa0
  075413  3F83: 8b46fe           mov ax, word ptr [bp - 2]
  075416  3F86: 50               push ax
  075417  3F87: 56               push si
  075418  3F88: 8ec0             mov es, ax
  07541A  3F8A: 26ff7448         push word ptr es:[si + 0x48]
  07541E  3F8E: 6a64             push 0x64
  075420  3F90: 268b5446         mov dx, word ptr es:[si + 0x46]
  075424  3F94: b80100           mov ax, 1
  075427  3F97: 8d1e9e83         lea bx, [0x839e]
  07542B  3F9B: 9af8021f18       lcall 0x181f, 0x2f8
  075430  3FA0: 837e0601         cmp word ptr [bp + 6], 1
  075434  3FA4: 7528             jne 0x3fce
  075436  3FA6: 837e0801         cmp word ptr [bp + 8], 1
  07543A  3FAA: 751c             jne 0x3fc8
  07543C  3FAC: 681423           push 0x2314
  07543F  3FAF: 8d46e0           lea ax, [bp - 0x20]
  075442  3FB2: 50               push ax
  075443  3FB3: 9ae4071d0d       lcall 0xd1d, 0x7e4
  075448  3FB8: 83c404           add sp, 4
  07544B  3FBB: 6a3e             push 0x3e
  07544D  3FBD: 9a8e041f18       lcall 0x181f, 0x48e
  075452  3FC2: 83c402           add sp, 2
  075455  3FC5: eb16             jmp 0x3fdd
  075457  3FC7: 90               nop 
  075458  3FC8: 681a23           push 0x231a
  07545B  3FCB: eb04             jmp 0x3fd1
  07545D  3FCD: 90               nop 
  07545E  3FCE: 682323           push 0x2323
  075461  3FD1: 8d46e0           lea ax, [bp - 0x20]
  075464  3FD4: 50               push ax
  075465  3FD5: 9ae4071d0d       lcall 0xd1d, 0x7e4
  07546A  3FDA: 83c404           add sp, 4
  07546D  3FDD: 9ade0f1f19       lcall 0x191f, 0xfde
  075472  3FE2: 8d5ee0           lea bx, [bp - 0x20]
  075475  3FE5: 2bc0             sub ax, ax
  075477  3FE7: 9ad00f1f19       lcall 0x191f, 0xfd0
  07547C  3FEC: 8bf0             mov si, ax
  07547E  3FEE: 8956fe           mov word ptr [bp - 2], dx
  075481  3FF1: 0bd0             or dx, ax
  075483  3FF3: 741d             je 0x4012
  075485  3FF5: 8b46fe           mov ax, word ptr [bp - 2]
  075488  3FF8: 50               push ax
  075489  3FF9: 56               push si
  07548A  3FFA: 8ec0             mov es, ax
  07548C  3FFC: 26ff7448         push word ptr es:[si + 0x48]
  075490  4000: 6a64             push 0x64
  075492  4002: 268b5446         mov dx, word ptr es:[si + 0x46]
  075496  4006: b80100           mov ax, 1
  075499  4009: 8d1e9e83         lea bx, [0x839e]
  07549D  400D: 9af8021f18       lcall 0x181f, 0x2f8
  0754A2  4012: 9ab6031f18       lcall 0x181f, 0x3b6
  0754A7  4017: 8d86e0fc         lea ax, [bp - 0x320]
  0754AB  401B: 16               push ss
  0754AC  401C: 50               push ax
  0754AD  401D: 9af4031f18       lcall 0x181f, 0x3f4
  0754B2  4022: ff36a483         push word ptr [0x83a4]
  0754B6  4026: ff36a283         push word ptr [0x83a2]
  0754BA  402A: ff36a083         push word ptr [0x83a0]
  0754BE  402E: ff369e83         push word ptr [0x839e]
  0754C2  4032: ff36ae2d         push word ptr [0x2dae]
  0754C6  4036: ff36ac2d         push word ptr [0x2dac]
  0754CA  403A: ff36aa2d         push word ptr [0x2daa]
  0754CE  403E: ff36a82d         push word ptr [0x2da8]
  0754D2  4042: 68c800           push 0xc8
  0754D5  4045: 2bc0             sub ax, ax
  0754D7  4047: 99               cdq 
  0754D8  4048: bb4001           mov bx, 0x140
  0754DB  404B: 9a44041f18       lcall 0x181f, 0x444
  0754E0  4050: 6a00             push 0
  0754E2  4052: 684001           push 0x140
  0754E5  4055: 68c800           push 0xc8
  0754E8  4058: 2bc0             sub ax, ax
  0754EA  405A: 99               cdq 
  0754EB  405B: 2bdb             sub bx, bx
  0754ED  405D: 9ae2001f18       lcall 0x181f, 0xe2
  0754F2  4062: 8d1e2b23         lea bx, [0x232b]
  0754F6  4066: 9a860a1f1a       lcall 0x1a1f, 0xa86
  0754FB  406B: 8946f4           mov word ptr [bp - 0xc], ax
  0754FE  406E: 8956f6           mov word ptr [bp - 0xa], dx
  075501  4071: 0bd0             or dx, ax
  075503  4073: 7405             je 0x407a
  075505  4075: 8b56f6           mov dx, word ptr [bp - 0xa]
  075508  4078: eb07             jmp 0x4081
  07550A  407A: a19e08           mov ax, word ptr [0x89e]
  07550D  407D: 8b16a008         mov dx, word ptr [0x8a0]
  075511  4081: a39e1f           mov word ptr [0x1f9e], ax
  075514  4084: 8916a01f         mov word ptr [0x1fa0], dx
  075518  4088: 8b364a1f         mov si, word ptr [0x1f4a]
  07551C  408C: 8b3e501f         mov di, word ptr [0x1f50]
  075520  4090: a1521f           mov ax, word ptr [0x1f52]
  075523  4093: 8946fa           mov word ptr [bp - 6], ax
  075526  4096: c7064a1ff200     mov word ptr [0x1f4a], 0xf2
  07552C  409C: c706501f2f00     mov word ptr [0x1f50], 0x2f
  075532  40A2: c706521f0000     mov word ptr [0x1f52], 0
  075538  40A8: 800e561f18       or byte ptr [0x1f56], 0x18
  07553D  40AD: 8b5e0a           mov bx, word ptr [bp + 0xa]
  075540  40B0: 9afe031f18       lcall 0x181f, 0x3fe
  075545  40B5: 89364a1f         mov word ptr [0x1f4a], si
  075549  40B9: 893e501f         mov word ptr [0x1f50], di
  07554D  40BD: 8b46fa           mov ax, word ptr [bp - 6]
  075550  40C0: a3521f           mov word ptr [0x1f52], ax
  075553  40C3: 9ab6031f18       lcall 0x181f, 0x3b6
  075558  40C8: 6800a0           push 0xa000
  07555B  40CB: 6800fc           push 0xfc00
  07555E  40CE: 9af4031f18       lcall 0x181f, 0x3f4
  075563  40D3: 8b46f6           mov ax, word ptr [bp - 0xa]
  075566  40D6: 0b46f4           or ax, word ptr [bp - 0xc]
  075569  40D9: 740b             je 0x40e6
  07556B  40DB: ff76f6           push word ptr [bp - 0xa]
  07556E  40DE: ff76f4           push word ptr [bp - 0xc]
  075571  40E1: 9aa8011f19       lcall 0x191f, 0x1a8
  075576  40E6: a18a26           mov ax, word ptr [0x268a]
  075579  40E9: 8b168c26         mov dx, word ptr [0x268c]
  07557D  40ED: a39e1f           mov word ptr [0x1f9e], ax
  075580  40F0: 8916a01f         mov word ptr [0x1fa0], dx
  075584  40F4: c706641f0100     mov word ptr [0x1f64], 1
  07558A  40FA: 8b46f8           mov ax, word ptr [bp - 8]
  07558D  40FD: a37203           mov word ptr [0x372], ax
  075590  4100: 5e               pop si
  075591  4101: 5f               pop di
  075592  4102: c9               leave 
  075593  4103: cb               retf 

; ---- func_075594  size=55  insns=22  prologue=ENTER 0x0014,0  terminal=RETF ----
  075594  4104: c8140000         enter 0x14, 0
  075598  4108: 683423           push 0x2334
  07559B  410B: 8d46ec           lea ax, [bp - 0x14]
  07559E  410E: 50               push ax
  07559F  410F: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0755A4  4114: 83c404           add sp, 4
  0755A7  4117: 833e985303       cmp word ptr [0x5398], 3
  0755AC  411C: 750f             jne 0x412d
  0755AE  411E: 6a02             push 2
  0755B0  4120: 8d46ec           lea ax, [bp - 0x14]
  0755B3  4123: 16               push ss
  0755B4  4124: 50               push ax
  0755B5  4125: 9a82011f18       lcall 0x181f, 0x182
  0755BA  412A: 83c406           add sp, 6
  0755BD  412D: 8d46ec           lea ax, [bp - 0x14]
  0755C0  4130: 50               push ax
  0755C1  4131: 6a01             push 1
  0755C3  4133: 6a01             push 1
  0755C5  4135: 0e               push cs
  0755C6  4136: e8a70d           call 0x4ee0
  0755C9  4139: c9               leave 
  0755CA  413A: cb               retf 

; ---- func_0755CC  size=1052  insns=321  prologue=ENTER 0x000E,0  terminal=RETF ----
  0755CC  413C: c80e0000         enter 0xe, 0
  0755D0  4140: 56               push si
  0755D1  4141: 686621           push 0x2166
  0755D4  4144: 685485           push 0x8554
  0755D7  4147: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0755DC  414C: 83c404           add sp, 4
  0755DF  414F: 8b4606           mov ax, word ptr [bp + 6]
  0755E2  4152: a38853           mov word ptr [0x5388], ax
  0755E5  4155: c706825300c6     mov word ptr [0x5382], 0xc600
  0755EB  415B: c70686530e00     mov word ptr [0x5386], 0xe
  0755F1  4161: b80100           mov ax, 1
  0755F4  4164: 8946fe           mov word ptr [bp - 2], ax
  0755F7  4167: a3a200           mov word ptr [0xa2], ax
  0755FA  416A: a3a000           mov word ptr [0xa0], ax
  0755FD  416D: a3a400           mov word ptr [0xa4], ax
  075600  4170: b8ffff           mov ax, 0xffff
  075603  4173: a3a453           mov word ptr [0x53a4], ax
  075606  4176: a3d253           mov word ptr [0x53d2], ax
  075609  4179: a3d453           mov word ptr [0x53d4], ax
  07560C  417C: a3d653           mov word ptr [0x53d6], ax
  07560F  417F: 2bc0             sub ax, ax
  075611  4181: a39453           mov word ptr [0x5394], ax
  075614  4184: a39653           mov word ptr [0x5396], ax
  075617  4187: a3a053           mov word ptr [0x53a0], ax
  07561A  418A: a3a253           mov word ptr [0x53a2], ax
  07561D  418D: a38053           mov word ptr [0x5380], ax
  075620  4190: a3d053           mov word ptr [0x53d0], ax
  075623  4193: a3d853           mov word ptr [0x53d8], ax
  075626  4196: 8946f6           mov word ptr [bp - 0xa], ax
  075629  4199: eb0f             jmp 0x41aa
  07562B  419B: 90               nop 
  07562C  419C: 8b5ef6           mov bx, word ptr [bp - 0xa]
  07562F  419F: d1e3             shl bx, 1
  075631  41A1: c787c853ffff     mov word ptr [bx + 0x53c8], 0xffff
  075637  41A7: ff46f6           inc word ptr [bp - 0xa]
  07563A  41AA: 837ef604         cmp word ptr [bp - 0xa], 4
  07563E  41AE: 7cec             jl 0x419c
  075640  41B0: c746f60000       mov word ptr [bp - 0xa], 0
  075645  41B5: 68e803           push 0x3e8
  075648  41B8: 685802           push 0x258
  07564B  41BB: 9ad4041f18       lcall 0x181f, 0x4d4
  075650  41C0: 83c404           add sp, 4
  075653  41C3: 8b5ef6           mov bx, word ptr [bp - 0xa]
  075656  41C6: d1e3             shl bx, 1
  075658  41C8: 8987ea53         mov word ptr [bx + 0x53ea], ax
  07565C  41CC: ff46f6           inc word ptr [bp - 0xa]
  07565F  41CF: 837ef610         cmp word ptr [bp - 0xa], 0x10
  075663  41D3: 7ce0             jl 0x41b5
  075665  41D5: c746f60000       mov word ptr [bp - 0xa], 0
  07566A  41DA: 2bc0             sub ax, ax
  07566C  41DC: 8b5ef6           mov bx, word ptr [bp - 0xa]
  07566F  41DF: d1e3             shl bx, 1
  075671  41E1: 8987da53         mov word ptr [bx + 0x53da], ax
  075675  41E5: 8987e253         mov word ptr [bx + 0x53e2], ax
  075679  41E9: ff46f6           inc word ptr [bp - 0xa]
  07567C  41EC: 837ef604         cmp word ptr [bp - 0xa], 4
  075680  41F0: 7ce8             jl 0x41da
  075682  41F2: 6a04             push 4
  075684  41F4: 50               push ax
  075685  41F5: 680a54           push 0x540a
  075688  41F8: 9aae0d1d0d       lcall 0xd1d, 0xdae
  07568D  41FD: 83c406           add sp, 6
  075690  4200: 0e               push cs
  075691  4201: e8f50c           call 0x4ef9
  075694  4204: 0bc0             or ax, ax
  075696  4206: 7403             je 0x420b
  075698  4208: e91403           jmp 0x451f
  07569B  420B: a0a653           mov al, byte ptr [0x53a6]
  07569E  420E: 2ae4             sub ah, ah
  0756A0  4210: 8bc8             mov cx, ax
  0756A2  4212: c1e003           shl ax, 3
  0756A5  4215: 050f00           add ax, 0xf
  0756A8  4218: a3da53           mov word ptr [0x53da], ax
  0756AB  421B: 8bc1             mov ax, cx
  0756AD  421D: 41               inc cx
  0756AE  421E: 8bd1             mov dx, cx
  0756B0  4220: c1e102           shl cx, 2
  0756B3  4223: 03ca             add cx, dx
  0756B5  4225: 890edc53         mov word ptr [0x53dc], cx
  0756B9  4229: 8bd0             mov dx, ax
  0756BB  422B: 8bc8             mov cx, ax
  0756BD  422D: d1e0             shl ax, 1
  0756BF  422F: 03c1             add ax, cx
  0756C1  4231: d1e0             shl ax, 1
  0756C3  4233: 40               inc ax
  0756C4  4234: 40               inc ax
  0756C5  4235: a3e053           mov word ptr [0x53e0], ax
  0756C8  4238: 8bc2             mov ax, dx
  0756CA  423A: d1e2             shl dx, 1
  0756CC  423C: 03d0             add dx, ax
  0756CE  423E: 42               inc dx
  0756CF  423F: 42               inc dx
  0756D0  4240: 8916de53         mov word ptr [0x53de], dx
  0756D4  4244: 803e280800       cmp byte ptr [0x828], 0
  0756D9  4249: 7504             jne 0x424f
  0756DB  424B: 0e               push cs
  0756DC  424C: e8dc0c           call 0x4f2b
  0756DF  424F: 9af2041f18       lcall 0x181f, 0x4f2
  0756E4  4254: b83900           mov ax, 0x39
  0756E7  4257: 9ac0041f18       lcall 0x181f, 0x4c0
  0756EC  425C: 9aac031f18       lcall 0x181f, 0x3ac
  0756F1  4261: c746fe0200       mov word ptr [bp - 2], 2
  0756F6  4266: 837e0600         cmp word ptr [bp + 6], 0
  0756FA  426A: 751e             jne 0x428a
  0756FC  426C: c7068c010100     mov word ptr [0x18c], 1
  075702  4272: c7063a853a00     mov word ptr [0x853a], 0x3a
  075708  4278: c7063c854800     mov word ptr [0x853c], 0x48
  07570E  427E: c706a4855010     mov word ptr [0x85a4], 0x1050
  075714  4284: c706a6850000     mov word ptr [0x85a6], 0
  07571A  428A: 2bc0             sub ax, ax
  07571C  428C: 9a800c1f1a       lcall 0x1a1f, 0xc80
  075721  4291: 0bc0             or ax, ax
  075723  4293: 7403             je 0x4298
  075725  4295: e98702           jmp 0x451f
  075728  4298: 9aac031f18       lcall 0x181f, 0x3ac
  07572D  429D: 837e0600         cmp word ptr [bp + 6], 0
  075731  42A1: 7457             je 0x42fa
  075733  42A3: 9a8e0c1f1a       lcall 0x1a1f, 0xc8e
  075738  42A8: 0bc0             or ax, ax
  07573A  42AA: 740a             je 0x42b6
  07573C  42AC: a15801           mov ax, word ptr [0x158]
  07573F  42AF: a32208           mov word ptr [0x822], ax
  075742  42B2: e96a02           jmp 0x451f
  075745  42B5: 90               nop 
  075746  42B6: ff36ae85         push word ptr [0x85ae]
  07574A  42BA: ff36ac85         push word ptr [0x85ac]
  07574E  42BE: ff36aa85         push word ptr [0x85aa]
  075752  42C2: ff36a885         push word ptr [0x85a8]
  075756  42C6: 6a01             push 1
  075758  42C8: 6a18             push 0x18
  07575A  42CA: 2bc0             sub ax, ax
  07575C  42CC: 99               cdq 
  07575D  42CD: 8b1e3a85         mov bx, word ptr [0x853a]
  075761  42D1: 9aba001f18       lcall 0x181f, 0xba
  075766  42D6: ff36ae85         push word ptr [0x85ae]
  07576A  42DA: ff36ac85         push word ptr [0x85ac]
  07576E  42DE: ff36aa85         push word ptr [0x85aa]
  075772  42E2: ff36a885         push word ptr [0x85a8]
  075776  42E6: 6a01             push 1
  075778  42E8: 6a18             push 0x18
  07577A  42EA: 8b163c85         mov dx, word ptr [0x853c]
  07577E  42EE: 4a               dec dx
  07577F  42EF: 2bc0             sub ax, ax
  075781  42F1: 8b1e3a85         mov bx, word ptr [0x853a]
  075785  42F5: 9aba001f18       lcall 0x181f, 0xba
  07578A  42FA: 9aac031f18       lcall 0x181f, 0x3ac
  07578F  42FF: ff36a683         push word ptr [0x83a6]
  075793  4303: 9aca041f18       lcall 0x181f, 0x4ca
  075798  4308: 83c402           add sp, 2
  07579B  430B: ff7606           push word ptr [bp + 6]
  07579E  430E: 9a3e081f1a       lcall 0x1a1f, 0x83e
  0757A3  4313: 83c402           add sp, 2
  0757A6  4316: 9aac031f18       lcall 0x181f, 0x3ac
  0757AB  431B: 9a76091f1a       lcall 0x1a1f, 0x976
  0757B0  4320: 9a6c0b1f19       lcall 0x191f, 0xb6c
  0757B5  4325: 9aea071f1a       lcall 0x1a1f, 0x7ea
  0757BA  432A: 9af8071f1a       lcall 0x1a1f, 0x7f8
  0757BF  432F: 9aac031f18       lcall 0x181f, 0x3ac
  0757C4  4334: 6a19             push 0x19
  0757C6  4336: 6aff             push -1
  0757C8  4338: 68a953           push 0x53a9
  0757CB  433B: 9aae0d1d0d       lcall 0xd1d, 0xdae
  0757D0  4340: 83c406           add sp, 6
  0757D3  4343: c606a75300       mov byte ptr [0x53a7], 0
  0757D8  4348: 6a08             push 8
  0757DA  434A: 6a01             push 1
  0757DC  434C: 9ad4041f18       lcall 0x181f, 0x4d4
  0757E1  4351: 83c404           add sp, 4
  0757E4  4354: a2a853           mov byte ptr [0x53a8], al
  0757E7  4357: c7068a53d405     mov word ptr [0x538a], 0x5d4
  0757ED  435D: 2bc0             sub ax, ax
  0757EF  435F: a38e53           mov word ptr [0x538e], ax
  0757F2  4362: a38c53           mov word ptr [0x538c], ax
  0757F5  4365: a19853           mov ax, word ptr [0x5398]
  0757F8  4368: a39453           mov word ptr [0x5394], ax
  0757FB  436B: a39653           mov word ptr [0x5396], ax
  0757FE  436E: 833ea45300       cmp word ptr [0x53a4], 0
  075803  4373: 7c06             jl 0x437b
  075805  4375: a1a453           mov ax, word ptr [0x53a4]
  075808  4378: a39653           mov word ptr [0x5396], ax
  07580B  437B: ff36a683         push word ptr [0x83a6]
  07580F  437F: 9aca041f18       lcall 0x181f, 0x4ca
  075814  4384: 83c402           add sp, 2
  075817  4387: c746fa0000       mov word ptr [bp - 6], 0
  07581C  438C: e91a01           jmp 0x44a9
  07581F  438F: 90               nop 
  075820  4390: c746f80000       mov word ptr [bp - 8], 0
  075825  4395: c746f60000       mov word ptr [bp - 0xa], 0
  07582A  439A: 6976fa3c01       imul si, word ptr [bp - 6], 0x13c
  07582F  439F: 8b5ef6           mov bx, word ptr [bp - 0xa]
  075832  43A2: c6803c8800       mov byte ptr [bx + si - 0x77c4], 0
  075837  43A7: ff46f6           inc word ptr [bp - 0xa]
  07583A  43AA: 837ef60c         cmp word ptr [bp - 0xa], 0xc
  07583E  43AE: 7cea             jl 0x439a
  075840  43B0: 8b46fa           mov ax, word ptr [bp - 6]
  075843  43B3: 2d1c00           sub ax, 0x1c
  075846  43B6: 50               push ax
  075847  43B7: 50               push ax
  075848  43B8: ff76fa           push word ptr [bp - 6]
  07584B  43BB: 6a0d             push 0xd
  07584D  43BD: 9a5c091f18       lcall 0x181f, 0x95c
  075852  43C2: 83c408           add sp, 8
  075855  43C5: 8946f4           mov word ptr [bp - 0xc], ax
  075858  43C8: 6bd81c           imul bx, ax, 0x1c
  07585B  43CB: c6874c3100       mov byte ptr [bx + 0x314c], 0
  075860  43D0: 6976fa3c01       imul si, word ptr [bp - 6], 0x13c
  075865  43D5: 8a843a88         mov al, byte ptr [si - 0x77c6]
  075869  43D9: 88874d31         mov byte ptr [bx + 0x314d], al
  07586D  43DD: 8a843b88         mov al, byte ptr [si - 0x77c5]
  075871  43E1: 88874e31         mov byte ptr [bx + 0x314e], al
  075875  43E5: 837efa03         cmp word ptr [bp - 6], 3
  075879  43E9: 7505             jne 0x43f0
  07587B  43EB: c68746310e       mov byte ptr [bx + 0x3146], 0xe
  075880  43F0: 8b46fa           mov ax, word ptr [bp - 6]
  075883  43F3: 2d1c00           sub ax, 0x1c
  075886  43F6: 50               push ax
  075887  43F7: 50               push ax
  075888  43F8: ff76fa           push word ptr [bp - 6]
  07588B  43FB: 6a02             push 2
  07588D  43FD: 9a5c091f18       lcall 0x181f, 0x95c
  075892  4402: 83c408           add sp, 8
  075895  4405: 8946f4           mov word ptr [bp - 0xc], ax
  075898  4408: 6bd81c           imul bx, ax, 0x1c
  07589B  440B: c6874c3101       mov byte ptr [bx + 0x314c], 1
  0758A0  4410: 6976fa3c01       imul si, word ptr [bp - 6], 0x13c
  0758A5  4415: 8a843a88         mov al, byte ptr [si - 0x77c6]
  0758A9  4419: 88874d31         mov byte ptr [bx + 0x314d], al
  0758AD  441D: 8a843b88         mov al, byte ptr [si - 0x77c5]
  0758B1  4421: 88874e31         mov byte ptr [bx + 0x314e], al
  0758B5  4425: 837efa01         cmp word ptr [bp - 6], 1
  0758B9  4429: 7505             jne 0x4430
  0758BB  442B: c6875b3114       mov byte ptr [bx + 0x315b], 0x14
  0758C0  4430: 8b46fa           mov ax, word ptr [bp - 6]
  0758C3  4433: 2d1c00           sub ax, 0x1c
  0758C6  4436: 50               push ax
  0758C7  4437: 50               push ax
  0758C8  4438: ff76fa           push word ptr [bp - 6]
  0758CB  443B: 6a01             push 1
  0758CD  443D: 9a5c091f18       lcall 0x181f, 0x95c
  0758D2  4442: 83c408           add sp, 8
  0758D5  4445: 8946f4           mov word ptr [bp - 0xc], ax
  0758D8  4448: 6bd81c           imul bx, ax, 0x1c
  0758DB  444B: c6874c3101       mov byte ptr [bx + 0x314c], 1
  0758E0  4450: 6976fa3c01       imul si, word ptr [bp - 6], 0x13c
  0758E5  4455: 8a843a88         mov al, byte ptr [si - 0x77c6]
  0758E9  4459: 88874d31         mov byte ptr [bx + 0x314d], al
  0758ED  445D: 8a843b88         mov al, byte ptr [si - 0x77c5]
  0758F1  4461: 88874e31         mov byte ptr [bx + 0x314e], al
  0758F5  4465: 837ef800         cmp word ptr [bp - 8], 0
  0758F9  4469: 7407             je 0x4472
  0758FB  446B: 803ea65301       cmp byte ptr [0x53a6], 1
  075900  4470: 7606             jbe 0x4478
  075902  4472: 837efa02         cmp word ptr [bp - 6], 2
  075906  4476: 7509             jne 0x4481
  075908  4478: 6b5ef41c         imul bx, word ptr [bp - 0xc], 0x1c
  07590C  447C: c6875b3115       mov byte ptr [bx + 0x315b], 0x15
  075911  4481: 695efa3c01       imul bx, word ptr [bp - 6], 0x13c
  075916  4486: 8a873a88         mov al, byte ptr [bx - 0x77c6]
  07591A  448A: 2ae4             sub ah, ah
  07591C  448C: a37c01           mov word ptr [0x17c], ax
  07591F  448F: a34085           mov word ptr [0x8540], ax
  075922  4492: 8a873b88         mov al, byte ptr [bx - 0x77c5]
  075926  4496: a37e01           mov word ptr [0x17e], ax
  075929  4499: a33e85           mov word ptr [0x853e], ax
  07592C  449C: 6b5efa34         imul bx, word ptr [bp - 6], 0x34
  075930  44A0: c78740540000     mov word ptr [bx + 0x5440], 0
  075936  44A6: ff46fa           inc word ptr [bp - 6]
  075939  44A9: 837efa04         cmp word ptr [bp - 6], 4
  07593D  44AD: 7d2b             jge 0x44da
  07593F  44AF: 6b5efa34         imul bx, word ptr [bp - 6], 0x34
  075943  44B3: 80bf3f5402       cmp byte ptr [bx + 0x543f], 2
  075948  44B8: 74ec             je 0x44a6
  07594A  44BA: 837efa04         cmp word ptr [bp - 6], 4
  07594E  44BE: 7c03             jl 0x44c3
  075950  44C0: e9cdfe           jmp 0x4390
  075953  44C3: 6b5efa34         imul bx, word ptr [bp - 6], 0x34
  075957  44C7: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  07595C  44CC: 7403             je 0x44d1
  07595E  44CE: e9bffe           jmp 0x4390
  075961  44D1: c746f80100       mov word ptr [bp - 8], 1
  075966  44D6: e9bcfe           jmp 0x4395
  075969  44D9: 90               nop 
  07596A  44DA: 9a7c081f1a       lcall 0x1a1f, 0x87c
  07596F  44DF: 9aac031f18       lcall 0x181f, 0x3ac
  075974  44E4: 0bc0             or ax, ax
  075976  44E6: 74f7             je 0x44df
  075978  44E8: 9aac0a1f19       lcall 0x191f, 0xaac
  07597D  44ED: 9a5c0a1f1a       lcall 0x1a1f, 0xa5c
  075982  44F2: 6800a0           push 0xa000
  075985  44F5: 6800fc           push 0xfc00
  075988  44F8: 9af4031f18       lcall 0x181f, 0x3f4
  07598D  44FD: 803e280800       cmp byte ptr [0x828], 0
  075992  4502: 750c             jne 0x4510
  075994  4504: 833eac8300       cmp word ptr [0x83ac], 0
  075999  4509: 7405             je 0x4510
  07599B  450B: 9ae8041f18       lcall 0x181f, 0x4e8
  0759A0  4510: 6a25             push 0x25
  0759A2  4512: 9a8e041f18       lcall 0x181f, 0x48e
  0759A7  4517: 83c402           add sp, 2
  0759AA  451A: c746fe0000       mov word ptr [bp - 2], 0
  0759AF  451F: 803e280800       cmp byte ptr [0x828], 0
  0759B4  4524: 750c             jne 0x4532
  0759B6  4526: 833eac8300       cmp word ptr [0x83ac], 0
  0759BB  452B: 7405             je 0x4532
  0759BD  452D: 9ae8041f18       lcall 0x181f, 0x4e8
  0759C2  4532: 8b46fe           mov ax, word ptr [bp - 2]
  0759C5  4535: 5e               pop si
  0759C6  4536: c9               leave 
  0759C7  4537: cb               retf 
  0759C8  4538: 9ab6031f18       lcall 0x181f, 0x3b6
  0759CD  453D: 6800a0           push 0xa000
  0759D0  4540: 6800fc           push 0xfc00
  0759D3  4543: 9af4031f18       lcall 0x181f, 0x3f4
  0759D8  4548: 0e               push cs
  0759D9  4549: e8b709           call 0x4f03
  0759DC  454C: cb               retf 
  0759DD  454D: 90               nop 
  0759DE  454E: 9ab6031f18       lcall 0x181f, 0x3b6
  0759E3  4553: 0e               push cs
  0759E4  4554: e8b609           call 0x4f0d
  0759E7  4557: cb               retf 

; ---- func_0759E8  size=1455  insns=467  prologue=ENTER 0x03F4,0  terminal=RETF ----
  0759E8  4558: c8f40300         enter 0x3f4, 0
  0759EC  455C: b80100           mov ax, 1
  0759EF  455F: 89861eff         mov word ptr [bp - 0xe2], ax
  0759F3  4563: 89861cff         mov word ptr [bp - 0xe4], ax
  0759F7  4567: c78610ffc800     mov word ptr [bp - 0xf0], 0xc8
  0759FD  456D: c78612ff4001     mov word ptr [bp - 0xee], 0x140
  075A03  4573: c78614ff0000     mov word ptr [bp - 0xec], 0
  075A09  4579: c78616ff00a0     mov word ptr [bp - 0xea], 0xa000
  075A0F  457F: 9a3c051f18       lcall 0x181f, 0x53c
  075A14  4584: 833e040100       cmp word ptr [0x104], 0
  075A19  4589: 7437             je 0x45c2
  075A1B  458B: 6a03             push 3
  075A1D  458D: 9a98041f18       lcall 0x181f, 0x498
  075A22  4592: 83c402           add sp, 2
  075A25  4595: 6a0a             push 0xa
  075A27  4597: 8d8622ff         lea ax, [bp - 0xde]
  075A2B  459B: 50               push ax
  075A2C  459C: 9ada0c1f1a       lcall 0x1a1f, 0xcda
  075A31  45A1: 83c404           add sp, 4
  075A34  45A4: 8d8622ff         lea ax, [bp - 0xde]
  075A38  45A8: 50               push ax
  075A39  45A9: 0e               push cs
  075A3A  45AA: e83d09           call 0x4eea
  075A3D  45AD: 83c402           add sp, 2
  075A40  45B0: 0bc0             or ax, ax
  075A42  45B2: 750e             jne 0x45c2
  075A44  45B4: 3906ac83         cmp word ptr [0x83ac], ax
  075A48  45B8: 744d             je 0x4607
  075A4A  45BA: 9ae8041f18       lcall 0x181f, 0x4e8
  075A4F  45BF: eb46             jmp 0x4607
  075A51  45C1: 90               nop 
  075A52  45C2: 803e280800       cmp byte ptr [0x828], 0
  075A57  45C7: 7473             je 0x463c
  075A59  45C9: 6a05             push 5
  075A5B  45CB: 8d8622ff         lea ax, [bp - 0xde]
  075A5F  45CF: 50               push ax
  075A60  45D0: 9ada0c1f1a       lcall 0x1a1f, 0xcda
  075A65  45D5: 83c404           add sp, 4
  075A68  45D8: 6a00             push 0
  075A6A  45DA: 8d8672ff         lea ax, [bp - 0x8e]
  075A6E  45DE: 50               push ax
  075A6F  45DF: 8d8622ff         lea ax, [bp - 0xde]
  075A73  45E3: 50               push ax
  075A74  45E4: 0e               push cs
  075A75  45E5: e8fd08           call 0x4ee5
  075A78  45E8: 83c406           add sp, 6
  075A7B  45EB: 0bc0             or ax, ax
  075A7D  45ED: 7521             jne 0x4610
  075A7F  45EF: 81be7cffa406     cmp word ptr [bp - 0x84], 0x6a4
  075A85  45F5: 7d19             jge 0x4610
  075A87  45F7: 8d8622ff         lea ax, [bp - 0xde]
  075A8B  45FB: 50               push ax
  075A8C  45FC: 0e               push cs
  075A8D  45FD: e8ea08           call 0x4eea
  075A90  4600: 83c402           add sp, 2
  075A93  4603: 0bc0             or ax, ax
  075A95  4605: 7509             jne 0x4610
  075A97  4607: c606290801       mov byte ptr [0x829], 1
  075A9C  460C: e9e804           jmp 0x4af7
  075A9F  460F: 90               nop 
  075AA0  4610: 6a00             push 0
  075AA2  4612: 0e               push cs
  075AA3  4613: e81a09           call 0x4f30
  075AA6  4616: 83c402           add sp, 2
  075AA9  4619: 0bc0             or ax, ax
  075AAB  461B: 7403             je 0x4620
  075AAD  461D: e9dd04           jmp 0x4afd
  075AB0  4620: 89860cff         mov word ptr [bp - 0xf4], ax
  075AB4  4624: 6b9e0cff34       imul bx, word ptr [bp - 0xf4], 0x34
  075AB9  4629: c6873f5401       mov byte ptr [bx + 0x543f], 1
  075ABE  462E: ff860cff         inc word ptr [bp - 0xf4]
  075AC2  4632: 83be0cff04       cmp word ptr [bp - 0xf4], 4
  075AC7  4637: 7ceb             jl 0x4624
  075AC9  4639: e9bb04           jmp 0x4af7
  075ACC  463C: 8d860cfc         lea ax, [bp - 0x3f4]
  075AD0  4640: 16               push ss
  075AD1  4641: 50               push ax
  075AD2  4642: 6a00             push 0
  075AD4  4644: ff36a483         push word ptr [0x83a4]
  075AD8  4648: ff36a283         push word ptr [0x83a2]
  075ADC  464C: ff36a083         push word ptr [0x83a0]
  075AE0  4650: ff369e83         push word ptr [0x839e]
  075AE4  4654: 683c23           push 0x233c
  075AE7  4657: 9a4e041f18       lcall 0x181f, 0x44e
  075AEC  465C: 83c410           add sp, 0x10
  075AEF  465F: 0bc0             or ax, ax
  075AF1  4661: 743b             je 0x469e
  075AF3  4663: ff36a483         push word ptr [0x83a4]
  075AF7  4667: ff36a283         push word ptr [0x83a2]
  075AFB  466B: ff36a083         push word ptr [0x83a0]
  075AFF  466F: ff369e83         push word ptr [0x839e]
  075B03  4673: 2ac0             sub al, al
  075B05  4675: 9a84041f18       lcall 0x181f, 0x484
  075B0A  467A: 0e               push cs
  075B0B  467B: e89908           call 0x4f17
  075B0E  467E: 680003           push 0x300
  075B11  4681: 6800a0           push 0xa000
  075B14  4684: 6800fc           push 0xfc00
  075B17  4687: 8d860cfc         lea ax, [bp - 0x3f4]
  075B1B  468B: 16               push ss
  075B1C  468C: 50               push ax
  075B1D  468D: 9ab20f1d0d       lcall 0xd1d, 0xfb2
  075B22  4692: 83c40a           add sp, 0xa
  075B25  4695: c7860eff0100     mov word ptr [bp - 0xf2], 1
  075B2B  469B: e9fa00           jmp 0x4798
  075B2E  469E: 803e2a0800       cmp byte ptr [0x82a], 0
  075B33  46A3: 7431             je 0x46d6
  075B35  46A5: ffb616ff         push word ptr [bp - 0xea]
  075B39  46A9: ffb614ff         push word ptr [bp - 0xec]
  075B3D  46AD: ffb612ff         push word ptr [bp - 0xee]
  075B41  46B1: ffb610ff         push word ptr [bp - 0xf0]
  075B45  46B5: ff36a483         push word ptr [0x83a4]
  075B49  46B9: ff36a283         push word ptr [0x83a2]
  075B4D  46BD: ff36a083         push word ptr [0x83a0]
  075B51  46C1: ff369e83         push word ptr [0x839e]
  075B55  46C5: 68b000           push 0xb0
  075B58  46C8: 2bc0             sub ax, ax
  075B5A  46CA: 99               cdq 
  075B5B  46CB: bb4001           mov bx, 0x140
  075B5E  46CE: 9a44041f18       lcall 0x181f, 0x444
  075B63  46D3: eb0c             jmp 0x46e1
  075B65  46D5: 90               nop 
  075B66  46D6: 8d860cfc         lea ax, [bp - 0x3f4]
  075B6A  46DA: 16               push ss
  075B6B  46DB: 50               push ax
  075B6C  46DC: 9af4031f18       lcall 0x181f, 0x3f4
  075B71  46E1: ff36a483         push word ptr [0x83a4]
  075B75  46E5: ff36a283         push word ptr [0x83a2]
  075B79  46E9: ff36a083         push word ptr [0x83a0]
  075B7D  46ED: ff369e83         push word ptr [0x839e]
  075B81  46F1: 68c800           push 0xc8
  075B84  46F4: 6a07             push 7
  075B86  46F6: 6a06             push 6
  075B88  46F8: 2bc0             sub ax, ax
  075B8A  46FA: 99               cdq 
  075B8B  46FB: bb4001           mov bx, 0x140
  075B8E  46FE: 9af80d1f1a       lcall 0x1a1f, 0xdf8
  075B93  4703: ff36a483         push word ptr [0x83a4]
  075B97  4707: ff36a283         push word ptr [0x83a2]
  075B9B  470B: ff36a083         push word ptr [0x83a0]
  075B9F  470F: ff369e83         push word ptr [0x839e]
  075BA3  4713: 68c800           push 0xc8
  075BA6  4716: 6a08             push 8
  075BA8  4718: 6a09             push 9
  075BAA  471A: 2bc0             sub ax, ax
  075BAC  471C: 99               cdq 
  075BAD  471D: bb4001           mov bx, 0x140
  075BB0  4720: 9af80d1f1a       lcall 0x1a1f, 0xdf8
  075BB5  4725: ff36a483         push word ptr [0x83a4]
  075BB9  4729: ff36a283         push word ptr [0x83a2]
  075BBD  472D: ff36a083         push word ptr [0x83a0]
  075BC1  4731: ff369e83         push word ptr [0x839e]
  075BC5  4735: 68c800           push 0xc8
  075BC8  4738: 6a0f             push 0xf
  075BCA  473A: 6a0e             push 0xe
  075BCC  473C: 2bc0             sub ax, ax
  075BCE  473E: 99               cdq 
  075BCF  473F: bb4001           mov bx, 0x140
  075BD2  4742: 9af80d1f1a       lcall 0x1a1f, 0xdf8
  075BD7  4747: ff36a483         push word ptr [0x83a4]
  075BDB  474B: ff36a283         push word ptr [0x83a2]
  075BDF  474F: ff36a083         push word ptr [0x83a0]
  075BE3  4753: ff369e83         push word ptr [0x839e]
  075BE7  4757: ff36ae2d         push word ptr [0x2dae]
  075BEB  475B: ff36ac2d         push word ptr [0x2dac]
  075BEF  475F: ff36aa2d         push word ptr [0x2daa]
  075BF3  4763: ff36a82d         push word ptr [0x2da8]
  075BF7  4767: 68c800           push 0xc8
  075BFA  476A: 2bc0             sub ax, ax
  075BFC  476C: 99               cdq 
  075BFD  476D: bb4001           mov bx, 0x140
  075C00  4770: 9a44041f18       lcall 0x181f, 0x444
  075C05  4775: 6a00             push 0
  075C07  4777: 684001           push 0x140
  075C0A  477A: 68c800           push 0xc8
  075C0D  477D: 2bc0             sub ax, ax
  075C0F  477F: 99               cdq 
  075C10  4780: 2bdb             sub bx, bx
  075C12  4782: 9ae2001f18       lcall 0x181f, 0xe2
  075C17  4787: 8d860cfc         lea ax, [bp - 0x3f4]
  075C1B  478B: 16               push ss
  075C1C  478C: 50               push ax
  075C1D  478D: 9af4031f18       lcall 0x181f, 0x3f4
  075C22  4792: c7860eff0000     mov word ptr [bp - 0xf2], 0
  075C28  4798: 6a33             push 0x33
  075C2A  479A: 9ade041f18       lcall 0x181f, 0x4de
  075C2F  479F: 83c402           add sp, 2
  075C32  47A2: 9a3c0f1f18       lcall 0x181f, 0xf3c
  075C37  47A7: 803e280800       cmp byte ptr [0x828], 0
  075C3C  47AC: 750c             jne 0x47ba
  075C3E  47AE: 833eac8300       cmp word ptr [0x83ac], 0
  075C43  47B3: 7405             je 0x47ba
  075C45  47B5: 9ae8041f18       lcall 0x181f, 0x4e8
  075C4A  47BA: 83be0eff00       cmp word ptr [bp - 0xf2], 0
  075C4F  47BF: 7504             jne 0x47c5
  075C51  47C1: 0e               push cs
  075C52  47C2: e84807           call 0x4f0d
  075C55  47C5: 9a3c0f1f18       lcall 0x181f, 0xf3c
  075C5A  47CA: c7861cff0000     mov word ptr [bp - 0xe4], 0
  075C60  47D0: 8d1e4523         lea bx, [0x2345]
  075C64  47D4: 9afe031f18       lcall 0x181f, 0x3fe
  075C69  47D9: 898620ff         mov word ptr [bp - 0xe0], ax
  075C6D  47DD: 48               dec ax
  075C6E  47DE: 7d03             jge 0x47e3
  075C70  47E0: e91a03           jmp 0x4afd
  075C73  47E3: 48               dec ax
  075C74  47E4: 48               dec ax
  075C75  47E5: 7e0f             jle 0x47f6
  075C77  47E7: 48               dec ax
  075C78  47E8: 7503             jne 0x47ed
  075C7A  47EA: e96d01           jmp 0x495a
  075C7D  47ED: 48               dec ax
  075C7E  47EE: 7503             jne 0x47f3
  075C80  47F0: e92d02           jmp 0x4a20
  075C83  47F3: e90703           jmp 0x4afd
  075C86  47F6: c7860cff0000     mov word ptr [bp - 0xf4], 0
  075C8C  47FC: eb1a             jmp 0x4818
  075C8E  47FE: 6a03             push 3
  075C90  4800: 6a00             push 0
  075C92  4802: 9ad4041f18       lcall 0x181f, 0x4d4
  075C97  4807: 83c404           add sp, 4
  075C9A  480A: 8b9e0cff         mov bx, word ptr [bp - 0xf4]
  075C9E  480E: d1e3             shl bx, 1
  075CA0  4810: 89877e1e         mov word ptr [bx + 0x1e7e], ax
  075CA4  4814: ff860cff         inc word ptr [bp - 0xf4]
  075CA8  4818: 83be0cff05       cmp word ptr [bp - 0xf4], 5
  075CAD  481D: 7d15             jge 0x4834
  075CAF  481F: 83be20ff03       cmp word ptr [bp - 0xe0], 3
  075CB4  4824: 75d8             jne 0x47fe
  075CB6  4826: 8b9e0cff         mov bx, word ptr [bp - 0xf4]
  075CBA  482A: d1e3             shl bx, 1
  075CBC  482C: c7877e1e0100     mov word ptr [bx + 0x1e7e], 1
  075CC2  4832: ebe0             jmp 0x4814
  075CC4  4834: 83be20ff03       cmp word ptr [bp - 0xe0], 3
  075CC9  4839: 750f             jne 0x484a
  075CCB  483B: 9ae40b1f1a       lcall 0x1a1f, 0xbe4
  075CD0  4840: 0bc0             or ax, ax
  075CD2  4842: 7406             je 0x484a
  075CD4  4844: c7861cff0100     mov word ptr [bp - 0xe4], 1
  075CDA  484A: 0e               push cs
  075CDB  484B: e8c906           call 0x4f17
  075CDE  484E: 83be20ff02       cmp word ptr [bp - 0xe0], 2
  075CE3  4853: 7567             jne 0x48bc
  075CE5  4855: 8d1e4f23         lea bx, [0x234f]
  075CE9  4859: 9afe031f18       lcall 0x181f, 0x3fe
  075CEE  485E: 89861aff         mov word ptr [bp - 0xe6], ax
  075CF2  4862: 3d0100           cmp ax, 1
  075CF5  4865: 7d09             jge 0x4870
  075CF7  4867: c7861cff0100     mov word ptr [bp - 0xe4], 1
  075CFD  486D: eb4d             jmp 0x48bc
  075CFF  486F: 90               nop 
  075D00  4870: 3d0100           cmp ax, 1
  075D03  4873: 7e47             jle 0x48bc
  075D05  4875: 8d8622ff         lea ax, [bp - 0xde]
  075D09  4879: 50               push ax
  075D0A  487A: 685723           push 0x2357
  075D0D  487D: 685c23           push 0x235c
  075D10  4880: 686623           push 0x2366
  075D13  4883: 0e               push cs
  075D14  4884: e89f06           call 0x4f26
  075D17  4887: 83c408           add sp, 8
  075D1A  488A: 89861aff         mov word ptr [bp - 0xe6], ax
  075D1E  488E: 0bc0             or ax, ax
  075D20  4890: 7cd5             jl 0x4867
  075D22  4892: 686621           push 0x2166
  075D25  4895: 8d8622ff         lea ax, [bp - 0xde]
  075D29  4899: 50               push ax
  075D2A  489A: 9a16081d0d       lcall 0xd1d, 0x816
  075D2F  489F: 83c404           add sp, 4
  075D32  48A2: 0bc0             or ax, ax
  075D34  48A4: 7416             je 0x48bc
  075D36  48A6: c70674210100     mov word ptr [0x2174], 1
  075D3C  48AC: 8d8622ff         lea ax, [bp - 0xde]
  075D40  48B0: 50               push ax
  075D41  48B1: 686621           push 0x2166
  075D44  48B4: 9ae4071d0d       lcall 0xd1d, 0x7e4
  075D49  48B9: 83c404           add sp, 4
  075D4C  48BC: 83be1cff00       cmp word ptr [bp - 0xe4], 0
  075D51  48C1: 752e             jne 0x48f1
  075D53  48C3: 83be20ff02       cmp word ptr [bp - 0xe0], 2
  075D58  48C8: 7506             jne 0x48d0
  075D5A  48CA: b80100           mov ax, 1
  075D5D  48CD: eb03             jmp 0x48d2
  075D5F  48CF: 90               nop 
  075D60  48D0: 2bc0             sub ax, ax
  075D62  48D2: 50               push ax
  075D63  48D3: 0e               push cs
  075D64  48D4: e85906           call 0x4f30
  075D67  48D7: 83c402           add sp, 2
  075D6A  48DA: 89861aff         mov word ptr [bp - 0xe6], ax
  075D6E  48DE: 48               dec ax
  075D6F  48DF: 7506             jne 0x48e7
  075D71  48E1: c7861cff0100     mov word ptr [bp - 0xe4], 1
  075D77  48E7: 83be1aff01       cmp word ptr [bp - 0xe6], 1
  075D7C  48EC: 7e03             jle 0x48f1
  075D7E  48EE: e90c02           jmp 0x4afd
  075D81  48F1: 83be1cff00       cmp word ptr [bp - 0xe4], 0
  075D86  48F6: 7503             jne 0x48fb
  075D88  48F8: e9f201           jmp 0x4aed
  075D8B  48FB: 8d860cfc         lea ax, [bp - 0x3f4]
  075D8F  48FF: 16               push ss
  075D90  4900: 50               push ax
  075D91  4901: 6a00             push 0
  075D93  4903: ff36a483         push word ptr [0x83a4]
  075D97  4907: ff36a283         push word ptr [0x83a2]
  075D9B  490B: ff36a083         push word ptr [0x83a0]
  075D9F  490F: ff369e83         push word ptr [0x839e]
  075DA3  4913: 687423           push 0x2374
  075DA6  4916: 9a4e041f18       lcall 0x181f, 0x44e
  075DAB  491B: 83c410           add sp, 0x10
  075DAE  491E: 0bc0             or ax, ax
  075DB0  4920: 7503             jne 0x4925
  075DB2  4922: e91301           jmp 0x4a38
  075DB5  4925: ff36a483         push word ptr [0x83a4]
  075DB9  4929: ff36a283         push word ptr [0x83a2]
  075DBD  492D: ff36a083         push word ptr [0x83a0]
  075DC1  4931: ff369e83         push word ptr [0x839e]
  075DC5  4935: 2ac0             sub al, al
  075DC7  4937: 9a84041f18       lcall 0x181f, 0x484
  075DCC  493C: 0e               push cs
  075DCD  493D: e8d705           call 0x4f17
  075DD0  4940: 680003           push 0x300
  075DD3  4943: 6800a0           push 0xa000
  075DD6  4946: 6800fc           push 0xfc00
  075DD9  4949: 8d860cfc         lea ax, [bp - 0x3f4]
  075DDD  494D: 16               push ss
  075DDE  494E: 50               push ax
  075DDF  494F: 9ab20f1d0d       lcall 0xd1d, 0xfb2
  075DE4  4954: 83c40a           add sp, 0xa
  075DE7  4957: e99301           jmp 0x4aed
  075DEA  495A: 0e               push cs
  075DEB  495B: e8b905           call 0x4f17
  075DEE  495E: 6a00             push 0
  075DF0  4960: ff36a483         push word ptr [0x83a4]
  075DF4  4964: ff36a283         push word ptr [0x83a2]
  075DF8  4968: ff36a083         push word ptr [0x83a0]
  075DFC  496C: ff369e83         push word ptr [0x839e]
  075E00  4970: 686b23           push 0x236b
  075E03  4973: 9a7a081f19       lcall 0x191f, 0x87a
  075E08  4978: 83c40c           add sp, 0xc
  075E0B  497B: 3d0100           cmp ax, 1
  075E0E  497E: 1bc0             sbb ax, ax
  075E10  4980: f7d8             neg ax
  075E12  4982: 898618ff         mov word ptr [bp - 0xe8], ax
  075E16  4986: 0bc0             or ax, ax
  075E18  4988: 7445             je 0x49cf
  075E1A  498A: 9a0a041f18       lcall 0x181f, 0x40a
  075E1F  498F: ff36a483         push word ptr [0x83a4]
  075E23  4993: ff36a283         push word ptr [0x83a2]
  075E27  4997: ff36a083         push word ptr [0x83a0]
  075E2B  499B: ff369e83         push word ptr [0x839e]
  075E2F  499F: ff36ae2d         push word ptr [0x2dae]
  075E33  49A3: ff36ac2d         push word ptr [0x2dac]
  075E37  49A7: ff36aa2d         push word ptr [0x2daa]
  075E3B  49AB: ff36a82d         push word ptr [0x2da8]
  075E3F  49AF: 68c800           push 0xc8
  075E42  49B2: 2bc0             sub ax, ax
  075E44  49B4: 99               cdq 
  075E45  49B5: bb4001           mov bx, 0x140
  075E48  49B8: 9a44041f18       lcall 0x181f, 0x444
  075E4D  49BD: 6a00             push 0
  075E4F  49BF: 684001           push 0x140
  075E52  49C2: 68c800           push 0xc8
  075E55  49C5: 2bc0             sub ax, ax
  075E57  49C7: 99               cdq 
  075E58  49C8: 2bdb             sub bx, bx
  075E5A  49CA: 9ae2001f18       lcall 0x181f, 0xe2
  075E5F  49CF: 9a20031f19       lcall 0x191f, 0x320
  075E64  49D4: 89861aff         mov word ptr [bp - 0xe6], ax
  075E68  49D8: 0bc0             or ax, ax
  075E6A  49DA: 752a             jne 0x4a06
  075E6C  49DC: c606290801       mov byte ptr [0x829], 1
  075E71  49E1: f606825301       test byte ptr [0x5382], 1
  075E76  49E6: 740a             je 0x49f2
  075E78  49E8: 6a03             push 3
  075E7A  49EA: 9aac041f18       lcall 0x181f, 0x4ac
  075E7F  49EF: eb12             jmp 0x4a03
  075E81  49F1: 90               nop 
  075E82  49F2: 6a01             push 1
  075E84  49F4: 9aac041f18       lcall 0x181f, 0x4ac
  075E89  49F9: 83c402           add sp, 2
  075E8C  49FC: 6a02             push 2
  075E8E  49FE: 9aa2041f18       lcall 0x181f, 0x4a2
  075E93  4A03: 83c402           add sp, 2
  075E96  4A06: 83be1aff01       cmp word ptr [bp - 0xe6], 1
  075E9B  4A0B: 7506             jne 0x4a13
  075E9D  4A0D: c7861cff0100     mov word ptr [bp - 0xe4], 1
  075EA3  4A13: 83be1aff01       cmp word ptr [bp - 0xe6], 1
  075EA8  4A18: 7f03             jg 0x4a1d
  075EAA  4A1A: e9d4fe           jmp 0x48f1
  075EAD  4A1D: e9dd00           jmp 0x4afd
  075EB0  4A20: c7861cff0100     mov word ptr [bp - 0xe4], 1
  075EB6  4A26: 0e               push cs
  075EB7  4A27: e8ed04           call 0x4f17
  075EBA  4A2A: 6a00             push 0
  075EBC  4A2C: 9a8e0f1f19       lcall 0x191f, 0xf8e
  075EC1  4A31: 83c402           add sp, 2
  075EC4  4A34: e9bafe           jmp 0x48f1
  075EC7  4A37: 90               nop 
  075EC8  4A38: 0e               push cs
  075EC9  4A39: e8e004           call 0x4f1c
  075ECC  4A3C: 8d860cfc         lea ax, [bp - 0x3f4]
  075ED0  4A40: 16               push ss
  075ED1  4A41: 50               push ax
  075ED2  4A42: 9af4031f18       lcall 0x181f, 0x3f4
  075ED7  4A47: ff36a483         push word ptr [0x83a4]
  075EDB  4A4B: ff36a283         push word ptr [0x83a2]
  075EDF  4A4F: ff36a083         push word ptr [0x83a0]
  075EE3  4A53: ff369e83         push word ptr [0x839e]
  075EE7  4A57: 68c800           push 0xc8
  075EEA  4A5A: 6a07             push 7
  075EEC  4A5C: 6a06             push 6
  075EEE  4A5E: 2bc0             sub ax, ax
  075EF0  4A60: 99               cdq 
  075EF1  4A61: bb4001           mov bx, 0x140
  075EF4  4A64: 9af80d1f1a       lcall 0x1a1f, 0xdf8
  075EF9  4A69: ff36a483         push word ptr [0x83a4]
  075EFD  4A6D: ff36a283         push word ptr [0x83a2]
  075F01  4A71: ff36a083         push word ptr [0x83a0]
  075F05  4A75: ff369e83         push word ptr [0x839e]
  075F09  4A79: 68c800           push 0xc8
  075F0C  4A7C: 6a08             push 8
  075F0E  4A7E: 6a09             push 9
  075F10  4A80: 2bc0             sub ax, ax
  075F12  4A82: 99               cdq 
  075F13  4A83: bb4001           mov bx, 0x140
  075F16  4A86: 9af80d1f1a       lcall 0x1a1f, 0xdf8
  075F1B  4A8B: ff36a483         push word ptr [0x83a4]
  075F1F  4A8F: ff36a283         push word ptr [0x83a2]
  075F23  4A93: ff36a083         push word ptr [0x83a0]
  075F27  4A97: ff369e83         push word ptr [0x839e]
  075F2B  4A9B: 68c800           push 0xc8
  075F2E  4A9E: 6a0f             push 0xf
  075F30  4AA0: 6a0e             push 0xe
  075F32  4AA2: 2bc0             sub ax, ax
  075F34  4AA4: 99               cdq 
  075F35  4AA5: bb4001           mov bx, 0x140
  075F38  4AA8: 9af80d1f1a       lcall 0x1a1f, 0xdf8
  075F3D  4AAD: ff36a483         push word ptr [0x83a4]
  075F41  4AB1: ff36a283         push word ptr [0x83a2]
  075F45  4AB5: ff36a083         push word ptr [0x83a0]
  075F49  4AB9: ff369e83         push word ptr [0x839e]
  075F4D  4ABD: ff36ae2d         push word ptr [0x2dae]
  075F51  4AC1: ff36ac2d         push word ptr [0x2dac]
  075F55  4AC5: ff36aa2d         push word ptr [0x2daa]
  075F59  4AC9: ff36a82d         push word ptr [0x2da8]
  075F5D  4ACD: 68c800           push 0xc8
  075F60  4AD0: 2bc0             sub ax, ax
  075F62  4AD2: 99               cdq 
  075F63  4AD3: bb4001           mov bx, 0x140
  075F66  4AD6: 9a44041f18       lcall 0x181f, 0x444
  075F6B  4ADB: 6a00             push 0
  075F6D  4ADD: 684001           push 0x140
  075F70  4AE0: 68c800           push 0xc8
  075F73  4AE3: 2bc0             sub ax, ax
  075F75  4AE5: 99               cdq 
  075F76  4AE6: 2bdb             sub bx, bx
  075F78  4AE8: 9ae2001f18       lcall 0x181f, 0xe2
  075F7D  4AED: 83be1cff00       cmp word ptr [bp - 0xe4], 0
  075F82  4AF2: 7403             je 0x4af7
  075F84  4AF4: e9c3fc           jmp 0x47ba
  075F87  4AF7: c7861eff0000     mov word ptr [bp - 0xe2], 0
  075F8D  4AFD: 0e               push cs
  075F8E  4AFE: e81604           call 0x4f17
  075F91  4B01: 8b861eff         mov ax, word ptr [bp - 0xe2]
  075F95  4B05: c9               leave 
  075F96  4B06: cb               retf 

; ---- func_075F98  size=30  insns=12  prologue=ENTER 0x0300,0  terminal=RETF ----
  075F98  4B08: c8000300         enter 0x300, 0
  075F9C  4B0C: 8d8600fd         lea ax, [bp - 0x300]
  075FA0  4B10: 16               push ss
  075FA1  4B11: 50               push ax
  075FA2  4B12: 9a780a1f1a       lcall 0x1a1f, 0xa78
  075FA7  4B17: 8d8600fd         lea ax, [bp - 0x300]
  075FAB  4B1B: 16               push ss
  075FAC  4B1C: 50               push ax
  075FAD  4B1D: 2bc0             sub ax, ax
  075FAF  4B1F: 9a6a0a1f1a       lcall 0x1a1f, 0xa6a
  075FB4  4B24: c9               leave 
  075FB5  4B25: cb               retf 

; ---- func_075FB6  size=1039  insns=298  prologue=ENTER 0x000C,0  terminal=page-end ----
  075FB6  4B26: c80c0000         enter 0xc, 0
  075FBA  4B2A: c746f81300       mov word ptr [bp - 8], 0x13
  075FBF  4B2F: 9a400e1f1a       lcall 0x1a1f, 0xe40
  075FC4  4B34: 9ab80e1f18       lcall 0x181f, 0xeb8
  075FC9  4B39: 9a5e0e1f18       lcall 0x181f, 0xe5e
  075FCE  4B3E: a3a683           mov word ptr [0x83a6], ax
  075FD1  4B41: 9a680e1f18       lcall 0x181f, 0xe68
  075FD6  4B46: 9a5e0e1f18       lcall 0x181f, 0xe5e
  075FDB  4B4B: a37a91           mov word ptr [0x917a], ax
  075FDE  4B4E: 9a680e1f18       lcall 0x181f, 0xe68
  075FE3  4B53: 9a5e0e1f18       lcall 0x181f, 0xe5e
  075FE8  4B58: a3a883           mov word ptr [0x83a8], ax
  075FEB  4B5B: 9a680e1f18       lcall 0x181f, 0xe68
  075FF0  4B60: 9a720e1f18       lcall 0x181f, 0xe72
  075FF5  4B65: a3808d           mov word ptr [0x8d80], ax
  075FF8  4B68: 8916828d         mov word ptr [0x8d82], dx
  075FFC  4B6C: 8b46f8           mov ax, word ptr [bp - 8]
  075FFF  4B6F: 9a360e1f1a       lcall 0x1a1f, 0xe36
  076004  4B74: 803e2a0800       cmp byte ptr [0x82a], 0
  076009  4B79: 751b             jne 0x4b96
  07600B  4B7B: 837ef803         cmp word ptr [bp - 8], 3
  07600F  4B7F: 7405             je 0x4b86
  076011  4B81: b80100           mov ax, 1
  076014  4B84: eb02             jmp 0x4b88
  076016  4B86: 2bc0             sub ax, ax
  076018  4B88: 50               push ax
  076019  4B89: ff76f8           push word ptr [bp - 8]
  07601C  4B8C: 9ad60e1f18       lcall 0x181f, 0xed6
  076021  4B91: 83c404           add sp, 4
  076024  4B94: eb06             jmp 0x4b9c
  076026  4B96: 8b46f8           mov ax, word ptr [bp - 8]
  076029  4B99: a3aa83           mov word ptr [0x83aa], ax
  07602C  4B9C: ff76f8           push word ptr [bp - 8]
  07602F  4B9F: 6a01             push 1
  076031  4BA1: 9ac4051f18       lcall 0x181f, 0x5c4
  076036  4BA6: 83c404           add sp, 4
  076039  4BA9: 6800a0           push 0xa000
  07603C  4BAC: 6800fc           push 0xfc00
  07603F  4BAF: 8d1e7d23         lea bx, [0x237d]
  076043  4BB3: 9a280e1f1a       lcall 0x1a1f, 0xe28
  076048  4BB8: 0bc0             or ax, ax
  07604A  4BBA: 740a             je 0x4bc6
  07604C  4BBC: c70622081300     mov word ptr [0x822], 0x13
  076052  4BC2: e9e002           jmp 0x4ea5
  076055  4BC5: 90               nop 
  076056  4BC6: 8d1e3083         lea bx, [0x8330]
  07605A  4BCA: b82000           mov ax, 0x20
  07605D  4BCD: 8bd0             mov dx, ax
  07605F  4BCF: 9a020e1f1a       lcall 0x1a1f, 0xe02
  076064  4BD4: a13683           mov ax, word ptr [0x8336]
  076067  4BD7: 0b063483         or ax, word ptr [0x8334]
  07606B  4BDB: 7509             jne 0x4be6
  07606D  4BDD: c70622081400     mov word ptr [0x822], 0x14
  076073  4BE3: e9bf02           jmp 0x4ea5
  076076  4BE6: 8d1ea82d         lea bx, [0x2da8]
  07607A  4BEA: b84001           mov ax, 0x140
  07607D  4BED: bac800           mov dx, 0xc8
  076080  4BF0: 9a020e1f1a       lcall 0x1a1f, 0xe02
  076085  4BF5: a1ae2d           mov ax, word ptr [0x2dae]
  076088  4BF8: 0b06ac2d         or ax, word ptr [0x2dac]
  07608C  4BFC: 74df             je 0x4bdd
  07608E  4BFE: 8d1e9e83         lea bx, [0x839e]
  076092  4C02: b84001           mov ax, 0x140
  076095  4C05: bac800           mov dx, 0xc8
  076098  4C08: 9a020e1f1a       lcall 0x1a1f, 0xe02
  07609D  4C0D: a1a483           mov ax, word ptr [0x83a4]
  0760A0  4C10: 0b06a283         or ax, word ptr [0x83a2]
  0760A4  4C14: 74c7             je 0x4bdd
  0760A6  4C16: 9a1e0e1f1a       lcall 0x1a1f, 0xe1e
  0760AB  4C1B: ff36ae2d         push word ptr [0x2dae]
  0760AF  4C1F: ff36ac2d         push word ptr [0x2dac]
  0760B3  4C23: ff36aa2d         push word ptr [0x2daa]
  0760B7  4C27: ff36a82d         push word ptr [0x2da8]
  0760BB  4C2B: 2ac0             sub al, al
  0760BD  4C2D: 9a84041f18       lcall 0x181f, 0x484
  0760C2  4C32: 8d1e8923         lea bx, [0x2389]
  0760C6  4C36: 9a860a1f1a       lcall 0x1a1f, 0xa86
  0760CB  4C3B: a38a26           mov word ptr [0x268a], ax
  0760CE  4C3E: 89168c26         mov word ptr [0x268c], dx
  0760D2  4C42: 8bc2             mov ax, dx
  0760D4  4C44: 0b068a26         or ax, word ptr [0x268a]
  0760D8  4C48: 750a             jne 0x4c54
  0760DA  4C4A: c70622081500     mov word ptr [0x822], 0x15
  0760E0  4C50: e95202           jmp 0x4ea5
  0760E3  4C53: 90               nop 
  0760E4  4C54: 8d1e9223         lea bx, [0x2392]
  0760E8  4C58: 9a860a1f1a       lcall 0x1a1f, 0xa86
  0760ED  4C5D: a39e08           mov word ptr [0x89e], ax
  0760F0  4C60: 8916a008         mov word ptr [0x8a0], dx
  0760F4  4C64: 8bc2             mov ax, dx
  0760F6  4C66: 0b069e08         or ax, word ptr [0x89e]
  0760FA  4C6A: 750a             jne 0x4c76
  0760FC  4C6C: c70622081600     mov word ptr [0x822], 0x16
  076102  4C72: e93002           jmp 0x4ea5
  076105  4C75: 90               nop 
  076106  4C76: 0e               push cs
  076107  4C77: e89802           call 0x4f12
  07610A  4C7A: 0e               push cs
  07610B  4C7B: e88a02           call 0x4f08
  07610E  4C7E: a03508           mov al, byte ptr [0x835]
  076111  4C81: 2ae4             sub ah, ah
  076113  4C83: a3a814           mov word ptr [0x14a8], ax
  076116  4C86: a3a414           mov word ptr [0x14a4], ax
  076119  4C89: a03008           mov al, byte ptr [0x830]
  07611C  4C8C: a3b414           mov word ptr [0x14b4], ax
  07611F  4C8F: a3ae14           mov word ptr [0x14ae], ax
  076122  4C92: a03208           mov al, byte ptr [0x832]
  076125  4C95: a3b614           mov word ptr [0x14b6], ax
  076128  4C98: a3b014           mov word ptr [0x14b0], ax
  07612B  4C9B: a03108           mov al, byte ptr [0x831]
  07612E  4C9E: a3b814           mov word ptr [0x14b8], ax
  076131  4CA1: a3b214           mov word ptr [0x14b2], ax
  076134  4CA4: 680010           push 0x1000
  076137  4CA7: ff368c26         push word ptr [0x268c]
  07613B  4CAB: ff368a26         push word ptr [0x268a]
  07613F  4CAF: 9ac4071f1a       lcall 0x1a1f, 0x7c4
  076144  4CB4: 83c406           add sp, 6
  076147  4CB7: 9abe0c1f1a       lcall 0x1a1f, 0xcbe
  07614C  4CBC: 0bc0             or ax, ax
  07614E  4CBE: 7403             je 0x4cc3
  076150  4CC0: e9e201           jmp 0x4ea5
  076153  4CC3: 8d1e9b23         lea bx, [0x239b]
  076157  4CC7: b80040           mov ax, 0x4000
  07615A  4CCA: 9a72031f1a       lcall 0x1a1f, 0x372
  07615F  4CCF: a33a08           mov word ptr [0x83a], ax
  076162  4CD2: 89163c08         mov word ptr [0x83c], dx
  076166  4CD6: 8bc2             mov ax, dx
  076168  4CD8: 0b063a08         or ax, word ptr [0x83a]
  07616C  4CDC: 750a             jne 0x4ce8
  07616E  4CDE: c70622081700     mov word ptr [0x822], 0x17
  076174  4CE4: e9be01           jmp 0x4ea5
  076177  4CE7: 90               nop 
  076178  4CE8: 9a100e1f1a       lcall 0x1a1f, 0xe10
  07617D  4CED: 0bc0             or ax, ax
  07617F  4CEF: 7409             je 0x4cfa
  076181  4CF1: c70622081800     mov word ptr [0x822], 0x18
  076187  4CF7: e9ab01           jmp 0x4ea5
  07618A  4CFA: 9aac0a1f19       lcall 0x191f, 0xaac
  07618F  4CFF: 0bc0             or ax, ax
  076191  4D01: 7409             je 0x4d0c
  076193  4D03: c70622081900     mov word ptr [0x822], 0x19
  076199  4D09: e99901           jmp 0x4ea5
  07619C  4D0C: 8d1ef093         lea bx, [0x93f0]
  0761A0  4D10: b82000           mov ax, 0x20
  0761A3  4D13: ba1800           mov dx, 0x18
  0761A6  4D16: 9a020e1f1a       lcall 0x1a1f, 0xe02
  0761AB  4D1B: a1f693           mov ax, word ptr [0x93f6]
  0761AE  4D1E: 0b06f493         or ax, word ptr [0x93f4]
  0761B2  4D22: 750a             jne 0x4d2e
  0761B4  4D24: c70622081a00     mov word ptr [0x822], 0x1a
  0761BA  4D2A: e97801           jmp 0x4ea5
  0761BD  4D2D: 90               nop 
  0761BE  4D2E: 8d1ef893         lea bx, [0x93f8]
  0761C2  4D32: b82000           mov ax, 0x20
  0761C5  4D35: ba1800           mov dx, 0x18
  0761C8  4D38: 9a020e1f1a       lcall 0x1a1f, 0xe02
  0761CD  4D3D: a1f693           mov ax, word ptr [0x93f6]
  0761D0  4D40: 0b06f493         or ax, word ptr [0x93f4]
  0761D4  4D44: 750a             jne 0x4d50
  0761D6  4D46: c70622081b00     mov word ptr [0x822], 0x1b
  0761DC  4D4C: e95601           jmp 0x4ea5
  0761DF  4D4F: 90               nop 
  0761E0  4D50: 8d1ea223         lea bx, [0x23a2]
  0761E4  4D54: b80040           mov ax, 0x4000
  0761E7  4D57: 9a72031f1a       lcall 0x1a1f, 0x372
  0761EC  4D5C: 8946f4           mov word ptr [bp - 0xc], ax
  0761EF  4D5F: 8956f6           mov word ptr [bp - 0xa], dx
  0761F2  4D62: 0bd0             or dx, ax
  0761F4  4D64: 750a             jne 0x4d70
  0761F6  4D66: c70622081c00     mov word ptr [0x822], 0x1c
  0761FC  4D6C: e93601           jmp 0x4ea5
  0761FF  4D6F: 90               nop 
  076200  4D70: ff76f6           push word ptr [bp - 0xa]
  076203  4D73: 50               push ax
  076204  4D74: 6a00             push 0
  076206  4D76: b80100           mov ax, 1
  076209  4D79: 8d1ef093         lea bx, [0x93f0]
  07620D  4D7D: 2bd2             sub dx, dx
  07620F  4D7F: 9a54021f18       lcall 0x181f, 0x254
  076214  4D84: ff76f6           push word ptr [bp - 0xa]
  076217  4D87: ff76f4           push word ptr [bp - 0xc]
  07621A  4D8A: 9aa8011f19       lcall 0x191f, 0x1a8
  07621F  4D8F: 8d1eab23         lea bx, [0x23ab]
  076223  4D93: b80040           mov ax, 0x4000
  076226  4D96: 9a72031f1a       lcall 0x1a1f, 0x372
  07622B  4D9B: 8946fa           mov word ptr [bp - 6], ax
  07622E  4D9E: 8956fc           mov word ptr [bp - 4], dx
  076231  4DA1: 0bd0             or dx, ax
  076233  4DA3: 7509             jne 0x4dae
  076235  4DA5: c70622081d00     mov word ptr [0x822], 0x1d
  07623B  4DAB: e9f700           jmp 0x4ea5
  07623E  4DAE: ff76fc           push word ptr [bp - 4]
  076241  4DB1: 50               push ax
  076242  4DB2: 6a00             push 0
  076244  4DB4: b80100           mov ax, 1
  076247  4DB7: 8d1ef893         lea bx, [0x93f8]
  07624B  4DBB: 2bd2             sub dx, dx
  07624D  4DBD: 9a54021f18       lcall 0x181f, 0x254
  076252  4DC2: ff76fc           push word ptr [bp - 4]
  076255  4DC5: ff76fa           push word ptr [bp - 6]
  076258  4DC8: 9aa8011f19       lcall 0x191f, 0x1a8
  07625D  4DCD: 8d1eb123         lea bx, [0x23b1]
  076261  4DD1: b80040           mov ax, 0x4000
  076264  4DD4: 9a72031f1a       lcall 0x1a1f, 0x372
  076269  4DD9: 8946fa           mov word ptr [bp - 6], ax
  07626C  4DDC: 8956fc           mov word ptr [bp - 4], dx
  07626F  4DDF: 0bd0             or dx, ax
  076271  4DE1: 7509             jne 0x4dec
  076273  4DE3: c70622081e00     mov word ptr [0x822], 0x1e
  076279  4DE9: e9b900           jmp 0x4ea5
  07627C  4DEC: c70602942000     mov word ptr [0x9402], 0x20
  076282  4DF2: c70600941800     mov word ptr [0x9400], 0x18
  076288  4DF8: a13483           mov ax, word ptr [0x8334]
  07628B  4DFB: 8b163683         mov dx, word ptr [0x8336]
  07628F  4DFF: a30494           mov word ptr [0x9404], ax
  076292  4E02: 89160694         mov word ptr [0x9406], dx
  076296  4E06: ff76fc           push word ptr [bp - 4]
  076299  4E09: ff76fa           push word ptr [bp - 6]
  07629C  4E0C: 6a00             push 0
  07629E  4E0E: b80100           mov ax, 1
  0762A1  4E11: 8d1e0094         lea bx, [0x9400]
  0762A5  4E15: 2bd2             sub dx, dx
  0762A7  4E17: 9a54021f18       lcall 0x181f, 0x254
  0762AC  4E1C: ff76fc           push word ptr [bp - 4]
  0762AF  4E1F: ff76fa           push word ptr [bp - 6]
  0762B2  4E22: 9aa8011f19       lcall 0x191f, 0x1a8
  0762B7  4E27: b8f093           mov ax, 0x93f0
  0762BA  4E2A: a36c1f           mov word ptr [0x1f6c], ax
  0762BD  4E2D: a3ba14           mov word ptr [0x14ba], ax
  0762C0  4E30: a32c08           mov word ptr [0x82c], ax
  0762C3  4E33: c7062e08f893     mov word ptr [0x82e], 0x93f8
  0762C9  4E39: 9adc081f1a       lcall 0x1a1f, 0x8dc
  0762CE  4E3E: ff360c26         push word ptr [0x260c]
  0762D2  4E42: ff360e26         push word ptr [0x260e]
  0762D6  4E46: ff361026         push word ptr [0x2610]
  0762DA  4E4A: ff361226         push word ptr [0x2612]
  0762DE  4E4E: ff361426         push word ptr [0x2614]
  0762E2  4E52: ff361626         push word ptr [0x2616]
  0762E6  4E56: 8d1eba23         lea bx, [0x23ba]
  0762EA  4E5A: a00826           mov al, byte ptr [0x2608]
  0762ED  4E5D: 8b160a26         mov dx, word ptr [0x260a]
  0762F1  4E61: 9a6a0e1f1a       lcall 0x1a1f, 0xe6a
  0762F6  4E66: 0e               push cs
  0762F7  4E67: e8b700           call 0x4f21
  0762FA  4E6A: 0bc0             or ax, ax
  0762FC  4E6C: 7537             jne 0x4ea5
  0762FE  4E6E: 6800a0           push 0xa000
  076301  4E71: 6800fc           push 0xfc00
  076304  4E74: 9af4031f18       lcall 0x181f, 0x3f4
  076309  4E79: c706c2530100     mov word ptr [0x53c2], 1
  07630F  4E7F: 9a5c0e1f1a       lcall 0x1a1f, 0xe5c
  076314  4E84: 8a268353         mov ah, byte ptr [0x5383]
  076318  4E88: 250001           and ax, 0x100
  07631B  4E8B: 3d0100           cmp ax, 1
  07631E  4E8E: 1bc0             sbb ax, ax
  076320  4E90: f7d8             neg ax
  076322  4E92: 50               push ax
  076323  4E93: 9aae0e1f18       lcall 0x181f, 0xeae
  076328  4E98: 83c402           add sp, 2
  07632B  4E9B: 9a98031f18       lcall 0x181f, 0x398
  076330  4EA0: 9a46051f18       lcall 0x181f, 0x546
  076335  4EA5: 9a4e0e1f1a       lcall 0x1a1f, 0xe4e
  07633A  4EAA: 9af2041f18       lcall 0x181f, 0x4f2
  07633F  4EAF: a1aa83           mov ax, word ptr [0x83aa]
  076342  4EB2: 8946fe           mov word ptr [bp - 2], ax
  076345  4EB5: 6a03             push 3
  076347  4EB7: 6a00             push 0
  076349  4EB9: 9ac4051f18       lcall 0x181f, 0x5c4
  07634E  4EBE: 83c404           add sp, 4
  076351  4EC1: 837efe03         cmp word ptr [bp - 2], 3
  076355  4EC5: 7405             je 0x4ecc
  076357  4EC7: b80100           mov ax, 1
  07635A  4ECA: eb02             jmp 0x4ece
  07635C  4ECC: 2bc0             sub ax, ax
  07635E  4ECE: 50               push ax
  07635F  4ECF: 6a03             push 3
  076361  4ED1: 9ad60e1f18       lcall 0x181f, 0xed6
  076366  4ED6: 83c404           add sp, 4
  076369  4ED9: 9ace051f18       lcall 0x181f, 0x5ce
  07636E  4EDE: c9               leave 
  07636F  4EDF: cb               retf 
  076370  4EE0: eaba0a1f19       ljmp 0x191f:0xaba
  076375  4EE5: ea040d1f1a       ljmp 0x1a1f:0xd04
  07637A  4EEA: ea120d1f1a       ljmp 0x1a1f:0xd12
  07637F  4EEF: ea200d1f1a       ljmp 0x1a1f:0xd20
  076384  4EF4: ea2e0d1f1a       ljmp 0x1a1f:0xd2e
  076389  4EF9: ea3c0d1f1a       ljmp 0x1a1f:0xd3c
  07638E  4EFE: ea4a0d1f1a       ljmp 0x1a1f:0xd4a
  076393  4F03: ea580d1f1a       ljmp 0x1a1f:0xd58
  076398  4F08: ea660d1f1a       ljmp 0x1a1f:0xd66
  07639D  4F0D: ea740d1f1a       ljmp 0x1a1f:0xd74
  0763A2  4F12: ea820d1f1a       ljmp 0x1a1f:0xd82
  0763A7  4F17: ea900d1f1a       ljmp 0x1a1f:0xd90
  0763AC  4F1C: ea9e0d1f1a       ljmp 0x1a1f:0xd9e
  0763B1  4F21: eaac0d1f1a       ljmp 0x1a1f:0xdac
  0763B6  4F26: eaba0d1f1a       ljmp 0x1a1f:0xdba
  0763BB  4F2B: eac80d1f1a       ljmp 0x1a1f:0xdc8
  0763C0  4F30: ead60d1f1a       ljmp 0x1a1f:0xdd6
