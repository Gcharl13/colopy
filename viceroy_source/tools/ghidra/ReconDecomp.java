import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.address.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.mem.MemoryBlock;
import ghidra.util.task.ConsoleTaskMonitor;
import java.io.*;

public class ReconDecomp extends GhidraScript {
    public void run() throws Exception {
        String[] args = getScriptArgs();
        String outDir = args[0];
        println("LANG " + currentProgram.getLanguageID());
        for (MemoryBlock b : currentProgram.getMemory().getBlocks())
            println("BLOCK " + b.getName() + " " + b.getStart() + ".." + b.getEnd()
                    + " size=0x" + Long.toHexString(b.getSize()));
        DecompInterface ifc = new DecompInterface();
        ifc.openProgram(currentProgram);
        FunctionManager fm = currentProgram.getFunctionManager();
        for (int i = 1; i < args.length; i++) {
            long flat = Long.parseLong(args[i].replace("0x",""), 16);
            int seg = (int)((flat & 0xF0000L) >> 4);
            int off = (int)(flat & 0xFFFFL);
            String as = String.format("%04x:%04x", seg, off);
            Address addr = currentProgram.getAddressFactory().getAddress(as);
            println("TARGET flat 0x" + Long.toHexString(flat) + " -> " + as + " -> " + addr);
            if (addr == null) { println("  null addr"); continue; }
            try { disassemble(addr); } catch (Exception e) { println("  dis err " + e); }
            Function func = fm.getFunctionAt(addr);
            if (func == null) {
                try { func = createFunction(addr, "func_" + Long.toHexString(flat)); }
                catch (Exception e) { println("  createFunc err " + e); }
            }
            if (func == null) { println("  NO FUNC"); continue; }
            DecompileResults res = ifc.decompileFunction(func, 120, new ConsoleTaskMonitor());
            String c = res.decompileCompleted()
                ? res.getDecompiledFunction().getC()
                : ("// DECOMPILE FAILED: " + res.getErrorMessage() + "\n");
            File of = new File(outDir, "func_" + Long.toHexString(flat) + ".c");
            FileWriter w = new FileWriter(of); w.write(c); w.close();
            println("  WROTE " + of.getPath() + " (" + c.length() + " bytes)");
        }
    }
}
