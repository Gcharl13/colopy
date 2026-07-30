; MAPEDIT.EXE named disasm — module mapedit.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _reset_sprite_memory  file 0x001600..0x001602  seg 0x0:0x0  (mapedit.obj) ----
  001600  cb               retf
  001601  90               nop

; ---- _load_main_sprites  file 0x001602..0x001604  seg 0x0:0x2  (mapedit.obj) ----
  001602  cb               retf
  001603  90               nop

; ---- _check_music  file 0x001604..0x001606  seg 0x0:0x4  (mapedit.obj) ----
  001604  cb               retf
  001605  90               nop

; ---- _build_check  file 0x001606..0x001608  seg 0x0:0x6  (mapedit.obj) ----
  001606  cb               retf
  001607  90               nop

; ---- @piece_draw  file 0x001608..0x00160A  seg 0x0:0x8  (mapedit.obj) ----
  001608  cb               retf
  001609  90               nop

; ---- @sprite_load  file 0x00160A..0x00160C  seg 0x0:0xa  (mapedit.obj) ----
  00160A  cb               retf
  00160B  90               nop

; ---- _perform_save  file 0x00160E..0x001610  seg 0x0:0xe  (mapedit.obj) ----
  00160E  cb               retf
  00160F  90               nop

; ---- _piss_factor  file 0x001610..0x001612  seg 0x0:0x10  (mapedit.obj) ----
  001610  cb               retf
  001611  90               nop

; ---- _pissed  file 0x001612..0x001614  seg 0x0:0x12  (mapedit.obj) ----
  001612  cb               retf
  001613  90               nop

; ---- _say_country  file 0x001614..0x001616  seg 0x0:0x14  (mapedit.obj) ----
  001614  cb               retf
  001615  90               nop

; ---- _cycle_save  file 0x001616..0x001618  seg 0x0:0x16  (mapedit.obj) ----
  001616  cb               retf
  001617  90               nop

; ---- _popups_normal  file 0x001618..0x001660  seg 0x0:0x18  (mapedit.obj) ----
  001618  a09500           mov al, byte ptr [0x95]
  00161B  2ae4             sub ah, ah
  00161D  a35005           mov word ptr [0x550], ax
  001620  a09600           mov al, byte ptr [0x96]
  001623  a35205           mov word ptr [0x552], ax
  001626  a09200           mov al, byte ptr [0x92]
  001629  a34a05           mov word ptr [0x54a], ax
  00162C  a09300           mov al, byte ptr [0x93]
  00162F  a34e05           mov word ptr [0x54e], ax
  001632  a09400           mov al, byte ptr [0x94]
  001635  a34c05           mov word ptr [0x54c], ax
  001638  a09700           mov al, byte ptr [0x97]
  00163B  a34205           mov word ptr [0x542], ax
  00163E  a34005           mov word ptr [0x540], ax
  001641  a09900           mov al, byte ptr [0x99]
  001644  a34405           mov word ptr [0x544], ax
  001647  a09a00           mov al, byte ptr [0x9a]
  00164A  a34605           mov word ptr [0x546], ax
  00164D  a09b00           mov al, byte ptr [0x9b]
  001650  a34805           mov word ptr [0x548], ax
  001653  c7066c05fa49     mov word ptr [0x56c], 0x49fa
  001659  c70664050100     mov word ptr [0x564], 1
  00165F  cb               retf

; ---- _event_wait  file 0x001660..0x0016B6  seg 0x0:0x60  (mapedit.obj) ----
  001660  c80c0000         enter 0xc, 0
  001664  c746fe0100       mov word ptr [bp - 2], 1
  001669  c746f80000       mov word ptr [bp - 8], 0
  00166E  9a0600180d       lcall 0xd18, 6
  001673  9a2a00210c       lcall 0xc21, 0x2a
  001678  2bc0             sub ax, ax
  00167A  9a4200210c       lcall 0xc21, 0x42
  00167F  9a0400af0b       lcall 0xbaf, 4
  001684  0bc0             or ax, ax
  001686  740d             je 0x1695
  001688  9a1800af0b       lcall 0xbaf, 0x18
  00168D  8946f8           mov word ptr [bp - 8], ax
  001690  c746fe0000       mov word ptr [bp - 2], 0
  001695  833e300700       cmp word ptr [0x730], 0
  00169A  7405             je 0x16a1
  00169C  c746fe0000       mov word ptr [bp - 2], 0
  0016A1  2bc0             sub ax, ax
  0016A3  8b56fe           mov dx, word ptr [bp - 2]
  0016A6  9a1001210c       lcall 0xc21, 0x110
  0016AB  837efe00         cmp word ptr [bp - 2], 0
  0016AF  75c7             jne 0x1678
  0016B1  8b46f8           mov ax, word ptr [bp - 8]
  0016B4  c9               leave
  0016B5  cb               retf

; ---- _forest_fix  file 0x0016B6..0x001786  seg 0x0:0xb6  (mapedit.obj) ----
  0016B6  c8080000         enter 8, 0
  0016BA  c746fa0000       mov word ptr [bp - 6], 0
  0016BF  e9b100           jmp 0x1773
  0016C2  3d1000           cmp ax, 0x10
  0016C5  7c05             jl 0x16cc
  0016C7  3d1800           cmp ax, 0x18
  0016CA  7c6a             jl 0x1736
  0016CC  ff46f8           inc word ptr [bp - 8]
  0016CF  8b46f8           mov ax, word ptr [bp - 8]
  0016D2  3906144b         cmp word ptr [0x4b14], ax
  0016D6  7f03             jg 0x16db
  0016D8  e99500           jmp 0x1770
  0016DB  ff36984e         push word ptr [0x4e98]
  0016DF  ff36964e         push word ptr [0x4e96]
  0016E3  ff36944e         push word ptr [0x4e94]
  0016E7  ff36924e         push word ptr [0x4e92]
  0016EB  8bd0             mov dx, ax
  0016ED  8b46fa           mov ax, word ptr [bp - 6]
  0016F0  9a0000780c       lcall 0xc78, 0
  0016F5  2ae4             sub ah, ah
  0016F7  8946fc           mov word ptr [bp - 4], ax
  0016FA  241f             and al, 0x1f
  0016FC  8946fe           mov word ptr [bp - 2], ax
  0016FF  3d1800           cmp ax, 0x18
  001702  7dc8             jge 0x16cc
  001704  f646fc20         test byte ptr [bp - 4], 0x20
  001708  74b8             je 0x16c2
  00170A  ff36984e         push word ptr [0x4e98]
  00170E  ff36964e         push word ptr [0x4e96]
  001712  ff36944e         push word ptr [0x4e94]
  001716  ff36924e         push word ptr [0x4e92]
  00171A  8166fce000       and word ptr [bp - 4], 0xe0
  00171F  8b5efc           mov bx, word ptr [bp - 4]
  001722  8366fe07         and word ptr [bp - 2], 7
  001726  0b5efe           or bx, word ptr [bp - 2]
  001729  8b46fa           mov ax, word ptr [bp - 6]
  00172C  8b56f8           mov dx, word ptr [bp - 8]
  00172F  9a0400760c       lcall 0xc76, 4
  001734  eb96             jmp 0x16cc
  001736  ff36984e         push word ptr [0x4e98]
  00173A  ff36964e         push word ptr [0x4e96]
  00173E  ff36944e         push word ptr [0x4e94]
  001742  ff36924e         push word ptr [0x4e92]
  001746  8b46fa           mov ax, word ptr [bp - 6]
  001749  8b56f8           mov dx, word ptr [bp - 8]
  00174C  9a0000780c       lcall 0xc78, 0
  001751  2ae4             sub ah, ah
  001753  8946fe           mov word ptr [bp - 2], ax
  001756  ff36984e         push word ptr [0x4e98]
  00175A  ff36964e         push word ptr [0x4e96]
  00175E  ff36944e         push word ptr [0x4e94]
  001762  ff36924e         push word ptr [0x4e92]
  001766  8346fef8         add word ptr [bp - 2], -8
  00176A  8b5efe           mov bx, word ptr [bp - 2]
  00176D  ebba             jmp 0x1729
  00176F  90               nop
  001770  ff46fa           inc word ptr [bp - 6]
  001773  8b46fa           mov ax, word ptr [bp - 6]
  001776  3906124b         cmp word ptr [0x4b12], ax
  00177A  7e08             jle 0x1784
  00177C  c746f80000       mov word ptr [bp - 8], 0
  001781  e94bff           jmp 0x16cf
  001784  c9               leave
  001785  cb               retf

; ---- _shift_key  file 0x001786..0x001796  seg 0x0:0x186  (mapedit.obj) ----
  001786  bb4000           mov bx, 0x40
  001789  8ec3             mov es, bx
  00178B  bb1700           mov bx, 0x17
  00178E  268a07           mov al, byte ptr es:[bx]
  001791  250300           and ax, 3
  001794  cb               retf
  001795  90               nop

; ---- _construct_mapedit_menu  file 0x001796..0x001B6A  seg 0x0:0x196  (mapedit.obj) ----
  001796  c8020000         enter 2, 0
  00179A  c746fe0100       mov word ptr [bp - 2], 1
  00179F  ff368200         push word ptr [0x82]
  0017A3  ff368000         push word ptr [0x80]
  0017A7  680008           push 0x800
  0017AA  9afe02d706       lcall 0x6d7, 0x2fe
  0017AF  83c406           add sp, 6
  0017B2  a37800           mov word ptr [0x78], ax
  0017B5  89167a00         mov word ptr [0x7a], dx
  0017B9  8bc2             mov ax, dx
  0017BB  0b067800         or ax, word ptr [0x78]
  0017BF  7503             jne 0x17c4
  0017C1  e9a103           jmp 0x1b65
  0017C4  689c00           push 0x9c
  0017C7  68a100           push 0xa1
  0017CA  9a1a004208       lcall 0x842, 0x1a
  0017CF  83c404           add sp, 4
  0017D2  0bc0             or ax, ax
  0017D4  7403             je 0x17d9
  0017D6  e98c03           jmp 0x1b65
  0017D9  50               push ax
  0017DA  6a01             push 1
  0017DC  9a06014208       lcall 0x842, 0x106
  0017E1  1e               push ds
  0017E2  50               push ax
  0017E3  ff367a00         push word ptr [0x7a]
  0017E7  ff367800         push word ptr [0x78]
  0017EB  9a4206d706       lcall 0x6d7, 0x642
  0017F0  83c40c           add sp, 0xc
  0017F3  6a1a             push 0x1a
  0017F5  9a06014208       lcall 0x842, 0x106
  0017FA  1e               push ds
  0017FB  50               push ax
  0017FC  6a01             push 1
  0017FE  ff367a00         push word ptr [0x7a]
  001802  ff367800         push word ptr [0x78]
  001806  9ade07d706       lcall 0x6d7, 0x7de
  00180B  83c40c           add sp, 0xc
  00180E  6a13             push 0x13
  001810  9a06014208       lcall 0x842, 0x106
  001815  1e               push ds
  001816  50               push ax
  001817  6a01             push 1
  001819  ff367a00         push word ptr [0x7a]
  00181D  ff367800         push word ptr [0x78]
  001821  9ade07d706       lcall 0x6d7, 0x7de
  001826  83c40c           add sp, 0xc
  001829  6a1b             push 0x1b
  00182B  9a06014208       lcall 0x842, 0x106
  001830  1e               push ds
  001831  50               push ax
  001832  6a01             push 1
  001834  ff367a00         push word ptr [0x7a]
  001838  ff367800         push word ptr [0x78]
  00183C  9ade07d706       lcall 0x6d7, 0x7de
  001841  83c40c           add sp, 0xc
  001844  6a14             push 0x14
  001846  9a06014208       lcall 0x842, 0x106
  00184B  1e               push ds
  00184C  50               push ax
  00184D  6a01             push 1
  00184F  ff367a00         push word ptr [0x7a]
  001853  ff367800         push word ptr [0x78]
  001857  9ade07d706       lcall 0x6d7, 0x7de
  00185C  83c40c           add sp, 0xc
  00185F  6a00             push 0
  001861  1e               push ds
  001862  68a900           push 0xa9
  001865  6a01             push 1
  001867  ff367a00         push word ptr [0x7a]
  00186B  ff367800         push word ptr [0x78]
  00186F  9ade07d706       lcall 0x6d7, 0x7de
  001874  83c40c           add sp, 0xc
  001877  6a1f             push 0x1f
  001879  9a06014208       lcall 0x842, 0x106
  00187E  1e               push ds
  00187F  50               push ax
  001880  6a01             push 1
  001882  ff367a00         push word ptr [0x7a]
  001886  ff367800         push word ptr [0x78]
  00188A  9ade07d706       lcall 0x6d7, 0x7de
  00188F  83c40c           add sp, 0xc
  001892  68aa00           push 0xaa
  001895  68af00           push 0xaf
  001898  9a1a004208       lcall 0x842, 0x1a
  00189D  83c404           add sp, 4
  0018A0  0bc0             or ax, ax
  0018A2  7403             je 0x18a7
  0018A4  e9be02           jmp 0x1b65
  0018A7  50               push ax
  0018A8  6a02             push 2
  0018AA  9a06014208       lcall 0x842, 0x106
  0018AF  1e               push ds
  0018B0  50               push ax
  0018B1  ff367a00         push word ptr [0x7a]
  0018B5  ff367800         push word ptr [0x78]
  0018B9  9a4206d706       lcall 0x6d7, 0x642
  0018BE  83c40c           add sp, 0xc
  0018C1  6a24             push 0x24
  0018C3  9a06014208       lcall 0x842, 0x106
  0018C8  1e               push ds
  0018C9  50               push ax
  0018CA  6a02             push 2
  0018CC  ff367a00         push word ptr [0x7a]
  0018D0  ff367800         push word ptr [0x78]
  0018D4  9ade07d706       lcall 0x6d7, 0x7de
  0018D9  83c40c           add sp, 0xc
  0018DC  6a25             push 0x25
  0018DE  9a06014208       lcall 0x842, 0x106
  0018E3  1e               push ds
  0018E4  50               push ax
  0018E5  6a02             push 2
  0018E7  ff367a00         push word ptr [0x7a]
  0018EB  ff367800         push word ptr [0x78]
  0018EF  9ade07d706       lcall 0x6d7, 0x7de
  0018F4  83c40c           add sp, 0xc
  0018F7  6a00             push 0
  0018F9  1e               push ds
  0018FA  68b700           push 0xb7
  0018FD  6a02             push 2
  0018FF  ff367a00         push word ptr [0x7a]
  001903  ff367800         push word ptr [0x78]
  001907  9ade07d706       lcall 0x6d7, 0x7de
  00190C  83c40c           add sp, 0xc
  00190F  6a26             push 0x26
  001911  9a06014208       lcall 0x842, 0x106
  001916  1e               push ds
  001917  50               push ax
  001918  6a02             push 2
  00191A  ff367a00         push word ptr [0x7a]
  00191E  ff367800         push word ptr [0x78]
  001922  9ade07d706       lcall 0x6d7, 0x7de
  001927  83c40c           add sp, 0xc
  00192A  6a27             push 0x27
  00192C  9a06014208       lcall 0x842, 0x106
  001931  1e               push ds
  001932  50               push ax
  001933  6a02             push 2
  001935  ff367a00         push word ptr [0x7a]
  001939  ff367800         push word ptr [0x78]
  00193D  9ade07d706       lcall 0x6d7, 0x7de
  001942  83c40c           add sp, 0xc
  001945  6a28             push 0x28
  001947  9a06014208       lcall 0x842, 0x106
  00194C  1e               push ds
  00194D  50               push ax
  00194E  6a02             push 2
  001950  ff367a00         push word ptr [0x7a]
  001954  ff367800         push word ptr [0x78]
  001958  9ade07d706       lcall 0x6d7, 0x7de
  00195D  83c40c           add sp, 0xc
  001960  6a29             push 0x29
  001962  9a06014208       lcall 0x842, 0x106
  001967  1e               push ds
  001968  50               push ax
  001969  6a02             push 2
  00196B  ff367a00         push word ptr [0x7a]
  00196F  ff367800         push word ptr [0x78]
  001973  9ade07d706       lcall 0x6d7, 0x7de
  001978  83c40c           add sp, 0xc
  00197B  6a00             push 0
  00197D  1e               push ds
  00197E  68b800           push 0xb8
  001981  6a02             push 2
  001983  ff367a00         push word ptr [0x7a]
  001987  ff367800         push word ptr [0x78]
  00198B  9ade07d706       lcall 0x6d7, 0x7de
  001990  83c40c           add sp, 0xc
  001993  6a2b             push 0x2b
  001995  9a06014208       lcall 0x842, 0x106
  00199A  1e               push ds
  00199B  50               push ax
  00199C  6a02             push 2
  00199E  ff367a00         push word ptr [0x7a]
  0019A2  ff367800         push word ptr [0x78]
  0019A6  9ade07d706       lcall 0x6d7, 0x7de
  0019AB  83c40c           add sp, 0xc
  0019AE  68b900           push 0xb9
  0019B1  68bd00           push 0xbd
  0019B4  9a1a004208       lcall 0x842, 0x1a
  0019B9  83c404           add sp, 4
  0019BC  0bc0             or ax, ax
  0019BE  7403             je 0x19c3
  0019C0  e9a201           jmp 0x1b65
  0019C3  50               push ax
  0019C4  6a06             push 6
  0019C6  9a06014208       lcall 0x842, 0x106
  0019CB  1e               push ds
  0019CC  50               push ax
  0019CD  ff367a00         push word ptr [0x7a]
  0019D1  ff367800         push word ptr [0x78]
  0019D5  9a4206d706       lcall 0x6d7, 0x642
  0019DA  83c40c           add sp, 0xc
  0019DD  6a4b             push 0x4b
  0019DF  9a06014208       lcall 0x842, 0x106
  0019E4  1e               push ds
  0019E5  50               push ax
  0019E6  6a06             push 6
  0019E8  ff367a00         push word ptr [0x7a]
  0019EC  ff367800         push word ptr [0x78]
  0019F0  9ade07d706       lcall 0x6d7, 0x7de
  0019F5  83c40c           add sp, 0xc
  0019F8  6a4c             push 0x4c
  0019FA  9a06014208       lcall 0x842, 0x106
  0019FF  1e               push ds
  001A00  50               push ax
  001A01  6a06             push 6
  001A03  ff367a00         push word ptr [0x7a]
  001A07  ff367800         push word ptr [0x78]
  001A0B  9ade07d706       lcall 0x6d7, 0x7de
  001A10  83c40c           add sp, 0xc
  001A13  6a00             push 0
  001A15  1e               push ds
  001A16  68c500           push 0xc5
  001A19  6a06             push 6
  001A1B  ff367a00         push word ptr [0x7a]
  001A1F  ff367800         push word ptr [0x78]
  001A23  9ade07d706       lcall 0x6d7, 0x7de
  001A28  83c40c           add sp, 0xc
  001A2B  6a4d             push 0x4d
  001A2D  9a06014208       lcall 0x842, 0x106
  001A32  1e               push ds
  001A33  50               push ax
  001A34  6a06             push 6
  001A36  ff367a00         push word ptr [0x7a]
  001A3A  ff367800         push word ptr [0x78]
  001A3E  9ade07d706       lcall 0x6d7, 0x7de
  001A43  83c40c           add sp, 0xc
  001A46  6a4a             push 0x4a
  001A48  9a06014208       lcall 0x842, 0x106
  001A4D  1e               push ds
  001A4E  50               push ax
  001A4F  6a06             push 6
  001A51  ff367a00         push word ptr [0x7a]
  001A55  ff367800         push word ptr [0x78]
  001A59  9ade07d706       lcall 0x6d7, 0x7de
  001A5E  83c40c           add sp, 0xc
  001A61  6a00             push 0
  001A63  1e               push ds
  001A64  68c600           push 0xc6
  001A67  6a06             push 6
  001A69  ff367a00         push word ptr [0x7a]
  001A6D  ff367800         push word ptr [0x78]
  001A71  9ade07d706       lcall 0x6d7, 0x7de
  001A76  83c40c           add sp, 0xc
  001A79  6a4e             push 0x4e
  001A7B  9a06014208       lcall 0x842, 0x106
  001A80  1e               push ds
  001A81  50               push ax
  001A82  6a06             push 6
  001A84  ff367a00         push word ptr [0x7a]
  001A88  ff367800         push word ptr [0x78]
  001A8C  9ade07d706       lcall 0x6d7, 0x7de
  001A91  83c40c           add sp, 0xc
  001A94  68c700           push 0xc7
  001A97  68cc00           push 0xcc
  001A9A  9a1a004208       lcall 0x842, 0x1a
  001A9F  83c404           add sp, 4
  001AA2  0bc0             or ax, ax
  001AA4  7403             je 0x1aa9
  001AA6  e9bc00           jmp 0x1b65
  001AA9  6a01             push 1
  001AAB  6a07             push 7
  001AAD  9a06014208       lcall 0x842, 0x106
  001AB2  1e               push ds
  001AB3  50               push ax
  001AB4  ff367a00         push word ptr [0x7a]
  001AB8  ff367800         push word ptr [0x78]
  001ABC  9a4206d706       lcall 0x6d7, 0x642
  001AC1  83c40c           add sp, 0xc
  001AC4  6a51             push 0x51
  001AC6  9a06014208       lcall 0x842, 0x106
  001ACB  1e               push ds
  001ACC  50               push ax
  001ACD  6a07             push 7
  001ACF  ff367a00         push word ptr [0x7a]
  001AD3  ff367800         push word ptr [0x78]
  001AD7  9ade07d706       lcall 0x6d7, 0x7de
  001ADC  83c40c           add sp, 0xc
  001ADF  6a52             push 0x52
  001AE1  9a06014208       lcall 0x842, 0x106
  001AE6  1e               push ds
  001AE7  50               push ax
  001AE8  6a07             push 7
  001AEA  ff367a00         push word ptr [0x7a]
  001AEE  ff367800         push word ptr [0x78]
  001AF2  9ade07d706       lcall 0x6d7, 0x7de
  001AF7  83c40c           add sp, 0xc
  001AFA  6a53             push 0x53
  001AFC  9a06014208       lcall 0x842, 0x106
  001B01  1e               push ds
  001B02  50               push ax
  001B03  6a07             push 7
  001B05  ff367a00         push word ptr [0x7a]
  001B09  ff367800         push word ptr [0x78]
  001B0D  9ade07d706       lcall 0x6d7, 0x7de
  001B12  83c40c           add sp, 0xc
  001B15  6a54             push 0x54
  001B17  9a06014208       lcall 0x842, 0x106
  001B1C  1e               push ds
  001B1D  50               push ax
  001B1E  6a07             push 7
  001B20  ff367a00         push word ptr [0x7a]
  001B24  ff367800         push word ptr [0x78]
  001B28  9ade07d706       lcall 0x6d7, 0x7de
  001B2D  83c40c           add sp, 0xc
  001B30  6a00             push 0
  001B32  1e               push ds
  001B33  68d400           push 0xd4
  001B36  6a07             push 7
  001B38  ff367a00         push word ptr [0x7a]
  001B3C  ff367800         push word ptr [0x78]
  001B40  9ade07d706       lcall 0x6d7, 0x7de
  001B45  83c40c           add sp, 0xc
  001B48  6a5f             push 0x5f
  001B4A  9a06014208       lcall 0x842, 0x106
  001B4F  1e               push ds
  001B50  50               push ax
  001B51  6a07             push 7
  001B53  ff367a00         push word ptr [0x7a]
  001B57  ff367800         push word ptr [0x78]
  001B5B  9ade07d706       lcall 0x6d7, 0x7de
  001B60  c746fe0000       mov word ptr [bp - 2], 0
  001B65  8b46fe           mov ax, word ptr [bp - 2]
  001B68  c9               leave
  001B69  cb               retf

