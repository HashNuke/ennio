defmodule Ennio.Extensions.StartTls do
  require Logger
  alias Ennio.Reply

  def name, do: "STARTTLS"

  def init do
    %{
      hooks: [:after_data],
      command: "STARTTLS"
    }
  end


  def call(conn, _args) do
    :ok = conn.transport.setopts conn.socket, [active: false]
    Reply.init conn
    {:ok, ssl_socket} = :ssl.ssl_accept conn.socket, Ennio.Config.smtp[:ssl_opts]

    conn = %Ennio.Connection{conn | socket: ssl_socket}
    |> Map.put(:secure, true)

    :ok = :ssl.setopts conn.socket, [active: :once]
    {:ok, conn}
  end

end
