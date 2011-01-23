-module(venus).
-export([venus_age/1]).

venus_age(Earth_Years)->
    Earth_Years * (365.26/224.68).
