; MAPEDIT.EXE named disasm — module me_mini.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _get_a_color  file 0x00CB64..0x00CB98  seg 0xB56:0x4  (me_mini.obj) ----
  00CB64  c8080100         enter 0x108, 0
  00CB68  b81000           mov ax, 0x10
  00CB6B  8946f8           mov word ptr [bp - 8], ax
  00CB6E  8946fa           mov word ptr [bp - 6], ax
  00CB71  8d86f8fe         lea ax, [bp - 0x108]
  00CB75  8946fc           mov word ptr [bp - 4], ax
  00CB78  8c56fe           mov word ptr [bp - 2], ss
  00CB7B  ff36c204         push word ptr [0x4c2]
  00CB7F  ff36c004         push word ptr [0x4c0]
  00CB83  6a00             push 0
  00CB85  8b4606           mov ax, word ptr [bp + 6]
  00CB88  8d5ef8           lea bx, [bp - 8]
  00CB8B  2bd2             sub dx, dx
  00CB8D  9a00008f0d       lcall 0xd8f, 0
  00CB92  8a4680           mov al, byte ptr [bp - 0x80]
  00CB95  c9               leave
  00CB96  cb               retf
  00CB97  90               nop

; ---- _get_a_color_2  file 0x00CB98..0x00CBCC  seg 0xB56:0x38  (me_mini.obj) ----
  00CB98  c8080100         enter 0x108, 0
  00CB9C  b81000           mov ax, 0x10
  00CB9F  8946f8           mov word ptr [bp - 8], ax
  00CBA2  8946fa           mov word ptr [bp - 6], ax
  00CBA5  8d86f8fe         lea ax, [bp - 0x108]
  00CBA9  8946fc           mov word ptr [bp - 4], ax
  00CBAC  8c56fe           mov word ptr [bp - 2], ss
  00CBAF  6a00             push 0
  00CBB1  6a00             push 0
  00CBB3  8d46f8           lea ax, [bp - 8]
  00CBB6  50               push ax
  00CBB7  ff7606           push word ptr [bp + 6]
  00CBBA  ff36ba04         push word ptr [0x4ba]
  00CBBE  ff36b804         push word ptr [0x4b8]
  00CBC2  9a48000b03       lcall 0x30b, 0x48
  00CBC7  8a4680           mov al, byte ptr [bp - 0x80]
  00CBCA  c9               leave
  00CBCB  cb               retf

; ---- _get_tile_colors  file 0x00CBCC..0x00CC38  seg 0xB56:0x6c  (me_mini.obj) ----
  00CBCC  56               push si
  00CBCD  2bf6             sub si, si
  00CBCF  56               push si
  00CBD0  0e               push cs
  00CBD1  e8c4ff           call 0xcb98
  00CBD4  83c402           add sp, 2
  00CBD7  8884ec4a         mov byte ptr [si + 0x4aec], al
  00CBDB  56               push si
  00CBDC  0e               push cs
  00CBDD  e8b8ff           call 0xcb98
  00CBE0  83c402           add sp, 2
  00CBE3  8884fc4a         mov byte ptr [si + 0x4afc], al
  00CBE7  56               push si
  00CBE8  0e               push cs
  00CBE9  e8acff           call 0xcb98
  00CBEC  83c402           add sp, 2
  00CBEF  8884f44a         mov byte ptr [si + 0x4af4], al
  00CBF3  46               inc si
  00CBF4  83fe08           cmp si, 8
  00CBF7  7cd6             jl 0xcbcf
  00CBF9  6a18             push 0x18
  00CBFB  0e               push cs
  00CBFC  e899ff           call 0xcb98
  00CBFF  83c402           add sp, 2
  00CC02  a2044b           mov byte ptr [0x4b04], al
  00CC05  6a19             push 0x19
  00CC07  0e               push cs
  00CC08  e88dff           call 0xcb98
  00CC0B  83c402           add sp, 2
  00CC0E  a2054b           mov byte ptr [0x4b05], al
  00CC11  6a1a             push 0x1a
  00CC13  0e               push cs
  00CC14  e881ff           call 0xcb98
  00CC17  83c402           add sp, 2
  00CC1A  a2064b           mov byte ptr [0x4b06], al
  00CC1D  6a21             push 0x21
  00CC1F  0e               push cs
  00CC20  e841ff           call 0xcb64
  00CC23  83c402           add sp, 2
  00CC26  a2074b           mov byte ptr [0x4b07], al
  00CC29  6a31             push 0x31
  00CC2B  0e               push cs
  00CC2C  e835ff           call 0xcb64
  00CC2F  83c402           add sp, 2
  00CC32  a2084b           mov byte ptr [0x4b08], al
  00CC35  5e               pop si
  00CC36  cb               retf
  00CC37  90               nop

