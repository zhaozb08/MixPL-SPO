function [alphas, thetas, te, tm] = elsr_gibbs( data, m, k, nlin, itr )
% ELSR-Gibbs: generate linear orders from partial orders using Gibbs
% sampling, and then learning from linear orders using ELSR
% Outputs:
% alphas: array of mixing coefficients
% thetas: r-th row is the parameter of r-th component
% te: time used to compute empirical probabilities
% tm: time used for optimization
% Inputs:
% data: each partial order is representated by a list of pairwise
% comparisons. Not necessarily transitive closure
% m: number of alternatives
% k: number of components
% nlin: number of linear extensions to be generated per partial order
% itr: number of iterations
[~, ~, n] = size(data); % n is the number of partial orders
% initialization
alphas = rand(1, k);
alphas = alphas/sum(alphas);
thetas = rand(k, m);
for r = 1:k
    thetas(r, :) = thetas(r, :)/sum(thetas(r, :));
end
% if learning from non-mixture, one iteration is enough
if k == 1
    itr = 1;
end
te = 0;
tm = 0;
%options = optimoptions('fminunc','Algorithm','quasi-newton');
for EMiter = 1:itr
    %E-step
    tes = tic;
    newalphas = zeros(1, k);
    nn = nlin*n;
    rankings = zeros(nn, m);
    weights = zeros(nn, k);
    %generating linear extensions
    for j = 1:n
        ranking = data(:, :, j); % j-th partial order
        % Computing the number of linear extensions for each component
        betas = rand(1, nlin);
        cum = cumsum(alphas);
        cnt = histcnt(betas, cum); %compute the number of linear orders for each component
        cumcnt = cumsum(cnt);
        samples = zeros(nlin, m);
        % sampling linear orders
        for r = 1:k
            s = gibbs_sampling(ranking, cnt(r), thetas(r, :));
            if r == 1
                samples(1:cumcnt(1), :) = s;
            else
                samples(cumcnt(r-1)+1:cumcnt(r),:) = s;
            end
        end
        rankings(nlin*(j-1)+1:nlin*j,:) = samples;
    end
    for j = 1:nn
        ranking = rankings(j, :);
        w = zeros(1, k);
        for r = 1:k
            %[thetas(r,:); ranking]
            w(r) = alphas(r)*prpl(thetas(r,:),ranking);
        end
        w = w/sum(w);
        weights(j, :) = w;
        newalphas = newalphas + w;
    end
    tee = toc(tes);
    te = te + tee;
    %M-step, LSR algorithm
    tms = tic;
    alphas = newalphas/sum(newalphas);
    for r = 1:k
        thetas(r, :) = wlsr( rankings, weights(:, r), thetas(r,:));
    end
    tme = toc(tms);
    tm = tm + tme;
end
end

