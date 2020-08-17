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
    {:sidecar, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sidecar](https://hexdocs.pm/sidecar).
