#!/bin/bash

hostname=$(hostname)
echo $hostname
set -e #Exit on error
set -o pipefail #also consider pipe when exiting
rm -rf ./build
source module_file.sh
mkdir build
cd build
if [[ "$hostname" == lassen* ]]; then
PREFIX_PATH=$BENCHMARK_PATH/benchmarks/lammps/install_lassen
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
elif [[ "$hostname" == tioga* ]]; then
PREFIX_PATH=$BENCHMARK_PATH/benchmarks/lammps/install_tioga
cmake \
  -D CMAKE_INSTALL_PREFIX=${PREFIX_PATH} \
  -D CMAKE_BUILD_TYPE=Release \
  -D MPI_CXX_COMPILER=mpicxx \
  -D CMAKE_CXX_COMPILER=hipcc \
  -D PKG_ML-SNAP=yes \
  -D BUILD_MPI=yes \
  -D CMAKE_TUNE_FLAGS="-munsafe-fp-atomics" \
  -D PKG_ML-SNAP=yes \
  -D PKG_GPU=no \
  -D PKG_KOKKOS=yes \
  -D Kokkos_ENABLE_HIP_MULTIPLE_KERNEL_INSTANTIATIONS=yes \
  -D Kokkos_ENABLE_HIP=yes \
  ../cmake
fi
make -j
make install