; ---- _file_menu  file 0x001B6A..0x001D50  seg 0x0:0x56a  (mapedit.obj) ----
  001B6A  c8420000         enter 0x42, 0
  001B6E  c746eeffff       mov word ptr [bp - 0x12], 0xffff
  001B73  c746f40100       mov word ptr [bp - 0xc], 1
  001B78  2bc0             sub ax, ax
  001B7A  8946f8           mov word ptr [bp - 8], ax
  001B7D  8946f6           mov word ptr [bp - 0xa], ax
  001B80  8946fe           mov word ptr [bp - 2], ax
  001B83  a31c52           mov word ptr [0x521c], ax
  001B86  8d46c0           lea ax, [bp - 0x40]
  001B89  50               push ax
  001B8A  6a00             push 0
  001B8C  ff760a           push word ptr [bp + 0xa]
  001B8F  9abf0a8813       lcall 0x1388, 0xabf
  001B94  83c406           add sp, 6
  001B97  0bc0             or ax, ax
  001B99  7514             jne 0x1baf
  001B9B  ff061c52         inc word ptr [0x521c]
  001B9F  8d46c0           lea ax, [bp - 0x40]
  001BA2  50               push ax
  001BA3  9ab40a8813       lcall 0x1388, 0xab4
  001BA8  83c402           add sp, 2
  001BAB  0bc0             or ax, ax
  001BAD  74ec             je 0x1b9b
  001BAF  833e1c5200       cmp word ptr [0x521c], 0
  001BB4  7503             jne 0x1bb9
  001BB6  e97e01           jmp 0x1d37
  001BB9  a11c52           mov ax, word ptr [0x521c]
  001BBC  050900           add ax, 9
  001BBF  b90a00           mov cx, 0xa
  001BC2  99               cdq
  001BC3  f7f9             idiv cx
  001BC5  a3784e           mov word ptr [0x4e78], ax
  001BC8  c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  001BCD  c746fc0000       mov word ptr [bp - 4], 0
  001BD2  8b46fe           mov ax, word ptr [bp - 2]
  001BD5  8bc8             mov cx, ax
  001BD7  c1e002           shl ax, 2
  001BDA  03c1             add ax, cx
  001BDC  d1e0             shl ax, 1
  001BDE  8946ec           mov word ptr [bp - 0x14], ax
  001BE1  050900           add ax, 9
  001BE4  8946fa           mov word ptr [bp - 6], ax
  001BE7  8d46c0           lea ax, [bp - 0x40]
  001BEA  50               push ax
  001BEB  6a00             push 0
  001BED  ff760a           push word ptr [bp + 0xa]
  001BF0  9abf0a8813       lcall 0x1388, 0xabf
  001BF5  83c406           add sp, 6
  001BF8  0bc0             or ax, ax
  001BFA  754a             jne 0x1c46
  001BFC  8b46ec           mov ax, word ptr [bp - 0x14]
  001BFF  ff46f2           inc word ptr [bp - 0xe]
  001C02  3946f2           cmp word ptr [bp - 0xe], ax
  001C05  7c29             jl 0x1c30
  001C07  8b46fa           mov ax, word ptr [bp - 6]
  001C0A  3946f2           cmp word ptr [bp - 0xe], ax
  001C0D  7f21             jg 0x1c30
  001C0F  8d46de           lea ax, [bp - 0x22]
  001C12  50               push ax
  001C13  8b46fc           mov ax, word ptr [bp - 4]
  001C16  ff46fc           inc word ptr [bp - 4]
  001C19  8bc8             mov cx, ax
  001C1B  d1e0             shl ax, 1
  001C1D  03c1             add ax, cx
  001C1F  c1e002           shl ax, 2
  001C22  03c1             add ax, cx
  001C24  05f064           add ax, 0x64f0
  001C27  50               push ax
  001C28  9a26068813       lcall 0x1388, 0x626
  001C2D  83c404           add sp, 4
  001C30  8d46c0           lea ax, [bp - 0x40]
  001C33  50               push ax
  001C34  9ab40a8813       lcall 0x1388, 0xab4
  001C39  83c402           add sp, 2
  001C3C  0bc0             or ax, ax
  001C3E  7506             jne 0x1c46
  001C40  837efc0a         cmp word ptr [bp - 4], 0xa
  001C44  7cb6             jl 0x1bfc
  001C46  837efc00         cmp word ptr [bp - 4], 0
  001C4A  7508             jne 0x1c54
  001C4C  c746f40000       mov word ptr [bp - 0xc], 0
  001C51  e9da00           jmp 0x1d2e
  001C54  8b5e06           mov bx, word ptr [bp + 6]
  001C57  8b4608           mov ax, word ptr [bp + 8]
  001C5A  2bd2             sub dx, dx
  001C5C  9ab2323d03       lcall 0x33d, 0x32b2
  001C61  8946f6           mov word ptr [bp - 0xa], ax
  001C64  8956f8           mov word ptr [bp - 8], dx
  001C67  0bd0             or dx, ax
  001C69  7503             jne 0x1c6e
  001C6B  e9c900           jmp 0x1d37
  001C6E  837efe00         cmp word ptr [bp - 2], 0
  001C72  7412             je 0x1c86
  001C74  6a62             push 0x62
  001C76  1e               push ds
  001C77  68d500           push 0xd5
  001C7A  ff76f8           push word ptr [bp - 8]
  001C7D  50               push ax
  001C7E  9a0e0a3d03       lcall 0x33d, 0xa0e
  001C83  83c40a           add sp, 0xa
  001C86  c746f00000       mov word ptr [bp - 0x10], 0
  001C8B  eb27             jmp 0x1cb4
  001C8D  90               nop
  001C8E  40               inc ax
  001C8F  50               push ax
  001C90  8b46f0           mov ax, word ptr [bp - 0x10]
  001C93  8bc8             mov cx, ax
  001C95  d1e0             shl ax, 1
  001C97  03c1             add ax, cx
  001C99  c1e002           shl ax, 2
  001C9C  03c1             add ax, cx
  001C9E  05f064           add ax, 0x64f0
  001CA1  1e               push ds
  001CA2  50               push ax
  001CA3  ff76f8           push word ptr [bp - 8]
  001CA6  ff76f6           push word ptr [bp - 0xa]
  001CA9  9a0e0a3d03       lcall 0x33d, 0xa0e
  001CAE  83c40a           add sp, 0xa
  001CB1  ff46f0           inc word ptr [bp - 0x10]
  001CB4  8b46f0           mov ax, word ptr [bp - 0x10]
  001CB7  3946fc           cmp word ptr [bp - 4], ax
  001CBA  7fd2             jg 0x1c8e
  001CBC  a1784e           mov ax, word ptr [0x4e78]
  001CBF  48               dec ax
  001CC0  3b46fe           cmp ax, word ptr [bp - 2]
  001CC3  7e14             jle 0x1cd9
  001CC5  6a63             push 0x63
  001CC7  1e               push ds
  001CC8  68dc00           push 0xdc
  001CCB  ff76f8           push word ptr [bp - 8]
  001CCE  ff76f6           push word ptr [bp - 0xa]
  001CD1  9a0e0a3d03       lcall 0x33d, 0xa0e
  001CD6  83c40a           add sp, 0xa
  001CD9  c746f40000       mov word ptr [bp - 0xc], 0
  001CDE  ff76f8           push word ptr [bp - 8]
  001CE1  ff76f6           push word ptr [bp - 0xa]
  001CE4  9a8e253d03       lcall 0x33d, 0x258e
  001CE9  48               dec ax
  001CEA  8946ee           mov word ptr [bp - 0x12], ax
  001CED  3d6100           cmp ax, 0x61
  001CF0  750a             jne 0x1cfc
  001CF2  ff4efe           dec word ptr [bp - 2]
  001CF5  c746f40100       mov word ptr [bp - 0xc], 1
  001CFA  eb1f             jmp 0x1d1b
  001CFC  3d6200           cmp ax, 0x62
  001CFF  7505             jne 0x1d06
  001D01  ff46fe           inc word ptr [bp - 2]
  001D04  ebef             jmp 0x1cf5
  001D06  0bc0             or ax, ax
  001D08  7c11             jl 0x1d1b
  001D0A  8bc8             mov cx, ax
  001D0C  d1e0             shl ax, 1
  001D0E  03c1             add ax, cx
  001D10  c1e002           shl ax, 2
  001D13  03c1             add ax, cx
  001D15  05f064           add ax, 0x64f0
  001D18  a3ee49           mov word ptr [0x49ee], ax
  001D1B  ff76f8           push word ptr [bp - 8]
  001D1E  ff76f6           push word ptr [bp - 0xa]
  001D21  9a1003c90c       lcall 0xcc9, 0x310
  001D26  2bc0             sub ax, ax
  001D28  8946f8           mov word ptr [bp - 8], ax
  001D2B  8946f6           mov word ptr [bp - 0xa], ax
  001D2E  837ef400         cmp word ptr [bp - 0xc], 0
  001D32  7403             je 0x1d37
  001D34  e991fe           jmp 0x1bc8
  001D37  8b46f8           mov ax, word ptr [bp - 8]
  001D3A  0b46f6           or ax, word ptr [bp - 0xa]
  001D3D  740b             je 0x1d4a
  001D3F  ff76f8           push word ptr [bp - 8]
  001D42  ff76f6           push word ptr [bp - 0xa]
  001D45  9a1003c90c       lcall 0xcc9, 0x310
  001D4A  8b46ee           mov ax, word ptr [bp - 0x12]
  001D4D  c9               leave
  001D4E  cb               retf
  001D4F  90               nop

; ---- _make_undo  file 0x001D50..0x001D7E  seg 0x0:0x750  (mapedit.obj) ----
  001D50  c8080000         enter 8, 0
  001D54  b8ffff           mov ax, 0xffff
  001D57  833e500000       cmp word ptr [0x50], 0
  001D5C  741e             je 0x1d7c
  001D5E  68e02e           push 0x2ee0
  001D61  ff36aa04         push word ptr [0x4aa]
  001D65  ff36a804         push word ptr [0x4a8]
  001D69  ff365c00         push word ptr [0x5c]
  001D6D  ff365a00         push word ptr [0x5a]
  001D71  9a4a0c8813       lcall 0x1388, 0xc4a
  001D76  c70652000100     mov word ptr [0x52], 1
  001D7C  c9               leave
  001D7D  cb               retf

; ---- _perform_undo  file 0x001D7E..0x001DA6  seg 0x0:0x77e  (mapedit.obj) ----
  001D7E  c8080000         enter 8, 0
  001D82  b8ffff           mov ax, 0xffff
  001D85  833e520000       cmp word ptr [0x52], 0
  001D8A  7418             je 0x1da4
  001D8C  68e02e           push 0x2ee0
  001D8F  ff365c00         push word ptr [0x5c]
  001D93  ff365a00         push word ptr [0x5a]
  001D97  ff36aa04         push word ptr [0x4aa]
  001D9B  ff36a804         push word ptr [0x4a8]
  001D9F  9a4a0c8813       lcall 0x1388, 0xc4a
  001DA4  c9               leave
  001DA5  cb               retf

; ---- _info_window_clear  file 0x001DA6..0x001E2C  seg 0x0:0x7a6  (mapedit.obj) ----
  001DA6  833e900000       cmp word ptr [0x90], 0
  001DAB  7525             jne 0x1dd2
  001DAD  ff36fa3a         push word ptr [0x3afa]
  001DB1  ff36f83a         push word ptr [0x3af8]
  001DB5  ff36f63a         push word ptr [0x3af6]
  001DB9  ff36f43a         push word ptr [0x3af4]
  001DBD  689600           push 0x96
  001DC0  6a22             push 0x22
  001DC2  b8f100           mov ax, 0xf1
  001DC5  ba3200           mov dx, 0x32
  001DC8  bb4f00           mov bx, 0x4f
  001DCB  9a04005b0c       lcall 0xc5b, 4
  001DD0  eb35             jmp 0x1e07
  001DD2  6a00             push 0
  001DD4  6a00             push 0
  001DD6  689600           push 0x96
  001DD9  6a4f             push 0x4f
  001DDB  6a32             push 0x32
  001DDD  68f100           push 0xf1
  001DE0  8b1e9000         mov bx, word ptr [0x90]
  001DE4  ff7706           push word ptr [bx + 6]
  001DE7  ff7704           push word ptr [bx + 4]
  001DEA  ff7702           push word ptr [bx + 2]
  001DED  ff37             push word ptr [bx]
  001DEF  ff36fa3a         push word ptr [0x3afa]
  001DF3  ff36f83a         push word ptr [0x3af8]
  001DF7  ff36f63a         push word ptr [0x3af6]
  001DFB  ff36f43a         push word ptr [0x3af4]
  001DFF  9a0000b90c       lcall 0xcb9, 0
  001E04  83c41c           add sp, 0x1c
  001E07  ff36fa3a         push word ptr [0x3afa]
  001E0B  ff36f83a         push word ptr [0x3af8]
  001E0F  ff36f63a         push word ptr [0x3af6]
  001E13  ff36f43a         push word ptr [0x3af4]
  001E17  68c800           push 0xc8
  001E1A  6a00             push 0
  001E1C  b8f000           mov ax, 0xf0
  001E1F  ba3100           mov dx, 0x31
  001E22  bb4001           mov bx, 0x140
  001E25  9a0c00860c       lcall 0xc86, 0xc
  001E2A  cb               retf
  001E2B  90               nop

; ---- _info_window_update  file 0x001E2C..0x001E42  seg 0x0:0x82c  (mapedit.obj) ----
  001E2C  6a32             push 0x32
  001E2E  6a4f             push 0x4f
  001E30  689600           push 0x96
  001E33  b8f100           mov ax, 0xf1
  001E36  ba3200           mov dx, 0x32
  001E39  8bd8             mov bx, ax
  001E3B  9a4400340c       lcall 0xc34, 0x44
  001E40  cb               retf
  001E41  90               nop

; ---- _info_terrain  file 0x001E42..0x001EE2  seg 0x0:0x842  (mapedit.obj) ----
  001E42  c8500000         enter 0x50, 0
  001E46  56               push si
  001E47  68e300           push 0xe3
  001E4A  8d46b0           lea ax, [bp - 0x50]
  001E4D  50               push ax
  001E4E  9a26068813       lcall 0x1388, 0x626
  001E53  83c404           add sp, 4
  001E56  8b5e06           mov bx, word ptr [bp + 6]
  001E59  c1e304           shl bx, 4
  001E5C  ffb7e64e         push word ptr [bx + 0x4ee6]
  001E60  9a6c003403       lcall 0x334, 0x6c
  001E65  83c402           add sp, 2
  001E68  52               push dx
  001E69  50               push ax
  001E6A  8d46b0           lea ax, [bp - 0x50]
  001E6D  16               push ss
  001E6E  50               push ax
  001E6F  9a220e8813       lcall 0x1388, 0xe22
  001E74  83c408           add sp, 8
  001E77  837e0608         cmp word ptr [bp + 6], 8
  001E7B  7c2d             jl 0x1eaa
  001E7D  837e0618         cmp word ptr [bp + 6], 0x18
  001E81  7d27             jge 0x1eaa
  001E83  8d46b0           lea ax, [bp - 0x50]
  001E86  50               push ax
  001E87  9a0000ad08       lcall 0x8ad, 0
  001E8C  83c402           add sp, 2
  001E8F  ff365a4b         push word ptr [0x4b5a]
  001E93  9a6c003403       lcall 0x334, 0x6c
  001E98  83c402           add sp, 2
  001E9B  52               push dx
  001E9C  50               push ax
  001E9D  8d46b0           lea ax, [bp - 0x50]
  001EA0  16               push ss
  001EA1  50               push ax
  001EA2  9a220e8813       lcall 0x1388, 0xe22
  001EA7  83c408           add sp, 8
  001EAA  68e500           push 0xe5
  001EAD  8d46b0           lea ax, [bp - 0x50]
  001EB0  50               push ax
  001EB1  9ae6058813       lcall 0x1388, 0x5e6
  001EB6  83c404           add sp, 4
  001EB9  8b5e0a           mov bx, word ptr [bp + 0xa]
  001EBC  ff37             push word ptr [bx]
  001EBE  8b7608           mov si, word ptr [bp + 8]
  001EC1  ff34             push word ptr [si]
  001EC3  8d46b0           lea ax, [bp - 0x50]
  001EC6  16               push ss
  001EC7  50               push ax
  001EC8  9a4e02ad08       lcall 0x8ad, 0x24e
  001ECD  83c408           add sp, 8
  001ED0  c41e8000         les bx, ptr [0x80]
  001ED4  268a07           mov al, byte ptr es:[bx]
  001ED7  2ae4             sub ah, ah
  001ED9  40               inc ax
  001EDA  8b5e0a           mov bx, word ptr [bp + 0xa]
  001EDD  0107             add word ptr [bx], ax
  001EDF  5e               pop si
  001EE0  c9               leave
  001EE1  cb               retf

; ---- _info_terrain_2  file 0x001EE2..0x001F4E  seg 0x0:0x8e2  (mapedit.obj) ----
  001EE2  c8500000         enter 0x50, 0
  001EE6  56               push si
  001EE7  68e700           push 0xe7
  001EEA  8d46b0           lea ax, [bp - 0x50]
  001EED  50               push ax
  001EEE  9a26068813       lcall 0x1388, 0x626
  001EF3  83c404           add sp, 4
  001EF6  8b5e06           mov bx, word ptr [bp + 6]
  001EF9  d1e3             shl bx, 1
  001EFB  ffb75a4b         push word ptr [bx + 0x4b5a]
  001EFF  9a6c003403       lcall 0x334, 0x6c
  001F04  83c402           add sp, 2
  001F07  52               push dx
  001F08  50               push ax
  001F09  8d46b0           lea ax, [bp - 0x50]
  001F0C  16               push ss
  001F0D  50               push ax
  001F0E  9a220e8813       lcall 0x1388, 0xe22
  001F13  83c408           add sp, 8
  001F16  68e900           push 0xe9
  001F19  8d46b0           lea ax, [bp - 0x50]
  001F1C  50               push ax
  001F1D  9ae6058813       lcall 0x1388, 0x5e6
  001F22  83c404           add sp, 4
  001F25  8b5e0a           mov bx, word ptr [bp + 0xa]
  001F28  ff37             push word ptr [bx]
  001F2A  8b7608           mov si, word ptr [bp + 8]
  001F2D  ff34             push word ptr [si]
  001F2F  8d46b0           lea ax, [bp - 0x50]
  001F32  16               push ss
  001F33  50               push ax
  001F34  9a4e02ad08       lcall 0x8ad, 0x24e
  001F39  83c408           add sp, 8
  001F3C  c41e8000         les bx, ptr [0x80]
  001F40  268a07           mov al, byte ptr es:[bx]
  001F43  2ae4             sub ah, ah
  001F45  40               inc ax
  001F46  8b5e0a           mov bx, word ptr [bp + 0xa]
  001F49  0107             add word ptr [bx], ax
  001F4B  5e               pop si
  001F4C  c9               leave
  001F4D  cb               retf

