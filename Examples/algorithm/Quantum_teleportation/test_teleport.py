import time
import os
from qgrtsys.if_host.python import *

if_quingo = If_Quingo()
start = time.time()


def test_gen_ran_num():
    dir_path = os.path.dirname(os.path.realpath(__file__))
    print(dir_path)
    kernel_file = dir_path + r"\kernel.qu"
    print(kernel_file)
    if_quingo.call_quingo(kernel_file, "teleportation")
    res = if_quingo.read_result()
    print(res)


test_gen_ran_num()
end = time.time()
during = end - start
print("during time is:")
print(during)
