package org.qdt.quingo.generator

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import org.qdt.quingo.quingo.impl.TypeImpl
import org.qdt.quingo.quingo.Type
import org.qdt.quingo.quingo.QuingoFactory

class Configuration {
	public static String outputFile = ""
	public static int sharedAddr = 0
	public static int staticAddr = 0x10000
	public static int dynamicAddr = 0x20000
	public static int maxUnrolling = 100
	public static int exitCode = 0
}

@Accessors class Position {
	Boolean constant
	Boolean reg
	Boolean mem
	
	new(Boolean _constant, Boolean _reg, Boolean _mem) {
		constant = _constant
		reg = _reg
		mem = _mem
	}
	
	def getOnlyReg() {
		!constant && reg && !mem
	}
	
	def atLeastOne() {
		constant || reg || mem
	}
	
	def setOnlyConstant() {
		constant = true
		reg = false
		mem = false
	}
	
	def setOnlyMem() {
		constant = false
		reg = false
		mem = true
	}
	
	def setOnlyReg() {
		constant = false
		reg = true
		mem = false
	}
	
	def setConAndReg() {
		constant = true
		reg = true
		mem = false
	}
}

class PointerType extends TypeImpl
{
	
}

@Accessors class MetaData {
	String reg
	//Boolean word // true for int/array type; false for bool type
	Object value
	int address
	Position valid
	List<MetaData> link
	//int type // 1 for pointer; 2 for array; 0 for else
	//Boolean qubit // true for qubit (array); false for other types
	Type type
	
	new(String _reg, int _address, Position _valid, List<MetaData> _link) {
		reg = _reg
		//word = _word
		address = _address
		valid = _valid
		link = _link
		//type = _type
		//qubit = _qubit
	}
	
	new(String _reg, int _address, Position _valid) {
		this(_reg, _address, _valid, null)
	}
	
	new(String _reg, int _address) {
		this(_reg, _address, new Position(false, false, false))
	}
	
	new(String _reg) {
		this(_reg, 0)
	}
	
	new(Boolean _bvalue) {
		this((_bvalue)? "r1": "r0", 0)
		value = _bvalue
		address = 0
		//word = false
		type = QuingoFactory::eINSTANCE.createBoolType
		valid = new Position(true, false, false)
	}
	
	new(Integer ivalue) {
		reg = ""
		value = ivalue
		address = 0
		type = QuingoFactory::eINSTANCE.createIntType
		valid = new Position(true, false, false)
	}
	
	new(Float fvalue) {
		reg = ""
		value = fvalue
		address = 0
		type = QuingoFactory::eINSTANCE.createDoubleType
		valid = new Position(true, false, false)
	}

	new() {
		this("")
	}
}
