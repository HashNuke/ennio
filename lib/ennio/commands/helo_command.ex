defmodule Ennio.Commands.Helo do

  alias Ennio.Reply

  def name do
    "HELO"
  end

  def call(conn, _args) do
    Reply.success conn, Ennio.Config.identity, last: true
    {:ok, conn}
  end
end