; ---- _info_window_draw  file 0x001F4E..0x0022E0  seg 0x0:0x94e  (mapedit.obj) ----
  001F4E  c85c0000         enter 0x5c, 0
  001F52  0e               push cs
  001F53  e850fe           call 0x1da6
  001F56  c746aa3300       mov word ptr [bp - 0x56], 0x33
  001F5B  c746acf200       mov word ptr [bp - 0x54], 0xf2
  001F60  c746a80100       mov word ptr [bp - 0x58], 1
  001F65  ff36144b         push word ptr [0x4b14]
  001F69  ff36124b         push word ptr [0x4b12]
  001F6D  68eb00           push 0xeb
  001F70  8d46b0           lea ax, [bp - 0x50]
  001F73  50               push ax
  001F74  9a08098813       lcall 0x1388, 0x908
  001F79  83c408           add sp, 8
  001F7C  ff76aa           push word ptr [bp - 0x56]
  001F7F  ff76ac           push word ptr [bp - 0x54]
  001F82  8d46b0           lea ax, [bp - 0x50]
  001F85  16               push ss
  001F86  50               push ax
  001F87  9a4e02ad08       lcall 0x8ad, 0x24e
  001F8C  83c408           add sp, 8
  001F8F  c41e8000         les bx, ptr [0x80]
  001F93  268a07           mov al, byte ptr es:[bx]
  001F96  2ae4             sub ah, ah
  001F98  40               inc ax
  001F99  0146aa           add word ptr [bp - 0x56], ax
  001F9C  ff36544b         push word ptr [0x4b54]
  001FA0  ff36524b         push word ptr [0x4b52]
  001FA4  68fa00           push 0xfa
  001FA7  8d46b0           lea ax, [bp - 0x50]
  001FAA  50               push ax
  001FAB  9a08098813       lcall 0x1388, 0x908
  001FB0  83c408           add sp, 8
  001FB3  ff76aa           push word ptr [bp - 0x56]
  001FB6  ff76ac           push word ptr [bp - 0x54]
  001FB9  8d46b0           lea ax, [bp - 0x50]
  001FBC  16               push ss
  001FBD  50               push ax
  001FBE  9a4e02ad08       lcall 0x8ad, 0x24e
  001FC3  83c408           add sp, 8
  001FC6  c41e8000         les bx, ptr [0x80]
  001FCA  268a07           mov al, byte ptr es:[bx]
  001FCD  2ae4             sub ah, ah
  001FCF  050600           add ax, 6
  001FD2  0146aa           add word ptr [bp - 0x56], ax
  001FD5  ff76aa           push word ptr [bp - 0x56]
  001FD8  ff76ac           push word ptr [bp - 0x54]
  001FDB  1e               push ds
  001FDC  680901           push 0x109
  001FDF  9a4e02ad08       lcall 0x8ad, 0x24e
  001FE4  83c408           add sp, 8
  001FE7  c41e8000         les bx, ptr [0x80]
  001FEB  268a07           mov al, byte ptr es:[bx]
  001FEE  2ae4             sub ah, ah
  001FF0  40               inc ax
  001FF1  0146aa           add word ptr [bp - 0x56], ax
  001FF4  ff36544b         push word ptr [0x4b54]
  001FF8  ff36524b         push word ptr [0x4b52]
  001FFC  9a1201ab02       lcall 0x2ab, 0x112
  002001  83c404           add sp, 4
  002004  2ae4             sub ah, ah
  002006  8946a4           mov word ptr [bp - 0x5c], ax
  002009  241f             and al, 0x1f
  00200B  8946ae           mov word ptr [bp - 0x52], ax
  00200E  8d46aa           lea ax, [bp - 0x56]
  002011  50               push ax
  002012  8d4eac           lea cx, [bp - 0x54]
  002015  51               push cx
  002016  ff76a4           push word ptr [bp - 0x5c]
  002019  9a0600b709       lcall 0x9b7, 6
  00201E  83c402           add sp, 2
  002021  50               push ax
  002022  0e               push cs
  002023  e81cfe           call 0x1e42
  002026  83c406           add sp, 6
  002029  f646a440         test byte ptr [bp - 0x5c], 0x40
  00202D  7424             je 0x2053
  00202F  f646a480         test byte ptr [bp - 0x5c], 0x80
  002033  740d             je 0x2042
  002035  8d46aa           lea ax, [bp - 0x56]
  002038  50               push ax
  002039  8d46ac           lea ax, [bp - 0x54]
  00203C  50               push ax
  00203D  6a02             push 2
  00203F  eb0b             jmp 0x204c
  002041  90               nop
  002042  8d46aa           lea ax, [bp - 0x56]
  002045  50               push ax
  002046  8d46ac           lea ax, [bp - 0x54]
  002049  50               push ax
  00204A  6a03             push 3
  00204C  0e               push cs
  00204D  e892fe           call 0x1ee2
  002050  83c406           add sp, 6
  002053  8346aa0a         add word ptr [bp - 0x56], 0xa
  002057  ff76aa           push word ptr [bp - 0x56]
  00205A  ff76ac           push word ptr [bp - 0x54]
  00205D  1e               push ds
  00205E  681c01           push 0x11c
  002061  9a4e02ad08       lcall 0x8ad, 0x24e
  002066  83c408           add sp, 8
  002069  c41e8000         les bx, ptr [0x80]
  00206D  268a07           mov al, byte ptr es:[bx]
  002070  2ae4             sub ah, ah
  002072  40               inc ax
  002073  0146aa           add word ptr [bp - 0x56], ax
  002076  803e590000       cmp byte ptr [0x59], 0
  00207B  7463             je 0x20e0
  00207D  f606580040       test byte ptr [0x58], 0x40
  002082  742a             je 0x20ae
  002084  f606580080       test byte ptr [0x58], 0x80
  002089  7411             je 0x209c
  00208B  ff36c204         push word ptr [0x4c2]
  00208F  ff36c004         push word ptr [0x4c0]
  002093  ff76aa           push word ptr [bp - 0x56]
  002096  b80400           mov ax, 4
  002099  e99800           jmp 0x2134
  00209C  ff36c204         push word ptr [0x4c2]
  0020A0  ff36c004         push word ptr [0x4c0]
  0020A4  ff76aa           push word ptr [bp - 0x56]
  0020A7  b81400           mov ax, 0x14
  0020AA  e98700           jmp 0x2134
  0020AD  90               nop
  0020AE  f606580020       test byte ptr [0x58], 0x20
  0020B3  7503             jne 0x20b8
  0020B5  e98800           jmp 0x2140
  0020B8  f606580080       test byte ptr [0x58], 0x80
  0020BD  7411             je 0x20d0
  0020BF  ff36c204         push word ptr [0x4c2]
  0020C3  ff36c004         push word ptr [0x4c0]
  0020C7  ff76aa           push word ptr [bp - 0x56]
  0020CA  b82400           mov ax, 0x24
  0020CD  eb65             jmp 0x2134
  0020CF  90               nop
  0020D0  ff36c204         push word ptr [0x4c2]
  0020D4  ff36c004         push word ptr [0x4c0]
  0020D8  ff76aa           push word ptr [bp - 0x56]
  0020DB  b83400           mov ax, 0x34
  0020DE  eb54             jmp 0x2134
  0020E0  803e560007       cmp byte ptr [0x56], 7
  0020E5  7e0e             jle 0x20f5
  0020E7  803e560011       cmp byte ptr [0x56], 0x11
  0020EC  7407             je 0x20f5
  0020EE  803e560018       cmp byte ptr [0x56], 0x18
  0020F3  7c05             jl 0x20fa
  0020F5  a05600           mov al, byte ptr [0x56]
  0020F8  eb05             jmp 0x20ff
  0020FA  a05600           mov al, byte ptr [0x56]
  0020FD  2407             and al, 7
  0020FF  98               cwde
  002100  8946a6           mov word ptr [bp - 0x5a], ax
  002103  ff76aa           push word ptr [bp - 0x56]
  002106  ff76ac           push word ptr [bp - 0x54]
  002109  68f43a           push 0x3af4
  00210C  50               push ax
  00210D  ff36ba04         push word ptr [0x4ba]
  002111  ff36b804         push word ptr [0x4b8]
  002115  9a48000b03       lcall 0x30b, 0x48
  00211A  83c40c           add sp, 0xc
  00211D  8a46a6           mov al, byte ptr [bp - 0x5a]
  002120  38065600         cmp byte ptr [0x56], al
  002124  741a             je 0x2140
  002126  ff36c204         push word ptr [0x4c2]
  00212A  ff36c004         push word ptr [0x4c0]
  00212E  ff76aa           push word ptr [bp - 0x56]
  002131  b84100           mov ax, 0x41
  002134  8d1ef43a         lea bx, [0x3af4]
  002138  8b56ac           mov dx, word ptr [bp - 0x54]
  00213B  9a00008f0d       lcall 0xd8f, 0
  002140  8346aa14         add word ptr [bp - 0x56], 0x14
  002144  837ea800         cmp word ptr [bp - 0x58], 0
  002148  7514             jne 0x215e
  00214A  8d46aa           lea ax, [bp - 0x56]
  00214D  50               push ax
  00214E  8d46ac           lea ax, [bp - 0x54]
  002151  50               push ax
  002152  6a04             push 4
  002154  0e               push cs
  002155  e88afd           call 0x1ee2
  002158  83c406           add sp, 6
  00215B  e92001           jmp 0x227e
  00215E  f606580020       test byte ptr [0x58], 0x20
  002163  745f             je 0x21c4
  002165  f606580080       test byte ptr [0x58], 0x80
  00216A  740c             je 0x2178
  00216C  8d46aa           lea ax, [bp - 0x56]
  00216F  50               push ax
  002170  8d46ac           lea ax, [bp - 0x54]
  002173  50               push ax
  002174  6a1b             push 0x1b
  002176  eb0a             jmp 0x2182
  002178  8d46aa           lea ax, [bp - 0x56]
  00217B  50               push ax
  00217C  8d46ac           lea ax, [bp - 0x54]
  00217F  50               push ax
  002180  6a1c             push 0x1c
  002182  0e               push cs
  002183  e8bcfc           call 0x1e42
  002186  83c406           add sp, 6
  002189  c41e8000         les bx, ptr [0x80]
  00218D  268a07           mov al, byte ptr es:[bx]
  002190  2ae4             sub ah, ah
  002192  050500           add ax, 5
  002195  0146aa           add word ptr [bp - 0x56], ax
  002198  ff76aa           push word ptr [bp - 0x56]
  00219B  ff76ac           push word ptr [bp - 0x54]
  00219E  1e               push ds
  00219F  682601           push 0x126
  0021A2  9a4e02ad08       lcall 0x8ad, 0x24e
  0021A7  83c408           add sp, 8
  0021AA  c41e8000         les bx, ptr [0x80]
  0021AE  268a07           mov al, byte ptr es:[bx]
  0021B1  2ae4             sub ah, ah
  0021B3  40               inc ax
  0021B4  0146aa           add word ptr [bp - 0x56], ax
  0021B7  ff76aa           push word ptr [bp - 0x56]
  0021BA  ff76ac           push word ptr [bp - 0x54]
  0021BD  1e               push ds
  0021BE  683701           push 0x137
  0021C1  e9b200           jmp 0x2276
  0021C4  f606580040       test byte ptr [0x58], 0x40
  0021C9  745f             je 0x222a
  0021CB  f606580080       test byte ptr [0x58], 0x80
  0021D0  740c             je 0x21de
  0021D2  8d46aa           lea ax, [bp - 0x56]
  0021D5  50               push ax
  0021D6  8d46ac           lea ax, [bp - 0x54]
  0021D9  50               push ax
  0021DA  6a02             push 2
  0021DC  eb0a             jmp 0x21e8
  0021DE  8d46aa           lea ax, [bp - 0x56]
  0021E1  50               push ax
  0021E2  8d46ac           lea ax, [bp - 0x54]
  0021E5  50               push ax
  0021E6  6a03             push 3
  0021E8  0e               push cs
  0021E9  e8f6fc           call 0x1ee2
  0021EC  83c406           add sp, 6
  0021EF  c41e8000         les bx, ptr [0x80]
  0021F3  268a07           mov al, byte ptr es:[bx]
  0021F6  2ae4             sub ah, ah
  0021F8  050500           add ax, 5
  0021FB  0146aa           add word ptr [bp - 0x56], ax
  0021FE  ff76aa           push word ptr [bp - 0x56]
  002201  ff76ac           push word ptr [bp - 0x54]
  002204  1e               push ds
  002205  684b01           push 0x14b
  002208  9a4e02ad08       lcall 0x8ad, 0x24e
  00220D  83c408           add sp, 8
  002210  c41e8000         les bx, ptr [0x80]
  002214  268a07           mov al, byte ptr es:[bx]
  002217  2ae4             sub ah, ah
  002219  40               inc ax
  00221A  0146aa           add word ptr [bp - 0x56], ax
  00221D  ff76aa           push word ptr [bp - 0x56]
  002220  ff76ac           push word ptr [bp - 0x54]
  002223  1e               push ds
  002224  685c01           push 0x15c
  002227  eb4d             jmp 0x2276
  002229  90               nop
  00222A  8d46aa           lea ax, [bp - 0x56]
  00222D  50               push ax
  00222E  8d4eac           lea cx, [bp - 0x54]
  002231  51               push cx
  002232  a05600           mov al, byte ptr [0x56]
  002235  98               cwde
  002236  50               push ax
  002237  0e               push cs
  002238  e807fc           call 0x1e42
  00223B  83c406           add sp, 6
  00223E  c41e8000         les bx, ptr [0x80]
  002242  268a07           mov al, byte ptr es:[bx]
  002245  2ae4             sub ah, ah
  002247  050500           add ax, 5
  00224A  0146aa           add word ptr [bp - 0x56], ax
  00224D  ff76aa           push word ptr [bp - 0x56]
  002250  ff76ac           push word ptr [bp - 0x54]
  002253  1e               push ds
  002254  687001           push 0x170
  002257  9a4e02ad08       lcall 0x8ad, 0x24e
  00225C  83c408           add sp, 8
  00225F  c41e8000         les bx, ptr [0x80]
  002263  268a07           mov al, byte ptr es:[bx]
  002266  2ae4             sub ah, ah
  002268  40               inc ax
  002269  0146aa           add word ptr [bp - 0x56], ax
  00226C  ff76aa           push word ptr [bp - 0x56]
  00226F  ff76ac           push word ptr [bp - 0x54]
  002272  1e               push ds
  002273  688301           push 0x183
  002276  9a4e02ad08       lcall 0x8ad, 0x24e
  00227B  83c408           add sp, 8
  00227E  8346aa14         add word ptr [bp - 0x56], 0x14
  002282  ff364a00         push word ptr [0x4a]
  002286  689801           push 0x198
  002289  8d46b0           lea ax, [bp - 0x50]
  00228C  50               push ax
  00228D  9a08098813       lcall 0x1388, 0x908
  002292  83c406           add sp, 6
  002295  ff76aa           push word ptr [bp - 0x56]
  002298  ff76ac           push word ptr [bp - 0x54]
  00229B  8d46b0           lea ax, [bp - 0x50]
  00229E  16               push ss
  00229F  50               push ax
  0022A0  9a4e02ad08       lcall 0x8ad, 0x24e
  0022A5  83c408           add sp, 8
  0022A8  c41e8000         les bx, ptr [0x80]
  0022AC  268a07           mov al, byte ptr es:[bx]
  0022AF  2ae4             sub ah, ah
  0022B1  40               inc ax
  0022B2  0146aa           add word ptr [bp - 0x56], ax
  0022B5  833e4e0000       cmp word ptr [0x4e], 0
  0022BA  740c             je 0x22c8
  0022BC  ff76aa           push word ptr [bp - 0x56]
  0022BF  ff76ac           push word ptr [bp - 0x54]
  0022C2  1e               push ds
  0022C3  68a801           push 0x1a8
  0022C6  eb0a             jmp 0x22d2
  0022C8  ff76aa           push word ptr [bp - 0x56]
  0022CB  ff76ac           push word ptr [bp - 0x54]
  0022CE  1e               push ds
  0022CF  68ba01           push 0x1ba
  0022D2  9a4e02ad08       lcall 0x8ad, 0x24e
  0022D7  83c408           add sp, 8
  0022DA  0e               push cs
  0022DB  e84efb           call 0x1e2c
  0022DE  c9               leave
  0022DF  cb               retf

; ---- _main_screen_refresh  file 0x0022E0..0x00232A  seg 0x0:0xce0  (mapedit.obj) ----
  0022E0  ff36fa3a         push word ptr [0x3afa]
  0022E4  ff36f83a         push word ptr [0x3af8]
  0022E8  ff36f63a         push word ptr [0x3af6]
  0022EC  ff36f43a         push word ptr [0x3af4]
  0022F0  2ac0             sub al, al
  0022F2  9a0e00490c       lcall 0xc49, 0xe
  0022F7  6a00             push 0
  0022F9  684001           push 0x140
  0022FC  68c800           push 0xc8
  0022FF  2bc0             sub ax, ax
  002301  99               cdq
  002302  2bdb             sub bx, bx
  002304  9a4400340c       lcall 0xc34, 0x44
  002309  6a01             push 1
  00230B  6a00             push 0
  00230D  6a00             push 0
  00230F  ff367a00         push word ptr [0x7a]
  002313  ff367800         push word ptr [0x78]
  002317  9a4409d706       lcall 0x6d7, 0x944
  00231C  83c40a           add sp, 0xa
  00231F  9a6800a208       lcall 0x8a2, 0x68
  002324  0e               push cs
  002325  e826fc           call 0x1f4e
  002328  cb               retf
  002329  90               nop

; ---- _add_item  file 0x00232A..0x00239E  seg 0x0:0xd2a  (mapedit.obj) ----
  00232A  55               push bp
  00232B  8bec             mov bp, sp
  00232D  ff36c204         push word ptr [0x4c2]
  002331  ff36c004         push word ptr [0x4c0]
  002335  ff7608           push word ptr [bp + 8]
  002338  8b460a           mov ax, word ptr [bp + 0xa]
  00233B  8d1ef43a         lea bx, [0x3af4]
  00233F  8b5606           mov dx, word ptr [bp + 6]
  002342  9a00008f0d       lcall 0xd8f, 0
  002347  8b4608           mov ax, word ptr [bp + 8]
  00234A  050f00           add ax, 0xf
  00234D  50               push ax
  00234E  6a03             push 3
  002350  ff760c           push word ptr [bp + 0xc]
  002353  6a13             push 0x13
  002355  8b5e06           mov bx, word ptr [bp + 6]
  002358  8bc3             mov ax, bx
  00235A  8d5f0f           lea bx, [bx + 0xf]
  00235D  8b5608           mov dx, word ptr [bp + 8]
  002360  9a0000a30b       lcall 0xba3, 0
  002365  837e0e00         cmp word ptr [bp + 0xe], 0
  002369  7431             je 0x239c
  00236B  a11607           mov ax, word ptr [0x716]
  00236E  a3ce01           mov word ptr [0x1ce], ax
  002371  ff36fa3a         push word ptr [0x3afa]
  002375  ff36f83a         push word ptr [0x3af8]
  002379  ff36f63a         push word ptr [0x3af6]
  00237D  ff36f43a         push word ptr [0x3af4]
  002381  8b4608           mov ax, word ptr [bp + 8]
  002384  051000           add ax, 0x10
  002387  50               push ax
  002388  6a0f             push 0xf
  00238A  8b4606           mov ax, word ptr [bp + 6]
  00238D  8bd8             mov bx, ax
  00238F  83c310           add bx, 0x10
  002392  48               dec ax
  002393  8b5608           mov dx, word ptr [bp + 8]
  002396  4a               dec dx
  002397  9a0c00860c       lcall 0xc86, 0xc
  00239C  c9               leave
  00239D  cb               retf

; ---- _add_item_2  file 0x00239E..0x002414  seg 0x0:0xd9e  (mapedit.obj) ----
  00239E  55               push bp
  00239F  8bec             mov bp, sp
  0023A1  ff7608           push word ptr [bp + 8]
  0023A4  ff7606           push word ptr [bp + 6]
  0023A7  68f43a           push 0x3af4
  0023AA  ff760a           push word ptr [bp + 0xa]
  0023AD  ff36ba04         push word ptr [0x4ba]
  0023B1  ff36b804         push word ptr [0x4b8]
  0023B5  9a48000b03       lcall 0x30b, 0x48
  0023BA  8be5             mov sp, bp
  0023BC  8b4608           mov ax, word ptr [bp + 8]
  0023BF  050f00           add ax, 0xf
  0023C2  50               push ax
  0023C3  6a03             push 3
  0023C5  ff760c           push word ptr [bp + 0xc]
  0023C8  6a13             push 0x13
  0023CA  8b5e06           mov bx, word ptr [bp + 6]
  0023CD  8bc3             mov ax, bx
  0023CF  8d5f0f           lea bx, [bx + 0xf]
  0023D2  8b5608           mov dx, word ptr [bp + 8]
  0023D5  9a0000a30b       lcall 0xba3, 0
  0023DA  837e0e00         cmp word ptr [bp + 0xe], 0
  0023DE  7431             je 0x2411
  0023E0  a11607           mov ax, word ptr [0x716]
  0023E3  a3ce01           mov word ptr [0x1ce], ax
  0023E6  ff36fa3a         push word ptr [0x3afa]
  0023EA  ff36f83a         push word ptr [0x3af8]
  0023EE  ff36f63a         push word ptr [0x3af6]
  0023F2  ff36f43a         push word ptr [0x3af4]
  0023F6  8b4608           mov ax, word ptr [bp + 8]
  0023F9  051000           add ax, 0x10
  0023FC  50               push ax
  0023FD  6a0f             push 0xf
  0023FF  8b4606           mov ax, word ptr [bp + 6]
  002402  8bd8             mov bx, ax
  002404  83c310           add bx, 0x10
  002407  48               dec ax
  002408  8b5608           mov dx, word ptr [bp + 8]
  00240B  4a               dec dx
  00240C  9a0c00860c       lcall 0xc86, 0xc
  002411  c9               leave
  002412  cb               retf
  002413  90               nop

; ---- _selection_screen_display  file 0x002414..0x002600  seg 0x0:0xe14  (mapedit.obj) ----
  002414  c8100000         enter 0x10, 0
  002418  ff36fa3a         push word ptr [0x3afa]
  00241C  ff36f83a         push word ptr [0x3af8]
  002420  ff36f63a         push word ptr [0x3af6]
  002424  ff36f43a         push word ptr [0x3af4]
  002428  2ac0             sub al, al
  00242A  9a0e00490c       lcall 0xc49, 0xe
  00242F  2bc0             sub ax, ax
  002431  a31607           mov word ptr [0x716], ax
  002434  8946fe           mov word ptr [bp - 2], ax
  002437  e9f100           jmp 0x252b
  00243A  2bc0             sub ax, ax
  00243C  8946f6           mov word ptr [bp - 0xa], ax
  00243F  8946f4           mov word ptr [bp - 0xc], ax
  002442  8b46f8           mov ax, word ptr [bp - 8]
  002445  8946f2           mov word ptr [bp - 0xe], ax
  002448  ff76fa           push word ptr [bp - 6]
  00244B  ff76fc           push word ptr [bp - 4]
  00244E  68f43a           push 0x3af4
  002451  ff76f2           push word ptr [bp - 0xe]
  002454  ff36ba04         push word ptr [0x4ba]
  002458  ff36b804         push word ptr [0x4b8]
  00245C  9a48000b03       lcall 0x30b, 0x48
  002461  83c40c           add sp, 0xc
  002464  837efe00         cmp word ptr [bp - 2], 0
  002468  7420             je 0x248a
  00246A  837ef801         cmp word ptr [bp - 8], 1
  00246E  741a             je 0x248a
  002470  ff36c204         push word ptr [0x4c2]
  002474  ff36c004         push word ptr [0x4c0]
  002478  ff76fa           push word ptr [bp - 6]
  00247B  b84100           mov ax, 0x41
  00247E  8d1ef43a         lea bx, [0x3af4]
  002482  8b56fc           mov dx, word ptr [bp - 4]
  002485  9a00008f0d       lcall 0xd8f, 0
  00248A  8b46fa           mov ax, word ptr [bp - 6]
  00248D  050f00           add ax, 0xf
  002490  50               push ax
  002491  ff76fe           push word ptr [bp - 2]
  002494  ff76f8           push word ptr [bp - 8]
  002497  6a13             push 0x13
  002499  8b5efc           mov bx, word ptr [bp - 4]
  00249C  8bc3             mov ax, bx
  00249E  8d5f0f           lea bx, [bx + 0xf]
  0024A1  8b56fa           mov dx, word ptr [bp - 6]
  0024A4  9a0000a30b       lcall 0xba3, 0
  0024A9  8a46f4           mov al, byte ptr [bp - 0xc]
  0024AC  0246f8           add al, byte ptr [bp - 8]
  0024AF  3a065600         cmp al, byte ptr [0x56]
  0024B3  7532             jne 0x24e7
  0024B5  803e580000       cmp byte ptr [0x58], 0
  0024BA  752b             jne 0x24e7
  0024BC  ff36fa3a         push word ptr [0x3afa]
  0024C0  ff36f83a         push word ptr [0x3af8]
  0024C4  ff36f63a         push word ptr [0x3af6]
  0024C8  ff36f43a         push word ptr [0x3af4]
  0024CC  8b46fa           mov ax, word ptr [bp - 6]
  0024CF  051000           add ax, 0x10
  0024D2  50               push ax
  0024D3  6a0f             push 0xf
  0024D5  8b46fc           mov ax, word ptr [bp - 4]
  0024D8  8bd8             mov bx, ax
  0024DA  83c310           add bx, 0x10
  0024DD  48               dec ax
  0024DE  8b56fa           mov dx, word ptr [bp - 6]
  0024E1  4a               dec dx
  0024E2  9a0c00860c       lcall 0xc86, 0xc
  0024E7  ff46f8           inc word ptr [bp - 8]
  0024EA  837ef808         cmp word ptr [bp - 8], 8
  0024EE  7d38             jge 0x2528
  0024F0  6b46f811         imul ax, word ptr [bp - 8], 0x11
  0024F4  40               inc ax
  0024F5  8946fc           mov word ptr [bp - 4], ax
  0024F8  6b46fe11         imul ax, word ptr [bp - 2], 0x11
  0024FC  40               inc ax
  0024FD  8946fa           mov word ptr [bp - 6], ax
  002500  8b46fe           mov ax, word ptr [bp - 2]
  002503  0bc0             or ax, ax
  002505  7503             jne 0x250a
  002507  e930ff           jmp 0x243a
  00250A  c746f60000       mov word ptr [bp - 0xa], 0
  00250F  c746f40800       mov word ptr [bp - 0xc], 8
  002514  8b46f8           mov ax, word ptr [bp - 8]
  002517  8946f2           mov word ptr [bp - 0xe], ax
  00251A  48               dec ax
  00251B  7403             je 0x2520
  00251D  e928ff           jmp 0x2448
  002520  c746f21100       mov word ptr [bp - 0xe], 0x11
  002525  e920ff           jmp 0x2448
  002528  ff46fe           inc word ptr [bp - 2]
  00252B  837efe02         cmp word ptr [bp - 2], 2
  00252F  7d07             jge 0x2538
  002531  c746f80000       mov word ptr [bp - 8], 0
  002536  ebb2             jmp 0x24ea
  002538  c746fc0100       mov word ptr [bp - 4], 1
  00253D  c746fa3000       mov word ptr [bp - 6], 0x30
  002542  803e560018       cmp byte ptr [0x56], 0x18
  002547  750f             jne 0x2558
  002549  803e580000       cmp byte ptr [0x58], 0
  00254E  7508             jne 0x2558
  002550  c746f00100       mov word ptr [bp - 0x10], 1
  002555  eb06             jmp 0x255d
  002557  90               nop
  002558  c746f00000       mov word ptr [bp - 0x10], 0
  00255D  ff76f0           push word ptr [bp - 0x10]
  002560  6a00             push 0
  002562  6a18             push 0x18
  002564  ff76fa           push word ptr [bp - 6]
  002567  ff76fc           push word ptr [bp - 4]
  00256A  0e               push cs
  00256B  e830fe           call 0x239e
  00256E  83c40a           add sp, 0xa
  002571  803e560019       cmp byte ptr [0x56], 0x19
  002576  7506             jne 0x257e
  002578  b80100           mov ax, 1
  00257B  eb03             jmp 0x2580
  00257D  90               nop
  00257E  2bc0             sub ax, ax
  002580  50               push ax
  002581  6a01             push 1
  002583  6a19             push 0x19
  002585  ff76fa           push word ptr [bp - 6]
  002588  8346fc11         add word ptr [bp - 4], 0x11
  00258C  ff76fc           push word ptr [bp - 4]
  00258F  0e               push cs
  002590  e80bfe           call 0x239e
  002593  83c40a           add sp, 0xa
  002596  803e56001a       cmp byte ptr [0x56], 0x1a
  00259B  7505             jne 0x25a2
  00259D  b80100           mov ax, 1
  0025A0  eb02             jmp 0x25a4
  0025A2  2bc0             sub ax, ax
  0025A4  50               push ax
  0025A5  6a02             push 2
  0025A7  6a1a             push 0x1a
  0025A9  ff76fa           push word ptr [bp - 6]
  0025AC  8346fc11         add word ptr [bp - 4], 0x11
  0025B0  ff76fc           push word ptr [bp - 4]
  0025B3  0e               push cs
  0025B4  e8e7fd           call 0x239e
  0025B7  83c40a           add sp, 0xa
  0025BA  803e5800c0       cmp byte ptr [0x58], 0xc0
  0025BF  7505             jne 0x25c6
  0025C1  b80100           mov ax, 1
  0025C4  eb02             jmp 0x25c8
  0025C6  2bc0             sub ax, ax
  0025C8  50               push ax
  0025C9  6a03             push 3
  0025CB  6a04             push 4
  0025CD  ff76fa           push word ptr [bp - 6]
  0025D0  8346fc11         add word ptr [bp - 4], 0x11
  0025D4  ff76fc           push word ptr [bp - 4]
  0025D7  0e               push cs
  0025D8  e84ffd           call 0x232a
  0025DB  83c40a           add sp, 0xa
  0025DE  803e580040       cmp byte ptr [0x58], 0x40
  0025E3  7505             jne 0x25ea
  0025E5  b80100           mov ax, 1
  0025E8  eb02             jmp 0x25ec
  0025EA  2bc0             sub ax, ax
  0025EC  50               push ax
  0025ED  6a04             push 4
  0025EF  6a14             push 0x14
  0025F1  ff76fa           push word ptr [bp - 6]
  0025F4  8346fc11         add word ptr [bp - 4], 0x11
  0025F8  ff76fc           push word ptr [bp - 4]
  0025FB  0e               push cs
  0025FC  e82bfd           call 0x232a
  0025FF  83               .byte 0x83

