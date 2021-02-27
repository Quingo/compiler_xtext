package eqasm

import eqasm.EqasmBase

// NOP
class EqasmNop extends EqasmBase {
	new () {
		this.setInsnName('nop')
	}
	
	override String str() {
		return String.format('%s', getInsnName)
	}
}

// STOP
class EqasmStop extends EqasmBase {
	new () {
		this.setInsnName('stop')
	}
	
	override String str() {
		return String.format('%s', getInsnName)
	}
}


class ThreeGprBase  extends EqasmBase {
	GPR rd
	GPR rs
	GPR rt

	new (GPR _rd, GPR _rs, GPR _rt) {
		this.rd = _rd
		this.rs = _rs
		this.rt = _rt
	}

	override String str() {
		return String.format("%s %s, %s, %s", this.name, this.rd.str, this.rs.str, this.rt.str)
	}
}

class EqasmAdd extends ThreeGprBase {
	new (GPR _rd, GPR _rs, GPR _rt) {
		super(_rd, _rs, _rt)
		setInsnName('add')
	}
}

class EqasmSub extends ThreeGprBase {
	new (GPR _rd, GPR _rs, GPR _rt) {
		super(_rd, _rs, _rt)
		setInsnName('sub')
	}
}

class EqasmOr extends ThreeGprBase {
	new (GPR _rd, GPR _rs, GPR _rt) {
		super(_rd, _rs, _rt)
		setInsnName('or')
	}
}
class EqasmXor extends ThreeGprBase {
	new (GPR _rd, GPR _rs, GPR _rt) {
		super(_rd, _rs, _rt)
		setInsnName('xor')
	}
}
class EqasmAnd extends ThreeGprBase {
	new (GPR _rd, GPR _rs, GPR _rt) {
		super(_rd, _rs, _rt)
		setInsnName('and')
	}
}
class EqasmMul extends ThreeGprBase {
	new (GPR _rd, GPR _rs, GPR _rt) {
		super(_rd, _rs, _rt)
		setInsnName('mul')
	}
}
class EqasmDiv extends ThreeGprBase {
	new (GPR _rd, GPR _rs, GPR _rt) {
		super(_rd, _rs, _rt)
		setInsnName('div')
	}
}
class EqasmRem extends ThreeGprBase {
	new (GPR _rd, GPR _rs, GPR _rt) {
		super(_rd, _rs, _rt)
		setInsnName('rem')
	}
}

//eqasm_insn.LDUI: ['rd', 'rs', 'imm'],  # LDUI rd, rs, imm15
class EqasmLdui extends EqasmBase {
	GPR rd 
	GPR rs
	ImmValue imm
	new (GPR _rd, GPR _rs, int _imm) {
		this.rd = _rd
		this.rs = _rs
		this.imm = new ImmValue(_imm)
		this.setInsnName('ldui')
	}
	override String str() {
		return String.format('%s %s, %s, %s', getInsnName, rd.str, rs.str, imm.hex)
	}
}

//eqasm_insn.ADDI: ['rd', 'rs', 'imm'],  # ADDI Rd, Rs, imm
class EqasmAddi extends EqasmBase {
	GPR rd 
	GPR rs
	ImmValue imm
	new (GPR _rd, GPR _rs, int _imm) {
		this.rd = _rd
		this.rs = _rs
		this.imm = new ImmValue(_imm)
		this.setInsnName('addi')
	}
	override String str() {
		return String.format('%s %s, %s, %s', getInsnName, rd.str, rs.str, imm.str)
	}
}


// eqasm_insn.LDI: ['rd', 'imm'],  # LDI Rd, Imm20
class EqasmLdi extends EqasmBase {
	GPR rd 
	ImmValue imm
	
	new (GPR _rd, int _imm) {
		this.rd = _rd
		this.imm = new ImmValue(_imm)
		this.setInsnName('ldi')
	}
	
	override String str() {
		return String.format('%s %s, %s', getInsnName, rd.str, imm.hex)
	}
}


// NOT Rd, Rt
class EqasmNot extends EqasmBase {
	GPR rd
	GPR rt 
	new (GPR _rd, GPR _rt) {
		this.rd = _rd
		this.rt = _rt
		this.setInsnName('not')
	}
	
	override String str() {
		return String.format('%s %s, %s', getInsnName, rd.str, rt.str)
	}
}



// fmr rd, qs
class EqasmFmr extends EqasmBase {
	GPR rd
	QR qs
	new (GPR _rd, QR _qs) {
		this.rd = _rd
		this.qs = _qs
		this.setInsnName('fmr')
	}
	
	override String str() {
		return String.format('%s %s, %s', getInsnName, rd.str, qs.str)
	}
}