defmodule Ennio.Smtp.Reply do

  alias Ennio.SmtpConnection
  alias Ennio.Config


  def ok(conn) do
    SmtpConnection.output conn, "250 ok"
  end


  def success(conn, data) do
    SmtpConnection.output conn, "250-#{data}"
  end

  def success(conn, data, last: true) do
    SmtpConnection.output conn, "250 #{data}"
  end

  def success(conn, data, multiline: true) do
    line_count = Enum.count data

    Enum.slice(data, 0, line_count - 1)
    |> Enum.map(fn(x)-> success(conn, x) end)

    last_line = Enum.at(data, line_count - 1)
    success(conn, last_line, last: true)
  end


  def error(conn, :bad_command_sequence) do
    require Logger
    Logger.info "invalid sequence"
    SmtpConnection.output conn, "503 bad sequence of commands"
  end

  def error(conn, :bad_command) do
    require Logger
    Logger.info "invalid command"
    SmtpConnection.output conn, "503 bad command"
  end

  def error(conn, :invalid_recipient_syntax) do
    #TODO
  end

  def error(conn, :invalid_from_syntax) do
    #TODO
  end
end
