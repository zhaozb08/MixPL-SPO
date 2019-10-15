function emp_updated = rank2subgroups(m, ranking, subgroups, emp)
% updating empirical probabilities given a ranking
grouped = subgroups;
emp_updated = emp;
[nrows, ~] = size(subgroups);
idx = ones(1, nrows);
barrier = zeros(1, nrows);
for k = 1:nrows
    barrier(k) = 3*k+1;
end
for i = 1:m
    %flags = zeros(1, nrows);
    if ranking(i) == 1
        for j = 1:nrows
            grouped(j, idx(j)) = 1;
            idx(j) = idx(j) + 1;
            %flags(j) = 1;
        end
    elseif ranking(i) == 2
        grouped(1, idx(1)) = 2;
        idx(1) = idx(1) + 1;
        %flags(1) = 1;
        if mod(m, 3) ~= 1
            idx_local = find( abs(subgroups(nrows,:)-2)<0.1 );
            grouped(nrows, idx(nrows)) = idx_local;
            idx(nrows) = idx(nrows) + 1;
            %flags(nrows) = 1;
        end
    elseif mod(m, 3) == 2 && ranking(i) == m - 1
        grouped(nrows, idx(nrows)) = 4;
        idx(nrows) = idx(nrows) + 1;
        %flags(nrows) = 1;
        grouped(nrows-1, idx(nrows-1)) = 4;
        idx(nrows-1) = idx(nrows-1) + 1;
        %flags(nrows-1) = 1;
    else
        for k = 1:nrows
            if ranking(i) <= barrier(k)
                idx_local = find( abs(subgroups(k,:)-ranking(i))<0.1 );
                grouped(k, idx(k)) = idx_local;
                idx(k) = idx(k) + 1;
                %flags(k) = 1;
                break;
            end
        end
    end
end
for i = 1:nrows
    emp_updated(i, :) = emp(i,:) + idx_mnl(grouped(i,:));
end