; ---- _parse_spot  file 0x0026CC..0x0027EE  seg 0x0:0x10cc  (mapedit.obj) ----
  0026CC  c80c0000         enter 0xc, 0
  0026D0  837e0600         cmp word ptr [bp + 6], 0
  0026D4  7503             jne 0x26d9
  0026D6  e91201           jmp 0x27eb
  0026D9  8b5e06           mov bx, word ptr [bp + 6]
  0026DC  c1e304           shl bx, 4
  0026DF  8b871453         mov ax, word ptr [bx + 0x5314]
  0026E3  8b8f1253         mov cx, word ptr [bx + 0x5312]
  0026E7  83f903           cmp cx, 3
  0026EA  7c03             jl 0x26ef
  0026EC  e9a100           jmp 0x2790
  0026EF  2ae4             sub ah, ah
  0026F1  8946f6           mov word ptr [bp - 0xa], ax
  0026F4  c746fcff00       mov word ptr [bp - 4], 0xff
  0026F9  2bc0             sub ax, ax
  0026FB  8946fe           mov word ptr [bp - 2], ax
  0026FE  8946f4           mov word ptr [bp - 0xc], ax
  002701  8bc1             mov ax, cx
  002703  0bc0             or ax, ax
  002705  7503             jne 0x270a
  002707  e9a200           jmp 0x27ac
  00270A  48               dec ax
  00270B  7407             je 0x2714
  00270D  8346f610         add word ptr [bp - 0xa], 0x10
  002711  e99800           jmp 0x27ac
  002714  8346f608         add word ptr [bp - 0xa], 8
  002718  e99100           jmp 0x27ac
  00271B  90               nop
  00271C  c746f61800       mov word ptr [bp - 0xa], 0x18
  002721  c746fcff00       mov word ptr [bp - 4], 0xff
  002726  2bc0             sub ax, ax
  002728  8946fe           mov word ptr [bp - 2], ax
  00272B  8946f4           mov word ptr [bp - 0xc], ax
  00272E  eb7c             jmp 0x27ac
  002730  c746f61900       mov word ptr [bp - 0xa], 0x19
  002735  c746fc4000       mov word ptr [bp - 4], 0x40
  00273A  ebea             jmp 0x2726
  00273C  c746f61a00       mov word ptr [bp - 0xa], 0x1a
  002741  ebf2             jmp 0x2735
  002743  90               nop
  002744  c746f60000       mov word ptr [bp - 0xa], 0
  002749  c746fc1fff       mov word ptr [bp - 4], 0xff1f
  00274E  c746fec000       mov word ptr [bp - 2], 0xc0
  002753  c746f40100       mov word ptr [bp - 0xc], 1
  002758  eb52             jmp 0x27ac
  00275A  c746f60000       mov word ptr [bp - 0xa], 0
  00275F  c746fc3fff       mov word ptr [bp - 4], 0xff3f
  002764  c746fe4000       mov word ptr [bp - 2], 0x40
  002769  ebe8             jmp 0x2753
  00276B  90               nop
  00276C  c746f60000       mov word ptr [bp - 0xa], 0
  002771  c746fc1fff       mov word ptr [bp - 4], 0xff1f
  002776  c746fea000       mov word ptr [bp - 2], 0xa0
  00277B  ebd6             jmp 0x2753
  00277D  90               nop
  00277E  c746f60000       mov word ptr [bp - 0xa], 0
  002783  c746fc5fff       mov word ptr [bp - 4], 0xff5f
  002788  c746fe2000       mov word ptr [bp - 2], 0x20
  00278D  ebc4             jmp 0x2753
  00278F  90               nop
  002790  3d0600           cmp ax, 6
  002793  7717             ja 0x27ac
  002795  d1e0             shl ax, 1
  002797  93               xchg bx, ax
  002798  2effa79e11       jmp word ptr cs:[bx + 0x119e]
  00279D  90               nop
  00279E  1c11             sbb al, 0x11
  0027A0  3011             xor byte ptr [bx + di], dl
  0027A2  3c11             cmp al, 0x11
  0027A4  44               inc sp
  0027A5  115a11           adc word ptr [bp + si + 0x11], bx
  0027A8  6c               insb byte ptr es:[di], dx
  0027A9  117e11           adc word ptr [bp + 0x11], di
  0027AC  a05600           mov al, byte ptr [0x56]
  0027AF  3846f6           cmp byte ptr [bp - 0xa], al
  0027B2  751b             jne 0x27cf
  0027B4  8a46fc           mov al, byte ptr [bp - 4]
  0027B7  38065700         cmp byte ptr [0x57], al
  0027BB  7512             jne 0x27cf
  0027BD  8a46fe           mov al, byte ptr [bp - 2]
  0027C0  38065800         cmp byte ptr [0x58], al
  0027C4  7509             jne 0x27cf
  0027C6  8a46f4           mov al, byte ptr [bp - 0xc]
  0027C9  38065900         cmp byte ptr [0x59], al
  0027CD  741c             je 0x27eb
  0027CF  8a46f6           mov al, byte ptr [bp - 0xa]
  0027D2  a25600           mov byte ptr [0x56], al
  0027D5  8a46fc           mov al, byte ptr [bp - 4]
  0027D8  a25700           mov byte ptr [0x57], al
  0027DB  8a46fe           mov al, byte ptr [bp - 2]
  0027DE  a25800           mov byte ptr [0x58], al
  0027E1  8a46f4           mov al, byte ptr [bp - 0xc]
  0027E4  a25900           mov byte ptr [0x59], al
  0027E7  0e               push cs
  0027E8  e829fc           call 0x2414
  0027EB  c9               leave
  0027EC  cb               retf
  0027ED  90               nop

; ---- _selection_mouse  file 0x0027EE..0x002826  seg 0x0:0x11ee  (mapedit.obj) ----
  0027EE  c8040000         enter 4, 0
  0027F2  c746fc0100       mov word ptr [bp - 4], 1
  0027F7  833e320700       cmp word ptr [0x732], 0
  0027FC  7417             je 0x2815
  0027FE  a12407           mov ax, word ptr [0x724]
  002801  8b162607         mov dx, word ptr [0x726]
  002805  bb1300           mov bx, 0x13
  002808  9a0200aa0b       lcall 0xbaa, 2
  00280D  50               push ax
  00280E  0e               push cs
  00280F  e8bafe           call 0x26cc
  002812  83c402           add sp, 2
  002815  833e300700       cmp word ptr [0x730], 0
  00281A  7405             je 0x2821
  00281C  c746fc0000       mov word ptr [bp - 4], 0
  002821  8b46fc           mov ax, word ptr [bp - 4]
  002824  c9               leave
  002825  cb               retf

; ---- _selection_screen  file 0x002826..0x002910  seg 0x0:0x1226  (mapedit.obj) ----
  002826  c8060000         enter 6, 0
  00282A  c746fe0100       mov word ptr [bp - 2], 1
  00282F  0e               push cs
  002830  e8e1fb           call 0x2414
  002833  9a2a00210c       lcall 0xc21, 0x2a
  002838  2bc0             sub ax, ax
  00283A  9a4200210c       lcall 0xc21, 0x42
  00283F  9a0400af0b       lcall 0xbaf, 4
  002844  0bc0             or ax, ax
  002846  7503             jne 0x284b
  002848  e99e00           jmp 0x28e9
  00284B  c746fc0000       mov word ptr [bp - 4], 0
  002850  9a1800af0b       lcall 0xbaf, 0x18
  002855  2d4801           sub ax, 0x148
  002858  742c             je 0x2886
  00285A  2d0300           sub ax, 3
  00285D  743b             je 0x289a
  00285F  48               dec ax
  002860  48               dec ax
  002861  7407             je 0x286a
  002863  2d0300           sub ax, 3
  002866  740a             je 0x2872
  002868  eb38             jmp 0x28a2
  00286A  c746fc0100       mov word ptr [bp - 4], 1
  00286F  eb36             jmp 0x28a7
  002871  90               nop
  002872  c746fc0800       mov word ptr [bp - 4], 8
  002877  833ece0110       cmp word ptr [0x1ce], 0x10
  00287C  7529             jne 0x28a7
  00287E  c746fcf8ff       mov word ptr [bp - 4], 0xfff8
  002883  eb22             jmp 0x28a7
  002885  90               nop
  002886  c746fcf8ff       mov word ptr [bp - 4], 0xfff8
  00288B  833ece0108       cmp word ptr [0x1ce], 8
  002890  7515             jne 0x28a7
  002892  c746fc0800       mov word ptr [bp - 4], 8
  002897  eb0e             jmp 0x28a7
  002899  90               nop
  00289A  c746fcffff       mov word ptr [bp - 4], 0xffff
  00289F  eb06             jmp 0x28a7
  0028A1  90               nop
  0028A2  c746fe0000       mov word ptr [bp - 2], 0
  0028A7  837efc00         cmp word ptr [bp - 4], 0
  0028AB  743c             je 0x28e9
  0028AD  8b46fc           mov ax, word ptr [bp - 4]
  0028B0  48               dec ax
  0028B1  0106ce01         add word ptr [0x1ce], ax
  0028B5  833ece0117       cmp word ptr [0x1ce], 0x17
  0028BA  7506             jne 0x28c2
  0028BC  c706ce010000     mov word ptr [0x1ce], 0
  0028C2  833ece0117       cmp word ptr [0x1ce], 0x17
  0028C7  7e05             jle 0x28ce
  0028C9  832ece0118       sub word ptr [0x1ce], 0x18
  0028CE  833ece0100       cmp word ptr [0x1ce], 0
  0028D3  7d05             jge 0x28da
  0028D5  8306ce0108       add word ptr [0x1ce], 8
  0028DA  ff06ce01         inc word ptr [0x1ce]
  0028DE  ff36ce01         push word ptr [0x1ce]
  0028E2  0e               push cs
  0028E3  e8e6fd           call 0x26cc
  0028E6  83c402           add sp, 2
  0028E9  833e320700       cmp word ptr [0x732], 0
  0028EE  7407             je 0x28f7
  0028F0  0e               push cs
  0028F1  e8fafe           call 0x27ee
  0028F4  8946fe           mov word ptr [bp - 2], ax
  0028F7  2bc0             sub ax, ax
  0028F9  8b56fe           mov dx, word ptr [bp - 2]
  0028FC  9a1001210c       lcall 0xc21, 0x110
  002901  837efe00         cmp word ptr [bp - 2], 0
  002905  7403             je 0x290a
  002907  e92eff           jmp 0x2838
  00290A  0e               push cs
  00290B  e8d2f9           call 0x22e0
  00290E  c9               leave
  00290F  cb               retf

; ---- _cursor_update  file 0x002910..0x002A04  seg 0x0:0x1310  (mapedit.obj) ----
  002910  c80c0000         enter 0xc, 0
  002914  0e               push cs
  002915  e836f6           call 0x1f4e
  002918  833e726901       cmp word ptr [0x6972], 1
  00291D  1bc0             sbb ax, ax
  00291F  f7d8             neg ax
  002921  a37269           mov word ptr [0x6972], ax
  002924  a1524b           mov ax, word ptr [0x4b52]
  002927  3906f249         cmp word ptr [0x49f2], ax
  00292B  7e03             jle 0x2930
  00292D  e9d200           jmp 0x2a02
  002930  a1f249           mov ax, word ptr [0x49f2]
  002933  0306d452         add ax, word ptr [0x52d4]
  002937  3b06524b         cmp ax, word ptr [0x4b52]
  00293B  7f03             jg 0x2940
  00293D  e9c200           jmp 0x2a02
  002940  a1544b           mov ax, word ptr [0x4b54]
  002943  3906f449         cmp word ptr [0x49f4], ax
  002947  7e03             jle 0x294c
  002949  e9b600           jmp 0x2a02
  00294C  a1f449           mov ax, word ptr [0x49f4]
  00294F  0306d852         add ax, word ptr [0x52d8]
  002953  3b06544b         cmp ax, word ptr [0x4b54]
  002957  7f03             jg 0x295c
  002959  e9a600           jmp 0x2a02
  00295C  a1544b           mov ax, word ptr [0x4b54]
  00295F  2b06f449         sub ax, word ptr [0x49f4]
  002963  8bc8             mov cx, ax
  002965  a1524b           mov ax, word ptr [0x4b52]
  002968  2b06f249         sub ax, word ptr [0x49f2]
  00296C  0306d85a         add ax, word ptr [0x5ad8]
  002970  f72e8a4e         imul word ptr [0x4e8a]
  002974  8946fe           mov word ptr [bp - 2], ax
  002977  8bd0             mov dx, ax
  002979  8bc1             mov ax, cx
  00297B  0306f45a         add ax, word ptr [0x5af4]
  00297F  8bca             mov cx, dx
  002981  f72e8c4e         imul word ptr [0x4e8c]
  002985  8946fa           mov word ptr [bp - 6], ax
  002988  ff36023b         push word ptr [0x3b02]
  00298C  ff36003b         push word ptr [0x3b00]
  002990  ff36fe3a         push word ptr [0x3afe]
  002994  ff36fc3a         push word ptr [0x3afc]
  002998  ff36fa3a         push word ptr [0x3afa]
  00299C  ff36f83a         push word ptr [0x3af8]
  0029A0  ff36f63a         push word ptr [0x3af6]
  0029A4  ff36f43a         push word ptr [0x3af4]
  0029A8  8bd0             mov dx, ax
  0029AA  050800           add ax, 8
  0029AD  50               push ax
  0029AE  ff368a4e         push word ptr [0x4e8a]
  0029B2  ff368c4e         push word ptr [0x4e8c]
  0029B6  8bc1             mov ax, cx
  0029B8  8bd9             mov bx, cx
  0029BA  9a0000670c       lcall 0xc67, 0
  0029BF  833e726900       cmp word ptr [0x6972], 0
  0029C4  7421             je 0x29e7
  0029C6  8b46fa           mov ax, word ptr [bp - 6]
  0029C9  ff366a00         push word ptr [0x6a]
  0029CD  ff366800         push word ptr [0x68]
  0029D1  050800           add ax, 8
  0029D4  50               push ax
  0029D5  a1d004           mov ax, word ptr [0x4d0]
  0029D8  051300           add ax, 0x13
  0029DB  8b56fe           mov dx, word ptr [bp - 2]
  0029DE  8d1ef43a         lea bx, [0x3af4]
  0029E2  9a00008f0d       lcall 0xd8f, 0
  0029E7  8b46fa           mov ax, word ptr [bp - 6]
  0029EA  050800           add ax, 8
  0029ED  50               push ax
  0029EE  ff368a4e         push word ptr [0x4e8a]
  0029F2  ff368c4e         push word ptr [0x4e8c]
  0029F6  8bd0             mov dx, ax
  0029F8  8b46fe           mov ax, word ptr [bp - 2]
  0029FB  8bd8             mov bx, ax
  0029FD  9a4400340c       lcall 0xc34, 0x44
  002A02  c9               leave
  002A03  cb               retf

; ---- _set_center  file 0x002A04..0x002A5E  seg 0x0:0x1404  (mapedit.obj) ----
  002A04  55               push bp
  002A05  8bec             mov bp, sp
  002A07  57               push di
  002A08  56               push si
  002A09  8b7e06           mov di, word ptr [bp + 6]
  002A0C  8b7608           mov si, word ptr [bp + 8]
  002A0F  56               push si
  002A10  57               push di
  002A11  9a0e00ab02       lcall 0x2ab, 0xe
  002A16  83c404           add sp, 4
  002A19  0bc0             or ax, ax
  002A1B  743d             je 0x2a5a
  002A1D  893ec804         mov word ptr [0x4c8], di
  002A21  8936ca04         mov word ptr [0x4ca], si
  002A25  833e700001       cmp word ptr [0x70], 1
  002A2A  7529             jne 0x2a55
  002A2C  837e0a00         cmp word ptr [bp + 0xa], 0
  002A30  740b             je 0x2a3d
  002A32  833e726900       cmp word ptr [0x6972], 0
  002A37  7404             je 0x2a3d
  002A39  0e               push cs
  002A3A  e8d3fe           call 0x2910
  002A3D  893e524b         mov word ptr [0x4b52], di
  002A41  8936544b         mov word ptr [0x4b54], si
  002A45  837e0a00         cmp word ptr [bp + 0xa], 0
  002A49  740a             je 0x2a55
  002A4B  c70672690000     mov word ptr [0x6972], 0
  002A51  0e               push cs
  002A52  e8bbfe           call 0x2910
  002A55  9a6800a208       lcall 0x8a2, 0x68
  002A5A  5e               pop si
  002A5B  5f               pop di
  002A5C  c9               leave
  002A5D  cb               retf

; ---- _possibly_center  file 0x002A5E..0x002B14  seg 0x0:0x145e  (mapedit.obj) ----
  002A5E  c8060000         enter 6, 0
  002A62  57               push di
  002A63  56               push si
  002A64  8b7e06           mov di, word ptr [bp + 6]
  002A67  8b16f249         mov dx, word ptr [0x49f2]
  002A6B  c746fe0000       mov word ptr [bp - 2], 0
  002A70  8b460a           mov ax, word ptr [bp + 0xa]
  002A73  3bc7             cmp ax, di
  002A75  7d02             jge 0x2a79
  002A77  8bc7             mov ax, di
  002A79  8946fc           mov word ptr [bp - 4], ax
  002A7C  8b5e0c           mov bx, word ptr [bp + 0xc]
  002A7F  3b5e08           cmp bx, word ptr [bp + 8]
  002A82  7e03             jle 0x2a87
  002A84  8b5e08           mov bx, word ptr [bp + 8]
  002A87  8b460c           mov ax, word ptr [bp + 0xc]
  002A8A  3b4608           cmp ax, word ptr [bp + 8]
  002A8D  7d03             jge 0x2a92
  002A8F  8b4608           mov ax, word ptr [bp + 8]
  002A92  8946fa           mov word ptr [bp - 6], ax
  002A95  8b460a           mov ax, word ptr [bp + 0xa]
  002A98  3bc7             cmp ax, di
  002A9A  7e02             jle 0x2a9e
  002A9C  8bc7             mov ax, di
  002A9E  8bca             mov cx, dx
  002AA0  41               inc cx
  002AA1  41               inc cx
  002AA2  3bc1             cmp ax, cx
  002AA4  7d0a             jge 0x2ab0
  002AA6  83fa01           cmp dx, 1
  002AA9  7e05             jle 0x2ab0
  002AAB  c746fe0100       mov word ptr [bp - 2], 1
  002AB0  a1f449           mov ax, word ptr [0x49f4]
  002AB3  40               inc ax
  002AB4  40               inc ax
  002AB5  3bc3             cmp ax, bx
  002AB7  7f05             jg 0x2abe
  002AB9  8b76fe           mov si, word ptr [bp - 2]
  002ABC  eb0d             jmp 0x2acb
  002ABE  8b76fe           mov si, word ptr [bp - 2]
  002AC1  833ef44901       cmp word ptr [0x49f4], 1
  002AC6  7e03             jle 0x2acb
  002AC8  be0100           mov si, 1
  002ACB  a12660           mov ax, word ptr [0x6026]
  002ACE  48               dec ax
  002ACF  48               dec ax
  002AD0  3b46fc           cmp ax, word ptr [bp - 4]
  002AD3  7d0e             jge 0x2ae3
  002AD5  a1124b           mov ax, word ptr [0x4b12]
  002AD8  48               dec ax
  002AD9  48               dec ax
  002ADA  3b062660         cmp ax, word ptr [0x6026]
  002ADE  7e03             jle 0x2ae3
  002AE0  be0100           mov si, 1
  002AE3  a13e60           mov ax, word ptr [0x603e]
  002AE6  48               dec ax
  002AE7  48               dec ax
  002AE8  3b46fa           cmp ax, word ptr [bp - 6]
  002AEB  7d0e             jge 0x2afb
  002AED  a1144b           mov ax, word ptr [0x4b14]
  002AF0  48               dec ax
  002AF1  48               dec ax
  002AF2  3b063e60         cmp ax, word ptr [0x603e]
  002AF6  7e03             jle 0x2afb
  002AF8  be0100           mov si, 1
  002AFB  0bf6             or si, si
  002AFD  740e             je 0x2b0d
  002AFF  ff760e           push word ptr [bp + 0xe]
  002B02  ff7608           push word ptr [bp + 8]
  002B05  57               push di
  002B06  0e               push cs
  002B07  e8fafe           call 0x2a04
  002B0A  83c406           add sp, 6
  002B0D  8bc6             mov ax, si
  002B0F  5e               pop si
  002B10  5f               pop di
  002B11  c9               leave
  002B12  cb               retf
  002B13  90               nop

