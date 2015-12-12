defmodule Ennio.Commands.Helo do

  alias Ennio.Reply

  def name, do: "HELO"

  def call(conn, _args) do
    Reply.success conn, Ennio.Config.identity
    {:ok, conn}
  end
end
