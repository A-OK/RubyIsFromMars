-module(mars).
-export([mars_age/1]).

mars_age(Age) ->
    Port = open_port({spawn,"ruby mars.rb"},[{packet, 4},
                     nouse_stdio, exit_status, binary]),
    port_command(Port, term_to_binary({mars_age, Age})),
    receive
      {Port, {data, Data}} ->
        {result, Mars_Years} = binary_to_term(Data),
        io:format("~p~n", [Mars_Years])
    end.
