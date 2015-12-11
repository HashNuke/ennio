defmodule Ennio.Smtp.HeloCommand do

  alias Ennio.Smtp.Reply

  def name do
    "HELO"
  end

  def call(conn, args) do
    Reply.ok conn
  end
end
