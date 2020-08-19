"""
function: test equal function
testpoints:
    res[0][0]= (1 == 2) = false
    res[0][1]= (12 == 12) = true
    res[0][2]= (9.99999 == 10.0) = false
    res[0][3]= (9.99999 == 9.99999) = true
    res[0][5]= (true == res[0][4]) = false&true
    res[1][0]= (1 != 2) = true
    res[1][1]= (12 != 12) = false
    res[1][2]= (9.99999 != 10.0) = true
    res[1][3]= (9.99999 != 9.99999) = false
    res[1][5]= (true != res[0][4]) = false&true
"""


import os.path
from qgrtsys.if_host.python import *

if_quingo = If_Quingo()


def test_equal(detailed):
    dir_path = os.path.dirname(os.path.realpath(__file__))
    kernel_file = dir_path + r"\equal.qu"
    it_num = 10 if detailed else 1
    count = 0
    true_showed, false_showed = False, False
    while count < it_num:
        print("Iteration number: ", count)
        if_quingo.call_quingo(kernel_file, 'test_and')
        res = if_quingo.read_result()
        print(res)
        assert(res[0][0] == False)
        assert(res[0][1] == True)
        assert(res[0][2] == False)
        assert(res[0][3] == True)
        assert(res[1][0] == True)
        assert(res[1][1] == False)
        assert(res[1][2] == True)
        assert(res[1][3] == False)
        if res[0][4]:
            true_showed = True
            assert(res[0][5] == True)
            assert(res[1][5] == False)
        else:
            false_showed = True
            assert(res[0][5] == False)
            assert(res[1][5] == True)
        if true_showed and false_showed:
            return
        count += 1
    assert not detailed, "It is suspicious that the same result showed up to " + \
        str(it_num) + " times!"


if __name__ == '__main__':
    detailed = len(sys.argv) > 1 and sys.argv[1] == '--detailed'
    test_equal(detailed)
