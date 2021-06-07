package eqasm
import org.junit.jupiter.api.Assertions

/**
 * Base class of registers.
 */
abstract class Register {
    public int index = -1
    def String str()
}

/**
 * Floating point registers.
 */
class FPR extends Register {
    final static int NumFPRs = 32

    new(int _index) {
        Assertions.assertTrue(0 <= _index && _index < NumFPRs)
        this.index = _index
    }

    new(FPR other) { this.index = other.index }

    override str() { return String.format("f%s", this.index) }
}

/**
 * General purpose registers.
 */
class GPR extends Register {
    final static int NumGPRs = 32

    new(int _index) {
        Assertions.assertTrue(0 <= _index && _index < NumGPRs)
        this.index = _index
    }

    new(GPR other) { this.index = other.index }

    override str() {
        return String.format("r%s", this.index)
    }
}


/**
 * Represent a pair of qubits.
 */
class QubitPair {
    public var int left
    public var int right
    new (int _left, int _right) {
        this.left = _left
        this.right = _right
    }

    def String str() {
        return String.format("(%d,%d)", left, right)
    }
}


/**
 * Represent a qubit.
 */
class QR extends Register {
    final static int NumQRs = 32

    new(int _index) {
        Assertions.assertTrue(0 <= _index && _index < NumQRs)
        this.index = _index
    }

    new(QR other) { this.index = other.index }

    override str() { return String.format("q%s", this.index) }
}

/**
 * The s-registers in eQASM.
 * <p>
 * Each register stores the index of a qubit
 */
class Qotrs extends Register {
    final static int NumQotrss = 32

    new(int _index) {
        Assertions.assertTrue(0 <= _index && _index < NumQotrss)
        this.index = _index
    }

    new(Qotrs other) { this.index = other.index }

    override str() { return String.format("s%s", this.index) }
}

/**
 * The t-registers in eQASM.
 * <p>
 * Each register stores the indexes of two qubits
 */
class Qotrt extends Register {
    final static int NumQotrts = 32

    new(int _index) {
        Assertions.assertTrue(0 <= _index && _index < NumQotrts)
        this.index = _index
    }

    new(Qotrt other) { this.index = other.index }

    override str() { return String.format("t%s", this.index) }
}