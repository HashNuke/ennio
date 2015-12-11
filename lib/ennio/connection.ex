defmodule Ennio.Connection do
  alias Ennio.Config

  require Logger

  defstruct transport: nil,
            socket: nil,
            extensions: nil,
            state: nil,
            mail: nil


  def new(socket, transport) do
    conn = %Ennio.Connection{transport: transport, socket: socket}
    %{conn | extensions: Config.extensions }
  end



  def call(conn, data) do
    #TODO if data command is in progress avoid the following
    [command | args] = String.strip(data) |> String.split(" ")

    # This avoids pattern matching
    command = String.upcase command

    case Map.get(available_commands, command) do
      nil ->
        Ennio.Reply.error(conn, :bad_command)
        {:ok, conn}
      module ->
        module.call(conn, args)
    end
  end


  def output(conn, data) do
    conn.transport.send conn.socket, "#{data}\n"
  end


  defp available_commands do
    %{
      "EHLO" => Ennio.Commands.Ehlo,
      "HELO" => Ennio.Commands.Helo,
      "MAIL" => Ennio.Commands.Mail,
      "RCPT" => Ennio.Commands.Rcpt,
      "DATA" => Ennio.Commands.Data,
      "RSET" => Ennio.Commands.Rset,
      "QUIT" => Ennio.Commands.Quit
    }
  end

end