; ---- _move_cursor  file 0x002B14..0x002B7A  seg 0x0:0x1514  (mapedit.obj) ----
  002B14  c8040000         enter 4, 0
  002B18  57               push di
  002B19  56               push si
  002B1A  ba0100           mov dx, 1
  002B1D  a1524b           mov ax, word ptr [0x4b52]
  002B20  8946fe           mov word ptr [bp - 2], ax
  002B23  8b0e544b         mov cx, word ptr [0x4b54]
  002B27  894efc           mov word ptr [bp - 4], cx
  002B2A  8bf8             mov di, ax
  002B2C  037e06           add di, word ptr [bp + 6]
  002B2F  8bf1             mov si, cx
  002B31  037608           add si, word ptr [bp + 8]
  002B34  3bfa             cmp di, dx
  002B36  7c04             jl 0x2b3c
  002B38  3bf2             cmp si, dx
  002B3A  7d02             jge 0x2b3e
  002B3C  2bd2             sub dx, dx
  002B3E  a1124b           mov ax, word ptr [0x4b12]
  002B41  48               dec ax
  002B42  3bc7             cmp ax, di
  002B44  7e08             jle 0x2b4e
  002B46  a1144b           mov ax, word ptr [0x4b14]
  002B49  48               dec ax
  002B4A  3bc6             cmp ax, si
  002B4C  7f02             jg 0x2b50
  002B4E  2bd2             sub dx, dx
  002B50  0bd2             or dx, dx
  002B52  7421             je 0x2b75
  002B54  6a01             push 1
  002B56  ff76fc           push word ptr [bp - 4]
  002B59  ff76fe           push word ptr [bp - 2]
  002B5C  ff76fc           push word ptr [bp - 4]
  002B5F  ff76fe           push word ptr [bp - 2]
  002B62  0e               push cs
  002B63  e8f8fe           call 0x2a5e
  002B66  83c40a           add sp, 0xa
  002B69  893e524b         mov word ptr [0x4b52], di
  002B6D  8936544b         mov word ptr [0x4b54], si
  002B71  0e               push cs
  002B72  e89bfd           call 0x2910
  002B75  5e               pop si
  002B76  5f               pop di
  002B77  c9               leave
  002B78  cb               retf
  002B79  90               nop

; ---- _set_view_mode  file 0x002B7A..0x002B82  seg 0x0:0x157a  (mapedit.obj) ----
  002B7A  c70670000100     mov word ptr [0x70], 1
  002B80  cb               retf
  002B81  90               nop

; ---- _set_zoom_level  file 0x002B82..0x002BCC  seg 0x0:0x1582  (mapedit.obj) ----
  002B82  55               push bp
  002B83  8bec             mov bp, sp
  002B85  56               push si
  002B86  8b7606           mov si, word ptr [bp + 6]
  002B89  8bc6             mov ax, si
  002B8B  0bc0             or ax, ax
  002B8D  7d02             jge 0x2b91
  002B8F  2bc0             sub ax, ax
  002B91  8bf0             mov si, ax
  002B93  3d0300           cmp ax, 3
  002B96  7e03             jle 0x2b9b
  002B98  b80300           mov ax, 3
  002B9B  8bf0             mov si, ax
  002B9D  8936d004         mov word ptr [0x4d0], si
  002BA1  9a0600470a       lcall 0xa47, 6
  002BA6  6a00             push 0
  002BA8  ff36544b         push word ptr [0x4b54]
  002BAC  ff36524b         push word ptr [0x4b52]
  002BB0  ff36544b         push word ptr [0x4b54]
  002BB4  ff36524b         push word ptr [0x4b52]
  002BB8  0e               push cs
  002BB9  e8a2fe           call 0x2a5e
  002BBC  83c40a           add sp, 0xa
  002BBF  0bc0             or ax, ax
  002BC1  7505             jne 0x2bc8
  002BC3  9a6800a208       lcall 0x8a2, 0x68
  002BC8  5e               pop si
  002BC9  c9               leave
  002BCA  cb               retf
  002BCB  90               nop

; ---- _memory_check  file 0x002BCC..0x002BFC  seg 0x0:0x15cc  (mapedit.obj) ----
  002BCC  9a8200080d       lcall 0xd08, 0x82
  002BD1  a38a69           mov word ptr [0x698a], ax
  002BD4  89168c69         mov word ptr [0x698c], dx
  002BD8  c41e7800         les bx, ptr [0x78]
  002BDC  268b474a         mov ax, word ptr es:[bx + 0x4a]
  002BE0  268b574c         mov dx, word ptr es:[bx + 0x4c]
  002BE4  a38e69           mov word ptr [0x698e], ax
  002BE7  89169069         mov word ptr [0x6990], dx
  002BEB  8d1ed701         lea bx, [0x1d7]
  002BEF  8d06d001         lea ax, [0x1d0]
  002BF3  2bd2             sub dx, dx
  002BF5  9ad8363d03       lcall 0x33d, 0x36d8
  002BFA  cb               retf
  002BFB  90               nop

; ---- _create_me  file 0x002BFC..0x002C70  seg 0x0:0x15fc  (mapedit.obj) ----
  002BFC  c8540000         enter 0x54, 0
  002C00  56               push si
  002C01  be0100           mov si, 1
  002C04  6a14             push 0x14
  002C06  8d1ef101         lea bx, [0x1f1]
  002C0A  8d06e901         lea ax, [0x1e9]
  002C0E  8d16dd01         lea dx, [0x1dd]
  002C12  9a0a383d03       lcall 0x33d, 0x380a
  002C17  0bc0             or ax, ax
  002C19  7550             jne 0x2c6b
  002C1B  68644b           push 0x4b64
  002C1E  8d46ac           lea ax, [bp - 0x54]
  002C21  50               push ax
  002C22  9a26068813       lcall 0x1388, 0x626
  002C27  83c404           add sp, 4
  002C2A  8d46ac           lea ax, [bp - 0x54]
  002C2D  16               push ss
  002C2E  50               push ax
  002C2F  16               push ss
  002C30  50               push ax
  002C31  1e               push ds
  002C32  68f901           push 0x1f9
  002C35  9a5c00040c       lcall 0xc04, 0x5c
  002C3A  c746fc3a00       mov word ptr [bp - 4], 0x3a
  002C3F  c746fe4800       mov word ptr [bp - 2], 0x48
  002C44  8d46ac           lea ax, [bp - 0x54]
  002C47  50               push ax
  002C48  68184a           push 0x4a18
  002C4B  9a26068813       lcall 0x1388, 0x626
  002C50  83c404           add sp, 4
  002C53  6a48             push 0x48
  002C55  6a3a             push 0x3a
  002C57  9aba03f909       lcall 0x9f9, 0x3ba
  002C5C  83c404           add sp, 4
  002C5F  0bc0             or ax, ax
  002C61  7508             jne 0x2c6b
  002C63  c70646000100     mov word ptr [0x46], 1
  002C69  2bf6             sub si, si
  002C6B  8bc6             mov ax, si
  002C6D  5e               pop si
  002C6E  c9               leave
  002C6F  cb               retf

; ---- _continent_check  file 0x002C70..0x002DE0  seg 0x0:0x1670  (mapedit.obj) ----
  002C70  c81a0000         enter 0x1a, 0
  002C74  57               push di
  002C75  56               push si
  002C76  b8e8fd           mov ax, 0xfde8
  002C79  2bd2             sub dx, dx
  002C7B  9ae202c90c       lcall 0xcc9, 0x2e2
  002C80  a38c00           mov word ptr [0x8c], ax
  002C83  89168e00         mov word ptr [0x8e], dx
  002C87  8bc2             mov ax, dx
  002C89  0b068c00         or ax, word ptr [0x8c]
  002C8D  7503             jne 0x2c92
  002C8F  e94a01           jmp 0x2ddc
  002C92  9a0200c409       lcall 0x9c4, 2
  002C97  8bf0             mov si, ax
  002C99  ff368e00         push word ptr [0x8e]
  002C9D  ff368c00         push word ptr [0x8c]
  002CA1  9a1003c90c       lcall 0xcc9, 0x310
  002CA6  2bc0             sub ax, ax
  002CA8  a38e00           mov word ptr [0x8e], ax
  002CAB  a38c00           mov word ptr [0x8c], ax
  002CAE  f7c60100         test si, 1
  002CB2  740f             je 0x2cc3
  002CB4  8d1e0802         lea bx, [0x208]
  002CB8  8d06fc01         lea ax, [0x1fc]
  002CBC  2bd2             sub dx, dx
  002CBE  9ad8363d03       lcall 0x33d, 0x36d8
  002CC3  8bc6             mov ax, si
  002CC5  a802             test al, 2
  002CC7  740f             je 0x2cd8
  002CC9  8d1e1c02         lea bx, [0x21c]
  002CCD  8d061002         lea ax, [0x210]
  002CD1  2bd2             sub dx, dx
  002CD3  9ad8363d03       lcall 0x33d, 0x36d8
  002CD8  a1144b           mov ax, word ptr [0x4b14]
  002CDB  8946ee           mov word ptr [bp - 0x12], ax
  002CDE  8b0eb004         mov cx, word ptr [0x4b0]
  002CE2  8b16b204         mov dx, word ptr [0x4b2]
  002CE6  894ef2           mov word ptr [bp - 0xe], cx
  002CE9  8956f4           mov word ptr [bp - 0xc], dx
  002CEC  8bd0             mov dx, ax
  002CEE  a1124b           mov ax, word ptr [0x4b12]
  002CF1  8946f0           mov word ptr [bp - 0x10], ax
  002CF4  8d5ee6           lea bx, [bp - 0x1a]
  002CF7  9a0a003e0c       lcall 0xc3e, 0xa
  002CFC  ff76f4           push word ptr [bp - 0xc]
  002CFF  ff76f2           push word ptr [bp - 0xe]
  002D02  ff76f0           push word ptr [bp - 0x10]
  002D05  ff76ee           push word ptr [bp - 0x12]
  002D08  ff76ec           push word ptr [bp - 0x14]
  002D0B  ff76ea           push word ptr [bp - 0x16]
  002D0E  ff76e8           push word ptr [bp - 0x18]
  002D11  ff76e6           push word ptr [bp - 0x1a]
  002D14  ff36144b         push word ptr [0x4b14]
  002D18  2bc0             sub ax, ax
  002D1A  99               cdq
  002D1B  8b1e124b         mov bx, word ptr [0x4b12]
  002D1F  9a00004c0c       lcall 0xc4c, 0
  002D24  c746f60000       mov word ptr [bp - 0xa], 0
  002D29  833e144b00       cmp word ptr [0x4b14], 0
  002D2E  7e5c             jle 0x2d8c
  002D30  8b7ef6           mov di, word ptr [bp - 0xa]
  002D33  2bf6             sub si, si
  002D35  3936124b         cmp word ptr [0x4b12], si
  002D39  7e4a             jle 0x2d85
  002D3B  897ef6           mov word ptr [bp - 0xa], di
  002D3E  a1124b           mov ax, word ptr [0x4b12]
  002D41  f7ef             imul di
  002D43  8bd8             mov bx, ax
  002D45  035eea           add bx, word ptr [bp - 0x16]
  002D48  8e46ec           mov es, word ptr [bp - 0x14]
  002D4B  03de             add bx, si
  002D4D  895ef8           mov word ptr [bp - 8], bx
  002D50  8c46fa           mov word ptr [bp - 6], es
  002D53  2680270f         and byte ptr es:[bx], 0xf
  002D57  57               push di
  002D58  56               push si
  002D59  9a1201ab02       lcall 0x2ab, 0x112
  002D5E  83c404           add sp, 4
  002D61  241f             and al, 0x1f
  002D63  3c19             cmp al, 0x19
  002D65  7410             je 0x2d77
  002D67  57               push di
  002D68  56               push si
  002D69  9a1201ab02       lcall 0x2ab, 0x112
  002D6E  83c404           add sp, 4
  002D71  241f             and al, 0x1f
  002D73  3c1a             cmp al, 0x1a
  002D75  7507             jne 0x2d7e
  002D77  c45ef8           les bx, ptr [bp - 8]
  002D7A  26c60700         mov byte ptr es:[bx], 0
  002D7E  46               inc si
  002D7F  3936124b         cmp word ptr [0x4b12], si
  002D83  7fb9             jg 0x2d3e
  002D85  47               inc di
  002D86  393e144b         cmp word ptr [0x4b14], di
  002D8A  7fa7             jg 0x2d33
  002D8C  ff76ec           push word ptr [bp - 0x14]
  002D8F  ff76ea           push word ptr [bp - 0x16]
  002D92  ff76e8           push word ptr [bp - 0x18]
  002D95  ff76e6           push word ptr [bp - 0x1a]
  002D98  ff36223b         push word ptr [0x3b22]
  002D9C  ff36203b         push word ptr [0x3b20]
  002DA0  ff361e3b         push word ptr [0x3b1e]
  002DA4  ff361c3b         push word ptr [0x3b1c]
  002DA8  ff36144b         push word ptr [0x4b14]
  002DAC  2bc0             sub ax, ax
  002DAE  99               cdq
  002DAF  8b1e124b         mov bx, word ptr [0x4b12]
  002DB3  9a00004c0c       lcall 0xc4c, 0
  002DB8  0e               push cs
  002DB9  e8a4e8           call 0x1660
  002DBC  6a00             push 0
  002DBE  684001           push 0x140
  002DC1  68c800           push 0xc8
  002DC4  2bc0             sub ax, ax
  002DC6  99               cdq
  002DC7  2bdb             sub bx, bx
  002DC9  9a4400340c       lcall 0xc34, 0x44
  002DCE  8d5ee6           lea bx, [bp - 0x1a]
  002DD1  9a0600460c       lcall 0xc46, 6
  002DD6  c70646000100     mov word ptr [0x46], 1
  002DDC  5e               pop si
  002DDD  5f               pop di
  002DDE  c9               leave
  002DDF  cb               retf

; ---- _execute_menu_event  file 0x002DE0..0x003184  seg 0x0:0x17e0  (mapedit.obj) ----
  002DE0  55               push bp
  002DE1  8bec             mov bp, sp
  002DE3  56               push si
  002DE4  8b4e06           mov cx, word ptr [bp + 6]
  002DE7  8bc1             mov ax, cx
  002DE9  2d1300           sub ax, 0x13
  002DEC  3d5700           cmp ax, 0x57
  002DEF  7603             jbe 0x2df4
  002DF1  e98c03           jmp 0x3180
  002DF4  d1e0             shl ax, 1
  002DF6  93               xchg bx, ax
  002DF7  2effa7fc17       jmp word ptr cs:[bx + 0x17fc]
  002DFC  ac               lodsb al, byte ptr [si]
  002DFD  1824             sbb byte ptr [si], ah
  002DFF  19801b80         sbb word ptr [bx + si - 0x7fe5], ax
  002E03  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E07  1b801b8e         sbb ax, word ptr [bx + si - 0x71e5]
  002E0B  19d4             sbb sp, dx
  002E0D  19801b80         sbb word ptr [bx + si - 0x7fe5], ax
  002E11  1b801b5e         sbb ax, word ptr [bx + si + 0x5e1b]
  002E15  1a801bba         sbb al, byte ptr [bx + si - 0x45e5]
  002E19  1a801b80         sbb al, byte ptr [bx + si - 0x7fe5]
  002E1D  1bc2             sbb ax, dx
  002E1F  1ad2             sbb dl, dl
  002E21  1ad8             sbb bl, al
  002E23  1ad8             sbb bl, al
  002E25  1ad8             sbb bl, al
  002E27  1ad8             sbb bl, al
  002E29  1a801be0         sbb al, byte ptr [bx + si - 0x1fe5]
  002E2D  1a801b80         sbb al, byte ptr [bx + si - 0x7fe5]
  002E31  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E35  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E39  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E3D  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E41  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E45  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E49  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E4D  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E51  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E55  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E59  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E5D  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E61  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E65  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E69  1bf4             sbb si, sp
  002E6B  1afc             sbb bh, ah
  002E6D  1a04             sbb al, byte ptr [si]
  002E6F  1b1a             sbb bx, word ptr [bp + si]
  002E71  1b28             sbb bp, word ptr [bx + si]
  002E73  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E77  1b401b           sbb ax, word ptr [bx + si + 0x1b]
  002E7A  4c               dec sp
  002E7B  1b581b           sbb bx, word ptr [bx + si + 0x1b]
  002E7E  641b801b80       sbb ax, word ptr fs:[bx + si - 0x7fe5]
  002E83  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E87  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E8B  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E8F  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E93  1b701b           sbb si, word ptr [bx + si + 0x1b]
  002E96  801b80           sbb byte ptr [bp + di], 0x80
  002E99  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002E9D  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002EA1  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002EA5  1b801b80         sbb ax, word ptr [bx + si - 0x7fe5]
  002EA9  1b7c1b           sbb di, word ptr [si + 0x1b]
  002EAC  68184a           push 0x4a18
  002EAF  684e63           push 0x634e
  002EB2  9a26068813       lcall 0x1388, 0x626
  002EB7  83c404           add sp, 4
  002EBA  684e63           push 0x634e
  002EBD  9a880a8813       lcall 0x1388, 0xa88
  002EC2  83c402           add sp, 2
  002EC5  6a0e             push 0xe
  002EC7  8d1e4602         lea bx, [0x246]
  002ECB  8d063f02         lea ax, [0x23f]
  002ECF  8d164e63         lea dx, [0x634e]
  002ED3  9a0a383d03       lcall 0x33d, 0x380a
  002ED8  0bc0             or ax, ax
  002EDA  7403             je 0x2edf
  002EDC  e9a102           jmp 0x3180
  002EDF  68644b           push 0x4b64
  002EE2  68184a           push 0x4a18
  002EE5  9a26068813       lcall 0x1388, 0x626
  002EEA  83c404           add sp, 4
  002EED  1e               push ds
  002EEE  68184a           push 0x4a18
  002EF1  1e               push ds
  002EF2  68184a           push 0x4a18
  002EF5  1e               push ds
  002EF6  684e02           push 0x24e
  002EF9  9a5c00040c       lcall 0xc04, 0x5c
  002EFE  9ab002f909       lcall 0x9f9, 0x2b0
  002F03  0bc0             or ax, ax
  002F05  7413             je 0x2f1a
  002F07  8d1e5702         lea bx, [0x257]
  002F0B  8d065102         lea ax, [0x251]
  002F0F  2bd2             sub dx, dx
  002F11  9ad8363d03       lcall 0x33d, 0x36d8
  002F16  e96702           jmp 0x3180
  002F19  90               nop
  002F1A  c70646000000     mov word ptr [0x46], 0
  002F20  e95d02           jmp 0x3180
  002F23  90               nop
  002F24  68184a           push 0x4a18
  002F27  684e63           push 0x634e
  002F2A  9a26068813       lcall 0x1388, 0x626
  002F2F  83c404           add sp, 4
  002F32  684e63           push 0x634e
  002F35  9a880a8813       lcall 0x1388, 0xa88
  002F3A  83c402           add sp, 2
  002F3D  833e460001       cmp word ptr [0x46], 1
  002F42  1bf6             sbb si, si
  002F44  f7de             neg si
  002F46  0bf6             or si, si
  002F48  751a             jne 0x2f64
  002F4A  8d1e6902         lea bx, [0x269]
  002F4E  8d065f02         lea ax, [0x25f]
  002F52  2bd2             sub dx, dx
  002F54  9ad8363d03       lcall 0x33d, 0x36d8
  002F59  48               dec ax
  002F5A  7506             jne 0x2f62
  002F5C  be0100           mov si, 1
  002F5F  eb03             jmp 0x2f64
  002F61  90               nop
  002F62  2bf6             sub si, si
  002F64  0bf6             or si, si
  002F66  7404             je 0x2f6c
  002F68  0e               push cs
  002F69  e890fc           call 0x2bfc
  002F6C  a1124b           mov ax, word ptr [0x4b12]
  002F6F  d1f8             sar ax, 1
  002F71  a3c804           mov word ptr [0x4c8], ax
  002F74  a3524b           mov word ptr [0x4b52], ax
  002F77  a1144b           mov ax, word ptr [0x4b14]
  002F7A  d1f8             sar ax, 1
  002F7C  a3ca04           mov word ptr [0x4ca], ax
  002F7F  a3544b           mov word ptr [0x4b54], ax
  002F82  9aca04560b       lcall 0xb56, 0x4ca
  002F87  0e               push cs
  002F88  e855f3           call 0x22e0
  002F8B  e9f201           jmp 0x3180
  002F8E  68184a           push 0x4a18
  002F91  684e63           push 0x634e
  002F94  9a26068813       lcall 0x1388, 0x626
  002F99  83c404           add sp, 4
  002F9C  684e63           push 0x634e
  002F9F  9a880a8813       lcall 0x1388, 0xa88
  002FA4  83c402           add sp, 2
  002FA7  8d1e2902         lea bx, [0x229]
  002FAB  8d062402         lea ax, [0x224]
  002FAF  2bd2             sub dx, dx
  002FB1  9ad8363d03       lcall 0x33d, 0x36d8
  002FB6  48               dec ax
  002FB7  7403             je 0x2fbc
  002FB9  e9c401           jmp 0x3180
  002FBC  9ab002f909       lcall 0x9f9, 0x2b0
  002FC1  0bc0             or ax, ax
  002FC3  7503             jne 0x2fc8
  002FC5  e952ff           jmp 0x2f1a
  002FC8  8d1e3702         lea bx, [0x237]
  002FCC  8d063102         lea ax, [0x231]
  002FD0  e93cff           jmp 0x2f0f
  002FD3  90               nop
  002FD4  68184a           push 0x4a18
  002FD7  684e63           push 0x634e
  002FDA  9a26068813       lcall 0x1388, 0x626
  002FDF  83c404           add sp, 4
  002FE2  684e63           push 0x634e
  002FE5  9a880a8813       lcall 0x1388, 0xa88
  002FEA  83c402           add sp, 2
  002FED  833e460001       cmp word ptr [0x46], 1
  002FF2  1bf6             sbb si, si
  002FF4  f7de             neg si
  002FF6  0bf6             or si, si
  002FF8  751a             jne 0x3014
  002FFA  8d1e7602         lea bx, [0x276]
  002FFE  8d067102         lea ax, [0x271]
  003002  2bd2             sub dx, dx
  003004  9ad8363d03       lcall 0x33d, 0x36d8
  003009  48               dec ax
  00300A  7506             jne 0x3012
  00300C  be0100           mov si, 1
  00300F  eb03             jmp 0x3014
  003011  90               nop
  003012  2bf6             sub si, si
  003014  0bf6             or si, si
  003016  7503             jne 0x301b
  003018  e96501           jmp 0x3180
  00301B  687e02           push 0x27e
  00301E  688302           push 0x283
  003021  688d02           push 0x28d
  003024  0e               push cs
  003025  e842eb           call 0x1b6a
  003028  83c406           add sp, 6
  00302B  0bc0             or ax, ax
  00302D  7d03             jge 0x3032
  00302F  e94e01           jmp 0x3180
  003032  ff36ee49         push word ptr [0x49ee]
  003036  68184a           push 0x4a18
  003039  9a26068813       lcall 0x1388, 0x626
  00303E  83c404           add sp, 4
  003041  9a7001f909       lcall 0x9f9, 0x170
  003046  0bc0             or ax, ax
  003048  740c             je 0x3056
  00304A  8d1e9b02         lea bx, [0x29b]
  00304E  8d069502         lea ax, [0x295]
  003052  e9bafe           jmp 0x2f0f
  003055  90               nop
  003056  0e               push cs
  003057  e85ce6           call 0x16b6
  00305A  e90fff           jmp 0x2f6c
  00305D  90               nop
  00305E  68184a           push 0x4a18
  003061  684e63           push 0x634e
  003064  9a26068813       lcall 0x1388, 0x626
  003069  83c404           add sp, 4
  00306C  684e63           push 0x634e
  00306F  9a880a8813       lcall 0x1388, 0xa88
  003074  83c402           add sp, 2
  003077  833e460000       cmp word ptr [0x46], 0
  00307C  750a             jne 0x3088
  00307E  c7066e5e0000     mov word ptr [0x5e6e], 0
  003084  e9f900           jmp 0x3180
  003087  90               nop
  003088  8d1ea802         lea bx, [0x2a8]
  00308C  8d06a302         lea ax, [0x2a3]
  003090  2bd2             sub dx, dx
  003092  9ad8363d03       lcall 0x33d, 0x36d8
  003097  8bf0             mov si, ax
  003099  83fe02           cmp si, 2
  00309C  7514             jne 0x30b2
  00309E  9ab002f909       lcall 0x9f9, 0x2b0
  0030A3  0bc0             or ax, ax
  0030A5  74d7             je 0x307e
  0030A7  8d1eb602         lea bx, [0x2b6]
  0030AB  8d06b002         lea ax, [0x2b0]
  0030AF  e95dfe           jmp 0x2f0f
  0030B2  4e               dec si
  0030B3  7403             je 0x30b8
  0030B5  e9c800           jmp 0x3180
  0030B8  ebc4             jmp 0x307e
  0030BA  0e               push cs
  0030BB  e8bcfa           call 0x2b7a
  0030BE  e9bf00           jmp 0x3180
  0030C1  90               nop
  0030C2  a1d004           mov ax, word ptr [0x4d0]
  0030C5  48               dec ax
  0030C6  50               push ax
  0030C7  0e               push cs
  0030C8  e8b7fa           call 0x2b82
  0030CB  83c402           add sp, 2
  0030CE  5e               pop si
  0030CF  c9               leave
  0030D0  cb               retf
  0030D1  90               nop
  0030D2  a1d004           mov ax, word ptr [0x4d0]
  0030D5  40               inc ax
  0030D6  ebee             jmp 0x30c6
  0030D8  83e929           sub cx, 0x29
  0030DB  f7d9             neg cx
  0030DD  51               push cx
  0030DE  ebe7             jmp 0x30c7
  0030E0  6a01             push 1
  0030E2  ff36544b         push word ptr [0x4b54]
  0030E6  ff36524b         push word ptr [0x4b52]
  0030EA  0e               push cs
  0030EB  e816f9           call 0x2a04
  0030EE  83c406           add sp, 6
  0030F1  5e               pop si
  0030F2  c9               leave
  0030F3  cb               retf
  0030F4  0e               push cs
  0030F5  e878fb           call 0x2c70
  0030F8  5e               pop si
  0030F9  c9               leave
  0030FA  cb               retf
  0030FB  90               nop
  0030FC  0e               push cs
  0030FD  e826f7           call 0x2826
  003100  5e               pop si
  003101  c9               leave
  003102  cb               retf
  003103  90               nop
  003104  a14a00           mov ax, word ptr [0x4a]
  003107  40               inc ax
  003108  b90300           mov cx, 3
  00310B  99               cdq
  00310C  f7f9             idiv cx
  00310E  89164a00         mov word ptr [0x4a], dx
  003112  0e               push cs
  003113  e838ee           call 0x1f4e
  003116  5e               pop si
  003117  c9               leave
  003118  cb               retf
  003119  90               nop
  00311A  833e4e0001       cmp word ptr [0x4e], 1
  00311F  1bc0             sbb ax, ax
  003121  f7d8             neg ax
  003123  a34e00           mov word ptr [0x4e], ax
  003126  ebea             jmp 0x3112
  003128  833e500000       cmp word ptr [0x50], 0
  00312D  7451             je 0x3180
  00312F  833e520000       cmp word ptr [0x52], 0
  003134  7503             jne 0x3139
  003136  e94efe           jmp 0x2f87
  003139  0e               push cs
  00313A  e841ec           call 0x1d7e
  00313D  e947fe           jmp 0x2f87
  003140  8d1ec402         lea bx, [0x2c4]
  003144  8d06be02         lea ax, [0x2be]
  003148  e9c4fd           jmp 0x2f0f
  00314B  90               nop
  00314C  8d1ed202         lea bx, [0x2d2]
  003150  8d06cc02         lea ax, [0x2cc]
  003154  e9b8fd           jmp 0x2f0f
  003157  90               nop
  003158  8d1ee002         lea bx, [0x2e0]
  00315C  8d06da02         lea ax, [0x2da]
  003160  e9acfd           jmp 0x2f0f
  003163  90               nop
  003164  8d1eee02         lea bx, [0x2ee]
  003168  8d06e802         lea ax, [0x2e8]
  00316C  e9a0fd           jmp 0x2f0f
  00316F  90               nop
  003170  8d1efc02         lea bx, [0x2fc]
  003174  8d06f602         lea ax, [0x2f6]
  003178  e994fd           jmp 0x2f0f
  00317B  90               nop
  00317C  0e               push cs
  00317D  e84cfa           call 0x2bcc
  003180  5e               pop si
  003181  c9               leave
  003182  cb               retf
  003183  90               nop

