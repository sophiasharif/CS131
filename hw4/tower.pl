% transpose/2 -- assumes input is a valid matrix.
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :- lists_firsts_rests(Matrix, Row, Rests), transpose(Rests, Rows).
lists_firsts_rests([], [], []).
lists_firsts_rests([[F|R]|T], [F|Fs], [R|Rs]) :- lists_firsts_rests(T, Fs, Rs).

% reverse_matrix/2 -- reverse the rows in a matrix
reverse_matrix([], []).
reverse_matrix([H|T],[RH|RT]) :- reverse(H, RH), reverse_matrix(T, RT).

% is_N_by_N_grid/2 -- check input grid is an N by N matrix
is_N_by_N_grid(N,Grid) :- length(Grid, N), maplist(length_(N), Grid).
length_(N,L) :- length(L,N).

% valid_grid/2 -- check this is an NxN grid and rows & cols follow rules
valid_grid(N,G) :- is_N_by_N_grid(N, G), 
    valid_rows(N, G), 
    transpose(G, GT), 
    valid_rows(N, GT).
valid_row(0, []).
valid_row(N, Row) :- append(Pre, [N|Post], Row), append(Pre, Post, NewRow), 
                    N1 is N-1, valid_row(N1, NewRow).
valid_rows(N,G) :- maplist(valid_row(N), G).

% valid_grid_fd/2 -- optimized version of valid_grid
valid_grid_fd(N,G) :- is_N_by_N_grid(N, G), 
    valid_rows_fd(N, G), 
    transpose(G, GT), 
    valid_rows_fd(N, GT).
valid_row_fd(N, Row):- fd_domain(Row, 1, N), fd_all_different(Row), fd_labeling(Row).
valid_rows_fd(N,G) :- maplist(valid_row_fd(N), G).

% valid_tower_count/2 -- check that C towers are visible in list Towers
valid_tower_count(Towers, C) :- valid_tower_count_helper(Towers, 0, 0, C).
valid_tower_count_helper([], _, C, C).
valid_tower_count_helper([H|T], Tallest, Acc, C) :- 
    H > Tallest, 
    NewAcc is Acc+1, 
    valid_tower_count_helper(T, H, NewAcc, C).
valid_tower_count_helper([H|T], Tallest, Acc, C) :- 
    H < Tallest,
    valid_tower_count_helper(T, Tallest, Acc, C).

% valid_grid_counts/2 -- check that counts structure accurately describes grid G
valid_grid_counts(G, counts(T,B,L,R)) :- 
    transpose(G, GT),
    reverse_matrix(G, GR),
    reverse_matrix(GT, GTR),
    valid_tower_counts(G, L),
    valid_tower_counts(GT, T),
    valid_tower_counts(GR, R),
    valid_tower_counts(GTR, B).
valid_tower_counts([],[]).
valid_tower_counts([TowersH|TowersT], [CountH|CountT]) :- valid_tower_count(TowersH, CountH), valid_tower_counts(TowersT, CountT).

% 1 -- ntower/3
ntower(0, [], counts([],[],[],[])).
ntower(N,T,C) :- valid_grid_fd(N, T), valid_grid_counts(T, C).

% 2 -- plain_ntower/3
plain_ntower(0, [], counts([],[],[],[])).
plain_ntower(N,T,C) :- valid_grid(N, T), valid_grid_counts(T, C).

% 3 -- speedup/1
measure_plain_ntower(N, T, C, ExecutionTime) :-
    statistics(cpu_time, [Start|_]), 
    plain_ntower(N, T, C),       
    statistics(cpu_time, [End|_]),    
    ExecutionTime is End - Start.   

measure_ntower(N, T, C, ExecutionTime) :-
    statistics(cpu_time, [Start|_]), 
    ntower(N, T, C),       
    statistics(cpu_time, [End|_]),    
    ExecutionTime is End - Start.   

speedup(Ratio) :- 
    measure_ntower(4, T, counts([1,2,3,3],[3,3,1,2],[1,2,2,2],[4,3,1,2]), E1),
    measure_plain_ntower(4, T, counts([1,2,3,3],[3,3,1,2],[1,2,2,2],[4,3,1,2]), E2),
    E_adjusted is E2+1, % make sure we don't divide by 0
    Ratio is E1/E_adjusted.

% 4 -- ambiguous/4
ambiguous(N, C, T1, T2) :- ntower(N, T1, C), ntower(N, T2, C), T1 \= T2.