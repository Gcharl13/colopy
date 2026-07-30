; MAPEDIT.EXE named disasm — module pack_5.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @pack_raw_copy  file 0x013628..0x0136A6  seg 0x1202:0x8  (pack_5.c.obj) ----
  013628  c8020000         enter 2, 0
  01362C  57               push di
  01362D  56               push si
  01362E  2bf6             sub si, si
  013630  39369252         cmp word ptr [0x5292], si
  013634  7c69             jl 0x1369f
  013636  7f06             jg 0x1363e
  013638  39369052         cmp word ptr [0x5290], si
  01363C  7461             je 0x1369f
  01363E  0bf6             or si, si
  013640  755d             jne 0x1369f
  013642  a12860           mov ax, word ptr [0x6028]
  013645  2bd2             sub dx, dx
  013647  3b169252         cmp dx, word ptr [0x5292]
  01364B  7c0f             jl 0x1365c
  01364D  7f06             jg 0x13655
  01364F  3b069052         cmp ax, word ptr [0x5290]
  013653  7607             jbe 0x1365c
  013655  8b169252         mov dx, word ptr [0x5292]
  013659  a19052           mov ax, word ptr [0x5290]
  01365C  8946fe           mov word ptr [bp - 2], ax
  01365F  ff36a64e         push word ptr [0x4ea6]
  013663  ff36a44e         push word ptr [0x4ea4]
  013667  8d46fe           lea ax, [bp - 2]
  01366A  16               push ss
  01366B  50               push ax
  01366C  ff1e4260         lcall [0x6042]
  013670  8bf8             mov di, ax
  013672  3b7efe           cmp di, word ptr [bp - 2]
  013675  7407             je 0x1367e
  013677  be0400           mov si, 4
  01367A  eb13             jmp 0x1368f
  01367C  90               nop
  01367D  90               nop
  01367E  ff36a64e         push word ptr [0x4ea6]
  013682  ff36a44e         push word ptr [0x4ea4]
  013686  8d46fe           lea ax, [bp - 2]
  013689  16               push ss
  01368A  50               push ax
  01368B  ff1ee864         lcall [0x64e8]
  01368F  833e925200       cmp word ptr [0x5292], 0
  013694  7fa8             jg 0x1363e
  013696  7c07             jl 0x1369f
  013698  833e905200       cmp word ptr [0x5290], 0
  01369D  759f             jne 0x1363e
  01369F  8bc6             mov ax, si
  0136A1  5e               pop si
  0136A2  5f               pop di
  0136A3  c9               leave
  0136A4  cb               retf
  0136A5  90               nop

; ---- @pack_a_packet  file 0x0136A6..0x0137A0  seg 0x1202:0x86  (pack_5.c.obj) ----
  0136A6  c8020000         enter 2, 0
  0136AA  52               push dx
  0136AB  50               push ax
  0136AC  8bc8             mov cx, ax
  0136AE  0bc0             or ax, ax
  0136B0  740a             je 0x136bc
  0136B2  48               dec ax
  0136B3  7463             je 0x13718
  0136B5  0e               push cs
  0136B6  e86fff           call 0x13628
  0136B9  e9e200           jmp 0x1379e
  0136BC  c746fe0010       mov word ptr [bp - 2], 0x1000
  0136C1  833e8c4401       cmp word ptr [0x448c], 1
  0136C6  7528             jne 0x136f0
  0136C8  ff364460         push word ptr [0x6044]
  0136CC  ff364260         push word ptr [0x6042]
  0136D0  ff36ea64         push word ptr [0x64ea]
  0136D4  ff36e864         push word ptr [0x64e8]
  0136D8  ff36a64e         push word ptr [0x4ea6]
  0136DC  ff36a44e         push word ptr [0x4ea4]
  0136E0  1e               push ds
  0136E1  688844           push 0x4488
  0136E4  8d46fe           lea ax, [bp - 2]
  0136E7  16               push ss
  0136E8  50               push ax
  0136E9  ff1e9644         lcall [0x4496]
  0136ED  c9               leave
  0136EE  cb               retf
  0136EF  90               nop
  0136F0  ff364460         push word ptr [0x6044]
  0136F4  ff364260         push word ptr [0x6042]
  0136F8  ff36ea64         push word ptr [0x64ea]
  0136FC  ff36e864         push word ptr [0x64e8]
  013700  ff36a64e         push word ptr [0x4ea6]
  013704  ff36a44e         push word ptr [0x4ea4]
  013708  1e               push ds
  013709  688844           push 0x4488
  01370C  8d46fe           lea ax, [bp - 2]
  01370F  16               push ss
  013710  50               push ax
  013711  ff1e8e44         lcall [0x448e]
  013715  c9               leave
  013716  cb               retf
  013717  90               nop
  013718  833e8c4401       cmp word ptr [0x448c], 1
  01371D  7563             jne 0x13782
  01371F  8bc2             mov ax, dx
  013721  48               dec ax
  013722  7422             je 0x13746
  013724  48               dec ax
  013725  743d             je 0x13764
  013727  ff364460         push word ptr [0x6044]
  01372B  ff364260         push word ptr [0x6042]
  01372F  ff36ea64         push word ptr [0x64ea]
  013733  ff36e864         push word ptr [0x64e8]
  013737  ff36a64e         push word ptr [0x4ea6]
  01373B  ff36a44e         push word ptr [0x4ea4]
  01373F  ff1e9a44         lcall [0x449a]
  013743  c9               leave
  013744  cb               retf
  013745  90               nop
  013746  ff364460         push word ptr [0x6044]
  01374A  ff364260         push word ptr [0x6042]
  01374E  ff36a05a         push word ptr [0x5aa0]
  013752  ff369e5a         push word ptr [0x5a9e]
  013756  ff36a64e         push word ptr [0x4ea6]
  01375A  ff36a44e         push word ptr [0x4ea4]
  01375E  ff1e9e44         lcall [0x449e]
  013762  c9               leave
  013763  cb               retf
  013764  ff364a63         push word ptr [0x634a]
  013768  ff364863         push word ptr [0x6348]
  01376C  ff36a05a         push word ptr [0x5aa0]
  013770  ff369e5a         push word ptr [0x5a9e]
  013774  ff36a64e         push word ptr [0x4ea6]
  013778  ff36a44e         push word ptr [0x4ea4]
  01377C  ff1ea244         lcall [0x44a2]
  013780  c9               leave
  013781  cb               retf
  013782  ff364460         push word ptr [0x6044]
  013786  ff364260         push word ptr [0x6042]
  01378A  ff36ea64         push word ptr [0x64ea]
  01378E  ff36e864         push word ptr [0x64e8]
  013792  ff36a64e         push word ptr [0x4ea6]
  013796  ff36a44e         push word ptr [0x4ea4]
  01379A  ff1e9244         lcall [0x4492]
  01379E  c9               leave
  01379F  cb               retf
