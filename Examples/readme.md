# Quingo examples Auto test

## Methods
Use pytest for auto test. The introduction of pytest can refer to [website](https://docs.pytest.org/en/latest/). It can help us execute our examples in this directory and subdirectory. The test results will show in terminal.

## Dependence
- Anaconda
- pytest


## Usage
Open terminal and enter this `examples` directory, then input command ```pytest -ra``` and execute, wait and the result will shown . The result is like:

![test_result.jpg](test_result.jpg)


## Some attentions
- Please put your project in an independent folder.
- The host file of your project should contain string `test`, the main host program also needs to be put in a function and the name of the function should start with `test_`. 
- You need to add `assert` statements to check examples' results.
- For dir change during testing, some code should be added in the beginning of your test function. An example is shown as follows.
```python
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
``` 
- Since the execution of a Quingo project takes some time, if there are too many projects in this directory, it is normal to test for a long time, please be patient.
