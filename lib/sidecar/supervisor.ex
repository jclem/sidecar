defmodule Sidecar.Supervisor do
  @moduledoc """
  Supervises a list of sidecar processes
  """

  use Supervisor

  def start_link(init_opts \\ []) do
    opts = Keyword.merge(Application.get_all_env(:sidecar), init_opts)
    Supervisor.start_link(__MODULE__, opts)
  end

  @impl true
  def init(init_opts) do
    children =
      init_opts
      |> Keyword.get(:processes, [])
      |> Enum.map(fn {id, command} ->
        Supervisor.child_spec({Sidecar.Process, [command: command, name: id]}, id: id)
      end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
