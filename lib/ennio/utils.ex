defmodule Ennio.Utils do

  def dns_mx_records(domain) do
    :inet_res.lookup '#{domain}', :in, :mx
  end


  def generate_unique_id do
    :crypto.strong_rand_bytes(18) |> Base.encode64
  end

end
