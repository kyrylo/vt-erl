-module(vt_ws_handler).

-export([init/2
        ,websocket_handle/3
        ,websocket_info/3
        ,terminate/3]).

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


terminate(timeout, Req, _State) ->
    lager:info("~p:terminate ~~ Peer ~p timed out",
               [?MODULE, cowboy_req:peer(Req)]);
terminate(remote, Req, _State) ->
    lager:info("~p:terminate ~~ Peer ~p normally closed connection",
               [?MODULE, cowboy_req:peer(Req)]);
terminate({remote, CloseCode, _Bin}, Req, _State) ->
    lager:info("~p:terminate ~~ Peer ~p abruptly closed connection (close code ~p)",
               [?MODULE, cowboy_req:peer(Req), CloseCode]);
terminate({error, Reason}, Req, _State) ->
    lager:error("~p:terminate ~~ Peer ~p closed connection due to an error (~p)",
               [?MODULE, cowboy_req:peer(Req), Reason]);
terminate({crash, Class, Reason}, Req, _State) ->
    lager:error("~p:terminate ~~ Peer ~p closed connection: ~p  (~p)",
                [?MODULE, cowboy_req:peer(Req), Reason, Class]);
terminate(Reason, _Req, _State) ->
    lager:info("~p:terminate ~~ Terminate reason: ~p", [Reason]).
