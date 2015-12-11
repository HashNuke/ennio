defmodule Ennio.Smtp.Mail do
  defstruct from: nil,
            to: nil,
            headers: [],
            plain_body: nil,
            html_body: nil

  def add_header(mail, name, value) do
    mail.headers = [{name, value} | mail.headers]
  end

end
