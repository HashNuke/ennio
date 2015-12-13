defmodule Ennio.Commands.Mail do
  alias Ennio.Reply
  alias Ennio.AddressParser

  def name, do: "MAIL"


  def call(conn, args) do
    case find_email(args) do
      :invalid_parameter_syntax ->
        Reply.error(conn, :invalid_parameter_syntax)
      :invalid_mailbox_syntax ->
        Reply.error(conn, :invalid_mailbox_syntax)
      from_email ->
        mail = %Ennio.Mail{from: from_email}
        conn = %Ennio.Connection{conn | mail: mail}
        IO.inspect conn
    end
    {:ok, conn}
  end


  def find_email(args) do
    arg_string = Enum.join args, " "

    case find_from_param(arg_string) do
      :invalid_parameter_syntax -> :invalid_parameter_syntax
      from_param ->
        case Regex.scan(AddressParser.email_pattern, from_param) do
          [] -> :invalid_mailbox_syntax
          results ->
            [[ email | _rest ]] = results
            email
        end
    end
  end


  def find_from_param(arg_string) do
    case Regex.scan(AddressParser.mail_from_pattern, arg_string) do
      [] -> :invalid_parameter_syntax
      results ->
        [[ match | _rest ]] = results
        match
    end
  end

end
