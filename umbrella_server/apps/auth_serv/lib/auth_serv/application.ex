defmodule AuthServ.Application do
  use Application

  @impl true
  def start(_type, _args) do
    ch_state = %{
      :port => 3000,
      :service_type => %{
        :worker => AuthServ.Application,
        :state_initiator => fn s -> [s] end
      }}

    children = [
      {SSLTCP.Server, ch_state},
      {DynamicSupervisor, name: AuthServ.ServiceSupervisor, strategy: :one_for_one}
    ]

    opts = [strategy: :one_for_one, name: AuthServ.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
