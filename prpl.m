function pr = prpl( theta, ranking )
% probability of ranking given theta defined by Plackett-Luce model
m = length(theta);
pr = 1;
localsum = ones(m-1);
for i = 1:m-1
    if i >= 2
        localsum(i) = localsum(i-1) - theta(ranking(i-1));
    end
    pr = pr*theta(ranking(i))/localsum(i);
end

