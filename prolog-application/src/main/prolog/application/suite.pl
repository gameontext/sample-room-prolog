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

:- module(suite,[
	      move/1,
	      here/1
	  ]).

:- dynamic
        here/1.

here(somewhere).

move(Room):-
  retract(here(_)),
  assert(here(Room)).



