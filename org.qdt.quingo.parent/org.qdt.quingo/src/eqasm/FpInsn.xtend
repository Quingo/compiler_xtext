package eqasm
import eqasm.GPR
import eqasm.FPR

/**
 * eQASM FCVT_W_S instruction.
 * <p>
 * Example: FCVT.W.S rd, fs
 */
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

/**
 * eQASM FCVT_S_W instruction.
 * <p>
 * Example: FCVT.S.W fd, rs
 */
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
 * eQASM FMV.W.X instruction.
 * <p>
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
 * eQASM FMV.X.W instruction.
 * <p>
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

/**
 * eQASM FLW instruction.
 * <p>
 * Example: FLW fd, imm(rs)
 */
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

/**
 * eQASM FSW instruction.
 * <p>
 * Example: FSW fs, imm(rs)
 */
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

/**
 * eQASM floating point instruction base.
 */
abstract class FpInsnBase extends EqasmBase {
	public FPR fs
	public FPR ft

	new (FPR _fs, FPR _ft) {
		this.fs = _fs
		this.ft = _ft
	}
}

/**
 * eQASM FNEG.S instruction.
 */
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

/**
 * Base class for eQASM floating point instructions that have three operands.
 */
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

/**
 * eQASM FADD.S instruction.
 * <p>
 * Example: FADD.S fd, fs, ft
 */
class EqasmFadds extends ThreeFpInsnBase {
	new (FPR _fd, FPR _fs, FPR _ft) {
		super(_fd, _fs, _ft)
		this.setInsnName('fadd.s')
	}
}

/**
 * eQASM FSUB.S instruction.
 * <p>
 * Example: FSUB.S fd, fs, ft
 */
class EqasmFsubs extends ThreeFpInsnBase {
	new (FPR _fd, FPR _fs, FPR _ft) {
		super(_fd, _fs, _ft)
		this.setInsnName('fsub.s')
	}
}

/**
 * eQASM FMUL.S instruction.
 * <p>
 * Example: FMUL.S fd, fs, ft
 */
class EqasmFmuls extends ThreeFpInsnBase {
	new (FPR _fd, FPR _fs, FPR _ft) {
		super(_fd, _fs, _ft)
		this.setInsnName('fmul.s')
	}
}

/**
 * eQASM FDIV.S instruction.
 * <p>
 * Example: FDIV.S fd, fs, ft
 */
class EqasmFdivs extends ThreeFpInsnBase {
	new (FPR _fd, FPR _fs, FPR _ft) {
		super(_fd, _fs, _ft)
		this.setInsnName('fdiv.s')
	}
}

/**
 * Base class for floating point comparison instructions in eQASM.
 */
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

/**
 * eQASM FEQ.S instruction.
 * <p>
 * Example: FEQ.S rd, fs, ft
 */
class EqasmFeqs extends FcmpInsn {
	new (GPR _rd, FPR _fs, FPR _ft) {
		super(_rd, _fs, _ft)
		this.setInsnName('feq.s')
	}
}

/**
 * eQASM FLT.S instruction.
 * <p>
 * Example: FLT.S rd, fs, ft
 */
class EqasmFlts extends FcmpInsn {
	new (GPR _rd, FPR _fs, FPR _ft) {
		super(_rd, _fs, _ft)
		this.setInsnName('flt.s')
	}
}

/**
 * eQASM FLE.S instruction.
 * <p>
 * Example: FLE.S rd, fs, ft
 */
class EqasmFles extends FcmpInsn {
	new (GPR _rd, FPR _fs, FPR _ft) {
		super(_rd, _fs, _ft)
		this.setInsnName('fle.s')
	}
}
