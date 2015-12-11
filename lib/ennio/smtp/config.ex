defmodule Ennio.Config do

  def smtp_identity do
    smtp[:identity]
  end

  def smtp_banner do
    "#{smtp[:identity]} EnnioSMTP #{Ennio.version}"
  end

  def smtp_port do
    smtp[:port] || 2525
  end

  def smtp do
    Application.get_env(:ennio, :smtp)
  end
end
