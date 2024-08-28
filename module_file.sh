#!/bin/bash
hostname=$(hostname)
if [[ "$hostname" == lassen* ]]; then
module load cuda/12.2
module load gcc/12
module load cmake/3.29
elif [[ "$hostname" == tioga* ]]; then
module load rocm/6.0.3 
module load rocmcc/6.0.3-cce-17.0.1-magic
fi
