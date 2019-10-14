function se = obj_gmm_t2p( theta, emp )
% objective function for GMM-top-2, 2-way
l = length(theta);
m = l/2 - 1;
q1 = m*(m-1) - 1;
q = 3*(q1+1)/2 - 1;
q2 = q - q1;
alphas = theta(1:2);
gamma1 = theta(3:m+2);
gamma2 = theta(m+3:2*m+2);
pair = zeros(q2, 2);
idx = 0;
for i1 = 1:m
    for i2 = i1+1:m
        idx = idx + 1;
        pair(idx, :) = [i1 i2];
    end
end
%Computing probabilities given theta
theop = zeros(2, q);
ind = 0;
for a1 = 1:m
    for a2 = 1:m
        if a1 ~= a2
            ind = ind + 1;
            theop(1, ind) = gamma1(a1)*gamma1(a2)/(1-gamma1(a1));
            theop(2, ind) = gamma2(a1)*gamma2(a2)/(1-gamma2(a1));
        end
    end
end
for j = 1:q2
    a1 = pair(j, 1);
    a2 = pair(j, 2);
    theop(1, q1+j) = gamma1(a1)/(gamma1(a1)+gamma1(a2));
    theop(2, q1+j) = gamma2(a1)/(gamma2(a1)+gamma2(a2));
end
theo = alphas(1)*theop(1,:)+alphas(2)*theop(2,:);
diff = theo - emp;
se = diff*diff';
end
