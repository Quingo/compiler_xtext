package org.qdt.quingo.generator

import org.qdt.quingo.quingo.ArrayType
import org.qdt.quingo.quingo.BoolType
import org.qdt.quingo.quingo.DoubleType
import org.qdt.quingo.quingo.IntType
import org.qdt.quingo.quingo.TupleType
import org.qdt.quingo.quingo.Type
import org.qdt.quingo.generator.PointerType
import org.qdt.quingo.generator.EqasmBackend

class Serializer {

    // sizes of primitive data types in bytes
    public static val int BOOL_SIZE    = 1
    public static val int INT_SIZE     = 4
    public static val int POINTER_SIZE = 4
    public static val int DOUBLE_SIZE  = 4

    /**
     * Get the data size of the structure with `type` in the stack space.
     */
    static def int dataSize(Type type) {
        if (type instanceof IntType) {
            return Serializer.INT_SIZE
        } else if (type instanceof BoolType) {
            return Serializer.BOOL_SIZE
        } else if (type instanceof ArrayType) {
            return Serializer.POINTER_SIZE
        } else if (type instanceof PointerType) {
            return Serializer.POINTER_SIZE
        } else if (type instanceof DoubleType) {
            return Serializer.DOUBLE_SIZE
        } else if (type instanceof TupleType) {
            var sum = 0
            for (ttype: type.type) { sum += dataSize(ttype) }
            return sum
        }
        return 0
    }

}