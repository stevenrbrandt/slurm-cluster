# override IPython's default %%bash to not buffer all output
from IPython.core.magic import register_cell_magic
from time import time, sleep
import os, sys

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

pyver="%d.%d" % (sys.version_info.major, sys.version_info.minor)
# We are going to install kuibit, a Python package to post-process Cactus simulations.
# We will install kuibit inside the Cactus directory. The main reason for this is to
# have a make easier to uninstall kuibit (you can just remove the Cactus folder). 
os.environ["PYTHONUSERBASE"] = f"{home}/Cactus/python"
sys.path.insert(1, f"{os.environ['PYTHONUSERBASE']}/lib/python{pyver}/site-packages")
sys.path.insert(1, f"/usr/local/lib/python{pyver}/site-packages")
os.environ["OMPI_MCA_btl"]="^vader"
