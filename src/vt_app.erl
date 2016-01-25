%%%-------------------------------------------------------------------
%% @doc vt public API
%% @end
%%%-------------------------------------------------------------------

-module(vt_app).

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

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
    {ok, _} = cowboy:start_http(http_listener, 100, [{port, 7332}],
                                [{env, [{dispatch, Dispatch}]}]),

    lager:set_loglevel(lager_console_backend, info),
    vt_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
