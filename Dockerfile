FROM jdubz/elixir-phoenix:1.7.3

MAINTAINER Josh Williams <vmizzle@gmail.com>

WORKDIR /usr/src/app

RUN apk add --no-cache build-base

COPY mix.exs /usr/src/app
COPY mix.lock /usr/src/app

ENV MIX_ENV=dev

RUN mix local.hex --force && \
	mix local.rebar --force && \
	yes | mix deps.get && \
	mix deps.compile

COPY . /usr/src/app

ENV RELX_REPLACE_OS_VARS true

EXPOSE 4000

CMD ["mix", "phx.server"]
