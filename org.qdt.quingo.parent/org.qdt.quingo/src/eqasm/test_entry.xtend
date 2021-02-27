package eqasm

import eqasm.GPR
import java.util.ArrayList

class test_entry {
	def static void main(String[] args) {
    test_static_add()
//    test_gpr_assignment()
//    test_eqasm_prog()
//    test_lwst()
  }

  def static void test_int_range(){
  	var int a = (1 << 31) - 1
  	println(a)
  }

  def static void test_static_add() {
	  var insn  = new EqasmPureLabel("hahaha")
	  insn.setTrailingComment("this is a comment")
	  EqasmBase.dump()
  }

  def static void test_eqasm_prog() {
  	val rd = new GPR(1)
  	val rs = new GPR(2)
  	val rt = new GPR(31)


	new EqasmAdd(rd, rs, rt)
	new EqasmSub(rd, rs, rt)
	new EqasmXor(rd, rs, rt)
	new EqasmMul(rd, rs, rt)
	new EqasmDiv(rd, rs, rt)
	new EqasmRem(rd, rs, rt)
	new EqasmAnd(rd, rs, rt)
	new EqasmOr(rd, rs, rt)

	// ----------------------------------------------------------------
	// three different types of printing
	// ----------------------------------------------------------------
	// 1: using index
	// for (i: 0 ..< insnArray.size) {
	// 	println(insnArray.get(i).str)
	// }

	// 2: sing forEach with index
	//	insnArray.forEach[element, index | println(element.str)]
	// 3: using forEach without index
	//	insnArray.forEach[it | println(it.str)]
	// 4: using forEach with default it
//	insnArray.forEach[println(str())]
		EqasmBase.dump()

  }

  def static void test_lwst() {
  	val rd = new GPR(1)
  	val rs = new GPR(2)
  	val rt = new GPR(31)

	var lwstArray = new ArrayList<EqasmBase>
	lwstArray.add(new EqasmLw(rd, 10, rt))
	lwstArray.add(new EqasmLb(rd, 100, rt))
	var lbu = new EqasmLbu(rd, 200, rt)
	lbu.setLabel('greatLabel')
	lwstArray.add(lbu)
	lwstArray.add(new EqasmSw(rs, 200, rt))
	lwstArray.add(new EqasmSb(rs, 200, rt))
//	lwstArray.forEach[println(str())]
	lwstArray.forEach[println(labeledInsn())]
  }


  def static void test_gpr_assignment() {
  	var gpr1 = new GPR(1)
   	println(String.format('gpr1: %s', gpr1.str))
    var gpr2 = gpr1
    println(String.format('gpr2: %s', gpr2.str))
    gpr1.index = 2
   	println(String.format('gpr1: %s', gpr1.str))
    println(String.format('gpr2: %s', gpr2.str)) // gpr2 gets r2 as well.

	if (gpr1 === gpr2) {
		println("gpr1 and gpr2 are the same object.")
	}

  }}