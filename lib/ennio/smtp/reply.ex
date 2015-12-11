defmodule Ennio.Smtp.Reply do

  def ok(conn) do
    "220 ok"
  end

  def complete(data) do
    "250-#{data}"
  end

  def complete(data, last: true) do
    "250 #{data}"
  end

  def complete(data, multiline: true) do
    count = Enum.count data
    Enum.slice(data, 0, count - 1)
    |> Enum.map(fn(x)-> complete(x) end)

    Enum.at(data, count - 1)
    |> complete(last: true)
  end

  def error(:invalid_command_sequence) do
    #TODO
  end

  def error(:invalid_command) do
    #TODO
  end

  def error(:invalid_recipient_syntax) do
    #TODO
  end

  def error(:invalid_from_syntax) do
    #TODO
  end
end
