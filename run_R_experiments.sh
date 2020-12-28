#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "STARTING R EXPERIMENTS..."

echo "Running synthetic dataset experiments..."

# 1. Synthetic datasets

echo "Started running CLIQUE algorithm..."
# 1.1 CLIQUE algorithm
Rscript $CURR_DIR/R_scripts/synthetic_data/run_CLIQUE.R $CURR_DIR/../subspace_datasets/synthetic_datasets $CURR_DIR/../Results/synthetic_datasets
echo "CLIQUE algorithm finished!"

echo "Started running PROCLUS algorithm..."
# 1.2 PROCLUS algorithm
Rscript $CURR_DIR/R_scripts/synthetic_data/run_PROCLUS.R $CURR_DIR/../subspace_datasets/synthetic_datasets $CURR_DIR/../Results/synthetic_datasets
echo "PROCLUS algorithm finished!"

echo "Started running SUBCLU algorithm..."
# 1.3 SUBCLU algorithm
Rscript $CURR_DIR/R_scripts/synthetic_data/run_SUBCLU.R $CURR_DIR/../subspace_datasets/synthetic_datasets $CURR_DIR/../Results/synthetic_datasets
echo "SUBCLU algorithm finished!"

echo "Started running ORCLUS algorithm..."
# 1.4 ORCLUS algorithm
Rscript $CURR_DIR/R_scripts/synthetic_data/run_ORCLUS.R $CURR_DIR/../subspace_datasets/synthetic_datasets $CURR_DIR/../Results/synthetic_datasets
echo "ORCLUS algorithm finished!"

echo "Synthetic dataset experiment finished!"


echo "Running real dataset experiments..."

# 2. Real datasets

echo "ANURAN CALLS dataset experiment started..."
# 2.1 Anuran calls datasets

echo "Started running CLIQUE algorithm..."
# 2.1.1 CLIQUE ALGORITHM
Rscript $CURR_DIR/R_scripts/real_data/Anuran_calls_data/run_CLIQUE.R $CURR_DIR/../subspace_datasets/real_datasets/anuran_calls_dataset $CURR_DIR/../Results/real_datasets/anuran_calls_dataset 100
echo "CLIQUE algorithm finished!"

echo "Started running PROCLUS algorithm..."
# 2.1.2 PROCLUS ALGORITHM
Rscript $CURR_DIR/R_scripts/real_data/Anuran_calls_data/run_PROCLUS.R $CURR_DIR/../subspace_datasets/real_datasets/anuran_calls_dataset $CURR_DIR/../Results/real_datasets/anuran_calls_dataset 100
echo "PROCLUS algorithm finished!"

echo "Started running SUBCLU algorithm..."
# 2.1.3 SUBCLU ALGORITHM
Rscript $CURR_DIR/R_scripts/real_data/Anuran_calls_data/run_SUBCLU.R $CURR_DIR/../subspace_datasets/real_datasets/anuran_calls_dataset $CURR_DIR/../Results/real_datasets/anuran_calls_dataset 100
echo "SUBCLU algorithm finished!"

echo "Started running ORCLUS algorithm..."
# 2.1.4 ORCLUS ALGORITHM
Rscript $CURR_DIR/R_scripts/real_data/Anuran_calls_data/run_ORCLUS.R $CURR_DIR/../subspace_datasets/real_datasets/anuran_calls_dataset $CURR_DIR/../Results/real_datasets/anuran_calls_dataset 100
echo "ORCLUS algorithm finished!"

echo "ANURAN CALLS dataset experiment finished!"


# 2.2 Image Datasets
# echo "Image datasets experiments started..."

# echo "Started running CLIQUE algorithm..."
# 2.1.1 CLIQUE ALGORITHM
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_CLIQUE.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets coil-100 $CURR_DIR/../Results/real_datasets/image_datasets 10
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_CLIQUE.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets lego $CURR_DIR/../Results/real_datasets/image_datasets 10
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_CLIQUE.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets fruits $CURR_DIR/../Results/real_datasets/image_datasets 10
# echo "CLIQUE algorithm finished!"

# echo "Started running PROCLUS algorithm..."
# 2.1.2 PROCLUS ALGORITHM
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_PROCLUS.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets coil-100 $CURR_DIR/../Results/real_datasets/image_datasets 10
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_PROCLUS.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets lego $CURR_DIR/../Results/real_datasets/image_datasets 10
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_PROCLUS.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets fruits $CURR_DIR/../Results/real_datasets/image_datasets 10
# echo "PROCLUS algorithm finished!"

# echo "Started running SUBCLU algorithm..."
# 2.1.3 SUBCLU ALGORITHM
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_SUBCLU.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets coil-100 $CURR_DIR/../Results/real_datasets/image_datasets 10
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_SUBCLU.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets lego $CURR_DIR/../Results/real_datasets/image_datasets 10
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_SUBCLU.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets fruits $CURR_DIR/../Results/real_datasets/image_datasets 10
# echo "SUBCLU algorithm finished!"

# echo "Started running ORCLUS algorithm..."
# 2.1.4 ORCLUS ALGORITHM
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_ORCLUS.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets coil-100 $CURR_DIR/../Results/real_datasets/image_datasets 10
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_ORCLUS.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets lego $CURR_DIR/../Results/real_datasets/image_datasets 10
# Rscript $CURR_DIR/R_scripts/real_data/Image_data/run_ORCLUS.R $CURR_DIR/../subspace_datasets/real_datasets/image_datasets fruits $CURR_DIR/../Results/real_datasets/image_datasets 10
# echo "ORCLUS algorithm finished!"

# echo "Image datasets experiments finished!"