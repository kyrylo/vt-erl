REBAR=./rebar3

.PHONY: all

all: compile run

compile:
	@$(REBAR) compile

run:
	erl -pa _build/default/lib/*/ebin/ -s vt
