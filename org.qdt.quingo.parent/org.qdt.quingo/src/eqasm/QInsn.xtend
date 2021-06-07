package eqasm

import java.util.ArrayList
import java.util.Set
import org.junit.jupiter.api.Assertions

import eqasm.GPR
import eqasm.Qotrt
import eqasm.Qotrs
import eqasm.EqasmBase
import eqasm.QuantumOperationBase
import java.util.HashSet


/**
 * eQASM qwait instruction.
 */
class EqasmQwait extends EqasmBase {
	ImmValue imm
	
	new (Integer _imm) {
		this.imm = new ImmValue(_imm)
		this.setInsnName('qwait')
	}
	
	override String str() {
		return String.format('%s %s', getInsnName, imm.str)
	}
}

/**
 * eQASM qwaitr instruction.
 */
class EqasmQwaitr extends EqasmBase {
	GPR rs 
	
	new (GPR _rs) {
		this.rs = _rs
		this.setInsnName('qwaitr')
	}
	
	override String str() {
		return String.format('%s %s', getInsnName, rs.str)
	}
}

/**
 * eQASM smis instruction.
 */
class EqasmSmis extends EqasmBase {
	Qotrs si
	Set<Integer> SingleQubitList
	
	new (Qotrs _si, Integer[] _qubits) {
		this.si = _si
		this.SingleQubitList = intListToSet(_qubits)
		this.setInsnName('smis')
	}

	new (Qotrs _si, ArrayList<Integer> _qubits) {
		this.si = _si
		this.SingleQubitList = intListToSet(_qubits)
		this.setInsnName('smis')
	}
	
	def static intListToSet(Integer[] _qubits) {
		var Set<Integer> myset = new HashSet<Integer>()
		for (q: _qubits) {
			if (! myset.contains(q)) {
				myset.add(q)
			}
		}
		return myset
	}
	
	def getStrQubitList() {
		return String.format("{%s}", String.join(', ', SingleQubitList.map[String.valueOf(it)]))
	}
	
	override String str() {
		return String.format('%s %s, %s', getInsnName, si.str, getStrQubitList)
	}
}

/**
 * eQASM smit instruction.
 */
class EqasmSmit extends EqasmBase {
	Qotrt ti
	Set<QubitPair> QubitPairList
	
	new (Qotrt _ti, ArrayList<QubitPair> _QubitPairs) {
		this.ti = _ti
		this.QubitPairList = new HashSet<QubitPair>()
		QubitPairList = qubitPairListToSet(_QubitPairs)
		this.setInsnName('smit')
	}
	
	new (Qotrt _ti, QubitPair[] _QubitPairs) {
		this.ti = _ti
		this.QubitPairList = qubitPairListToSet(_QubitPairs);
		this.setInsnName('smit')
	}
	
	def static qubitPairListToSet(QubitPair[] _QubitPairs) {
		var Set<QubitPair> myset = new HashSet<QubitPair>()
		for (q: _QubitPairs) {
			if (! myset.contains(q)) {
				myset.add(q)
			}
		}
		return myset
	}
	
	def static qubitPairListToSet(ArrayList<QubitPair> _QubitPairs) {
		var Set<QubitPair> myset = new HashSet<QubitPair>()
		for (q: _QubitPairs) {
			if (! myset.contains(q)) {
				myset.add(q)
			}
		}
		return myset
	}
	
	def getStrQubitPairList() {
		return String.format("{%s}", String.join(',', QubitPairList.map[it.str]))
	}
	
	override String str() {
		return String.format('%s %s, %s', getInsnName, ti.str, getStrQubitPairList)
	}
}

/**
 * eQASM quantum bundles.
 * <p>
 * Example: 1, op1 (s/t)reg1 | op2 (s/t)reg2
 */
class EqasmQBundle extends EqasmBase {
	public var Integer PreInterval = 0
	public var ArrayList<QuantumOperationBase> QOps
	new () {
		QOps = new ArrayList<QuantumOperationBase>
		PreInterval = 1
	}
	
	new (String _OpName, Qotrs _SReg) {
		PreInterval = 1
		QOps = new ArrayList<QuantumOperationBase>
		QOps.add(new SingleQubitGate(_OpName, _SReg))
	}
	
	new (String _OpName, Qotrt _TReg) {
		PreInterval = 1
		QOps = new ArrayList<QuantumOperationBase>
		QOps.add(new TwoQubitGate(_OpName, _TReg))
	}
	
	new (int _pi, String _OpName, Qotrs _SReg) {
		PreInterval = _pi
		QOps = new ArrayList<QuantumOperationBase>
		QOps.add(new SingleQubitGate(_OpName, _SReg))
	}
	
	new (int _pi, String _OpName, Qotrt _TReg) {
		PreInterval = _pi
		QOps = new ArrayList<QuantumOperationBase>
		QOps.add(new TwoQubitGate(_OpName, _TReg))
	}
	
	new (Integer pi, ArrayList<QuantumOperationBase> _QOps) {
		Assertions.assertTrue(0 <= pi && pi <= 7)
		PreInterval = pi
		QOps = _QOps
	}
	
	def addOp(String _OpName, Qotrs _SReg) {
		QOps.add(new SingleQubitGate(_OpName, _SReg))
	}
	
	def addOp(String _OpName, Qotrt _TReg) {
		QOps.add(new TwoQubitGate(_OpName, _TReg))
	}
	
	override String str() {
		return String.format("%d, %s", PreInterval, String.join(' | ', QOps.map[it.str]))
	}
}

