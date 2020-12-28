## SCRIPT TO RUN CLIQUE CLUSTERING ON SYNTHETIC DATASET
library(subspace)
library(tictoc)
library(plyr)
library(reticulate)

# include get_NMI.R script
source('./get_NMI.R')

args <- commandArgs(trailingOnly = TRUE)

cat(args, "\n")

if(length(args) != 4) {
  cat("USAGE: Rscript run_CLIQUE.R <data_dir_root> <data_name> <result_root_dir> <reps>\n")
  cat("<result_root_dir> : Root directory for the data.\n")
  cat("<data_name>       : Name of image data\n")
  cat("<result_root_dir> : Root directory for the results.\n")
  cat("<reps>            : Number of repetitions\n")
  q()
}

# Feature pickle directory
data_feats  <- c(file.path(args[1], args[2], 'vgg16_fc2/'), file.path(args[1], args[2], 'vgg19_fc2/'), file.path(args[1], args[2], 'resnet_avg_pool/'), file.path(args[1], args[2], 'inception_avg_pool/'), file.path(args[1], args[2], 'xception_avg_pool/'), file.path(args[1], args[2], 'efficientnet_avg_pool/'))

result_file <-  file.path(args[3], args[2], 'CLIQUE/results.csv')

# Create result dir if not already existing
dir.create(file.path(args[3], args[2], 'CLIQUE'), showWarnings = F, recursive = T)

reps <- strtoi(args[3])

# Write header to result file
write.table(list("Features", "NMI sqrt", "NMI min", "NMI max", "NMI sum", "Avg time"), result_file, row.names = F, col.names = F, sep = ',')

# extract the true cluster indices
lab <- read.delim(file.path(args[1], args[2], 'true_labels.txt'))$X0

cat("RUNNING CLIQUE FOR ", args[2], " DATASET..\n")

num_points <- length(list.files(p, pattern="*\\.p$", full.names=TRUE))

# loop through the datasets and run the CLIQUE algorithm
for (feats in data_feats) {

  pkl_files <- lapply(0:(num_points-1), function(x)(paste(feats, x, '.p', sep="")))
  
  feat_split = strsplit(feats, '/')[[1]]
  
  feat_name <- feat_split[length(feat_split)]
  
  cat("loading data...\n")
  data <- ldply(pkl_files, py_load_object, pickle='pickle', .id = NULL)
  cat('done!\n')
  
  # min-max normalize the data
  data <- apply(t(data), 1, function(x)(x-min(x))/(max(x)-min(x)))

  
  # arrays to store the results for current dataset
  NMI_sqrt = array(data = 0, dim = reps)
  NMI_min  = array(data = 0, dim = reps)
  NMI_max  = array(data = 0, dim = reps)
  NMI_sum  = array(data = 0, dim = reps)
  
  cat("Running for ", feat_name, " features\n")
  
  tic()
  
  for (k in 1:reps) {
    
    # run the CLIQUE algorithm
    res <- CLIQUE(data, xi = 50, tau = 0.5)
    
    # initialize predLab array
    predLab <- array(data=0, dim=dim(data)[1])
    
    # generate predicted labels from clustering result 
    for(i in 1:length(res)){ predLab[res[[i]]$objects] = i}
    
    # contingency matrix
    t<-table(lab, predLab)
    
    nmi <- get_NMI(t)
    
    NMI_sqrt[k] = nmi[1]
    NMI_min[k]  = nmi[2]
    NMI_max[k]  = nmi[3]
    NMI_sum[k]  = nmi[4]
    
    cat("Reps =", k, nmi, "\n")
  }
  
  toc_obj = toc()
  
  avg_time = (toc_obj$toc - toc_obj$tic)[[1]]
  
  res_nmi_sqrt <- paste(mean(NMI_sqrt), median(NMI_sqrt), sd(NMI_sqrt), sep = ' ')
  res_nmi_min  <- paste(mean(NMI_min), median(NMI_min), sd(NMI_min), sep = ' ')
  res_nmi_max  <- paste(mean(NMI_max), median(NMI_max), sd(NMI_max), sep = ' ')
  res_nmi_sum  <- paste(mean(NMI_sum), median(NMI_sum), sd(NMI_sum), sep = ' ')
  
  # result for current dataset
  data_res <- list(feat_name, res_nmi_sqrt, res_nmi_min, res_nmi_max, res_nmi_sum, avg_time)
  
  # Write it to the results file
  write.table(data_res, result_file, row.names = F, col.names = F, sep = ',', append = T)
}


