import capstone
EXE = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
data = open(EXE, "rb").read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
for fo in (0xCDD6,):
    res=fo-0x2400
    print(f"FILE 0x{fo:X} (res 0x{res:X}):")
    for insn in md.disasm(data[fo:fo+0x18], res):
        print(f"  res:{insn.address:06x} {insn.bytes.hex():<10} {insn.mnemonic} {insn.op_str}")
