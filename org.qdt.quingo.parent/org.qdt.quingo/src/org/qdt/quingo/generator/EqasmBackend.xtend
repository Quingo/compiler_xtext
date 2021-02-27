package org.qdt.quingo.generator

import eqasm.*
import org.junit.jupiter.api.Assertions

import org.qdt.quingo.quingo.Type
import org.qdt.quingo.quingo.DoubleType
import org.qdt.quingo.quingo.BoolType
import java.util.ArrayList
import static extension org.qdt.quingo.generator.StringToReg.*
import org.eclipse.xtext.generator.IFileSystemAccess2

class EqasmBackend {
    
    /** Reset the backend status. 
     * 
     * For now, it clears the instructions which are generated in the previous compilation round.
     * This function is expected to be called before a new compilation.
     */
    static def resetBackend() {
        EqasmBase.resetInsn()
    }
    
	static def writeInsnToFile(IFileSystemAccess2 fsa, String fileName) {
        EqasmBase.dump(fsa, fileName)
    }
    
    static val r0 = new GPR(0)
    static val r1 = new GPR(1)
    static val r2 = new GPR(2)
    static val r3 = new GPR(3)
    static val f0 = new FPR(0)
    static val f1 = new FPR(1)
    static val f2 = new FPR(2)
    static val f3 = new FPR(3)

    /**
     * To ensure -2^(31) <= value <= 2^31 - 1
     */
    static def checkRange(int value) {
        val maxSignedInt32 = (1 << 31) - 1
        val minSignedInt32 = 1 << 31

        if (value < minSignedInt32 || value > maxSignedInt32) {
            var msg = "Given immediate value (%d) resides outside the " +
                      "allowed range for a 32-bit signed integer ([%d, %d])."

            var fmt_msg = String.format(msg, value, minSignedInt32, maxSignedInt32)

            // throw new IllegalArgumentException(fmt_msg)
            System.err.println(fmt_msg)
        }
    }

    // ----------------------------------------------------------------------------------
    // immediate values related operations, commonly used aliases, ...
    // ----------------------------------------------------------------------------------
    /**
     * Load an immediate value into the target register. Class-instruction version.
     */
    static def loadImmToReg(GPR _reg, int value) { 

        checkRange(value)

        val r0 = new GPR(0)

        if (-0x1000 < value && value < 0x1000) {
        	// TODO: why here use addi instead of a direct LDI?
            new EqasmAddi(_reg, r0, value)

        } else {
            val low20bits = value.bitwiseAnd(0xFFFFF)
            val high15bits = value >>> 17
            new EqasmLdi(_reg, low20bits)
            new EqasmLdui(_reg, _reg, high15bits)
        }
    }

    static def loadImmToReg(GPR _reg, int value, String comment) {

		var insn = loadImmToReg(_reg, value)
		insn.setTrailingComment(comment)
        
//        checkRange(value)
//
//        val r0 = new GPR(0)
//
//        if (-0x1000 < value && value < 0x1000) {
//            var insn = new EqasmAddi(_reg, r0, value)
//            insn.setTrailingComment(comment)
//
//        } else {
//            val low20bits = value.bitwiseAnd(0xFFFFF)
//            val high15bits = value >>> 17
//            var insnLdi = new EqasmLdi(_reg, low20bits)
//            insnLdi.setTrailingComment(comment)
//            var insnLdui = new EqasmLdui(_reg, _reg, high15bits)
//            insnLdui.setTrailingComment(comment)
//        }
    }

    /**
     * Load a floating point immediate `value` to the FPR `fregTarget`. In this process, `regTempTransfer` is used as
     *   a temporary transfer buffer.
     */
    static def loadFpImmToReg(String fregTarget, float value, String regTempTransfer) {
        loadImmToReg(strToGPR(regTempTransfer), Float.floatToIntBits(value))
        moveGprToFpr(fregTarget, regTempTransfer)
    }

