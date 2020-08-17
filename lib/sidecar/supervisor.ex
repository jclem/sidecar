defmodule Sidecar.Supervisor do
  @moduledoc """
  Supervises a list of sidecar processes
  """

  @doc false
  use Supervisor

  @typedoc """
  Options used to start a list of sidecar processes.

  - `processes` A keyword list of processes to start whose keys are unique
    process identifiers, and whose values are `t:Sidecar.Process.init_opts/0`
    lists
  """
  @type init_opts :: [processes: Keyword.t(Sidecar.Process.init_opts())]

  @doc """
  Start one or more supervised sidecar processes.

  ## Examples

  ```elixir
  Sidecar.Supervisor.start_link(processes: [
    ngrok: "ngrok http 4000"
  ])
  ```
  """
  @spec start_link(init_opts) :: Supervisor.on_start()
  def start_link(init_opts \\ []) do
    opts = Keyword.merge(Application.get_all_env(:sidecar), init_opts)
    Supervisor.start_link(__MODULE__, opts)
  end

  @impl true
  def init(init_opts) do
    children =
      init_opts
      |> Keyword.get(:processes, [])
      |> Enum.map(fn {name, command} ->
        Supervisor.child_spec({Sidecar.Process, [command: command, name: name]}, id: name)
      end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
