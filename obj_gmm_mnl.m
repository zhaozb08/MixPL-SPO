function se = obj_gmm_mnl( theta, subgroups, emp )
% objective function for GMM-MNL
l = length(theta);
m = l/2 - 1;
alpha = theta(1);
gamma1 = theta(3:m+2);
gamma2 = theta(m+3:2*m+2);
[nrows,~] = size(subgroups);
%Computing theoretical probabilities
theo = zeros(nrows, 17);
for i = 1:nrows
    theo(i, 1) = alpha*gamma1(subgroups(i, 1))/sum(gamma1(subgroups(i,:)))+(1-alpha)*gamma2(subgroups(i, 1))/sum(gamma2(subgroups(i,:)));
    theo(i, 2) = alpha*gamma1(subgroups(i, 2))/sum(gamma1(subgroups(i,:)))+(1-alpha)*gamma2(subgroups(i, 2))/sum(gamma2(subgroups(i,:)));
    theo(i, 3) = alpha*gamma1(subgroups(i, 3))/sum(gamma1(subgroups(i,:)))+(1-alpha)*gamma2(subgroups(i, 3))/sum(gamma2(subgroups(i,:)));
    theo(i, 4) = alpha*gamma1(subgroups(i, 2))/(gamma1(subgroups(i, 2))+gamma1(subgroups(i, 3))+gamma1(subgroups(i, 4)))+(1-alpha)*gamma2(subgroups(i, 2))/(gamma2(subgroups(i, 2))+gamma2(subgroups(i, 3))+gamma2(subgroups(i, 4)));
    theo(i, 5) = alpha*gamma1(subgroups(i, 3))/(gamma1(subgroups(i, 2))+gamma1(subgroups(i, 3))+gamma1(subgroups(i, 4)))+(1-alpha)*gamma2(subgroups(i, 3))/(gamma2(subgroups(i, 2))+gamma2(subgroups(i, 3))+gamma2(subgroups(i, 4)));
    theo(i, 6) = alpha*gamma1(subgroups(i, 1))/(gamma1(subgroups(i, 1))+gamma1(subgroups(i, 3))+gamma1(subgroups(i, 4)))+(1-alpha)*gamma2(subgroups(i, 1))/(gamma2(subgroups(i, 1))+gamma2(subgroups(i, 3))+gamma2(subgroups(i, 4)));
    theo(i, 7) = alpha*gamma1(subgroups(i, 3))/(gamma1(subgroups(i, 1))+gamma1(subgroups(i, 3))+gamma1(subgroups(i, 4)))+(1-alpha)*gamma2(subgroups(i, 3))/(gamma2(subgroups(i, 1))+gamma2(subgroups(i, 3))+gamma2(subgroups(i, 4)));
    theo(i, 8) = alpha*gamma1(subgroups(i, 1))/(gamma1(subgroups(i, 1))+gamma1(subgroups(i, 2))+gamma1(subgroups(i, 4)))+(1-alpha)*gamma2(subgroups(i, 1))/(gamma2(subgroups(i, 1))+gamma2(subgroups(i, 2))+gamma2(subgroups(i, 4)));
    theo(i, 9) = alpha*gamma1(subgroups(i, 2))/(gamma1(subgroups(i, 1))+gamma1(subgroups(i, 2))+gamma1(subgroups(i, 4)))+(1-alpha)*gamma2(subgroups(i, 2))/(gamma2(subgroups(i, 1))+gamma2(subgroups(i, 2))+gamma2(subgroups(i, 4)));
    theo(i, 10) = alpha*gamma1(subgroups(i, 1))/(gamma1(subgroups(i, 1))+gamma1(subgroups(i, 2))+gamma1(subgroups(i, 3)))+(1-alpha)*gamma2(subgroups(i, 1))/(gamma2(subgroups(i, 1))+gamma2(subgroups(i, 2))+gamma2(subgroups(i, 3)));
    theo(i, 11) = alpha*gamma1(subgroups(i, 2))/(gamma1(subgroups(i, 1))+gamma1(subgroups(i, 2))+gamma1(subgroups(i, 3)))+(1-alpha)*gamma2(subgroups(i, 2))/(gamma2(subgroups(i, 1))+gamma2(subgroups(i, 2))+gamma2(subgroups(i, 3)));
    theo(i, 12) = alpha*gamma1(subgroups(i, 1))/(gamma1(subgroups(i, 1))+gamma1(subgroups(i, 2)))+(1-alpha)*gamma2(subgroups(i, 1))/(gamma2(subgroups(i, 1))+gamma2(subgroups(i, 2)));
    theo(i, 13) = alpha*gamma1(subgroups(i, 1))/(gamma1(subgroups(i, 1))+gamma1(subgroups(i, 3)))+(1-alpha)*gamma2(subgroups(i, 1))/(gamma2(subgroups(i, 1))+gamma2(subgroups(i, 3)));
    theo(i, 14) = alpha*gamma1(subgroups(i, 1))/(gamma1(subgroups(i, 1))+gamma1(subgroups(i, 4)))+(1-alpha)*gamma2(subgroups(i, 1))/(gamma2(subgroups(i, 1))+gamma2(subgroups(i, 4)));
    theo(i, 15) = alpha*gamma1(subgroups(i, 2))/(gamma1(subgroups(i, 2))+gamma1(subgroups(i, 3)))+(1-alpha)*gamma2(subgroups(i, 2))/(gamma2(subgroups(i, 2))+gamma2(subgroups(i, 3)));
    theo(i, 16) = alpha*gamma1(subgroups(i, 2))/(gamma1(subgroups(i, 2))+gamma1(subgroups(i, 4)))+(1-alpha)*gamma2(subgroups(i, 2))/(gamma2(subgroups(i, 2))+gamma2(subgroups(i, 4)));
    theo(i, 17) = alpha*gamma1(subgroups(i, 3))/(gamma1(subgroups(i, 3))+gamma1(subgroups(i, 4)))+(1-alpha)*gamma2(subgroups(i, 3))/(gamma2(subgroups(i, 3))+gamma2(subgroups(i, 4)));
end
%theo
diff = theo - emp;
se = sum(sum(diff.^2));
end
