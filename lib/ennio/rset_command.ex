defmodule Ennio.RsetCommand do

  alias Ennio.Reply

  def name do
    "RSET"
  end

  def call(conn, _args) do
    conn = %Ennio.Connection{conn | mail: %Ennio.Mail{} }
    Reply.ok conn
    {:ok, conn}
  end
end
