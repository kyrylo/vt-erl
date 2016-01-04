-module(vt_tcp_server_sup).

-behaviour(supervisor).

%% API
-export([start_link/0
        ,start_socket/0]).

%% Supervisor callbacks
-export([init/1]).

-define(TCP_PORT, 7331).
-define(TCP_OPTIONS, [binary, {packet, 0},
                      {reuseaddr, true},
                      {active, once}]).
-define(SUP_FLAGS, {simple_one_for_one, 60, 3600}).
-define(CHILD_SPEC(ListenSocket),
        {socket,
         {vt_tcp_server, start_link, [ListenSocket]},
         temporary, 1000, worker, [vt_tcp]
        }).

%%====================================================================
%% API
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_socket() ->
    supervisor:start_child(?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

init([]) ->
    case gen_tcp:listen(?TCP_PORT, ?TCP_OPTIONS) of
        {ok, ListenSocket} ->
            spawn_link(fun start_socket/0),
            {ok, {?SUP_FLAGS, [?CHILD_SPEC(ListenSocket)]}};
        Result ->
            Result
    end.