; ---- _allocate_mini  file 0x00CC38..0x00CC3C  seg 0xB56:0xd8  (me_mini.obj) ----
  00CC38  2bc0             sub ax, ax
  00CC3A  cb               retf
  00CC3B  90               nop

; ---- _generate_mini  file 0x00CC3C..0x00CC7C  seg 0xB56:0xdc  (me_mini.obj) ----
  00CC3C  a1ca04           mov ax, word ptr [0x4ca]
  00CC3F  2d1300           sub ax, 0x13
  00CC42  a3c249           mov word ptr [0x49c2], ax
  00CC45  a1124b           mov ax, word ptr [0x4b12]
  00CC48  2d3900           sub ax, 0x39
  00CC4B  50               push ax
  00CC4C  6a01             push 1
  00CC4E  a1c804           mov ax, word ptr [0x4c8]
  00CC51  2d1c00           sub ax, 0x1c
  00CC54  a38269           mov word ptr [0x6982], ax
  00CC57  50               push ax
  00CC58  9a0e006508       lcall 0x865, 0xe
  00CC5D  83c406           add sp, 6
  00CC60  a38269           mov word ptr [0x6982], ax
  00CC63  a1144b           mov ax, word ptr [0x4b14]
  00CC66  2d2800           sub ax, 0x28
  00CC69  50               push ax
  00CC6A  6a01             push 1
  00CC6C  ff36c249         push word ptr [0x49c2]
  00CC70  9a0e006508       lcall 0x865, 0xe
  00CC75  83c406           add sp, 6
  00CC78  a3c249           mov word ptr [0x49c2], ax
  00CC7B  cb               retf

