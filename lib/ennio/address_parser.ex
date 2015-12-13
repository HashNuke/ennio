defmodule Ennio.AddressParser do


  #TODO not required anymore?
  def call(forward_path) do
    try do
      {:ok, forward_path}
    rescue
      _ -> {:error, :syntax}
    end
  end


  def email_pattern do
    ~r/[\w.\-+]+@[\w-]+(\.[\w-]+)+/i
  end


  def mailbox_path_pattern do
    ~r/\<(@[\w-]+(\.[\w-]+)+;)*[\w.\-+]+@[\w-]+(\.[\w-]+)+\>/i
  end


  def mail_from_pattern do
    mail_parameter_pattern("from")
  end


  defp mail_parameter_pattern(name) do
    ~r/#{name}:\ \<(@[\w-]+(\.[\w-]+)+;)*[\w.\-+]+@[\w-]+(\.[\w-]+)+\>/i
  end
end
