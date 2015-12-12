defmodule Ennio.Commands.Rset do
  alias Ennio.Reply

  def name, do: "RSET"

  def call(conn, _args) do
    if conn.secure do
      :ok = :ssl.renegotiate conn.socket
    end

    conn = %Ennio.Connection{conn | mail: %Ennio.Mail{}}
    Reply.ok conn
    {:ok, conn}
  end
end
