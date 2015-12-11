defmodule Ennio.Commands.Quit do

  alias Ennio.Reply

  def name do
    "QUIT"
  end

  def call(conn, _args) do
    Reply.bye conn
    {:halt, conn}
  end
end
