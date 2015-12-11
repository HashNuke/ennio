defmodule Ennio.Smtp.EhloCommand do

  alias Ennio.Smtp.Reply

  def name do
    "EHLO"
  end

  def call(conn, _args) do
    #TODO accept FQDN as first arg
    Reply.success conn, Ennio.Config.smtp_identity
    Reply.success conn, conn.extensions, multiline: true
    {:ok, conn}
  end
end
