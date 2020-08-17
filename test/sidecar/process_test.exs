defmodule Sidecar.ProcessTest do
  use ExUnit.Case, async: true
  doctest Sidecar.Process

  import ExUnit.CaptureLog

  setup do
    {:ok, id: id()}
  end

  test "logs process output and exits with its status code", %{id: id} do
    test_command("echo #{id}", id)
  end

  test "allows for lazy evaluation of commands", %{id: id} do
    test_command(fn -> "echo #{id}" end, id)
  end

  test "allows for commands in list form", %{id: id} do
    test_command(["echo", id], id)
  end

  test "allows for commands in list form in a function", %{id: id} do
    test_command(fn -> ["echo", id] end, id)
  end

  defp test_command(command, test_output) do
    assert capture_log([async: true], fn ->
             pid =
               start_supervised!(
                 {Sidecar.Process, [name: "echo", command: command]},
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
           end) =~ test_output
  end

  defp id do
    Base.encode16(:crypto.strong_rand_bytes(16))
  end
end
