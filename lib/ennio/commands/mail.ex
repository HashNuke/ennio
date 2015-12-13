defmodule Ennio.Commands.Mail do
  alias Ennio.Reply

  def name, do: "MAIL"


  def call(conn, args) do
    case Ennio.AddressParser.find_email("from", args) do
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


end