    static val mapEqualOpToFlag    = #{'==' -> 'EQ', '!=' -> 'NE'}
	static val mapPartialOrderOpToFlag = #{'<' -> 'LT' ,'<=' -> 'LE', '>' -> 'GT', '>=' -> 'GE'}
    static val mapPOop = #{'==' -> 'EQ', '!=' -> 'NE', '<' -> 'LT' ,'<=' -> 'LE', '>' -> 'GT', '>=' -> 'GE'}

    // some commonly used aliases
    static def genInsnResetRegToZero(String regTarget) {
        new EqasmLdi(strToGPR(regTarget), 0)
    }

    static def genInsnMovReg(String regTarget, String regSource) {
        new EqasmAdd(strToGPR(regTarget), strToGPR(regSource), r0)
    }

    /**
    * Move the 32-bit representation of a single-precision FP value from FPR `fregTarget` to GPR `regSource`
    */
    static def moveGprToFpr(String fregTarget, String regSource) {
        new EqasmFmvwx(strToFPR(fregTarget), strToGPR(regSource))
    }

    /**
    * Move the 32-bit representation of a single-precision FP value from GPR `regSource` to FPR `fregTarget`.
    */
    static def moveFprToGpr(String regTarget, String fregSource) {
        new EqasmFmvxw(strToGPR(regTarget), strToFPR(fregSource))
    }


    static def genInsnConvFloatToInt(String regGPR, String regFPR) {
        new EqasmFcvtws(strToGPR(regGPR), strToFPR(regFPR))
    }

    static def genInsnConvIntToFloat(String regFPR, String regGPR) {
        new EqasmFcvtsw(strToFPR(regFPR), strToGPR(regGPR))
    }

    static def genInsnFetchMsmtRes(String regTarget, String regQR) {
        new EqasmFmr(strToGPR(regTarget), strToQR(regQR))
    }
    // ----------------------------------------------------------------------------------
    // immediate values related operations, commonly used aliases, ...
    // ----------------------------------------------------------------------------------

    // ----------------------------------------------------------------------------------
    // arithmetic operations for GPR and FPR
    // ----------------------------------------------------------------------------------
    static def genInsnAddConst(String regTarget, int iValue) {
        new EqasmAddi(strToGPR(regTarget), strToGPR(regTarget), iValue)
    }

    static def genInsnAddConst(String regTarget, String regSource, int iValue) {
        new EqasmAddi(strToGPR(regTarget), strToGPR(regSource), iValue)
    }

    // remove SubRegs, AddRegs, MulRes. Use genInsnForArith, instead.
    static def genInsnSubRegs(String regTarget, String regSource1, String regSource2) {
        new EqasmSub(strToGPR(regTarget), strToGPR(regSource1), strToGPR(regSource2))
    }

    static def genInsnAddRegs(String regTarget, String regSource1, String regSource2) {
        new EqasmAdd(strToGPR(regTarget), strToGPR(regSource1), strToGPR(regSource2))
    }

    static def genInsnFpAddRegs(String regTarget, String regSource1, String regSource2) {
        new EqasmFadds(strToFPR(regTarget), strToFPR(regSource1), strToFPR(regSource2))
    }

    static def genInsnMulRegs(String regTarget, String regSource1, String regSource2) {
        new EqasmMul(strToGPR(regTarget), strToGPR(regSource1), strToGPR(regSource2))
    }

    static def genInsnAndRegs(String regAndResult, String regLeftOperand, String regRightOperand) {
        new EqasmAnd(strToGPR(regAndResult), strToGPR(regLeftOperand), strToGPR(regRightOperand))
    }

    static def genInsnOrRegs(String regOrResult, String regLeftOperand, String regRightOperand) {
        new EqasmOr(strToGPR(regOrResult), strToGPR(regLeftOperand), strToGPR(regRightOperand))
    }

