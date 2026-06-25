import capstone
with open('/home/user/colopy/raw/COLONIZE/VICEROY.EXE','rb') as f:
    data = f.read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

def dump(start, end, label=""):
    print(f"=== {label} 0x{start:X}..0x{end:X} ===")
    off = start
    code = data[start:end]
    for ins in md.disasm(code, start):
        print(f"{ins.address:06X}  {ins.bytes.hex():<14} {ins.mnemonic} {ins.op_str}")

# The squared+x2 heading penalty region and where it lands
dump(0x051712, 0x051766, "heading penalty + accumulator")
