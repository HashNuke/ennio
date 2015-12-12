defmodule Ennio.Extensions.StartTls do
  require Logger
  alias Ennio.Reply

  def init do
    %{
      hooks: [:after_data],
      command: "STARTTLS"
    }
  end


  def name do
    "STARTTLS"
  end


  def call(conn, data) do
    Logger.debug "STARTTLS"
    ssl_opts = [
      certfile: '/Users/HashNuke/Desktop/certs/server.crt',
      cacertfile: '/Users/HashNuke/Desktop/certs/server.csr',
      keyfile: '/Users/HashNuke/Desktop/certs/server.key',
      verify: :verify_peer
    ]
    {:ok, new_socket} = :ssl.ssl_accept conn.socket, ssl_opts
    Reply.init %{conn | socket: new_socket}
    {:ok, conn}
  end

end
