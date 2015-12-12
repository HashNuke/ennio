defmodule Ennio.Commands.Ehlo do

  alias Ennio.Reply
  require Logger

  def name, do: "EHLO"

  def call(conn, _args) do
    #TODO accept FQDN as first arg
    Logger.debug "#{name} received"
    Reply.success conn, Ennio.Config.identity, last: false
    Reply.success conn, extension_names(conn), multiline: true
    {:ok, conn}
  end

  def extension_names(conn) do
    if conn.secure do
      Enum.filter_map conn.extensions, &(&1.name != "STARTTLS"), &(&1.name)
    else
      Enum.map conn.extensions, &(&1.name)
    end
  end
end
