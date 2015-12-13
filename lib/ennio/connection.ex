defmodule Ennio.Connection do
  alias Ennio.Config

  @inbuilt_commands %{
              "EHLO" => Ennio.Commands.Ehlo,
              "HELO" => Ennio.Commands.Helo,
              "MAIL" => Ennio.Commands.Mail,
              "RCPT" => Ennio.Commands.Rcpt,
              "DATA" => Ennio.Commands.Data,
              "RSET" => Ennio.Commands.Rset,
              "QUIT" => Ennio.Commands.Quit
            }


  defstruct transport: nil,
            socket: nil,
            extensions: nil,
            state: nil,
            mail: nil,
            secure: false
            session_id: nil


  def new(socket, transport) do
    conn = %Ennio.Connection{transport: transport, socket: socket}
    session_id = Ennio.Utils.generate_unique_id
    %Ennio.Connection{conn | extensions: Config.extensions, session_id: session_id }
  end


  def reset(conn) do
    session_id = Ennio.Utils.generate_unique_id
    %Ennio.Connection{conn | nil, session_id: session_id}
  end


  def call(conn, data) do
    #TODO if DATA command is in progress avoid the following
    [command | args] = String.strip(data) |> String.split(" ")
    args = Enum.join args, " "
    require Logger
    Logger.debug data

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


  def output(conn, [response_code, data]) do
    write(conn, "#{response_code} #{data}")
  end


  def output(conn, [response_code, data], last: false) do
    write(conn, "#{response_code}-#{data}")
  end


  defp write(conn, data) do
    if conn.secure == true do
      :ssl.send conn.socket, "#{data}\n"
    else
      conn.transport.send conn.socket, "#{data}\n"
    end
  end


  defp available_commands do
    Config.extensions
    |> Enum.filter_map(&command_extension?/1, &get_command_extension/1)
    |> Enum.into %{}
    |> Map.merge(@inbuilt_commands)
  end


  defp command_extension?(extension) do
    info = extension.init()
    info[:command] != nil
  end


  defp get_command_extension(extension) do
    info = extension.init()
    {info[:command], extension}
  end
end
