function [est, tm, to, exitflag] = gmm_2pl_partial( pfl, option )
% GMM algorithms to learn 2-PL from structured partial orders
% Outputs:
% est: estimated parameter; each row is a component, starting with the
% mixing coefficient
% tm: time to compute empirical probabilities
% to: time spent for optimization
% exitflag: exitflag during optimization for debugging
% Inputs: 
% pfl: preference profile, i.e., data. Each row is a linear order.
% Strutured partial orders will be sampled from pfl within this function.
% This is part of synthetic data generation process.
% options:
% option 1: top-1,2,3 orders.
% option 2: top-2,3 orders
% option 4: top-2 and 2-way orders
% option 6: MNL
[n, m] = size( pfl ); % n: number of rankings; m: number of alternatives
k = 2;
% options = optimoptions('fmincon','Algorithm','quasi-newton');
% Initialization
alphas = rand(1, k);
alphas = alphas/sum(alphas);
thetas = rand(k, m);
for r = 1:k
    thetas(r,:) = thetas(r,:)/sum(thetas(r,:));
end
t0 = [alphas reshape(thetas', 1, k*m)];
Aeq = zeros(k+1, k*(m+1));
Aeq(1, 1:k) = ones(1, k);
for r = 1:k
    Aeq(r+1,k+(r-1)*m+1:k+r*m) = ones(1, m);
end
beq = ones(k+1, 1);
lb = zeros(k*(m+1),1);
ub = ones(k*(m+1), 1);
options = optimoptions('fmincon','MaxFunctionEvaluations',36000);
switch option
    case 1 % top-1, 2, 3 moments. This is identical with gmm_2pl for linear orders
        q = m^2+m;
        q1 = m*(m-1);
        q2 = m;
        emp = zeros(1, q);
        tms = tic;
        for j = 1:n
            a1 = pfl(j,1);
            a2 = pfl(j,2);
            a3 = pfl(j,3);
            idx0 = q1+q2+a1;
            emp(idx0) = emp(idx0) + 1; % top-1
            idx1 = t3_findidx(m, a1, a2); % top-2
            emp(idx1) = emp(idx1) + 1;
            t3partial = [a1 a2 a3];
            if checkcyclic(m, t3partial)
                idx2 = q1 + a1;
                emp(idx2) = emp(idx2) + 1; % top-3
            end
        end
        emp = emp/n;
        tm = toc(tms);
        tos = tic;
        [hat, fval, exitflag] = fmincon(@(x) obj_gmm_t123(x, emp), t0, [], [], Aeq, beq, lb, ub,[],options);
        to = toc(tos);
    case 2 % top-2, 3 orders; also identical with gmm_2pl for linear orders
        q = m^2-1;
        q1 = m*(m-1)-1;
        emp = zeros(1, q);
        tms = tic;
        for j = 1:n
            a1 = pfl(j,1);
            a2 = pfl(j,2);
            a3 = pfl(j,3);
            idx1 = t3_findidx(m, a1, a2); % top-2
            if idx1 ~= q1 + 1
                emp(idx1) = emp(idx1) + 1;
            end
            t3partial = [a1 a2 a3];
            if checkcyclic(m, t3partial)
                idx2 = q1 + a1;
                emp(idx2) = emp(idx2) + 1; % top-3
            end
        end
        emp = emp/n;
        tm = toc(tms);
        tos = tic;
        [hat, fval] = fmincon(@(x) obj_gmm_t23(x, emp), t0, [], [], Aeq, beq, lb, ub);
        to = toc(tos);
    case 4 % top-2 and 2-way
        q1 = m*(m-1) - 1;
        q = 3*(q1+1)/2 - 1;
        emp = zeros(1, q);
        empn = 0.0001*ones(1, q); % avoid (rare) divided by zero cases
        pos = partialExtract(pfl, 1); % sampling partial orders (part of synthetic data generation)
        tms = tic;
        for j = 1:n
            a1 = pos(j,2);
            a2 = pos(j,3);
            if pos(j, 1) == 1
                empn(1:q1) = empn(1:q1) + 1;
                idx1 = t3_findidx(m, a1, a2); % top-2
                if idx1 ~= q1 + 1
                    emp(idx1) = emp(idx1) + 1;
                end
            else
                if a1 < a2
                    idx2 = t2p_findidx(m, a1, a2) + q1;
                    emp(idx2) = emp(idx2) + 1;
                    empn(idx2) = empn(idx2) + 1;
                else
                    idx2 = t2p_findidx(m, a2, a1) + q1;
                    empn(idx2) = empn(idx2) + 1;
                end
            end
        end
        emp = emp./empn;
        tm = toc(tms);
        tos = tic;
        [hat, fval, exitflag] = fmincon(@(x) obj_gmm_t2p(x, emp), t0, [], [], Aeq, beq, lb, ub, [], options);
        %fval
        to = toc(tos);
    case 6 % MNL
        nrows = ceil((m - 1)/3);
        emp = zeros(nrows, 17);
        empn = zeros(nrows, 17);
        subgroups = partition2four(m);
        pos = partialExtract(pfl, 2);
        betas = randi(28, 1, n);
        tms = tic;
        for j = 1:n
            window = func_window(betas(j)); % indices to be updated
            emp(pos(j, 1),:) = emp(pos(j, 1),:) + idx_mnl(pos(j, 2:5)).*window;
            empn(pos(j, 1),:) = empn(pos(j, 1),:) + window;
        end
        emp = emp./empn;
        tm = toc(tms);
        tos = tic;
        [hat, fval, exitflag] = fmincon(@(x) obj_gmm_mnl(x, subgroups, emp), t0, [], [], Aeq, beq, lb, ub, [], options);
        %fval
        to = toc(tos);
    otherwise
        disp('Option value can only be 1, 2, 4, 6');
end
%alpha = hat(1);
%theta1 = normalizetheta(hat(2:m));
%theta2 = normalizetheta(hat(m+1:2*m-1));
est = hat;
end
