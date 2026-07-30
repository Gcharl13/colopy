; MAPEDIT.EXE named disasm — module dos_crt0msg.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __acrtmsg  file 0x00AE76..0x00B09E  seg 0x0:0x9876  (dos_crt0msg.asm.obj) ----
  00AE76  07               pop es
  00AE77  d7               xlatb
  00AE78  06               push es
  00AE79  83c40c           add sp, 0xc
  00AE7C  6a00             push 0
  00AE7E  1e               push ds
  00AE7F  68a206           push 0x6a2
  00AE82  6a06             push 6
  00AE84  ff367a00         push word ptr [0x7a]
  00AE88  ff367800         push word ptr [0x78]
  00AE8C  9ade07d706       lcall 0x6d7, 0x7de
  00AE91  83c40c           add sp, 0xc
  00AE94  6a67             push 0x67
  00AE96  9a06014208       lcall 0x842, 0x106
  00AE9B  1e               push ds
  00AE9C  50               push ax
  00AE9D  6a06             push 6
  00AE9F  ff367a00         push word ptr [0x7a]
  00AEA3  ff367800         push word ptr [0x78]
  00AEA7  9ade07d706       lcall 0x6d7, 0x7de
  00AEAC  83c40c           add sp, 0xc
  00AEAF  6a68             push 0x68
  00AEB1  9a06014208       lcall 0x842, 0x106
  00AEB6  1e               push ds
  00AEB7  50               push ax
  00AEB8  6a06             push 6
  00AEBA  ff367a00         push word ptr [0x7a]
  00AEBE  ff367800         push word ptr [0x78]
  00AEC2  9ade07d706       lcall 0x6d7, 0x7de
  00AEC7  83c40c           add sp, 0xc
  00AECA  6a00             push 0
  00AECC  1e               push ds
  00AECD  68a306           push 0x6a3
  00AED0  6a06             push 6
  00AED2  ff367a00         push word ptr [0x7a]
  00AED6  ff367800         push word ptr [0x78]
  00AEDA  9ade07d706       lcall 0x6d7, 0x7de
  00AEDF  83c40c           add sp, 0xc
  00AEE2  6a69             push 0x69
  00AEE4  9a06014208       lcall 0x842, 0x106
  00AEE9  1e               push ds
  00AEEA  50               push ax
  00AEEB  6a06             push 6
  00AEED  ff367a00         push word ptr [0x7a]
  00AEF1  ff367800         push word ptr [0x78]
  00AEF5  9ade07d706       lcall 0x6d7, 0x7de
  00AEFA  83c40c           add sp, 0xc
  00AEFD  8bf8             mov di, ax
  00AEFF  8956fe           mov word ptr [bp - 2], dx
  00AF02  6a6a             push 0x6a
  00AF04  9a06014208       lcall 0x842, 0x106
  00AF09  1e               push ds
  00AF0A  50               push ax
  00AF0B  6a06             push 6
  00AF0D  ff367a00         push word ptr [0x7a]
  00AF11  ff367800         push word ptr [0x78]
  00AF15  9ade07d706       lcall 0x6d7, 0x7de
  00AF1A  83c40c           add sp, 0xc
  00AF1D  6a00             push 0
  00AF1F  1e               push ds
  00AF20  68a406           push 0x6a4
  00AF23  6a06             push 6
  00AF25  ff367a00         push word ptr [0x7a]
  00AF29  ff367800         push word ptr [0x78]
  00AF2D  9ade07d706       lcall 0x6d7, 0x7de
  00AF32  83c40c           add sp, 0xc
  00AF35  6a6b             push 0x6b
  00AF37  9a06014208       lcall 0x842, 0x106
  00AF3C  1e               push ds
  00AF3D  50               push ax
  00AF3E  6a06             push 6
  00AF40  ff367a00         push word ptr [0x7a]
  00AF44  ff367800         push word ptr [0x78]
  00AF48  9ade07d706       lcall 0x6d7, 0x7de
  00AF4D  83c40c           add sp, 0xc
  00AF50  6a6c             push 0x6c
  00AF52  9a06014208       lcall 0x842, 0x106
  00AF57  1e               push ds
  00AF58  50               push ax
  00AF59  6a06             push 6
  00AF5B  ff367a00         push word ptr [0x7a]
  00AF5F  ff367800         push word ptr [0x78]
  00AF63  9ade07d706       lcall 0x6d7, 0x7de
  00AF68  83c40c           add sp, 0xc
  00AF6B  6a6f             push 0x6f
  00AF6D  9a06014208       lcall 0x842, 0x106
  00AF72  1e               push ds
  00AF73  50               push ax
  00AF74  6a06             push 6
  00AF76  ff367a00         push word ptr [0x7a]
  00AF7A  ff367800         push word ptr [0x78]
  00AF7E  9ade07d706       lcall 0x6d7, 0x7de
  00AF83  83c40c           add sp, 0xc
  00AF86  8e46fe           mov es, word ptr [bp - 2]
  00AF89  26c745021300     mov word ptr es:[di + 2], 0x13
  00AF8F  f6062f5e20       test byte ptr [0x5e2f], 0x20
  00AF94  7513             jne 0xafa9
  00AF96  56               push si
  00AF97  6a06             push 6
  00AF99  ff367a00         push word ptr [0x7a]
  00AF9D  ff367800         push word ptr [0x78]
  00AFA1  9a2205d706       lcall 0x6d7, 0x522
  00AFA6  83c408           add sp, 8
  00AFA9  68a506           push 0x6a5
  00AFAC  6a00             push 0
  00AFAE  9a1a004208       lcall 0x842, 0x1a
  00AFB3  83c404           add sp, 4
  00AFB6  0bc0             or ax, ax
  00AFB8  7403             je 0xafbd
  00AFBA  e9d600           jmp 0xb093
  00AFBD  56               push si
  00AFBE  6a07             push 7
  00AFC0  9a06014208       lcall 0x842, 0x106
  00AFC5  1e               push ds
  00AFC6  50               push ax
  00AFC7  ff367a00         push word ptr [0x7a]
  00AFCB  ff367800         push word ptr [0x78]
  00AFCF  9a4206d706       lcall 0x6d7, 0x642
  00AFD4  83c40c           add sp, 0xc
  00AFD7  6a70             push 0x70
  00AFD9  9a06014208       lcall 0x842, 0x106
  00AFDE  1e               push ds
  00AFDF  50               push ax
  00AFE0  6a07             push 7
  00AFE2  ff367a00         push word ptr [0x7a]
  00AFE6  ff367800         push word ptr [0x78]
  00AFEA  9ade07d706       lcall 0x6d7, 0x7de
  00AFEF  83c40c           add sp, 0xc
  00AFF2  6a71             push 0x71
  00AFF4  9a06014208       lcall 0x842, 0x106
  00AFF9  1e               push ds
  00AFFA  50               push ax
  00AFFB  6a07             push 7
  00AFFD  ff367a00         push word ptr [0x7a]
  00B001  ff367800         push word ptr [0x78]
  00B005  9ade07d706       lcall 0x6d7, 0x7de
  00B00A  83c40c           add sp, 0xc
  00B00D  6a72             push 0x72
  00B00F  9a06014208       lcall 0x842, 0x106
  00B014  1e               push ds
  00B015  50               push ax
  00B016  6a07             push 7
  00B018  ff367a00         push word ptr [0x7a]
  00B01C  ff367800         push word ptr [0x78]
  00B020  9ade07d706       lcall 0x6d7, 0x7de
  00B025  83c40c           add sp, 0xc
  00B028  6a00             push 0
  00B02A  1e               push ds
  00B02B  68ab06           push 0x6ab
  00B02E  6a07             push 7
  00B030  ff367a00         push word ptr [0x7a]
  00B034  ff367800         push word ptr [0x78]
  00B038  9ade07d706       lcall 0x6d7, 0x7de
  00B03D  83c40c           add sp, 0xc
  00B040  6a73             push 0x73
  00B042  9a06014208       lcall 0x842, 0x106
  00B047  1e               push ds
  00B048  50               push ax
  00B049  6a07             push 7
  00B04B  ff367a00         push word ptr [0x7a]
  00B04F  ff367800         push word ptr [0x78]
  00B053  9ade07d706       lcall 0x6d7, 0x7de
  00B058  83c40c           add sp, 0xc
  00B05B  6a74             push 0x74
  00B05D  9a06014208       lcall 0x842, 0x106
  00B062  1e               push ds
  00B063  50               push ax
  00B064  6a07             push 7
  00B066  ff367a00         push word ptr [0x7a]
  00B06A  ff367800         push word ptr [0x78]
  00B06E  9ade07d706       lcall 0x6d7, 0x7de
  00B073  83c40c           add sp, 0xc
  00B076  6a75             push 0x75
  00B078  9a06014208       lcall 0x842, 0x106
  00B07D  1e               push ds
  00B07E  50               push ax
  00B07F  6a07             push 7
  00B081  ff367a00         push word ptr [0x7a]
  00B085  ff367800         push word ptr [0x78]
  00B089  9ade07d706       lcall 0x6d7, 0x7de
  00B08E  83c40c           add sp, 0xc
  00B091  2bf6             sub si, si
  00B093  9a00004208       lcall 0x842, 0
  00B098  8bc6             mov ax, si
  00B09A  5e               pop si
  00B09B  5f               pop di
  00B09C  c9               leave
  00B09D  cb               retf

; ---- __FF_MSGBANNER  file 0x015DFA..0x015E1C  seg 0x1388:0xf7a  (dos_crt0msg.asm.obj) ----
  015DFA  55               push bp
  015DFB  8bec             mov bp, sp
  015DFD  b8fc00           mov ax, 0xfc
  015E00  50               push ax
  015E01  0e               push cs
  015E02  e87c02           call 0x16081
  015E05  833eac4600       cmp word ptr [0x46ac], 0
  015E0A  7404             je 0x15e10
  015E0C  ff1eaa46         lcall [0x46aa]
  015E10  b8ff00           mov ax, 0xff
  015E13  50               push ax
  015E14  0e               push cs
  015E15  e86902           call 0x16081
  015E18  8be5             mov sp, bp
  015E1A  5d               pop bp
  015E1B  cb               retf
