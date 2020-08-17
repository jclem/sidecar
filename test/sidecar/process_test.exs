defmodule Sidecar.ProcessTest do
  use ExUnit.Case, async: true
  doctest Sidecar.Process

  import ExUnit.CaptureLog

  test "logs process output and exits with its status code" do
    assert capture_log([async: true], fn ->
             pid =
               start_supervised!(
                 {Sidecar.Process, [name: "echo", command: "echo Hello from Sidecar.Process"]},
                 restart: :temporary
               )

             ref = Process.monitor(pid)

             receive do
               {:DOWN, ^ref, _, _, {:shutdown, reason}} ->
                 assert reason == {:process_exit, 0}
             after
               1_000 ->
                 raise "Sidecar.Process did not terminate"
             end
           end) =~ "Hello from Sidecar.Process"
  end

  test "allows for lazy evaluation of commands" do
    assert capture_log([async: true], fn ->
             pid =
               start_supervised!(
                 {Sidecar.Process,
                  [name: "echo", command: fn -> "echo Hello from lazy Sidecar.Process" end]},
                 restart: :temporary
               )

             ref = Process.monitor(pid)

             receive do
               {:DOWN, ^ref, _, _, {:shutdown, reason}} ->
                 assert reason == {:process_exit, 0}
             after
               1_000 ->
                 raise "Sidecar.Process did not terminate"
             end
           end) =~ "Hello from lazy Sidecar.Process"
  end
end
