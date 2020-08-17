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

  ## Defining Commands

  Process commands can be defined in multiple ways:

  - As a string: `"echo hello"`—the command will be split on whitespace.
  - As a list of strings: `["echo", "hello"]`
  - As a function returning a string or a list of strings: `fn -> ["echo", "hello"] end`

  See `t:Sidecar.Process.command/0` for details.
  """
end
