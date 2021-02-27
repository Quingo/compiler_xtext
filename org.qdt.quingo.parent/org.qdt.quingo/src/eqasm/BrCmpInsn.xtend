package eqasm
import eqasm.EqasmBase


// BR <cmp_flag>, <target_label>
class EqasmBr extends EqasmBase {
	String CmpFlag
	String TargetLabel

	new (String _CmpFlag, String _TargetLabel) {
		this.CmpFlag = _CmpFlag
		this.TargetLabel = _TargetLabel
		this.setInsnName('br')
	}

	override String str() {
		return String.format('%s %s, %s', getInsnName, CmpFlag, TargetLabel)
	}
}

//# FBR <cmp_flag>, Rd
class EqasmFbr extends EqasmBase {
	String CmpFlag
	GPR rd

	new (String _CmpFlag, GPR _rd) {
		this.CmpFlag = _CmpFlag
		this.rd = _rd
		this.setInsnName('fbr')
	}

	override String str() {
		return String.format('%s %s, %s', getInsnName, CmpFlag, rd.str)
	}
}

// CMP Rs, Rt
class EqasmCmp extends EqasmBase {
	GPR rs
	GPR rt
	new (GPR _rs, GPR _rt) {
		this.rs = _rs
		this.rt = _rt
		this.setInsnName('cmp')
	}

	override String str() {
		return String.format('%s %s, %s', getInsnName, rs.str, rt.str)
	}
}


// BEQ rs, rt, <target_label>
class EqasmBeq extends EqasmBase {
	GPR rs
	GPR rt
	String TargetLabel

	new (GPR _rs, GPR _rt, String _TargetLabel) {
		this.rs = _rs
		this.rt = _rt
		this.TargetLabel = _TargetLabel
		this.setInsnName('beq')
	}

	override String str() {
		return String.format('%s %s, %s, %s', getInsnName, rs.str, rt.str, TargetLabel)
	}
}

// BNE rs, rt, <target_label>
class EqasmBne extends EqasmBase {
	GPR rs
	GPR rt
	String TargetLabel

	new (GPR _rs, GPR _rt, String _TargetLabel) {
		this.rs = _rs
		this.rt = _rt
		this.TargetLabel = _TargetLabel
		this.setInsnName('bne')
	}

	override String str() {
		return String.format('%s %s, %s, %s', getInsnName, rs.str, rt.str, TargetLabel)
	}
}
