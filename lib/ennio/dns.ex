defmodule Ennio.Dns do

  def mx_records(domain) do
    inet_res.lookup '#{domain}', :in, :mx
  end


  def reverse_lookup do
    #TODO
  end


end
