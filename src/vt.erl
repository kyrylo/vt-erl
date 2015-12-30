-module(vt).

%% Application callbacks
-export([start/0,
         stop/0]).

%%====================================================================
%% API
%%====================================================================

start() ->
    application:start(vt).

stop() ->
    application:stop(vt).
