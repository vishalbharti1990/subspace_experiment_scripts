using LMCLUS
using FreqTables
using DataFrames
using CSV
using DelimitedFiles
using Statistics

include("NMI.jl")
include("genPredLab.jl")
include("normalize.jl")

curr_dir = @__DIR__;

if length(ARGS) != 3
	println("USAGE: julia run_LMCLUS_anuran.jl <reps> <data_dir> <result_dir> [<nprocs>]\n");
	println("\t<reps>       : Number of repetitions");
	println("\t<data_path>  : Relative path to Anuran Calls data 'Frogs_MFCCs.csv'");
	println("\t<result_dir> : Relative path to the result directory");
	exit(0);
end

# Set random number seed
seed = 12345;

# Number of reps
reps = parse(Int64, ARGS[1]);

# Arbitrary Oriented Data dir
data_csv_path = joinpath(curr_dir, ARGS[2], "Frogs_MFCCs.csv");

# Arbitrary Oriented Results dir
results_dir = joinpath(curr_dir, ARGS[3]);
mkpath(results_dir);

# file to write summarized results for arbitrary datasets
res_file = joinpath(results_dir, "results.csv");

# read data from csv file
data_csv = readdlm(data_csv_path, ',', skipstart=1);
X = data_csv[:,1:22]';
X = convert(Array{Float64}, X);

# min-max normalize
normalizeArr(X);
# replace NaNs with 0
replace!(X, NaN=>0);

# Extract the labels
true_species = data_csv[:,end-1];
true_genus = data_csv[:,end-2];
true_families = data_csv[:,end-3];

# Initialize params
params = LMCLUS.Parameters(10);
params.best_bound = 0.1;

rep_res_df_spec = DataFrame(reps = Int[], nmi_sqrt = Float32[], nmi_min = Float32[],
 nmi_max = Float32[], nmi_sum = Float32[]);
rep_res_df_gen  = DataFrame(reps = Int[], nmi_sqrt = Float32[], nmi_min = Float32[],
 nmi_max = Float32[], nmi_sum = Float32[]);
rep_res_df_fam  = DataFrame(reps = Int[], nmi_sqrt = Float32[], nmi_min = Float32[],
 nmi_max = Float32[], nmi_sum = Float32[]);

nArr_spec = zeros(reps, 4);
nArr_gen  = zeros(reps, 4);
nArr_fam  = zeros(reps, 4);

stime = time();

rep_data_file_spec = joinpath(results_dir, "anuran_species_rep.csv");
rep_data_file_gen  = joinpath(results_dir, "anuran_genus_rep.csv");
rep_data_file_fam  = joinpath(results_dir, "anuran_families_rep.csv");

for i=1:reps
	params.random_seed = seed * i;
    res = lmclus(X, params);
	predLab = assignments(res);

	nArr_spec[i,:] = getNMI(freqtable(true_species, predLab));
	nArr_gen[i,:]  = getNMI(freqtable(true_genus, predLab));
	nArr_fam[i,:]  = getNMI(freqtable(true_families, predLab));

	push!(rep_res_df_spec, [i nArr_spec[i,:]']);
	push!(rep_res_df_gen, [i nArr_gen[i,:]']);
	push!(rep_res_df_fam, [i nArr_fam[i,:]']);
	print("\nRep ",i, " : ", nArr_spec[i,:], nArr_gen[i,:], nArr_fam[i,:]);
end

CSV.write(rep_data_file_spec, rep_res_df_spec);
CSV.write(rep_data_file_gen, rep_res_df_gen);
CSV.write(rep_data_file_fam, rep_res_df_fam);

print("\n");

run_time = time() - stime;

data_res_spec = DataFrame(data_name="Anuran_species", NMI_sqrt_mean=round(mean(nArr_spec[:,1]), digits=2), NMI_sqrt_median=round(median(nArr_spec[:,1]), digits=2), NMI_sqrt_std=round(std(nArr_spec[:,1]), digits=2),
	NMI_min_mean=round(mean(nArr_spec[:,2]), digits=2), NMI_min_median=round(median(nArr_spec[:,2]), digits=2), NMI_min_std=round(std(nArr_spec[:,2]), digits=2),
	NMI_max_mean=round(mean(nArr_spec[:,3]), digits=2), NMI_max_median=round(median(nArr_spec[:,3]), digits=2), NMI_max_std=round(std(nArr_spec[:,3]), digits=2),
	NMI_sum_mean=round(mean(nArr_spec[:,4]), digits=2), NMI_sum_median=round(median(nArr_spec[:,4]), digits=2), NMI_sum_std=round(std(nArr_spec[:,4]), digits=2), rtime=round(run_time, digits=2));

CSV.write(res_file, data_res_spec; append=true);

data_res_gen = DataFrame(data_name="Anuran_genus", NMI_sqrt_mean=round(mean(nArr_gen[:,1]), digits=2), NMI_sqrt_median=round(median(nArr_gen[:,1]), digits=2), NMI_sqrt_std=round(std(nArr_gen[:,1]), digits=2),
	NMI_min_mean=round(mean(nArr_gen[:,2]), digits=2), NMI_min_median=round(median(nArr_gen[:,2]), digits=2), NMI_min_std=round(std(nArr_gen[:,2]), digits=2),
	NMI_max_mean=round(mean(nArr_gen[:,3]), digits=2), NMI_max_median=round(median(nArr_gen[:,3]), digits=2), NMI_max_std=round(std(nArr_gen[:,3]), digits=2),
	NMI_sum_mean=round(mean(nArr_gen[:,4]), digits=2), NMI_sum_median=round(median(nArr_gen[:,4]), digits=2), NMI_sum_std=round(std(nArr_gen[:,4]), digits=2), rtime=round(run_time, digits=2));

CSV.write(res_file, data_res_gen; append=true);

data_res_fam = DataFrame(data_name="Anuran_families", NMI_sqrt_mean=round(mean(nArr_fam[:,1]), digits=2), NMI_sqrt_median=round(median(nArr_fam[:,1]), digits=2), NMI_sqrt_std=round(std(nArr_fam[:,1]), digits=2),
	NMI_min_mean=round(mean(nArr_fam[:,2]), digits=2), NMI_min_median=round(median(nArr_fam[:,2]), digits=2), NMI_min_std=round(std(nArr_fam[:,2]), digits=2),
	NMI_max_mean=round(mean(nArr_fam[:,3]), digits=2), NMI_max_median=round(median(nArr_fam[:,3]), digits=2), NMI_max_std=round(std(nArr_fam[:,3]), digits=2),
	NMI_sum_mean=round(mean(nArr_fam[:,4]), digits=2), NMI_sum_median=round(median(nArr_fam[:,4]), digits=2), NMI_sum_std=round(std(nArr_fam[:,4]), digits=2), rtime=round(run_time, digits=2));

CSV.write(res_file, data_res_fam; append=true);