%%%-------------------------------------------------------------------
%% @doc vt public API
%% @end
%%%-------------------------------------------------------------------

-module(vt_app).

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

-define(HTTP_PORT, 7332).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile(
                 [{'_',
                   [
                    {"/", vt_web_handler, []},
                    {"/ws", vt_ws_handler, []}
                   ]
                  }]),
    lager:info("~p:init ~~ Starting an HTTP server - 127.0.0.1:~p",
               [?MODULE, ?HTTP_PORT]),
    lager:info("~p:init ~~ Starting a WebSocket server - 127.0.0.1:~p/ws",
               [?MODULE, ?HTTP_PORT]),
    {ok, _} = cowboy:start_http(http_listener, 100, [{port, ?HTTP_PORT}],
                                [{env, [{dispatch, Dispatch}]}]),

    lager:set_loglevel(lager_console_backend, info),
    vt_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
