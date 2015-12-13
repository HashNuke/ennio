defmodule Ennio.Commands.Rcpt do
  alias Ennio.Reply

  def name, do: "RCPT"


  def call(conn, args) do
    case conn.mail do
      nil ->
        Reply.error(conn, :invalid_command_sequence)
        {:ok, conn}
      _ ->
        parse_and_assign_to_email(conn, args)
    end
  end


  defp parse_and_assign_to_email(conn, args) do
    case Ennio.AddressParser.find_email("to", args) do
      :invalid_parameter_syntax ->
        Reply.error(conn, :invalid_parameter_syntax)
      :invalid_mailbox_syntax ->
        Reply.error(conn, :invalid_mailbox_syntax)
      email_address ->
        to_addresses = conn.mail.to ++ [email_address]
        mail = %Ennio.Mail{conn.mail | to: to_addresses}
        conn = %Ennio.Connection{conn | mail: mail}
        #TODO reply needs to be better
        #TODO call API module
        Reply.ok conn
    end
    {:ok, conn}
  end

end
