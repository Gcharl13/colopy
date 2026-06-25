import capstone
EXE = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
data = open(EXE, "rb").read()

# Claimed evidence bytes:
# mov ax,[0x586]  = A1 86 05
# mov es,ax       = 8E C0
# mov di,[0x588]  = 8B 3E 88 05
# mov si,0xfa00   = BE 00 FA
# add si,[0x5a8]  = 03 36 A8 05

patterns = {
 "mov ax,[0x586]": bytes.fromhex("a18605"),
 "mov es,ax":      bytes.fromhex("8ec0"),
 "mov di,[0x588]": bytes.fromhex("8b3e8805"),
 "mov si,0xfa00":  bytes.fromhex("be00fa"),
 "add si,[0x5a8]": bytes.fromhex("0336a805"),
}
for name,pat in patterns.items():
    idxs=[]
    i=data.find(pat)
    while i!=-1 and len(idxs)<10:
        idxs.append(i)
        i=data.find(pat,i+1)
    # convert file off to resident: resident = fileoff - 0x2400
    res=[f"0x{x:X}(res 0x{x-0x2400:X})" for x in idxs]
    print(f"{name:20} count={data.count(pat):4}  first: {res[:5]}")

# Also check header to confirm load image start
print("\nMZ header:")
print("e_cblp,e_cp:", int.from_bytes(data[2:4],'little'), int.from_bytes(data[4:6],'little'))
hdr_paras=int.from_bytes(data[8:10],'little')
print("header size paras:", hdr_paras, "-> bytes:", hdr_paras*16, "hex", hex(hdr_paras*16))
