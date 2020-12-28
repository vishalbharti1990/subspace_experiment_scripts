# Normalizes (min-max) an array
# each column is taken as a record  
function normalizeArr(x)
    for i=1:size(x)[1]
        x[i,:] = (x[i,:].-minimum(x[i,:]))/(maximum(x[i,:]).-minimum(x[i,:]));
    end
end