    static def genInsnForArith(String regTarget, String regLeftOperand,
                               String strOperator, String regRightOperand) {

        val rd = strToGPR(regTarget)
        val rs = strToGPR(regLeftOperand)
        val rt = strToGPR(regRightOperand)

        switch(strOperator) {
            case "+": new EqasmAdd(rd, rs, rt)
            case "-": new EqasmSub(rd, rs, rt)
            case "*": new EqasmMul(rd, rs, rt)
            case "/": new EqasmDiv(rd, rs, rt)
            case "%": new EqasmRem(rd, rs, rt)
            default: System.err.println(String.format("Undefined operator '%s' for GPRs.", strOperator))
        }
    }

    static def genInsnForFpArith(String fregTarget, String fregLeftOperand,
                                 String strOperator, String fregRightOperand) {

        val fd = strToFPR(fregTarget)
        val fs = strToFPR(fregLeftOperand)
        val ft = strToFPR(fregRightOperand)

        switch(strOperator) {
            case "+": new EqasmFadds(fd, fs, ft)
            case "-": new EqasmFsubs(fd, fs, ft)
            case "*": new EqasmFmuls(fd, fs, ft)
            case "/": new EqasmFdivs(fd, fs, ft)
            default: System.err.println(String.format("Undefined operator '%s' for floating-point registers.", strOperator))
        }
    }

    /**
     * eQASM-instruction-based multiplication and accumulation, which performs:
     *          regTarget <- regSrc * iFactor + iOffset
     */
    static def genInsnForMAC(String regTarget, String regSrc, int iFactor, int iOffset) {
        if (iFactor == 1) {
            // regTarget <- regSrc = regSrc * iFactor
            new EqasmAddi(strToGPR(regTarget), strToGPR(regSrc), 0)
        } else {
            // regTarget <- iFactor
            loadImmToReg(strToGPR(regTarget), iFactor)
            // regTarget <- regSrc * iFactor
            new EqasmMul(strToGPR(regTarget), strToGPR(regTarget), strToGPR(regSrc))
        }

        // regTarget <- regTarget + iOffset
        new EqasmAddi(strToGPR(regTarget), strToGPR(regTarget), iOffset)
    }

    // maybe this function can be further splitted.
    static def genInsnForUnary(String regTarget, String regSource, String strOp, Type type) {
        if (strOp == "-") {
            if (type instanceof DoubleType) {
                val fd = strToFPR(regTarget)
                val fs = strToFPR(regSource)
                new EqasmFnegs(fd, fs)

            } else {

                val rd = strToGPR(regTarget)
                val rs = strToGPR(regSource)
                new EqasmSub(rd, r0, rs)
            }

        } else if (strOp == "!") {  // TODO: this logic seems to be erroneous
            if (!(type instanceof BoolType)) {
                throw new Exception("The ! operator can only be used for boolean values.")
            }

            val rd = strToGPR(regTarget)
            val rs = strToGPR(regSource)
            new EqasmSub(rd, r1, rs)
        }
    }

    // ----------------------------------------------------------------------------------
    // arithmetic operations for GPR and FPR
    // ----------------------------------------------------------------------------------

    // ----------------------------------------------------------------------------------
    // Memory operations
    // ----------------------------------------------------------------------------------
    /**
     * Store the `sourceReg` register containing a `type` value into the memory `address`.
     */
    static def storeRegToMem(Type type, String sourceReg, int address) {

        switch(type) {  // TODO: replace r0 with variable regConstantZero
            BoolType:   new EqasmSb(strToGPR(sourceReg), address, r0)
            DoubleType: new EqasmFsw(strToFPR(sourceReg), address, r0)
            default:    new EqasmSw(strToGPR(sourceReg), address, r0)
        }
    }

    static def storeRegToMem(String sourceReg, int address) {
    	new EqasmSw(strToGPR(sourceReg), address, r0)
    }

    /**
     * Store the `sourceReg` register containing a `type` value into the memory at the
     *     address  = offset + content[baseAddrReg]
     */
    static def storeRegToMem(Type type, String sourceReg, int offset, String baseAddrReg) {

        switch(type) {
            BoolType:   new EqasmSb (strToGPR(sourceReg), offset, strToGPR(baseAddrReg))
            DoubleType: new EqasmFsw(strToFPR(sourceReg), offset, strToGPR(baseAddrReg))
            default:    new EqasmSw (strToGPR(sourceReg), offset, strToGPR(baseAddrReg))
        }
    }

