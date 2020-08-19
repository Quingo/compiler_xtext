from qgrtsys.if_host.python import *

if_quingo = If_Quingo()


def gen_ran_num():
    if_quingo.call_quingo("kernel.qu", 'random')
    res = if_quingo.read_result()
    print(res)


gen_ran_num()
