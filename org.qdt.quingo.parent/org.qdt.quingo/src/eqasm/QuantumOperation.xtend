package eqasm


//enum QOpType {
//	SINGLE_QUBIT_GATE,
//	TWO_QUBIT_GATE,
//	MEASUREMENT
//}

abstract class QuantumOperationBase {
	var String name
	new (String _name) {
		name = _name
	}
		
	def getOpName() {
		return name
	}
	
	def setOpName(String _name) {
		name = _name
	}
	
	def String str()
}

class SingleQubitGate extends QuantumOperationBase {
	public var Qotrs SReg
	
	new (String _name, Qotrs _SReg) {
		super(_name)
		SReg = _SReg
	}
	
	override String str() {
		return String.format("%s %s", getOpName, SReg.str)
	}
}

class Measurement extends QuantumOperationBase {
	public var Qotrs SReg
	
	new (Qotrs _SReg) {
		super('MeasZ')
		SReg = _SReg
	}
	
	override String str() {
		return String.format("%s %s", getOpName, SReg.str)
	}
}


class TwoQubitGate extends QuantumOperationBase {
	public var Qotrt TReg
	
	new (String _name, Qotrt _TReg) {
		super(_name)
		TReg = _TReg
	}
	
	override String str() {
		return String.format("%s %s", getOpName, TReg.str)
	}
}
