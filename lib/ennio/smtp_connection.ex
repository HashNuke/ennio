defmodule Ennio.SmtpConnection do
  defstruct transport: nil, socket: nil, state: nil, mail: nil


  def call(conn, data) do
    {command, args} = process_input(data)

    case command do
      "MAIL" -> process
      "RCPT" ->
      "VRFY" ->
      "EXPN" ->
    end

    command
  end


  def output(conn, data) do
    #TODO output might be an array
  end
end
