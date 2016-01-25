-module(vt_tcp_server).

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3]).

-record(state, {socket}).

%%====================================================================
%% API
%%====================================================================

start_link(Socket) ->
    gen_server:start_link(?MODULE, Socket, []).

%%====================================================================
%% gen_server callbacks
%%====================================================================

init(Socket) ->
    gen_server:cast(self(), accept),
    {ok, #state{socket=Socket}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(accept, State = #state{socket=ListenSocket}) ->
    case gen_tcp:accept(ListenSocket) of
        {ok, AcceptSocket} ->
            vt_tcp_server_sup:start_socket(),
            lager:info("~p:handle_cast ~~ Accepted a new TCP connection on ~p", [?MODULE, AcceptSocket]),
            {noreply, State#state{socket=AcceptSocket}};
        {error, Reason} ->
            lager:error("~p:handle_cast ~~ Error: ~p~n", [?MODULE, Reason]),
            {noreply, State}
    end.

handle_info({tcp, _Socket, Data}, State) ->
    {noreply, State};
handle_info({tcp_closed, _Socket}, State = #state{socket=AcceptSocket}) ->
    lager:info("~p:handle_info ~~ The TCP connection was closed on ~p", [?MODULE, AcceptSocket]),
    {stop, normal, State};
handle_info({tcp_error, _Socket, Reason}, State) ->
    lager:error("~p:handle_info ~~ Error: ~p~n", [?MODULE, Reason]),
    {stop, normal, State};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(normal, _State) ->
    ok;
terminate(Reason, _State) ->
    io:format("terminate reason: ~p~n", [Reason]).

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
