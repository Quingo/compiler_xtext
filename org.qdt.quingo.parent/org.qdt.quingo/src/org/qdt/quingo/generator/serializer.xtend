package org.qdt.quingo.generator

import org.qdt.quingo.quingo.ArrayType
import org.qdt.quingo.quingo.BoolType
import org.qdt.quingo.quingo.DoubleType
import org.qdt.quingo.quingo.IntType
import org.qdt.quingo.quingo.TupleType
import org.qdt.quingo.quingo.Type
import org.qdt.quingo.generator.PointerType

/**
 * Data sizes of Quingo types.
 * 
 * @author Jintao Yu, Xiang Fu
 */
class Serializer {

    /**
     * The size of 'bool' type
     */
    public static val int BOOL_SIZE    = 1

    /**
     * The size of 'int' type
     */
    public static val int INT_SIZE     = 4

    /**
     * The size of a pointer type
     */
    public static val int POINTER_SIZE = 4

    /**
     * The size of 'double' type
     */
    public static val int DOUBLE_SIZE  = 4

    /**
     * Get the data size of the structure with `type` in the stack space.
     * 
     * @param type  the Quingo type
     * @return int  the size of the type in bytes
     */
    static def int dataSize(Type type) {
        if (type instanceof IntType) {
            return Serializer.INT_SIZE
        } 
        else if (type instanceof BoolType) {
            return Serializer.BOOL_SIZE
        } 
        else if (type instanceof ArrayType) {
            return Serializer.POINTER_SIZE
        } 
        else if (type instanceof PointerType) {
            return Serializer.POINTER_SIZE
        } 
        else if (type instanceof DoubleType) {
            return Serializer.DOUBLE_SIZE
        } 
        else if (type instanceof TupleType) {
            var sum = 0
            for (ttype: type.type) { 
            	sum += dataSize(ttype)
            }
            return sum
        }
        return 0
    }

}