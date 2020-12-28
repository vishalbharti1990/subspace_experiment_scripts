# This function computes the normalized
# mutual information for a confusion
# matrix c
function getNMI(c)

    normC = c/sum(c);

    rSum = sum(normC, dims=2);
    cSum = sum(normC, dims=1);

    NMI = 0;

    for i=1:size(normC,1)
        for j=1:size(normC,2)
            MI = (normC[i,j] * log2.(normC[i,j]/(rSum[i]*cSum[j])));

            if ~isnan.(MI) 
                NMI = NMI + MI; 
            end 
        end
    end

    log2R = log2.(rSum);
    log2C = log2.(cSum);

    s1 = -(cSum .* log2C)';
    s2 = -(rSum .* log2R);

    s1[isnan.(s1)] .= 0;
    s2[isnan.(s2)] .= 0;

    h1 = sum(s1); 
    h2 = sum(s2);

    NMI_sqrt = NMI/sqrt(h1*h2);
    NMI_sum = 2*NMI/(h1+h2)
    NMI_min = NMI/min(h1,h2)
    NMI_max = NMI/max(h1,h2)

    nmi = [round(NMI_sqrt, digits=2) round(NMI_min, digits=2) round(NMI_max, digits=2) round(NMI_sum, digits=2)]

    nmi[isnan.(nmi)] .= 0

    return nmi
end