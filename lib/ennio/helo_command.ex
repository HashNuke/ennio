defmodule Ennio.HeloCommand do

  alias Ennio.Reply

  def name do
    "HELO"
  end

  def call(conn, _args) do
    Reply.success conn, Ennio.Config.smtp_identity, last: true
    {:ok, conn}
  end
end
