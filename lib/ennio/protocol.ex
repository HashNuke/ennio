defmodule Ennio.Protocol do
  use GenServer

  alias Ennio.Connection
  alias Ennio.Config

  @behaviour :ranch_protocol
  @timeout Application.get_env :ennio, :timeout, 5000


  def start_link(ref, socket, transport, options) do
    :proc_lib.start_link(__MODULE__, :init, [ref, socket, transport, options])
  end


  def init(ref, socket, transport, _options) do
    :ok = :proc_lib.init_ack {:ok, self}
    :ok = :ranch.accept_ack ref
    :ok = transport.setopts socket, [active: :once]

    #TODO move extension detection elsewhere so that it is called only once
    extensions = ["SIZE 2500"]
    state = %Connection{transport: transport, socket: socket, extensions: extensions}
    :gen_server.enter_loop __MODULE__, [], state, @timeout
  end


  def handle_info({:tcp, socket, data}, conn) do
    %Connection{socket: socket, transport: transport, mail: mail} = conn
    :ok = transport.setopts socket, [active: :once]

    case Connection.call(conn, data) do
      {:halt, conn} ->
        {:stop, :normal, conn}
      {:ok, conn} ->
        {:noreply, conn, @timeout}
    end
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
