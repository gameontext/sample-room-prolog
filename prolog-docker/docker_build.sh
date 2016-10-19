#!/bin/bash

cp ../prolog-application/src/main/prolog/application/application.pl target/application.pl
cp ../prolog-application/src/main/prolog/application/room_protocol.pl target/room_protocol.pl
cp ../prolog-application/src/main/prolog/application/room_command.pl target/room_command.pl
docker build -t prolog .

