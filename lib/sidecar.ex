defmodule Sidecar do
  @moduledoc """
  Runs sidecar processes with Elixir apps

  Sidecar's goal is to serve the common need for running sidecar processes
  alongside an Elixir application. For example, one might need to run an
  [ngrok](https://ngrok.io) proxy alongside their Phoenix application in
  order to test incoming webhook URLs.

  One way of solving this problem is by using a tool like
  [foreman](https://github.com/ddollar/foreman), but using this tool isn't
  always desirable. Sidecar allows a developer to specify sidecar processes
  that run as part of their application's supervision tree, instead.

  In order to use Sidecar, first specify a set of processes to run:

  ```elixir
  config :sidecar, processes: [
    ngrok: "ngrok http 4000"
  ]
  ```

  Then, add Sidecar.Supervisor to your app's supervision tree:

  ```elixir
  def start(_type, _args) do
    children = [
      # ...etc.
      Sidecar.Supervisor
    ]
  end
  ```

  Note that sidecar processes can also be specified in the child spec:

  ```elixir
  def start(_type, _args) do
    children = [
      # ...etc.
      {Sidecar.Supervisor, [processes: [ngrok: "ngrok http 4000"]]}
    ]
  end
  ```

  And they can also be lazily evaluated each time the process starts or is
  restarted:

  ```elixir
  def start(_type, _args) do
    children = [
      # ...etc.
      {Sidecar.Supervisor, [processes: [ngrok: fn ->
        "ngrok http \#{MyApp.Endpoint.config(:http)[:port]}"
      end]]}
    ]
  end
  ```
  """
end
