function flag = checkcyclic( m, array )
% if the alternatives are cyclic, return 0; otherwise, return 1
flag = 1;
l = length(array);
for j = 2:l
    if array(j) == array(j-1) + 1
        continue;
    elseif array(j-1) == m && array(j) == 1
        continue;
    else
        flag = 0;
    end
end
end
