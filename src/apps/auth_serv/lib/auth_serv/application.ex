defmodule AuthServ.Application do
  use Application

  @impl true
  def start(_type, _args) do
    certificate_path = Path.join(:code.priv_dir(:auth_serv), "certificates")

    children = [
      {Ssltcp.Server, Ssltcp.sup_opts(3000, 0, 0, certificate_path)},
      {DynamicSupervisor, name: AuthServ.ServiceSupervisor, strategy: :one_for_one}
    ]

    opts = [strategy: :one_for_one, name: AuthServ.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
