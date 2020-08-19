"""
function: test add function
testpoints:
    res[0]= 10 + 10 = 20
    res[1]= 10.0 + 9.9999 = 19.9999
    res[2]= 10 - 10 = 0
    res[3]= 10.0 - 9.9999 = 0.0001
"""


import os.path
from qgrtsys.if_host.python import *

if_quingo = If_Quingo()


def test_add(detailed):
    dir_path = os.path.dirname(os.path.realpath(__file__))
    kernel_file = dir_path + r"\add.qu"
    it_num = 10 if detailed else 1
    count = 0
    while count < it_num:
        print("Iteration number: ", count)
        if_quingo.call_quingo(kernel_file, 'test_add')
        res = if_quingo.read_result()
        print(res)
        assert(res[0] == 20)
        assert(res[1] == 19.9999)
        assert(res[2] == 0)
        assert(res[3] == 0.0001)
        count += 1
    assert not detailed, "It is suspicious that the same result showed up to " + \
        str(it_num) + " times!"


if __name__ == '__main__':
    detailed = len(sys.argv) > 1 and sys.argv[1] == '--detailed'
    test_add(detailed)
