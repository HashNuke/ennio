defmodule Ennio.Smtp.EhloCommand do

  alias Ennio.Smtp.Reply

  def name do
    "EHLO"
  end

  def call(conn, args) do
    Reply.complete conn, conn.extensions, multiline: true
  end
end
