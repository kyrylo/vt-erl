-module(vt_ws_handler).

-export([init/2
        ,websocket_handle/3
        ,websocket_info/3]).

init(Req, Opts) ->
    lager:info("~p:init ~~ Accepted a WebSocket connection from peer ~p",
               [?MODULE, cowboy_req:peer(Req)]),
    {cowboy_websocket, Req, Opts}.

websocket_handle({text, Msg}, Req, State) ->
	{reply, {text, << "That's what she said! ", Msg/binary >>}, Req, State};
websocket_handle(_Data, Req, State) ->
	{ok, Req, State}.

websocket_info({timeout, _Ref, Msg}, Req, State) ->
	{reply, {text, Msg}, Req, State};
websocket_info(_Info, Req, State) ->
	{ok, Req, State}.
