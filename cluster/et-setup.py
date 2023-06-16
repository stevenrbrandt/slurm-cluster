# this allows you to use "cd" in cells to change directories instead of requiring "%cd"
%automagic on
# override IPython's default %%bash to not buffer all output
from IPython.core.magic import register_cell_magic
from time import time, sleep
import os
home = os.path.expanduser("~/")
@register_cell_magic
def bash(line, cell):
    get_ipython().system(cell)
@register_cell_magic
def slurm(line, cell):
    with open(f"{home}/.slurm.sh","w") as fd:
        fd.write("if [ ${SLURM_PROCID} != 0 ]; then exit 0; fi\n")
        fd.write(cell)
    get_ipython().system(f"srun {line} bash {home}/.slurm.sh")

# this (non-default package) keeps the end of shell output in view
try: import scrolldown
except ModuleNotFoundError: pass

# We are going to install kuibit, a Python package to post-process Cactus simulations.
# We will install kuibit inside the Cactus directory. The main reason for this is to
# have a make easier to uninstall kuibit (you can just remove the Cactus folder). 
import os, sys
os.environ["PYTHONUSERBASE"] = os.environ['HOME'] + "/Cactus/python"
sys.path.insert(1, f"{os.environ['PYTHONUSERBASE']}/lib/python{sys.version_info[0]}.{sys.version_info[1]}/site-packages")
