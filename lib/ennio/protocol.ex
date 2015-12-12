defmodule Ennio.Protocol do
  @behaviour :ranch_protocol

  require Logger
  use GenServer

  alias Ennio.Connection

  @timeout Application.get_env :ennio, :timeout, 10000


  def start_link(ref, socket, transport, options) do
    :proc_lib.start_link(__MODULE__, :init, [ref, socket, transport, options])
  end


  def init(ref, socket, transport, _options) do
    :ok = :proc_lib.init_ack {:ok, self}
    :ok = :ranch.accept_ack ref
    :ok = transport.setopts socket, [active: :once]
    state = Connection.new(socket, transport)

    Ennio.Reply.init state

    Logger.debug "entering listen loop"
    :gen_server.enter_loop __MODULE__, [], state, @timeout
  end

  def handle_info({:tcp, _socket, data}, conn) do
    handle_input(conn, data)
  end

  def handle_info({:tcp_closed, _socket}, state) do
    Logger.debug "TCP closed"
    {:stop, :normal, state}
  end

  def handle_info({:tcp_error, _, reason}, state) do
    Logger.debug "TCP error: #{reason}"
    {:stop, reason, state}
  end

  def handle_info({:ssl, _socket, data}, conn) do
    handle_input(conn, data)
  end

  def handle_info({:ssl_closed, _socket}, state) do
    Logger.debug "SSL closed"
    {:stop, :normal, state}
  end

  def handle_info(:timeout, state) do
    Logger.debug "TCP timeout"
    {:stop, :normal, state}
  end


  defp handle_input(conn, data) do
    Logger.debug "Received secure(#{conn.secure}): #{data}"
    :ok = set_socket_opts conn, [active: :once]

    case Connection.call(conn, data) do
      {:halt, conn} ->
        {:stop, :normal, conn}
      {:ok, conn} ->
        {:noreply, conn, @timeout}
    end
  end


  defp set_socket_opts(conn, opts) do
    if conn.secure == true do
      :ssl.setopts conn.socket, opts
    else
      conn.transport.setopts conn.socket, opts
    end
  end
end