; ---- _mouse_area  file 0x003184..0x0031E0  seg 0x0:0x1b84  (mapedit.obj) ----
  003184  8b1e2407         mov bx, word ptr [0x724]
  003188  2bd2             sub dx, dx
  00318A  8b0e2607         mov cx, word ptr [0x726]
  00318E  81fbfc00         cmp bx, 0xfc
  003192  7c13             jl 0x31a7
  003194  83f909           cmp cx, 9
  003197  7c0e             jl 0x31a7
  003199  81fb3401         cmp bx, 0x134
  00319D  7d08             jge 0x31a7
  00319F  83f930           cmp cx, 0x30
  0031A2  7d03             jge 0x31a7
  0031A4  ba0200           mov dx, 2
  0031A7  81fbf100         cmp bx, 0xf1
  0031AB  7c14             jl 0x31c1
  0031AD  83f932           cmp cx, 0x32
  0031B0  7c0f             jl 0x31c1
  0031B2  81fb4001         cmp bx, 0x140
  0031B6  7d09             jge 0x31c1
  0031B8  81f9c800         cmp cx, 0xc8
  0031BC  7d03             jge 0x31c1
  0031BE  ba0300           mov dx, 3
  0031C1  0bdb             or bx, bx
  0031C3  7c18             jl 0x31dd
  0031C5  83f908           cmp cx, 8
  0031C8  7c13             jl 0x31dd
  0031CA  391eec64         cmp word ptr [0x64ec], bx
  0031CE  7e0d             jle 0x31dd
  0031D0  a1ee64           mov ax, word ptr [0x64ee]
  0031D3  050800           add ax, 8
  0031D6  3bc1             cmp ax, cx
  0031D8  7e03             jle 0x31dd
  0031DA  ba0100           mov dx, 1
  0031DD  8bc2             mov ax, dx
  0031DF  cb               retf

; ---- _change_map  file 0x0031E0..0x003328  seg 0x0:0x1be0  (mapedit.obj) ----
  0031E0  c80c0000         enter 0xc, 0
  0031E4  57               push di
  0031E5  56               push si
  0031E6  8b7e06           mov di, word ptr [bp + 6]
  0031E9  83ff01           cmp di, 1
  0031EC  7d03             jge 0x31f1
  0031EE  e93201           jmp 0x3323
  0031F1  8b7608           mov si, word ptr [bp + 8]
  0031F4  83fe01           cmp si, 1
  0031F7  7d03             jge 0x31fc
  0031F9  e92701           jmp 0x3323
  0031FC  a1124b           mov ax, word ptr [0x4b12]
  0031FF  48               dec ax
  003200  3bc7             cmp ax, di
  003202  7f03             jg 0x3207
  003204  e91c01           jmp 0x3323
  003207  a1144b           mov ax, word ptr [0x4b14]
  00320A  48               dec ax
  00320B  3bc6             cmp ax, si
  00320D  7f03             jg 0x3212
  00320F  e91101           jmp 0x3323
  003212  393ef249         cmp word ptr [0x49f2], di
  003216  7e03             jle 0x321b
  003218  e90801           jmp 0x3323
  00321B  393e2660         cmp word ptr [0x6026], di
  00321F  7d03             jge 0x3224
  003221  e9ff00           jmp 0x3323
  003224  3936f449         cmp word ptr [0x49f4], si
  003228  7e03             jle 0x322d
  00322A  e9f600           jmp 0x3323
  00322D  39363e60         cmp word ptr [0x603e], si
  003231  7d03             jge 0x3236
  003233  e9ed00           jmp 0x3323
  003236  56               push si
  003237  57               push di
  003238  9afa00ab02       lcall 0x2ab, 0xfa
  00323D  83c404           add sp, 4
  003240  8ec2             mov es, dx
  003242  8bd8             mov bx, ax
  003244  895ef4           mov word ptr [bp - 0xc], bx
  003247  8c46f6           mov word ptr [bp - 0xa], es
  00324A  268a07           mov al, byte ptr es:[bx]
  00324D  8846fe           mov byte ptr [bp - 2], al
  003250  241f             and al, 0x1f
  003252  8846ff           mov byte ptr [bp - 1], al
  003255  8846f9           mov byte ptr [bp - 7], al
  003258  837e0a00         cmp word ptr [bp + 0xa], 0
  00325C  7407             je 0x3265
  00325E  803e590000       cmp byte ptr [0x59], 0
  003263  7452             je 0x32b7
  003265  807eff19         cmp byte ptr [bp - 1], 0x19
  003269  7406             je 0x3271
  00326B  807eff1a         cmp byte ptr [bp - 1], 0x1a
  00326F  750e             jne 0x327f
  003271  833e4e0000       cmp word ptr [0x4e], 0
  003276  7407             je 0x327f
  003278  803e560000       cmp byte ptr [0x56], 0
  00327D  7d38             jge 0x32b7
  00327F  807eff19         cmp byte ptr [bp - 1], 0x19
  003283  7406             je 0x328b
  003285  807eff1a         cmp byte ptr [bp - 1], 0x1a
  003289  7507             jne 0x3292
  00328B  f606580020       test byte ptr [0x58], 0x20
  003290  7512             jne 0x32a4
  003292  a05700           mov al, byte ptr [0x57]
  003295  2046fe           and byte ptr [bp - 2], al
  003298  837e0a00         cmp word ptr [bp + 0xa], 0
  00329C  7506             jne 0x32a4
  00329E  a05800           mov al, byte ptr [0x58]
  0032A1  0846fe           or byte ptr [bp - 2], al
  0032A4  803e560000       cmp byte ptr [0x56], 0
  0032A9  7c0c             jl 0x32b7
  0032AB  837e0a00         cmp word ptr [bp + 0xa], 0
  0032AF  7506             jne 0x32b7
  0032B1  a05600           mov al, byte ptr [0x56]
  0032B4  8846ff           mov byte ptr [bp - 1], al
  0032B7  837e0a00         cmp word ptr [bp + 0xa], 0
  0032BB  7439             je 0x32f6
  0032BD  803e590000       cmp byte ptr [0x59], 0
  0032C2  7532             jne 0x32f6
  0032C4  807eff19         cmp byte ptr [bp - 1], 0x19
  0032C8  7414             je 0x32de
  0032CA  807eff1a         cmp byte ptr [bp - 1], 0x1a
  0032CE  740e             je 0x32de
  0032D0  8a46ff           mov al, byte ptr [bp - 1]
  0032D3  a25600           mov byte ptr [0x56], al
  0032D6  c6065700ff       mov byte ptr [0x57], 0xff
  0032DB  eb0c             jmp 0x32e9
  0032DD  90               nop
  0032DE  8a46ff           mov al, byte ptr [bp - 1]
  0032E1  a25600           mov byte ptr [0x56], al
  0032E4  c606570040       mov byte ptr [0x57], 0x40
  0032E9  c606580000       mov byte ptr [0x58], 0
  0032EE  0e               push cs
  0032EF  e85cec           call 0x1f4e
  0032F2  5e               pop si
  0032F3  5f               pop di
  0032F4  c9               leave
  0032F5  cb               retf
  0032F6  8066fee0         and byte ptr [bp - 2], 0xe0
  0032FA  803e590000       cmp byte ptr [0x59], 0
  0032FF  7405             je 0x3306
  003301  8a46f9           mov al, byte ptr [bp - 7]
  003304  eb03             jmp 0x3309
  003306  8a46ff           mov al, byte ptr [bp - 1]
  003309  0846fe           or byte ptr [bp - 2], al
  00330C  c45ef4           les bx, ptr [bp - 0xc]
  00330F  268a07           mov al, byte ptr es:[bx]
  003312  3846fe           cmp byte ptr [bp - 2], al
  003315  740c             je 0x3323
  003317  8a46fe           mov al, byte ptr [bp - 2]
  00331A  268807           mov byte ptr es:[bx], al
  00331D  c70646000100     mov word ptr [0x46], 1
  003323  5e               pop si
  003324  5f               pop di
  003325  c9               leave
  003326  cb               retf
  003327  90               nop

; ---- _fill_map  file 0x003328..0x0033B6  seg 0x0:0x1d28  (mapedit.obj) ----
  003328  c80a0000         enter 0xa, 0
  00332C  57               push di
  00332D  56               push si
  00332E  8b4606           mov ax, word ptr [bp + 6]
  003331  2b064a00         sub ax, word ptr [0x4a]
  003335  8946fa           mov word ptr [bp - 6], ax
  003338  8b7608           mov si, word ptr [bp + 8]
  00333B  2b364a00         sub si, word ptr [0x4a]
  00333F  8b3e4a00         mov di, word ptr [0x4a]
  003343  d1e7             shl di, 1
  003345  47               inc di
  003346  8bc6             mov ax, si
  003348  03c7             add ax, di
  00334A  3bc6             cmp ax, si
  00334C  7e4e             jle 0x339c
  00334E  8976f8           mov word ptr [bp - 8], si
  003351  8b46fa           mov ax, word ptr [bp - 6]
  003354  03c7             add ax, di
  003356  8946f6           mov word ptr [bp - 0xa], ax
  003359  897efc           mov word ptr [bp - 4], di
  00335C  8bfe             mov di, si
  00335E  8b56fc           mov dx, word ptr [bp - 4]
  003361  8b76fa           mov si, word ptr [bp - 6]
  003364  3976f6           cmp word ptr [bp - 0xa], si
  003367  7e23             jle 0x338c
  003369  57               push di
  00336A  56               push si
  00336B  9a0e00ab02       lcall 0x2ab, 0xe
  003370  83c404           add sp, 4
  003373  0bc0             or ax, ax
  003375  740c             je 0x3383
  003377  ff760a           push word ptr [bp + 0xa]
  00337A  57               push di
  00337B  56               push si
  00337C  0e               push cs
  00337D  e860fe           call 0x31e0
  003380  83c406           add sp, 6
  003383  46               inc si
  003384  3976f6           cmp word ptr [bp - 0xa], si
  003387  7fe0             jg 0x3369
  003389  8b56fc           mov dx, word ptr [bp - 4]
  00338C  8b46f8           mov ax, word ptr [bp - 8]
  00338F  03c2             add ax, dx
  003391  47               inc di
  003392  3bc7             cmp ax, di
  003394  7fcb             jg 0x3361
  003396  8b7efc           mov di, word ptr [bp - 4]
  003399  8b76f8           mov si, word ptr [bp - 8]
  00339C  8d4502           lea ax, [di + 2]
  00339F  50               push ax
  0033A0  50               push ax
  0033A1  8d44ff           lea ax, [si - 1]
  0033A4  50               push ax
  0033A5  8b46fa           mov ax, word ptr [bp - 6]
  0033A8  48               dec ax
  0033A9  50               push ax
  0033AA  9a0a00a208       lcall 0x8a2, 0xa
  0033AF  83c408           add sp, 8
  0033B2  5e               pop si
  0033B3  5f               pop di
  0033B4  c9               leave
  0033B5  cb               retf

; ---- _parse_main_keys  file 0x0033B6..0x00357E  seg 0x0:0x1db6  (mapedit.obj) ----
  0033B6  c8060000         enter 6, 0
  0033BA  57               push di
  0033BB  56               push si
  0033BC  c746fa0100       mov word ptr [bp - 6], 1
  0033C1  2bc0             sub ax, ax
  0033C3  8946fc           mov word ptr [bp - 4], ax
  0033C6  8946fe           mov word ptr [bp - 2], ax
  0033C9  a16c52           mov ax, word ptr [0x526c]
  0033CC  3d3700           cmp ax, 0x37
  0033CF  7503             jne 0x33d4
  0033D1  e97401           jmp 0x3548
  0033D4  7f5c             jg 0x3432
  0033D6  3d3600           cmp ax, 0x36
  0033D9  7503             jne 0x33de
  0033DB  e96201           jmp 0x3540
  0033DE  7603             jbe 0x33e3
  0033E0  e99d00           jmp 0x3480
  0033E3  3c1b             cmp al, 0x1b
  0033E5  7503             jne 0x33ea
  0033E7  e9d600           jmp 0x34c0
  0033EA  7f20             jg 0x340c
  0033EC  2c08             sub al, 8
  0033EE  7503             jne 0x33f3
  0033F0  e99500           jmp 0x3488
  0033F3  2c05             sub al, 5
  0033F5  7503             jne 0x33fa
  0033F7  e9be00           jmp 0x34b8
  0033FA  2c04             sub al, 4
  0033FC  7503             jne 0x3401
  0033FE  e9bf00           jmp 0x34c0
  003401  2c07             sub al, 7
  003403  7503             jne 0x3408
  003405  e9b800           jmp 0x34c0
  003408  eb76             jmp 0x3480
  00340A  90               nop
  00340B  90               nop
  00340C  2c20             sub al, 0x20
  00340E  7503             jne 0x3413
  003410  e9a500           jmp 0x34b8
  003413  2c11             sub al, 0x11
  003415  7503             jne 0x341a
  003417  e90601           jmp 0x3520
  00341A  fec8             dec al
  00341C  7503             jne 0x3421
  00341E  e90401           jmp 0x3525
  003421  fec8             dec al
  003423  7503             jne 0x3428
  003425  e90401           jmp 0x352c
  003428  fec8             dec al
  00342A  7503             jne 0x342f
  00342C  e90901           jmp 0x3538
  00342F  eb4f             jmp 0x3480
  003431  90               nop
  003432  3d4801           cmp ax, 0x148
  003435  7503             jne 0x343a
  003437  e91901           jmp 0x3553
  00343A  7f22             jg 0x345e
  00343C  2d3800           sub ax, 0x38
  00343F  7503             jne 0x3444
  003441  e90f01           jmp 0x3553
  003444  48               dec ax
  003445  7503             jne 0x344a
  003447  e90401           jmp 0x354e
  00344A  2dd700           sub ax, 0xd7
  00344D  7471             je 0x34c0
  00344F  2d1d00           sub ax, 0x1d
  003452  746c             je 0x34c0
  003454  2d1a00           sub ax, 0x1a
  003457  7503             jne 0x345c
  003459  e9ec00           jmp 0x3548
  00345C  eb22             jmp 0x3480
  00345E  2d4901           sub ax, 0x149
  003461  3d0800           cmp ax, 8
  003464  771a             ja 0x3480
  003466  d1e0             shl ax, 1
  003468  93               xchg bx, ax
  003469  2effa76e1e       jmp word ptr cs:[bx + 0x1e6e]
  00346E  4e               dec si
  00346F  1f               pop ds
  003470  801e381f80       sbb byte ptr [0x1f38], 0x80
  003475  1e               push ds
  003476  40               inc ax
  003477  1f               pop ds
  003478  801e201f25       sbb byte ptr [0x1f20], 0x25
  00347D  1f               pop ds
  00347E  2c1f             sub al, 0x1f
  003480  c746fa0000       mov word ptr [bp - 6], 0
  003485  e9d000           jmp 0x3558
  003488  803e590000       cmp byte ptr [0x59], 0
  00348D  7515             jne 0x34a4
  00348F  6a01             push 1
  003491  ff36544b         push word ptr [0x4b54]
  003495  ff36524b         push word ptr [0x4b52]
  003499  0e               push cs
  00349A  e843fd           call 0x31e0
  00349D  83c406           add sp, 6
  0034A0  e9b500           jmp 0x3558
  0034A3  90               nop
  0034A4  0e               push cs
  0034A5  e8a8e8           call 0x1d50
  0034A8  6a01             push 1
  0034AA  ff36544b         push word ptr [0x4b54]
  0034AE  ff36524b         push word ptr [0x4b52]
  0034B2  0e               push cs
  0034B3  e872fe           call 0x3328
  0034B6  ebe5             jmp 0x349d
  0034B8  0e               push cs
  0034B9  e894e8           call 0x1d50
  0034BC  6a00             push 0
  0034BE  ebea             jmp 0x34aa
  0034C0  833e460000       cmp word ptr [0x46], 0
  0034C5  7509             jne 0x34d0
  0034C7  c7066e5e0000     mov word ptr [0x5e6e], 0
  0034CD  e98800           jmp 0x3558
  0034D0  68184a           push 0x4a18
  0034D3  684e63           push 0x634e
  0034D6  9a26068813       lcall 0x1388, 0x626
  0034DB  83c404           add sp, 4
  0034DE  684e63           push 0x634e
  0034E1  9a880a8813       lcall 0x1388, 0xa88
  0034E6  83c402           add sp, 2
  0034E9  8d1e0903         lea bx, [0x309]
  0034ED  8d060403         lea ax, [0x304]
  0034F1  2bd2             sub dx, dx
  0034F3  9ad8363d03       lcall 0x33d, 0x36d8
  0034F8  8bf0             mov si, ax
  0034FA  83fe02           cmp si, 2
  0034FD  751b             jne 0x351a
  0034FF  9ab002f909       lcall 0x9f9, 0x2b0
  003504  0bc0             or ax, ax
  003506  74bf             je 0x34c7
  003508  8d1e1703         lea bx, [0x317]
  00350C  8d061103         lea ax, [0x311]
  003510  2bd2             sub dx, dx
  003512  9ad8363d03       lcall 0x33d, 0x36d8
  003517  eb3f             jmp 0x3558
  003519  90               nop
  00351A  4e               dec si
  00351B  753b             jne 0x3558
  00351D  eba8             jmp 0x34c7
  00351F  90               nop
  003520  c746fcffff       mov word ptr [bp - 4], 0xffff
  003525  c746fe0100       mov word ptr [bp - 2], 1
  00352A  eb2c             jmp 0x3558
  00352C  b80100           mov ax, 1
  00352F  8946fc           mov word ptr [bp - 4], ax
  003532  8946fe           mov word ptr [bp - 2], ax
  003535  eb21             jmp 0x3558
  003537  90               nop
  003538  c746fcffff       mov word ptr [bp - 4], 0xffff
  00353D  eb19             jmp 0x3558
  00353F  90               nop
  003540  c746fc0100       mov word ptr [bp - 4], 1
  003545  eb11             jmp 0x3558
  003547  90               nop
  003548  b8ffff           mov ax, 0xffff
  00354B  ebe2             jmp 0x352f
  00354D  90               nop
  00354E  c746fc0100       mov word ptr [bp - 4], 1
  003553  c746feffff       mov word ptr [bp - 2], 0xffff
  003558  837efc00         cmp word ptr [bp - 4], 0
  00355C  7509             jne 0x3567
  00355E  8b7efa           mov di, word ptr [bp - 6]
  003561  837efe00         cmp word ptr [bp - 2], 0
  003565  7410             je 0x3577
  003567  ff76fe           push word ptr [bp - 2]
  00356A  ff76fc           push word ptr [bp - 4]
  00356D  0e               push cs
  00356E  e8a3f5           call 0x2b14
  003571  83c404           add sp, 4
  003574  bf0100           mov di, 1
  003577  8bc7             mov ax, di
  003579  5e               pop si
  00357A  5f               pop di
  00357B  c9               leave
  00357C  cb               retf
  00357D  90               nop

