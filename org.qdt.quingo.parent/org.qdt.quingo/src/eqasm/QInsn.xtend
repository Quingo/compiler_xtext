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

class QInsn {

	def static void main (String[] args) {
		testBundle()
	}
	
	def testConversion() {
		var ArrayList<Integer> intArray = new ArrayList<Integer>
	  	intArray.add(1)
	  	intArray.add(3)
	  	intArray.add(3)
	  	intArray.add(4)
	  	intArray.add(3)
		val intSet = EqasmSmis.intListToSet(intArray)
		for(i: intSet) {
			println(i)
		}
	}
	
	def static testBundle() {
	  	val rd = new GPR(1)
//	  	val rs = new GPR(2)
//	  	val rt = new GPR(31)
	  	val si = new Qotrs(13)
	  	val s0 = new Qotrs(0)
	  	val ti = new Qotrt(15)
//	  	val Integer[] qArray= #{1, 2, 3, 6, 9}
	  	var ArrayList<Integer> qArray = new ArrayList<Integer>
	  	qArray.add(1)
	  	var SingleQubitGate gate1 = new SingleQubitGate('h', si)
	  	var SingleQubitGate gate2 = new SingleQubitGate('x180', s0)
	  	var meas = new Measurement(si)
	  	var cnot = new TwoQubitGate('cnot', ti)
	  	var tqArray = new ArrayList<QuantumOperationBase>()
	  	tqArray.add(gate1)
  		tqArray.add(gate2)
		tqArray.add(meas)
		tqArray.add(cnot)
	  			
	  	
	  	val qubit_pair1 = new QubitPair(0, 1)
	  	val qubit_pair2 = new QubitPair(2, 3)
	  	val QubitPair[] qPairArray = #{qubit_pair1, qubit_pair2}
	  	
		var lwstArray = new ArrayList<EqasmBase>
		lwstArray.add(new EqasmQwait(10))
		lwstArray.add(new EqasmQwaitr(rd))
		lwstArray.add(new EqasmSmis(si, qArray))
		lwstArray.add(new EqasmSmit(ti, qPairArray))
		lwstArray.add(new EqasmQBundle(6, tqArray))
		
		var flexBundle = new EqasmQBundle()
		flexBundle.addOp('Kun', si)
		flexBundle.addOp('Xiang', ti)
		lwstArray.add(flexBundle)
		lwstArray.add(new EqasmQBundle(1, 'Xiangkun', si))
		lwstArray.forEach[println(str())]
	}
}

// qwait imm
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
// qwaitr rs
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
// smis si, sq_list
class EqasmSmis extends EqasmBase {
	Qotrs si
	Set<Integer> SingleQubitList
	
	// TODO: check the range of each qubit index
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
//eqasm_insn.SMIT: ['ti', 'tq_list']
class EqasmSmit extends EqasmBase {
	Qotrt ti
	Set<QubitPair> QubitPairList
	
	// TODO: check the range of each qubit index in the qubit pair list
	new (Qotrt _ti, ArrayList<QubitPair> _QubitPairs) {
		this.ti = _ti
		this.QubitPairList = new HashSet<QubitPair>()
//		_QubitPairs.forEach[this.QubitPairList.add(it)]
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

//# quantum bundles: 1, op1 (s/t)reg1 | op2 (s/t)reg2
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
//		if (PreInterval == 1) {
//			return String.format(String.join(' | ', QOps.map[it.str]))
//		}
		return String.format("%d, %s", PreInterval, String.join(' | ', QOps.map[it.str]))
	}
}

