defmodule Ennio.Extensions.Size do
  def init do
    %{
      hooks: [:after_data]
    }
  end


  def name do
    "SIZE #{Ennio.Config.max_size}"
  end


  def call(conn, data) do
    {:ok, conn}
  end

end
