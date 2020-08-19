"""
function: test typechange function
testpoints:
    res[0]= toInt(10) = 10
    res[1]= toInt(9.1) = 9
    res[2]= toInt(9.5) = 10
    res[3]= toDouble(9.99) = 9.99
    res[4]= toDouble(10) = 10.0
"""


import os.path
from qgrtsys.if_host.python import *

if_quingo = If_Quingo()


def test_typechange(detailed):
    dir_path = os.path.dirname(os.path.realpath(__file__))
    kernel_file = dir_path + r"\typechange.qu"
    it_num = 10 if detailed else 1
    count = 0
    while count < it_num:
        print("Iteration number: ", count)
        if_quingo.call_quingo(kernel_file, 'test_typechange')
        res = if_quingo.read_result()
        print(res)
        assert(res[0] == 10)
        assert(res[1] == 9)
        assert(res[2] == 10)
        assert(res[3] == 9.99)
        assert(res[4] == 10)
        count += 1
    assert not detailed, "It is suspicious that the same result showed up to " + \
        str(it_num) + " times!"


if __name__ == '__main__':
    detailed = len(sys.argv) > 1 and sys.argv[1] == '--detailed'
    test_typechange(detailed)
