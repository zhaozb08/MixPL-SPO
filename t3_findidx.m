function idx = t3_findidx( m, a1, a2 )
% finding the index of event a1>a2>others for GMM-Top-1,2,3
idx = (m - 1) * (a1 - 1) + a2;
if a2 > a1
    idx = idx - 1;
end
end

