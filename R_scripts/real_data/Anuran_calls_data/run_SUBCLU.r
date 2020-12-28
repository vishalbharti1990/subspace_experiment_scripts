## SCRIPT TO RUN SUBCLU CLUSTERING ON ANURAN CALLS DATASET
library(subspace)
library(tictoc)

set.seed(12345)

# include get_NMI.R script
source('./get_NMI.R')

args <- commandArgs(trailingOnly = TRUE)

cat(args, "\n")

if(length(args) != 3) {
  cat("USAGE: Rscript run_SUBCLU.R <data_dir> <result_root_dir> <reps>\n")
  cat("<data_dir>        : Data directory for anuran calls data csv\n")
  cat("<result_root_dir> : Root directory for the results.\n")
  cat("<reps>            : Number of repetitions\n")
  q()
}

data_file <- file.path(args[1], 'Frogs_MFCCs.csv')

res_anuran_data_file <- file.path(args[2], 'SUBCLU/results.csv')

# Create result dir if not already existing
dir.create(file.path(args[2], 'SUBCLU'), showWarnings = F, recursive = T)

reps <- strtoi(args[3])

data <- read.csv(data_file, header = T)

# extract species, genus and families labels
true_species  <- data[, ncol(data)-1]
true_genus    <- data[, ncol(data)-2]
true_families <- data[, ncol(data)-3]

# Extract the data
X <- data[, 1:22]

# Min-max normalize the data
X <- apply(t(X), 1, function(x)(x-min(x))/(max(x)-min(x)))

# Replace NA's with 0
X[is.na(X)] <- 0

# arrays to store the NMI_sqrt results
NMI_sqrt_species  = array(data = 0, dim = reps)
NMI_sqrt_genus    = array(data = 0, dim = reps)
NMI_sqrt_families = array(data = 0, dim = reps)

# arrays to store the NMI_min results
NMI_min_species  = array(data = 0, dim = reps)
NMI_min_genus    = array(data = 0, dim = reps)
NMI_min_families = array(data = 0, dim = reps)

# arrays to store the NMI_max results
NMI_max_species  = array(data = 0, dim = reps)
NMI_max_genus    = array(data = 0, dim = reps)
NMI_max_families = array(data = 0, dim = reps)

# arrays to store the NMI_sum results
NMI_sum_species  = array(data = 0, dim = reps)
NMI_sum_genus    = array(data = 0, dim = reps)
NMI_sum_families = array(data = 0, dim = reps)

write.table(list("Class type","NMI sqrt", "NMI min", "NMI max", "NMI sum", "Avg time"), res_anuran_data_file, row.names = F, col.names = F, sep = ',')

tic()

for (k in 1:reps) {
  
  # run the CLIQUE algorithm
  res <- SubClu(X, epsilon = 1, minSupport = 8)
  
  # initialize predLab array
  predLab <- array(data=0, dim=dim(X)[1])
  
  # generate predicted labels from clustering result 
  for(i in 1:length(res)){ predLab[res[[i]]$objects] = i}
  
  # contingency matrix
  t_species  <- table(true_species, predLab)
  t_genus    <- table(true_genus, predLab)
  t_families <- table(true_families, predLab)
  
  # get NMI values for each label type
  nmi_species  <- get_NMI(t_species)
  nmi_genus    <- get_NMI(t_genus)
  nmi_families <- get_NMI(t_families)
  
  # save NMI_sqrt values
  NMI_sqrt_species[k]  = nmi_species[1]
  NMI_sqrt_genus[k]    = nmi_genus[1]
  NMI_sqrt_families[k] = nmi_families[1]
  
  # save NMI_min values
  NMI_min_species[k]  = nmi_species[2]
  NMI_min_genus[k]    = nmi_genus[2]
  NMI_min_families[k] = nmi_families[2]
  
  # save NMI_max values
  NMI_max_species[k]  = nmi_species[3]
  NMI_max_genus[k]    = nmi_genus[3]
  NMI_max_families[k] = nmi_families[3]  
  
  # save NMI_sum values
  NMI_sum_species[k]  = nmi_species[4]
  NMI_sum_genus[k]    = nmi_genus[4]
  NMI_sum_families[k] = nmi_families[4]
  
  cat("Reps =", k, "\n")
}

toc_obj = toc()

avg_time = (toc_obj$toc - toc_obj$tic)[[1]]

# species class results
res_nmi_sqrt_species <- paste(mean(NMI_sqrt_species), median(NMI_sqrt_species), sd(NMI_sqrt_species), sep = ' ')
res_nmi_min_species  <- paste(mean(NMI_min_species), median(NMI_min_species), sd(NMI_min_species), sep = ' ')
res_nmi_max_species  <- paste(mean(NMI_max_species), median(NMI_max_species), sd(NMI_max_species), sep = ' ')
res_nmi_sum_species  <- paste(mean(NMI_sum_species), median(NMI_sum_species), sd(NMI_sum_species), sep = ' ')

# genus class results
res_nmi_sqrt_genus <- paste(mean(NMI_sqrt_genus), median(NMI_sqrt_genus), sd(NMI_sqrt_genus), sep = ' ')
res_nmi_min_genus  <- paste(mean(NMI_min_genus), median(NMI_min_genus), sd(NMI_min_genus), sep = ' ')
res_nmi_max_genus  <- paste(mean(NMI_max_genus), median(NMI_max_genus), sd(NMI_max_genus), sep = ' ')
res_nmi_sum_genus  <- paste(mean(NMI_sum_genus), median(NMI_sum_genus), sd(NMI_sum_genus), sep = ' ')

# families class results
res_nmi_sqrt_families <- paste(mean(NMI_sqrt_families), median(NMI_sqrt_families), sd(NMI_sqrt_families), sep = ' ')
res_nmi_min_families  <- paste(mean(NMI_min_families), median(NMI_min_families), sd(NMI_min_families), sep = ' ')
res_nmi_max_families  <- paste(mean(NMI_max_families), median(NMI_max_families), sd(NMI_max_families), sep = ' ')
res_nmi_sum_families  <- paste(mean(NMI_sum_families), median(NMI_sum_families), sd(NMI_sum_families), sep = ' ')

# Structure results to write
nmi_res_species  <- list("SPECIES", res_nmi_sqrt_species, res_nmi_min_species, res_nmi_max_species, res_nmi_sum_species, avg_time)
nmi_res_genus    <- list("GENUS", res_nmi_sqrt_genus, res_nmi_min_genus, res_nmi_max_genus, res_nmi_sum_genus, avg_time)
nmi_res_families <- list("FAMILIES", res_nmi_sqrt_families, res_nmi_min_families, res_nmi_max_families, res_nmi_sum_families, avg_time)

# Write it to the results file
write.table(nmi_res_species, res_anuran_data_file, row.names = F, col.names = F, sep = ',', append = T)
write.table(nmi_res_genus, res_anuran_data_file, row.names = F, col.names = F, sep = ',', append = T)
write.table(nmi_res_families, res_anuran_data_file, row.names = F, col.names = F, sep = ',', append = T)