#!/bin/bash
#Kripke does not support latest version of CUDA/12 and hence to use older version of GCC. 
#Also need to change the host-configs/llnl-blueos-V100-nvcc-gcc.cmake
PREFIX_PATH=$BENCHMARK_PATH/benchmarks/lammps/install_lassen
set -e #Exit on error
set -o pipefail #also consider pipe when exiting
source module_file.sh
mkdir build
cd build
cmake \
  -D CMAKE_INSTALL_PREFIX=${PREFIX_PATH} \
  -D Kokkos_ARCH_VOLTA70=ON \
  -D CMAKE_BUILD_TYPE=Release \
  -D MPI_CXX_COMPILER=mpicxx \
  -D BUILD_MPI=yes \
  -D CMAKE_CXX_COMPILER=$PWD/../lib/kokkos/bin/nvcc_wrapper \
  -D PKG_ML-SNAP=yes \
  -D PKG_GPU=no \
  -D PKG_KOKKOS=yes \
  -D Kokkos_ENABLE_CUDA=yes \
  ../cmake
make -j
make install
