# call : genPredLab(res, length(trueLab))
function genPredLab(res, l)
    predLab = ones(l);
    Ms = res.manifolds;
    for i=1:length(Ms)
        lab = Ms[i].points;
        predLab[lab] .= i;
    end

    return predLab;
end