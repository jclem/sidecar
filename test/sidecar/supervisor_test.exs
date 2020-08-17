defmodule Sidecar.SupervisorTest do
  use ExUnit.Case, async: true
  doctest Sidecar.Supervisor

  import ExUnit.CaptureLog

  test "supervises a list of processes" do
    assert capture_log([async: true], fn ->
             pid =
               start_supervised!(
                 {Sidecar.Supervisor,
                  [processes: [name: "echo", command: "echo Hello from Sidecar.Supervisor"]]},
                 restart: :temporary
               )

             # TODO: I'm not sure how to avoid just waiting for "echo" to run.
             Process.sleep(500)

             Process.exit(pid, :normal)
           end) =~ "Hello from Sidecar.Supervisor"
  end
end
