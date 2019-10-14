function samples = gibbs_sampling(partial, n, theta)
% sampling linear extensions from PL using Gibbs
% see paper "Learning Plackett-Luce Mixtures from Partial Preferences"
% partial: partial order representated by a list of pairwise comparisons
% n: number of rankings
% theta: parameter of PL
[length_partial, ~] = size(partial);
m = length(theta);
theta = theta/sum(theta);
upper_a = zeros(m, m);
lower_a = zeros(m, m);
po_list = zeros(1, m);
for i = 1:length_partial
    if partial(i, 1) ~= 0
        upper_a(partial(i, 2), partial(i, 1)) = 1;
        lower_a(partial(i, 1), partial(i, 2)) = 1;
        po_list(partial(i, 1)) = 1;
        po_list(partial(i, 2)) = 1;
    else
        break;
    end
end
m_constrained = sum(po_list);
k1 = m_constrained; %burn in
k2 = round(log(m_constrained)+1); %thin
%first round: generating a linear extension for initialization
utility = sampleutility(theta, po_list, upper_a, lower_a, zeros(1, m), 1, 1);
t = k1+k2*(n-1)+1;
utilities = sampleutility(theta, po_list, upper_a, lower_a, utility, t, 0);
utility_free = zeros(1, m);
samples = zeros(n, m);
for j = 1:n
    for i = 1:m
        if po_list(i) == 0
            rand_temp = eps + (1-2*eps)*rand();
            utility_free(i) = -log(-log(rand_temp)) + log(theta(i));
        end
    end
    utility_full = utilities(k1+(j-1)*k2+1,:)+utility_free;
    [~, samples(j, :)] = sort(utility_full, 'descend');
end
end
