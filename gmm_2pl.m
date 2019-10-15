function [est, tm, to, exitflag] = gmm_2pl( pfl, option )
% GMM algorithms to learn 2-PL from full rankings
% Outputs:
% est: estimated parameter; each row is a component, starting with the
% mixing coefficient
% tm: time to compute empirical probabilities
% to: time spent for optimization
% exitflag: exitflag during optimization for debugging
% Inputs: 
% pfl: preference profile, i.e., data. Each row is a linear order. 
% options:
% option 1: top 1,2,3 moments from "Learning mixtures of Plackett-Luce models"
% option 2: top 2,3 moments
% option 4: top 2 pairwise moments
[n, m] = size( pfl ); % n: number of rankings; m: number of alternatives
k = 2; % number of components
%options = optimoptions('fmincon','Algorithm','quasi-newton');
%Initialization
alphas = rand(1, k);
alphas = alphas/sum(alphas);
thetas = rand(k, m);
for r = 1:k
    thetas(r,:) = thetas(r,:)/sum(thetas(r,:));
end
t0 = [alphas reshape(thetas', 1, k*m)];
% optimization constraints
Aeq = zeros(k+1, k*(m+1));
Aeq(1, 1:k) = ones(1, k);
for r = 1:k
    Aeq(r+1,k+(r-1)*m+1:k+r*m) = ones(1, m);
end
beq = ones(k+1, 1);
lb = zeros(k*(m+1),1);
ub = ones(k*(m+1), 1);
% optimization setting
options = optimoptions('fmincon','MaxFunctionEvaluations',36000);
switch option
    case 1 %top 1, 2, 3 moments
        q = m^2+m; % number of marginal events
        q1 = m*(m-1); % number of top 2 moments
        q2 = m; % number of top 3 moments
        emp = zeros(1, q); % empirical frequences of each marginal event
        tms = tic;
        for j = 1:n
            a1 = pfl(j,1);
            a2 = pfl(j,2);
            a3 = pfl(j,3);
            idx0 = q1+q2+a1; % index of top-1 events
            emp(idx0) = emp(idx0) + 1; % counting top-1 frequency
            idx1 = t3_findidx(m, a1, a2); % index of top-2 events
            emp(idx1) = emp(idx1) + 1; % counting top-2 frequency
            t3partial = [a1 a2 a3];
            % checking if this top-3 event should be counted
            if checkcyclic(m, t3partial)
                idx2 = q1 + a1;
                emp(idx2) = emp(idx2) + 1; %top-3
            end
        end
        emp = emp/n; % normalize to empirical probabilities
        tm = toc(tms);
        tos = tic;
        % optimization
        [hat, fval, exitflag] = fmincon(@(x) obj_gmm_t123(x, emp), t0, [], [], Aeq, beq, lb, ub,[],options);
        to = toc(tos);
    case 2 %top 2, 3 moments
        q = m^2-1; % number of marginal events
        q1 = m*(m-1)-1; % top-2 moments
        emp = zeros(1, q);
        tms = tic;
        for j = 1:n
            a1 = pfl(j,1);
            a2 = pfl(j,2);
            a3 = pfl(j,3);
            idx1 = t3_findidx(m, a1, a2); % finding index of top-2
            if idx1 ~= q1 + 1
                emp(idx1) = emp(idx1) + 1;
            end
            t3partial = [a1 a2 a3];
            if checkcyclic(m, t3partial)
                idx2 = q1 + a1;
                emp(idx2) = emp(idx2) + 1; %top-3
            end
        end
        emp = emp/n;
        tm = toc(tms);
        tos = tic;
        [hat, fval] = fmincon(@(x) obj_gmm_t23(x, emp), t0, [], [], Aeq, beq, lb, ub);
        to = toc(tos);
    case 4 % top-2 and pairwise
        q1 = m*(m-1) - 1;
        q = 3*(q1+1)/2 - 1;
        emp = zeros(1, q);
        tms = tic;
        for j = 1:n
            a1 = pfl(j,1);
            a2 = pfl(j,2);
            idx1 = t3_findidx(m, a1, a2); %top-2
            if idx1 ~= q1 + 1
                emp(idx1) = emp(idx1) + 1;
            end
            for i1 = 1:m-1
                for i2 = i1+1:m
                    a1p = pfl(j, i1);
                    a2p = pfl(j, i2);
                    if a1p < a2p
                        idx2 = t2p_findidx(m, a1p, a2p) + q1; % finding pairwise index
                        emp(idx2) = emp(idx2) + 1;
                    end
                end
            end
        end
        emp = emp/n;
        tm = toc(tms);
        tos = tic;
        [hat, fval, exitflag] = fmincon(@(x) obj_gmm_t2p(x, emp), t0, [], [], Aeq, beq, lb, ub, [], options);
        %fval
        to = toc(tos);
    case 6 % MNL
        nrows = ceil((m - 1)/3); % number of groups
        emp = zeros(nrows, 17); % 17 marginal events per group
        tms = tic;
        subgroups = partition2four(m); % grouping
        for j = 1:n
            emp = rank2subgroups(m, pfl(j,:), subgroups, emp);
        end
        emp = emp/n;
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