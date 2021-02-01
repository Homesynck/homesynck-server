defmodule AuthServer.Application do
  use Application

  @impl true
  def start(_type, _args) do
    certificate_path = Path.join(:code.priv_dir(:auth_server), "certificates")

    children = [
      {Ssltcp.Server, Ssltcp.sup_opts(3000, AuthServer.AuthService, certificate_path)},
      {DynamicSupervisor, name: AuthServer.ServiceSupervisor, strategy: :one_for_one}
    ]

    opts = [strategy: :one_for_one, name: AuthServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
