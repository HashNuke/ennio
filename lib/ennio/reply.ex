defmodule Ennio.Reply do

  alias Ennio.Connection
  alias Ennio.Config


  def init(conn) do
    Connection.output conn, "220 #{Config.banner}"
  end


  def ok(conn) do
    Connection.output conn, "250 ok"
  end


  def bye(conn) do
    Connection.output conn, "221 ok bye"
  end


  def success(conn, data) do
    Connection.output conn, "250-#{data}"
  end

  def success(conn, data, last: true) do
    Connection.output conn, "250 #{data}"
  end

  def success(conn, data, multiline: true) do
    line_count = Enum.count data

    Enum.slice(data, 0, line_count - 1)
    |> Enum.map(fn(x)-> success(conn, x) end)

    last_line = Enum.at(data, line_count - 1)
    success(conn, last_line, last: true)
  end


  def error(conn, :bad_command_sequence) do
    Connection.output conn, "503 bad sequence of commands"
  end

  def error(conn, :bad_command) do
    Connection.output conn, "503 bad command"
  end

  def error(conn, :invalid_recipient_syntax) do
    #TODO
  end

  def error(conn, :invalid_from_syntax) do
    #TODO
  end
end