    static def storeRegToMem(String sourceReg, int offset, String baseAddrReg) {
    	new EqasmSw (strToGPR(sourceReg), offset, strToGPR(baseAddrReg))
    }

    /**
     * Load the `type`-value in memory at `address` to the `targetReg` register:
     *     address  = offset + content[baseAddrReg]
     */
    static def loadMemToReg(Type type, String targetReg, int address) {

        switch(type) {
            BoolType:   new EqasmLb(strToGPR(targetReg), address, r0)
            DoubleType: new EqasmFlw(strToFPR(targetReg), address, r0)
            default:    new EqasmLw(strToGPR(targetReg), address, r0)
        }
    }
    static def loadMemToReg(String targetReg, int address) {
		new EqasmLw(strToGPR(targetReg), address, r0)
    }

    /**
     * Load the `type`-value in the following address to the `targetReg` register:
     *     address  = offset + content[baseAddrReg]
     */
    static def loadMemToReg(Type type, String targetReg, int offset, String baseAddrReg) {

        switch(type) {
            BoolType:   new EqasmLb (strToGPR(targetReg), offset, strToGPR(baseAddrReg))
            DoubleType: new EqasmFlw(strToFPR(targetReg), offset, strToGPR(baseAddrReg))
            default:    new EqasmLw (strToGPR(targetReg), offset, strToGPR(baseAddrReg))
        }
    }

    static def loadMemToReg(String targetReg, int offset, String baseAddrReg) {
		new EqasmLw (strToGPR(targetReg), offset, strToGPR(baseAddrReg))
    }
    // ----------------------------------------------------------------------------------
    // Memory operations
    // ----------------------------------------------------------------------------------

    // ----------------------------------------------------------------------------------
    // Quantum operations
    // ----------------------------------------------------------------------------------
    static def genInsnSetQotrs(String regQotrs, Integer[] qArray) {
        new EqasmSmis(strToQotrs(regQotrs), qArray)
    }

    static def genInsnSetQotrt(String tregTarget, ArrayList<QubitPair> qPairArray) {
        new EqasmSmit(strToQotrt(tregTarget), qPairArray)
    }

    static def genInsnWait(int iWaitTime) {
        new EqasmQwait(iWaitTime)
    }

    static def genInsnWait(String regWaitTime) {
        new EqasmQwaitr(strToGPR(regWaitTime))
    }

    static def genInsnSQOperation(int PreInterval, String opName, String regQotrs) {
        new EqasmQBundle(PreInterval, opName, strToQotrs(regQotrs))
    }

    static def genInsnTQOperation(int PreInterval, String opName, QubitPair qubit_pair) {

        var regQotrt = strToQotrt('t0')         // allocate a Qotrt

        var ArrayList<QubitPair> qPairArray = new ArrayList<QubitPair> // put the content inside
        qPairArray.add(qubit_pair)
        new EqasmSmit(regQotrt, qPairArray)

        new EqasmQBundle(PreInterval, opName, regQotrt)
    }
    // ----------------------------------------------------------------------------------
    // Quantum operations
    // ----------------------------------------------------------------------------------

    // ----------------------------------------------------------------------------------
    // Comparison, Jump, Labels, etc.
    // ----------------------------------------------------------------------------------

    // maybe the following two functions can be merged into a single one.
    static def genInsnsCheckEquality(String regResult, String regLeftOperand, String regRightOperand,
                              String strOp, Type type) {
        Assertions.assertTrue(strOp.equals('==') || strOp.equals('!='))

        var rd = strToGPR(regResult)

        if (type instanceof DoubleType) {  // floating-point comparison
            new EqasmFeqs(rd, strToFPR(regLeftOperand), strToFPR(regRightOperand))

            if (strOp.equals("!=")) {
                new EqasmSub(rd, r1, rd)
            }

        } else {                                            // integer comparison
            new EqasmCmp(strToGPR(regLeftOperand), strToGPR(regRightOperand))
            new EqasmNop()
			new EqasmFbr(mapEqualOpToFlag.get(strOp), rd)
        }

    }

