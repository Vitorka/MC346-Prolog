tam([],0).
tam([_|XS], T) :- tam(XS, TT), T is TT+1.

/*Pega todos os posfixos de uma lista, com tam >= 4*/
all_postfix(L, R) :- all_postfix(L, R, [L]).

all_postfix([], ACC, ACC).
all_postfix([X|XS], R, ACC) :- tam(XS, T), T >= 4 -> append(ACC, [XS], ACC1), all_postfix(XS, R, ACC1)
                                                  ;all_postfix(XS, R, ACC).

/*Pega todos os prefixos de uma lista, com tam >= 4*/
all_prefix(L, R) :- reverse(L, V), all_prefix(V, R, [L]).

all_prefix([], ACC, ACC).
all_prefix([X|XS], R, ACC) :- tam(XS, T), T >= 4 -> reverse(XS, V), append(ACC, [V], ACC1), all_prefix(XS, R, ACC1)
                                                  ;all_prefix(XS, R, ACC).

get_pre_post(S, PR, PO) :- string_chars(S, L), all_prefix(L, PR), all_postfix(L, PO).
