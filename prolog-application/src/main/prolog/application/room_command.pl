
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

:- module(room_command, [processContent/3]).


writePreamble(Output,Direction,UserId) :-
    write(Output,Direction),
    write(Output,","),
    write(Output,UserId),
    write(Output,",").

processContent("/swagger",JsonDict,Output) :-
    writePreamble(Output,"player",JsonDict.userId),
    
    atom_string(Star,"*"),
    atom_string(UserId,JsonDict.userId),
    string_concat(JsonDict.username," swaggers around the room confusing the pair of dictionaries chatting in the corner.",String),
    Content_Pairs = [Star-String,UserId-"You swagger nonchanlantly about."],
    dict_pairs(Content,_,Content_Pairs),
    json_write_dict(Output,
    		    _{
    			    type:"event",
    			    content:Content,
    			    bookmark:"No bookmarks around here."
    			}).

processContent("/look",JsonDict,Output) :-
    writePreamble(Output,"player",JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"location",
    			    name:"A Prolog Room",
    			    fullName:"A SWI Prolog Room",
    			    description:"In the centre of the room is a large predicate calculus engine, it is humming an old folk tune whilst listening to the local trade unionist (who is also in the room) explain the benefits of joining the union. There is a happy rabbit chasing tadpoles up the state of the union.",
    			    commands:_{'/swagger':"swagger about"},
    			    roomInventory:["cloud","rabbit"]
    			}).


processContent("/go N",JsonDict,Output) :-
    writePreamble(Output,"playerLocation",JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"exit",
    			    content:"You exit happily through the Northern Door, opened for you by the King of the North.",
    			    exitId:"N"
    			}).

processContent("/go S",JsonDict,Output) :-
    writePreamble(Output,"playerLocation",JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"exit",
    			    content:"You exit happily through the Southern Door, opened for you by a penguin.",
    			    exitId:"S"
    			}).

processContent("/go W",JsonDict,Output) :-
    writePreamble(Output,"playerLocation",JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"exit",
    			    content:"You exit happily through the Western Door, opened for you by the Wicked Witch of the West.",
    			    exitId:"W"
    			}).

processContent("/go E",JsonDict,Output) :-
    writePreamble(Output,"playerLocation",JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"exit",
    			    content:"You exit happily through the Eastern Door, opened for you by politely by Mr Miyagi.",
    			    exitId:"E"
    			}).

processContent("/inventory",JsonDict,Output) :-
    writePreamble(Output,"player",JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"event",
    			    content:_{'*':"You try and look at you inventory and realise that state does not yet exist, whether inside or outside of this reality. You scream out to the universe in perplexity, and get told by a still quiet voice to be patient, its being looked at soon."},
    			    bookmark:"Please, next please."
    			}).

processContent("/examine cloud",JsonDict,Output) :-
    writePreamble(Output,"player",JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"event",
    			    content:_{'*':"You look closely at the cloud, it looks back closely at you."},
    			    bookmark:"Please, next please."
    			}).

processContent("/examine rabbit",JsonDict,Output) :-
    writePreamble(Output,"player",JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"event",
    			    content:_{'*':"The rabbit tells you that this room is still a work in progress, and please look at https://github.com/ilanpillemer/gameon-room-prolog for more details and speak to @ilanpillemer"},
    			    bookmark:"Please, next please."
    			}).

processContent(_,JsonDict,Output) :-
    write(Output,"player,*,"),
    json_write_dict(Output,
    		    _{
    			    type:"chat",
    			    username:JsonDict.username,
    			    content:JsonDict.content,
    			    bookmark:"not_implemented"
    			}).



