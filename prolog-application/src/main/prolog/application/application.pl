:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/websocket)).
:- use_module(room_protocol).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- server(8000).

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
		process(Dest,Recp,Json,Reply),
		ws_send(WebSocket, text(Reply)),
		room(WebSocket)
    ).

welcome(_Request) :-
    format('Content-type: text/plain~n~n'),
    format('Prolog Room Is Up And Running!~n').

process("roomHello",_,_,Reply) :-
    Reply = "Received roomHello message".

process(WTF,_,_,Reply) :-
    string_concat("Unknown Destination: ",WTF,Reply).

