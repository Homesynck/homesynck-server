defmodule Homesynck.Sync.Update do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homesynck.Sync.Directory

  schema "updates" do
    belongs_to :directory, Directory, foreign_key: :directory_id

    field :instructions, :string
    field :rank, :integer

    timestamps()
  end

  @doc false
  def changeset(update, attrs) do
    update
    |> cast(attrs, [:rank, :instructions, :directory_id])
    |> validate_required([:rank, :instructions, :directory_id])
    |> unique_constraint([:rank, :directory_id])
  end
end
