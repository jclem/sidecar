defmodule Sidecar.Process do
  @moduledoc """
  Supervises a single sidecar process
  """

  use GenServer

  require Logger

  def start_link(init_opts) do
    GenServer.start_link(__MODULE__, init_opts)
  end

  @impl true
  def init(opts) do
    Logger.metadata(sidecar_process: Keyword.get(opts, :name))

    cmd = get_cmd(opts)

    port =
      Port.open(
        {:spawn, "#{Path.join([__DIR__, "..", "..", "portwrap.sh"])} #{cmd}"},
        [{:line, Keyword.get(opts, :line_length, 1024)}]
      )

    {:ok, %{port: port}}
  end

  @impl true
  def handle_info({_port, {:data, {_eol, data}}}, state) do
    Logger.info(data)
    {:noreply, state}
  end

  defp get_cmd(opts) do
    Keyword.get(opts, :command)
  end
end