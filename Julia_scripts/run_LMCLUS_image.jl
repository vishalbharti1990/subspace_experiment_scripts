using LMCLUS
using FreqTables
using DataFrames
using CSV
using DelimitedFiles
using Statistics
using PyCall
pickle = pyimport("pickle");

include("NMI.jl")
include("genPredLab.jl")
include("normalize.jl")

curr_dir = @__DIR__;

function unpickle(filename)
    r = nothing
    @pywith pybuiltin("open")(filename,"rb") as f begin
        r = pickle.load(f)
    end
    return r
end

function load_pkl_features(data_dir, data_shape)
	data = zeros(data_shape);
	println("Loading data features..")
	p_stat = 0.1;
	for i=1:data_shape[2]
		if (i+1)/data_shape[2] == p_stat
			println((i+1), "/", data_shape[2]);
			p_stat = round(p_stat + 0.1, digits=1);
		end
		data[:, i] = unpickle(joinpath(data_dir, join([string(i-1) ".p"])));
	end
	println("Loaded ", data_shape[2], " points..")
	return data
end

if length(ARGS) != 4
	println("USAGE: julia run_LMCLUS_image.jl <reps> <data_dir> <result_dir> [<nprocs>]\n");
	println("\t<reps>       : Number of repetitions");
	println("\t<data_dir>   : Relative path to the image features data directory");
	println("\t<arch_layer> : Architecture and layer for the feature to be used")
	println("\t<result_dir> : Relative path to the result directory");
	exit(0);
end


# Set random number seed
seed = 12345;

# Number of reps
reps = parse(Int64, ARGS[1]);

# Arbitrary Oriented Data dir
data_dir = joinpath(curr_dir, ARGS[2], ARGS[3]);

# Arbitrary Oriented Results dir
results_dir = joinpath(curr_dir, ARGS[4], ARGS[3]);
mkpath(results_dir);

# file to write summarized results for arbitrary datasets
res_file = joinpath(results_dir, "results.csv");

# Get list of all features from pickle files
data_files = [joinpath(data_dir, file) for file in readdir(data_dir) if endswith(file, ".p")];
data_size = length(data_files);

if data_size == 0
	println("ERROR: No data found in data directory...");
	exit(0);
end

feature_size = length(unpickle(data_files[1]));
data_shape = (feature_size, data_size);

println("Data shape : ", data_shape);

data = load_pkl_features(data_dir, data_shape);

# min-max normalize
normalizeArr(data);
# replace NaNs with 0
replace!(data, NaN=>0);

# Read true labels
trueLab = readdlm(joinpath(curr_dir, ARGS[2], "true_labels.txt"));

# Initialize params
params = LMCLUS.Parameters(5);
params.best_bound = 0.1;

rep_res_df = DataFrame(reps = Int[], nmi_sqrt = Float32[], nmi_min = Float32[],
 nmi_max = Float32[], nmi_sum = Float32[]);

nArr = zeros(reps, 4);

stime = time();

rep_data_file = joinpath(results_dir, join([ARGS[3] "_rep.csv"]));

print("\nNMI_sqrt NMI_min NMI_max NMI_sum")
for i=1:reps
	params.random_seed = seed * i;
    res = lmclus(data, params);
	predLab = genPredLab(res, length(trueLab));

	nArr[i,:] = getNMI(freqtable(trueLab[:],predLab));
	push!(rep_res_df, [i nArr[i,:]']);
	print("\nRep ",i, " : ",nArr[i,:]);
end

CSV.write(rep_data_file, rep_res_df);

print("\n");

run_time = time() - stime;

dname = join([basename(ARGS[2]) "_" ARGS[3]])

data_res = DataFrame(data_name=dname, NMI_sqrt_mean=round(mean(nArr[:,1]), digits=2), NMI_sqrt_median=round(median(nArr[:,1]), digits=2), NMI_sqrt_std=round(std(nArr[:,1]), digits=2),
	NMI_min_mean=round(mean(nArr[:,2]), digits=2), NMI_min_median=round(median(nArr[:,2]), digits=2), NMI_min_std=round(std(nArr[:,2]), digits=2),
	NMI_max_mean=round(mean(nArr[:,3]), digits=2), NMI_max_median=round(median(nArr[:,3]), digits=2), NMI_max_std=round(std(nArr[:,3]), digits=2),
	NMI_sum_mean=round(mean(nArr[:,4]), digits=2), NMI_sum_median=round(median(nArr[:,4]), digits=2), NMI_sum_std=round(std(nArr[:,4]), digits=2), rtime=round(run_time, digits=2));

CSV.write(res_file, data_res; append=true);