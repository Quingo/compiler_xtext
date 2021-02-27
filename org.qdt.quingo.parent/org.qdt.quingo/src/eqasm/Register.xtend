package eqasm
import org.junit.jupiter.api.Assertions

abstract class Register {
    public int index = -1
    def String str()
}


class FPR extends Register {
    final static int NumFPRs = 32

    new(int _index) {
        Assertions.assertTrue(0 <= _index && _index < NumFPRs)
        this.index = _index
    }

    new(FPR other) { this.index = other.index }

    override str() { return String.format("f%s", this.index) }
}

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


class QR extends Register {
    final static int NumQRs = 32

    new(int _index) {
        Assertions.assertTrue(0 <= _index && _index < NumQRs)
        this.index = _index
    }

    new(QR other) { this.index = other.index }

    override str() { return String.format("q%s", this.index) }
}


class Qotrs extends Register {
    final static int NumQotrss = 32

    new(int _index) {
        Assertions.assertTrue(0 <= _index && _index < NumQotrss)
        this.index = _index
    }

    new(Qotrs other) { this.index = other.index }

    override str() { return String.format("s%s", this.index) }
}

class Qotrt extends Register {
    final static int NumQotrts = 32

    new(int _index) {
        Assertions.assertTrue(0 <= _index && _index < NumQotrts)
        this.index = _index
    }

    new(Qotrt other) { this.index = other.index }

    override str() { return String.format("t%s", this.index) }
}