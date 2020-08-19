import os.path
from qgrtsys.if_host.python import *

if_quingo = If_Quingo()

def test_repetition_code():
	dir_path = os.path.dirname(os.path.realpath(__file__))
	kernel_file = dir_path + r"\kernel.qu"
	if_quingo.call_quingo(kernel_file, 'repetitionCode')
	res = if_quingo.read_result()
	print(res)
	assert(res == [False, False, False])

test_repetition_code()