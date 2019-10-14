function cnt = histcnt(betas, cum)
% count the number of items in each bin
% cnt: the number of items in each bin
% betas: random numbers between 0 and 1
% cum: barriers for bins
% example: betas = [0.2 0.5 0.3]; cum = [0.4, 1]; then cnt = [2, 1] because
% there are two numbers below 0.4 and 1 number between 0.4 and 1.
l = length(cum);
cnt = zeros(1, l);
lb = length(betas);
for i = 1:lb
    for j = 1:l
        if betas(i) <= cum(j)
            cnt(j) = cnt(j) + 1;
            break;
        end
    end
end
end

