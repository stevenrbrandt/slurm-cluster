# override IPython's default %%bash to not buffer all output
import os, sys, inspect
use_magic = os.environ.get("_NO_USE_MAGIC_") is None
if use_magic:
    from IPython.core.magic import register_cell_magic

from time import time, sleep

home = os.path.expanduser("~/")


if use_magic:
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
SPACK_ROOT = "/home/etuser/spack-root"
os.environ["SPACK_ROOT"] = SPACK_ROOT
import sys
#sys.path.insert(1, "/usr/spack-root/var/spack/environments/cactus-tutorial/.spack-env/view/./.spack/openpmd-api/repos/spack_repo/builtin/packages")
sys.path.insert(1, f"{home}/EmitCactus")
sys.path.insert(1, f"{os.environ['PYTHONUSERBASE']}/lib/python{pyver}/site-packages")
sys.path.insert(1, f"/usr/local/lib/python{pyver}/site-packages")
sys.path.insert(1, f"/usr/lib/python3/dist-packages")
sys.path.insert(1, f"/usr/local/lib/python${pyver}/dist-packages")
sys.path.insert(1, f"{SPACK_ROOT}/var/spack/environments/cactus-tutorial/.spack-env/view/local/lib/python3.11/dist-packages")
sys.path.insert(1, f"{SPACK_ROOT}/var/spack/environments/cactus-tutorial/.spack-env/view/lib/python3.11/site-packages")
os.environ["OMPI_MCA_btl"]="^vader"
# Puts us python13
os.environ["PYTHONPATH"] = ":".join(sys.path)
os.environ["PATH"]="/usr/local/bin:/usr/bin:/bin:/usr/spack-root/var/spack/environments/cactus-tutorial/.spack-env/view/bin:"
