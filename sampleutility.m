function utilities = sampleutility(theta, po_list, upper_a, lower_a, ini, n, first)
% sampling utilities using Gibbs
% theta: parameter of PL. e.g. [0.2, 0.3, 0.5]
% po_list: list of pairwise comparisons. e.g. [1 2; 1 3]
% upper_a: set of alternatives that are preferred over each alternative
% lower_a: set of alternatives that are less preferred over each alternative
% ini: initial value of utilties for each alternative
% n: number of samples
% first: binary indicating whether first round (for initialization)
% utilities: the sampled utility for each alternative
m = length(theta);
if first == 0
    utilities = repmat(ini, n, 1);
    utility = ini;
    for k = 1:n
        for j = 1:m
            if po_list(j) == 1
                lower_limit = eps;
                upper_limit = 1 - eps;
                for i = 1:m
                    if upper_a(j, i) == 1
                        upper_val = exp(-theta(j)*exp(-utility(i)));
                        if upper_val < upper_limit
                            upper_limit = upper_val;
                        end
                    end
                    if lower_a(j, i) == 1
                        lower_val = exp(-theta(j)*exp(-utility(i)));
                        if lower_val > lower_limit
                            lower_limit = lower_val;
                        end
                    end
                end
                rand_temp = lower_limit + (upper_limit - lower_limit)*rand();
                utilities(k, j) = log(theta(j)) - log(-log( rand_temp ));
                utility(j) = utilities(k, j);
            end
        end
    end
else
    utility = zeros(1, m);
    for j = 1:m
        if po_list(j) == 1
            lower_limit = eps;
            upper_limit = 1 - eps;
            for i = 1:j
                if upper_a(j, i) == 1
                    upper_val = exp(-theta(j)*exp(-utility(i)));
                    if upper_val < upper_limit
                        upper_limit = upper_val;
                    end
                end
                if lower_a(j, i) == 1
                    lower_val = exp(-theta(j)*exp(-utility(i)));
                    if lower_val > lower_limit
                        lower_limit = lower_val;
                    end
                end
            end
            rand_temp = lower_limit + (upper_limit - lower_limit)*rand();
            utility(j) = log(theta(j)) - log(-log( rand_temp ));
        end
    end
    utilities = utility;
end
end

