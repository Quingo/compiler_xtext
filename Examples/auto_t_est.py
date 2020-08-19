from os import listdir
from os.path import isfile, join, isdir
import termcolor as tc
import subprocess
import os

from qgrtsys.if_backend.cactus.cactus_quantumsim import *
"""
from qgrtsys.core.manager import *
from qgrtsys.core.data_transfer import *
"""
import logging

log = logging.getLogger(__name__)


def error_msg(arg):
    """Show failed information during testing """
    log.warning(arg)


def debug_msg(arg):
    """Show debug infromation during testing"""
    log.info(arg)


def multi_host(exp, host):
    """Check if there are more than one host program in the Quingo project
    exp:name of Quingo project in this directory
    host:name of the host program in this example
    """
    error_flag = False
    if (len(host) > 1):
        error_flag = True
        error_msg("Multi host in " + exp)
    return error_flag


def failed_example_exist(exp_list):
    failed_exist = False
    if(exp_list is not None):
        failed_exist = True

    return failed_exist


def test_convert():
    """Main test function in this test module"""
    # get Quingo projects in current directory
    onlyfiles = [f for f in listdir() if isdir(f)]
    # get current directory
    path = os.getcwd()
    tested_exp_num = 0
    passed_exp_num = 0
    failed_exp_num = 0
    failed_exp = []

    for exp in onlyfiles:
        # get host files in one example
        host = [f for f in listdir(exp) if isfile(
            join(exp, f)) and f.endswith('.py')]

        if(len(host) > 0):
            debug_msg("Start testing program " + exp)
            tested_exp_num += 1
            # check if there are multi hosts
            if(multi_host(exp, host)):
                failed_exp_num += 1
                failed_exp.append(exp)
            else:
                for f in host:
                    # check if the program can be executed properly
                    error_flag = execute(path, exp, f)
                    if(error_flag):
                        failed_exp_num += 1
                        failed_exp.append(exp)
                    else:
                        passed_exp_num += 1

    debug_msg("Testing finish, " + str(tested_exp_num) + " examples tested. passed: " +
              str(passed_exp_num) + ". failed: " + str(failed_exp_num))

    if (len(failed_exp) > 0):
        error_msg("failed examples are:" + str(failed_exp))

    assert(failed_example_exist(failed_exp) == False)


def execute(path, exp, f):
    """execute a Quingo project and return if the project is executed successfully
    Input:
        path: current directory
        exp: name of Quingo project in this directory
        f: name of the host name of the project
    Return:
        error_flag:flag to indicate if the program is executed successfully
    """
    error_flag = False
    host_dir = path + "\\" + exp
    # change current directory to tested Quingo project directory
    os.chdir(host_dir)

    python_str = "python "
    python_cmd = python_str + f
    # execute the project use qgrtsys
    subprocess.call(python_cmd, shell=True)

    backend = Cactus_quantumsim()

    build_path = r"build"
    # check if the "build" directory is generated
    if(os.path.exists(build_path)):
        # find output result files in build directory
        bin_files = [f for f in listdir(build_path) if isfile(
            join(build_path, f) and f.endswith('.bin'))]
        # check if there are only one bin file
        if(len(bin_files) > 1):
            error_flag = True
            error_msg("Multi bin files in program " + exp)
        elif(len(bin_files) < 1):
            error_flag = True
            error_msg(
                "Cactus failed to execute eQASM in program " + exp)
        else:
            # try to read bin files
            for f in bin_files:
                backend.ret_file_path = build_path + "\\" + f
                try:
                    backend.read_result()
                    #debug_msg("Executing result of " + exp + " is " + str(result))
                except:
                    error_flag = True
                    error_msg("Failed to read result from program " + exp)
                # remove bin file to prevent affecting next test
                os.remove(backend.ret_file_path)

    else:
        error_flag = True
        error_msg("Compile error in program " + exp)
    # back to upper path
    os.chdir(path)
    return error_flag
