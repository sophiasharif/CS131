% transpose/2; assumes input is a valid matrix.
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :- lists_firsts_rests(Matrix, Row, Rests), transpose(Rests, Rows).
lists_firsts_rests([], [], []).
lists_firsts_rests([[F|R]|T], [F|Fs], [R|Rs]) :- lists_firsts_rests(T, Fs, Rs).

% reverse matrix
reverse_matrix([], []).
reverse_matrix([H|T],[RH|RT]) :- reverse(H, RH), reverse_matrix(T, RT).

% check this is an NxN grid and rows & cols follow rules
valid_grid(N,G) :- is_N_by_N_grid(N, G), valid_rows(N, G), transpose(G, GT), valid_rows(N, GT).
length_(N,L) :- length(L,N).
is_N_by_N_grid(N,Grid) :- length(Grid, N), maplist(length_(N), Grid).
valid_row(0, []).
valid_row(N, Row) :- append(Pre, [N|Post], Row), append(Pre, Post, NewRow), 
                    N1 is N-1, valid_row(N1, NewRow).
valid_rows(N,G) :- maplist(valid_row(N), G).

% check count for one list
valid_tower_count(Towers, C) :- valid_tower_count_helper(Towers, 0, 0, C).
valid_tower_count_helper([], _, C, C).
valid_tower_count_helper([H|T], Tallest, Acc, C) :- 
    H > Tallest, 
    NewAcc is Acc+1, 
    valid_tower_count_helper(T, H, NewAcc, C).
valid_tower_count_helper([H|T], Tallest, Acc, C) :- 
    H < Tallest,
    valid_tower_count_helper(T, Tallest, Acc, C).

% check count for multiple lists
valid_tower_counts([],[]).
valid_tower_counts([TowersH|TowersT], [CountH|CountT]) :- valid_tower_count(TowersH, CountH), valid_tower_counts(TowersT, CountT).

valid_grid_counts(G, counts(T,B,L,R)) :- 
    transpose(G, GT),
    reverse_matrix(G, GR),
    reverse_matrix(G, GRT),
    valid_tower_counts(G, L),
    valid_tower_counts(GT, T),
    write(GR), nl, 
    write(GRT), nl,
    true.

% valid_grid_counts([[2,3,4,5,1],[5,4,1,3,2],[4,1,5,2,3],[1,2,3,4,5],[3,5,2,1,4]], counts([2,3,2,1,4], [3,1,3,3,2], [4,1,2,5,2], [2,4,2,1,2])).
