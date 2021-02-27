package org.qdt.quingo.generator
import eqasm.FPR
import eqasm.GPR
import eqasm.Qotrs
import eqasm.Qotrt
import eqasm.QR
import org.junit.jupiter.api.Assertions


class StringToReg {
    def static intFromString(String intStr) {
        try {
            val Integer intValue = new Integer(intStr)
            return intValue
        } catch(Exception e) {
            System.err.println(e)
            var errMsg = String.format(
                "Error happens while converting the following string into an integer: %s", intStr)
            System.err.println(errMsg)
            throw new Exception(errMsg)
        }
    }

	def static int getIndex(String StrReg, String abbr) {
		Assertions.assertTrue(StrReg.toLowerCase().startsWith(abbr))
     	val StrRegIndex = StrReg.substring(1, StrReg.length())
     	return intFromString(StrRegIndex)
	}

    def static GPR strToGPR(String StrReg) {
		val RegIndex = getIndex(StrReg, 'r')
     	return new GPR(RegIndex)
    }

    def static FPR strToFPR(String StrFReg) {
		val RegIndex = getIndex(StrFReg, 'f')
     	return new FPR(RegIndex)
    }

    def static Qotrs strToQotrs(String StrSReg) {
		val RegIndex = getIndex(StrSReg, 's')
     	return new Qotrs(RegIndex)
    }

    def static Qotrt strToQotrt(String StrTReg) {
		val RegIndex = getIndex(StrTReg, 't')
     	return new Qotrt(RegIndex)
    }


    def static QR strToQR(String StrQReg) {
		val RegIndex = getIndex(StrQReg, 'q')
     	return new QR(RegIndex)
    }

}