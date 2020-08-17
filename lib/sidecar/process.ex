defmodule Sidecar.Process do
  @moduledoc """
  Supervises a single sidecar process

  It is recommended one uses `Sidecar.Supervisor` to run sidecar processes,
  rather than using this module manually.
  """

  @doc false
  use GenServer

  require Logger

  @typedoc """
  A command that starts a sidecar process

  If a function, the function will be evaluated just before the sidecar
  process starts.

  A command that is a string or a function returning a string will be split
  on whitespace.

  ## Examples

  *The command is the value in each of these keyword lists.*

  ### A string

  ```elixir
  [ngrok: "ngrok http 4000"]
  ```

  ### A list of strings

  ```elixir
  [ngrok: ~w(ngrok http 4000)]
  ```

  ### A function returning a string

  ```elixir
  [ngrok: fn -> "ngrok http \#{MyApp.Endpoint.config(:http)[:port]}" end]
  ```

  ### A function returning a list of strings

  ```elixir
  [ngrok: fn -> ["ngrok", "http", MyApp.Endpoint.config(:http)[:port]] end]
  ```
  """
  @type command :: String.t() | (() -> String.t()) | [String.t()] | (() -> [String.t()])

  @typedoc """
  Options used to start a sidecar process

  - `name` An identifier for the process
  - `command` The command to run, which is passed to `Port.open/2` using
    `{:spawn, command}`. If the command is a function, the function is
    evaluated just before the sidecar process is started. Its return value will
    be the command.
  """
  @type init_opts :: [name: atom, command: command]

  @doc """
  Start a supervised sidecar process.
  """
  @spec start_link(init_opts) :: GenServer.on_start()
  def start_link(init_opts) do
    GenServer.start_link(__MODULE__, init_opts)
  end

  @impl true
  def init(opts) do
    Logger.metadata(sidecar: Keyword.fetch!(opts, :name))

    command = opts |> Keyword.fetch!(:command) |> normalize_command()

    port =
      Port.open(
        {:spawn_executable, Path.join([__DIR__, "..", "..", "portwrap.sh"])},
        [
          :exit_status,
          line: Keyword.get(opts, :line_length, 1024),
          args: command
        ]
      )

    {:ok, %{port: port}}
  end

  @impl true
  def handle_info({_port, {:data, {_eol, data}}}, state) do
    Logger.info(data)
    {:noreply, state}
  end

  def handle_info({_port, {:exit_status, exit_status}}, state) do
    Logger.warn("process_exit=#{exit_status}")
    {:stop, {:shutdown, {:process_exit, exit_status}}, state}
  end

  defp normalize_command(command) when is_function(command), do: normalize_command(command.())
  defp normalize_command(command) when is_binary(command), do: String.split(command, ~r/\s/)
  defp normalize_command(command) when is_list(command), do: command
end
