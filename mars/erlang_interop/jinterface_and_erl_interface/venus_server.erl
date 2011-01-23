-module(venus_server).
-export([start/0]).
     
start() ->
    Pid=spawn(fun venus_age/0), 
    register(venus_server,Pid).


venus_age() ->  
    receive
        {Caller, Age} ->
            Caller ! ((365.26/224.68) * Age),
            venus_age()
    end.