; ---- _blast_mini_region  file 0x00CC7C..0x00CDD4  seg 0xB56:0x11c  (me_mini.obj) ----
  00CC7C  c83a0000         enter 0x3a, 0
  00CC80  57               push di
  00CC81  56               push si
  00CC82  8b560e           mov dx, word ptr [bp + 0xe]
  00CC85  0bd2             or dx, dx
  00CC87  7c0d             jl 0xcc96
  00CC89  8bca             mov cx, dx
  00CC8B  b81000           mov ax, 0x10
  00CC8E  d3e0             shl ax, cl
  00CC90  8946e4           mov word ptr [bp - 0x1c], ax
  00CC93  eb06             jmp 0xcc9b
  00CC95  90               nop
  00CC96  c746e40000       mov word ptr [bp - 0x1c], 0
  00CC9B  8b7606           mov si, word ptr [bp + 6]
  00CC9E  8b7e08           mov di, word ptr [bp + 8]
  00CCA1  57               push di
  00CCA2  56               push si
  00CCA3  9afa00ab02       lcall 0x2ab, 0xfa
  00CCA8  83c404           add sp, 4
  00CCAB  8946d8           mov word ptr [bp - 0x28], ax
  00CCAE  8956da           mov word ptr [bp - 0x26], dx
  00CCB1  57               push di
  00CCB2  56               push si
  00CCB3  9a2e01ab02       lcall 0x2ab, 0x12e
  00CCB8  83c404           add sp, 4
  00CCBB  57               push di
  00CCBC  56               push si
  00CCBD  9ae402ab02       lcall 0x2ab, 0x2e4
  00CCC2  83c404           add sp, 4
  00CCC5  8946d4           mov word ptr [bp - 0x2c], ax
  00CCC8  8956d6           mov word ptr [bp - 0x2a], dx
  00CCCB  57               push di
  00CCCC  56               push si
  00CCCD  9a9801ab02       lcall 0x2ab, 0x198
  00CCD2  83c404           add sp, 4
  00CCD5  8bc6             mov ax, si
  00CCD7  2b068269         sub ax, word ptr [0x6982]
  00CCDB  05fc00           add ax, 0xfc
  00CCDE  8bd7             mov dx, di
  00CCE0  2b16c249         sub dx, word ptr [0x49c2]
  00CCE4  83c209           add dx, 9
  00CCE7  8d1ef43a         lea bx, [0x3af4]
  00CCEB  9a0000910c       lcall 0xc91, 0
  00CCF0  8946d0           mov word ptr [bp - 0x30], ax
  00CCF3  8956d2           mov word ptr [bp - 0x2e], dx
  00CCF6  a1124b           mov ax, word ptr [0x4b12]
  00CCF9  8946e0           mov word ptr [bp - 0x20], ax
  00CCFC  a1f63a           mov ax, word ptr [0x3af6]
  00CCFF  8946dc           mov word ptr [bp - 0x24], ax
  00CD02  837e0c00         cmp word ptr [bp + 0xc], 0
  00CD06  7f03             jg 0xcd0b
  00CD08  e9c500           jmp 0xcdd0
  00CD0B  8b5e0a           mov bx, word ptr [bp + 0xa]
  00CD0E  8b460c           mov ax, word ptr [bp + 0xc]
  00CD11  8946de           mov word ptr [bp - 0x22], ax
  00CD14  0bdb             or bx, bx
  00CD16  7f06             jg 0xcd1e
  00CD18  8b76d8           mov si, word ptr [bp - 0x28]
  00CD1B  e99000           jmp 0xcdae
  00CD1E  8bc3             mov ax, bx
  00CD20  8946fc           mov word ptr [bp - 4], ax
  00CD23  8b76d8           mov si, word ptr [bp - 0x28]
  00CD26  8b7ed4           mov di, word ptr [bp - 0x2c]
  00CD29  8b4ed0           mov cx, word ptr [bp - 0x30]
  00CD2C  8e5eda           mov ds, word ptr [bp - 0x26]
  00CD2F  8bde             mov bx, si
  00CD31  46               inc si
  00CD32  8a07             mov al, byte ptr [bx]
  00CD34  8846e7           mov byte ptr [bp - 0x19], al
  00CD37  8e46d6           mov es, word ptr [bp - 0x2a]
  00CD3A  8bdf             mov bx, di
  00CD3C  47               inc di
  00CD3D  268a07           mov al, byte ptr es:[bx]
  00CD40  8846ff           mov byte ptr [bp - 1], al
  00CD43  837e1000         cmp word ptr [bp + 0x10], 0
  00CD47  7407             je 0xcd50
  00CD49  c646ff0f         mov byte ptr [bp - 1], 0xf
  00CD4D  eb40             jmp 0xcd8f
  00CD4F  90               nop
  00CD50  837ee400         cmp word ptr [bp - 0x1c], 0
  00CD54  7410             je 0xcd66
  00CD56  8a46ff           mov al, byte ptr [bp - 1]
  00CD59  2ae4             sub ah, ah
  00CD5B  8546e4           test word ptr [bp - 0x1c], ax
  00CD5E  7506             jne 0xcd66
  00CD60  8866ff           mov byte ptr [bp - 1], ah
  00CD63  eb2a             jmp 0xcd8f
  00CD65  90               nop
  00CD66  f646e720         test byte ptr [bp - 0x19], 0x20
  00CD6A  7412             je 0xcd7e
  00CD6C  8a46e7           mov al, byte ptr [bp - 0x19]
  00CD6F  2480             and al, 0x80
  00CD71  3c01             cmp al, 1
  00CD73  1ac0             sbb al, al
  00CD75  2401             and al, 1
  00CD77  041b             add al, 0x1b
  00CD79  8846e7           mov byte ptr [bp - 0x19], al
  00CD7C  eb04             jmp 0xcd82
  00CD7E  8066e71f         and byte ptr [bp - 0x19], 0x1f
  00CD82  8a5ee7           mov bl, byte ptr [bp - 0x19]
  00CD85  2aff             sub bh, bh
  00CD87  368a87ec4a       mov al, byte ptr ss:[bx + 0x4aec]
  00CD8C  8846ff           mov byte ptr [bp - 1], al
  00CD8F  8a46ff           mov al, byte ptr [bp - 1]
  00CD92  8e46d2           mov es, word ptr [bp - 0x2e]
  00CD95  8bd9             mov bx, cx
  00CD97  41               inc cx
  00CD98  268807           mov byte ptr es:[bx], al
  00CD9B  ff4efc           dec word ptr [bp - 4]
  00CD9E  758f             jne 0xcd2f
  00CDA0  894ed0           mov word ptr [bp - 0x30], cx
  00CDA3  897ed4           mov word ptr [bp - 0x2c], di
  00CDA6  8b5e0a           mov bx, word ptr [bp + 0xa]
  00CDA9  b8e715           mov ax, 0x15e7
  00CDAC  8ed8             mov ds, ax
  00CDAE  8b46e0           mov ax, word ptr [bp - 0x20]
  00CDB1  2bc3             sub ax, bx
  00CDB3  03f0             add si, ax
  00CDB5  8b46e0           mov ax, word ptr [bp - 0x20]
  00CDB8  2bc3             sub ax, bx
  00CDBA  0146d4           add word ptr [bp - 0x2c], ax
  00CDBD  8b46dc           mov ax, word ptr [bp - 0x24]
  00CDC0  2bc3             sub ax, bx
  00CDC2  0146d0           add word ptr [bp - 0x30], ax
  00CDC5  8976d8           mov word ptr [bp - 0x28], si
  00CDC8  ff4ede           dec word ptr [bp - 0x22]
  00CDCB  7403             je 0xcdd0
  00CDCD  e944ff           jmp 0xcd14
  00CDD0  5e               pop si
  00CDD1  5f               pop di
  00CDD2  c9               leave
  00CDD3  cb               retf

