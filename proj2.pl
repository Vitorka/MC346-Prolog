% :- initialization main.
% :- use_module(library(readutil)).
%
% /* executar com: swipl -q -g main proj2.pl < trechos  */
%
% main :-
%     read_string(user_input, _, RAWINPUT), split_string(RAWINPUT, "\n", "", LINES), list_trechos(LINES, X), print(X).


tam([],0).
tam([_|XS], T) :- tam(XS, TT), T is TT+1.

/*Pega todos os posfixos de uma lista, com tam >= 4
L: lista com os caracteres da string
R: lista de caracteres com os posfixos da string
ACC: acumulador para montar a lista de posfixos*/
all_postfix(L, R) :- all_postfix(L, R, [L]).

all_postfix([], ACC, ACC).
all_postfix([_|XS], R, ACC) :- tam(XS, T), T >= 4 -> append(ACC, [XS], ACC1), all_postfix(XS, R, ACC1)
                                                  ;all_postfix(XS, R, ACC).

/*Pega todos os prefixos de uma lista, com tam >= 4
L: lista com os caracteres da string
R: lista de caracteres com os prefixos da string
ACC: acumulador para montar a lista de prefixos*/
all_prefix(L, R) :- reverse(L, V), all_prefix(V, R, [L]).

all_prefix([], ACC, ACC).
all_prefix([_|XS], R, ACC) :- tam(XS, T), T >= 4 -> reverse(XS, V), append(ACC, [V], ACC1), all_prefix(XS, R, ACC1)
                                                  ;all_prefix(XS, R, ACC).

/*Pega todos os prefixos e posfixos das strings
PR: lista com os prefixos da string S
PO: lista com os posfixos da string S*/
get_pre_post(S, PR, PO) :- string_chars(S, L), all_prefix(L, PR), all_postfix(L, PO).

/*Obtem prefixos e posfixos para todos os trechos
LT: lista com os trechos de DNA
LPRPO: lista do tuplas que armazenam os prefixos e posfixos dos trechos*/
list_trechos(LT, LPRPO) :- list_trechos(LT, LPRPO, []).

list_trechos([], LPRPO, ACC) :- LPRPO=ACC.
list_trechos([X|XS], LPRPO, ACC) :- get_pre_post(X, PR, PO), append(ACC, [trecho(X, PR, PO)], ACC1), list_trechos(XS, LPRPO, ACC1).

/*Dado duas listas: uma de prefixos e outra de sufixos, verifica se ha sufixos
ou prefixos iguais
[X|XS]: lista com os prefixos de um trecho
[Y|YS]: lista com os sufixos de outro trecho*/
verifica_pref_postf([], _, EQUAL) :- EQUAL="", fail.
verifica_pref_postf(_, [], EQUAL) :- EQUAL="", fail.
verifica_pref_postf([X|_], [Y|_], EQUAL) :- X=Y, EQUAL=X.
verifica_pref_postf([X|XS], [Y|YS], EQUAL) :- tam(X, TX), tam(Y, TY), TX > TY -> verifica_pref_postf(XS, [Y|YS], EQUAL)
                                                                              ; verifica_pref_postf([X|XS], YS, EQUAL).

/*Une dois trechos
T1: trecho que corresponde ao prefixo
T2: trecho que corresponde ao sufixo
EQUAL: parte igual entre os dois trechos
UN: uniao dos dois trechos por meio de seus prefixos e sufixos iguais*/
une_trechos(T1, T2, [], UN) :- append(T2, T1, UN), !.
une_trechos(T1, T2, EQUAL, UN) :- T1=[X|XS], EQUAL=[Y|YS], X=Y,
                                  une_trechos(XS, T2, YS, UN), !.

teste(L, EQUAL, UN) :- list_trechos(L, [trecho(TX, PRX, _), trecho(TY, _, POY)|_]),
                   verifica_pref_postf(PRX, POY, EQUAL),
                   string_chars(TX, T1), string_chars(TY, T2),
                   une_trechos(T1, T2, EQUAL, UNN), string_chars(UN, UNN), !.
