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
:- use_module(room_command).

server(Port) :-
    http_server(http_dispatch, [port(Port)]),
    thread_get_message(_). % prevent process from closing

:- http_handler( /,
		 welcome,
		 []).

:- http_handler( root(room),
                 http_upgrade_to_websocket(init, []),
                 [spawn([])]).

init(WebSocket) :-
    ws_send(WebSocket, text('ack,{"version": [1]}')),
    room(WebSocket).

%% intercepting the websocket stream and then
%% forcing the close, 'seems' too hacky.
room(WebSocket) :-
    ws_receive(WebSocket, Message),
    (   Message.opcode == close
		->  true
		;
 		parse(Message.data,Dest,Recp,Json), !,
		stream_pair(WebSocket,_,Output),
		process(Dest,Recp,Json,Reply,Output,WebSocket),
		ws_send(WebSocket,text(Reply)),
		room(WebSocket)
    ).

welcome(_Request) :-
    format('Content-type: text/plain~n~n'),
    format('Prolog Room Is Up And Running!~n').

process("roomHello",_,Json,Reply,Output,WebSocket) :-
    open_string(Json, JsonStream),
    json_read_dict(JsonStream,JsonDict),
    processHelloEvent(JsonDict,Output),
    ws_send(WebSocket,text("")),
    processContent("/look",JsonDict,Output),
    Reply="".

process("room",_,Json,Reply,Output,_) :-
    open_string(Json, JsonStream),
    json_read_dict(JsonStream,JsonDict),
    processContent(JsonDict.content,JsonDict,Output),
    Reply="".

process(WTF,_,_,Reply,_,_) :-
    string_concat("Unknown Destination: ",WTF,Reply).

    

    

