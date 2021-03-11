defmodule Homesynck.Sync.Update do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homesynck.Sync.{Controller, UpdateReceived}

  schema "updates" do
    belongs_to :emitter, Controller
    many_to_many :receivers, Controller, join_through: UpdateReceived

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