    /**
     * Generate eQASM instructions for partial order (PO) relationship comparison.
     */
    static def genInsnsPOCmp(String regResult, String regLeftOperand, String regRightOperand, String strOp, Type type) {

        var rd = strToGPR(regResult)

        if (type instanceof DoubleType) {

            var fs = strToFPR(regLeftOperand)
            var ft = strToFPR(regRightOperand)

            if (strOp.equals("<")) {
                new EqasmFlts(rd, fs, ft)
            }
            else if (strOp.equals("<=")) {
                new EqasmFles(rd, fs, ft)
            }
            else if(strOp.equals(">=")) {
                new EqasmFlts(rd, fs, ft)
                new EqasmSub(rd, strToGPR('r1'), rd)
            }
            else if (strOp.equals(">")) {
                new EqasmFles(rd, fs, ft)
                new EqasmSub(rd, strToGPR('r1'), rd)
            } else {
                throw new Exception('Found unsupported partial order operator ' + strOp +
                                    'for floating-point values')
            }
        } else {
            var rs = strToGPR(regLeftOperand)
            var rt = strToGPR(regRightOperand)

            new EqasmCmp(rs, rt)
            new EqasmNop()
            new EqasmFbr(mapPartialOrderOpToFlag.get(strOp), rd)
        }
    }

    static def genInsnGotoLabelUponCmp(String regLeftOperand, String strOperator,  String regRightOperand,
                                String strTargetLabel) {

        new EqasmCmp(strToGPR(regLeftOperand), strToGPR(regRightOperand))
        new EqasmNop()
        val strCmpFalg = mapPOop.get(strOperator)
        new EqasmBr(strCmpFalg, strTargetLabel)
    }

    static def gotoLabelIfNotEqual(String reg1, String reg2, String TargetLabel) {
        addEqasmBne(reg1, reg2, TargetLabel)
    }

    static def gotoLabelIfEqual(String reg1, String reg2, String TargetLabel) {
        addEqasmBeq(reg1, reg2, TargetLabel)
    }

    static def insertQasmGoto(String targetLabel) {
        // addEqasmBeq('r0', 'r0', funcEndLabel)
        new EqasmBr('ALWAYS', targetLabel)
    }

    static def addEqasmBne(String reg0, String reg1, String TargetLabel) {
        val gpr0 = strToGPR(reg0)
        val gpr1 = strToGPR(reg1)
        new EqasmBne(gpr0, gpr1, TargetLabel)
    }

    static def addEqasmBeq(String reg0, String reg1, String TargetLabel) {
        val gpr0 = strToGPR(reg0)
        val gpr1 = strToGPR(reg1)
        new EqasmBeq(gpr0, gpr1, TargetLabel)
    }

    static def genQasmLabel(String label) {
        new EqasmPureLabel(label)
    }

    static def genQasmLabel(String label, String comment) {
        var insn = new EqasmPureLabel(label)
        insn.setTrailingComment(comment)
    }

    static def genQasmComment(String comment) {
        new EqasmComment("# " + comment)
    }
    // ----------------------------------------------------------------------------------
    // Comparison, Jump, Labels, etc.
    // ----------------------------------------------------------------------------------


    static def addInitInstructions() {
        new EqasmXor(r0, r0, r0)
        new EqasmAddi(r1, r0, 1)
        loadImmToReg(r2, Configuration.dynamicAddr)
        new EqasmSw(r0, Configuration.staticAddr, r0)
        new EqasmFcvtsw(f0, r0)
    }

    static def addEndInstructions() {
        new EqasmPureLabel('function_0_end')
        new EqasmStop()
    }
}