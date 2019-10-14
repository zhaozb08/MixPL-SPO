function subgroups = partition2four(m)
% Grouping for GMM-MNL
% m = 4: [1 2 3 4]
% m = 5: [1 2 3 4; 1 5 2 4]
% m = 6: [1 2 3 4; 1 5 6 2]
% m = 7: [1 2 3 4; 1 5 6 7]
% m = 8: [1 2 3 4; 1 5 6 7; 1 8 2 7]
nrows = ceil((m - 1)/3);
subgroups = ones(nrows, 4);
for i = 1:nrows
    subgroups(i,2:4) = 3*i-1:3*i+1;
end
for j = 3:4
    if subgroups(nrows, j) == m+1
        subgroups(nrows, j) = 2;
    elseif subgroups(nrows, j) == m+2
        subgroups(nrows, j) = subgroups(nrows-1, 4);
    end
end

