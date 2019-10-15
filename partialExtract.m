function pos = partialExtract(pfl, option)
% Sampling partial orders from linear orders
% Output: partial orders (pos)
% Input: 
% pfl: list of linear orders
% options: to control the structures to be generated
% option = 1: top-2 and 2-way
% option = 2: MNL
[n, m] = size(pfl); % n: number of rankings; m: number of alternatives
alphas = rand(1, n);
alts = 1:m;
if option == 1 % top-2 and 2-way
    pos = zeros(n, 3); % for each row, first entry is structure, 1 means top-2; 2 means 2-way
    for i = 1:n
        ranking = pfl(i, :);
        if alphas(i) < 0.5 % half top-2 and half 2-way
            pos(i, 1) = 1;
            pos(i, 2) = ranking(1);
            pos(i, 3) = ranking(2);
        else
            pos(i, 1) = 2;
            pair = datasample(alts, 2, 'Replace', false); % 2-way orders are sampled randomly at uniform
            for j = 1:m
                if ranking(j) == pair(1)
                    pos(i, 2) = pair(1);
                    pos(i, 3) = pair(2);
                    break;
                elseif ranking(j) == pair(2)
                    pos(i, 2) = pair(2);
                    pos(i, 3) = pair(1);
                    break;
                end
            end
        end
    end
end
if option == 2 % MNL structures
    subgroups = partition2four(m);
    [nrows, ~] = size(subgroups);
    alphas = randi(nrows, 1, n);
    pos = zeros(n, 5);
    for i = 1:n
        ranking = pfl(i, :);
        group = subgroups(alphas(i),:);
        pos(i, 1) = alphas(i);
        idx = 2;
        for j = 1:m
            idx_local = find( abs(group-ranking(j))<0.1 );
            if ~isempty(idx_local)
                pos(i, idx) = idx_local;
                idx = idx + 1;
            end
        end
    end
end
end