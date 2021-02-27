package eqasm
import eqasm.GPR
import eqasm.FPR
import java.util.ArrayList

class FpInsn {
	def static void main(String[] args) {

	  	val fd = new FPR(19)
	  	val fs = new FPR(27)
	  	val ft = new FPR(4)
	  	val rd = new GPR(11)

	  	var insnArray = new ArrayList<EqasmBase>

	  	insnArray.add(new EqasmFcvtws(rd, fs))
	  	insnArray.add(new EqasmFcvtsw(fs, rd))
	 	insnArray.add(new EqasmFlw(fd, 100, rd)) // # FLW fd, imm(rs)
	 	insnArray.add(new EqasmFsw(fs, 100, rd)) // # FSW fs, imm(rs)
	  	insnArray.add(new EqasmFadds(fd, fs, ft))
	  	insnArray.add(new EqasmFsubs(fd, fs, ft))
	  	insnArray.add(new EqasmFmuls(fd, fs, ft))
	  	insnArray.add(new EqasmFdivs(fd, fs, ft))
	  	insnArray.add(new EqasmFles(rd, fs, ft))
	  	insnArray.add(new EqasmFeqs(rd, fs, ft))
	  	insnArray.add(new EqasmFlts(rd, fs, ft))

	  	insnArray.forEach[println(str())]
	}
}

//eqasm_insn.FCVT_W_S: ['rd', 'fs'],        # FCVT.W.S rd, fs
//eqasm_insn.FCVT_S_W: ['fd', 'rs'],        # FCVT.S.W fd, rs
class EqasmFcvtws extends EqasmBase {
	GPR rd
	FPR fs

	new (GPR _rd, FPR _fs) {
		this.rd = _rd
		this.fs = _fs
		this.setInsnName('fcvt.w.s')
	}

	override String str() {
		return String.format("%s %s, %s", getInsnName, rd.str, fs.str)
	}
}

class EqasmFcvtsw extends EqasmBase {
	FPR fd
	GPR rs

	new (FPR _fd, GPR _rs) {
		this.fd = _fd
		this.rs = _rs
		this.setInsnName('fcvt.s.w')
	}

	override String str() {
		return String.format("%s %s, %s", getInsnName, fd.str, rs.str)
	}
}

/**
 * FMV.W.X moves the single-precision value encoded in IEEE 754-2008 standard encoding from the lower 32 bits
 * of GPR rs to the FPR fd
 */
class EqasmFmvwx extends EqasmBase {
	GPR rs
	FPR fd

	new (FPR _fd, GPR _rs) {
		this.fd = _fd
		this.rs = _rs
		this.setInsnName('fmv.w.x')
	}

	override String str() {
		return String.format("%s %s, %s", getInsnName, rs.str, fd.str)
	}
}

/**
 * Move the lower 32 bits of IEEE 754-2008 standard encoding of a FP value from FPR fs to GPR rd
 */
class EqasmFmvxw extends EqasmBase {
	FPR fs
	GPR rd

	new (GPR _rd, FPR _fs) {
		this.rd = _rd
		this.fs = _fs
		this.setInsnName('fmv.x.w')
	}

	override String str() {
		return String.format("%s %s, %s", getInsnName, fs.str, rd.str)
	}
}

//eqasm_insn.FLW: ['fd', 'imm', 'rs'],      # FLW fd, imm(rs)
//eqasm_insn.FSW: ['fs', 'imm', 'rs'],      # FSW fs, imm(rs)
class EqasmFlw extends EqasmBase {
	FPR fd
	ImmValue imm
	GPR rs

	new (FPR _fd, int _imm, GPR _rs) {
		this.fd = _fd
		this.imm = new ImmValue(_imm)
		this.rs = _rs
		this.setInsnName('flw')
	}

	override String str() {
		return String.format("%s %s, %s(%s)", getInsnName, fd.str, imm.str, rs.str)
	}
}

