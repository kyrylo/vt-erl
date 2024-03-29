-module(vt).

%% API
-export([start/0
        ,stop/0]).

%%====================================================================
%% API
%%====================================================================

start() ->
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowlib),
    ok = application:start(cowboy),
    ok = application:start(compiler),
    ok = application:start(syntax_tools),
    ok = application:start(goldrush),
    ok = application:start(lager),
    ok = application:start(rmarshal),
    ok = application:start(vt).

stop() ->
    application:stop(vt).
