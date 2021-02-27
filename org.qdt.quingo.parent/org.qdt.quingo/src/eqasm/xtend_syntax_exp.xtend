package eqasm
import java.util.ArrayList
import java.util.Iterator
import java.util.List
import java.util.ListIterator

class xtend_syntax_exp {
    def public static void main(String[] args) {
//        var int[] elistInt = #[1, 2, 3, 4, 5]
        var List<Integer> elist = new ArrayList<Integer>()
        elist.add(1)
        elist.add(2)
        elist.add(3)
        elist.add(4)
        elist.add(5)
        
        var ListIterator<Integer> eIter  = elist.listIterator()
        while (eIter.hasNext()) {
            var e = eIter.next()
            println("now I get: " + e)
            if (e < 4 && e > 2) {
                eIter.remove()    
                eIter.add(6)
                eIter.add(9)
            }
        } 
        elist.forEach[println(it)]
    }
}