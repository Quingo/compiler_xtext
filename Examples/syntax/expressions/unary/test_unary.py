"""
function: test unary function
testpoints:
    res[0]= +10 = 10
    res[1]= -(-9.99） = 9.99
    res[2]= ！(true & false) = false & true
"""


import os.path
from qgrtsys.if_host.python import *

if_quingo = If_Quingo()


def test_unary(detailed):
    dir_path = os.path.dirname(os.path.realpath(__file__))
    kernel_file = dir_path + r"\unary.qu"
    it_num = 10 if detailed else 1
    count = 0
    true_showed, false_showed = False, False
    while count < it_num:
        print("Iteration number: ", count)
        if_quingo.call_quingo(kernel_file, 'test_unary')
        res = if_quingo.read_result()
        print(res)
        assert(res[0] == 10)
        assert(res[1] == 9.99)
        if res[2][0]:
            true_showed = True
            assert(res[2][1] == False)
        else:
            false_showed = True
            assert(res[2][1] == True)
        if true_showed and false_showed:
            return
        count += 1
    assert not detailed, "It is suspicious that the same result showed up to " + \
        str(it_num) + " times!"


if __name__ == '__main__':
    detailed = len(sys.argv) > 1 and sys.argv[1] == '--detailed'
    test_unary(detailed)