; ---- _parse_viewing_keys  file 0x00357E..0x00358E  seg 0x0:0x1f7e  (mapedit.obj) ----
  00357E  ba0100           mov dx, 1
  003581  a16c52           mov ax, word ptr [0x526c]
  003584  2d0d00           sub ax, 0xd
  003587  7402             je 0x358b
  003589  2bd2             sub dx, dx
  00358B  8bc2             mov ax, dx
  00358D  cb               retf

; ---- _parse_area_map  file 0x00358E..0x003682  seg 0x0:0x1f8e  (mapedit.obj) ----
  00358E  c8060000         enter 6, 0
  003592  57               push di
  003593  56               push si
  003594  c746fe0000       mov word ptr [bp - 2], 0
  003599  a18e4e           mov ax, word ptr [0x4e8e]
  00359C  3906ce5a         cmp word ptr [0x5ace], ax
  0035A0  7403             je 0x35a5
  0035A2  e9d600           jmp 0x367b
  0035A5  0e               push cs
  0035A6  e8dde1           call 0x1786
  0035A9  8946fa           mov word ptr [bp - 6], ax
  0035AC  833e280700       cmp word ptr [0x728], 0
  0035B1  7404             je 0x35b7
  0035B3  0e               push cs
  0035B4  e899e7           call 0x1d50
  0035B7  8b76fe           mov si, word ptr [bp - 2]
  0035BA  8b7efc           mov di, word ptr [bp - 4]
  0035BD  833e320700       cmp word ptr [0x732], 0
  0035C2  7459             je 0x361d
  0035C4  a12607           mov ax, word ptr [0x726]
  0035C7  2d0800           sub ax, 8
  0035CA  8a0ed004         mov cl, byte ptr [0x4d0]
  0035CE  bb1000           mov bx, 0x10
  0035D1  d3fb             sar bx, cl
  0035D3  99               cdq
  0035D4  f7fb             idiv bx
  0035D6  2b06f45a         sub ax, word ptr [0x5af4]
  0035DA  0306f449         add ax, word ptr [0x49f4]
  0035DE  8bf0             mov si, ax
  0035E0  50               push ax
  0035E1  a12407           mov ax, word ptr [0x724]
  0035E4  99               cdq
  0035E5  f7fb             idiv bx
  0035E7  8bf8             mov di, ax
  0035E9  2b3ed85a         sub di, word ptr [0x5ad8]
  0035ED  033ef249         add di, word ptr [0x49f2]
  0035F1  57               push di
  0035F2  9a0e00ab02       lcall 0x2ab, 0xe
  0035F7  83c404           add sp, 4
  0035FA  0bc0             or ax, ax
  0035FC  747d             je 0x367b
  0035FE  393e524b         cmp word ptr [0x4b52], di
  003602  7506             jne 0x360a
  003604  3936544b         cmp word ptr [0x4b54], si
  003608  7413             je 0x361d
  00360A  833e726900       cmp word ptr [0x6972], 0
  00360F  7404             je 0x3615
  003611  0e               push cs
  003612  e8fbf2           call 0x2910
  003615  893e524b         mov word ptr [0x4b52], di
  003619  8936544b         mov word ptr [0x4b54], si
  00361D  833e320700       cmp word ptr [0x732], 0
  003622  7457             je 0x367b
  003624  837efa00         cmp word ptr [bp - 6], 0
  003628  751a             jne 0x3644
  00362A  833e300700       cmp word ptr [0x730], 0
  00362F  7507             jne 0x3638
  003631  833e200700       cmp word ptr [0x720], 0
  003636  7431             je 0x3669
  003638  6a01             push 1
  00363A  56               push si
  00363B  57               push di
  00363C  0e               push cs
  00363D  e8c4f3           call 0x2a04
  003640  eb24             jmp 0x3666
  003642  90               nop
  003643  90               nop
  003644  833e200700       cmp word ptr [0x720], 0
  003649  7411             je 0x365c
  00364B  803e590000       cmp byte ptr [0x59], 0
  003650  750a             jne 0x365c
  003652  6a01             push 1
  003654  56               push si
  003655  57               push di
  003656  0e               push cs
  003657  e886fb           call 0x31e0
  00365A  eb0a             jmp 0x3666
  00365C  ff362007         push word ptr [0x720]
  003660  56               push si
  003661  57               push di
  003662  0e               push cs
  003663  e8c2fc           call 0x3328
  003666  83c406           add sp, 6
  003669  833e300700       cmp word ptr [0x730], 0
  00366E  740b             je 0x367b
  003670  833e726900       cmp word ptr [0x6972], 0
  003675  7504             jne 0x367b
  003677  0e               push cs
  003678  e895f2           call 0x2910
  00367B  2bc0             sub ax, ax
  00367D  5e               pop si
  00367E  5f               pop di
  00367F  c9               leave
  003680  cb               retf
  003681  90               nop

; ---- _parse_area_mini  file 0x003682..0x0036E0  seg 0x0:0x2082  (mapedit.obj) ----
  003682  57               push di
  003683  56               push si
  003684  833e300700       cmp word ptr [0x730], 0
  003689  7452             je 0x36dd
  00368B  8b362607         mov si, word ptr [0x726]
  00368F  0336c249         add si, word ptr [0x49c2]
  003693  83ee09           sub si, 9
  003696  a1124b           mov ax, word ptr [0x4b12]
  003699  48               dec ax
  00369A  48               dec ax
  00369B  50               push ax
  00369C  6a01             push 1
  00369E  a12407           mov ax, word ptr [0x724]
  0036A1  03068269         add ax, word ptr [0x6982]
  0036A5  2dfc00           sub ax, 0xfc
  0036A8  50               push ax
  0036A9  9a0e006508       lcall 0x865, 0xe
  0036AE  83c406           add sp, 6
  0036B1  8bf8             mov di, ax
  0036B3  a1144b           mov ax, word ptr [0x4b14]
  0036B6  48               dec ax
  0036B7  48               dec ax
  0036B8  50               push ax
  0036B9  6a01             push 1
  0036BB  56               push si
  0036BC  9a0e006508       lcall 0x865, 0xe
  0036C1  83c406           add sp, 6
  0036C4  8bf0             mov si, ax
  0036C6  393ec804         cmp word ptr [0x4c8], di
  0036CA  7506             jne 0x36d2
  0036CC  3936ca04         cmp word ptr [0x4ca], si
  0036D0  740b             je 0x36dd
  0036D2  6a01             push 1
  0036D4  56               push si
  0036D5  57               push di
  0036D6  0e               push cs
  0036D7  e82af3           call 0x2a04
  0036DA  83c406           add sp, 6
  0036DD  5e               pop si
  0036DE  5f               pop di
  0036DF  cb               retf

; ---- _parse_mouse_stroke  file 0x0036E0..0x003724  seg 0x0:0x20e0  (mapedit.obj) ----
  0036E0  56               push si
  0036E1  2bf6             sub si, si
  0036E3  0e               push cs
  0036E4  e89dfa           call 0x3184
  0036E7  a3ce5a           mov word ptr [0x5ace], ax
  0036EA  39362807         cmp word ptr [0x728], si
  0036EE  7403             je 0x36f3
  0036F0  a38e4e           mov word ptr [0x4e8e], ax
  0036F3  a18e4e           mov ax, word ptr [0x4e8e]
  0036F6  48               dec ax
  0036F7  740b             je 0x3704
  0036F9  48               dec ax
  0036FA  7412             je 0x370e
  0036FC  48               dec ax
  0036FD  7417             je 0x3716
  0036FF  8bc6             mov ax, si
  003701  5e               pop si
  003702  cb               retf
  003703  90               nop
  003704  0e               push cs
  003705  e886fe           call 0x358e
  003708  8bf0             mov si, ax
  00370A  8bc6             mov ax, si
  00370C  5e               pop si
  00370D  cb               retf
  00370E  0e               push cs
  00370F  e870ff           call 0x3682
  003712  8bc6             mov ax, si
  003714  5e               pop si
  003715  cb               retf
  003716  39363007         cmp word ptr [0x730], si
  00371A  7404             je 0x3720
  00371C  0e               push cs
  00371D  e806f1           call 0x2826
  003720  8bc6             mov ax, si
  003722  5e               pop si
  003723  cb               retf

; ---- _human_interface_loop  file 0x003724..0x00389C  seg 0x0:0x2124  (mapedit.obj) ----
  003724  55               push bp
  003725  8bec             mov bp, sp
  003727  57               push di
  003728  56               push si
  003729  9a0600180d       lcall 0xd18, 6
  00372E  051400           add ax, 0x14
  003731  83d200           adc dx, 0
  003734  a3a04e           mov word ptr [0x4ea0], ax
  003737  8916a24e         mov word ptr [0x4ea2], dx
  00373B  2bf6             sub si, si
  00373D  89367269         mov word ptr [0x6972], si
  003741  0e               push cs
  003742  e8cbf1           call 0x2910
  003745  9a2a00210c       lcall 0xc21, 0x2a
  00374A  9a0600180d       lcall 0xd18, 6
  00374F  a3144a           mov word ptr [0x4a14], ax
  003752  8916164a         mov word ptr [0x4a16], dx
  003756  2bc0             sub ax, ax
  003758  9a4200210c       lcall 0xc21, 0x42
  00375D  9a0400af0b       lcall 0xbaf, 4
  003762  8bf8             mov di, ax
  003764  0bff             or di, di
  003766  7513             jne 0x377b
  003768  ff367a00         push word ptr [0x7a]
  00376C  ff367800         push word ptr [0x78]
  003770  2bc0             sub ax, ax
  003772  9ab413d706       lcall 0x6d7, 0x13b4
  003777  0bc0             or ax, ax
  003779  7425             je 0x37a0
  00377B  833e726900       cmp word ptr [0x6972], 0
  003780  740a             je 0x378c
  003782  a1144a           mov ax, word ptr [0x4a14]
  003785  8b16164a         mov dx, word ptr [0x4a16]
  003789  eb0e             jmp 0x3799
  00378B  90               nop
  00378C  a1144a           mov ax, word ptr [0x4a14]
  00378F  8b16164a         mov dx, word ptr [0x4a16]
  003793  051400           add ax, 0x14
  003796  83d200           adc dx, 0
  003799  a3a04e           mov word ptr [0x4ea0], ax
  00379C  8916a24e         mov word ptr [0x4ea2], dx
  0037A0  a1144a           mov ax, word ptr [0x4a14]
  0037A3  8b16164a         mov dx, word ptr [0x4a16]
  0037A7  3916a24e         cmp word ptr [0x4ea2], dx
  0037AB  7f20             jg 0x37cd
  0037AD  7c06             jl 0x37b5
  0037AF  3906a04e         cmp word ptr [0x4ea0], ax
  0037B3  7718             ja 0x37cd
  0037B5  0e               push cs
  0037B6  e857f1           call 0x2910
  0037B9  a1144a           mov ax, word ptr [0x4a14]
  0037BC  8b16164a         mov dx, word ptr [0x4a16]
  0037C0  051400           add ax, 0x14
  0037C3  83d200           adc dx, 0
  0037C6  a3a04e           mov word ptr [0x4ea0], ax
  0037C9  8916a24e         mov word ptr [0x4ea2], dx
  0037CD  0bff             or di, di
  0037CF  7476             je 0x3847
  0037D1  9a1800af0b       lcall 0xbaf, 0x18
  0037D6  a36c52           mov word ptr [0x526c], ax
  0037D9  3dff00           cmp ax, 0xff
  0037DC  7d0e             jge 0x37ec
  0037DE  8bd8             mov bx, ax
  0037E0  f687a94502       test byte ptr [bx + 0x45a9], 2
  0037E5  7405             je 0x37ec
  0037E7  832e6c5220       sub word ptr [0x526c], 0x20
  0037EC  c706684a0000     mov word ptr [0x4a68], 0
  0037F2  ff367a00         push word ptr [0x7a]
  0037F6  ff367800         push word ptr [0x78]
  0037FA  a16c52           mov ax, word ptr [0x526c]
  0037FD  9a5214d706       lcall 0x6d7, 0x1452
  003802  a3684a           mov word ptr [0x4a68], ax
  003805  0bc0             or ax, ax
  003807  7513             jne 0x381c
  003809  ff367a00         push word ptr [0x7a]
  00380D  ff367800         push word ptr [0x78]
  003811  a16c52           mov ax, word ptr [0x526c]
  003814  9ae614d706       lcall 0x6d7, 0x14e6
  003819  a3684a           mov word ptr [0x4a68], ax
  00381C  0bc0             or ax, ax
  00381E  7507             jne 0x3827
  003820  0e               push cs
  003821  e892fb           call 0x33b6
  003824  a3684a           mov word ptr [0x4a68], ax
  003827  0bc0             or ax, ax
  003829  7507             jne 0x3832
  00382B  0e               push cs
  00382C  e84ffd           call 0x357e
  00382F  a3684a           mov word ptr [0x4a68], ax
  003832  9a0600180d       lcall 0xd18, 6
  003837  051400           add ax, 0x14
  00383A  83d200           adc dx, 0
  00383D  a3a04e           mov word ptr [0x4ea0], ax
  003840  8916a24e         mov word ptr [0x4ea2], dx
  003844  be0100           mov si, 1
  003847  0bff             or di, di
  003849  7522             jne 0x386d
  00384B  c41e7800         les bx, ptr [0x78]
  00384F  26393f           cmp word ptr es:[bx], di
  003852  7519             jne 0x386d
  003854  06               push es
  003855  53               push bx
  003856  b80100           mov ax, 1
  003859  9ab413d706       lcall 0x6d7, 0x13b4
  00385E  c41e7800         les bx, ptr [0x78]
  003862  26393f           cmp word ptr es:[bx], di
  003865  7506             jne 0x386d
  003867  0e               push cs
  003868  e875fe           call 0x36e0
  00386B  0bf0             or si, ax
  00386D  c41e7800         les bx, ptr [0x78]
  003871  26833f00         cmp word ptr es:[bx], 0
  003875  740d             je 0x3884
  003877  be0100           mov si, 1
  00387A  26ff37           push word ptr es:[bx]
  00387D  0e               push cs
  00387E  e85ff5           call 0x2de0
  003881  83c402           add sp, 2
  003884  2bc0             sub ax, ax
  003886  8b166e5e         mov dx, word ptr [0x5e6e]
  00388A  9a1001210c       lcall 0xc21, 0x110
  00388F  0bf6             or si, si
  003891  7503             jne 0x3896
  003893  e9b4fe           jmp 0x374a
  003896  5e               pop si
  003897  5f               pop di
  003898  c9               leave
  003899  cb               retf
  00389A  90               nop
  00389B  90               nop

; ---- _human_turn  file 0x00389C..0x0038AE  seg 0x0:0x229c  (mapedit.obj) ----
  00389C  9a6800a208       lcall 0x8a2, 0x68
  0038A1  0e               push cs
  0038A2  e87ffe           call 0x3724
  0038A5  833e6e5e00       cmp word ptr [0x5e6e], 0
  0038AA  75f5             jne 0x38a1
  0038AC  cb               retf
  0038AD  90               nop

; ---- _computer_turn  file 0x0038AE..0x0038B0  seg 0x0:0x22ae  (mapedit.obj) ----
  0038AE  cb               retf
  0038AF  90               nop

; ---- _turn_control_loop  file 0x0038B0..0x0038E4  seg 0x0:0x22b0  (mapedit.obj) ----
  0038B0  0e               push cs
  0038B1  e8e2de           call 0x1796
  0038B4  6a01             push 1
  0038B6  6a00             push 0
  0038B8  6a00             push 0
  0038BA  ff367a00         push word ptr [0x7a]
  0038BE  ff367800         push word ptr [0x78]
  0038C2  9a4409d706       lcall 0x6d7, 0x944
  0038C7  83c40a           add sp, 0xa
  0038CA  9adc00560b       lcall 0xb56, 0xdc
  0038CF  9a6800a208       lcall 0x8a2, 0x68
  0038D4  0e               push cs
  0038D5  e876e6           call 0x1f4e
  0038D8  0e               push cs
  0038D9  e8c0ff           call 0x389c
  0038DC  833e6e5e00       cmp word ptr [0x5e6e], 0
  0038E1  75f1             jne 0x38d4
  0038E3  cb               retf

; ---- _load_terrain  file 0x0038E4..0x003936  seg 0x0:0x22e4  (mapedit.obj) ----
  0038E4  55               push bp
  0038E5  8bec             mov bp, sp
  0038E7  57               push di
  0038E8  56               push si
  0038E9  8b7e06           mov di, word ptr [bp + 6]
  0038EC  9a06014208       lcall 0x842, 0x106
  0038F1  9ac8014208       lcall 0x842, 0x1c8
  0038F6  8bdf             mov bx, di
  0038F8  c1e304           shl bx, 4
  0038FB  8987e64e         mov word ptr [bx + 0x4ee6], ax
  0038FF  8bf3             mov si, bx
  003901  9a98014208       lcall 0x842, 0x198
  003906  8884e84e         mov byte ptr [si + 0x4ee8], al
  00390A  9a98014208       lcall 0x842, 0x198
  00390F  8884e94e         mov byte ptr [si + 0x4ee9], al
  003913  9a98014208       lcall 0x842, 0x198
  003918  8884ea4e         mov byte ptr [si + 0x4eea], al
  00391C  2bf6             sub si, si
  00391E  9a98014208       lcall 0x842, 0x198
  003923  8bdf             mov bx, di
  003925  c1e304           shl bx, 4
  003928  8880ed4e         mov byte ptr [bx + si + 0x4eed], al
  00392C  46               inc si
  00392D  83fe09           cmp si, 9
  003930  7cec             jl 0x391e
  003932  5e               pop si
  003933  5f               pop di
  003934  c9               leave
  003935  cb               retf

; ---- _load_data  file 0x003936..0x003A7A  seg 0x0:0x2336  (mapedit.obj) ----
  003936  c8240000         enter 0x24, 0
  00393A  57               push di
  00393B  56               push si
  00393C  8d7eec           lea di, [bp - 0x14]
  00393F  be1f03           mov si, 0x31f
  003942  8cd0             mov ax, ss
  003944  8ec0             mov es, ax
  003946  a5               movsw word ptr es:[di], word ptr [si]
  003947  a5               movsw word ptr es:[di], word ptr [si]
  003948  a5               movsw word ptr es:[di], word ptr [si]
  003949  2bc0             sub ax, ax
  00394B  b90a00           mov cx, 0xa
  00394E  8d7ef2           lea di, [bp - 0xe]
  003951  f3aa             rep stosb byte ptr es:[di], al
  003953  8d7edc           lea di, [bp - 0x24]
  003956  be2503           mov si, 0x325
  003959  a5               movsw word ptr es:[di], word ptr [si]
  00395A  a5               movsw word ptr es:[di], word ptr [si]
  00395B  a5               movsw word ptr es:[di], word ptr [si]
  00395C  a4               movsb byte ptr es:[di], byte ptr [si]
  00395D  2bc0             sub ax, ax
  00395F  b90900           mov cx, 9
  003962  8d7ee3           lea di, [bp - 0x1d]
  003965  f3aa             rep stosb byte ptr es:[di], al
  003967  682c03           push 0x32c
  00396A  8d46ec           lea ax, [bp - 0x14]
  00396D  50               push ax
  00396E  9a1a004208       lcall 0x842, 0x1a
  003973  83c404           add sp, 4
  003976  c746fc0000       mov word ptr [bp - 4], 0
  00397B  8b76fc           mov si, word ptr [bp - 4]
  00397E  56               push si
  00397F  0e               push cs
  003980  e861ff           call 0x38e4
  003983  83c402           add sp, 2
  003986  46               inc si
  003987  83fe08           cmp si, 8
  00398A  7cf2             jl 0x397e
  00398C  683703           push 0x337
  00398F  6a00             push 0
  003991  9a1a004208       lcall 0x842, 0x1a
  003996  83c404           add sp, 4
  003999  c746fc0000       mov word ptr [bp - 4], 0
  00399E  c746fee64f       mov word ptr [bp - 2], 0x4fe6
  0039A3  8b46fc           mov ax, word ptr [bp - 4]
  0039A6  050800           add ax, 8
  0039A9  50               push ax
  0039AA  0e               push cs
  0039AB  e836ff           call 0x38e4
  0039AE  83c402           add sp, 2
  0039B1  8b5efe           mov bx, word ptr [bp - 2]
  0039B4  8d7780           lea si, [bx - 0x80]
  0039B7  1e               push ds
  0039B8  07               pop es
  0039B9  8b7efe           mov di, word ptr [bp - 2]
  0039BC  b90800           mov cx, 8
  0039BF  f3a5             rep movsw word ptr es:[di], word ptr [si]
  0039C1  ff46fc           inc word ptr [bp - 4]
  0039C4  8346fe10         add word ptr [bp - 2], 0x10
  0039C8  817efe6650       cmp word ptr [bp - 2], 0x5066
  0039CD  72d4             jb 0x39a3
  0039CF  684003           push 0x340
  0039D2  6a00             push 0
  0039D4  9a1a004208       lcall 0x842, 0x1a
  0039D9  83c404           add sp, 4
  0039DC  2bf6             sub si, si
  0039DE  8d4418           lea ax, [si + 0x18]
  0039E1  50               push ax
  0039E2  0e               push cs
  0039E3  e8fefe           call 0x38e4
  0039E6  83c402           add sp, 2
  0039E9  46               inc si
  0039EA  83fe05           cmp si, 5
  0039ED  7cef             jl 0x39de
  0039EF  684603           push 0x346
  0039F2  6a00             push 0
  0039F4  9a1a004208       lcall 0x842, 0x1a
  0039F9  83c404           add sp, 4
  0039FC  be5a4b           mov si, 0x4b5a
  0039FF  9a06014208       lcall 0x842, 0x106
  003A04  9ac8014208       lcall 0x842, 0x1c8
  003A09  46               inc si
  003A0A  46               inc si
  003A0B  8944fe           mov word ptr [si - 2], ax
  003A0E  81fe644b         cmp si, 0x4b64
  003A12  72eb             jb 0x39ff
  003A14  685203           push 0x352
  003A17  6a00             push 0
  003A19  9a1a004208       lcall 0x842, 0x1a
  003A1E  83c404           add sp, 4
  003A21  0bc0             or ax, ax
  003A23  754d             jne 0x3a72
  003A25  9a06014208       lcall 0x842, 0x106
  003A2A  9a98014208       lcall 0x842, 0x198
  003A2F  a29200           mov byte ptr [0x92], al
  003A32  9a98014208       lcall 0x842, 0x198
  003A37  a29300           mov byte ptr [0x93], al
  003A3A  9a98014208       lcall 0x842, 0x198
  003A3F  a29400           mov byte ptr [0x94], al
  003A42  9a98014208       lcall 0x842, 0x198
  003A47  a29500           mov byte ptr [0x95], al
  003A4A  9a98014208       lcall 0x842, 0x198
  003A4F  a29600           mov byte ptr [0x96], al
  003A52  9a98014208       lcall 0x842, 0x198
  003A57  a29700           mov byte ptr [0x97], al
  003A5A  9a98014208       lcall 0x842, 0x198
  003A5F  a29900           mov byte ptr [0x99], al
  003A62  9a98014208       lcall 0x842, 0x198
  003A67  a29a00           mov byte ptr [0x9a], al
  003A6A  9a98014208       lcall 0x842, 0x198
  003A6F  a29b00           mov byte ptr [0x9b], al
  003A72  0e               push cs
  003A73  e8a2db           call 0x1618
  003A76  5e               pop si
  003A77  5f               pop di
  003A78  c9               leave
  003A79  cb               retf

