defmodule Ennio.Mime do
  def parse(mail_body) do
    mail_body
    |> split_parts
    |> parse_parts
    |> consolidate_parts
  end


  def parse_parts(parts) do
    parse_parts parts, []
  end


  def parse_parts([], parsed) do
    parsed
  end


  def parse_parts([part | rest], parsed_parts) do
    #TODO parse and assign a map or something
    new_parsed_part = part

    parsed_parts = [new_parsed_part | parsed]
    parse_parts rest, parsed_parts
  end


  def consolidate_parts(parts) do
    #TODO join multiparts to conlidate all the parts
    parts
  end
end
