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

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/websocket)).

:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).

:- use_module(room_protocol).


server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- server(8000).

stop :-
    http_stop_server(8000, []).


:- http_handler( /,
		 welcome,
		 []).

:- http_handler( root(room),
                 http_upgrade_to_websocket(init, []),
                 [spawn([])]).

init(WebSocket) :-
    ws_send(WebSocket, text('ack,{"version": [1]}')),
    room(WebSocket).

room(WebSocket) :-
    ws_receive(WebSocket, Message),
    (   Message.opcode == close
		->  true
		;
 		parse(Message.data,Dest,Recp,Json), !,
		stream_pair(WebSocket,_,Output),
		process(Dest,Recp,Json,Reply,Output),
		ws_send(WebSocket,text("")),
		room(WebSocket)
    ).

welcome(_Request) :-
    format('Content-type: text/plain~n~n'),
    format('Prolog Room Is Up And Running!~n').


:- json_object
       point(x:integer, y:integer).

process("roomHello",_,_,Reply,Output) :-
    prolog_to_json(point(25,50), Reply),
    write(Output,'player,*,'),
    json_write(Output,Reply).


process(WTF,_,_,Reply,_) :-
    string_concat("Unknown Destination: ",WTF,Reply).
    

