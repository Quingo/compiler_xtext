package org.qdt.quingo.generator

import eqasm.Register

abstract class MetaDataBase {
	public var int address
	
	public var Register register
}

class MetaDataInt extends MetaDataBase {

}