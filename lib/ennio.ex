defmodule Ennio do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Ennio.ServerSupervisor, []),
      supervisor(Task.Supervisor, [[name: Ennio.TaskSupervisor]])
    ]

    start_ranch

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ennio.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def start_ranch do
    protocol_options = []
    {:ok, _} = :ranch.start_listener(:ennio, 1, :ranch_tcp, [port: smtp_port], Ennio.SmtpProtocol, protocol_options)
  end


  defp smtp_port do
    Application.get_env(:ennio, :smtp_port, 2525)
  end
end
