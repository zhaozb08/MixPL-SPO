function cpr = cyclic_partial( m, l )
% return list of l cyclic alternatives where l <= m
p = [1:m 1:m];
cpr = zeros(m, l);
for j = 1:m
    for i = 1:l
        cpr(j, i) = p(i+j-1);
    end
end
end

