"""
function: test Nequal function
testpoints:
    res[0][0]= (2 > 1) = true
    res[0][1]= (2 > 2) = false
    res[0][2]= (10.0 > 9.99999) = true
    res[0][3]= (9.99999 > 9.99999) = false

    res[1][0]= (2 >= 2) = true
    res[1][1]= (1 >= 2) = false
    res[1][2]= (10.0 >= 9.9999) = true
    res[1][3]= (9.99999 >= 9.99999) = true

    res[2][0]= (2 < 3) = true
    res[2][1]= (2 < 2) = false
    res[2][2]= (9.99999 < 10.0) = true
    res[2][3]= (9.99999 < 9.99999) = false

    res[2][0]= (2 <= 2) = true
    res[2][1]= (2 <= 1) = false
    res[2][2]= (9.99999 <= 10.0) = true
    res[2][3]= (9.99999 <= 9.99999) = true
"""


import os.path
from qgrtsys.if_host.python import *

if_quingo = If_Quingo()


def test_nequal(detailed):
    dir_path = os.path.dirname(os.path.realpath(__file__))
    kernel_file = dir_path + r"\nequal.qu"
    it_num = 10 if detailed else 1
    count = 0
    true_showed, false_showed = False, False
    while count < it_num:
        print("Iteration number: ", count)
        if_quingo.call_quingo(kernel_file, 'test_nequal')
        res = if_quingo.read_result()
        print(res)
        assert(res[0][0] == True)
        assert(res[0][1] == False)
        assert(res[0][2] == True)
        assert(res[0][3] == False)
        assert(res[1][0] == True)
        assert(res[1][1] == False)
        assert(res[1][2] == True)
        assert(res[1][3] == True)
        assert(res[2][0] == True)
        assert(res[2][1] == False)
        assert(res[2][2] == True)
        assert(res[2][3] == False)
        assert(res[3][0] == True)
        assert(res[3][1] == False)
        assert(res[3][2] == True)
        assert(res[3][3] == True)

        count += 1
    assert not detailed, "It is suspicious that the same result showed up to " + \
        str(it_num) + " times!"


if __name__ == '__main__':
    detailed = len(sys.argv) > 1 and sys.argv[1] == '--detailed'
    test_nequal(detailed)
