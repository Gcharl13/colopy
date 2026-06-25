import capstone
with open('/home/user/colopy/raw/COLONIZE/VICEROY.EXE','rb') as f:
    data = f.read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
md.detail = False

def dump(file_off, n=24, label=""):
    print(f"--- {label} file_off=0x{file_off:X} ---")
    code = data[file_off:file_off+n]
    print("raw:", code.hex())
    for ins in md.disasm(code, file_off):
        print(f"{ins.address:06X}  {ins.bytes.hex():<14} {ins.mnemonic} {ins.op_str}")

for off,lbl in [(0x05170A,"@0x05170A"),(0x051759,"@0x051759 cmp"),(0x051760,"@0x051760"),
                (0x051712,"@0x051712"),(0x0516C5,"@0x0516C5 gate"),(0x0516CC,"@0x0516CC gate")]:
    dump(off, 24, lbl)
