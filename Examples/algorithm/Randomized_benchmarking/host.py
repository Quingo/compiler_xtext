from qgrtsys.if_host.python import *
import time
if_quingo = If_Quingo()
start = time.time()
if_quingo.call_quingo("kernel.qu", "Randomized_benchmarking")
res = if_quingo.read_result()
print(res)
end = time.time()
during = end - start
print("during time is:")
print(during)
