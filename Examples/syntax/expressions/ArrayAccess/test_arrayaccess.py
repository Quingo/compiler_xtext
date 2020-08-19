"""
function: test arrayaccess function
testpoints:
    array = {{1,2},{4,5,6},{7,8,9,10}}
    res[0]= array[0] = {1,2}
    res[1]= array[1][1] = 5
    res[2]= array.length = 3
    res[3]= array[2].length = 4
"""


import os.path
from qgrtsys.if_host.python import *

if_quingo = If_Quingo()


def test_arrayaccess(detailed):
    dir_path = os.path.dirname(os.path.realpath(__file__))
    kernel_file = dir_path + r"\arrayaccess.qu"
    it_num = 10 if detailed else 1
    count = 0
    while count < it_num:
        print("Iteration number: ", count)
        if_quingo.call_quingo(kernel_file, 'test_arrayaccess')
        res = if_quingo.read_result()
        print(res)
        assert(res[0] == {1, 2})
        assert(res[1] == 5)
        assert(res[2] == 3)
        assert(res[3] == 4)
        count += 1
    assert not detailed, "It is suspicious that the same result showed up to " + \
        str(it_num) + " times!"


if __name__ == '__main__':
    detailed = len(sys.argv) > 1 and sys.argv[1] == '--detailed'
    test_arrayaccess(detailed)
