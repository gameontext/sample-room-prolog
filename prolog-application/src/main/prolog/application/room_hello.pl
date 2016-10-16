
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

:- module(room_hello, [processHelloEvent/2,processLocationResponse/2]).

 processHelloEvent(JsonDict,Output) :-
    write(Output,'player,*,'),
    atom_string(Star,"*"),
    atom_string(UserId,JsonDict.userId),
    string_concat("Player ",JsonDict.username,S1),
    string_concat(S1," has entered into the room and started laughing hysterically.",S2),
    Content_Pairs = [Star-S2,UserId-"You have entered a slightly threadbare Prolog Room. Nothing to see (yet)."],
    dict_pairs(Content,_,Content_Pairs),
    Event = [type-"event",
	 content-Content,
	 bookmark-0 % bookmark functionality not in use
	],
    dict_pairs(D,_,Event),
    json_write_dict(Output,D).

processLocationResponse(JsonDict,Output) :-
    string_concat("player,",JsonDict.userId,S1),
    string_concat(S1,",",S2),
    write(Output,S2),
    json_write_dict(Output,
    		    _{
    			    type:"location",
    			    name:"A Prolog Room",
    			    fullName:"A SWI Prolog Room",
    			    description:"In the centre of the room is a large predicate calculus engine, it is humming an old folk tune whilst listening to the local trade unionist (who is also in the room) explain the benefits of joining the union. There is a happy rabbit chasing tadpoles up the state of the union.",
    			    commands:_{
    			    		     '/swagger':"swagger about"
    			    		 },
    			    roomInventory:["cloud","rabbit"]
    			}).



