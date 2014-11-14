-module(chat).
-export([start/0]).
-export([do_answer/0]).
-export([wait/1]).
-export([agent/1]).

do_answer()->
	receive
    	{Agent, "How are you?"} ->
        	io:format("A: ~s~n", ["Fine, thank you!"]),
			Agent! {idle};
		{Agent, Other} ->
        	io:format("Unknown question ~s~n",[Other]),
			Agent! {idle};
    	_ ->
        	ok
	end.

agent(Name)->
   receive
    {online} ->
		io:format("~s online~n",[Name]),
		agent(Name);
	{offline} ->
		io:format("~s offline, please leave me email, I will get back soon!~n",[Name]),
		agent(Name);
	{idle} ->
		io:format("~s available!~n",[Name]),
		agent(Name);
	{answer} ->
		io:format("~s busy!~n",[Name]),
		AnwserPid = spawn(chat,do_answer,[]),
		AnwserPid! {self(), "How are you?"},
		agent(Name)
	end.

wait(AgentPid)->
	{ok, [Question]} = io:fread("Question> ","~255c"),
	io:format("Entered: ~s~n",[Question]).

start()->
   {ok,[Username]} = io:fread("You name> ","~s"),
   io:format("Morning, ~s~n", [Username]),
   AgentPid = spawn(chat,agent,["henry"]),
   AgentPid ! {online},
   wait(AgentPid).


   	
    
 