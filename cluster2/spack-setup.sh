#!/bin/bash
export SPACK_SKIP_MODULES=1

if [ ! -d "$SPACK_ROOT" ]
then
  git clone https://github.com/spack/spack.git "$SPACK_ROOT"
  #git clone https://github.com/stevenrbrandt/spack.git "$SPACK_ROOT"
  source "$SPACK_ROOT/share/spack/setup-env.sh"
  spack compiler find
else
  source "$SPACK_ROOT/share/spack/setup-env.sh"
fi