; ---- _start_new_game  file 0x003A7A..0x003B16  seg 0x0:0x247a  (mapedit.obj) ----
  003A7A  56               push si
  003A7B  be0100           mov si, 1
  003A7E  833e4c0000       cmp word ptr [0x4c], 0
  003A83  7530             jne 0x3ab5
  003A85  833e540000       cmp word ptr [0x54], 0
  003A8A  7529             jne 0x3ab5
  003A8C  685903           push 0x359
  003A8F  685e03           push 0x35e
  003A92  686803           push 0x368
  003A95  0e               push cs
  003A96  e8d1e0           call 0x1b6a
  003A99  83c406           add sp, 6
  003A9C  0bc0             or ax, ax
  003A9E  7d06             jge 0x3aa6
  003AA0  89365400         mov word ptr [0x54], si
  003AA4  eb0f             jmp 0x3ab5
  003AA6  ff36ee49         push word ptr [0x49ee]
  003AAA  68184a           push 0x4a18
  003AAD  9a26068813       lcall 0x1388, 0x626
  003AB2  83c404           add sp, 4
  003AB5  c706124b3a00     mov word ptr [0x4b12], 0x3a
  003ABB  c706144b4800     mov word ptr [0x4b14], 0x48
  003AC1  8bc6             mov ax, si
  003AC3  a3d804           mov word ptr [0x4d8], ax
  003AC6  9a3e04f909       lcall 0x9f9, 0x43e
  003ACB  0bc0             or ax, ax
  003ACD  7543             jne 0x3b12
  003ACF  39065400         cmp word ptr [0x54], ax
  003AD3  740d             je 0x3ae2
  003AD5  0e               push cs
  003AD6  e823f1           call 0x2bfc
  003AD9  0bc0             or ax, ax
  003ADB  741d             je 0x3afa
  003ADD  8bc6             mov ax, si
  003ADF  5e               pop si
  003AE0  cb               retf
  003AE1  90               nop
  003AE2  9a7001f909       lcall 0x9f9, 0x170
  003AE7  0bc0             or ax, ax
  003AE9  740b             je 0x3af6
  003AEB  a1a404           mov ax, word ptr [0x4a4]
  003AEE  a36200           mov word ptr [0x62], ax
  003AF1  8bc6             mov ax, si
  003AF3  5e               pop si
  003AF4  cb               retf
  003AF5  90               nop
  003AF6  0e               push cs
  003AF7  e8bcdb           call 0x16b6
  003AFA  a1124b           mov ax, word ptr [0x4b12]
  003AFD  d1f8             sar ax, 1
  003AFF  a3c804           mov word ptr [0x4c8], ax
  003B02  a3524b           mov word ptr [0x4b52], ax
  003B05  a1144b           mov ax, word ptr [0x4b14]
  003B08  d1f8             sar ax, 1
  003B0A  a3ca04           mov word ptr [0x4ca], ax
  003B0D  a3544b           mov word ptr [0x4b54], ax
  003B10  2bf6             sub si, si
  003B12  8bc6             mov ax, si
  003B14  5e               pop si
  003B15  cb               retf

; ---- _viceroy_game  file 0x003B16..0x003DDE  seg 0x0:0x2516  (mapedit.obj) ----
  003B16  c8040000         enter 4, 0
  003B1A  57               push di
  003B1B  56               push si
  003B1C  6a00             push 0
  003B1E  68d007           push 0x7d0
  003B21  9a0a003403       lcall 0x334, 0xa
  003B26  83c404           add sp, 4
  003B29  9a7d011c0d       lcall 0xd1c, 0x17d
  003B2E  b81300           mov ax, 0x13
  003B31  9a0a003c0c       lcall 0xc3c, 0xa
  003B36  6a01             push 1
  003B38  6a13             push 0x13
  003B3A  9a0800c50e       lcall 0xec5, 8
  003B3F  83c404           add sp, 4
  003B42  6a13             push 0x13
  003B44  6a01             push 1
  003B46  9a8600650f       lcall 0xf65, 0x86
  003B4B  83c404           add sp, 4
  003B4E  9a0700650f       lcall 0xf65, 7
  003B53  9a7400750d       lcall 0xd75, 0x74
  003B58  6800a0           push 0xa000
  003B5B  6800fc           push 0xfc00
  003B5E  8d1e7003         lea bx, [0x370]
  003B62  9a0a00c00e       lcall 0xec0, 0xa
  003B67  0bc0             or ax, ax
  003B69  7409             je 0x3b74
  003B6B  c70662001300     mov word ptr [0x62], 0x13
  003B71  e93502           jmp 0x3da9
  003B74  8d1ef43a         lea bx, [0x3af4]
  003B78  b84001           mov ax, 0x140
  003B7B  bac800           mov dx, 0xc8
  003B7E  9a0a003e0c       lcall 0xc3e, 0xa
  003B83  a1fa3a           mov ax, word ptr [0x3afa]
  003B86  0b06f83a         or ax, word ptr [0x3af8]
  003B8A  750a             jne 0x3b96
  003B8C  c70662001400     mov word ptr [0x62], 0x14
  003B92  e91402           jmp 0x3da9
  003B95  90               nop
  003B96  8d1efc3a         lea bx, [0x3afc]
  003B9A  b84001           mov ax, 0x140
  003B9D  bac800           mov dx, 0xc8
  003BA0  9a0a003e0c       lcall 0xc3e, 0xa
  003BA5  a1023b           mov ax, word ptr [0x3b02]
  003BA8  0b06003b         or ax, word ptr [0x3b00]
  003BAC  74de             je 0x3b8c
  003BAE  9a0c00340c       lcall 0xc34, 0xc
  003BB3  ff36fa3a         push word ptr [0x3afa]
  003BB7  ff36f83a         push word ptr [0x3af8]
  003BBB  ff36f63a         push word ptr [0x3af6]
  003BBF  ff36f43a         push word ptr [0x3af4]
  003BC3  2ac0             sub al, al
  003BC5  9a0e00490c       lcall 0xc49, 0xe
  003BCA  68c800           push 0xc8
  003BCD  684001           push 0x140
  003BD0  6a00             push 0
  003BD2  6a00             push 0
  003BD4  6a00             push 0
  003BD6  6a00             push 0
  003BD8  1e               push ds
  003BD9  68f43a           push 0x3af4
  003BDC  9a2400c50e       lcall 0xec5, 0x24
  003BE1  83c410           add sp, 0x10
  003BE4  8d1e7c03         lea bx, [0x37c]
  003BE8  9a0a00430d       lcall 0xd43, 0xa
  003BED  a3963a           mov word ptr [0x3a96], ax
  003BF0  8916983a         mov word ptr [0x3a98], dx
  003BF4  8bc2             mov ax, dx
  003BF6  0b06963a         or ax, word ptr [0x3a96]
  003BFA  750a             jne 0x3c06
  003BFC  c70662001500     mov word ptr [0x62], 0x15
  003C02  e9a401           jmp 0x3da9
  003C05  90               nop
  003C06  8d1e8503         lea bx, [0x385]
  003C0A  9a0a00430d       lcall 0xd43, 0xa
  003C0F  a38000           mov word ptr [0x80], ax
  003C12  89168200         mov word ptr [0x82], dx
  003C16  8bc2             mov ax, dx
  003C18  0b068000         or ax, word ptr [0x80]
  003C1C  750a             jne 0x3c28
  003C1E  c70662001600     mov word ptr [0x62], 0x16
  003C24  e98201           jmp 0x3da9
  003C27  90               nop
  003C28  680008           push 0x800
  003C2B  ff36983a         push word ptr [0x3a98]
  003C2F  ff36963a         push word ptr [0x3a96]
  003C33  9a92303d03       lcall 0x33d, 0x3092
  003C38  83c406           add sp, 6
  003C3B  6800a0           push 0xa000
  003C3E  6800fc           push 0xfc00
  003C41  9a0a00700d       lcall 0xd70, 0xa
  003C46  9ac20bf908       lcall 0x8f9, 0xbc2
  003C4B  0bc0             or ax, ax
  003C4D  7403             je 0x3c52
  003C4F  e95701           jmp 0x3da9
  003C52  8d1e8e03         lea bx, [0x38e]
  003C56  b80040           mov ax, 0x4000
  003C59  9a0800db0d       lcall 0xddb, 8
  003C5E  a36400           mov word ptr [0x64], ax
  003C61  89166600         mov word ptr [0x66], dx
  003C65  8bc2             mov ax, dx
  003C67  0b066400         or ax, word ptr [0x64]
  003C6B  7509             jne 0x3c76
  003C6D  c70662001700     mov word ptr [0x62], 0x17
  003C73  e93301           jmp 0x3da9
  003C76  8d1e9503         lea bx, [0x395]
  003C7A  b80040           mov ax, 0x4000
  003C7D  9a0800db0d       lcall 0xddb, 8
  003C82  a3c004           mov word ptr [0x4c0], ax
  003C85  8916c204         mov word ptr [0x4c2], dx
  003C89  2bc0             sub ax, ax
  003C8B  a3c604           mov word ptr [0x4c6], ax
  003C8E  a3c404           mov word ptr [0x4c4], ax
  003C91  8bc2             mov ax, dx
  003C93  0b06c004         or ax, word ptr [0x4c0]
  003C97  7509             jne 0x3ca2
  003C99  c70662001800     mov word ptr [0x62], 0x18
  003C9F  e90701           jmp 0x3da9
  003CA2  a1c004           mov ax, word ptr [0x4c0]
  003CA5  a3c404           mov word ptr [0x4c4], ax
  003CA8  8916c604         mov word ptr [0x4c6], dx
  003CAC  8d1e9b03         lea bx, [0x39b]
  003CB0  b80040           mov ax, 0x4000
  003CB3  9a0800db0d       lcall 0xddb, 8
  003CB8  a36800           mov word ptr [0x68], ax
  003CBB  89166a00         mov word ptr [0x6a], dx
  003CBF  8bc2             mov ax, dx
  003CC1  0b066800         or ax, word ptr [0x68]
  003CC5  7509             jne 0x3cd0
  003CC7  c70662001900     mov word ptr [0x62], 0x19
  003CCD  e9d900           jmp 0x3da9
  003CD0  8d1efa49         lea bx, [0x49fa]
  003CD4  b82000           mov ax, 0x20
  003CD7  ba1800           mov dx, 0x18
  003CDA  9a0a003e0c       lcall 0xc3e, 0xa
  003CDF  a1004a           mov ax, word ptr [0x4a00]
  003CE2  0b06fe49         or ax, word ptr [0x49fe]
  003CE6  750a             jne 0x3cf2
  003CE8  c70662001a00     mov word ptr [0x62], 0x1a
  003CEE  e9b800           jmp 0x3da9
  003CF1  90               nop
  003CF2  8d1ea103         lea bx, [0x3a1]
  003CF6  b80040           mov ax, 0x4000
  003CF9  9a0800db0d       lcall 0xddb, 8
  003CFE  8bf0             mov si, ax
  003D00  8956fe           mov word ptr [bp - 2], dx
  003D03  0bd0             or dx, ax
  003D05  7509             jne 0x3d10
  003D07  c70662001b00     mov word ptr [0x62], 0x1b
  003D0D  e99900           jmp 0x3da9
  003D10  8b46fe           mov ax, word ptr [bp - 2]
  003D13  50               push ax
  003D14  56               push si
  003D15  6a00             push 0
  003D17  8bf8             mov di, ax
  003D19  b80100           mov ax, 1
  003D1C  8d1efa49         lea bx, [0x49fa]
  003D20  2bd2             sub dx, dx
  003D22  9a00008f0d       lcall 0xd8f, 0
  003D27  57               push di
  003D28  56               push si
  003D29  9a1003c90c       lcall 0xcc9, 0x310
  003D2E  b8fa49           mov ax, 0x49fa
  003D31  a36c05           mov word ptr [0x56c], ax
  003D34  a33206           mov word ptr [0x632], ax
  003D37  a39000           mov word ptr [0x90], ax
  003D3A  9a6c00560b       lcall 0xb56, 0x6c
  003D3F  0e               push cs
  003D40  e8f3fb           call 0x3936
  003D43  a09700           mov al, byte ptr [0x97]
  003D46  2ae4             sub ah, ah
  003D48  a32006           mov word ptr [0x620], ax
  003D4B  a31c06           mov word ptr [0x61c], ax
  003D4E  a09200           mov al, byte ptr [0x92]
  003D51  a32c06           mov word ptr [0x62c], ax
  003D54  a32606           mov word ptr [0x626], ax
  003D57  a09400           mov al, byte ptr [0x94]
  003D5A  a32e06           mov word ptr [0x62e], ax
  003D5D  a32806           mov word ptr [0x628], ax
  003D60  a09300           mov al, byte ptr [0x93]
  003D63  a33006           mov word ptr [0x630], ax
  003D66  a32a06           mov word ptr [0x62a], ax
  003D69  9a2801f909       lcall 0x9f9, 0x128
  003D6E  b8e02e           mov ax, 0x2ee0
  003D71  99               cdq
  003D72  9ae202c90c       lcall 0xcc9, 0x2e2
  003D77  a35a00           mov word ptr [0x5a], ax
  003D7A  89165c00         mov word ptr [0x5c], dx
  003D7E  8bc2             mov ax, dx
  003D80  0b065a00         or ax, word ptr [0x5a]
  003D84  7406             je 0x3d8c
  003D86  c70650000100     mov word ptr [0x50], 1
  003D8C  0e               push cs
  003D8D  e8eafc           call 0x3a7a
  003D90  0bc0             or ax, ax
  003D92  7515             jne 0x3da9
  003D94  6800a0           push 0xa000
  003D97  6800fc           push 0xfc00
  003D9A  9a0a00700d       lcall 0xd70, 0xa
  003D9F  c7066e5e0100     mov word ptr [0x5e6e], 1
  003DA5  0e               push cs
  003DA6  e807fb           call 0x38b0
  003DA9  9a4e00650f       lcall 0xf65, 0x4e
  003DAE  8b36c649         mov si, word ptr [0x49c6]
  003DB2  6a03             push 3
  003DB4  6a00             push 0
  003DB6  9a8600650f       lcall 0xf65, 0x86
  003DBB  83c404           add sp, 4
  003DBE  83fe03           cmp si, 3
  003DC1  7405             je 0x3dc8
  003DC3  b80100           mov ax, 1
  003DC6  eb02             jmp 0x3dca
  003DC8  2bc0             sub ax, ax
  003DCA  50               push ax
  003DCB  6a03             push 3
  003DCD  9a0800c50e       lcall 0xec5, 8
  003DD2  83c404           add sp, 4
  003DD5  9af3011c0d       lcall 0xd1c, 0x1f3
  003DDA  5e               pop si
  003DDB  5f               pop di
  003DDC  c9               leave
  003DDD  cb               retf

; ---- _show_logo  file 0x003DDE..0x003DF6  seg 0x0:0x27de  (mapedit.obj) ----
  003DDE  68aa03           push 0x3aa
  003DE1  9aa8058813       lcall 0x1388, 0x5a8
  003DE6  83c402           add sp, 2
  003DE9  68c303           push 0x3c3
  003DEC  9aa8058813       lcall 0x1388, 0x5a8
  003DF1  83c402           add sp, 2
  003DF4  cb               retf
  003DF5  90               nop

; ---- _show_flags  file 0x003DF6..0x003E28  seg 0x0:0x27f6  (mapedit.obj) ----
  003DF6  0e               push cs
  003DF7  e8e4ff           call 0x3dde
  003DFA  68ef03           push 0x3ef
  003DFD  9aa8058813       lcall 0x1388, 0x5a8
  003E02  83c402           add sp, 2
  003E05  68f903           push 0x3f9
  003E08  9aa8058813       lcall 0x1388, 0x5a8
  003E0D  83c402           add sp, 2
  003E10  682704           push 0x427
  003E13  9aa8058813       lcall 0x1388, 0x5a8
  003E18  83c402           add sp, 2
  003E1B  685804           push 0x458
  003E1E  9aa8058813       lcall 0x1388, 0x5a8
  003E23  83c402           add sp, 2
  003E26  cb               retf
  003E27  90               nop

; ---- @scan_past  file 0x003E28..0x003E72  seg 0x0:0x2828  (mapedit.obj) ----
  003E28  c8040000         enter 4, 0
  003E2C  50               push ax
  003E2D  56               push si
  003E2E  2bd2             sub dx, dx
  003E30  8b37             mov si, word ptr [bx]
  003E32  803c00           cmp byte ptr [si], 0
  003E35  7505             jne 0x3e3c
  003E37  8bf3             mov si, bx
  003E39  eb15             jmp 0x3e50
  003E3B  90               nop
  003E3C  8bf3             mov si, bx
  003E3E  8a46fa           mov al, byte ptr [bp - 6]
  003E41  8b1c             mov bx, word ptr [si]
  003E43  3807             cmp byte ptr [bx], al
  003E45  7409             je 0x3e50
  003E47  ff04             inc word ptr [si]
  003E49  8b1c             mov bx, word ptr [si]
  003E4B  803f00           cmp byte ptr [bx], 0
  003E4E  75ee             jne 0x3e3e
  003E50  807efa00         cmp byte ptr [bp - 6], 0
  003E54  740e             je 0x3e64
  003E56  8a46fa           mov al, byte ptr [bp - 6]
  003E59  8b1c             mov bx, word ptr [si]
  003E5B  3807             cmp byte ptr [bx], al
  003E5D  7505             jne 0x3e64
  003E5F  ff04             inc word ptr [si]
  003E61  ba0100           mov dx, 1
  003E64  8b1c             mov bx, word ptr [si]
  003E66  803f00           cmp byte ptr [bx], 0
  003E69  7502             jne 0x3e6d
  003E6B  ff0c             dec word ptr [si]
  003E6D  8bc2             mov ax, dx
  003E6F  5e               pop si
  003E70  c9               leave
  003E71  cb               retf

; ---- _flag_parse  file 0x003E72..0x003ED8  seg 0x0:0x2872  (mapedit.obj) ----
  003E72  c8020000         enter 2, 0
  003E76  56               push si
  003E77  8b7606           mov si, word ptr [bp + 6]
  003E7A  8b1c             mov bx, word ptr [si]
  003E7C  8a07             mov al, byte ptr [bx]
  003E7E  98               cwde
  003E7F  8bd8             mov bx, ax
  003E81  895efe           mov word ptr [bp - 2], bx
  003E84  f687a94502       test byte ptr [bx + 0x45a9], 2
  003E89  7407             je 0x3e92
  003E8B  8bd0             mov dx, ax
  003E8D  83ea20           sub dx, 0x20
  003E90  eb02             jmp 0x3e94
  003E92  8bd3             mov dx, bx
  003E94  8bc2             mov ax, dx
  003E96  2d4300           sub ax, 0x43
  003E99  7409             je 0x3ea4
  003E9B  2d0a00           sub ax, 0xa
  003E9E  740e             je 0x3eae
  003EA0  5e               pop si
  003EA1  c9               leave
  003EA2  cb               retf
  003EA3  90               nop
  003EA4  c70654000100     mov word ptr [0x54], 1
  003EAA  5e               pop si
  003EAB  c9               leave
  003EAC  cb               retf
  003EAD  90               nop
  003EAE  8bde             mov bx, si
  003EB0  b03a             mov al, 0x3a
  003EB2  0e               push cs
  003EB3  e872ff           call 0x3e28
  003EB6  0bc0             or ax, ax
  003EB8  7415             je 0x3ecf
  003EBA  ff34             push word ptr [si]
  003EBC  68184a           push 0x4a18
  003EBF  9a26068813       lcall 0x1388, 0x626
  003EC4  83c404           add sp, 4
  003EC7  8bde             mov bx, si
  003EC9  2ac0             sub al, al
  003ECB  0e               push cs
  003ECC  e859ff           call 0x3e28
  003ECF  c7064c000100     mov word ptr [0x4c], 1
  003ED5  5e               pop si
  003ED6  c9               leave
  003ED7  cb               retf

; ---- _main  file 0x003ED8..0x003F7C  seg 0x0:0x28d8  (mapedit.obj) ----
  003ED8  c8060000         enter 6, 0
  003EDC  57               push di
  003EDD  56               push si
  003EDE  c7066a3c0100     mov word ptr [0x3c6a], 1
  003EE4  9a0e00160f       lcall 0xf16, 0xe
  003EE9  9a5a003e0f       lcall 0xf3e, 0x5a
  003EEE  2bc0             sub ax, ax
  003EF0  a34200           mov word ptr [0x42], ax
  003EF3  a34400           mov word ptr [0x44], ax
  003EF6  bf0100           mov di, 1
  003EF9  397e06           cmp word ptr [bp + 6], di
  003EFC  7e5a             jle 0x3f58
  003EFE  8b7608           mov si, word ptr [bp + 8]
  003F01  46               inc si
  003F02  46               inc si
  003F03  8b1c             mov bx, word ptr [si]
  003F05  8a07             mov al, byte ptr [bx]
  003F07  98               cwde
  003F08  50               push ax
  003F09  688404           push 0x484
  003F0C  9ae8098813       lcall 0x1388, 0x9e8
  003F11  83c404           add sp, 4
  003F14  0bc0             or ax, ax
  003F16  7428             je 0x3f40
  003F18  8b1c             mov bx, word ptr [si]
  003F1A  895efa           mov word ptr [bp - 6], bx
  003F1D  803f00           cmp byte ptr [bx], 0
  003F20  7425             je 0x3f47
  003F22  897efc           mov word ptr [bp - 4], di
  003F25  8976fe           mov word ptr [bp - 2], si
  003F28  8d46fa           lea ax, [bp - 6]
  003F2B  50               push ax
  003F2C  0e               push cs
  003F2D  e842ff           call 0x3e72
  003F30  83c402           add sp, 2
  003F33  ff46fa           inc word ptr [bp - 6]
  003F36  8b5efa           mov bx, word ptr [bp - 6]
  003F39  803f00           cmp byte ptr [bx], 0
  003F3C  75ea             jne 0x3f28
  003F3E  eb07             jmp 0x3f47
  003F40  8b1c             mov bx, word ptr [si]
  003F42  803f3f           cmp byte ptr [bx], 0x3f
  003F45  740b             je 0x3f52
  003F47  46               inc si
  003F48  46               inc si
  003F49  47               inc di
  003F4A  397e06           cmp word ptr [bp + 6], di
  003F4D  7fb4             jg 0x3f03
  003F4F  eb07             jmp 0x3f58
  003F51  90               nop
  003F52  0e               push cs
  003F53  e8a0fe           call 0x3df6
  003F56  eb04             jmp 0x3f5c
  003F58  0e               push cs
  003F59  e8bafb           call 0x3b16
  003F5C  9a0c003e0f       lcall 0xf3e, 0xc
  003F61  833e620000       cmp word ptr [0x62], 0
  003F66  740f             je 0x3f77
  003F68  ff366200         push word ptr [0x62]
  003F6C  688704           push 0x487
  003F6F  9aa8058813       lcall 0x1388, 0x5a8
  003F74  83c404           add sp, 4
  003F77  5e               pop si
  003F78  5f               pop di
  003F79  c9               leave
  003F7A  cb               retf
  003F7B  90               nop