class EqasmFsw extends EqasmBase {
	FPR fs
	ImmValue imm
	GPR rs

	new (FPR _fs, int _imm, GPR _rs) {
		this.fs = _fs
		this.imm = new ImmValue(_imm)
		this.rs = _rs
		this.setInsnName('fsw')
	}

	override String str() {
		return String.format("%s %s, %s(%s)", getInsnName, fs.str, imm.str, rs.str)
	}
}

abstract class FpInsnBase extends EqasmBase {
	public FPR fs
	public FPR ft

	new (FPR _fs, FPR _ft) {
		this.fs = _fs
		this.ft = _ft
	}
}


class EqasmFnegs extends EqasmBase {
	public FPR fd
	public FPR fs

	new (FPR _fd, FPR _fs) {
		this.fd = _fd
		this.fs = _fs
		this.setInsnName('fneg.s')
	}

	override String str() {
		return String.format("%s %s, %s", getInsnName, fd.str, fs.str)
	}
}


//eqasm_insn.FADD_S: ['fd', 'fs', 'ft'],  # FADD.S fd, fs, ft
//eqasm_insn.FSUB_S: ['fd', 'fs', 'ft'],  # FSUB.S fd, fs, ft
//eqasm_insn.FMUL_S: ['fd', 'fs', 'ft'],  # FMUL.S fd, fs, ft
//eqasm_insn.FDIV_S: ['fd', 'fs', 'ft'],  # FDIV.S fd, fs, ft
class ThreeFpInsnBase extends FpInsnBase {
	FPR fd

	new (FPR _fd, FPR _fs, FPR _ft) {
		super(_fs, _ft)
		this.fd = _fd
	}

	override String str() {
		return String.format("%s %s, %s, %s", getInsnName, fd.str, fs.str, ft.str)
	}
}

class EqasmFadds extends ThreeFpInsnBase {
	new (FPR _fd, FPR _fs, FPR _ft) {
		super(_fd, _fs, _ft)
		this.setInsnName('fadd.s')
	}
}

class EqasmFsubs extends ThreeFpInsnBase {
	new (FPR _fd, FPR _fs, FPR _ft) {
		super(_fd, _fs, _ft)
		this.setInsnName('fsub.s')
	}
}

class EqasmFmuls extends ThreeFpInsnBase {
	new (FPR _fd, FPR _fs, FPR _ft) {
		super(_fd, _fs, _ft)
		this.setInsnName('fmul.s')
	}
}

class EqasmFdivs extends ThreeFpInsnBase {
	new (FPR _fd, FPR _fs, FPR _ft) {
		super(_fd, _fs, _ft)
		this.setInsnName('fdiv.s')
	}
}

class FcmpInsn extends FpInsnBase {
	GPR rd

	new (GPR _rd, FPR _fs, FPR _ft) {
		super(_fs, _ft)
		this.rd = _rd
	}

	override String str() {
		return String.format("%s %s, %s(%s)", getInsnName, rd.str, fs.str, ft.str)
	}
}

//eqasm_insn.FEQ_S: ['rd', 'fs', 'ft'],   # FEQ.S rd, fs, ft
//eqasm_insn.FLT_S: ['rd', 'fs', 'ft'],   # FLT.S rd, fs, ft
//eqasm_insn.FLE_S: ['rd', 'fs', 'ft']    # FLE.S rd, fs, ft
class EqasmFeqs extends FcmpInsn {
	new (GPR _rd, FPR _fs, FPR _ft) {
		super(_rd, _fs, _ft)
		this.setInsnName('feq.s')
	}
}

class EqasmFlts extends FcmpInsn {
	new (GPR _rd, FPR _fs, FPR _ft) {
		super(_rd, _fs, _ft)
		this.setInsnName('flt.s')
	}
}


class EqasmFles extends FcmpInsn {
	new (GPR _rd, FPR _fs, FPR _ft) {
		super(_rd, _fs, _ft)
		this.setInsnName('fle.s')
	}
}