; ---- _blast_mini  file 0x00CDD4..0x00CDEE  seg 0xB56:0x274  (me_mini.obj) ----
  00CDD4  55               push bp
  00CDD5  8bec             mov bp, sp
  00CDD7  6a00             push 0
  00CDD9  ff7606           push word ptr [bp + 6]
  00CDDC  6a27             push 0x27
  00CDDE  6a38             push 0x38
  00CDE0  ff36c249         push word ptr [0x49c2]
  00CDE4  ff368269         push word ptr [0x6982]
  00CDE8  0e               push cs
  00CDE9  e890fe           call 0xcc7c
  00CDEC  c9               leave
  00CDED  cb               retf

; ---- _show_mini_region  file 0x00CDEE..0x00CF14  seg 0xB56:0x28e  (me_mini.obj) ----
  00CDEE  c8040000         enter 4, 0
  00CDF2  57               push di
  00CDF3  56               push si
  00CDF4  8b7e06           mov di, word ptr [bp + 6]
  00CDF7  8b7608           mov si, word ptr [bp + 8]
  00CDFA  0e               push cs
  00CDFB  e83efe           call 0xcc3c
  00CDFE  8bc6             mov ax, si
  00CE00  3b36c249         cmp si, word ptr [0x49c2]
  00CE04  7d04             jge 0xce0a
  00CE06  8b36c249         mov si, word ptr [0x49c2]
  00CE0A  8976fe           mov word ptr [bp - 2], si
  00CE0D  03460c           add ax, word ptr [bp + 0xc]
  00CE10  48               dec ax
  00CE11  8b0ec249         mov cx, word ptr [0x49c2]
  00CE15  83c126           add cx, 0x26
  00CE18  3bc1             cmp ax, cx
  00CE1A  7e02             jle 0xce1e
  00CE1C  8bc1             mov ax, cx
  00CE1E  2bc6             sub ax, si
  00CE20  40               inc ax
  00CE21  7902             jns 0xce25
  00CE23  2bc0             sub ax, ax
  00CE25  89460c           mov word ptr [bp + 0xc], ax
  00CE28  8bc7             mov ax, di
  00CE2A  037e0a           add di, word ptr [bp + 0xa]
  00CE2D  3b068269         cmp ax, word ptr [0x6982]
  00CE31  7d03             jge 0xce36
  00CE33  a18269           mov ax, word ptr [0x6982]
  00CE36  8946fc           mov word ptr [bp - 4], ax
  00CE39  8d4dff           lea cx, [di - 1]
  00CE3C  8b168269         mov dx, word ptr [0x6982]
  00CE40  83c237           add dx, 0x37
  00CE43  3bca             cmp cx, dx
  00CE45  7e02             jle 0xce49
  00CE47  8bca             mov cx, dx
  00CE49  2bc8             sub cx, ax
  00CE4B  41               inc cx
  00CE4C  7902             jns 0xce50
  00CE4E  2bc9             sub cx, cx
  00CE50  894e0a           mov word ptr [bp + 0xa], cx
  00CE53  0bc9             or cx, cx
  00CE55  7503             jne 0xce5a
  00CE57  e9b500           jmp 0xcf0f
  00CE5A  837e0c00         cmp word ptr [bp + 0xc], 0
  00CE5E  7503             jne 0xce63
  00CE60  e9ac00           jmp 0xcf0f
  00CE63  ff7612           push word ptr [bp + 0x12]
  00CE66  ff7610           push word ptr [bp + 0x10]
  00CE69  ff760c           push word ptr [bp + 0xc]
  00CE6C  51               push cx
  00CE6D  ff76fe           push word ptr [bp - 2]
  00CE70  ff76fc           push word ptr [bp - 4]
  00CE73  0e               push cs
  00CE74  e805fe           call 0xcc7c
  00CE77  83c40c           add sp, 0xc
  00CE7A  ff36fa3a         push word ptr [0x3afa]
  00CE7E  ff36f83a         push word ptr [0x3af8]
  00CE82  ff36f63a         push word ptr [0x3af6]
  00CE86  ff36f43a         push word ptr [0x3af4]
  00CE8A  a1c249           mov ax, word ptr [0x49c2]
  00CE8D  052600           add ax, 0x26
  00CE90  3b063e60         cmp ax, word ptr [0x603e]
  00CE94  7e03             jle 0xce99
  00CE96  a13e60           mov ax, word ptr [0x603e]
  00CE99  2b06c249         sub ax, word ptr [0x49c2]
  00CE9D  050900           add ax, 9
  00CEA0  50               push ax
  00CEA1  6a0f             push 0xf
  00CEA3  a18269           mov ax, word ptr [0x6982]
  00CEA6  8bd8             mov bx, ax
  00CEA8  83c337           add bx, 0x37
  00CEAB  3b1e2660         cmp bx, word ptr [0x6026]
  00CEAF  7e04             jle 0xceb5
  00CEB1  8b1e2660         mov bx, word ptr [0x6026]
  00CEB5  2bd8             sub bx, ax
  00CEB7  3b06f249         cmp ax, word ptr [0x49f2]
  00CEBB  7d03             jge 0xcec0
  00CEBD  a1f249           mov ax, word ptr [0x49f2]
  00CEC0  2b068269         sub ax, word ptr [0x6982]
  00CEC4  05fc00           add ax, 0xfc
  00CEC7  8d9ffc00         lea bx, [bx + 0xfc]
  00CECB  8b16c249         mov dx, word ptr [0x49c2]
  00CECF  3b16f449         cmp dx, word ptr [0x49f4]
  00CED3  7d04             jge 0xced9
  00CED5  8b16f449         mov dx, word ptr [0x49f4]
  00CED9  2b16c249         sub dx, word ptr [0x49c2]
  00CEDD  83c209           add dx, 9
  00CEE0  9a0c00860c       lcall 0xc86, 0xc
  00CEE5  837e0e00         cmp word ptr [bp + 0xe], 0
  00CEE9  7424             je 0xcf0f
  00CEEB  8b46fe           mov ax, word ptr [bp - 2]
  00CEEE  2b06c249         sub ax, word ptr [0x49c2]
  00CEF2  050900           add ax, 9
  00CEF5  50               push ax
  00CEF6  ff760a           push word ptr [bp + 0xa]
  00CEF9  ff760c           push word ptr [bp + 0xc]
  00CEFC  8bd0             mov dx, ax
  00CEFE  8b46fc           mov ax, word ptr [bp - 4]
  00CF01  2b068269         sub ax, word ptr [0x6982]
  00CF05  05fc00           add ax, 0xfc
  00CF08  8bd8             mov bx, ax
  00CF0A  9a4400340c       lcall 0xc34, 0x44
  00CF0F  5e               pop si
  00CF10  5f               pop di
  00CF11  c9               leave
  00CF12  cb               retf
  00CF13  90               nop

