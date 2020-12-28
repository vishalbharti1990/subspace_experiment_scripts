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
	println("USAGE: julia run_LMCLUS_arb.jl <reps> <data_dir> <result_dir> [<nprocs>]\n");
	println("\t<reps>       : Number of repetitions");
	println("\t<data_dir>   : Relative path to the synthetic data directory");
	println("\t<result_dir> : Relative path to the result directory");
	exit(0);
end

# Set random number seed
seed = 12345;

# Number of reps
reps = parse(Int64, ARGS[1]);

# Arbitrary Oriented Data dir
data_dir_arb = joinpath(curr_dir, ARGS[2]);

# Arbitrary Oriented Results dir
arbitrary_dir = joinpath(curr_dir, ARGS[3]);
mkpath(arbitrary_dir);

# file to write summarized results for arbitrary datasets
arbitrary_res_file = joinpath(arbitrary_dir, "results.csv");

# Get list of all csv files
data_files = [file for file in readdir(data_dir_arb) if endswith(file, "csv")];

# Run for arbitrary datasets
for (i, data) in enumerate(data_files)

	# file to write result of each rep for the current dataset
	rep_data_file = joinpath(arbitrary_dir, join([split(data,".csv")[1], "_rep_res.csv"]))

	print("\n\nRunning for Dataset ", i, "\n");

	file_name = joinpath(data_dir_arb, data);

	d = readdlm(file_name, ',', header=false);

	x = d[1:(end-1),:];

	normalizeArr(x);

	trueLab = d[end,:];

	n = parse(Int, split(data,'_')[2]);

	params = LMCLUS.Parameters(min(5, n-1));
	params.best_bound = 0.5;

	nArr = zeros(reps, 4);

	stime = time();

	rep_res_df = DataFrame(reps = Int[], nmi_sqrt = Float32[], nmi_min = Float32[],
	 nmi_max = Float32[], nmi_sum = Float32[]);

	print("\nNMI_sqrt NMI_min NMI_max NMI_sum")
	for i=1:reps
		params.random_seed = seed * i;
	    res = lmclus(x, params);
    	predLab = genPredLab(res, length(trueLab));

    	nArr[i,:] = getNMI(freqtable(trueLab,predLab));
    	push!(rep_res_df, [i nArr[i,:]']);
    	print("\nRep ",i, " : ",nArr[i,:]);
	end

	CSV.write(rep_data_file, rep_res_df);

	print("\n");

	run_time = time() - stime;

	data_res = DataFrame(data_name=data, NMI_sqrt_mean=round(mean(nArr[:,1]), digits=2), NMI_sqrt_median=round(median(nArr[:,1]), digits=2), NMI_sqrt_std=round(std(nArr[:,1]), digits=2),
		NMI_min_mean=round(mean(nArr[:,2]), digits=2), NMI_min_median=round(median(nArr[:,2]), digits=2), NMI_min_std=round(std(nArr[:,2]), digits=2),
		NMI_max_mean=round(mean(nArr[:,3]), digits=2), NMI_max_median=round(median(nArr[:,3]), digits=2), NMI_max_std=round(std(nArr[:,3]), digits=2),
		NMI_sum_mean=round(mean(nArr[:,4]), digits=2), NMI_sum_median=round(median(nArr[:,4]), digits=2), NMI_sum_std=round(std(nArr[:,4]), digits=2), rtime=round(run_time, digits=2));

	CSV.write(arbitrary_res_file, data_res; append=true);
end