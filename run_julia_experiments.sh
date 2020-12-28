#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "STARTING JULIA EXPERIMENTS..."

echo "Running synthetic dataset experiments..."

# 1. Synthetic datasets

# 1.1 Axis Parallel datasets experiments
julia $CURR_DIR/Julia_scripts/run_LMCLUS_axis.jl 100 ../../subspace_datasets/synthetic_datasets/axis_parallel/col_format ../../Results/synthetic_datasets/axis_parallel/LMCLUS

# 1.2 Arbitrary datasets experiments
julia $CURR_DIR/Julia_scripts/run_LMCLUS_arb.jl 100 ../../subspace_datasets/synthetic_datasets/arbitrary/col_format ../../Results/synthetic_datasets/arbitrary/LMCLUS

echo "Synthetic dataset experiment finished!"

echo "Running real dataset experiments..."

# 2. Real Datasets

# 2.1 Image datasets

echo "COIL-100 dataset experiments started..."

# 2.1.1 COIL-100 dataset
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/coil-100 vgg16_fc2 ../../Results/real_datasets/image_datasets/coil-100/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/coil-100 vgg19_fc2 ../../Results/real_datasets/image_datasets/coil-100/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/coil-100 resnet_avg_pool ../../Results/real_datasets/image_datasets/coil-100/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/coil-100 xception_avg_pool ../../Results/real_datasets/image_datasets/coil-100/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/coil-100 inception_avg_pool ../../Results/real_datasets/image_datasets/coil-100/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/coil-100 efficientnet_avg_pool ../../Results/real_datasets/image_datasets/coil-100/LMCLUS

echo "COIL-100 dataset experiments finished!"

echo "LEGO dataset experiments started.."

# 2.1.2 lego dataset
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/lego vgg16_fc2 ../../Results/real_datasets/image_datasets/lego/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/lego vgg19_fc2 ../../Results/real_datasets/image_datasets/lego/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/lego resnet_avg_pool ../../Results/real_datasets/image_datasets/lego/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/lego xception_avg_pool ../../Results/real_datasets/image_datasets/lego/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/lego inception_avg_pool ../../Results/real_datasets/image_datasets/lego/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/lego efficientnet_avg_pool ../../Results/real_datasets/image_datasets/lego/LMCLUS

echo "LEGO dataset experiments finished!"

echo "FRUITS dataset experiments started"

# 2.1.3 fruits dataset
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/fruits vgg16_fc2 ../../Results/real_datasets/image_datasets/fruits/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/fruits vgg19_fc2 ../../Results/real_datasets/image_datasets/fruits/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/fruits resnet_avg_pool ../../Results/real_datasets/image_datasets/fruits/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/fruits xception_avg_pool ../../Results/real_datasets/image_datasets/fruits/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/fruits inception_avg_pool ../../Results/real_datasets/image_datasets/fruits/LMCLUS
julia $CURR_DIR/Julia_scripts/run_LMCLUS_image.jl 10 ../../subspace_datasets/real_datasets/image_datasets/fruits efficientnet_avg_pool ../../Results/real_datasets/image_datasets/fruits/LMCLUS

echo "FRUITS dataset experiments finished!"


# 2.2 Anuran calls dataset

echo "ANURAN CALLS dataset experiment started..."

julia $CURR_DIR/Julia_scripts/run_LMCLUS_anuran.jl 100 ../../subspace_datasets/real_datasets/anuran_calls_dataset ../../Results/real_datasets/anuran_calls_dataset/LMCLUS

echo "ANURAN CALLS dataset experiment finished!"