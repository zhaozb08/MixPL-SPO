function idx = t2p_findidx( m, a1, a2 )
% finding index for pairwise comparison a1>a2
% example: m = 3
% (1, 2): 1
% (1, 3): 2
% (2, 3): 3
idx = m*(a1-1)-a1*(a1+1)/2+a2;
end