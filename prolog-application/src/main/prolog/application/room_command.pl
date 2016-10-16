
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


writePreamble(Output,UserId) :-
    write(Output,"playerLocation,"),
    write(Output,UserId),
    write(Output,",").

processContent("/go N",JsonDict,Output) :-
    writePreamble(Output, JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"exit",
    			    content:"You exit happily through the Northern Door, opened for you by the King of the North.",
    			    exitId:"N"
    			}).

processContent("/go S",JsonDict,Output) :-
    writePreamble(Output, JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"exit",
    			    content:"You exit happily through the Southern Door, opened for you by a penguin.",
    			    exitId:"S"
    			}).

processContent("/go W",JsonDict,Output) :-
    writePreamble(Output, JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"exit",
    			    content:"You exit happily through the Western Door, opened for you by the Wicked Witch of the West.",
    			    exitId:"W"
    			}).

processContent("/go E",JsonDict,Output) :-
    writePreamble(Output, JsonDict.userId),
    json_write_dict(Output,
    		    _{
    			    type:"exit",
    			    content:"You exit happily through the Eastern Door, opened for you by politely by Mr Miyagi.",
    			    exitId:"E"
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



