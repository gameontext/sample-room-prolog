
/*******************************************************************************
 * Copyright (c) 2016 Ilan Pillemer.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/

:- module(room_protocol, [parse/4,writePreamble/3]).

parse(String,Dest,Recp,Json) :-
    sub_string(String,S1,_,_, "{"),
    S1 > 0,
    S2 is S1 - 1,
    sub_string(String,0,S2,_,R1),
    sub_string(String,S1,_,0,Json),
    split_string(R1,","," \s\t\n",L),
    L = [Dest,Recp].

writePreamble(Output,Direction,UserId) :-
    write(Output,Direction),
    write(Output,","),
    write(Output,UserId),
    write(Output,",").
