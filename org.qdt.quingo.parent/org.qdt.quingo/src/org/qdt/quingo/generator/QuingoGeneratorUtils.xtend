package org.qdt.quingo.generator

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import org.qdt.quingo.quingo.impl.TypeImpl
import org.qdt.quingo.quingo.Type
import org.qdt.quingo.quingo.QuingoFactory

/**
 * Contain configurable values for the compilation.
 * 
 * @author Jintao Yu
 */
 class Configuration {
	/**
	 * name of the generated eQASM file
	 */
	public static String outputFile = ""
	
	/**
	 * head address of the shared memory region
	 * <p>
	 * This region is used for returning the calculation result.
	 */
	public static int sharedAddr = 0
	
	/**
	 * head address of the static memory region
	 * <p>
	 * This region is used for storing primitive variables and arrays whose lengths are known
	 * during compilation.
	 */
	public static int staticAddr = 0x10000
	
	/**
	 * head address of the dynamic memory region
	 * <p>
	 * This region is used for storing arrays whose lengths are unknown during compilation.
	 */
	public static int dynamicAddr = 0x20000
	
	/**
	 * the maximum number that loop unrolling is up to
	 * <p>
	 * Beyond this number, the loop keeps its form in the generated code.
	 */
	public static int maxUnrolling = 100
	
	/**
	 * the exit code of compilation
	 * <p>
	 * It is the value returned as a command-line tool. 0 represents normal exit, and 
	 * negative numbers represent compilation errors.
	 */
	public static int exitCode = 0
}

/**
 * Record the position(s) of the newest data.
 * <p>
 * This class is used as a field of {@code MetaData} class.
 * 
 * @author Jintao Yu
 */
 @Accessors class Position {
 	/**
 	 * newest data is in the MetaData (i.e., 'value' and 'link' fields)
 	 */
	Boolean constant
	
	/**
	 * newest data is in the register (i.e., the 'reg' field)
	 */
	Boolean reg
	
	/**
	 * newest data is in memory (starting from 'address' field)
	 */
	Boolean mem

	new(Boolean _constant, Boolean _reg, Boolean _mem) {
		constant = _constant
		reg = _reg
		mem = _mem
	}

	/**
	 * Whether only 'reg' is valid.
	 */
	def getOnlyReg() {
		!constant && reg && !mem
	}

	/**
	 * Whether there is any valid data.
	 * <p>
	 * If the result is false, it shows that the MetaData is never assigned.
	 */
	def atLeastOne() {
		constant || reg || mem
	}

	/**
	 * Set the 'constant' field to true and others to false
	 */
	def setOnlyConstant() {
		constant = true
		reg = false
		mem = false
	}

	/**
	 * Set the 'mem' field to true and others to false
	 */
	def setOnlyMem() {
		constant = false
		reg = false
		mem = true
	}

	/**
	 * Set the 'reg' field to true and others to false
	 */
	def setOnlyReg() {
		constant = false
		reg = true
		mem = false
	}

	/**
	 * Set the 'constant' and 'reg' fields to true and 'mem' to false
	 */
	def setConAndReg() {
		constant = true
		reg = true
		mem = false
	}
}

/**
 * Show the 'Type' is a pointer.
 * <p>
 * We need to define an extra type for the pointer, which is not defined in the syntax.
 * However, it does not need to have any special fields. Therefore, we extend the
 * {@code TypeImpl} class and add no fields or methods.
 * 
 * @author Jintao Yu
 */
class PointerType extends TypeImpl
{

}

/**
 * Meta data representation of a variable or a constant value.
 * <p>
 * It is the data structure representing the compilation result of a value such as a bool or an array.
 * 
 * @author Jintao Yu
 */
@Accessors class MetaData {
	/**
	 * The register storing the variable.
	 * <p>
	 * When no register storing the variable, i.e., valid.reg == false, 'reg' is an empty string.
	 * <p>
	 * When the MetaData stores an operation (for higher-level function calling purpose), the 'reg'
	 * stores the URI of the operation.
	 */
	String reg
	
	/**
	 * The value of the variable.
	 * <p>
	 * 'value' is only valid when valid.constant == true.
	 * <p>
	 * 'value' can be {@code Boolean}, {@code Integer} or {@code Double} depending on the type of the
	 * MetaData.
	 */
	Object value
	
	/**
	 * The stack address where the variable is stored.
	 * <p>
	 * 'address' is the address on the quantum coprocessor, not the on computer that runs the compiler.
	 * <p>
	 * 'address' is allocated when the MetaData is created and remains unchanged during the lifetime of
	 * the MetaData.
	 */
	int address
	
	/**
	 * Indicate where is the newest value located.
	 */
	Position valid
	
	/**
	 * The list of MetaData of the members in an array or a tuple.
	 * <p>
	 * Its value is null for variables of primitive types
	 */
	List<MetaData> link
	
	/**
	 * The Quingo type of the underlining variable
	 */
	Type type

	new(String _reg, int _address, Position _valid, List<MetaData> _link) {
		reg = _reg
		address = _address
		valid = _valid
		link = _link
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
