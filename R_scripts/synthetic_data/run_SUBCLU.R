## SCRIPT TO RUN SUBCLU CLUSTERING ON SYNTHETIC DATASET
library(subspace)
library(tictoc)

set.seed(12345)

# include get_NMI.R script
source('./get_NMI.R')

args <- commandArgs(trailingOnly = TRUE)

cat(args, "\n")

if(length(args) != 3) {
  cat("USAGE: Rscript run_SUBCLU.R <data_root_dir> <result_root_dir> <reps>\n")
  cat("<data_root_dir>   : Root directory for the synthetic data. axis_parallel and arbitrary directory are assumed to be inside this directory\n")
  cat("<result_root_dir> : Root directory for the results. Results are save in axis_parallel and arbitrary sub directories\n")
  cat("<reps>            : Number of repetitions\n")
  q()
}

data_dir_axis_parallel <- file.path(args[1], 'axis_parallel/row_format')

data_dir_arbitrary     <- file.path(args[1], 'arbitrary/row_format')

result_axis_par_file   <- file.path(args[2], 'axis_parallel/SUBCLU/results.csv')

result_arbitrary_file  <- file.path(args[2], 'arbitrary/SUBCLU/results.csv')

# Create result dir if not already existing
dir.create(file.path(args[2], 'axis_parallel/SUBCLU'), showWarnings = F, recursive = T)
dir.create(file.path(args[2], 'arbitrary/SUBCLU'), showWarnings = F, recursive = T)

reps <- strtoi(args[3])

data_axis_parallel     <- list.files(data_dir_axis_parallel, pattern="*.csv", full.names=TRUE)

data_arbitrary         <- list.files(data_dir_arbitrary, pattern="*.csv", full.names=TRUE)

# Write header to result file
write.table(list("Dataset Name", "NMI sqrt", "NMI min", "NMI max", "NMI sum", "Avg time"), result_axis_par_file, row.names = F, col.names = F, sep = ',')

data_cnt = 1

cat("RUNNING SUBCLU FOR AXIS PARALLEL DATASET..\n")

# loop through the datasets and run the CLIQUE algorithm
for (data_file in data_axis_parallel) {
  
  data <- read.csv(data_file, header = FALSE)
  
  # extract file name from path
  f_name <- strsplit(data_file, '/')[[1]]
  
  # extract the true cluster indices
  lab <- data[,ncol(data)]
  
  # extract the data
  data <- data[,1:ncol(data)-1]
  
  # min-max normalize the data
  data <- apply(t(data), 1, function(x)(x-min(x))/(max(x)-min(x)))

  # arrays to store the results for current dataset
  NMI_sqrt = array(data = 0, dim = reps)
  NMI_min  = array(data = 0, dim = reps)
  NMI_max  = array(data = 0, dim = reps)
  NMI_sum  = array(data = 0, dim = reps)
  
  cat("Running for dataset", data_cnt, "\n")
  
  tic()
  
  for (k in 1:reps) {
    
    # run the SUBCLU algorithm
    res <- SubClu(data, epsilon = 2, minSupport = 8)
    
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
  f_name <- strsplit(data_file, '/')[[1]]
  
  # result for current dataset
  data_res <- list(f_name[length(f_name)], res_nmi_sqrt, res_nmi_min, res_nmi_max, res_nmi_sum, avg_time)
  
  # Write it to the results file
  write.table(data_res, result_axis_par_file, row.names = F, col.names = F, sep = ',', append = T)
  
  data_cnt = data_cnt + 1
  
}

write.table(list("Dataset Name", "NMI sqrt", "NMI min", "NMI max", "NMI sum", "Avg time"), result_arbitrary_file, row.names = F, col.names = F, sep = ',')

cat("\nRUNNING SUBCLU FOR ARBITRARY ORIENTED DATASET..\n")

data_cnt = 1

# loop through the datasets and run the CLIQUE algorithm
for (data_file in data_arbitrary) {
  
  data <- read.csv(data_file, header = FALSE)
  
  # extract file name from path
  f_name <- strsplit(data_file, '/')[[1]]
  
  # extract the true cluster indices
  lab <- data[,ncol(data)]
  
  # extract the data
  data <- data[,1:ncol(data)-1]
  
  # min-max normalize the data
  data <- apply(t(data), 1, function(x)(x-min(x))/(max(x)-min(x)))
  
  # arrays to store the results for current dataset
  NMI_sqrt = array(data = 0, dim = reps)
  NMI_min  = array(data = 0, dim = reps)
  NMI_max  = array(data = 0, dim = reps)
  NMI_sum  = array(data = 0, dim = reps)
  
  cat("Running for dataset", data_cnt, "\n")
  
  tic()
  
  for (k in 1:reps) {
    
    # run the SUBCLU algorithm
    res <- SubClu(data, epsilon = 2, minSupport = 8)
    
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
  data_res <- list(f_name[length(f_name)], res_nmi_sqrt, res_nmi_min, res_nmi_max, res_nmi_sum, avg_time)
  
  # Write it to the results file
  write.table(data_res, result_arbitrary_file, row.names = F, col.names = F, sep = ',', append = T)
  
  data_cnt = data_cnt + 1
  
}

