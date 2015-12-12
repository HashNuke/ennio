defmodule Ennio.Config do

  def identity do
    smtp[:identity]
  end

  def banner do
    "#{identity} EnnioSMTP #{Ennio.version}"
  end

  def port do
    smtp[:port] || 2525
  end

  def max_size do
    smtp[:max_size] || 100000
  end


  def extensions do
    if smtp[:only_extensions] do
      smtp[:only_extensions]
    else
      additional_extensions = smtp[:extensions] || []
      inbuilt_extensions ++ additional_extensions
    end
  end


  def smtp do
    Application.get_env(:ennio, :smtp)
  end


  defp inbuilt_extensions do
    [
      Ennio.Extensions.Size,
      Ennio.Extensions.StartTls
    ]
  end
end
