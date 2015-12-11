defmodule Ennio.Smtp.HeloCommand do

  alias Ennio.Smtp.Reply

  def name do
    "HELO"
  end

  def call(conn, _args) do
    Reply.ok conn
    {:ok, conn}
  end
end
