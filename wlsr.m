function theta = wlsr( rankings, weights, theta_ini)
% LSR algorithm proposed by "Fast and Accurate Inference of Plackett?Luce
% Models". See
% https://papers.nips.cc/paper/5681-fast-and-accurate-inference-of-plackettluce-models
% for more about the algorithm and their original implementation in Python
[n, m] = size(rankings);
chain = zeros(m, m);
for j = 1:n
    ranking = rankings(j, :);
    sum_weights = sum(theta_ini);
    for i1 = 1:m-1
        winner = ranking(i1);
        val = 1/sum_weights;
        for i2 = i1+1:m
            loser = ranking(i2);
            chain(loser, winner) = chain(loser, winner) + val*weights(j);
        end
        sum_weights = sum_weights - theta_ini(winner);
    end
end
chain = chain - diag(sum(chain, 2));
theta = null(chain');
theta = theta/sum(theta);
end
