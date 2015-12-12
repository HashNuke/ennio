defmodule Ennio.Reply do

  alias Ennio.Connection
  alias Ennio.Config

  # Notes about error codes
  # First digit: ok-2, pending-3, temp-4, error-5
  # Second digit: syntax-0, information-1, connection-2, system-5
  # Third digit: Finer detail that's not documented


  def init(conn) do
    Connection.output conn, [220, Config.banner]
  end


  def will_attempt_delivery(conn) do
    Connection.output conn, [251, "Cannot verify user; Will attempt delivery"]
  end


  def ok(conn) do
    Connection.output conn, [250, "ok"]
  end


  def bye(conn) do
    Connection.output conn, [221, "ok bye"]
  end


  def success(conn, data) do
    Connection.output conn, [250, data]
  end

  def success(conn, data, last: false) do
    Connection.output conn, [250, data], last: false
  end

  # This hack is because in a multi-line reply,
  # every line except the last line
  # will contain a hyphen after the response code
  def success(conn, data, multiline: true) do
    line_count = Enum.count data

    Enum.slice(data, 0, line_count - 1)
    |> Enum.map(fn(line)-> success(conn, line, last: false) end)

    last_line = Enum.at(data, line_count - 1)
    success(conn, last_line)
  end


  def error(conn, :mailbox_unavailable) do
    Connection.output conn, [450, "mailbox unavailable"]
  end

  def error(conn, :bad_command) do
    Connection.output conn, [500, "bad command"]
  end

  def error(conn, :parameter_syntax) do
    Connection.output conn, [501, "syntax error in paramters or arguments"]
  end

  def error(conn, :bad_command_sequence) do
    Connection.output conn, [503, "bad command sequence"]
  end

  def error(conn, :unimplemented_parameter) do
    Connection.output conn, [504, "unimplemented parameter"]
  end

  def error(conn, :wrong_delivery) do
    Connection.output conn, [551, "user not local"]
  end

  def error(conn, :storage_limit_exceeded) do
    Connection.output conn, [552, "storage limit exceeded"]
  end

  def error(conn, :invalid_mailbox_syntax) do
    Connection.output conn, [553, "invalid mailbox syntax"]
  end

  def error(conn, :unsupported_parameter) do
    Connection.output conn, [555, "unsupported parameter"]
  end
end