; ---- _show_mini  file 0x00CF14..0x00D02A  seg 0xB56:0x3b4  (me_mini.obj) ----
  00CF14  55               push bp
  00CF15  8bec             mov bp, sp
  00CF17  0e               push cs
  00CF18  e821fd           call 0xcc3c
  00CF1B  833e900000       cmp word ptr [0x90], 0
  00CF20  7524             jne 0xcf46
  00CF22  ff36fa3a         push word ptr [0x3afa]
  00CF26  ff36f83a         push word ptr [0x3af8]
  00CF2A  ff36f63a         push word ptr [0x3af6]
  00CF2E  ff36f43a         push word ptr [0x3af4]
  00CF32  6a29             push 0x29
  00CF34  6a00             push 0
  00CF36  b8f100           mov ax, 0xf1
  00CF39  ba0800           mov dx, 8
  00CF3C  bb4f00           mov bx, 0x4f
  00CF3F  9a04005b0c       lcall 0xc5b, 4
  00CF44  eb33             jmp 0xcf79
  00CF46  6a00             push 0
  00CF48  6a00             push 0
  00CF4A  6a29             push 0x29
  00CF4C  6a4f             push 0x4f
  00CF4E  6a08             push 8
  00CF50  68f100           push 0xf1
  00CF53  8b1e9000         mov bx, word ptr [0x90]
  00CF57  ff7706           push word ptr [bx + 6]
  00CF5A  ff7704           push word ptr [bx + 4]
  00CF5D  ff7702           push word ptr [bx + 2]
  00CF60  ff37             push word ptr [bx]
  00CF62  ff36fa3a         push word ptr [0x3afa]
  00CF66  ff36f83a         push word ptr [0x3af8]
  00CF6A  ff36f63a         push word ptr [0x3af6]
  00CF6E  ff36f43a         push word ptr [0x3af4]
  00CF72  9a0000b90c       lcall 0xcb9, 0
  00CF77  8be5             mov sp, bp
  00CF79  ff36fa3a         push word ptr [0x3afa]
  00CF7D  ff36f83a         push word ptr [0x3af8]
  00CF81  ff36f63a         push word ptr [0x3af6]
  00CF85  ff36f43a         push word ptr [0x3af4]
  00CF89  6a30             push 0x30
  00CF8B  6a06             push 6
  00CF8D  b8fb00           mov ax, 0xfb
  00CF90  ba0800           mov dx, 8
  00CF93  bb3401           mov bx, 0x134
  00CF96  9a0c00860c       lcall 0xc86, 0xc
  00CF9B  ff7608           push word ptr [bp + 8]
  00CF9E  0e               push cs
  00CF9F  e832fe           call 0xcdd4
  00CFA2  8be5             mov sp, bp
  00CFA4  ff36fa3a         push word ptr [0x3afa]
  00CFA8  ff36f83a         push word ptr [0x3af8]
  00CFAC  ff36f63a         push word ptr [0x3af6]
  00CFB0  ff36f43a         push word ptr [0x3af4]
  00CFB4  a1c249           mov ax, word ptr [0x49c2]
  00CFB7  052600           add ax, 0x26
  00CFBA  3b063e60         cmp ax, word ptr [0x603e]
  00CFBE  7e03             jle 0xcfc3
  00CFC0  a13e60           mov ax, word ptr [0x603e]
  00CFC3  2b06c249         sub ax, word ptr [0x49c2]
  00CFC7  050900           add ax, 9
  00CFCA  50               push ax
  00CFCB  6a0f             push 0xf
  00CFCD  a18269           mov ax, word ptr [0x6982]
  00CFD0  8bd8             mov bx, ax
  00CFD2  83c337           add bx, 0x37
  00CFD5  3b1e2660         cmp bx, word ptr [0x6026]
  00CFD9  7e04             jle 0xcfdf
  00CFDB  8b1e2660         mov bx, word ptr [0x6026]
  00CFDF  2bd8             sub bx, ax
  00CFE1  3b06f249         cmp ax, word ptr [0x49f2]
  00CFE5  7d03             jge 0xcfea
  00CFE7  a1f249           mov ax, word ptr [0x49f2]
  00CFEA  2b068269         sub ax, word ptr [0x6982]
  00CFEE  05fc00           add ax, 0xfc
  00CFF1  8d9ffc00         lea bx, [bx + 0xfc]
  00CFF5  8b16c249         mov dx, word ptr [0x49c2]
  00CFF9  3b16f449         cmp dx, word ptr [0x49f4]
  00CFFD  7d04             jge 0xd003
  00CFFF  8b16f449         mov dx, word ptr [0x49f4]
  00D003  2b16c249         sub dx, word ptr [0x49c2]
  00D007  83c209           add dx, 9
  00D00A  9a0c00860c       lcall 0xc86, 0xc
  00D00F  837e0600         cmp word ptr [bp + 6], 0
  00D013  7413             je 0xd028
  00D015  6a08             push 8
  00D017  6a4f             push 0x4f
  00D019  6a29             push 0x29
  00D01B  b8f100           mov ax, 0xf1
  00D01E  ba0800           mov dx, 8
  00D021  8bd8             mov bx, ax
  00D023  9a4400340c       lcall 0xc34, 0x44
  00D028  c9               leave
  00D029  cb               retf

; ---- _new_mini  file 0x00D02A..0x00D030  seg 0xB56:0x4ca  (me_mini.obj) ----
  00D02A  0e               push cs
  00D02B  e80efc           call 0xcc3c
  00D02E  cb               retf
  00D02F  90               nop
