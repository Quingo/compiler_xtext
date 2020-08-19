from qgrtsys.if_host.python import *
import time
if_quingo = If_Quingo()

if_quingo.call_quingo("kernel.qu", 'qft')
res = if_quingo.read_result()
