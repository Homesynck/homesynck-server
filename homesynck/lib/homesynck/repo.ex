defmodule Homesynck.Repo do
  use Ecto.Repo,
    otp_app: :homesynck,
    adapter: Ecto.Adapters.Postgres
end
