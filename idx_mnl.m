function idx = idx_mnl(ranking)
% finding indices to increase given a ranking within a group
% indices 1,2,3: 1 top, 2 top, 3 top;
% indices 4,5: 2 selected in {2,3,4}, 3 selected in {2,3,4}
% indices 6,7: 1 selected in {1,3,4}, 3 selected in {1,3,4}
% indices 8,9: 1 selected in {1,2,4}, 2 selected in {1,2,4}
% indices 10,11: 1 selected in {1,2,3}, 2 selected in {1,2,3}
% indices 12,13,14: 1 beats 2, 1 beats 3, 1 beats 4
% indices 15,16: 2 beats 3, 2 beats 4,
% index 17: 3 beats 4
if ranking == [1 2 3 4]
    idx = [1 0 0 1 0 1 0 1 0 1 0 1 1 1 1 1 1];
elseif ranking == [1 2 4 3]
    idx = [1 0 0 1 0 1 0 1 0 1 0 1 1 1 1 1 0];
elseif ranking == [1 3 2 4]
    idx = [1 0 0 0 1 1 0 1 0 1 0 1 1 1 0 1 1];
elseif ranking == [1 3 4 2]
    idx = [1 0 0 0 1 1 0 1 0 1 0 1 1 1 0 0 1];
elseif ranking == [1 4 2 3]
    idx = [1 0 0 0 0 1 0 1 0 1 0 1 1 1 1 0 0];
elseif ranking == [1 4 3 2]
    idx = [1 0 0 0 0 1 0 1 0 1 0 1 1 1 0 0 0];
%2 top
elseif ranking == [2 1 3 4]
    idx = [0 1 0 1 0 1 0 0 1 0 1 0 1 1 1 1 1];
elseif ranking == [2 1 4 3]
    idx = [0 1 0 1 0 1 0 0 1 0 1 0 1 1 1 1 0];
elseif ranking == [2 3 1 4]
    idx = [0 1 0 1 0 0 1 0 1 0 1 0 0 1 1 1 1];
elseif ranking == [2 3 4 1]
    idx = [0 1 0 1 0 0 1 0 1 0 1 0 0 0 1 1 1];
elseif ranking == [2 4 1 3]
    idx = [0 1 0 1 0 0 0 0 1 0 1 0 1 0 1 1 0];
elseif ranking == [2 4 3 1]
    idx = [0 1 0 1 0 0 0 0 1 0 1 0 0 0 1 1 0];
%3 top
elseif ranking == [3 1 2 4]
    idx = [0 0 1 0 1 0 1 1 0 0 0 1 0 1 0 1 1];
elseif ranking == [3 1 4 2]
    idx = [0 0 1 0 1 0 1 1 0 0 0 1 0 1 0 0 1];
elseif ranking == [3 2 1 4]
    idx = [0 0 1 0 1 0 1 0 1 0 0 0 0 1 0 1 1];
elseif ranking == [3 2 4 1]
    idx = [0 0 1 0 1 0 1 0 1 0 0 0 0 0 0 1 1];
elseif ranking == [3 4 1 2]
    idx = [0 0 1 0 1 0 1 0 0 0 0 1 0 0 0 0 1];
elseif ranking == [3 4 2 1]
    idx = [0 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 1];
%4 top
elseif ranking == [4 1 2 3]
    idx = [0 0 0 0 0 0 0 0 0 1 0 1 1 0 1 0 0];
elseif ranking == [4 1 3 2]
    idx = [0 0 0 0 0 0 0 0 0 1 0 1 1 0 0 0 0];
elseif ranking == [4 2 1 3]
    idx = [0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0];
elseif ranking == [4 2 3 1]
    idx = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0];
elseif ranking == [4 3 1 2]
    idx = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0];
else
    idx = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
end
end