defmodule Ennio do
  use Application

  alias Ennio.Config
  require Logger

  @version Mix.Project.config[:version]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Ennio.ServerSupervisor, []),
      # supervisor(Task.Supervisor, [[name: Ennio.TaskSupervisor]])
    ]

    start_ranch

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ennio.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def start_ranch do
    protocol_options = []
    port = Config.port
    ranch_tcp_opts = [port: port]
    # ranch_ssl_opts = [
    #   port: port,
    #   certfile: '/Users/HashNuke/Desktop/certs/server.crt',
    #   cacertfile: '/Users/HashNuke/Desktop/certs/server.csr',
    #   keyfile: '/Users/HashNuke/Desktop/certs/server.key',
    #   verify: :verify_peer
    # ]
    {:ok, _} = :ranch.start_listener(:ennio, 1, :ranch_tcp, ranch_tcp_opts, Ennio.Protocol, protocol_options)
    Logger.info "SMTP server started on port #{port}"
  end


  def version, do: @version
end
