defmodule Ennio.Connection do
  require Logger

  defstruct transport: nil,
            socket: nil,
            extensions: nil,
            idenity: nil,
            state: nil,
            mail: nil


  def call(conn, data) do
    [command | args] = String.strip(data) |> String.split(" ")

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
      "EHLO" => Ennio.EhloCommand,
      "HELO" => Ennio.HeloCommand,
      "MAIL" => Ennio.MailCommand,
      "RCPT" => Ennio.RcptCommand,
      "DATA" => Ennio.DataCommand
    }
  end

end
