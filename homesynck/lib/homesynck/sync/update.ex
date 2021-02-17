defmodule Homesynck.Sync.Update do
  use Ecto.Schema
  import Ecto.Changeset

  schema "updates" do
    has_one :emitter, Homesynck.Sync.Controller
    field :instructions, :string
    field :rank, :integer

    timestamps()
  end

  @doc false
  def changeset(update, attrs) do
    update
    |> cast(attrs, [:rank, :instructions])
    |> validate_required([:rank, :instructions])
  end
end
