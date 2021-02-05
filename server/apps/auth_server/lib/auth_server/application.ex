defmodule AuthServer.Application do
  use Application

  @impl true
  def start(_type, _args) do
    certificate_path = Path.join(:code.priv_dir(:auth_server), "certificates")

    children = [
      {Server,
       %{
         name: :PingServer,
         protocol:
           {Server.Protocol.TcpTls,
            %{
              port: 3000,
              cert_path: certificate_path
            }},
         service: {Server.Service.Ping, []}
       }}
    ]

    opts = [strategy: :one_for_one, name: AuthServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
