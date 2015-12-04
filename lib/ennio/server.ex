defmodule Ennio.Server do
  import Supervisor.Spec, warn: false

  def start(module, options) do
    IO.inspect options
  end


  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    options = [:binary, packet: :line, active: false, reuseaddr: true]
    {:ok, socket} = :gen_tcp.listen(port, options)
    IO.puts "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end


  defp loop_acceptor(socket) do
    {:ok, accepted_client} = :gen_tcp.accept(socket)
    {:ok, tcp_task_pid} = Task.Supervisor.start_child(
      Ennio.TaskSupervisor,
      fn -> serve(accepted_client) end
    )

    :ok = :gen_tcp.controlling_process(accepted_client, tcp_task_pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> process_line
  end

  defp process_line(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        write_line "You said #{data}", socket
        serve(socket)
      {:error, _} -> true
    end
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
