defmodule Ennio.AddressParser do

  def find_email(param_name, args) do
    case find_mailbox_param(param_name, args) do
      :invalid_parameter_syntax -> :invalid_parameter_syntax
      from_param ->
        case Regex.scan(email_pattern, from_param) do
          [] -> :invalid_mailbox_syntax
          results ->
            [[ email | _rest ]] = results
            email
        end
    end
  end


  def find_mailbox_param(name, args) do
    pattern = mailbox_param_pattern(name)
    case Regex.scan(pattern, args) do
      [] -> :invalid_parameter_syntax
      results ->
        [[ match | _rest ]] = results
        match
    end
  end


  def email_pattern do
    ~r/[\w.\-+]+@[\w-]+(\.[\w-]+)+/i
  end


  def mailbox_path_pattern do
    ~r/\<(@[\w-]+(\.[\w-]+)+;)*[\w.\-+]+@[\w-]+(\.[\w-]+)+\>/i
  end


  defp mailbox_param_pattern(name) do
    ~r/#{name}:\ \<(@[\w-]+(\.[\w-]+)+;)*[\w.\-+]+@[\w-]+(\.[\w-]+)+\>/i
  end
end
