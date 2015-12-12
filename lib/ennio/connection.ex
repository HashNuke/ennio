defmodule Ennio.Connection do
  alias Ennio.Config

  require Logger

  defstruct transport: nil,
            socket: nil,
            extensions: nil,
            state: nil,
            mail: nil,
            secure: false


  def new(socket, transport) do
    conn = %Ennio.Connection{transport: transport, socket: socket}
    %{conn | extensions: Config.extensions }
  end



  def call(conn, data) do
    #TODO if DATA command is in progress avoid the following
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
    if conn.secure == true do
      :ssl.send conn.socket, "#{data}\n"
    else
      conn.transport.send conn.socket, "#{data}\n"
    end
  end


  defp available_commands do
    inbuilt = %{
      "EHLO" => Ennio.Commands.Ehlo,
      "HELO" => Ennio.Commands.Helo,
      "MAIL" => Ennio.Commands.Mail,
      "RCPT" => Ennio.Commands.Rcpt,
      "DATA" => Ennio.Commands.Data,
      "RSET" => Ennio.Commands.Rset,
      "QUIT" => Ennio.Commands.Quit
    }

    Config.extensions
    |> Enum.filter_map(&is_command_extension/1, &get_command_extension/1)
    |> Enum.into %{}
    |> Map.merge(inbuilt)
  end


  defp is_command_extension(extension) do
    info = extension.init()
    info[:command] != nil
  end


  defp get_command_extension(extension) do
    info = extension.init()
    {info[:command], extension}
  end
end
