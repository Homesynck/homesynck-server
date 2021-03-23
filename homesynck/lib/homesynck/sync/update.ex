defmodule Homesynck.Sync.Update do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homesynck.Auth.User

  schema "updates" do
    belongs_to :emitter, User

    field :instructions, :string
    field :rank, :integer

    timestamps()
  end

  @doc false
  def changeset(update, attrs) do
    update
    |> cast(attrs, [:rank, :instructions])
    |> put_assoc(:emitter, Map.get(attrs, :emitter))
    |> IO.inspect
    |> validate_required([:rank, :instructions, :emitter])
  end
end
