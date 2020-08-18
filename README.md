# Sidecar [![CI](https://github.com/jclem/sidecar/workflows/CI/badge.svg?branch=main&event=push)](https://github.com/jclem/sidecar/actions?query=event%3Apush+branch%3Amain+workflow%3ACI)

Sidecar makes it easy to run sidecar processes alongside your main
application. This is especially useful in development when you may want to
spin up a process like `npm run dev` or an [ngrok](https://ngrok.io) proxy.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sidecar` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sidecar, "~> 0.5.0"}
  ]
end
```

## Configuration

First, configure your sidecar processes:

```elixir
config :sidecar, processes: [
  ngrok: "ngrok http 4000",
  npm: "npm run dev"
]
```

Then, add the Sidecar supervisor to your application's supervision tree:

```elixir
def start(_type, _args) do
  children = [
    # ...etc.
    Sidecar.Supervisor
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sidecar](https://hexdocs.pm/sidecar).
