defmodule Ennio.Mail do

  defstruct from: nil,
            to: nil,
            headers: [],
            plain_body: nil,
            html_body: nil

  def add_header(mail, name, value) do
    updated_headers = [{name, value} | mail.headers]
    %{ mail | headers: updated_headers }
  end

end
