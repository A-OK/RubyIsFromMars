-module(mars_client).
-export([mars_age/1]).

mars_age(Age) ->
  {'mars_server','mars_server@localhost'} ! {self(), Age},
  receive
    Mars_Years  ->
      io:format("~p~n", [Mars_Years])
  end.
