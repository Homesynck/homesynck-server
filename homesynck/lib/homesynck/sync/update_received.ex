defmodule Homesynck.Sync.UpdateReceived do
  use Ecto.Schema
  import Ecto.Changeset

  schema "updates_received" do
    has_one :update, Homesynck.Sync.Update
    has_one :controller, Homesynck.Sync.Controller

    timestamps()
  end

  @doc false
  def changeset(update_received, attrs) do
    update_received
    |> cast(attrs, [])
    |> validate_required([])
  end
end
