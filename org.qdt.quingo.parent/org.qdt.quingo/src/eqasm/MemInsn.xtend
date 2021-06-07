package eqasm

import eqasm.EqasmBase

/**
 * The base class of store instructions.
 */
class StoreBase extends EqasmBase {
	GPR rs
	ImmValue imm
	GPR rt

	new (GPR _rs, int _imm, GPR _rt) {
		rs = _rs
		imm = new ImmValue(_imm)
		rt = _rt
	}

	override String str() {
		return String.format("%s %s, %s(%s)", name, rs.str, imm.hex, rt.str)
	}
}

/**
 * eQASM SB instruction.
 * <p>
 * Example: SB  rs, imm10(rt)
 */
class EqasmSb extends StoreBase {
	new (GPR _rs, int _imm, GPR _rt) {
		super(_rs, _imm, _rt)
		setInsnName('sb')
	}
}

/**
 * eQASM SW instruction.
 * <p>
 * Example: SW  rs, imm10(rt)
 */
class EqasmSw extends StoreBase {
	new (GPR _rs, int _imm, GPR _rt) {
		super(_rs, _imm, _rt)
		setInsnName('sw')
	}
}


/**
 * Base class of load instructions.
 */
class LoadBase extends EqasmBase{
	GPR rd
	ImmValue imm
	GPR rt

	new (GPR _rd, int _imm, GPR _rt) {
		rd = _rd
		imm = new ImmValue(_imm)
		rt = _rt
	}

	override String str() {
		return String.format("%s %s, %s(%s)", name, rd.str, imm.hex, rt.str)
	}
}

/**
 * eQASM LW instruction.
 * <p>
 * Example: LW  rd, imm10(rt)
 */
class EqasmLw extends LoadBase {
	new (GPR _rd, int _imm, GPR _rt) {
		super(_rd, _imm, _rt)
		setInsnName('lw')
	}
}

/**
 * eQASM LB instruction.
 * <p>
 * Example: LB  rd, imm10(rt)
 */
class EqasmLb extends LoadBase {
	new (GPR _rd, int _imm, GPR _rt) {
		super(_rd, _imm, _rt)
		setInsnName('lb')
	}
}

/**
 * eQASM LBU instruction.
 * <p>
 * Example: LBU rd, imm10(rt)
 */
class EqasmLbu extends LoadBase {
	new (GPR _rd, int _imm, GPR _rt) {
		super(_rd, _imm, _rt)
		setInsnName('lbu')
	}
}