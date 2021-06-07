package eqasm
import org.junit.jupiter.api.Assertions
import java.util.ArrayList
import org.eclipse.xtext.generator.IFileSystemAccess2

interface EqasmInterface{
	def void setInsnName(String _name)
	def String getInsnName()
	def String str()
	def String labeledInsn()
	def String getLabel()
	def void setLabel(String _label)
}

/**
 * Base class of eQASM instructions
 */
abstract class EqasmBase implements EqasmInterface {
	public String name
	public String label
	public String trailingComment
	public static ArrayList<EqasmBase> insnCollection = new ArrayList<EqasmBase>

	new () {
		insnCollection.add(this)
	}

    /** 
     * Clear instructions collected in `insnCollection`.
     */
	def static void resetInsn() {
		insnCollection.clear()
	}

	def static void dump(IFileSystemAccess2 fsa, String fileName) {
		var insnString = ''
		for(EqasmBase insn : insnCollection){
            insnString += insn.labeledInsn + '\n'
        }
		fsa.generateFile(fileName, insnString)
	}

	def static void dump() {
		insnCollection.forEach[println(labeledInsn())]
	}

	override void setInsnName(String _name) {
		this.name =  _name.toUpperCase()
	}

	def String getTrailingComment() {
		var String retComment = ''
		if (trailingComment !== null) {
			retComment = '# ' + trailingComment
		}
		return retComment
	}
	def void setTrailingComment(String _comment) { this.trailingComment = _comment }

	override String getInsnName() {
		return this.name
	}

	override String labeledInsn() {
		return String.format("%-30s %s", this.getLabel + this.str, this.getTrailingComment)
	}

	override getLabel() {
		var String ret_label = ''
		if (label !== null) {
			ret_label = label + ':'
		}
		return ret_label
	}
	override setLabel(String _label) {this.label = _label}
}

/**
 * A mock instruction used to store a label
 */
class EqasmPureLabel extends EqasmBase {
	new (String _label) {
		setLabel(_label)
	}

	override String str() {
		return ""
	}
}

/**
 * A mock instruction used to store one line comment
 */
class EqasmComment extends EqasmBase {
	String comment
	new (String _comment) {
		comment = _comment
	}

	override String str() {
		return comment
	}
}

/**
 * Represent an immediate value.
 */
class ImmValue {
	int imm
	final int width

	new(int _value, int _width) {
		Assertions.assertTrue(_value >= 2 ** (_width - 1) || _value < - 2 ** (_width - 1))
		this.width = _width
		this.imm = _value
	}

	new(int _value) {
		val _width = 32
		this.width = _width
		this.imm = _value
	}
	def getWidth() {
		return this.width
	}

	def hex() {
        return "0x" + Integer.toHexString(imm)
    }

	def str() {
		return String.format("%d", this.imm)
	}
}
