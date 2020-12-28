#!/bin/bash

# Install deps
sudo apt update
sudo apt install build-essential libatomic1 python gfortran perl wget m4 cmake git-core pkg-config curl wget libblas-dev liblapack-dev

# Download julia 1.0.5 src
# wget https://github.com/JuliaLang/julia/releases/download/v1.0.5/julia-1.0.5-full.tar.gz
# tar -xf julia-1.0.5-full.tar.gz
# cd julia-1.0.5
# make -j 4
# make -j 4 install

# Download pre-compiled julia debian binary
wget https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.5-linux-x86_64.tar.gz
tar zxvf julia-1.0.5-linux-x86_64.tar.gz

# Add julia to path
PATH="$HOME/julia-1.0.5/bin:$PATH"
export PATH

# Install R
cd ~
sudo apt install dirmngr apt-transport-https ca-certificates software-properties-common gnupg2
sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian stretch-cran35/'
sudo apt install r-base


# Install Julia packages and dependencies
julia -e 'using Pkg; Pkg.add("https://github.com/wildart/LMCLUS.jl.git"); Pkg.add("FreqTables"); Pkg.add("DataFrames"); Pkg.add("CSV"); Pkg.add("PyCall")'
# numpy used by PyCall
python3 -m pip install numpy

# Java setup for R packages
sudo apt-get update
sudo apt-get install default-jre
sudo apt-get install default-jdk
sudo apt-get install r-cran-rjava
sudo R CMD javareconf

# Install R packages
sudo R -e 'install.packages(c("tictoc","subspace","orclus"), repos="http://cran.rstudio.com/")'

# Get datasets
git clone https://bitbucket.org/vrbharti1990/subspace_datasets.git