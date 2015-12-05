defmodule Ennio.SmtpProtocol do
  @behaviour :ranch_protocol

  def start_link(ref, socket, transport, options) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, options])
    {:ok, pid}
  end


  def init(ref, socket, transport, _options = []) do
    :ok = :ranch.accept_ack(ref)
    loop(socket, transport)
  end


  def loop(socket, transport) do
    case transport.recv(socket, 0, 5000) do
      {:ok, data} ->
        transport.send(socket, data)
        loop(socket, transport)
      _ ->
        :ok = transport.close(socket)
    end
  end

end
