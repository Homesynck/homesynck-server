defmodule Homesynck.Sync.UpdateReceived do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homesynck.Sync.{Update, Controller}

  schema "updates_received" do
    belongs_to :update, Update
    belongs_to :receiver, Controller

    timestamps()
  end

  @doc false
  def changeset(update_received, attrs) do
    update_received
    |> cast(attrs, [])
    |> validate_required([])
  end
end
