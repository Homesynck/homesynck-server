defmodule Ssltcp do
  @doc """
  Build options for supervision
  """
  def sup_opts(port, service_module, service_state, certificate_path) do
    %{
      :port => port,
      :cert_path => certificate_path,
      :service_type => %{
        :service => service_module,
        :state_initiator => fn s -> [s, service_state] end
      }
    }
  end
end
