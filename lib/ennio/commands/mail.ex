defmodule Ennio.Commands.Mail do
  alias Ennio.Reply

  def name, do: "MAIL"


  def call(conn, args) do
    case conn.mail do
      nil ->
        parse_and_assign_from_email(conn, args)
      _ ->
        Reply.error(conn, :invalid_command_sequence)
        {:ok, conn}
    end
  end


  defp parse_and_assign_from_email(conn, args) do
    case Ennio.AddressParser.find_email("from", args) do
      :invalid_parameter_syntax ->
        Reply.error(conn, :invalid_parameter_syntax)
      :invalid_mailbox_syntax ->
        Reply.error(conn, :invalid_mailbox_syntax)
      from_email ->
        mail = %Ennio.Mail{from: from_email}
        conn = %Ennio.Connection{conn | mail: mail}
    end
    {:ok, conn}
  end

end
