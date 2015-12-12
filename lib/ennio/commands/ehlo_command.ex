defmodule Ennio.Commands.Ehlo do

  alias Ennio.Reply
  require Logger

  def name do
    "EHLO"
  end

  def call(conn, _args) do
    #TODO accept FQDN as first arg
    Logger.info "#{name} received"
    Reply.success conn, Ennio.Config.identity
    Reply.success conn, extension_names(conn.extensions), multiline: true
    {:ok, conn}
  end


  def extension_names(extensions) do
    Enum.map extensions, fn(ext)-> ext.name end
  end
end
