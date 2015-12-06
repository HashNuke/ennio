defmodule Ennio.SmtpProtocol do
  use GenServer
  @behaviour :ranch_protocol

  @timeout Application.get_env :ennio, :timeout, 5000


  def start_link(ref, socket, transport, options) do
    :proc_lib.start_link(__MODULE__, :init, [ref, socket, transport, options])
  end


  def init(ref, socket, transport, _options) do
    :ok = :proc_lib.init_ack {:ok, self}
    :ok = :ranch.accept_ack ref
    :ok = transport.setopts socket, [active: :once]

    state = %{socket: socket, transport: transport}
    :gen_server.enter_loop __MODULE__, [], state, @timeout
  end


  def handle_info({:tcp, socket, data}, state=%{socket: socket, transport: transport}) do
    :ok = transport.setopts socket, [active: :once]
    :ok = transport.send socket, data
    {:noreply, state, @timeout}
  end

  def handle_info({:tcp_closed, _socket}, state) do
    {:stop, :normal, state}
  end

  def handle_info({:tcp_error, _, reason}, state) do
    {:stop, reason, state}
  end

  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

end
