import capstone
with open('/home/user/colopy/raw/COLONIZE/VICEROY.EXE','rb') as f:
    data = f.read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

# Scan for ENTER (C8) prologues between 0x04E51E and 0x05170A
print("=== ENTER (c8) bytes between 0x04E520 and 0x051800 ===")
for off in range(0x04E520, 0x051800):
    if data[off] == 0xC8:
        # ENTER imm16, imm8
        frame = int.from_bytes(data[off+1:off+3],'little')
        lvl = data[off+3]
        print(f"  0x{off:06X}  C8 {data[off+1]:02X} {data[off+2]:02X} {data[off+3]:02X}  ENTER 0x{frame:x},{lvl}")
