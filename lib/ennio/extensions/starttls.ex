defmodule Ennio.Extensions.StartTls do
  require Logger
  alias Ennio.Reply

  def init do
    %{
      hooks: [:after_data],
      command: "STARTTLS"
    }
  end


  def name, do: "STARTTLS"


  def call(conn, data) do
    Logger.debug "#{name} received"

    # try moving this after the ssl_accept
    :ok = conn.transport.setopts conn.socket, [active: false]

    Reply.init conn
    Logger.debug "SSL Accepting..."
    {:ok, ssl_socket} = :ssl.ssl_accept conn.socket, Ennio.Config.smtp[:ssl_opts]

    # :ok = conn.transport.setopts conn.socket, [active: :once]

    Logger.debug "Accepted SSL connection"
    conn = %Ennio.Connection{conn | socket: ssl_socket}
    |> Map.put(:secure, true)

    # :ok = :ssl.controlling_process(conn.socket, self)
    :ok = :ssl.setopts conn.socket, [active: :once]
    {:ok, conn}
  end

end
