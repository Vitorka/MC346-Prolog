:- initialization main.
:- use_module(library(readutil)).

/* executar com: swipl -q -g main proj2.pl < trechos  */

main :-
    read_string(user_input, _, RAWINPUT), split_string(RAWINPUT, "\n\r", "", LINES), exclude(equal(""), LINES, [X|XS]),
    find_matches([X|XS], RESULT), maplist(writeln, RESULT).

equal(X, Y) :- X == Y.

tam([],0).
tam([_|XS], T) :- tam(XS, TT), T is TT+1.

send_test(_, [], _, _) :- fail.
send_test(X, [Y|YS], TOBEREMOVED, CONCAT) :- string_chars(X, NEWX), string_chars(Y, NEWY),
            ( match(NEWX, NEWY, TOBECONCAT) ->  TOBEREMOVED = Y, append(NEWX, TOBECONCAT, LISTCONCAT), string_chars(CONCAT, LISTCONCAT)
                                            ; match(NEWY, NEWX, TOBECONCAT) ->  TOBEREMOVED = Y, append(NEWY, TOBECONCAT, LISTCONCAT), string_chars(CONCAT, LISTCONCAT) ;
                                                                     send_test(X, YS, TOBEREMOVED, CONCAT) ).

find_matches([X], [X]).
find_matches([X|XS], RR) :- send_test(X, XS, TOBEREMOVED, CONCAT)   ->  exclude(equal(TOBEREMOVED),XS, NEWTRECHOS), find_matches([CONCAT|NEWTRECHOS], RR)
                                                                        ;   find_matches(XS, R), RR = [X|R].

/*Funcao que encontra o match de prefixo e sufixo entre dois trechos e une
[X|XS] e T1: Trecho 1 - Verfica sufixo
[Y|YS] e T2: Trecho 2 - Verfica prefixo*/
match(T1, T2, UNIAO) :- match(T1, T2, UNIAO, T2, 0).

match([], T2, T2, _, ACC) :- ACC >= 4.
match([X|XS], [Y|YS], UNIAO, T2AUX, ACC) :- (X==Y, ACC1 is (ACC + 1), match(XS, YS, UNIAO, T2AUX, ACC1) -> true
                                                  ; ACC == 0 -> match(XS, T2AUX, UNIAO, T2AUX, ACC) ; fail).
