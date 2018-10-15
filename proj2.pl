:- initialization main.
:- use_module(library(readutil)).

/* executar com: swipl -q -g main proj2.pl < trechos  */

main :-     
    read_string(user_input, _, RAWINPUT), split_string(RAWINPUT, "\n", "", LINES), list_trechos(LINES, X), print(X). 


tam([],0).
tam([_|XS], T) :- tam(XS, TT), T is TT+1.

/*Pega todos os posfixos de uma lista, com tam >= 4
L: lista com os caracteres da string
R: lista de caracteres com os posfixos da string
ACC: acumulador para montar a lista de posfixos*/
all_postfix(L, R) :- all_postfix(L, R, [L]).

all_postfix([], ACC, ACC).
all_postfix([X|XS], R, ACC) :- tam(XS, T), T >= 4 -> append(ACC, [XS], ACC1), all_postfix(XS, R, ACC1)
                                                  ;all_postfix(XS, R, ACC).

/*Pega todos os prefixos de uma lista, com tam >= 4
L: lista com os caracteres da string
R: lista de caracteres com os prefixos da string
ACC: acumulador para montar a lista de prefixos*/
all_prefix(L, R) :- reverse(L, V), all_prefix(V, R, [L]).

all_prefix([], ACC, ACC).
all_prefix([X|XS], R, ACC) :- tam(XS, T), T >= 4 -> reverse(XS, V), append(ACC, [V], ACC1), all_prefix(XS, R, ACC1)
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
