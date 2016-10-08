:- module(room_protocol, [parse/4]).

parse(String,Dest,Recp,Json) :-
    sub_string(String,S1,_,_, "{"),
    S1 > 0,
    S2 is S1 - 1,
    sub_string(String,0,S2,_,R1),
    sub_string(String,S1,_,0,Json),
    split_string(R1,","," \s\t\n",L),
    L = [Dest,Recp].
