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
  Options used to start a sidecar process

  - `name` An identifier for the process
  - `command` The command to run, which is passed to `Port.open/2` using
    `{:spawn, command}`. If the command is a function, the function is
    evaluated just before the sidecar process is started. Its return value will
    be the command.
  """
  @type init_opts :: [name: atom, command: String.t() | (() -> String.t())]

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

    command =
      case Keyword.fetch!(opts, :command) do
        command when is_function(command) ->
          command.()

        command when is_binary(command) ->
          command
      end

    port =
      Port.open(
        {:spawn, "#{Path.join([__DIR__, "..", "..", "portwrap.sh"])} #{command}"},
        [{:line, Keyword.get(opts, :line_length, 1024)}, :exit_status]
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
end
